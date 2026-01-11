import os
import json
import csv
import io
import pandas as pd
from datetime import datetime
from functools import wraps
from flask import current_app, request, abort
from models import db, AuditLog
from models import DataVersion
from datetime import datetime, timezone
import json
# utils.py
from models import db, School, Review

def create_version(table_name, record_id, action, data_before, data_after, user_id):
    """Создание записи о версии данных"""
    from models import SchoolVersion, db  # Импортируем SchoolVersion, а не DataVersion
    from datetime import datetime, timezone
    import json
    
    print(f"DEBUG: create_version вызвана для {table_name} {record_id}, действие: {action}")
    
    if data_before:
        data_before_json = json.dumps(data_before, ensure_ascii=False, default=str)
    else:
        data_before_json = None
        
    if data_after:
        data_after_json = json.dumps(data_after, ensure_ascii=False, default=str)
    else:
        data_after_json = None
    
    # Используем SchoolVersion вместо DataVersion
    version = SchoolVersion(
        pk_school=record_id,  # или другое поле в зависимости от таблицы
        version_number=1,  # нужно реализовать подсчет версий
        action=action,
        old_data=data_before_json,
        new_data=data_after_json,
        changed_by=user_id,
        changed_at=datetime.now(timezone.utc)
    )
    
    print(f"DEBUG: Создана версия: {version}")
    
    try:
        db.session.add(version)
        db.session.commit()
        print(f"DEBUG: Версия сохранена в БД")
    except Exception as e:
        print(f"ERROR: Ошибка сохранения версии: {e}")
        db.session.rollback()
    
    return version




def save_school_version_on_create(school, user_id):
    """Сохранение версии при создании школы"""
    school_data = {
        'Official_Name': school.Official_Name,
        'Legal_Adress': school.Legal_Adress,
        'Phone': school.Phone,
        'Email': school.Email,
        'Website': school.Website,
        'Founding_Date': school.Founding_Date.isoformat() if school.Founding_Date else None,
        'Number_of_Students': school.Number_of_Students,
        'License': school.License,
        'Accreditation': school.Accreditation,
        'PK_Type_of_School': school.PK_Type_of_School,
        'PK_Settlement': school.PK_Settlement,
        'is_active': school.is_active
    }
    
    create_version('School', school.PK_School, 'create', None, school_data, user_id)


def save_school_version_on_update(school, old_values, user_id):
    """Сохранение версии при обновлении школы"""
    # Получаем полные данные школы ДО изменения
    school_data_before = {
        'Official_Name': old_values.get('Official_Name', '') if old_values else school.Official_Name,
        'Legal_Adress': old_values.get('Legal_Adress', '') if old_values else school.Legal_Adress,
        'Phone': old_values.get('Phone', '') if old_values else school.Phone,
        'Email': old_values.get('Email', '') if old_values else school.Email,
        'Website': old_values.get('Website', '') if old_values else school.Website,
        'Founding_Date': old_values.get('Founding_Date', '') if old_values else (school.Founding_Date.isoformat() if school.Founding_Date else None),
        'Number_of_Students': old_values.get('Number_of_Students', '') if old_values else school.Number_of_Students,
        'License': old_values.get('License', '') if old_values else school.License,
        'Accreditation': old_values.get('Accreditation', '') if old_values else school.Accreditation,
        'PK_Type_of_School': old_values.get('PK_Type_of_School', '') if old_values else school.PK_Type_of_School,
        'PK_Settlement': old_values.get('PK_Settlement', '') if old_values else school.PK_Settlement,
        'is_active': old_values.get('is_active', True) if old_values else school.is_active
    }
    
    # Полные данные школы ПОСЛЕ изменения
    school_data_after = {
        'Official_Name': school.Official_Name,
        'Legal_Adress': school.Legal_Adress,
        'Phone': school.Phone,
        'Email': school.Email,
        'Website': school.Website,
        'Founding_Date': school.Founding_Date.isoformat() if school.Founding_Date else None,
        'Number_of_Students': school.Number_of_Students,
        'License': school.License,
        'Accreditation': school.Accreditation,
        'PK_Type_of_School': school.PK_Type_of_School,
        'PK_Settlement': school.PK_Settlement,
        'is_active': school.is_active
    }
    
    create_version('School', school.PK_School, 'update', school_data_before, school_data_after, user_id)

def save_school_version_on_delete(school, user_id):
    """Сохранение версии при удалении школы"""
    school_data = {
        'Official_Name': school.Official_Name,
        'Legal_Adress': school.Legal_Adress,
        'Phone': school.Phone,
        'Email': school.Email,
        'Website': school.Website,
        'Founding_Date': school.Founding_Date.isoformat() if school.Founding_Date else None,
        'Number_of_Students': school.Number_of_Students,
        'License': school.License,
        'Accreditation': school.Accreditation,
        'PK_Type_of_School': school.PK_Type_of_School,
        'PK_Settlement': school.PK_Settlement,
        'is_active': school.is_active
    }
    
    create_version('School', school.PK_School, 'delete', school_data, None, user_id)



