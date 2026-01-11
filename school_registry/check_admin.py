# from app import app, db
# from models import User
# from werkzeug.security import check_password_hash

# with app.app_context():
#     # Проверяем всех пользователей
#     users = User.query.all()
#     print(f"Всего пользователей в базе: {len(users)}")
    
#     for user in users:
#         print(f"\nID: {user.id}")
#         print(f"Имя пользователя: {user.username}")
#         print(f"Email: {user.email}")
#         print(f"Роль: {user.role}")
#         print(f"Активен: {user.is_active}")
#         print(f"Дата создания: {user.created_at}")
        
#         # Проверяем пароль
#         test_passwords = ['admin123', 'admin', 'password', '123456']
#         password_found = False
#         for test_password in test_passwords:
#             if check_password_hash(user.password_hash, test_password):
#                 print(f"✅ Пароль найден: '{test_password}'")
#                 password_found = True
#                 break
        
#         if not password_found:
#             print("❌ Пароль не распознан")


from app import app, db
from models import User

with app.app_context():
    # Удаляем существующего admin если есть
    admin = User.query.filter_by(username='admin').first()
    if admin:
        db.session.delete(admin)
        print("Старый пользователь admin удален")
    
    # Создаем нового администратора
    new_admin = User(
        username='admin',
        email='admin@alreg.ru',
        role=5,  # super_admin
        is_active=True
    )
    new_admin.set_password('admin123')  # Убедитесь, что используете правильный пароль
    
    db.session.add(new_admin)
    db.session.commit()
    
    print("✅ Новый администратор создан")
    print("👤 Имя пользователя: admin")
    print("🔑 Пароль: admin123")
    print("👑 Роль: Супер-администратор (5)")