#!/usr/bin/env python3
"""
Скрипт для инициализации базы данных PostgreSQL для Реестра школ Алтайского края
"""

import os
import sys
import re
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

def create_database():
    """Создание базы данных если она не существует"""
    try:
        conn = psycopg2.connect(
            host="localhost",
            user="postgres",
            password="postgres",  # Замените на ваш пароль
            port=5432
        )
        conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = conn.cursor()
        
        cursor.execute("SELECT 1 FROM pg_database WHERE datname = 'school_registry'")
        exists = cursor.fetchone()
        
        if not exists:
            print("Создание базы данных 'school_registry'...")
            cursor.execute('CREATE DATABASE school_registry')
            print("✅ База данных создана успешно")
        else:
            print("✅ База данных уже существует")
        
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Ошибка при создании базы данных: {e}")
        sys.exit(1)

def execute_sql_file(engine, filename):
    """Выполнение SQL файла с использованием psycopg2 напрямую"""
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            sql_content = f.read()
        
        # Удаляем ошибочный VIEW
        sql_content = re.sub(r'CREATE VIEW "View1" AS\s*\n?\s*SELECT\s*;', '', sql_content, flags=re.IGNORECASE)
        
        # Используем psycopg2 напрямую для выполнения DDL
        import psycopg2
        conn = psycopg2.connect(
            host="localhost",
            user="postgres",
            password="postgres",  # Ваш пароль
            dbname="school_registry",
            port=5432
        )
        conn.autocommit = True
        cursor = conn.cursor()
        
        # Разделяем SQL на отдельные команды
        sql_commands = []
        current_command = ""
        
        for line in sql_content.split('\n'):
            line = line.strip()
            if line.startswith('--'):  # Пропускаем комментарии
                continue
            current_command += line + " "
            if line.endswith(';'):
                sql_commands.append(current_command.strip())
                current_command = ""
        
        # Выполняем каждую команду отдельно
        for command in sql_commands:
            if command and not command.startswith('--'):
                try:
                    cursor.execute(command)
                except Exception as e:
                    print(f"⚠️ Предупреждение при выполнении SQL: {e}")
                    continue
        
        cursor.close()
        conn.close()
        
        print(f"✅ SQL файл {filename} выполнен успешно")
        
    except Exception as e:
        print(f"❌ Ошибка при выполнении SQL файла: {e}")
        sys.exit(1)

def add_system_tables(engine):
    """Добавление системных таблиц - исправленная версия для SQLAlchemy 2.0"""
    try:
        # Проверяем существование таблицы users
        with engine.connect() as connection:
            result = connection.execute(text("""
                SELECT EXISTS (
                    SELECT FROM information_schema.tables
                    WHERE table_schema = 'public'
                    AND table_name = 'users'
                )
            """))
            exists = result.scalar()
        
        if not exists:
            print("Создание системных таблиц...")
            
            # Используем engine.begin() для управления транзакциями
            with engine.begin() as connection:
                connection.execute(text("""
                    CREATE TABLE users (
                        id SERIAL PRIMARY KEY,
                        username VARCHAR(64) UNIQUE NOT NULL,
                        email VARCHAR(120) UNIQUE NOT NULL,
                        password_hash VARCHAR(256),
                        role INTEGER DEFAULT 1,
                        is_active BOOLEAN DEFAULT TRUE,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        last_login TIMESTAMP,
                        gosuslugi_id VARCHAR(100),
                        gosuslugi_data TEXT
                    )
                """))
                
                connection.execute(text("""
                    CREATE TABLE audit_log (
                        id SERIAL PRIMARY KEY,
                        user_id INTEGER REFERENCES users(id),
                        action VARCHAR(50) NOT NULL,
                        table_name VARCHAR(50) NOT NULL,
                        record_id VARCHAR(100) NOT NULL,
                        old_values TEXT,
                        new_values TEXT,
                        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        ip_address VARCHAR(45),
                        user_agent TEXT
                    )
                """))
                
                connection.execute(text("""
                    CREATE TABLE import_history (
                        id SERIAL PRIMARY KEY,
                        filename VARCHAR(255) NOT NULL,
                        file_type VARCHAR(10) NOT NULL,
                        imported_by INTEGER REFERENCES users(id),
                        imported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        record_count INTEGER,
                        status VARCHAR(20) DEFAULT 'completed',
                        errors TEXT
                    )
                """))
            
            print("✅ Системные таблицы созданы")
        else:
            print("✅ Системные таблицы уже существуют")
            
    except Exception as e:
        print(f"❌ Ошибка при создании системных таблиц: {e}")
        sys.exit(1)

