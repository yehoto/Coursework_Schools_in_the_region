import os
from datetime import timedelta
from dotenv import load_dotenv

load_dotenv()

basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-production'
    
    # PostgreSQL конфигурация
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'postgresql://postgres:password@localhost:5432/school_registry'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_pre_ping': True,
        'pool_recycle': 300,
    }
    
    # Настройки загрузки файлов
    UPLOAD_FOLDER = os.path.join(basedir, 'uploads')
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024
    
    # Сессии
    PERMANENT_SESSION_LIFETIME = timedelta(hours=2)
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'Lax'
    
    # Безопасность
    WTF_CSRF_ENABLED = True
    WTF_CSRF_SECRET_KEY = SECRET_KEY
    
    # Роли пользователей
    ROLES = {
        'guest': 0,
        'parent': 1,
        'teacher': 2,
        'school_admin': 3,
        'region_admin': 4,
        'super_admin': 5
    }
    
    # Настройки приложения
    SCHOOLS_PER_PAGE = 20
    DEFAULT_PAGE = 1
    
    # Интеграция с госуслугами (заглушки)
    GOSUSLUGI_APP_ID = os.environ.get('GOSUSLUGI_APP_ID', 'demo-app-id')
    GOSUSLUGI_REDIRECT_URI = os.environ.get('GOSUSLUGI_REDIRECT_URI', 
        'http://localhost:5000/auth/gosuslugi/callback')
    
    @staticmethod
    def init_app(app):
        # Создаем необходимые директории
        directories = [
            app.config['UPLOAD_FOLDER'],
            os.path.join(app.config['UPLOAD_FOLDER'], 'backups'),
            os.path.join(app.config['UPLOAD_FOLDER'], 'imports'),
            os.path.join(basedir, 'instance'),
            os.path.join(basedir, 'static', 'css'),
            os.path.join(basedir, 'static', 'js'),
            os.path.join(basedir, 'static', 'images')
        ]
        for directory in directories:
            try:
                if not os.path.exists(directory):
                    os.makedirs(directory, exist_ok=True)
            except Exception:
                pass

class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_ECHO = False
    
    @staticmethod
    def init_app(app):
        Config.init_app(app)

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'postgresql://localhost/school_registry_test'
    WTF_CSRF_ENABLED = False

class ProductionConfig(Config):
    DEBUG = False
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')
    if not SQLALCHEMY_DATABASE_URI:
        raise ValueError("DATABASE_URL environment variable is required for production")
    SESSION_COOKIE_SECURE = True
    
    @classmethod
    def init_app(cls, app):
        Config.init_app(app)
        
        # Логирование в production
        import logging
        from logging.handlers import RotatingFileHandler
        
        if not app.debug:
            if not os.path.exists('logs'):
                os.mkdir('logs')
            file_handler = RotatingFileHandler(
                'logs/school_registry.log',
                maxBytes=10240,
                backupCount=10
            )
            file_handler.setFormatter(logging.Formatter(
                '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
            ))
            file_handler.setLevel(logging.INFO)
            app.logger.addHandler(file_handler)
            app.logger.setLevel(logging.INFO)
            app.logger.info('School Registry startup')

config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}