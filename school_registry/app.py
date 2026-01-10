import os
import csv
import json
from datetime import datetime, timezone
from functools import wraps
from flask import (
    Flask, render_template, request, jsonify,
    redirect, url_for, flash, send_file, abort,
    make_response, session, send_from_directory
)
from flask_login import (
    LoginManager, login_user, logout_user,
    login_required, current_user
)
from flask_migrate import Migrate
from config import config
from models import db, User, School, District, Settlement, TypeOfSchool, Infrastructure
from models import Specialization, Employee, Subject, EducationProgram, Review, Inspection
from models import AuditLog, ImportHistory
from forms import (
    LoginForm, RegistrationForm, SchoolForm,
    ReviewForm, ImportForm, EmployeeForm,
    ProgramForm, UserProfileForm
)
from utils import (
    allowed_file, audit_log, role_required,
    export_to_csv, export_to_excel, import_from_csv, import_from_excel,
    validate_school_data, generate_report_stats, create_backup,
    render_star_rating, pluralize
)

# Инициализация приложения
app = Flask(__name__)

# Загрузка конфигурации
app.config.from_object(config['development'])
config['development'].init_app(app)

# Инициализация расширений
db.init_app(app)
migrate = Migrate(app, db)

login_manager = LoginManager(app)
login_manager.login_view = 'login'
login_manager.login_message = 'Пожалуйста, войдите для доступа к этой странице.'
login_manager.login_message_category = 'warning'

@login_manager.user_loader
def load_user(user_id):
    return db.session.get(User, int(user_id))

# Контекстные процессоры
# Контекстные процессоры
# Контекстные процессоры
@app.context_processor
def inject_globals():
    from config import Config
    
    def user_has_role(role_name):
        """Безопасная проверка роли пользователя в шаблонах"""
        if not current_user.is_authenticated:
            return False
        required_role = Config.ROLES.get(role_name, 0)
        return current_user.role >= required_role
    
    def user_role_name():
        """Безопасное получение имени роли в шаблонах"""
        if not current_user.is_authenticated:
            return 'Гость'
        roles = {
            0: 'Гость',
            1: 'Родитель',
            2: 'Учитель',
            3: 'Администратор школы',
            4: 'Администратор региона',
            5: 'Супер-администратор'
        }
        return roles.get(current_user.role, 'Неизвестно')
    
    def get_filter_display_name(key, value):
        """Получить читаемое имя для фильтра"""
        if key == 'district_id':
            district = District.query.get(value)
            return f"Район: {district.Name}" if district else value
        elif key == 'settlement_id':
            settlement = Settlement.query.get(value)
            return f"Нас. пункт: {settlement.Name}" if settlement else value
        elif key == 'school_type_id':
            school_type = TypeOfSchool.query.get(value)
            return f"Тип: {school_type.Name}" if school_type else value
        elif key == 'specialization_id':
            spec = Specialization.query.get(value)
            return f"Специализация: {spec.Name}" if spec else value
        elif key == 'has_library':
            return "Библиотека"
        elif key == 'has_gym':
            return "Спортзал"
        elif key == 'has_lab':
            return "Лаборатория"
        elif key == 'has_accessible':
            return "Доступная среда"
        elif key == 'program_type':
            return "Программа: " + ("Дополнительная" if value == "дополнительная" else "Основная")
        elif key == 'min_students':
            return f"Учащихся от: {value}"
        elif key == 'max_students':
            return f"Учащихся до: {value}"
        elif key == 'min_year':
            return f"Год от: {value}"
        elif key == 'max_year':
            return f"Год до: {value}"
        return f"{key}: {value}"
    
    def get_active_filters():
        """Получить список активных фильтров для отображения"""
        filters = []
        for key, value in request.args.items():
            if key not in ['page', 'sort_by', 'order', 'q'] and value:
                if isinstance(value, list):
                    for v in value:
                        filters.append((key, get_filter_display_name(key, v)))
                else:
                    filters.append((key, get_filter_display_name(key, value)))
        return filters
    
    def has_active_filters():
        """Проверить, есть ли активные фильтры"""
        for key in request.args:
            if key not in ['page', 'sort_by', 'order', 'q'] and request.args[key]:
                return True
        return False
    
    def remove_filter_url(filter_key):
        """Создать URL без указанного фильтра"""
        args = dict(request.args)
        if 'page' in args:
            del args['page']
        if filter_key in args:
            del args[filter_key]
        return url_for('index', **args)
    
    return {
        'roles': Config.ROLES,
        'current_user': current_user,
        'now': datetime.now(),
        'render_star_rating': render_star_rating,
        'pluralize': pluralize,
        'user_has_role': user_has_role,
        'user_role_name': user_role_name,
        'get_filter_display_name': get_filter_display_name,
        'get_active_filters': get_active_filters,
        'has_active_filters': has_active_filters(),
        'active_filters': get_active_filters(),
        'remove_filter_url': remove_filter_url
    }
# Обработка ошибок
@app.errorhandler(404)
def not_found_error(error):
    return render_template('errors/404.html'), 404

@app.errorhandler(403)
def forbidden_error(error):
    return render_template('errors/403.html'), 403

@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return render_template('errors/500.html'), 500

# Статические файлы
@app.route('/static/<path:filename>')
def static_files(filename):
    return send_from_directory('static', filename)

