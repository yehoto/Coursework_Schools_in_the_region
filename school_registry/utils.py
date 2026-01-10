import os
import json
import csv
import io
import pandas as pd
from datetime import datetime
from functools import wraps
from flask import current_app, request, abort
from models import db, AuditLog

def allowed_file(filename, allowed_extensions):
    """Проверка разрешенных расширений файлов"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in allowed_extensions

def audit_log(user_id, action, table_name, record_id, old_values=None, new_values=None):
    """Логирование действий в системе"""
    try:
        log = AuditLog(
            user_id=user_id,
            action=action,
            table_name=table_name,
            record_id=str(record_id),
            old_values=json.dumps(old_values, ensure_ascii=False) if old_values else None,
            new_values=json.dumps(new_values, ensure_ascii=False) if new_values else None,
            ip_address=request.remote_addr,
            user_agent=request.user_agent.string if request.user_agent else None
        )
        db.session.add(log)
        db.session.commit()
    except Exception as e:
        current_app.logger.error(f'Ошибка при логировании: {e}')
        db.session.rollback()

def role_required(role_name):
    """Декоратор для проверки ролей"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            from flask_login import current_user
            if not current_user.is_authenticated:
                abort(401)
            if not current_user.has_role(role_name):
                abort(403)
            return f(*args, **kwargs)
        return decorated_function
    return decorator

def export_to_csv(data, filename=None):
    """Экспорт данных в CSV"""
    if not data:
        return None
    
    headers = list(data[0].keys())
    output = io.StringIO()
    writer = csv.DictWriter(output, fieldnames=headers)
    writer.writeheader()
    writer.writerows(data)
    output.seek(0)
    
    if not filename:
        filename = f'export_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'
    
    return output, filename

def export_to_excel(data, filename=None):
    """Экспорт данных в Excel"""
    if not data:
        return None
    
    df = pd.DataFrame(data)
    output = io.BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name='Данные')
    output.seek(0)
    
    if not filename:
        filename = f'export_{datetime.now().strftime("%Y%m%d_%H%M%S")}.xlsx'
    
    return output, filename

def import_from_csv(file_stream):
    """Импорт данных из CSV"""
    try:
        if hasattr(file_stream, 'read'):
            content = file_stream.read().decode('utf-8-sig')
        else:
            content = file_stream
        
        csv_file = io.StringIO(content)
        sample = csv_file.read(1024)
        csv_file.seek(0)
        delimiter = ',' if ',' in sample else ';'
        
        reader = csv.DictReader(csv_file, delimiter=delimiter)
        data = [row for row in reader]
        return data, None
    except Exception as e:
        return None, str(e)

def import_from_excel(file_stream):
    """Импорт данных из Excel"""
    try:
        df = pd.read_excel(file_stream)
        data = df.to_dict('records')
        return data, None
    except Exception as e:
        return None, str(e)

def validate_school_data(data):
    """Валидация данных школы"""
    errors = []
    required_fields = ['Official_Name', 'Legal_Adress', 'Phone']
    
    for field in required_fields:
        if not data.get(field):
            errors.append(f'Поле "{field}" обязательно для заполнения')
    
    if data.get('Email') and '@' not in data['Email']:
        errors.append('Неверный формат email')
    
    if data.get('Phone') and len(data['Phone']) > 20:
        errors.append('Телефон слишком длинный')
    
    if data.get('Number_of_Students'):
        try:
            students = int(data['Number_of_Students'])
            if students < 0:
                errors.append('Количество учащихся не может быть отрицательным')
        except ValueError:
            errors.append('Количество учащихся должно быть числом')
    
    return errors

def generate_report_stats():
    """Генерация статистики для отчетов"""
    from models import School, Review, Employee, District, TypeOfSchool, Settlement
    
    stats = {
        'total_schools': School.query.filter_by(is_active=True).count(),
        'total_students': db.session.query(db.func.sum(School.Number_of_Students)).filter(School.is_active == True).scalar() or 0,
        'total_employees': Employee.query.count(),
        'total_reviews': Review.query.filter_by(is_approved=True).count(),
        'avg_rating': db.session.query(db.func.avg(Review.Rating)).filter(Review.is_approved == True).scalar() or 0,
        'schools_by_type': {},
        'schools_by_district': {}
    }
    
    for school_type in TypeOfSchool.query.all():
        count = School.query.filter_by(
            PK_Type_of_School=school_type.PK_Type_of_School,
            is_active=True
        ).count()
        stats['schools_by_type'][school_type.Name] = count
    
    for district in District.query.all():
        count = School.query.join(Settlement).filter(
            Settlement.PK_District == district.PK_District,
            School.is_active == True
        ).count()
        stats['schools_by_district'][district.Name] = count
    
    return stats

def create_backup():
    """Создание резервной копии базы данных"""
    try:
        backup_dir = os.path.join(current_app.config['UPLOAD_FOLDER'], 'backups')
        if not os.path.exists(backup_dir):
            os.makedirs(backup_dir)
        
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_file = os.path.join(backup_dir, f'db_backup_{timestamp}.sql')
        
        # Для PostgreSQL используем pg_dump
        import subprocess
        db_url = current_app.config['SQLALCHEMY_DATABASE_URI']
        
        # Извлекаем данные из URL
        from urllib.parse import urlparse
        parsed = urlparse(db_url)
        dbname = parsed.path[1:]
        user = parsed.username
        password = parsed.password
        host = parsed.hostname
        port = parsed.port or 5432
        
        # Команда pg_dump
        env = os.environ.copy()
        env['PGPASSWORD'] = password
        
        cmd = [
            'pg_dump',
            '-h', host,
            '-p', str(port),
            '-U', user,
            '-d', dbname,
            '-f', backup_file
        ]
        
        result = subprocess.run(cmd, env=env, capture_output=True, text=True)
        
        if result.returncode == 0:
            return backup_file
        else:
            current_app.logger.error(f'Ошибка при создании резервной копии: {result.stderr}')
            return None
            
    except Exception as e:
        current_app.logger.error(f'Ошибка при создании резервной копии: {e}')
        return None

def render_star_rating(rating):
    """Генерация HTML для звездного рейтинга"""
    full_stars = int(rating)
    half_star = rating - full_stars >= 0.5
    empty_stars = 5 - full_stars - (1 if half_star else 0)
    
    stars_html = ''
    stars_html += '<i class="bi bi-star-fill text-warning"></i>' * full_stars
    if half_star:
        stars_html += '<i class="bi bi-star-half text-warning"></i>'
    stars_html += '<i class="bi bi-star text-warning"></i>' * empty_stars
    
    return stars_html

def pluralize(number, singular, plural1, plural2=None):
    """Функция для склонения существительных"""
    if plural2 is None:
        plural2 = plural1
    
    if number % 10 == 1 and number % 100 != 11:
        return singular
    elif 2 <= number % 10 <= 4 and (number % 100 < 10 or number % 100 >= 20):
        return plural1
    else:
        return plural2