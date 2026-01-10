#!/usr/bin/env python3
"""
Скрипт для заполнения базы данных тестовыми данными
"""

import os
import sys
from datetime import datetime, date
from faker import Faker
import random

# Добавляем текущую директорию в путь Python
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app import app, db
from models import (
    User, School, District, Settlement, TypeOfSchool, 
    Infrastructure, Specialization, Employee, Subject, 
    EducationProgram, Review, Inspection
)

fake = Faker('ru_RU')

def create_test_data():
    """Создание тестовых данных"""
    print("Создание тестовых данных...")
    
    with app.app_context():
        try:
            # Создаем районы Алтайского края
            print("Создание районов...")
            districts_data = [
                "Алейский район",
                "Барнаульский район", 
                "Бийский район",
                "Благовещенский район",
                "Бурлинский район",
                "Быстроистокский район",
                "Волчихинский район",
                "Егорьевский район",
                "Ельцовский район",
                "Завьяловский район",
                "Залесовский район",
                "Заринский район",
                "Змеиногорский район",
                "Зональный район",
                "Калманский район",
                "Каменский район",
                "Ключевский район",
                "Косихинский район",
                "Красногорский район",
                "Краснощековский район",
                "Крутихинский район",
                "Кулундинский район",
                "Курьинский район",
                "Кытмановский район",
                "Локтевский район",
                "Мамонтовский район",
                "Михайловский район",
                "Немецкий национальный район",
                "Новичихинский район",
                "Павловский район",
                "Панкрушихинский район",
                "Первомайский район",
                "Петропавловский район",
                "Поспелихинский район",
                "Ребрихинский район",
                "Родинский район",
                "Романовский район",
                "Рубцовский район",
                "Славгородский район",
                "Смоленский район",
                "Советский район",
                "Солонешенский район",
                "Солтонский район",
                "Суетский район",
                "Табунский район",
                "Тальменский район",
                "Тогульский район",
                "Топчихинский район",
                "Третьяковский район",
                "Троицкий район",
                "Тюменцевский район",
                "Угловский район",
                "Усть-Калманский район",
                "Усть-Пристанский район",
                "Хабарский район",
                "Целинный район",
                "Чарышский район",
                "Шелаболихинский район",
                "Шипуновский район",
            ]
            
            districts = []
            for name in districts_data:
                district = District.query.filter_by(Name=name).first()
                if not district:
                    district = District(Name=name)
                    db.session.add(district)
                districts.append(district)
            
            db.session.commit()
            print(f"✅ Создано {len(districts)} районов")
            
            # Создаем населенные пункты
            print("Создание населенных пунктов...")
            settlements_data = [
                # Города
                ("Барнаул", "город", "Барнаульский район"),
                ("Бийск", "город", "Бийский район"),
                ("Рубцовск", "город", "Рубцовский район"),
                ("Новоалтайск", "город", "Барнаульский район"),
                ("Заринск", "город", "Заринский район"),
                ("Камень-на-Оби", "город", "Каменский район"),
                ("Славгород", "город", "Славгородский район"),
                ("Алейск", "город", "Алейский район"),
                ("Яровое", "город", "Славгородский район"),
                ("Белокуриха", "город", "Быстроистокский район"),
                ("Горняк", "город", "Локтевский район"),
                ("Змеиногорск", "город", "Змеиногорский район"),
                # Поселки
                ("Тальменка", "поселок", "Тальменский район"),
                ("Павловск", "поселок", "Павловский район"),
                ("Шипуново", "поселок", "Шипуновский район"),
                ("Косиха", "поселок", "Косихинский район"),
                ("Поспелиха", "поселок", "Поспелихинский район"),
                ("Калманка", "поселок", "Калманский район"),
                ("Троицкое", "поселок", "Троицкий район"),
                ("Смоленское", "поселок", "Смоленский район"),
                ("Кулунда", "поселок", "Кулундинский район"),
                ("Благовещенка", "поселок", "Благовещенский район"),
                ("Михайловское", "поселок", "Михайловский район"),
                ("Волчиха", "поселок", "Волчихинский район"),
                ("Шелаболиха", "поселок", "Шелаболихинский район"),
                ("Красногорское", "поселок", "Красногорский район"),
                ("Солонешное", "поселок", "Солонешенский район"),
                # Села
                ("Ребриха", "село", "Ребрихинский район"),
                ("Мамонтово", "село", "Мамонтовский район"),
                ("Романово", "село", "Романовский район"),
                ("Быстрый Исток", "село", "Быстроистокский район"),
                ("Угловское", "село", "Угловский район"),
                ("Чарышское", "село", "Чарышский район"),
                ("Курья", "село", "Курьинский район"),
                ("Петропавловское", "село", "Петропавловский район"),
                ("Зональное", "село", "Зональный район"),
                ("Солтон", "село", "Солтонский район"),
                ("Кытманово", "село", "Кытмановский район"),
                ("Топчиха", "село", "Топчихинский район"),
                ("Усть-Калманка", "село", "Усть-Калманский район"),
                ("Хабары", "село", "Хабарский район"),
                ("Целинное", "село", "Целинный район"),
            ]
            
            settlements = []
            for name, type_, district_name in settlements_data:
                # Находим район по имени
                district = District.query.filter_by(Name=district_name).first()
                if district:
                    settlement = Settlement.query.filter_by(Name=name, Type=type_).first()
                    if not settlement:
                        settlement = Settlement(
                            Name=name,
                            Type=type_,
                            PK_District=district.PK_District
                        )
                        db.session.add(settlement)
                    settlements.append(settlement)
            
            db.session.commit()
            print(f"✅ Создано {len(settlements)} населенных пунктов")
            
            # Создаем типы школ (уже должны быть из init-db)
            print("Проверка типов школ...")
            school_types = TypeOfSchool.query.all()
            if not school_types:
                print("⚠️ Типы школ не найдены, создаем...")
                types_data = [
                    "Общеобразовательная школа",
                    "Гимназия", 
                    "Лицей",
                    "Школа-интернат",
                    "Коррекционная школа",
                    "Вечерняя школа",
                    "Кадетская школа",
                    "Школа с углубленным изучением предметов"
                ]
                for type_name in types_data:
                    school_type = TypeOfSchool(Name=type_name)
                    db.session.add(school_type)
                db.session.commit()
                school_types = TypeOfSchool.query.all()
            
            print(f"✅ Найдено {len(school_types)} типов школ")
            
            # Создаем инфраструктуру (уже должна быть из init-db)
            infrastructure_items = Infrastructure.query.all()
            if not infrastructure_items:
                print("⚠️ Инфраструктура не найдена, создаем...")
                infra_data = [
                    "Спортзал",
                    "Бассейн",
                    "Библиотека",
                    "Лаборатория",
                    "Компьютерный класс",
                    "Актовый зал",
                    "Столовая",
                    "Медицинский кабинет",
                    "Спортивная площадка",
                    "Мастерские",
                    "Теплица",
                    "Стадион",
                    "Тир",
                    "Танцевальный зал",
                    "Музей"
                ]
                for infra_name in infra_data:
                    infra = Infrastructure(Name=infra_name)
                    db.session.add(infra)
                db.session.commit()
                infrastructure_items = Infrastructure.query.all()
            
            print(f"✅ Найдено {len(infrastructure_items)} объектов инфраструктуры")
            
            # Создаем специализации (уже должны быть из init-db)
            specializations = Specialization.query.all()
            if not specializations:
                print("⚠️ Специализации не найдены, создаем...")
                spec_data = [
                    "Физико-математическая",
                    "Химико-биологическая",
                    "Гуманитарная",
                    "Лингвистическая",
                    "Техническая",
                    "Художественно-эстетическая",
                    "Спортивная",
                    "Информационные технологии",
                    "Естественно-научная",
                    "Социально-экономическая"
                ]
                for spec_name in spec_data:
                    spec = Specialization(Name=spec_name)
                    db.session.add(spec)
                db.session.commit()
                specializations = Specialization.query.all()
            
            print(f"✅ Найдено {len(specializations)} специализаций")
            
            # Создаем предметы (уже должны быть из init-db)
            subjects = Subject.query.all()
            if not subjects:
                print("⚠️ Предметы не найдены, создаем...")
                subjects_data = [
                    "Математика",
                    "Физика",
                    "Химия",
                    "Биология",
                    "Русский язык",
                    "Литература",
                    "История",
                    "Обществознание",
                    "География",
                    "Английский язык",
                    "Немецкий язык",
                    "Французский язык",
                    "Информатика",
                    "Технология",
                    "Физическая культура",
                    "ОБЖ",
                    "Музыка",
                    "ИЗО",
                    "Черчение"
                ]
                for subject_name in subjects_data:
                    subject = Subject(Name=subject_name)
                    db.session.add(subject)
                db.session.commit()
                subjects = Subject.query.all()
            
            print(f"✅ Найдено {len(subjects)} предметов")
            
            # Создаем образовательные программы
            print("Создание образовательных программ...")
            programs_data = [
                ("01.01", "Основная общеобразовательная программа", "основная"),
                ("01.02", "Программа углубленного изучения математики", "дополнительная"),
                ("01.03", "Программа углубленного изучения физики", "дополнительная"),
                ("01.04", "Программа углубленного изучения иностранных языков", "дополнительная"),
                ("01.05", "Программа художественно-эстетического развития", "дополнительная"),
                ("01.06", "Программа спортивной подготовки", "дополнительная"),
                ("01.07", "Программа информационных технологий", "дополнительная"),
                ("01.08", "Программа экологического образования", "дополнительная"),
                ("01.09", "Программа патриотического воспитания", "дополнительная"),
                ("01.10", "Программа инклюзивного образования", "основная"),
            ]
            
            programs = []
            for code, name, type_ in programs_data:
                program = EducationProgram.query.filter_by(Code_Designation=code).first()
                if not program:
                    program = EducationProgram(
                        Code_Designation=code,
                        Name=name,
                        Type=type_
                    )
                    db.session.add(program)
                programs.append(program)
            
            db.session.commit()
            print(f"✅ Создано {len(programs)} образовательных программ")
            
            # Создаем сотрудников (учителей)
            print("Создание сотрудников...")
            positions = [
                "Директор",
                "Заместитель директора по учебной работе",
                "Заместитель директора по воспитательной работе",
                "Учитель математики",
                "Учитель физики",
                "Учитель химии",
                "Учитель биологии",
                "Учитель русского языка и литературы",
                "Учитель истории",
                "Учитель английского языка",
                "Учитель информатики",
                "Учитель физической культуры",
                "Психолог",
                "Социальный педагог",
                "Библиотекарь",
                "Логопед",
            ]
            
            employees = []
            for i in range(100):
                first_name = fake.first_name_male() if i % 2 == 0 else fake.first_name_female()
                last_name = fake.last_name_male() if i % 2 == 0 else fake.last_name_female()
                middle_name = fake.middle_name_male() if i % 2 == 0 else fake.middle_name_female()
                
                employee = Employee(
                    Full_Name=f"{last_name} {first_name} {middle_name}",
                    Position=random.choice(positions),
                    Qualifications=fake.text(max_nb_chars=100),
                    Experience_Years=random.randint(1, 40)
                )
                db.session.add(employee)
                employees.append(employee)
            
            db.session.commit()
            print(f"✅ Создано {len(employees)} сотрудников")
            
            # Создаем школы (главное!)
            print("Создание школ...")
            
            # Шаблоны названий школ
            school_name_patterns = [
                "Средняя общеобразовательная школа №{num}",
                "Гимназия №{num}",
                "Лицей №{num}",
                "Школа-интернат №{num}",
                "Коррекционная школа №{num}",
                "Вечерняя школа №{num}",
                "Кадетская школа №{num}",
                "Школа с углубленным изучением {subject} №{num}",
                "{settlement}ская средняя школа",
                "{settlement}ская гимназия",
                "{settlement}ский лицей",
            ]
            
            # Предметы для углубленного изучения
            subjects_for_school = ["математики", "физики", "химии", "биологии", "информатики", 
                                  "английского языка", "русского языка", "истории", "обществознания"]
            
            schools = []
            for i in range(1, 201):  # Создаем 200 школ
                # Выбираем случайное поселение
                settlement = random.choice(settlements)
                
                # Выбираем случайный тип школы
                school_type = random.choice(school_types)
                
                # Формируем название школы
                pattern = random.choice(school_name_patterns)
                if "{subject}" in pattern:
                    school_name = pattern.format(
                        num=i, 
                        subject=random.choice(subjects_for_school)
                    )
                elif "{settlement}" in pattern:
                    # Убираем окончание у названия поселения
                    settlement_name = settlement.Name
                    if settlement_name.endswith('ск'):
                        base_name = settlement_name[:-2]
                    elif settlement_name.endswith('ое') or settlement_name.endswith('ая'):
                        base_name = settlement_name[:-2]
                    else:
                        base_name = settlement_name
                    
                    school_name = pattern.format(settlement=base_name)
                else:
                    school_name = pattern.format(num=i)
                
                # Создаем школу
                school = School(
                    Official_Name=school_name,
                    Legal_Adress=f"{settlement.Type} {settlement.Name}, {fake.street_address()}",
                    Phone=f"+7 (385{random.randint(2,9)}) {random.randint(100000, 999999)}",
                    Email=f"school{i}@altai.edu.ru",
                    Website=f"http://school{i}.altai.edu.ru",
                    Founding_Date=date(random.randint(1950, 2010), random.randint(1, 12), random.randint(1, 28)),
                    Number_of_Students=random.randint(50, 2000),
                    License=f"Лицензия №Л035-{random.randint(10000, 99999)} от {date.today().strftime('%d.%m.%Y')}",
                    Accreditation=f"Аккредитация №А{random.randint(100, 999)} от {date.today().strftime('%d.%m.%Y')}",
                    PK_Type_of_School=school_type.PK_Type_of_School,
                    PK_Settlement=settlement.PK_Settlement,
                    is_active=True,
                    created_by=1  # ID администратора
                )
                
                # Добавляем инфраструктуру
                num_infra = random.randint(3, 8)
                for infra in random.sample(infrastructure_items, num_infra):
                    school.infrastructure.append(infra)
                
                # Добавляем специализации (с вероятностью 70%)
                if random.random() < 0.7:
                    num_specs = random.randint(1, 3)
                    for spec in random.sample(specializations, min(num_specs, len(specializations))):
                        school.specializations.append(spec)
                
                # Добавляем образовательные программы
                num_programs = random.randint(1, 4)
                for program in random.sample(programs, min(num_programs, len(programs))):
                    school.programs.append(program)
                
                # Добавляем сотрудников
                num_employees = random.randint(10, 40)
                for employee in random.sample(employees, min(num_employees, len(employees))):
                    school.employees.append(employee)
                
                db.session.add(school)
                schools.append(school)
                
                if i % 50 == 0:
                    print(f"  Создано {i} школ...")
                    db.session.commit()
            
            db.session.commit()
            print(f"✅ Создано {len(schools)} школ")
            
            # Создаем отзывы
            print("Создание отзывов...")
            review_authors = ["Родитель", "Ученик", "Выпускник", "Житель", "Гость"]
            
            # Получаем всех пользователей
            users = User.query.all()
            
            for school in random.sample(schools, min(100, len(schools))):  # Отзывы для 100 школ
                num_reviews = random.randint(1, 10)
                for j in range(num_reviews):
                    user = random.choice(users) if users else None
                    
                    review = Review(
                        Author=user.username if user else random.choice(review_authors),
                        Text=fake.paragraph(nb_sentences=random.randint(2, 5)),
                        Date=date.today(),
                        Rating=random.randint(3, 5),
                        PK_School=school.PK_School,
                        user_id=user.id if user else None,
                        is_approved=True
                    )
                    db.session.add(review)
            
            db.session.commit()
            print("✅ Созданы отзывы")
            
            # Создаем проверки (инспекции)
            print("Создание проверок...")
            inspection_results = [
                "Нарушений не выявлено",
                "Выявлены незначительные нарушения",
                "Выявлены нарушения в документации",
                "Требуется устранение нарушений",
                "Проверка пройдена успешно"
            ]
            
            for school in random.sample(schools, min(50, len(schools))):  # Проверки для 50 школ
                num_inspections = random.randint(0, 3)
                for k in range(num_inspections):
                    inspection = Inspection(
                        Date=date(random.randint(2020, 2025), random.randint(1, 12), random.randint(1, 28)),
                        Result=random.choice(inspection_results),
                        Prescription_Number=f"ПР-{random.randint(1000, 9999)}",
                        PK_School=school.PK_School
                    )
                    db.session.add(inspection)
            
            db.session.commit()
            print("✅ Созданы проверки")
            
            print("\n" + "="*60)
            print("✅ База данных успешно заполнена тестовыми данными!")
            print("="*60)
            print(f"📊 Статистика:")
            print(f"   • Районов: {District.query.count()}")
            print(f"   • Населенных пунктов: {Settlement.query.count()}")
            print(f"   • Школ: {School.query.filter_by(is_active=True).count()}")
            print(f"   • Сотрудников: {Employee.query.count()}")
            print(f"   • Отзывов: {Review.query.filter_by(is_approved=True).count()}")
            print(f"   • Образовательных программ: {EducationProgram.query.count()}")
            
            # Создаем специально школы для отчетов из ТЗ
            create_special_schools_for_reports(settlements, school_types, specializations, infrastructure_items)
            
        except Exception as e:
            db.session.rollback()
            print(f"❌ Ошибка при заполнении базы данных: {e}")
            import traceback
            traceback.print_exc()
            sys.exit(1)