# Главная страница
# Главная страница
# Главная страница
@app.route('/')
def index():
    page = request.args.get('page', 1, type=int)
    per_page = app.config['SCHOOLS_PER_PAGE']
    
    # Фильтрация
    query = School.query.filter_by(is_active=True)
    
    # Применение фильтров
    district_id = request.args.get('district_id')
    settlement_id = request.args.get('settlement_id')
    school_type_id = request.args.get('school_type_id')
    specialization_id = request.args.get('specialization_id')
    min_students = request.args.get('min_students')
    max_students = request.args.get('max_students')
    min_year = request.args.get('min_year')
    max_year = request.args.get('max_year')
    program_type = request.args.get('program_type')
    
    # Инфраструктура
    has_library = request.args.get('has_library')
    has_gym = request.args.get('has_gym')
    has_lab = request.args.get('has_lab')
    has_accessible = request.args.get('has_accessible')
    has_accreditation = request.args.get('has_accreditation')
    has_license = request.args.get('has_license')
    
    if district_id:
        query = query.join(Settlement).filter(Settlement.PK_District == district_id)
    
    if settlement_id:
        query = query.filter(School.PK_Settlement == settlement_id)
    
    if school_type_id:
        query = query.filter(School.PK_Type_of_School == school_type_id)
    
    if specialization_id:
        query = query.filter(School.specializations.any(PK_Specialization=specialization_id))
    
    if min_students:
        query = query.filter(School.Number_of_Students >= min_students)
    
    if max_students:
        query = query.filter(School.Number_of_Students <= max_students)
    
    if min_year:
        query = query.filter(db.extract('year', School.Founding_Date) >= min_year)
    
    if max_year:
        query = query.filter(db.extract('year', School.Founding_Date) <= max_year)
    
    # Фильтры по инфраструктуре
    if has_library:
        library = Infrastructure.query.filter_by(Name='Библиотека').first()
        if library:
            query = query.filter(School.infrastructure.any(PK_Infrastructure=library.PK_Infrastructure))
    
    if has_gym:
        gym = Infrastructure.query.filter_by(Name='Спортзал').first()
        if gym:
            query = query.filter(School.infrastructure.any(PK_Infrastructure=gym.PK_Infrastructure))
    
    if has_lab:
        lab = Infrastructure.query.filter_by(Name='Лаборатория').first()
        if lab:
            query = query.filter(School.infrastructure.any(PK_Infrastructure=lab.PK_Infrastructure))
    
    if has_accessible:
        accessible = Infrastructure.query.filter(Infrastructure.Name.ilike('%доступн%')).first()
        if accessible:
            query = query.filter(School.infrastructure.any(PK_Infrastructure=accessible.PK_Infrastructure))
    
    # Фильтры по аккредитации и лицензии
    if has_accreditation:
        query = query.filter(School.Accreditation != None, School.Accreditation != '')
    
    if has_license:
        query = query.filter(School.License != None, School.License != '')
    
    # Фильтр по программам образования
    if program_type:
        query = query.filter(School.programs.any(Type=program_type))
    
    # Сортировка
    sort_by = request.args.get('sort_by', 'name')
    order = request.args.get('order', 'asc')
    
    if sort_by == 'students':
        if order == 'desc':
            query = query.order_by(db.desc(School.Number_of_Students))
        else:
            query = query.order_by(School.Number_of_Students)
    elif sort_by == 'rating':
        # Создаем подзапрос для рейтинга с количеством отзывов
        subquery = db.session.query(
            Review.PK_School,
            db.func.coalesce(db.func.avg(Review.Rating), 0).label('avg_rating'),
            db.func.count(Review.PK_Review).label('review_count')
        ).filter(
            Review.is_approved == True
        ).group_by(
            Review.PK_School
        ).subquery()
        
        # Делаем LEFT JOIN с подзапросом
        query = query.outerjoin(subquery, School.PK_School == subquery.c.PK_School)
        
        # Для сортировки используем CASE, чтобы школы без отзывов имели рейтинг 0
        # и шли в конце при сортировке по убыванию
        if order == 'desc':
            # Сначала школы с рейтингом от 5 до 1, затем с рейтингом 0 (без отзывов)
            query = query.order_by(
                db.desc(db.case(
                    (subquery.c.review_count > 0, subquery.c.avg_rating),
                    else_=0
                ))
            )
        else:
            # Сначала школы с рейтингом от 0 до 5
            query = query.order_by(
                db.case(
                    (subquery.c.review_count > 0, subquery.c.avg_rating),
                    else_=0
                ).asc()
            )
    else:  # Сортировка по названию по умолчанию
        if order == 'desc':
            query = query.order_by(db.desc(School.Official_Name))
        else:
            query = query.order_by(School.Official_Name)
    
    # Пагинация
    try:
        schools = query.paginate(page=page, per_page=per_page, error_out=False)
    except:
        schools = query.paginate(page=1, per_page=per_page, error_out=False)
    
    # Данные для фильтров
    districts = District.query.order_by(District.Name).all()
    settlements = Settlement.query.order_by(Settlement.Name).all()
    school_types = TypeOfSchool.query.order_by(TypeOfSchool.Name).all()
    specializations = Specialization.query.order_by(Specialization.Name).all()
    infrastructure_items = Infrastructure.query.order_by(Infrastructure.Name).all()
    
    return render_template('index.html',
        schools=schools,
        districts=districts,
        settlements=settlements,
        school_types=school_types,
        specializations=specializations,
        infrastructure_items=infrastructure_items
    )

# API для получения населенных пунктов по району
@app.route('/api/districts/<int:district_id>/settlements')
def get_settlements_by_district(district_id):
    settlements = Settlement.query.filter_by(PK_District=district_id).all()
    return jsonify([{
        'id': s.PK_Settlement,
        'name': s.Name,
        'type': s.Type
    } for s in settlements])

# Поиск школ
@app.route('/search')
def search_schools():
    query = request.args.get('q', '').strip()
    page = request.args.get('page', 1, type=int)
    
    if not query:
        return redirect(url_for('index'))
    
    search_results = School.query.filter(
        db.or_(
            School.Official_Name.ilike(f'%{query}%'),
            School.Legal_Adress.ilike(f'%{query}%'),
            School.Phone.ilike(f'%{query}%')
        )
    ).filter_by(is_active=True).paginate(page=page, per_page=20)
    
    return render_template('search_results.html',
        schools=search_results,
        query=query)

# Детальная информация о школе
@app.route('/school/<int:school_id>')
def school_detail(school_id):
    school = School.query.get_or_404(school_id)
    
    if not school.is_active and not current_user.has_role('school_admin'):
        abort(404)
    
    # Статистика отзывов
    reviews = Review.query.filter_by(
        PK_School=school_id,
        is_approved=True
    ).order_by(db.desc(Review.Date)).limit(10).all()
    
    avg_rating = school.get_avg_rating()
    review_count = school.get_review_count()
    
    # Инспекции
    inspections = Inspection.query.filter_by(
        PK_School=school_id
    ).order_by(db.desc(Inspection.Date)).limit(5).all()
    
    # Сотрудники
    employees = school.employees[:10] if school.employees else []
    
    # Программы
    programs = school.programs[:10] if school.programs else []
    
    form = ReviewForm()
    
    return render_template('schools/detail.html',
        school=school,
        reviews=reviews,
        avg_rating=avg_rating,
        review_count=review_count,
        inspections=inspections,
        employees=employees,
        programs=programs,
        form=form)

# API для школы
@app.route('/api/school/<int:school_id>')
def api_school(school_id):
    school = School.query.get_or_404(school_id)
    
    if not school.is_active and not current_user.has_role('school_admin'):
        abort(404)
    
    data = {
        'id': school.PK_School,
        'name': school.Official_Name,
        'address': school.Legal_Adress,
        'phone': school.Phone,
        'email': school.Email,
        'website': school.Website,
        'students': school.Number_of_Students,
        'type': school.type_of_school.Name if school.type_of_school else '',
        'settlement': {
            'name': school.settlement.Name if school.settlement else '',
            'type': school.settlement.Type if school.settlement else ''
        },
        'infrastructure': [i.Name for i in school.infrastructure],
        'specializations': [s.Name for s in school.specializations],
        'rating': school.get_avg_rating(),
        'review_count': school.get_review_count()
    }
    
    return jsonify(data)

# Отчеты (запросы из ТЗ)
# 1. Школы в Бийске типа "гимназия"
@app.route('/report/gymnasiums_bijsk')
@login_required
def report_gymnasiums_bijsk():
    bijsk = Settlement.query.filter(
        Settlement.Name.ilike('%бийск%'),
        Settlement.Type.ilike('%город%')
    ).first()
    
    if not bijsk:
        flash('Населенный пункт Бийск не найден', 'warning')
        return redirect(url_for('index'))
    
    gymnasium_type = TypeOfSchool.query.filter(
        TypeOfSchool.Name.ilike('%гимназия%')
    ).first()
    
    if not gymnasium_type:
        flash('Тип школы "гимназия" не найден', 'warning')
        return redirect(url_for('index'))
    
    schools = School.query.filter_by(
        PK_Settlement=bijsk.PK_Settlement,
        PK_Type_of_School=gymnasium_type.PK_Type_of_School,
        is_active=True
    ).order_by(School.Official_Name).all()
    
    return render_template('reports/gymnasiums_bijsk.html',
        schools=schools,
        settlement=bijsk,
        school_type=gymnasium_type)

# 2. Школы с библиотекой
@app.route('/report/schools_with_library')
@login_required
def report_schools_with_library():
    library = Infrastructure.query.filter(
        Infrastructure.Name.ilike('%библиотека%')
    ).first()
    
    if not library:
        flash('Инфраструктура "Библиотека" не найдена', 'warning')
        return redirect(url_for('index'))
    
    schools = School.query.filter(
        School.infrastructure.any(PK_Infrastructure=library.PK_Infrastructure),
        School.is_active == True
    ).order_by(School.Official_Name).all()
    
    return render_template('reports/schools_with_library.html',
        schools=schools,
        infrastructure=library)

