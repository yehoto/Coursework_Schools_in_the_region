from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from wtforms import (
    StringField, PasswordField, BooleanField, SubmitField,
    TextAreaField, IntegerField, DateField, SelectField,
    SelectMultipleField, EmailField, URLField
)
from wtforms.validators import DataRequired, Length, EqualTo, ValidationError, Optional, Email, URL
from models import User

class LoginForm(FlaskForm):
    username = StringField('Имя пользователя', validators=[DataRequired()])
    password = PasswordField('Пароль', validators=[DataRequired()])
    remember_me = BooleanField('Запомнить меня')
    submit = SubmitField('Войти')

class RegistrationForm(FlaskForm):
    username = StringField(
        'Имя пользователя',
        validators=[DataRequired(), Length(min=3, max=64)]
    )
    email = StringField('Email', validators=[DataRequired()])
    password = PasswordField(
        'Пароль',
        validators=[DataRequired(), Length(min=6)]
    )
    password2 = PasswordField(
        'Повторите пароль',
        validators=[DataRequired(), EqualTo('password')]
    )
    submit = SubmitField('Зарегистрироваться')
    
    def validate_username(self, username):
        user = User.query.filter_by(username=username.data).first()
        if user is not None:
            raise ValidationError('Имя пользователя уже занято.')
    
    def validate_email(self, email):
        user = User.query.filter_by(email=email.data).first()
        if user is not None:
            raise ValidationError('Email уже зарегистрирован.')

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