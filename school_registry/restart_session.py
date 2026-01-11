# reset_db.py
import sys
import os

# Добавляем текущую директорию в путь
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app import app
from models import db

def reset_database_session():
    """Полный сброс сессии базы данных"""
    print("🔄 Полный сброс сессии базы данных...")
    
    try:
        with app.app_context():
            # Явно закрываем все соединения
            db.session.remove()
            db.get_engine(app).dispose()
            
            # Создаем новое соединение
            from sqlalchemy import create_engine
            engine = create_engine(app.config['SQLALCHEMY_DATABASE_URI'])
            
            # Тестируем
            with engine.connect() as conn:
                result = conn.execute("SELECT 1").scalar()
                print(f"✅ Соединение восстановлено. Результат теста: {result}")
                
    except Exception as e:
        print(f"❌ Ошибка при сбросе сессии: {e}")
        import traceback
        traceback.print_exc()

if __name__ == '__main__':
    reset_database_session()