# 3. Школы с углубленным изучением физики
@app.route('/report/schools_physics')
@login_required
def report_schools_physics():
    physics_spec = Specialization.query.filter(
        Specialization.Name.ilike('%физик%')
    ).first()
    
    schools = []
    if physics_spec:
        schools = School.query.filter(
            School.specializations.any(PK_Specialization=physics_spec.PK_Specialization),
            School.is_active == True
        ).order_by(School.Official_Name).all()
    
    if not schools:
        physics_subject = Subject.query.filter(
            Subject.Name.ilike('%физик%')
        ).first()
        
        if physics_subject:
            schools = School.query.join(
                school_employee
            ).join(
                Employee
            ).join(
                employee_subject_competence
            ).filter(
                employee_subject_competence.c.PK_Subject == physics_subject.PK_Subject,
                School.is_active == True
            ).distinct().order_by(School.Official_Name).all()
    
    return render_template('reports/schools_physics.html',
        schools=schools)

# 4. Школы-интернаты с >200 учащихся
@app.route('/report/boarding_schools')
@login_required
def report_boarding_schools():
    boarding_type = TypeOfSchool.query.filter(
        TypeOfSchool.Name.ilike('%интернат%')
    ).first()
    
    if not boarding_type:
        flash('Тип школы "интернат" не найден', 'warning')
        return redirect(url_for('index'))
    
    schools = School.query.filter(
        School.PK_Type_of_School == boarding_type.PK_Type_of_School,
        School.Number_of_Students > 200,
        School.is_active == True
    ).order_by(db.desc(School.Number_of_Students)).all()
    
    return render_template('reports/boarding_schools.html',
        schools=schools,
        school_type=boarding_type)

# 5. Кадровый состав школы
@app.route('/report/school_staff/<int:school_id>')
@login_required
def report_school_staff(school_id):
    school = School.query.get_or_404(school_id)
    employees = school.employees
    
    return render_template('reports/school_staff.html',
        school=school,
        employees=employees)

# 6. Программы школы
@app.route('/report/school_programs/<int:school_id>')
@login_required
def report_school_programs(school_id):
    school = School.query.get_or_404(school_id)
    programs = school.programs
    
    return render_template('reports/school_programs.html',
        school=school,
        programs=programs)

# Аутентификация
@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        
        if user and user.check_password(form.password.data):
            if not user.is_active:
                flash('Аккаунт деактивирован', 'danger')
                return redirect(url_for('login'))
            
            login_user(user, remember=form.remember_me.data)
            user.last_login = datetime.now(timezone.utc)
            db.session.commit()
            
            flash(f'Добро пожаловать, {user.username}!', 'success')
            
            next_page = request.args.get('next')
            return redirect(next_page or url_for('index'))
        
        flash('Неверное имя пользователя или пароль', 'danger')
    
    return render_template('auth/login.html', form=form)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    
    form = RegistrationForm()
    if form.validate_on_submit():
        user = User(
            username=form.username.data,
            email=form.email.data,
            role=1  # Родитель по умолчанию
        )
        user.set_password(form.password.data)
        
        db.session.add(user)
        db.session.commit()
        
        flash('Регистрация успешна! Теперь вы можете войти.', 'success')
        return redirect(url_for('login'))
    
    return render_template('auth/register.html', form=form)

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Вы вышли из системы', 'info')
    return redirect(url_for('index'))

# Заглушка для госуслуг
@app.route('/auth/gosuslugi')
def auth_gosuslugi():
    flash('Интеграция с госуслугами находится в разработке', 'info')
    return redirect(url_for('login'))

@app.route('/auth/gosuslugi/callback')
def gosuslugi_callback():
    flash('Callback от госуслуг получен', 'info')
    return redirect(url_for('index'))

# Профиль пользователя
@app.route('/profile')
@login_required
def profile():
    form = UserProfileForm(
        username=current_user.username,
        email=current_user.email
    )
    
    user_reviews = Review.query.filter_by(user_id=current_user.id).count()
    
    return render_template('auth/profile.html',
        form=form,
        user_reviews=user_reviews)

@app.route('/profile/update', methods=['POST'])
@login_required
def update_profile():
    form = UserProfileForm()
    
    if form.validate_on_submit():
        if form.new_password.data:
            if not current_user.check_password(form.current_password.data):
                flash('Текущий пароль неверен', 'danger')
                return redirect(url_for('profile'))
            
            current_user.set_password(form.new_password.data)
            flash('Пароль успешно изменен', 'success')
        
        if current_user.username != form.username.data:
            current_user.username = form.username.data
        
        if current_user.email != form.email.data:
            current_user.email = form.email.data
        
        db.session.commit()
        flash('Профиль успешно обновлен', 'success')
    else:
        for field, errors in form.errors.items():
            for error in errors:
                flash(f'{getattr(form, field).label.text}: {error}', 'danger')
    
    return redirect(url_for('profile'))

# Административная часть
@app.route('/admin')
@login_required
@role_required('school_admin')
def admin_dashboard():
    stats = generate_report_stats()
    
    recent_audits = AuditLog.query.order_by(
        db.desc(AuditLog.timestamp)
    ).limit(10).all()
    
    pending_reviews = Review.query.filter_by(
        is_approved=False
    ).count()
    
    return render_template('admin/dashboard.html',
        stats=stats,
        recent_audits=recent_audits,
        pending_reviews=pending_reviews)

# Управление школами
@app.route('/admin/schools')
@login_required
@role_required('school_admin')
def admin_schools():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    status = request.args.get('status', '')
    search = request.args.get('search', '')
    
    # Базовый запрос
    query = School.query
    
    # Фильтр по статусу
    if status == 'active':
        query = query.filter_by(is_active=True)
    elif status == 'inactive':
        query = query.filter_by(is_active=False)
    
    # Поиск
    if search:
        query = query.filter(
            db.or_(
                School.Official_Name.ilike(f'%{search}%'),
                School.Legal_Adress.ilike(f'%{search}%'),
                School.Phone.ilike(f'%{search}%')
            )
        )
    
    # Сортировка по дате создания (новые сверху)
    query = query.order_by(db.desc(School.created_at))
    
    # Пагинация
    schools = query.paginate(page=page, per_page=per_page, error_out=False)
    
    # Статистика
    active_count = School.query.filter_by(is_active=True).count()
    inactive_count = School.query.filter_by(is_active=False).count()
    
    return render_template('admin/schools.html',
                         schools=schools,
                         active_count=active_count,
                         inactive_count=inactive_count)

@app.route('/admin/school/add', methods=['GET', 'POST'])
@login_required
@role_required('region_admin')
def add_school():
    form = SchoolForm()
    
    form.type_of_school.choices = [(t.PK_Type_of_School, t.Name) 
                                   for t in TypeOfSchool.query.order_by(TypeOfSchool.Name).all()]
    form.settlement.choices = [(s.PK_Settlement, f'{s.Type} {s.Name}') 
                               for s in Settlement.query.order_by(Settlement.Name).all()]
    form.infrastructure.choices = [(i.PK_Infrastructure, i.Name) 
                                   for i in Infrastructure.query.order_by(Infrastructure.Name).all()]
    form.specializations.choices = [(s.PK_Specialization, s.Name) 
                                    for s in Specialization.query.order_by(Specialization.Name).all()]
    
    if form.validate_on_submit():
        school = School(
            Official_Name=form.official_name.data,
            Legal_Adress=form.legal_address.data,
            Phone=form.phone.data,
            Email=form.email.data,
            Website=form.website.data,
            Founding_Date=form.founding_date.data,
            Number_of_Students=form.number_of_students.data,
            License=form.license.data,
            Accreditation=form.accreditation.data,
            PK_Type_of_School=form.type_of_school.data,
            PK_Settlement=form.settlement.data,
            created_by=current_user.id
        )
        
        for infra_id in form.infrastructure.data:
            infra = Infrastructure.query.get(infra_id)
            if infra:
                school.infrastructure.append(infra)
        
        for spec_id in form.specializations.data:
            spec = Specialization.query.get(spec_id)
            if spec:
                school.specializations.append(spec)
        
        db.session.add(school)
        db.session.commit()
        
        audit_log(current_user.id, 'create', 'School', school.PK_School,
                  new_values=school.Official_Name)
        
        flash('Школа успешно добавлена', 'success')
        return redirect(url_for('index'))
    
    return render_template('admin/add_school.html', form=form)

