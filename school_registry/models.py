from datetime import datetime, timezone
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()

# Таблицы многие-ко-многим
school_infrastructure = db.Table(
    '"School_Infrastructure"',
    db.Column('"PK_Infrastructure"', db.BigInteger, db.ForeignKey('"Infrastructure"."PK_Infrastructure"'), primary_key=True),
    db.Column('"PK_School"', db.BigInteger, db.ForeignKey('"School"."PK_School"'), primary_key=True)
)

school_specialization = db.Table(
    '"School_Specialization"',
    db.Column('"PK_Specialization"', db.BigInteger, db.ForeignKey('"Specialization"."PK_Specialization"'), primary_key=True),
    db.Column('"PK_School"', db.BigInteger, db.ForeignKey('"School"."PK_School"'), primary_key=True)
)

school_employee = db.Table(
    '"School_Employee"',
    db.Column('"PK_School"', db.BigInteger, db.ForeignKey('"School"."PK_School"'), primary_key=True),
    db.Column('"PK_Employee"', db.BigInteger, db.ForeignKey('"Employee"."PK_Employee"'), primary_key=True)
)

employee_subject_competence = db.Table(
    '"Employee_Subject_Competence"',
    db.Column('"PK_Subject"', db.BigInteger, db.ForeignKey('"Subject"."PK_Subject"'), primary_key=True),
    db.Column('"PK_Employee"', db.BigInteger, db.ForeignKey('"Employee"."PK_Employee"'), primary_key=True)
)

school_program_implementation = db.Table(
    '"School_Program_Implementation"',
    db.Column('"PK_School"', db.BigInteger, db.ForeignKey('"School"."PK_School"'), primary_key=True),
    db.Column('"PK_Education_Program"', db.BigInteger, db.ForeignKey('"Education_Program"."PK_Education_Program"'), primary_key=True)
)

class User(db.Model, UserMixin):  # Добавьте UserMixin
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(256))
    role = db.Column(db.Integer, default=1)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.now(timezone.utc))
    last_login = db.Column(db.DateTime, nullable=True)
    gosuslugi_id = db.Column(db.String(100), nullable=True)
    gosuslugi_data = db.Column(db.Text, nullable=True)
    
    # Удалите все отношения с Review - создадим заново ниже
    # reviews = db.relationship('Review', backref='author_user', lazy='dynamic')
    
    def __repr__(self):
        return f'<User {self.username}>'
    
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def has_role(self, role_name):
        """Проверка роли пользователя"""
        from config import Config
        required_role = Config.ROLES.get(role_name, 0)
        return self.role >= required_role

class School(db.Model):
    __tablename__ = '"School"'
    
    PK_School = db.Column('"PK_School"', db.BigInteger, primary_key=True)
    Official_Name = db.Column('"Official_Name"', db.String(255), nullable=False)
    Legal_Adress = db.Column('"Legal_Adress"', db.Text, nullable=False)
    Phone = db.Column('"Phone"', db.String(20), nullable=False)
    Email = db.Column('"Email"', db.String(100))
    Website = db.Column('"Website"', db.String(200))
    Founding_Date = db.Column('"Founding_Date"', db.Date)
    Number_of_Students = db.Column('"Number_of_Students"', db.BigInteger)
    License = db.Column('"License"', db.Text)
    Accreditation = db.Column('"Accreditation"', db.Text)
    PK_Type_of_School = db.Column('"PK_Type_of_School"', db.BigInteger, db.ForeignKey('"Type_of_School"."PK_Type_of_School"'))
    PK_Settlement = db.Column('"PK_Settlement"', db.BigInteger, db.ForeignKey('"Settlement"."PK_Settlement"'))
    
    # Дополнительные поля для системы
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    created_by = db.Column(db.Integer, db.ForeignKey('users.id'))
    
    # Связи
    type_of_school = db.relationship('TypeOfSchool', backref='schools')
    settlement = db.relationship('Settlement', backref='schools')
    infrastructure = db.relationship('Infrastructure', secondary=school_infrastructure, backref='schools')
    specializations = db.relationship('Specialization', secondary=school_specialization, backref='schools')
    employees = db.relationship('Employee', secondary=school_employee, backref='schools')
    programs = db.relationship('EducationProgram', secondary=school_program_implementation, backref='schools')
    reviews = db.relationship('Review', backref='school', lazy=True)
    inspections = db.relationship('Inspection', backref='school', lazy=True)
    creator_user = db.relationship('User', backref='created_schools')
    
    def get_avg_rating(self):
        """Средний рейтинг школы"""
        if not self.reviews:
            return 0
        approved_reviews = [r for r in self.reviews if getattr(r, 'is_approved', True)]
        if not approved_reviews:
            return 0
        return sum(r.Rating for r in approved_reviews) / len(approved_reviews)
    
    def get_review_count(self):
        """Количество одобренных отзывов"""
        return len([r for r in self.reviews if getattr(r, 'is_approved', True)])
    
    def __repr__(self):
        return f'<School {self.Official_Name}>'