def create_special_schools_for_reports(settlements, school_types, specializations, infrastructure_items):
    """Создание специальных школ для тестирования отчетов из ТЗ"""
    print("\nСоздание специальных школ для отчетов...")
    
    # Находим нужные объекты
    bijsk = next((s for s in settlements if s.Name == "Бийск"), None)
    gimnazia_type = next((t for t in school_types if "Гимназия" in t.Name), None)
    library = next((i for i in infrastructure_items if "Библиотека" in i.Name), None)
    physics_spec = next((s for s in specializations if "физик" in s.Name.lower()), None)
    internat_type = next((t for t in school_types if "интернат" in t.Name.lower()), None)
    
    if not bijsk:
        print("⚠️ Населенный пункт Бийск не найден")
        return
    
    # 1. Школы в Бийске типа "гимназия" (для отчета 1)
    if gimnazia_type:
        for i in range(1, 6):
            school = School(
                Official_Name=f"Гимназия №{i} г. Бийска",
                Legal_Adress=f"г. Бийск, ул. {fake.street_name()}, {random.randint(1, 100)}",
                Phone=f"+7 (3854) {random.randint(100000, 999999)}",
                Email=f"gymnasium{i}@bijsk.edu.ru",
                Website=f"http://gymnasium{i}.bijsk.edu.ru",
                Founding_Date=date(1960 + i, 9, 1),
                Number_of_Students=random.randint(300, 800),
                License=f"Лицензия №Г{i:03d}",
                Accreditation=f"Аккредитация №А{i:03d}",
                PK_Type_of_School=gimnazia_type.PK_Type_of_School,
                PK_Settlement=bijsk.PK_Settlement,
                is_active=True,
                created_by=1
            )
            
            # Обязательно добавляем библиотеку
            if library:
                school.infrastructure.append(library)
            
            db.session.add(school)
        
        print("✅ Созданы гимназии в Бийске")
    
    # 2. Школы с библиотекой (для отчета 2)
    if library:
        # Создаем несколько школ с библиотекой в разных районах
        for i in range(1, 11):
            settlement = random.choice(settlements)
            school_type = random.choice(school_types)
            
            school = School(
                Official_Name=f"Школа с библиотекой №{i}",
                Legal_Adress=f"{settlement.Type} {settlement.Name}, ул. {fake.street_name()}, {random.randint(1, 100)}",
                Phone=f"+7 (385{random.randint(2,9)}) {random.randint(100000, 999999)}",
                Email=f"library_school{i}@altai.edu.ru",
                Founding_Date=date(1970 + i, 9, 1),
                Number_of_Students=random.randint(200, 600),
                PK_Type_of_School=school_type.PK_Type_of_School,
                PK_Settlement=settlement.PK_Settlement,
                is_active=True,
                created_by=1
            )
            
            # Обязательно добавляем библиотеку
            school.infrastructure.append(library)
            
            db.session.add(school)
        
        print("✅ Созданы школы с библиотекой")
    
    # 3. Школы с углубленным изучением физики (для отчета 5)
    if physics_spec:
        for i in range(1, 8):
            settlement = random.choice(settlements)
            
            school = School(
                Official_Name=f"Школа с углубленным изучением физики №{i}",
                Legal_Adress=f"{settlement.Type} {settlement.Name}, ул. {fake.street_name()}, {random.randint(1, 100)}",
                Phone=f"+7 (385{random.randint(2,9)}) {random.randint(100000, 999999)}",
                Email=f"physics_school{i}@altai.edu.ru",
                Founding_Date=date(1980 + i, 9, 1),
                Number_of_Students=random.randint(250, 700),
                PK_Type_of_School=random.choice(school_types).PK_Type_of_School,
                PK_Settlement=settlement.PK_Settlement,
                is_active=True,
                created_by=1
            )
            
            # Добавляем специализацию по физике
            school.specializations.append(physics_spec)
            
            # Добавляем лабораторию
            lab = next((i for i in infrastructure_items if "Лаборатория" in i.Name), None)
            if lab:
                school.infrastructure.append(lab)
            
            db.session.add(school)
        
        print("✅ Созданы школы с углубленным изучением физики")
    
    # 4. Школы-интернаты с >200 учащихся (для отчета 6)
    if internat_type:
        for i in range(1, 6):
            settlement = random.choice(settlements)
            
            # Создаем интернаты с большим количеством учащихся
            students = random.randint(250, 500)  # Все >200
            
            school = School(
                Official_Name=f"Школа-интернат №{i}",
                Legal_Adress=f"{settlement.Type} {settlement.Name}, ул. {fake.street_name()}, {random.randint(1, 100)}",
                Phone=f"+7 (385{random.randint(2,9)}) {random.randint(100000, 999999)}",
                Email=f"internat{i}@altai.edu.ru",
                Founding_Date=date(1965 + i, 9, 1),
                Number_of_Students=students,
                PK_Type_of_School=internat_type.PK_Type_of_School,
                PK_Settlement=settlement.PK_Settlement,
                is_active=True,
                created_by=1
            )
            
            db.session.add(school)
        
        print("✅ Созданы школы-интернаты с >200 учащихся")
    
    db.session.commit()

def main():
    """Основная функция"""
    print("="*60)
    print("Заполнение базы данных тестовыми данными")
    print("="*60)
    
    # Устанавливаем Faker
    try:
        import faker
    except ImportError:
        print("Установка библиотеки Faker...")
        os.system("pip install faker")
        import faker
    
    create_test_data()
    
    print("\n" + "="*60)
    print("✅ Готово! База данных заполнена тестовыми данными.")
    print("📊 Теперь в системе есть:")
    print("   • 200+ школ в Алтайском крае")
    print("   • Все виды отчетов из ТЗ")
    print("   • Тестовые пользователи")
    print("\n🚀 Запустите приложение: python app.py")
    print("👤 Войдите как администратор: admin / admin123")
    print("="*60)

if __name__ == "__main__":
    main()