@app.route('/admin/school/<int:school_id>/edit', methods=['GET', 'POST'])
@login_required
@role_required('region_admin')
def edit_school(school_id):
    school = School.query.get_or_404(school_id)
    
    # Создаем форму и передаем объект школы для автозаполнения
    form = SchoolForm(obj=school)
    
    # Заполняем choices для выпадающих списков
    form.type_of_school.choices = [(t.PK_Type_of_School, t.Name) 
                                   for t in TypeOfSchool.query.order_by(TypeOfSchool.Name).all()]
    form.settlement.choices = [(s.PK_Settlement, f'{s.Type} {s.Name}') 
                               for s in Settlement.query.order_by(Settlement.Name).all()]
    form.infrastructure.choices = [(i.PK_Infrastructure, i.Name) 
                                   for i in Infrastructure.query.order_by(Infrastructure.Name).all()]
    form.specializations.choices = [(s.PK_Specialization, s.Name) 
                                    for s in Specialization.query.order_by(Specialization.Name).all()]
    
    # ВРУЧНУЮ заполняем поля, которые не совпадают с именами в форме
    # Это нужно сделать перед form.validate_on_submit()
    if request.method == 'GET':
        form.official_name.data = school.Official_Name
        form.legal_address.data = school.Legal_Adress  # Legal_Adress -> legal_address
        form.phone.data = school.Phone
        form.email.data = school.Email
        form.website.data = school.Website
        form.founding_date.data = school.Founding_Date
        form.number_of_students.data = school.Number_of_Students
        form.license.data = school.License  # License -> license
        form.accreditation.data = school.Accreditation  # Accreditation -> accreditation
        form.type_of_school.data = school.PK_Type_of_School
        form.settlement.data = school.PK_Settlement
        form.infrastructure.data = [i.PK_Infrastructure for i in school.infrastructure]
        form.specializations.data = [s.PK_Specialization for s in school.specializations]
    
    if form.validate_on_submit():
        old_values = {
            'Official_Name': school.Official_Name,
            'Legal_Adress': school.Legal_Adress,
            'Phone': school.Phone
        }
        
        # Обновляем данные школы из формы
        school.Official_Name = form.official_name.data
        school.Legal_Adress = form.legal_address.data
        school.Phone = form.phone.data
        school.Email = form.email.data
        school.Website = form.website.data
        school.Founding_Date = form.founding_date.data
        school.Number_of_Students = form.number_of_students.data
        school.License = form.license.data
        school.Accreditation = form.accreditation.data
        school.PK_Type_of_School = form.type_of_school.data
        school.PK_Settlement = form.settlement.data
        
        # Обновляем инфраструктуру
        school.infrastructure = []
        for infra_id in form.infrastructure.data:
            infra = Infrastructure.query.get(infra_id)
            if infra:
                school.infrastructure.append(infra)
        
        # Обновляем специализации
        school.specializations = []
        for spec_id in form.specializations.data:
            spec = Specialization.query.get(spec_id)
            if spec:
                school.specializations.append(spec)
        
        db.session.commit()
        
        audit_log(current_user.id, 'update', 'School', school.PK_School,
                  old_values=old_values,
                  new_values={'Official_Name': school.Official_Name})
        
        flash('Школа успешно обновлена', 'success')
        return redirect(url_for('index'))
    
    return render_template('admin/edit_school.html', form=form, school=school)

@app.route('/admin/school/<int:school_id>/delete', methods=['POST'])
@login_required
@role_required('super_admin')
def delete_school(school_id):
    school = School.query.get_or_404(school_id)
    
    school.is_active = False
    db.session.commit()
    
    audit_log(current_user.id, 'delete', 'School', school.PK_School,
              old_values={'Official_Name': school.Official_Name})
    
    flash('Школа деактивирована', 'success')
    return redirect(url_for('admin_schools'))

# Импорт данных
@app.route('/admin/import', methods=['GET', 'POST'])
@login_required
@role_required('region_admin')
def import_data():
    form = ImportForm()
    
    if form.validate_on_submit():
        file_type = form.file_type.data
        
        if file_type == 'csv':
            headers = [
                'Official_Name', 'Legal_Adress', 'Phone', 'Email',
                'Website', 'Founding_Date', 'Number_of_Students',
                'Type_of_School', 'Settlement'
            ]
            
            output = io.StringIO()
            writer = csv.writer(output)
            writer.writerow(headers)
            writer.writerow([
                'Пример: Средняя школа №1',
                'г. Барнаул, ул. Ленина, 1',
                '+7 (3852) 123456',
                'school1@example.com',
                'http://school1.edu.ru',
                '1950-09-01',
                '500',
                'общеобразовательная школа',
                'г. Барнаул'
            ])
            output.seek(0)
            
            response = make_response(output.getvalue())
            response.headers['Content-Disposition'] = 'attachment; filename=school_import_template.csv'
            response.headers['Content-Type'] = 'text/csv'
            return response
            
        elif file_type == 'json':
            template = {
                "schools": [
                    {
                        "Official_Name": "Средняя школа №1",
                        "Legal_Adress": "г. Барнаул, ул. Ленина, 1",
                        "Phone": "+7 (3852) 123456",
                        "Email": "school1@example.com",
                        "Website": "http://school1.edu.ru",
                        "Founding_Date": "1950-09-01",
                        "Number_of_Students": 500,
                        "Type_of_School": "общеобразовательная школа",
                        "Settlement": "г. Барнаул"
                    }
                ]
            }
            
            response = make_response(json.dumps(template, ensure_ascii=False, indent=2))
            response.headers['Content-Disposition'] = 'attachment; filename=school_import_template.json'
            response.headers['Content-Type'] = 'application/json'
            return response
    
    return render_template('admin/import.html', form=form)

