#!/usr/bin/env python3
"""
Скрипт для запуска приложения Реестра школ Алтайского края
"""

import os
import sys
from app import app

if __name__ == '__main__':
    print("=" * 60)
    print("Реестр школ Алтайского края")
    print("=" * 60)
    print()
    print("Проверка зависимостей...")
    
    # Проверяем наличие PostgreSQL
    try:
        import psycopg2
        print("✅ PostgreSQL драйвер установлен")
    except ImportError:
        print("❌ Ошибка: psycopg2 не установлен")
        print("Установите его командой: pip install psycopg2-binary")
        sys.exit(1)
    
    # Проверяем наличие .env файла
    if not os.path.exists('.env'):
        print("⚠️  Предупреждение: .env файл не найден")
        print("Создаю .env файл с настройками по умолчанию...")
        
        with open('.env', 'w', encoding='utf-8') as f:
            f.write('SECRET_KEY=ваш-секретный-ключ-измените-в-production\n')
            f.write('DATABASE_URL=postgresql://postgres:password@localhost:5432/school_registry\n')
            f.write('FLASK_APP=app.py\n')
            f.write('FLASK_ENV=development\n')
            f.write('DEBUG=True\n')
        
        print("✅ .env файл создан")
        print("⚠️  ВНИМАНИЕ: Измените пароль в DATABASE_URL на ваш пароль от PostgreSQL!")
    
    print()
    print("Запуск приложения...")
    print("Откройте в браузере: http://localhost:5000")
    print()
    
    app.run(debug=True, host='0.0.0.0', port=5000)