class TypeOfSchool(db.Model):
    __tablename__ = '"Type_of_School"'
    
    PK_Type_of_School = db.Column('"PK_Type_of_School"', db.BigInteger, primary_key=True)
    Name = db.Column('"Name"', db.String(255), nullable=False)
    
    def __repr__(self):
        return f'<TypeOfSchool {self.Name}>'

class Settlement(db.Model):
    __tablename__ = '"Settlement"'
    
    PK_Settlement = db.Column('"PK_Settlement"', db.BigInteger, primary_key=True)
    Name = db.Column('"Name"', db.String(100), nullable=False)
    Type = db.Column('"Type"', db.String(20), nullable=False)
    PK_District = db.Column('"PK_District"', db.BigInteger, db.ForeignKey('"District"."PK_District"'))
    
    district = db.relationship('District', backref='settlements')
    
    def __repr__(self):
        return f'<Settlement {self.Type} {self.Name}>'

class District(db.Model):
    __tablename__ = '"District"'
    
    PK_District = db.Column('"PK_District"', db.BigInteger, primary_key=True)
    Name = db.Column('"Name"', db.String(255), nullable=False)
    
    def __repr__(self):
        return f'<District {self.Name}>'

class Infrastructure(db.Model):
    __tablename__ = '"Infrastructure"'
    
    PK_Infrastructure = db.Column('"PK_Infrastructure"', db.BigInteger, primary_key=True)
    Name = db.Column('"Name"', db.String(50), nullable=False)
    
    def __repr__(self):
        return f'<Infrastructure {self.Name}>'

class Specialization(db.Model):
    __tablename__ = '"Specialization"'
    
    PK_Specialization = db.Column('"PK_Specialization"', db.BigInteger, primary_key=True)
    Name = db.Column('"Name"', db.String(50), nullable=False)
    
    def __repr__(self):
        return f'<Specialization {self.Name}>'

class Employee(db.Model):
    __tablename__ = '"Employee"'
    
    PK_Employee = db.Column('"PK_Employee"', db.BigInteger, primary_key=True)
    Full_Name = db.Column('"Full_Name"', db.String(100), nullable=False)
    Position = db.Column('"Position"', db.String(50), nullable=False)
    
    # Дополнительные поля
    Qualifications = db.Column(db.Text, nullable=True)
    Experience_Years = db.Column(db.Integer, nullable=True)
    
    def __repr__(self):
        return f'<Employee {self.Full_Name}>'

class Subject(db.Model):
    __tablename__ = '"Subject"'
    
    PK_Subject = db.Column('"PK_Subject"', db.BigInteger, primary_key=True)
    Name = db.Column('"Name"', db.String(100), nullable=False)
    
    def __repr__(self):
        return f'<Subject {self.Name}>'

class EducationProgram(db.Model):
    __tablename__ = '"Education_Program"'
    
    PK_Education_Program = db.Column('"PK_Education_Program"', db.BigInteger, primary_key=True)
    Code_Designation = db.Column('"Code_Designation"', db.String(50), nullable=False)
    Name = db.Column('"Name"', db.String(255), nullable=False)
    Type = db.Column('"Type"', db.String(20), nullable=False)
    
    def __repr__(self):
        return f'<EducationProgram {self.Name}>'