@app.route('/admin/import/upload', methods=['POST'])
@login_required
@role_required('region_admin')
def upload_import():
    if 'file' not in request.files:
        flash('Файл не выбран', 'danger')
        return redirect(url_for('import_data'))
    
    file = request.files['file']
    if file.filename == '':
        flash('Файл не выбран', 'danger')
        return redirect(url_for('import_data'))
    
    file_extension = file.filename.rsplit('.', 1)[1].lower() if '.' in file.filename else ''
    
    imported_count = 0
    errors = []
    
    try:
        if file_extension == 'csv':
            data, error = import_from_csv(file)
            if error:
                flash(f'Ошибка чтения CSV: {error}', 'danger')
                return redirect(url_for('import_data'))
                
        elif file_extension in ['xlsx', 'xls']:
            data, error = import_from_excel(file)
            if error:
                flash(f'Ошибка чтения Excel: {error}', 'danger')
                return redirect(url_for('import_data'))
                
        elif file_extension == 'json':
            try:
                data = json.loads(file.read().decode('utf-8'))
                if 'schools' not in data:
                    flash('Неверный формат JSON: отсутствует ключ "schools"', 'danger')
                    return redirect(url_for('import_data'))
                data = data['schools']
            except:
                flash('Ошибка чтения JSON файла', 'danger')
                return redirect(url_for('import_data'))
        else:
            flash('Разрешены только CSV, Excel и JSON файлы', 'danger')
            return redirect(url_for('import_data'))
        
        for i, row in enumerate(data, 1):
            try:
                validation_errors = validate_school_data(row)
                if validation_errors:
                    errors.append(f'Строка {i}: {", ".join(validation_errors)}')
                    continue
                
                # Поиск типа школы
                type_name = row.get('Type_of_School', '')
                school_type = TypeOfSchool.query.filter(
                    TypeOfSchool.Name.ilike(f'%{type_name}%')
                ).first()
                
                if not school_type:
                    errors.append(f'Строка {i}: Тип школы "{type_name}" не найден')
                    continue
                
                # Поиск населенного пункта
                settlement_name = row.get('Settlement', '')
                settlement = Settlement.query.filter(
                    Settlement.Name.ilike(f'%{settlement_name}%')
                ).first()
                
                if not settlement:
                    errors.append(f'Строка {i}: Населенный пункт "{settlement_name}" не найден')
                    continue
                
                school = School(
                    Official_Name=row['Official_Name'],
                    Legal_Adress=row['Legal_Adress'],
                    Phone=row['Phone'],
                    Email=row.get('Email'),
                    Website=row.get('Website'),
                    Number_of_Students=row.get('Number_of_Students'),
                    PK_Type_of_School=school_type.PK_Type_of_School,
                    PK_Settlement=settlement.PK_Settlement,
                    created_by=current_user.id
                )
                
                if row.get('Founding_Date'):
                    try:
                        school.Founding_Date = datetime.strptime(
                            row['Founding_Date'], '%Y-%m-%d'
                        ).date()
                    except:
                        pass
                
                db.session.add(school)
                imported_count += 1
                
            except Exception as e:
                errors.append(f'Строка {i}: {str(e)}')
        
        db.session.commit()
        
        import_history = ImportHistory(
            filename=file.filename,
            file_type=file_extension,
            imported_by=current_user.id,
            record_count=imported_count,
            errors='\n'.join(errors) if errors else None
        )
        db.session.add(import_history)
        db.session.commit()
        
        if errors:
            flash(f'Импорт завершен с ошибками. Успешно: {imported_count}, ошибок: {len(errors)}', 'warning')
        else:
            flash(f'Успешно импортировано {imported_count} школ', 'success')
        
        return redirect(url_for('admin_schools'))
        
    except Exception as e:
        db.session.rollback()
        flash(f'Ошибка при импорте: {str(e)}', 'danger')
        return redirect(url_for('import_data'))

# Экспорт данных
@app.route('/export/schools')
@login_required
def export_schools():
    format_type = request.args.get('format', 'csv')
    schools = School.query.filter_by(is_active=True).all()
    
    data = []
    for school in schools:
        data.append({
            'ID': school.PK_School,
            'Название': school.Official_Name,
            'Адрес': school.Legal_Adress,
            'Телефон': school.Phone,
            'Email': school.Email or '',
            'Сайт': school.Website or '',
            'Учащихся': school.Number_of_Students or '',
            'Тип школы': school.type_of_school.Name if school.type_of_school else '',
            'Населенный пункт': f'{school.settlement.Type} {school.settlement.Name}' if school.settlement else '',
            'Район': school.settlement.district.Name if school.settlement and school.settlement.district else ''
        })
    
    if format_type == 'excel':
        output, filename = export_to_excel(data)
        response = make_response(output.getvalue())
        response.headers['Content-Disposition'] = f'attachment; filename={filename}'
        response.headers['Content-Type'] = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    else:
        output, filename = export_to_csv(data)
        response = make_response(output.getvalue().encode('utf-8'))
        response.headers['Content-Disposition'] = f'attachment; filename={filename}'
        response.headers['Content-Type'] = 'text/csv; charset=utf-8'
    
    return response

# Модуль отзывов
@app.route('/school/<int:school_id>/review/add', methods=['POST'])
@login_required
def add_review(school_id):
    school = School.query.get_or_404(school_id)
    
    if not school.is_active:
        abort(404)
    
    form = ReviewForm()
    if form.validate_on_submit():
        # Администраторы и учителя могут оставлять отзывы без модерации
        is_approved = False
        
        if current_user.has_role('school_admin') or current_user.has_role('region_admin') or current_user.has_role('super_admin'):
            is_approved = True
        
        review = Review(
            Author=current_user.username,
            Text=form.text.data,
            Rating=form.rating.data,
            Date=datetime.now(timezone.utc).date(),
            PK_School=school_id,
            user_id=current_user.id,
            is_approved=is_approved
        )
        
        db.session.add(review)
        db.session.commit()
        
        if is_approved:
            flash('Отзыв успешно добавлен', 'success')
        else:
            flash('Отзыв добавлен и будет опубликован после модерации', 'success')
        
    else:
        flash('Ошибка при добавлении отзыва', 'danger')
    
    return redirect(url_for('school_detail', school_id=school_id))

@app.route('/admin/reviews')
@login_required
@role_required('school_admin')
def admin_reviews():
    page = request.args.get('page', 1, type=int)
    status = request.args.get('status', 'pending')
    
    query = Review.query
    if status == 'pending':
        query = query.filter_by(is_approved=False)
    elif status == 'approved':
        query = query.filter_by(is_approved=True)
    
    reviews = query.order_by(db.desc(Review.Date)).paginate(page=page, per_page=20)
    
    return render_template('admin/reviews.html',
        reviews=reviews,
        status=status)

@app.route('/admin/review/<int:review_id>/moderate', methods=['POST'])
@login_required
@role_required('school_admin')
def moderate_review(review_id):
    review = Review.query.get_or_404(review_id)
    action = request.form.get('action')
    comment = request.form.get('comment', '')
    
    if action == 'approve':
        review.is_approved = True
        review.moderated_by = current_user.id
        review.moderated_at = datetime.now(timezone.utc)
        review.moderation_comment = comment
        flash('Отзыв одобрен', 'success')
    elif action == 'reject':
        review.is_approved = False
        review.moderated_by = current_user.id
        review.moderated_at = datetime.now(timezone.utc)
        review.moderation_comment = comment
        flash('Отзыв отклонен', 'info')
    
    db.session.commit()
    return redirect(url_for('admin_reviews', status='pending'))

# Резервное копирование
@app.route('/admin/backup')
@login_required
@role_required('super_admin')
def create_backup_route():
    backup_file = create_backup()
    if backup_file:
        flash(f'Резервная копия создана: {backup_file}', 'success')
    else:
        flash('Ошибка при создании резервной копии', 'danger')
    
    return redirect(url_for('admin_dashboard'))

# Новые отчеты по требованию ТЗ

@app.route('/reports')
@login_required
def reports_index():
    """Страница выбора типа отчета"""
    return render_template('reports/index.html')

