# fix_migrations.py
from app import app, db
from sqlalchemy import text
import sys

def fix_table_names():
    """Исправляем названия таблиц - работаем только с таблицами в двойных кавычках"""
    print("Исправление названий таблиц...")
    
    try:
        with app.app_context():
            conn = db.engine.connect()
            
            # 1. Проверяем, есть ли таблица "Review" (с кавычками)
            print("\n1. Проверка таблицы \"Review\"...")
            result = conn.execute(text("""
                SELECT EXISTS (
                    SELECT 1 FROM pg_tables 
                    WHERE schemaname = 'public' 
                    AND tablename = 'Review'
                );
            """))
            
            exists = result.fetchone()[0]
            print(f"Таблица \"Review\" существует: {exists}")
            
            if exists:
                # Проверяем колонки в "Review"
                result = conn.execute(text("""
                    SELECT column_name, data_type 
                    FROM information_schema.columns 
                    WHERE table_name = 'Review' 
                    AND table_schema = 'public'
                    ORDER BY ordinal_position;
                """))
                
                print("\nКолонки в таблице \"Review\":")
                for row in result:
                    print(f"  {row[0]}: {row[1]}")
                
                # Добавляем недостающие колонки в "Review"
                review_columns = [
                    ("is_deleted", "BOOLEAN DEFAULT false"),
                    ("deleted_by", "INTEGER"),
                    ("deleted_at", "TIMESTAMP"),
                    ("deletion_reason", "TEXT")
                ]
                
                print("\nДобавление колонок в \"Review\"...")
                for column_name, column_def in review_columns:
                    try:
                        # Проверяем, существует ли колонка
                        check_result = conn.execute(text(f"""
                            SELECT column_name 
                            FROM information_schema.columns 
                            WHERE table_name = 'Review' 
                            AND column_name = '{column_name}'
                        """))
                        
                        if check_result.fetchone() is None:
                            print(f"Добавляем {column_name} в \"Review\"...")
                            conn.execute(text(f'ALTER TABLE "Review" ADD COLUMN {column_name} {column_def}'))
                        else:
                            print(f"Колонка {column_name} уже существует в \"Review\"")
                    except Exception as e:
                        print(f"Ошибка при добавлении {column_name}: {e}")
            
            # 2. Проверяем, есть ли таблица "Inspection" (с кавычками)
            print("\n\n2. Проверка таблицы \"Inspection\"...")
            result = conn.execute(text("""
                SELECT EXISTS (
                    SELECT 1 FROM pg_tables 
                    WHERE schemaname = 'public' 
                    AND tablename = 'Inspection'
                );
            """))
            
            exists = result.fetchone()[0]
            print(f"Таблица \"Inspection\" существует: {exists}")
            
            if exists:
                # Проверяем колонки в "Inspection"
                result = conn.execute(text("""
                    SELECT column_name, data_type 
                    FROM information_schema.columns 
                    WHERE table_name = 'Inspection' 
                    AND table_schema = 'public'
                    ORDER BY ordinal_position;
                """))
                
                print("\nКолонки в таблице \"Inspection\":")
                for row in result:
                    print(f"  {row[0]}: {row[1]}")
                
                # Добавляем недостающие колонки в "Inspection"
                inspection_columns = [
                    ("has_violations", "BOOLEAN DEFAULT false"),
                    ("violation_type", "VARCHAR(200)"),
                    ("is_resolved", "BOOLEAN DEFAULT false"),
                    ("resolution_date", "DATE"),
                    ("description", "TEXT")
                ]
                
                print("\nДобавление колонок в \"Inspection\"...")
                for column_name, column_def in inspection_columns:
                    try:
                        # Проверяем, существует ли колонка
                        check_result = conn.execute(text(f"""
                            SELECT column_name 
                            FROM information_schema.columns 
                            WHERE table_name = 'Inspection' 
                            AND column_name = '{column_name}'
                        """))
                        
                        if check_result.fetchone() is None:
                            print(f"Добавляем {column_name} в \"Inspection\"...")
                            conn.execute(text(f'ALTER TABLE "Inspection" ADD COLUMN {column_name} {column_def}'))
                        else:
                            print(f"Колонка {column_name} уже существует в \"Inspection\"")
                    except Exception as e:
                        print(f"Ошибка при добавлении {column_name}: {e}")
            
            conn.close()
            print("\n✅ Исправление завершено!")
            
    except Exception as e:
        print(f"❌ Ошибка: {e}")
        sys.exit(1)

if __name__ == '__main__':
    fix_table_names()