def create_test_data(engine):
    """Создание тестовых данных - исправленная версия для SQLAlchemy 2.0"""
    try:
        with engine.connect() as connection:
            print("Создание тестовых данных...")
            
            result = connection.execute(text('SELECT COUNT(*) FROM "District"'))
            count = result.scalar()
        
        if count == 0:
            print("Добавление тестовых данных...")
            
            # Используем engine.begin() для вставки данных
            with engine.begin() as connection:
                districts = [
                    "Алейский район",
                    "Барнаульский район",
                    "Бийский район",
                    "Заринский район",
                    "Каменский район",
                    "Новоалтайский район",
                    "Рубцовский район",
                    "Славгородский район"
                ]
                
                for district in districts:
                    connection.execute(text(f'INSERT INTO "District" ("Name") VALUES (\'{district}\')'))
                
                settlements = [
                    ("Барнаул", "город", 2),
                    ("Бийск", "город", 3),
                    ("Рубцовск", "город", 7),
                    ("Новоалтайск", "город", 6),
                    ("Заринск", "город", 4),
                    ("Камень-на-Оби", "город", 5),
                    ("Славгород", "город", 8),
                    ("Алейск", "город", 1)
                ]
                
                for name, type_, district_id in settlements:
                    connection.execute(text(f"""
                        INSERT INTO "Settlement" ("Name", "Type", "PK_District")
                        VALUES ('{name}', '{type_}', {district_id})
                    """))
                
                school_types = [
                    "Общеобразовательная школа",
                    "Гимназия",
                    "Лицей",
                    "Школа-интернат",
                    "Коррекционная школа",
                    "Вечерняя школа",
                    "Кадетская школа"
                ]
                
                for school_type in school_types:
                    connection.execute(text(f'INSERT INTO "Type_of_School" ("Name") VALUES (\'{school_type}\')'))
                
                infrastructure = [
                    "Спортзал",
                    "Бассейн",
                    "Библиотека",
                    "Лаборатория",
                    "Компьютерный класс",
                    "Актовый зал",
                    "Столовая",
                    "Медицинский кабинет",
                    "Спортивная площадка",
                    "Мастерские"
                ]
                
                for item in infrastructure:
                    connection.execute(text(f'INSERT INTO "Infrastructure" ("Name") VALUES (\'{item}\')'))
                
                specializations = [
                    "Физико-математическая",
                    "Химико-биологическая",
                    "Гуманитарная",
                    "Лингвистическая",
                    "Техническая",
                    "Художественно-эстетическая",
                    "Спортивная",
                    "Информационные технологии"
                ]
                
                for specialization in specializations:
                    connection.execute(text(f'INSERT INTO "Specialization" ("Name") VALUES (\'{specialization}\')'))
                
                subjects = [
                    "Математика",
                    "Физика",
                    "Химия",
                    "Биология",
                    "Русский язык",
                    "Литература",
                    "История",
                    "Обществознание",
                    "География",
                    "Иностранный язык",
                    "Информатика"
                ]
                
                for subject in subjects:
                    connection.execute(text(f'INSERT INTO "Subject" ("Name") VALUES (\'{subject}\')'))
                
            print("✅ Тестовые данные созданы")
        else:
            print("✅ Тестовые данные уже существуют")
            
    except Exception as e:
        print(f"❌ Ошибка при создании тестовых данных: {e}")
        sys.exit(1)

def create_admin_user(engine):
    """Создание администратора - исправленная версия для SQLAlchemy 2.0"""
    try:
        from werkzeug.security import generate_password_hash
        
        with engine.connect() as connection:
            result = connection.execute(text("SELECT id FROM users WHERE username = 'admin'"))
            admin = result.fetchone()
        
        if not admin:
            print("Создание администратора...")
            password_hash = generate_password_hash('admin123')
            
            with engine.begin() as connection:
                connection.execute(text(f"""
                    INSERT INTO users (username, email, password_hash, role)
                    VALUES ('admin', 'admin@example.com', '{password_hash}', 5)
                """))
                
                test_users = [
                    ("parent", "parent@example.com", "parent123", 1),
                    ("teacher", "teacher@example.com", "teacher123", 2),
                    ("school_admin", "school_admin@example.com", "admin123", 3),
                    ("region_admin", "region_admin@example.com", "admin123", 4)
                ]
                
                for username, email, password, role in test_users:
                    password_hash = generate_password_hash(password)
                    connection.execute(text(f"""
                        INSERT INTO users (username, email, password_hash, role)
                        VALUES ('{username}', '{email}', '{password_hash}', {role})
                        ON CONFLICT (username) DO NOTHING
                    """))
            
            print("✅ Администратор и тестовые пользователи созданы")
            print("\n📋 Тестовые доступы:")
            print("   Администратор: admin / admin123")
            print("   Родитель: parent / parent123")
            print("   Учитель: teacher / teacher123")
            print("   Администратор школы: school_admin / admin123")
            print("   Администратор региона: region_admin / admin123")
        else:
            print("✅ Администратор уже существует")
            
    except Exception as e:
        print(f"❌ Ошибка при создании администратора: {e}")
        sys.exit(1)

def main():
    """Основная функция"""
    print("=" * 60)
    print("Инициализация базы данных Реестра школ Алтайского края")
    print("=" * 60)
    
    create_database()
    
    # Обновите пароль здесь на ваш реальный пароль PostgreSQL
    DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/school_registry"
    
    try:
        engine = create_engine(DATABASE_URL)
        
        # Тестируем подключение
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
        print("✅ Подключение к базе данных успешно")
        
        # Выполняем SQL схему
        sql_file = "schema.sql"
        if os.path.exists(sql_file):
            execute_sql_file(engine, sql_file)
        else:
            print(f"⚠️ Файл {sql_file} не найден")
        
        # Добавляем системные таблицы
        add_system_tables(engine)
        
        # Создаем тестовые данные
        create_test_data(engine)
        
        # Создаем администратора
        create_admin_user(engine)
        
        print("\n" + "=" * 60)
        print("✅ Инициализация базы данных завершена успешно!")
        print("=" * 60)
        print("\nСледующие шаги:")
        print("1. Запустите приложение: python app.py")
        print("2. Откройте в браузере: http://localhost:5000")
        print("3. Войдите под учетной записью администратора")
        
    except Exception as e:
        print(f"❌ Ошибка: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()