@app.route('/report/students')
@login_required
@role_required('school_admin')
def report_students():
    """Статистика по количеству учащихся"""
    from models import School, District, TypeOfSchool, Settlement
    
    # Параметры фильтрации
    district_id = request.args.get('district_id')
    type_id = request.args.get('type_id')
    min_year = request.args.get('min_year', 2000, type=int)
    max_year = request.args.get('max_year', 2026, type=int)
    
    # Базовый запрос
    query = School.query.filter_by(is_active=True)
    
    if district_id:
        query = query.join(Settlement).filter(Settlement.PK_District == district_id)
    
    if type_id:
        query = query.filter(School.PK_Type_of_School == type_id)
    
    schools = query.all()
    
    # Общая статистика
    total_schools = len(schools)
    total_students = sum(s.Number_of_Students or 0 for s in schools)
    avg_students_per_school = total_students / total_schools if total_schools else 0
    
    # Находим школу с максимальным количеством учащихся
    max_school = None
    max_students = 0
    for school in schools:
        if school.Number_of_Students and school.Number_of_Students > max_students:
            max_students = school.Number_of_Students
            max_school = school
    
    # Статистика по районам
    districts_stats = []
    all_districts = District.query.all()
    overall_total_students = db.session.query(db.func.sum(School.Number_of_Students)).filter(
        School.is_active == True
    ).scalar() or 0
    
    for district in all_districts:
        district_schools = [s for s in schools if s.settlement and s.settlement.PK_District == district.PK_District]
        
        if district_schools:
            district_total = sum(s.Number_of_Students or 0 for s in district_schools)
            district_avg = district_total / len(district_schools) if district_schools else 0
            percentage = (district_total / overall_total_students * 100) if overall_total_students else 0
            
            districts_stats.append({
                'district': district.Name,
                'schools_count': len(district_schools),
                'total_students': district_total,
                'avg_students': round(district_avg, 1),
                'percentage': round(percentage, 1)  # ДОБАВЛЯЕМ ЭТО!
            })
    
    # Статистика по типам школ
    types_stats = []
    all_types = TypeOfSchool.query.all()
    
    for school_type in all_types:
        type_schools = [s for s in schools if s.PK_Type_of_School == school_type.PK_Type_of_School]
        
        if type_schools:
            type_total = sum(s.Number_of_Students or 0 for s in type_schools)
            type_avg = type_total / len(type_schools) if type_schools else 0
            
            types_stats.append({
                'type': school_type.Name,
                'schools_count': len(type_schools),
                'total_students': type_total,
                'avg_students': round(type_avg, 1)
            })
    
    # Топ школ по количеству учащихся
    top_schools = sorted([s for s in schools if s.Number_of_Students], 
                        key=lambda x: x.Number_of_Students or 0, 
                        reverse=True)[:10]
    
    # Динамика по годам (если есть даты основания)
    yearly_stats = {}
    for school in schools:
        if school.Founding_Date:
            year = school.Founding_Date.year
            if year not in yearly_stats:
                yearly_stats[year] = {'count': 0, 'total_students': 0, 'avg_students': 0}
            
            yearly_stats[year]['count'] += 1
            yearly_stats[year]['total_students'] += (school.Number_of_Students or 0)
    
    for year in yearly_stats:
        data = yearly_stats[year]
        data['avg_students'] = data['total_students'] / data['count'] if data['count'] > 0 else 0
    
    # Данные для фильтров
    districts = District.query.order_by(District.Name).all()
    school_types = TypeOfSchool.query.order_by(TypeOfSchool.Name).all()
    
    return render_template('reports/students.html',
                         districts_stats=districts_stats,
                         types_stats=types_stats,
                         yearly_stats=yearly_stats,
                         top_schools=top_schools,
                         total_schools=total_schools,
                         total_students=total_students,
                         avg_students_per_school=round(avg_students_per_school, 1),
                         max_school=max_school,
                         max_students=max_students,
                         districts=districts,
                         school_types=school_types)

# Отчет по инфраструктуре с фильтрами
@app.route('/report/infrastructure')
@login_required
@role_required('school_admin')
def report_infrastructure():
    """Отчет по оснащенности школ"""
    from models import Infrastructure, School, District, Settlement, TypeOfSchool
    
    # Получаем параметры фильтрации
    district_id = request.args.get('district_id')
    school_type_id = request.args.get('school_type_id')
    settlement_id = request.args.get('settlement_id')
    
    # Базовый запрос
    query = School.query.filter_by(is_active=True)
    
    # Применяем фильтры
    if district_id:
        query = query.join(Settlement).filter(Settlement.PK_District == district_id)
    
    if school_type_id:
        query = query.filter(School.PK_Type_of_School == school_type_id)
    
    if settlement_id:
        query = query.filter(School.PK_Settlement == settlement_id)
    
    schools = query.all()
    total_schools = len(schools)
    
    # Статистика по инфраструктуре
    infrastructure_stats = []
    all_infra = Infrastructure.query.all()
    
    for infra in all_infra:
        count = School.query.filter(
            School.infrastructure.any(PK_Infrastructure=infra.PK_Infrastructure),
            School.is_active == True
        ).count()
        
        if district_id:
            count = len([s for s in schools if infra in s.infrastructure])
        
        percentage = (count / total_schools * 100) if total_schools else 0
        
        # Статистика по районам для этой инфраструктуры
        districts_data = []
        for district in District.query.all():
            district_count = School.query.join(Settlement).filter(
                School.infrastructure.any(PK_Infrastructure=infra.PK_Infrastructure),
                School.is_active == True,
                Settlement.PK_District == district.PK_District
            ).count()
            
            total_in_district = School.query.join(Settlement).filter(
                School.is_active == True,
                Settlement.PK_District == district.PK_District
            ).count()
            
            dist_percentage = (district_count / total_in_district * 100) if total_in_district else 0
            districts_data.append({
                'name': district.Name,
                'percentage': round(dist_percentage, 1)
            })
        
        infrastructure_stats.append({
            'name': infra.Name,
            'count': count,
            'percentage': round(percentage, 1),
            'districts': districts_data
        })
    
    # Количество школ с конкретной инфраструктурой
    library = Infrastructure.query.filter_by(Name='Библиотека').first()
    gym = Infrastructure.query.filter_by(Name='Спортзал').first()
    lab = Infrastructure.query.filter_by(Name='Лаборатория').first()
    
    with_library = len([s for s in schools if library in s.infrastructure]) if library else 0
    with_gym = len([s for s in schools if gym in s.infrastructure]) if gym else 0
    with_labs = len([s for s in schools if lab in s.infrastructure]) if lab else 0
    
    # Данные для фильтров
    districts = District.query.order_by(District.Name).all()
    school_types = TypeOfSchool.query.order_by(TypeOfSchool.Name).all()
    settlements = Settlement.query.order_by(Settlement.Name).all()
    
    return render_template('reports/infrastructure.html',
                         schools=schools,
                         total_schools=total_schools,
                         with_library=with_library,
                         with_gym=with_gym,
                         with_labs=with_labs,
                         infrastructure_stats=infrastructure_stats,
                         districts=districts,
                         school_types=school_types,
                         settlements=settlements)

