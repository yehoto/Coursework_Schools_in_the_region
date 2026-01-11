from datetime import datetime, timezone
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
import json

db = SQLAlchemy()

# Таблицы многие-ко-многим
school_infrastructure = db.Table(
    'School_Infrastructure',
    db.Column('PK_Infrastructure', db.BigInteger, db.ForeignKey('Infrastructure.PK_Infrastructure'), primary_key=True),
    db.Column('PK_School', db.BigInteger, db.ForeignKey('School.PK_School'), primary_key=True)
)

school_specialization = db.Table(
    'School_Specialization',
    db.Column('PK_Specialization', db.BigInteger, db.ForeignKey('Specialization.PK_Specialization'), primary_key=True),
    db.Column('PK_School', db.BigInteger, db.ForeignKey('School.PK_School'), primary_key=True)
)

school_employee = db.Table(
    'School_Employee',
    db.Column('PK_School', db.BigInteger, db.ForeignKey('School.PK_School'), primary_key=True),
    db.Column('PK_Employee', db.BigInteger, db.ForeignKey('Employee.PK_Employee'), primary_key=True)
)

employee_subject_competence = db.Table(
    'Employee_Subject_Competence',
    db.Column('PK_Subject', db.BigInteger, db.ForeignKey('Subject.PK_Subject'), primary_key=True),
    db.Column('PK_Employee', db.BigInteger, db.ForeignKey('Employee.PK_Employee'), primary_key=True)
)

school_program_implementation = db.Table(
    'School_Program_Implementation',
    db.Column('PK_School', db.BigInteger, db.ForeignKey('School.PK_School'), primary_key=True),
    db.Column('PK_Education_Program', db.BigInteger, db.ForeignKey('Education_Program.PK_Education_Program'), primary_key=True)
)

class User(db.Model, UserMixin):
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
    
    # Отношения
    reviews = db.relationship('Review', backref='author_user', foreign_keys='Review.user_id', lazy='dynamic')
    moderated_reviews = db.relationship('Review', backref='moderator_user', foreign_keys='Review.moderated_by', lazy='dynamic')
    created_schools = db.relationship('School', backref='creator', foreign_keys='School.created_by', lazy='dynamic')
    versions = db.relationship('DataVersion', backref='changer', foreign_keys='DataVersion.changed_by', lazy='dynamic')
    imports = db.relationship('ImportHistory', backref='importer', foreign_keys='ImportHistory.imported_by', lazy='dynamic')
    audit_logs = db.relationship('AuditLog', backref='user_ref', foreign_keys='AuditLog.user_id', lazy='dynamic')
    
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
    __tablename__ = 'School'
    
    PK_School = db.Column(db.BigInteger, primary_key=True)
    Official_Name = db.Column(db.String(255), nullable=False)
    Legal_Adress = db.Column(db.Text, nullable=False)
    Phone = db.Column(db.String(20), nullable=False)
    Email = db.Column(db.String(100))
    Website = db.Column(db.String(200))
    Founding_Date = db.Column(db.Date)
    Number_of_Students = db.Column(db.BigInteger)
    License = db.Column(db.Text)
    Accreditation = db.Column(db.Text)
    PK_Type_of_School = db.Column(db.BigInteger, db.ForeignKey('Type_of_School.PK_Type_of_School'))
    PK_Settlement = db.Column(db.BigInteger, db.ForeignKey('Settlement.PK_Settlement'))
    
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
    
    def get_avg_rating(self):
        """Средний рейтинг школы"""
        if not self.reviews:
            return 0
        
        try:
            approved_reviews = [r for r in self.reviews if getattr(r, 'is_approved', True)]
            if not approved_reviews:
                return 0
            return sum(r.Rating for r in approved_reviews) / len(approved_reviews)
        except Exception:
            # Если есть ошибка с is_approved, считаем все отзывы
            return sum(r.Rating for r in self.reviews) / len(self.reviews)
    
    def get_review_count(self):
        """Количество одобренных отзывов"""
        return len([r for r in self.reviews if r.is_approved and not r.is_deleted])
    
    def __repr__(self):
        return f'<School {self.Official_Name}>'

class TypeOfSchool(db.Model):
    __tablename__ = 'Type_of_School'
    
    PK_Type_of_School = db.Column(db.BigInteger, primary_key=True)
    Name = db.Column(db.String(255), nullable=False)
    
    def __repr__(self):
        return f'<TypeOfSchool {self.Name}>'

class Settlement(db.Model):
    __tablename__ = 'Settlement'
    
    PK_Settlement = db.Column(db.BigInteger, primary_key=True)
    Name = db.Column(db.String(100), nullable=False)
    Type = db.Column(db.String(20), nullable=False)
    PK_District = db.Column(db.BigInteger, db.ForeignKey('District.PK_District'))
    
    district = db.relationship('District', backref='settlements')
    
    def __repr__(self):
        return f'<Settlement {self.Type} {self.Name}>'