class Review(db.Model):
    __tablename__ = '"Review"'
    
    PK_Review = db.Column('"PK_Review"', db.BigInteger, primary_key=True)
    Author = db.Column('"Author"', db.String(100))
    Text = db.Column('"Text"', db.Text)
    Date = db.Column('"Date"', db.Date, nullable=False)
    Rating = db.Column('"Rating"', db.Integer, nullable=False)
    PK_School = db.Column('"PK_School"', db.BigInteger, db.ForeignKey('"School"."PK_School"'))
    
    # Дополнительные поля для системы
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    is_approved = db.Column(db.Boolean, default=True)
    
    # Связи - УПРОЩАЕМ: оставляем только user, без backref
    user = db.relationship('User')
    
    def __repr__(self):
        return f'<Review {self.PK_Review} - School {self.PK_School}>'

class Inspection(db.Model):
    __tablename__ = '"Inspection"'
    
    PK_Inspection = db.Column('"PK_Inspection"', db.BigInteger, primary_key=True)
    Date = db.Column('"Date"', db.Date, nullable=False)
    Result = db.Column('"Result"', db.Text, nullable=False)
    Prescription_Number = db.Column('"Prescription_Number"', db.String(50), nullable=False)
    PK_School = db.Column('"PK_School"', db.BigInteger, db.ForeignKey('"School"."PK_School"'))
    
    def __repr__(self):
        return f'<Inspection {self.Prescription_Number}>'

class AuditLog(db.Model):
    __tablename__ = 'audit_log'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    action = db.Column(db.String(50), nullable=False)
    table_name = db.Column(db.String(50), nullable=False)
    record_id = db.Column(db.String(100), nullable=False)
    old_values = db.Column(db.Text, nullable=True)
    new_values = db.Column(db.Text, nullable=True)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    ip_address = db.Column(db.String(45))
    user_agent = db.Column(db.Text, nullable=True)
    
    user = db.relationship('User', backref='audit_logs')
    
    def __repr__(self):
        return f'<AuditLog {self.action} {self.table_name}.{self.record_id}>'

class ImportHistory(db.Model):
    __tablename__ = 'import_history'
    
    id = db.Column(db.Integer, primary_key=True)
    filename = db.Column(db.String(255), nullable=False)
    file_type = db.Column(db.String(10), nullable=False)
    imported_by = db.Column(db.Integer, db.ForeignKey('users.id'))
    imported_at = db.Column(db.DateTime, default=datetime.utcnow)
    record_count = db.Column(db.Integer)
    status = db.Column(db.String(20), default='completed')
    errors = db.Column(db.Text, nullable=True)
    
    importer = db.relationship('User', backref='imports')
    
    def __repr__(self):
        return f'<ImportHistory {self.filename}>'
    
class DataVersion(db.Model):
    __tablename__ = 'data_versions'
    
    # Все имена в snake_case, как в базе данных
    pk_version = db.Column('pk_version', db.Integer, primary_key=True)
    table_name = db.Column('table_name', db.String(100), nullable=False)
    record_id = db.Column('record_id', db.Integer, nullable=False)
    action = db.Column('action', db.String(20), nullable=False)  # create, update, delete, rollback
    data_before = db.Column('data_before', db.JSON, nullable=True)
    data_after = db.Column('data_after', db.JSON, nullable=True)
    changed_by = db.Column('changed_by', db.Integer, db.ForeignKey('users.id'))
    changed_at = db.Column('changed_at', db.DateTime, default=datetime.now(timezone.utc))
    created_at = db.Column('created_at', db.DateTime, default=datetime.now(timezone.utc))
    
    # Связи
    user = db.relationship('User', backref='versions')
    
    def __repr__(self):
        return f'<DataVersion {self.pk_version}: {self.table_name}.{self.record_id} - {self.action}>'