# Отчет по кадровому составу с фильтрами
@app.route('/report/staff')
@login_required
@role_required('school_admin')
def report_staff():
    """Отчет по кадровому составу"""
    from models import Employee, School, District, TypeOfSchool
    
    # Параметры фильтрации
    district_id = request.args.get('district_id')
    school_type_id = request.args.get('school_type_id')
    position_filter = request.args.get('position', '').lower()
    min_experience = request.args.get('min_experience', 0, type=int)
    
    # Базовый запрос
    query = Employee.query
    
    # Фильтр по должности
    if position_filter:
        if position_filter == 'директор':
            query = query.filter(Employee.Position.ilike('%директор%'))
        elif position_filter == 'завуч':
            query = query.filter(db.or_(
                Employee.Position.ilike('%завуч%'),
                Employee.Position.ilike('%заместитель%')
            ))
        elif position_filter == 'учитель':
            query = query.filter(Employee.Position.ilike('%учитель%'))
    
    # Фильтр по стажу
    if min_experience > 0:
        query = query.filter(Employee.Experience_Years >= min_experience)
    
    employees = query.all()
    
    # Если заданы фильтры по школе
    if district_id or school_type_id:
        filtered_employees = []
        for emp in employees:
            # Получаем школы сотрудника
            emp_schools = School.query.filter(
                School.employees.any(PK_Employee=emp.PK_Employee),
                School.is_active == True
            )
            
            if district_id:
                emp_schools = emp_schools.join(Settlement).filter(Settlement.PK_District == district_id)
            
            if school_type_id:
                emp_schools = emp_schools.filter(School.PK_Type_of_School == school_type_id)
            
            if emp_schools.count() > 0:
                filtered_employees.append(emp)
        
        employees = filtered_employees
    
    total_employees = len(employees)
    
    # Статистика по должностям
    position_stats = []
    positions = {}
    
    for emp in employees:
        pos = emp.Position.lower()
        key = None
        
        if 'директор' in pos:
            key = 'Директора'
        elif 'завуч' in pos or 'заместитель' in pos:
            key = 'Завучи'
        elif 'учитель' in pos or 'преподаватель' in pos:
            key = 'Учителя'
        else:
            key = 'Прочие'
        
        positions[key] = positions.get(key, 0) + 1
    
    for position, count in positions.items():
        percentage = (count / total_employees * 100) if total_employees else 0
        position_stats.append({
            'position': position,
            'count': count,
            'percentage': round(percentage, 1)
        })
    
    # Статистика по стажу
    experiences = [e.Experience_Years for e in employees if e.Experience_Years]
    avg_experience = round(sum(experiences) / len(experiences), 1) if experiences else 0
    max_experience = max(experiences) if experiences else 0
    min_experience = min(experiences) if experiences else 0
    
    # Распределение по стажу
    experience_ranges = [
        {'range': '0-5 лет', 'min': 0, 'max': 5},
        {'range': '6-10 лет', 'min': 6, 'max': 10},
        {'range': '11-20 лет', 'min': 11, 'max': 20},
        {'range': '21-30 лет', 'min': 21, 'max': 30},
        {'range': 'Более 30 лет', 'min': 31, 'max': 100}
    ]
    
    for r in experience_ranges:
        count = len([e for e in employees if e.Experience_Years and r['min'] <= e.Experience_Years <= r['max']])
        percentage = (count / total_employees * 100) if total_employees else 0
        r['count'] = count
        r['percentage'] = round(percentage, 1)
    
    # Количество по категориям
    directors_count = len([e for e in employees if 'директор' in e.Position.lower()])
    deputies_count = len([e for e in employees if 'завуч' in e.Position.lower() or 'заместитель' in e.Position.lower()])
    teachers_count = len([e for e in employees if 'учитель' in e.Position.lower() or 'преподаватель' in e.Position.lower()])
    
    # Данные для фильтров
    districts = District.query.order_by(District.Name).all()
    school_types = TypeOfSchool.query.order_by(TypeOfSchool.Name).all()
    
    return render_template('reports/staff.html',
                         employees=employees,
                         total_employees=total_employees,
                         directors_count=directors_count,
                         deputies_count=deputies_count,
                         teachers_count=teachers_count,
                         position_stats=position_stats,
                         avg_experience=avg_experience,
                         max_experience=max_experience,
                         min_experience=min_experience,
                         experience_ranges=experience_ranges,
                         districts=districts,
                         school_types=school_types)

# Отчет по программам дополнительного образования
@app.route('/report/programs')
@login_required
@role_required('school_admin')
def report_programs():
    """Отчет по образовательным программам"""
    from models import EducationProgram, School, District, TypeOfSchool, Settlement
    
    # Параметры фильтрации
    district_id = request.args.get('district_id')
    school_type_id = request.args.get('school_type_id')
    program_type = request.args.get('program_type')
    
    # Базовый запрос для программ
    query = EducationProgram.query
    
    # Фильтр по типу программы
    if program_type:
        query = query.filter_by(Type=program_type)
    
    programs = query.all()
    
    # Статистика по программам
    program_stats = []
    for program in programs:
        # Школы с этой программой
        schools_query = School.query.filter(
            School.programs.any(PK_Education_Program=program.PK_Education_Program),
            School.is_active == True
        )
        
        # Применяем дополнительные фильтры
        if district_id:
            schools_query = schools_query.join(Settlement).filter(Settlement.PK_District == district_id)
        
        if school_type_id:
            schools_query = schools_query.filter(School.PK_Type_of_School == school_type_id)
        
        schools_with_program = schools_query.all()
        count = len(schools_with_program)
        
        total_schools = School.query.filter_by(is_active=True).count()
        percentage = (count / total_schools * 100) if total_schools else 0
        
        program_stats.append({
            'program': program,
            'schools_count': count,
            'percentage': round(percentage, 1),
            'schools': schools_with_program[:5]  # Первые 5 школ для примера
        })
    
    # Распределение по типам программ
    type_stats = []
    from collections import defaultdict
    program_types_count = defaultdict(int)
    
    for program in programs:
        program_types_count[program.Type] += 1
    
    for program_type, count in program_types_count.items():
        type_stats.append({
            'type': program_type,
            'count': count
        })
    
    # Данные для фильтров
    districts = District.query.order_by(District.Name).all()
    school_types = TypeOfSchool.query.order_by(TypeOfSchool.Name).all()
    
    return render_template('reports/programs.html',
                         programs=programs,
                         program_stats=program_stats,
                         type_stats=type_stats,
                         districts=districts,
                         school_types=school_types)

# Экспорт отчетов
@app.route('/export/report')
@login_required
@role_required('school_admin')
def export_report():
    """Экспорт отчета в Excel/CSV"""
    report_type = request.args.get('report_type')
    format_type = request.args.get('format', 'excel')
    
    # В зависимости от типа отчета собираем данные
    # Здесь должна быть логика экспорта
    
    flash('Экспорт отчетов будет реализован в следующей версии', 'info')
    return redirect(url_for('reports_index'))
# Отчет по динамике набора
@app.route('/report/dynamics')
@login_required
@role_required('school_admin')
def report_dynamics():
    """Динамика набора учащихся по годам"""
    from models import School
    
    # Группировка по году основания
    yearly_stats = {}
    
    schools = School.query.filter(
        School.is_active == True,
        School.Founding_Date != None
    ).all()
    
    for school in schools:
        year = school.Founding_Date.year if school.Founding_Date else None
        if year:
            if year not in yearly_stats:
                yearly_stats[year] = {'count': 0, 'total_students': 0}
            
            yearly_stats[year]['count'] += 1
            yearly_stats[year]['total_students'] += (school.Number_of_Students or 0)
    
    # Рассчитываем среднее
    for year, data in yearly_stats.items():
        data['avg_students'] = data['total_students'] / data['count'] if data['count'] > 0 else 0
    
    return render_template('reports/dynamics.html',
                         yearly_stats=yearly_stats)

