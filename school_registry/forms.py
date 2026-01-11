from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from wtforms import (
    StringField, PasswordField, BooleanField, SubmitField,
    TextAreaField, IntegerField, DateField, SelectField,
    SelectMultipleField, EmailField, URLField
)
from wtforms.validators import DataRequired, Length, EqualTo, ValidationError, Optional, Email, URL
from models import User
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField, BooleanField, TextAreaField
from wtforms.validators import DataRequired, Email, EqualTo, Length, ValidationError
from models import User, School

class LoginForm(FlaskForm):
    username = StringField('Имя пользователя', validators=[DataRequired()])
    password = PasswordField('Пароль', validators=[DataRequired()])
    remember_me = BooleanField('Запомнить меня')
    submit = SubmitField('Войти')

class RegistrationForm(FlaskForm):
    username = StringField('Имя пользователя', validators=[
        DataRequired(),
        Length(min=3, max=80, message='Имя пользователя должно быть от 3 до 80 символов')
    ])
    
    email = StringField('Email', validators=[
        DataRequired(),
        Email(),
        Length(max=120)
    ])
    
    password = PasswordField('Пароль', validators=[
        DataRequired(),
        Length(min=6, message='Пароль должен быть не менее 6 символов')
    ])
    
    password2 = PasswordField('Повторите пароль', validators=[
        DataRequired(),
        EqualTo('password', message='Пароли должны совпадать')
    ])
    
    role = SelectField('Выберите вашу роль', choices=[
        ('1', 'Ученик/Родитель (только просмотр)'),
        ('2', 'Работник образовательного учреждения'),
        ('3', 'Другое (только просмотр)')
    ], validators=[DataRequired()])
    
    school_id = SelectField('Выберите ваше учреждение', choices=[], coerce=int)
    
    submit = SubmitField('Зарегистрироваться')
    
    def __init__(self, *args, **kwargs):
        super(RegistrationForm, self).__init__(*args, **kwargs)
        # Заполняем список школ
        schools = School.query.filter_by(is_active=True).order_by(School.Official_Name).all()
        self.school_id.choices = [(0, '-- Выберите учреждение --')] + [
            (s.PK_School, s.Official_Name) for s in schools
        ]
    
    def validate_username(self, field):
        if User.query.filter_by(username=field.data).first():
            raise ValidationError('Это имя пользователя уже занято')
    
    def validate_email(self, field):
        if User.query.filter_by(email=field.data).first():
            raise ValidationError('Этот email уже зарегистрирован')
    
    def validate_school_id(self, field):
        if self.role.data == '2' and (field.data == 0 or field.data is None):
            raise ValidationError('Работник учреждения должен выбрать образовательное учреждение')

class SchoolForm(FlaskForm):
    official_name = StringField(
        'Официальное название*',
        validators=[DataRequired(), Length(max=255)]
    )
    legal_address = TextAreaField(
        'Юридический адрес*',
        validators=[DataRequired()]
    )
    phone = StringField(
        'Телефон*',
        validators=[DataRequired(), Length(max=20)]
    )
    email = EmailField(
        'Email',
        validators=[Optional(), Email(), Length(max=100)]
    )
    website = URLField(
        'Веб-сайт',
        validators=[Optional(), URL(), Length(max=200)]
    )
    founding_date = DateField(
        'Дата основания',
        format='%Y-%m-%d',
        validators=[Optional()]
    )
    number_of_students = IntegerField(
        'Количество учащихся',
        validators=[Optional()]
    )
    license = TextAreaField('Лицензия')
    accreditation = TextAreaField('Аккредитация')
    type_of_school = SelectField(
        'Тип школы*',
        coerce=int,
        validators=[DataRequired()]
    )
    settlement = SelectField(
        'Населенный пункт*',
        coerce=int,
        validators=[DataRequired()]
    )
    infrastructure = SelectMultipleField(
        'Инфраструктура',
        coerce=int
    )
    specializations = SelectMultipleField(
        'Специализации',
        coerce=int
    )
    submit = SubmitField('Сохранить')

class ReviewForm(FlaskForm):
    text = TextAreaField(
        'Текст отзыва*',
        validators=[DataRequired(), Length(min=10, max=1000)]
    )
    rating = SelectField(
        'Оценка*',
        choices=[
            (5, '5 - Отлично'),
            (4, '4 - Хорошо'),
            (3, '3 - Удовлетворительно'),
            (2, '2 - Плохо'),
            (1, '1 - Очень плохо')
        ],
        coerce=int,
        validators=[DataRequired()]
    )
    submit = SubmitField('Оставить отзыв')

class ImportForm(FlaskForm):
    file_type = SelectField(
        'Тип файла',
        choices=[('csv', 'CSV'), ('json', 'JSON'), ('excel', 'Excel')],
        validators=[DataRequired()]
    )
    submit = SubmitField('Загрузить шаблон')

class EmployeeForm(FlaskForm):
    full_name = StringField(
        'ФИО*',
        validators=[DataRequired(), Length(max=100)]
    )
    position = StringField(
        'Должность*',
        validators=[DataRequired(), Length(max=50)]
    )
    qualifications = TextAreaField('Квалификация')
    experience_years = IntegerField(
        'Стаж работы (лет)',
        validators=[Optional()]
    )
    subjects = SelectMultipleField(
        'Предметы',
        coerce=int
    )
    submit = SubmitField('Сохранить')

class ProgramForm(FlaskForm):
    code_designation = StringField(
        'Кодовое обозначение*',
        validators=[DataRequired(), Length(max=50)]
    )
    name = StringField(
        'Название программы*',
        validators=[DataRequired(), Length(max=255)]
    )
    type = SelectField(
        'Тип программы*',
        choices=[
            ('основная', 'Основная'),
            ('дополнительная', 'Дополнительная')
        ],
        validators=[DataRequired()]
    )
    description = TextAreaField('Описание')
    submit = SubmitField('Сохранить')

class UserProfileForm(FlaskForm):
    username = StringField(
        'Имя пользователя',
        validators=[DataRequired(), Length(min=3, max=64)]
    )
    email = EmailField(
        'Email',
        validators=[DataRequired(), Email()]
    )
    current_password = PasswordField(
        'Текущий пароль',
        validators=[Optional()]
    )
    new_password = PasswordField(
        'Новый пароль',
        validators=[Optional(), Length(min=6)]
    )
    new_password2 = PasswordField(
        'Повторите новый пароль',
        validators=[EqualTo('new_password')]
    )
    submit = SubmitField('Обновить профиль')

class InspectionForm(FlaskForm):
    date = DateField('Дата проверки', validators=[DataRequired()])
    result = TextAreaField('Результат проверки', validators=[DataRequired(), Length(max=2000)])
    prescription_number = StringField('Номер предписания', validators=[DataRequired(), Length(max=50)])
    school_id = SelectField('Школа', coerce=int, validators=[DataRequired()])
    has_violations = BooleanField('Нарушения выявлены')
    violation_type = StringField('Тип нарушений', validators=[Optional(), Length(max=200)])
    is_resolved = BooleanField('Нарушения устранены')
    resolution_date = DateField('Дата устранения', validators=[Optional()])
    description = TextAreaField('Описание', validators=[Optional(), Length(max=1000)])
    submit = SubmitField('Сохранить')