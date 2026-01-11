# check_db.py
from app import app, db
from sqlalchemy import text
import sys

def check_and_fix_database():
    """Проверка и исправление структуры базы данных"""
    print("🔍 Проверка структуры базы данных...")
    
    try:
        with app.app_context():
            conn = db.engine.connect()
            
            # 1. Проверяем все таблицы с двойными кавычками
            print("\n📋 Таблицы с двойными кавычками:")
            result = conn.execute(text("""
                SELECT tablename 
                FROM pg_tables 
                WHERE schemaname = 'public' 
                AND tablename LIKE '"%"'
                ORDER BY tablename;
            """))
            
            quoted_tables = [row[0] for row in result]
            for table in quoted_tables:
                print(f"  - {table}")
            
            # 2. Проверяем таблицу "Review"
            print("\n🔎 Детальная проверка таблицы \"Review\":")
            result = conn.execute(text("""
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns 
                WHERE table_name = 'Review' 
                AND table_schema = 'public'
                ORDER BY ordinal_position;
            """))
            
            print("Структура таблицы \"Review\":")
            for row in result:
                print(f"  {row[0]}: {row[1]} ({'NULL' if row[2] == 'YES' else 'NOT NULL'})")
            
            # 3. Проверяем, нужны ли исправления
            print("\n⚙️  Проверяем необходимые исправления...")
            
            # Список обязательных колонок для "Review"
            required_review_columns = [
                ('is_approved', 'BOOLEAN'),
                ('moderated_by', 'INTEGER'),
                ('moderated_at', 'TIMESTAMP'),
                ('moderation_comment', 'TEXT'),
                ('is_deleted', 'BOOLEAN'),
                ('deleted_by', 'INTEGER'),
                ('deleted_at', 'TIMESTAMP'),
                ('deletion_reason', 'TEXT')
            ]
            
            for column_name, data_type in required_review_columns:
                result = conn.execute(text(f"""
                    SELECT column_name 
                    FROM information_schema.columns 
                    WHERE table_name = 'Review' 
                    AND column_name = '{column_name}'
                """))
                
                if result.fetchone() is None:
                    print(f"❌ Отсутствует колонка: {column_name}")
                    
                    # Предлагаем добавить
                    if input(f"Добавить колонку {column_name} ({data_type})? (y/n): ").lower() == 'y':
                        try:
                            if data_type == 'BOOLEAN':
                                conn.execute(text(f'ALTER TABLE "Review" ADD COLUMN {column_name} BOOLEAN DEFAULT false'))
                            elif data_type == 'INTEGER':
                                conn.execute(text(f'ALTER TABLE "Review" ADD COLUMN {column_name} INTEGER'))
                            elif data_type == 'TIMESTAMP':
                                conn.execute(text(f'ALTER TABLE "Review" ADD COLUMN {column_name} TIMESTAMP'))
                            elif data_type == 'TEXT':
                                conn.execute(text(f'ALTER TABLE "Review" ADD COLUMN {column_name} TEXT'))
                            print(f"✅ Колонка {column_name} добавлена")
                        except Exception as e:
                            print(f"❌ Ошибка при добавлении: {e}")
                else:
                    print(f"✅ Колонка {column_name} присутствует")
            
            # 4. Проверяем таблицу "Inspection"
            print("\n🔎 Детальная проверка таблицы \"Inspection\":")
            result = conn.execute(text("""
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns 
                WHERE table_name = 'Inspection' 
                AND table_schema = 'public'
                ORDER BY ordinal_position;
            """))
            
            print("Структура таблицы \"Inspection\":")
            for row in result:
                print(f"  {row[0]}: {row[1]} ({'NULL' if row[2] == 'YES' else 'NOT NULL'})")
            
            # Список обязательных колонок для "Inspection"
            required_inspection_columns = [
                ('has_violations', 'BOOLEAN'),
                ('violation_type', 'VARCHAR(200)'),
                ('is_resolved', 'BOOLEAN'),
                ('resolution_date', 'DATE'),
                ('description', 'TEXT')
            ]
            
            for column_name, data_type in required_inspection_columns:
                result = conn.execute(text(f"""
                    SELECT column_name 
                    FROM information_schema.columns 
                    WHERE table_name = 'Inspection' 
                    AND column_name = '{column_name}'
                """))
                
                if result.fetchone() is None:
                    print(f"❌ Отсутствует колонка: {column_name}")
                    
                    # Предлагаем добавить
                    if input(f"Добавить колонку {column_name} ({data_type})? (y/n): ").lower() == 'y':
                        try:
                            if data_type == 'BOOLEAN':
                                conn.execute(text(f'ALTER TABLE "Inspection" ADD COLUMN {column_name} BOOLEAN DEFAULT false'))
                            elif data_type == 'VARCHAR(200)':
                                conn.execute(text(f'ALTER TABLE "Inspection" ADD COLUMN {column_name} VARCHAR(200)'))
                            elif data_type == 'DATE':
                                conn.execute(text(f'ALTER TABLE "Inspection" ADD COLUMN {column_name} DATE'))
                            elif data_type == 'TEXT':
                                conn.execute(text(f'ALTER TABLE "Inspection" ADD COLUMN {column_name} TEXT'))
                            print(f"✅ Колонка {column_name} добавлена")
                        except Exception as e:
                            print(f"❌ Ошибка при добавлении: {e}")
                else:
                    print(f"✅ Колонка {column_name} присутствует")
            
            conn.close()
            print("\n✅ Проверка завершена!")
            
    except Exception as e:
        print(f"❌ Ошибка при проверке базы данных: {e}")
        sys.exit(1)

if __name__ == '__main__':
    check_and_fix_database()