class District(db.Model):
    __tablename__ = 'District'
    
    PK_District = db.Column(db.BigInteger, primary_key=True)
    Name = db.Column(db.String(255), nullable=False)
    
    def __repr__(self):
        return f'<District {self.Name}>'

class Infrastructure(db.Model):
    __tablename__ = 'Infrastructure'
    
    PK_Infrastructure = db.Column(db.BigInteger, primary_key=True)
    Name = db.Column(db.String(50), nullable=False)
    
    def __repr__(self):
        return f'<Infrastructure {self.Name}>'

class Specialization(db.Model):
    __tablename__ = 'Specialization'
    
    PK_Specialization = db.Column(db.BigInteger, primary_key=True)
    Name = db.Column(db.String(50), nullable=False)
    
    def __repr__(self):
        return f'<Specialization {self.Name}>'

class Employee(db.Model):
    __tablename__ = 'Employee'
    
    PK_Employee = db.Column(db.BigInteger, primary_key=True)
    Full_Name = db.Column(db.String(100), nullable=False)
    Position = db.Column(db.String(50), nullable=False)
    
    # Дополнительные поля
    Qualifications = db.Column(db.Text, nullable=True)
    Experience_Years = db.Column(db.Integer, nullable=True)
    
    def __repr__(self):
        return f'<Employee {self.Full_Name}>'

class Subject(db.Model):
    __tablename__ = 'Subject'
    
    PK_Subject = db.Column(db.BigInteger, primary_key=True)
    Name = db.Column(db.String(100), nullable=False)
    
    def __repr__(self):
        return f'<Subject {self.Name}>'

class EducationProgram(db.Model):
    __tablename__ = 'Education_Program'
    
    PK_Education_Program = db.Column(db.BigInteger, primary_key=True)
    Code_Designation = db.Column(db.String(50), nullable=False)
    Name = db.Column(db.String(255), nullable=False)
    Type = db.Column(db.String(20), nullable=False)
    
    def __repr__(self):
        return f'<EducationProgram {self.Name}>'

class Review(db.Model):
    __tablename__ = 'Review'
    
    PK_Review = db.Column(db.BigInteger, primary_key=True)
    Author = db.Column(db.String(100))
    Text = db.Column(db.Text)
    Date = db.Column(db.Date, nullable=False)
    Rating = db.Column(db.Integer, nullable=False)
    PK_School = db.Column(db.BigInteger, db.ForeignKey('School.PK_School'))
    
    # Поля системы
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    is_approved = db.Column(db.Boolean, default=True)
    moderated_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    moderated_at = db.Column(db.DateTime, nullable=True)
    moderation_comment = db.Column(db.Text, nullable=True)
    is_deleted = db.Column(db.Boolean, default=False)
    deleted_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)
    deletion_reason = db.Column(db.Text, nullable=True)
    
    def __repr__(self):
        return f'<Review {self.PK_Review} - School {self.PK_School}>'

class Inspection(db.Model):
    __tablename__ = 'Inspection'
    
    PK_Inspection = db.Column(db.BigInteger, primary_key=True)
    Date = db.Column(db.Date, nullable=False)
    Result = db.Column(db.Text, nullable=False)
    Prescription_Number = db.Column(db.String(50), nullable=False)
    PK_School = db.Column(db.BigInteger, db.ForeignKey('School.PK_School'))
    
    # Дополнительные поля для отчетов
    has_violations = db.Column(db.Boolean, default=False)
    violation_type = db.Column(db.String(200), nullable=True)
    is_resolved = db.Column(db.Boolean, default=False)
    resolution_date = db.Column(db.Date, nullable=True)
    description = db.Column(db.Text, nullable=True)
    
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
    
    def __repr__(self):
        return f'<ImportHistory {self.filename}>'

class DataVersion(db.Model):
    __tablename__ = 'data_versions'
    
    pk_version = db.Column(db.Integer, primary_key=True)
    table_name = db.Column(db.String(100), nullable=False)
    record_id = db.Column(db.Integer, nullable=False)
    action = db.Column(db.String(20), nullable=False)
    data_before = db.Column(db.JSON, nullable=True)
    data_after = db.Column(db.JSON, nullable=True)
    changed_by = db.Column(db.Integer, db.ForeignKey('users.id'))
    changed_at = db.Column(db.DateTime, default=datetime.now(timezone.utc))
    created_at = db.Column(db.DateTime, default=datetime.now(timezone.utc))
    
    def __repr__(self):
        return f'<DataVersion {self.pk_version}: {self.table_name}.{self.record_id} - {self.action}>'
    
    def get_changes(self):
        """Возвращает список измененных полей"""
        if not self.data_before or not self.data_after:
            return []
        
        changes = []
        for key in set(list(self.data_before.keys()) + list(self.data_after.keys())):
            before = self.data_before.get(key)
            after = self.data_after.get(key)
            if before != after:
                changes.append({
                    'field': key,
                    'before': before,
                    'after': after
                })
        return changes