# Отчет по специализациям
@app.route('/report/specializations')
@login_required
@role_required('school_admin')
def report_specializations():
    """Отчет по специализациям школ"""
    from models import Specialization, School, District
    
    # Параметры фильтрации
    district_id = request.args.get('district_id')
    specialization_id = request.args.get('specialization_id')
    
    # Базовый запрос
    query = School.query.filter_by(is_active=True)
    
    if district_id:
        query = query.join(Settlement).filter(Settlement.PK_District == district_id)
    
    if specialization_id:
        query = query.filter(
            School.specializations.any(PK_Specialization=specialization_id)
        )
    
    schools = query.all()
    
    # Статистика по специализациям
    specialization_stats = []
    for spec in Specialization.query.all():
        count = School.query.filter(
            School.specializations.any(PK_Specialization=spec.PK_Specialization),
            School.is_active == True
        ).count()
        
        total_schools = School.query.filter_by(is_active=True).count()
        percentage = (count / total_schools * 100) if total_schools else 0
        
        specialization_stats.append({
            'specialization': spec,
            'count': count,
            'percentage': round(percentage, 1)
        })
    
    # Данные для фильтров
    districts = District.query.order_by(District.Name).all()
    specializations = Specialization.query.order_by(Specialization.Name).all()
    
    return render_template('reports/specializations.html',
                         schools=schools,
                         specialization_stats=specialization_stats,
                         districts=districts,
                         specializations=specializations)
@app.route('/api/settlements')
def get_all_settlements():
    settlements = Settlement.query.order_by(Settlement.Name).all()
    return jsonify([{
        'id': s.PK_Settlement,
        'name': s.Name,
        'type': s.Type
    } for s in settlements])
# Команды CLI
@app.cli.command('init-db')
def init_db_command():
    """Инициализация базы данных"""
    print("Инициализация базы данных...")
    
    # Создаем таблицы
    db.create_all()
    
    # Создаем типы школ
    if not TypeOfSchool.query.first():
        types = [
            TypeOfSchool(Name='Общеобразовательная школа'),
            TypeOfSchool(Name='Гимназия'),
            TypeOfSchool(Name='Лицей'),
            TypeOfSchool(Name='Школа-интернат'),
            TypeOfSchool(Name='Коррекционная школа'),
            TypeOfSchool(Name='Вечерняя школа'),
            TypeOfSchool(Name='Кадетская школа')
        ]
        for t in types:
            db.session.add(t)
    
    # Создаем районы
    if not District.query.first():
        districts = [
            District(Name='Алейский район'),
            District(Name='Барнаульский район'),
            District(Name='Бийский район'),
            District(Name='Заринский район'),
            District(Name='Каменский район'),
            District(Name='Новоалтайский район'),
            District(Name='Рубцовский район'),
            District(Name='Славгородский район')
        ]
        for d in districts:
            db.session.add(d)
    
    # Создаем населенные пункты
    if not Settlement.query.first():
        settlements = [
            Settlement(Name='Барнаул', Type='город', PK_District=2),
            Settlement(Name='Бийск', Type='город', PK_District=3),
            Settlement(Name='Рубцовск', Type='город', PK_District=7),
            Settlement(Name='Новоалтайск', Type='город', PK_District=6),
            Settlement(Name='Заринск', Type='город', PK_District=4),
            Settlement(Name='Камень-на-Оби', Type='город', PK_District=5),
            Settlement(Name='Славгород', Type='город', PK_District=8),
            Settlement(Name='Алейск', Type='город', PK_District=1)
        ]
        for s in settlements:
            db.session.add(s)
    
    # Создаем инфраструктуру
    if not Infrastructure.query.first():
        infrastructures = [
            Infrastructure(Name='Спортзал'),
            Infrastructure(Name='Бассейн'),
            Infrastructure(Name='Библиотека'),
            Infrastructure(Name='Лаборатория'),
            Infrastructure(Name='Компьютерный класс'),
            Infrastructure(Name='Актовый зал'),
            Infrastructure(Name='Столовая'),
            Infrastructure(Name='Медицинский кабинет'),
            Infrastructure(Name='Спортивная площадка'),
            Infrastructure(Name='Мастерские')
        ]
        for i in infrastructures:
            db.session.add(i)
    
    # Создаем специализации
    if not Specialization.query.first():
        specializations = [
            Specialization(Name='Физико-математическая'),
            Specialization(Name='Химико-биологическая'),
            Specialization(Name='Гуманитарная'),
            Specialization(Name='Лингвистическая'),
            Specialization(Name='Техническая'),
            Specialization(Name='Художественно-эстетическая'),
            Specialization(Name='Спортивная'),
            Specialization(Name='Информационные технологии')
        ]
        for s in specializations:
            db.session.add(s)
    
    # Создаем предметы
    if not Subject.query.first():
        subjects = [
            Subject(Name='Математика'),
            Subject(Name='Физика'),
            Subject(Name='Химия'),
            Subject(Name='Биология'),
            Subject(Name='Русский язык'),
            Subject(Name='Литература'),
            Subject(Name='История'),
            Subject(Name='Обществознание'),
            Subject(Name='География'),
            Subject(Name='Иностранный язык'),
            Subject(Name='Информатика')
        ]
        for s in subjects:
            db.session.add(s)
    
    # Создаем администратора
    if not User.query.filter_by(username='admin').first():
        admin = User(
            username='admin',
            email='admin@example.com',
            role=5
        )
        admin.set_password('admin123')
        db.session.add(admin)
    
    # Создаем тестовых пользователей
    test_users = [
        ('parent', 'parent@example.com', 'parent123', 1),
        ('teacher', 'teacher@example.com', 'teacher123', 2),
        ('school_admin', 'school_admin@example.com', 'admin123', 3),
        ('region_admin', 'region_admin@example.com', 'admin123', 4)
    ]
    
    for username, email, password, role in test_users:
        if not User.query.filter_by(username=username).first():
            user = User(username=username, email=email, role=role)
            user.set_password(password)
            db.session.add(user)
    
    db.session.commit()
    
    print('✅ База данных инициализирована с тестовыми данными.')
    print('👤 Администратор: admin / admin123')
    print('👨‍👩‍👧‍👦 Родитель: parent / parent123')
    print('👨‍🏫 Учитель: teacher / teacher123')
    print('🏫 Администратор школы: school_admin / admin123')
    print('🗺️ Администратор региона: region_admin / admin123')

@app.cli.command('create-user')
def create_user_command():
    """Создание нового пользователя"""
    import getpass
    
    username = input('Имя пользователя: ')
    if User.query.filter_by(username=username).first():
        print(f'❌ Пользователь {username} уже существует.')
        return
    
    email = input('Email: ')
    if User.query.filter_by(email=email).first():
        print(f'❌ Email {email} уже зарегистрирован.')
        return
    
    print('Роли:')
    print(' 0 - Гость')
    print(' 1 - Родитель')
    print(' 2 - Учитель')
    print(' 3 - Администратор школы')
    print(' 4 - Администратор региона')
    print(' 5 - Супер-администратор')
    
    try:
        role = int(input('Роль (0-5): '))
        if role < 0 or role > 5:
            print('❌ Роль должна быть от 0 до 5')
            return
    except ValueError:
        print('❌ Роль должна быть числом')
        return
    
    password = getpass.getpass('Пароль: ')
    password2 = getpass.getpass('Повторите пароль: ')
    
    if password != password2:
        print('❌ Пароли не совпадают')
        return
    
    if len(password) < 6:
        print('❌ Пароль должен быть не менее 6 символов')
        return
    
    user = User(username=username, email=email, role=role)
    user.set_password(password)
    
    db.session.add(user)
    db.session.commit()
    
    print(f'✅ Пользователь {username} создан с ролью {role}')

# Запуск приложения
if __name__ == '__main__':
    with app.app_context():
        try:
            db.create_all()
            print("✅ Database tables ready")
        except Exception as e:
            print(f"❌ Error: {e}")
        
        print("🚀 Starting School Registry application...")
        print("🌐 Server: http://localhost:5000")
        print("📝 Press Ctrl+C to stop")
        
    app.run(debug=True, host='0.0.0.0', port=5000)