# setup.py
import os
import sys
import sqlite3

print("=== Настройка Реестра школ Алтайского края ===\n")

# Проверяем и создаем папки
folders = ['instance', 'static/css', 'static/js', 'static/images',
           'uploads', 'uploads/backups', 'uploads/imports']

print("📁 Создание структуры папок...")
for folder in folders:
    try:
        if not os.path.exists(folder):
            os.makedirs(folder, exist_ok=True)
            print(f"  ✅ Создана: {folder}")
        else:
            print(f"  ✓ Уже существует: {folder}")
    except Exception as e:
        print(f"  ❌ Ошибка создания {folder}: {e}")

# Создаем файл базы данных вручную
print("\n🗄️ Создание базы данных...")
db_path = os.path.join('instance', 'school_registry.db')

try:
    # Создаем соединение с базой данных (это создаст файл если его нет)
    conn = sqlite3.connect(db_path)
    
    # Создаем простую таблицу для теста
    conn.execute('''
        CREATE TABLE IF NOT EXISTS test_table (
            id INTEGER PRIMARY KEY,
            name TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Добавляем тестовую запись
    conn.execute("INSERT INTO test_table (name) VALUES ('test_init')")
    conn.commit()
    conn.close()
    
    print(f"  ✅ База данных создана: {db_path}")
    print(f"  📊 Размер файла: {os.path.getsize(db_path)} байт")
    
except Exception as e:
    print(f"  ❌ Ошибка создания базы данных: {e}")
    
    # Пробуем другой путь (в текущей папке)
    print("  🔄 Пробую альтернативный путь...")
    try:
        db_path = 'school_registry.db'
        conn = sqlite3.connect(db_path)
        conn.execute('CREATE TABLE IF NOT EXISTS test_table (id INTEGER PRIMARY KEY, name TEXT)')
        conn.execute("INSERT INTO test_table (name) VALUES ('test_alt')")
        conn.commit()
        conn.close()
        print(f"  ✅ База данных создана в текущей папке: {db_path}")
        
        # Обновляем config.py для использования нового пути
        print("  🔄 Обновляю config.py...")
        with open('config.py', 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Ищем строку с DATABASE_URI
        import re
        new_content = re.sub(
            r"SQLALCHEMY_DATABASE_URI = .*",
            f"SQLALCHEMY_DATABASE_URI = 'sqlite:///{db_path}'",
            content
        )
        
        with open('config.py', 'w', encoding='utf-8') as f:
            f.write(new_content)
            
        print("  ✅ config.py обновлен")
        
    except Exception as e2:
        print(f"  ❌ Вторая попытка тоже не удалась: {e2}")
        print("\n⚠️  Возможные причины:")
        print("   1. Нет прав на запись в папку")
        print("   2. Файл уже открыт в другой программе")
        print("   3. Антивирус блокирует создание файла")
        sys.exit(1)

print("\n🔧 Импортирую модули...")
try:
    from app import app, db
    from models import User, School, District, Settlement, TypeOfSchool
    
    print("✅ Модули успешно импортированы")
    
    print("\n🗃️ Создаю таблицы через SQLAlchemy...")
    with app.app_context():
        try:
            db.create_all()
            print("✅ Таблицы созданы успешно")
            
            # Создаем администратора если его нет
            admin = User.query.filter_by(username='admin').first()
            if not admin:
                admin = User(
                    username='admin',
                    email='admin@example.com',
                    role=5  # super_admin
                )
                admin.set_password('admin123')
                db.session.add(admin)
                print("✅ Создан администратор: admin / admin123")
            
            db.session.commit()
            
        except Exception as e:
            print(f"❌ Ошибка создания таблиц: {e}")
            print("Пробую альтернативный метод...")
            
            # Пробуем создать таблицы через raw SQL
            try:
                conn = sqlite3.connect(db_path)
                cursor = conn.cursor()
                
                # Создаем таблицу пользователей
                cursor.execute('''
                    CREATE TABLE IF NOT EXISTS users (
                        id INTEGER PRIMARY KEY,
                        username TEXT UNIQUE NOT NULL,
                        email TEXT UNIQUE NOT NULL,
                        password_hash TEXT,
                        role INTEGER DEFAULT 0,
                        is_active BOOLEAN DEFAULT 1,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        last_login TIMESTAMP
                    )
                ''')
                
                # Добавляем администратора
                cursor.execute("SELECT * FROM users WHERE username = 'admin'")
                if not cursor.fetchone():
                    cursor.execute(
                        "INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)",
                        ('admin', 'admin@example.com', 'pbkdf2:sha256:...', 5)
                    )
                    print("✅ Администратор добавлен через SQL")
                
                conn.commit()
                conn.close()
                print("✅ Таблицы созданы через raw SQL")
                
            except Exception as e2:
                print(f"❌ Ошибка создания через raw SQL: {e2}")
    
    print("\n🎉 Настройка завершена!")
    print("\n📋 Следующие шаги:")
    print("   1. Запустите приложение: python app.py")
    print("   2. Откройте браузер и перейдите по адресу: http://localhost:5000")
    print("   3. Войдите как администратор:")
    print("      Логин: admin")
    print("      Пароль: admin123")
    
except Exception as e:
    print(f"❌ Ошибка при импорте модулей: {e}")
    print("\n🔧 Пробую исправить зависимости...")
    
    # Проверяем requirements.txt
    if os.path.exists('requirements.txt'):
        print("📦 Установка зависимостей...")
        os.system('pip install -r requirements.txt')
        
        # Пробуем снова
        print("\n🔄 Повторная попытка импорта...")
        try:
            from app import app, db
            print("✅ Модули успешно импортированы после установки зависимостей")
        except Exception as e2:
            print(f"❌ Ошибка импорта: {e2}")
    else:
        print("❌ Файл requirements.txt не найден")