def get_versions(table_name, record_id, limit=50):
    """Получить историю изменений записи"""
    return DataVersion.query.filter_by(
        table_name=table_name,
        record_id=record_id
    ).order_by(db.desc(DataVersion.changed_at)).limit(limit).all()

def rollback_to_version(version_id):
    """Откат к конкретной версии"""
    version = DataVersion.query.get(version_id)
    if not version:
        return False, "Версия не найдена"
    
    if version.action == 'delete' and version.data_before:
        # Восстановление удаленной записи
        # Здесь нужно импортировать соответствующую модель
        # и создать объект из data_before
        pass
    elif version.action in ['create', 'update'] and version.data_before:
        # Восстановление данных из предыдущей версии
        # Здесь нужно обновить запись данными из data_before
        pass
    
    # Создаем запись об откате
    create_version(
        table_name=version.table_name,
        record_id=version.record_id,
        action='rollback',
        data_before=version.data_after,
        data_after=version.data_before,
        user_id=current_user.id
    )
    
    return True, "Откат выполнен успешно"

def get_school_versions(school_id, limit=50):
    """Получить историю изменений школы"""
    return get_versions('School', school_id, limit)

def save_school_version(school, action, user_id):
    """Сохранение версии школы"""
    school_data = {
        'Official_Name': school.Official_Name,
        'Legal_Adress': school.Legal_Adress,
        'Phone': school.Phone,
        'Email': school.Email,
        'Website': school.Website,
        'Founding_Date': school.Founding_Date.isoformat() if school.Founding_Date else None,
        'Number_of_Students': school.Number_of_Students,
        'License': school.License,
        'Accreditation': school.Accreditation,
        'PK_Type_of_School': school.PK_Type_of_School,
        'PK_Settlement': school.PK_Settlement,
        'is_active': school.is_active,
        'infrastructure': [infra.PK_Infrastructure for infra in school.infrastructure],
        'specializations': [spec.PK_Specialization for spec in school.specializations]
    }
    
    # Для update нужно получить предыдущую версию
    if action == 'update':
        last_version = DataVersion.query.filter_by(
            table_name='School',
            record_id=school.PK_School,
            action='update'
        ).order_by(db.desc(DataVersion.changed_at)).first()
        
        if last_version:
            data_before = last_version.data_after
        else:
            # Если нет предыдущей версии update, берем create версию
            create_version = DataVersion.query.filter_by(
                table_name='School',
                record_id=school.PK_School,
                action='create'
            ).first()
            data_before = create_version.data_after if create_version else school_data
    else:
        data_before = None
    
    create_version(
        table_name='School',
        record_id=school.PK_School,
        action=action,
        data_before=data_before,
        data_after=school_data,
        user_id=user_id
    )

def allowed_file(filename, allowed_extensions):
    """Проверка разрешенных расширений файлов"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in allowed_extensions

def audit_log(user_id, action, table_name, record_id, old_values=None, new_values=None):
    """Запись в журнал аудита"""
    log = AuditLog(
        user_id=user_id,  # Должен быть ID пользователя, а не None
        action=action,
        table_name=table_name,
        record_id=record_id,
        old_values=json.dumps(old_values, ensure_ascii=False) if old_values else None,
        new_values=json.dumps(new_values, ensure_ascii=False) if new_values else None,
        timestamp=datetime.now(timezone.utc)  # Добавляем явно timestamp
    )
    db.session.add(log)
    db.session.commit()

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
    """Генерация статистики для админ-панели"""
    try:
        # Импортируем здесь, чтобы избежать циклических импортов
        from models import School, Review
        
        # Безопасно считаем школы и учащихся
        total_schools = School.query.filter_by(is_active=True).count()
        
        total_students_result = db.session.query(db.func.sum(School.Number_of_Students)).scalar()
        total_students = total_students_result or 0
        
        # Простой подсчет отзывов - не используем колонки, которых может не быть
        try:
            total_reviews = Review.query.count()
        except Exception:
            total_reviews = 0
        
        try:
            # Используем SQL, чтобы избежать проблем с несуществующими колонками
            from sqlalchemy import text
            result = db.session.execute(text("SELECT COUNT(*) FROM \"Review\""))
            total_reviews = result.scalar() or 0
        except Exception:
            total_reviews = 0
            
        # Для отзывов на модерации будем осторожнее
        pending_reviews = 0
        
        stats = {
            'total_schools': total_schools,
            'total_students': total_students,
            'total_reviews': total_reviews,
            'pending_reviews': pending_reviews
        }
        return stats
    except Exception as e:
        print(f"Ошибка при генерации статистики: {e}")
        return {
            'total_schools': 0,
            'total_students': 0,
            'total_reviews': 0,
            'pending_reviews': 0
        }

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