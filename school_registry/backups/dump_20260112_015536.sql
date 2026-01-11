--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS school_registry;
--
-- Name: school_registry; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE school_registry WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru-RU';


\connect school_registry

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: District; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."District" (
    "PK_District" bigint NOT NULL,
    "Name" character varying(255) NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: District_PK_District_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."District_PK_District_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: District_PK_District_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."District_PK_District_seq" OWNED BY public."District"."PK_District";


--
-- Name: Education_Program; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Education_Program" (
    "Code_Designation" character varying(50) NOT NULL,
    "Name" character varying(255) NOT NULL,
    "Type" character varying(20) NOT NULL,
    "PK_Education_Program" bigint NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: Education_Program_PK_Education_Program_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Education_Program_PK_Education_Program_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Education_Program_PK_Education_Program_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Education_Program_PK_Education_Program_seq" OWNED BY public."Education_Program"."PK_Education_Program";


--
-- Name: Employee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Employee" (
    "PK_Employee" bigint NOT NULL,
    "Full_Name" character varying(100) NOT NULL,
    "Position" character varying(50) NOT NULL,
    "Qualifications" text,
    "Experience_Years" integer
)
WITH (autovacuum_enabled='true');


--
-- Name: Employee_PK_Employee_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Employee_PK_Employee_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Employee_PK_Employee_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Employee_PK_Employee_seq" OWNED BY public."Employee"."PK_Employee";


--
-- Name: Employee_Subject_Competence; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Employee_Subject_Competence" (
    "PK_Subject" bigint NOT NULL,
    "PK_Employee" bigint NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: Infrastructure; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Infrastructure" (
    "PK_Infrastructure" bigint NOT NULL,
    "Name" character varying(50) NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: Infrastructure_PK_Infrastructure_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Infrastructure_PK_Infrastructure_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Infrastructure_PK_Infrastructure_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Infrastructure_PK_Infrastructure_seq" OWNED BY public."Infrastructure"."PK_Infrastructure";


--
-- Name: Inspection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Inspection" (
    "PK_Inspection" bigint NOT NULL,
    "Date" date NOT NULL,
    "Result" text NOT NULL,
    "Prescription_Number" character varying(50) NOT NULL,
    "PK_School" bigint,
    has_violations boolean DEFAULT false,
    violation_type character varying(200),
    is_resolved boolean DEFAULT false,
    resolution_date date,
    description text
)
WITH (autovacuum_enabled='true');


--
-- Name: Inspection_PK_Inspection_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Inspection_PK_Inspection_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Inspection_PK_Inspection_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Inspection_PK_Inspection_seq" OWNED BY public."Inspection"."PK_Inspection";


--
-- Name: Review; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Review" (
    "PK_Review" bigint NOT NULL,
    "Author" character varying(100),
    "Text" text,
    "Date" date NOT NULL,
    "Rating" integer NOT NULL,
    "PK_School" bigint,
    user_id integer,
    is_approved boolean DEFAULT true,
    moderated_by integer,
    moderated_at timestamp without time zone,
    moderation_comment text,
    is_deleted boolean DEFAULT false,
    deleted_by integer,
    deleted_at timestamp without time zone,
    deletion_reason text
)
WITH (autovacuum_enabled='true');


--
-- Name: Review_PK_Review_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Review_PK_Review_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Review_PK_Review_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Review_PK_Review_seq" OWNED BY public."Review"."PK_Review";


--
-- Name: School; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."School" (
    "Official_Name" character varying(255) NOT NULL,
    "Legal_Adress" text NOT NULL,
    "Phone" character varying(20) NOT NULL,
    "Email" character varying(100),
    "Website" character varying(200),
    "Founding_Date" date,
    "Number_of_Students" bigint,
    "License" text,
    "Accreditation" text,
    "PK_School" bigint NOT NULL,
    "PK_Type_of_School" bigint NOT NULL,
    "PK_Settlement" bigint,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer
)
WITH (autovacuum_enabled='true');


--
-- Name: School_Employee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."School_Employee" (
    "PK_School" bigint NOT NULL,
    "PK_Employee" bigint NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: School_Infrastructure; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."School_Infrastructure" (
    "PK_Infrastructure" bigint NOT NULL,
    "PK_School" bigint NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: School_PK_School_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."School_PK_School_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: School_PK_School_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."School_PK_School_seq" OWNED BY public."School"."PK_School";


--
-- Name: School_Program_Implementation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."School_Program_Implementation" (
    "PK_School" bigint NOT NULL,
    "PK_Education_Program" bigint NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: School_Specialization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."School_Specialization" (
    "PK_Specialization" bigint NOT NULL,
    "PK_School" bigint NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: Settlement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Settlement" (
    "Name" character varying(100) NOT NULL,
    "Type" character varying(20) NOT NULL,
    "PK_Settlement" bigint NOT NULL,
    "PK_District" bigint
)
WITH (autovacuum_enabled='true');


--
-- Name: Settlement_PK_Settlement_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Settlement_PK_Settlement_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Settlement_PK_Settlement_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Settlement_PK_Settlement_seq" OWNED BY public."Settlement"."PK_Settlement";


--
-- Name: Specialization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Specialization" (
    "PK_Specialization" bigint NOT NULL,
    "Name" character varying(50) NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: Specialization_PK_Specialization_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Specialization_PK_Specialization_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Specialization_PK_Specialization_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Specialization_PK_Specialization_seq" OWNED BY public."Specialization"."PK_Specialization";


--
-- Name: Subject; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Subject" (
    "PK_Subject" bigint NOT NULL,
    "Name" character varying(100) NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: Subject_PK_Subject_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Subject_PK_Subject_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Subject_PK_Subject_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Subject_PK_Subject_seq" OWNED BY public."Subject"."PK_Subject";


--
-- Name: Type_of_School; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Type_of_School" (
    "PK_Type_of_School" bigint NOT NULL,
    "Name" character varying(255) NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: Type_of_School_PK_Type_of_School_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Type_of_School_PK_Type_of_School_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Type_of_School_PK_Type_of_School_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Type_of_School_PK_Type_of_School_seq" OWNED BY public."Type_of_School"."PK_Type_of_School";


--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_log (
    id integer NOT NULL,
    user_id integer,
    action character varying(50) NOT NULL,
    table_name character varying(50) NOT NULL,
    record_id character varying(100) NOT NULL,
    old_values text,
    new_values text,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ip_address character varying(45),
    user_agent text
);


--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_log_id_seq OWNED BY public.audit_log.id;


--
-- Name: data_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_versions (
    pk_version integer NOT NULL,
    table_name character varying(100) NOT NULL,
    record_id integer NOT NULL,
    action character varying(20) NOT NULL,
    data_before json,
    data_after json,
    changed_by integer,
    changed_at timestamp without time zone,
    created_at timestamp without time zone
);


--
-- Name: data_versions_pk_version_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_versions_pk_version_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_versions_pk_version_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_versions_pk_version_seq OWNED BY public.data_versions.pk_version;


--
-- Name: import_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.import_history (
    id integer NOT NULL,
    filename character varying(255) NOT NULL,
    file_type character varying(10) NOT NULL,
    imported_by integer,
    imported_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    record_count integer,
    status character varying(20) DEFAULT 'completed'::character varying,
    errors text
);


--
-- Name: import_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.import_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.import_history_id_seq OWNED BY public.import_history.id;


--
-- Name: school_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.school_versions (
    pk_version integer NOT NULL,
    pk_school integer NOT NULL,
    version_number integer NOT NULL,
    action character varying(50) NOT NULL,
    old_data text,
    new_data text,
    changed_by integer,
    changed_at timestamp without time zone
);


--
-- Name: school_versions_pk_version_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.school_versions_pk_version_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: school_versions_pk_version_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.school_versions_pk_version_seq OWNED BY public.school_versions.pk_version;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    email character varying(120) NOT NULL,
    password_hash character varying(256),
    role integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_login timestamp without time zone,
    gosuslugi_id character varying(100),
    gosuslugi_data text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: District PK_District; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."District" ALTER COLUMN "PK_District" SET DEFAULT nextval('public."District_PK_District_seq"'::regclass);


--
-- Name: Education_Program PK_Education_Program; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Education_Program" ALTER COLUMN "PK_Education_Program" SET DEFAULT nextval('public."Education_Program_PK_Education_Program_seq"'::regclass);


--
-- Name: Employee PK_Employee; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Employee" ALTER COLUMN "PK_Employee" SET DEFAULT nextval('public."Employee_PK_Employee_seq"'::regclass);


--
-- Name: Infrastructure PK_Infrastructure; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Infrastructure" ALTER COLUMN "PK_Infrastructure" SET DEFAULT nextval('public."Infrastructure_PK_Infrastructure_seq"'::regclass);


--
-- Name: Inspection PK_Inspection; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Inspection" ALTER COLUMN "PK_Inspection" SET DEFAULT nextval('public."Inspection_PK_Inspection_seq"'::regclass);


--
-- Name: Review PK_Review; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Review" ALTER COLUMN "PK_Review" SET DEFAULT nextval('public."Review_PK_Review_seq"'::regclass);


--
-- Name: School PK_School; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School" ALTER COLUMN "PK_School" SET DEFAULT nextval('public."School_PK_School_seq"'::regclass);


--
-- Name: Settlement PK_Settlement; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Settlement" ALTER COLUMN "PK_Settlement" SET DEFAULT nextval('public."Settlement_PK_Settlement_seq"'::regclass);


--
-- Name: Specialization PK_Specialization; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Specialization" ALTER COLUMN "PK_Specialization" SET DEFAULT nextval('public."Specialization_PK_Specialization_seq"'::regclass);


--
-- Name: Subject PK_Subject; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subject" ALTER COLUMN "PK_Subject" SET DEFAULT nextval('public."Subject_PK_Subject_seq"'::regclass);


--
-- Name: Type_of_School PK_Type_of_School; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Type_of_School" ALTER COLUMN "PK_Type_of_School" SET DEFAULT nextval('public."Type_of_School_PK_Type_of_School_seq"'::regclass);


--
-- Name: audit_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN id SET DEFAULT nextval('public.audit_log_id_seq'::regclass);


--
-- Name: data_versions pk_version; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_versions ALTER COLUMN pk_version SET DEFAULT nextval('public.data_versions_pk_version_seq'::regclass);


--
-- Name: import_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_history ALTER COLUMN id SET DEFAULT nextval('public.import_history_id_seq'::regclass);


--
-- Name: school_versions pk_version; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_versions ALTER COLUMN pk_version SET DEFAULT nextval('public.school_versions_pk_version_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: District; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."District" ("PK_District", "Name") FROM stdin;
1	Алейский район
2	Барнаульский район
3	Бийский район
4	Заринский район
5	Каменский район
6	Новоалтайский район
7	Рубцовский район
8	Славгородский район
9	Благовещенский район
10	Бурлинский район
11	Быстроистокский район
12	Волчихинский район
13	Егорьевский район
14	Ельцовский район
15	Завьяловский район
16	Залесовский район
17	Змеиногорский район
18	Зональный район
19	Калманский район
20	Ключевский район
21	Косихинский район
22	Красногорский район
23	Краснощековский район
24	Крутихинский район
25	Кулундинский район
26	Курьинский район
27	Кытмановский район
28	Локтевский район
29	Мамонтовский район
30	Михайловский район
31	Немецкий национальный район
32	Новичихинский район
33	Павловский район
34	Панкрушихинский район
35	Первомайский район
36	Петропавловский район
37	Поспелихинский район
38	Ребрихинский район
39	Родинский район
40	Романовский район
41	Смоленский район
42	Советский район
43	Солонешенский район
44	Солтонский район
45	Суетский район
46	Табунский район
47	Тальменский район
48	Тогульский район
49	Топчихинский район
50	Третьяковский район
51	Троицкий район
52	Тюменцевский район
53	Угловский район
54	Усть-Калманский район
55	Усть-Пристанский район
56	Хабарский район
57	Целинный район
58	Чарышский район
59	Шелаболихинский район
60	Шипуновский район
\.


--
-- Data for Name: Education_Program; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Education_Program" ("Code_Designation", "Name", "Type", "PK_Education_Program") FROM stdin;
01.01	Основная общеобразовательная программа	основная	1
01.02	Программа углубленного изучения математики	дополнительная	2
01.03	Программа углубленного изучения физики	дополнительная	3
01.04	Программа углубленного изучения иностранных языков	дополнительная	4
01.05	Программа художественно-эстетического развития	дополнительная	5
01.06	Программа спортивной подготовки	дополнительная	6
01.07	Программа информационных технологий	дополнительная	7
01.08	Программа экологического образования	дополнительная	8
01.09	Программа патриотического воспитания	дополнительная	9
01.10	Программа инклюзивного образования	основная	10
\.


--
-- Data for Name: Employee; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Employee" ("PK_Employee", "Full_Name", "Position", "Qualifications", "Experience_Years") FROM stdin;
1	Костин Клавдий Феофанович	Учитель химии	Задержать госпожа сутки находить. Наткнуться намерение приятель войти карандаш.	31
2	Кузнецова Марфа Федоровна	Учитель химии	Правление пропаганда ставить помолчать да. Кидать кидать цвет кузнец прелесть добиться приходить.	15
3	Беляков Фока Артемьевич	Учитель информатики	Вскакивать пища выкинуть каюта. Сравнение пища затянуться трясти видимо прежний следовательно что.	39
4	Герасимова Анастасия Петровна	Библиотекарь	Жидкий трубка остановить космос избегать оставить. Висеть полевой приятель сустав дремать.	20
5	Осипов Сократ Феоктистович	Учитель русского языка и литературы	Чем способ потрясти прежде неожиданный. Советовать дружно находить инструкция.	29
6	Ильина Нинель Архиповна	Учитель английского языка	Изредка академик господь карман человечек нож помолчать.	5
7	Дементьев Лука Бенедиктович	Учитель физической культуры	Тута упорно народ степь болото. Магазин вариант школьный.	29
8	Стрелкова Анжела Вадимовна	Учитель русского языка и литературы	Июнь следовательно роскошный горький лапа налоговый. Интернет командующий правление мгновение.	7
9	Савельев Милован Ефремович	Социальный педагог	Прелесть похороны покинуть тревога.	5
10	Муравьева Нинель Михайловна	Учитель физики	Наткнуться сверкающий товар пасть спичка. Эффект премьера близко инструкция.	16
11	Уваров Галактион Тарасович	Заместитель директора по учебной работе	Желание шлем грустный мера тревога. Металл вообще дрогнуть развитый металл неправда.	36
12	Гришина Валерия Дмитриевна	Учитель биологии	Близко четко невозможно. Мера горький уронить отъезд. Пятеро райком ребятишки пламя нож.	31
13	Рожков Лука Ярославович	Учитель английского языка	Равнодушный серьезный разводить подробность ложиться.	40
14	Никонова Татьяна Никифоровна	Заместитель директора по учебной работе	Лететь решетка уронить жить. Более видимо спалить снимать. Вскинуть приятель хлеб ныне дорогой.	28
15	Корнилов Каллистрат Феоктистович	Учитель биологии	Миг промолчать лиловый. Слишком слишком число цель беспомощный набор.	38
16	Королева София Болеславовна	Психолог	Кузнец предоставить крутой другой цель возмутиться выкинуть. Пропаганда товар четко парень.	16
17	Жданов Влас Федосеевич	Учитель истории	Чем указанный танцевать да порт сустав.	3
18	Калашникова Варвара Алексеевна	Заместитель директора по учебной работе	Спорт манера картинка оборот более интернет о.	14
19	Носов Борис Гаврилович	Психолог	Мотоцикл человечек болото избегать кузнец. Голубчик армейский ломать направо.	35
20	Сазонова Екатерина Оскаровна	Учитель физической культуры	Цепочка упор непривычный правильный холодно. Банда помолчать тесно потянуться.	11
21	Третьяков Эрнст Трофимович	Учитель английского языка	Серьезный кожа витрина плод совещание выражение.	7
22	Кононова Синклитикия Даниловна	Учитель физики	Похороны строительство второй сохранять. Выбирать достоинство спалить мимо.	18
23	Костин Константин Гавриилович	Учитель биологии	Космос степь очередной цвет материя стакан. Полевой покинуть разуметься перебивать.	10
24	Исаева Ия Харитоновна	Заместитель директора по воспитательной работе	Ведь о степь соответствие при госпожа место. Уничтожение рот покинуть плод падаль слишком.	12
25	Буров Яков Якубович	Учитель английского языка	Термин совет успокоиться. Вряд сохранять умолять падать лиловый слишком означать.	21
26	Бурова Екатерина Ниловна	Учитель информатики	Назначить выражаться палка вздрагивать коробка. Тюрьма похороны радость полевой.	31
27	Логинов Спартак Викентьевич	Учитель математики	Вздрагивать совещание палата ответить. Боец район кузнец наслаждение.	35
28	Юдина Феврония Михайловна	Учитель физической культуры	Жестокий изба освобождение банк.	40
29	Шубин Владилен Измаилович	Учитель физической культуры	Командующий нервно сравнение пробовать число. Актриса угодный пропасть инфекция обида спичка.	2
30	Кулакова Елена Федоровна	Учитель физики	Табак торопливый доставать способ. Вытаскивать ложиться мусор поставить помимо плод доставать.	26
31	Константинов Никодим Якубович	Психолог	Рот тяжелый какой рабочий. Конструкция сравнение термин мгновение разводить салон карандаш.	36
32	Кудряшова Иванна Харитоновна	Учитель химии	Тяжелый висеть угроза выгнать правый. Пропадать четыре запустить дремать мусор при.	5
33	Борисов Никодим Жоресович	Заместитель директора по воспитательной работе	Провинция важный пятеро коробка а. Сверкающий счастье бочок опасность прошептать изучить ботинок.	27
34	Смирнова Таисия Федоровна	Заместитель директора по воспитательной работе	Полевой коричневый темнеть поколение. Направо слишком провал славный.	13
35	Муравьев Ладимир Жанович	Учитель математики	Жестокий человечек жить голубчик рот столетие. Ленинград дьявол падать плод.	40
36	Гуляева Вера Филипповна	Учитель физической культуры	Ломать сынок реклама что выражаться теория. Тута бак угодный войти дремать.	4
37	Зыков Лазарь Гертрудович	Заместитель директора по воспитательной работе	Хлеб грудь да забирать понятный серьезный.	39
38	Агафонова Полина Кузьминична	Учитель биологии	Горький коричневый деловой ныне чувство дьявол грудь ярко. Сынок отражение сустав зарплата.	7
39	Наумов Устин Виленович	Библиотекарь	Даль рот жить провинция передо спичка ночь.	37
40	Бирюкова Елизавета Вячеславовна	Учитель информатики	Монета трубка дурацкий коллектив рабочий. Житель процесс налево.\nБак вскакивать фонарик заведение.	40
41	Костин Максимильян Феликсович	Учитель математики	Отметить скрытый порт кольцо трубка торопливый. Дремать волк назначить скрытый решение.	6
42	Тарасова Феврония Антоновна	Учитель биологии	Деловой белье достоинство строительство полюбить. Написать число поставить добиться.	5
43	Архипов Степан Афанасьевич	Учитель истории	Бок ведь решение предоставить школьный. Интеллектуальный носок валюта сустав тесно.	37
44	Беляева Оксана Макаровна	Заместитель директора по воспитательной работе	Кидать вздрогнуть песенка тута ложиться. Выдержать угодный настать картинка исследование наступать.	37
45	Киселев Казимир Гертрудович	Учитель английского языка	Упор дремать социалистический. Домашний хозяйка карандаш торопливый бабочка заявление.	12
46	Щербакова Прасковья Валериевна	Директор	Магазин трубка выразить каюта. Услать ломать выражение еврейский наткнуться функция а вывести.	25
47	Гурьев Кузьма Филатович	Заместитель директора по воспитательной работе	Заработать бабочка неожиданно терапия возникновение. Основание выбирать цепочка потрясти.	17
48	Жданова Нина Степановна	Директор	Заложить каюта ход услать. Адвокат экзамен падать около способ тысяча.	7
49	Шестаков Христофор Харитонович	Учитель биологии	Ночь встать за полевой полностью какой.	13
50	Пахомова Зинаида Оскаровна	Логопед	Передо военный пропаганда задрать прежний. Полностью левый изба уничтожение. Жить счастье шлем.	37
51	Дьячков Вячеслав Вилорович	Учитель истории	Скрытый рассуждение смеяться что. Угроза вскинуть зеленый крутой грустный решетка.	6
52	Белоусова Ульяна Натановна	Учитель биологии	Угодный природа заведение головка. Девка торговля выражение коммунизм.	37
53	Кулагин Валентин Даниилович	Учитель русского языка и литературы	Запустить спалить академик прежний степь горький пятеро. Порт падаль следовательно привлекать.	19
54	Борисова Олимпиада Кузьминична	Заместитель директора по воспитательной работе	Коробка дрогнуть актриса отъезд. Встать жестокий расстегнуть мусор смертельный лиловый пасть.	38
55	Мамонтов Никита Демьянович	Учитель информатики	Очередной прелесть пропадать. Житель сустав рай счастье решетка плясать витрина коллектив.	29
56	Максимова Александра Архиповна	Учитель английского языка	Монета собеседник дыхание зарплата металл неправда.	21
57	Уваров Арефий Еремеевич	Учитель химии	Добиться коммунизм палата виднеться деловой упорно аж. Ломать налево ведь сынок гулять дорогой.	34
58	Михайлова Мария Павловна	Библиотекарь	Беспомощный выраженный прелесть. Ленинград солнце спалить художественный.	30
59	Карпов Христофор Валерьянович	Директор	Интеллектуальный встать валюта падаль провал помолчать кузнец проход.	30
60	Шашкова Раиса Ильинична	Логопед	Падаль мгновение военный дружно каюта.	12
61	Кошелев Бронислав Харлампович	Учитель английского языка	Собеседник шлем еврейский выкинуть заложить механический.	13
62	Орехова Лукия Евгеньевна	Учитель английского языка	Мимо сверкать командующий манера рабочий светило. Процесс багровый означать художественный.	4
63	Белов Руслан Федосеевич	Учитель физики	Сходить лапа выкинуть один инфекция дьявол. Хотеть сутки песенка недостаток рай.	20
64	Рыбакова Элеонора Геннадьевна	Учитель русского языка и литературы	Посвятить успокоиться кпсс. Прошептать советовать порт зарплата роскошный.	28
65	Гущин Еремей Исидорович	Учитель физической культуры	Скрытый понятный миг казнь кидать невыносимый. Вряд князь серьезный.	30
66	Лапина Евдокия Ниловна	Учитель биологии	Налоговый изучить упорно багровый низкий. Исполнять спичка неожиданно висеть зарплата.	7
67	Сысоев Гедеон Яковлевич	Учитель физической культуры	Лететь ботинок вперед низкий витрина.\nМедицина господь самостоятельно встать.	26
68	Орлова Виктория Харитоновна	Директор	Миг нажать житель выражение дорогой. Заплакать народ художественный через рабочий похороны.	33
69	Ефимов Осип Харитонович	Учитель биологии	Неожиданно пересечь кпсс инструкция. Цвет монета сынок палец штаб степь естественный.	6
70	Молчанова Любовь Эльдаровна	Учитель английского языка	Плод полюбить вскинуть. Счастье адвокат кольцо число.	14
71	Ермаков Олимпий Гавриилович	Логопед	Рот мимо пол военный командующий домашний потом. Поколение да основание задрать кидать.	21
72	Яковлева Ирина Семеновна	Учитель биологии	Полоска постоянный о господь блин деньги.	17
73	Мухин Остап Теймуразович	Заместитель директора по воспитательной работе	Деньги торопливый вскакивать господь четыре жидкий наткнуться.	22
74	Филатова Кира Аркадьевна	Учитель физики	Человечек нож зима ярко.	38
75	Баранов Влас Всеволодович	Заместитель директора по учебной работе	Банк спорт интеллектуальный четыре салон забирать. Миг печатать ленинград плясать тесно.	28
76	Дмитриева Марфа Степановна	Библиотекарь	Степь военный добиться. Пересечь набор грустный низкий полоска добиться правильный смеяться.	36
77	Рогов Софрон Анисимович	Заместитель директора по воспитательной работе	Фонарик строительство актриса строительство. Посидеть приходить команда житель дьявол дружно.	17
78	Федосеева Регина Эдуардовна	Директор	Секунда подробность мусор мусор. Рай район военный обида.\nНеправда приличный лететь ремень.	36
79	Галкин Любосмысл Егорович	Учитель физики	Волк изображать школьный выражаться да.	5
80	Быкова Валентина Викторовна	Учитель физики	Дорогой страсть трясти бровь. Демократия умирать функция.	11
81	Белозеров Остромир Витальевич	Психолог	Мрачно рис ученый инвалид скользить. Покидать боец вообще картинка монета вскинуть карандаш.	2
82	Петухова Элеонора Филипповна	Учитель русского языка и литературы	Порядок умолять перебивать передо. Очередной выражение термин означать господь.	11
83	Медведев Мина Трифонович	Психолог	Сынок забирать результат светило совет освобождение порт.	6
84	Зайцева Мария Ильинична	Учитель химии	Приятель ярко изменение жидкий славный правильный наслаждение.	23
85	Власов Всеслав Артурович	Учитель физической культуры	Монета полностью вперед написать тысяча о казнь. Боец пламя спичка способ шлем ведь тута.	6
86	Фомина Алина Ильинична	Заместитель директора по воспитательной работе	Сходить уничтожение вчера решетка приходить.	4
87	Михеев Ираклий Викентьевич	Учитель истории	Коричневый отметить указанный. Один услать фонарик салон тревога спорт домашний.	15
88	Маркова Евдокия Богдановна	Заместитель директора по учебной работе	Палка рота манера виднеться. Понятный пропадать мягкий плод место аллея подземный.	13
89	Федосеев Гостомысл Трифонович	Учитель физики	Зарплата провинция приятель рот смертельный приятель. Приходить пробовать мягкий легко.	32
90	Терентьева Кира Константиновна	Психолог	Команда блин ломать. Встать ручей мелочь упор полевой пробовать потрясти тяжелый.	24
91	Терентьев Федот Григорьевич	Учитель физики	Художественный отметить горький сустав лапа медицина. Командование четыре карандаш второй.	4
92	Дементьева Ульяна Павловна	Учитель физической культуры	За зима за один слишком сынок факультет. Светило функция покинуть прошептать очутиться.	1
93	Терентьев Симон Евстигнеевич	Учитель русского языка и литературы	Палка ручей теория граница адвокат. Покидать юный мелькнуть промолчать ярко.	8
94	Волкова Василиса Михайловна	Учитель русского языка и литературы	Порт тута поговорить.\nРучей вчера июнь. Через эффект жидкий картинка результат свежий возмутиться.	6
95	Потапов Роман Фадеевич	Учитель биологии	Единый наслаждение невыносимый мучительно зачем тесно цель. Хозяйка изменение сверкающий прежде.	31
96	Воронцова Лидия Георгиевна	Учитель истории	Космос сынок витрина район.	30
97	Логинов Лука Федосеевич	Учитель информатики	Пасть мимо сустав избегать. Еврейский развернуться недостаток спалить.	40
98	Рябова Любовь Дмитриевна	Заместитель директора по воспитательной работе	Дремать мотоцикл устройство бок запретить плод.\nМиллиард жидкий мгновение табак уронить изредка.	16
99	Веселов Мирослав Гавриилович	Учитель физики	Рай умолять угол пятеро что угроза неудобно. Юный командование изредка аж очередной магазин.	5
100	Чернова Жанна Викторовна	Заместитель директора по учебной работе	Сравнение шлем товар банк увеличиваться. Что горький зима эффект тута карман потянуться.	14
101	Вишняков Ефрем Тихонович	Логопед	Спичка деньги сынок премьера рассуждение. Наткнуться крутой триста подземный потянуться.	36
102	Гришина Олимпиада Руслановна	Психолог	Затянуться рассуждение полностью идея. Рис дремать забирать миллиард покидать покидать тысяча вряд.	40
103	Быков Бажен Арсеньевич	Учитель информатики	Возможно прелесть пространство спорт палата. Картинка ярко мрачно.	4
104	Шубина Ольга Геннадьевна	Психолог	Выбирать сбросить багровый задрать. Расстройство банда лапа близко слишком правление сверкать.	34
105	Григорьев Корнил Фёдорович	Директор	Голубчик очко передо головной вздрагивать. Пробовать приятель славный.	5
106	Мишина Валентина Эдуардовна	Заместитель директора по учебной работе	Войти следовательно торопливый отражение. Вчера командир неожиданный интеллектуальный.	6
107	Калашников Владимир Евсеевич	Логопед	Печатать призыв витрина лететь другой. Затянуться налево задрать избегать.	6
108	Блохина Марина Дмитриевна	Учитель физической культуры	Очко кпсс провинция.\nРемень господь освободить.	40
109	Артемьев Аникей Вилорович	Библиотекарь	Июнь возмутиться сопровождаться волк соответствие отдел разнообразный миллиард.	29
110	Лаврентьева Анастасия Мироновна	Психолог	Пропаганда неправда самостоятельно необычный лететь. Разводить заработать парень следовательно.	7
111	Вишняков Аггей Даниилович	Заместитель директора по учебной работе	Естественный славный волк выражение налоговый бабочка потянуться задержать.	14
112	Маркова Эмилия Михайловна	Учитель русского языка и литературы	Грудь порт спешить передо. Сынок освобождение потрясти.	35
113	Андреев Давыд Тарасович	Заместитель директора по учебной работе	Понятный грудь за уничтожение. Заведение вывести механический манера руководитель горький.	9
114	Прохорова Василиса Геннадиевна	Социальный педагог	Плавно скрытый неправда невыносимый грудь заявление.	11
115	Рогов Исидор Марсович	Учитель физики	Юный миф похороны видимо. Порт райком разуметься. Сынок тревога издали скользить пасть.	22
116	Бирюкова Милица Валентиновна	Заместитель директора по учебной работе	Упор потянуться запустить хотеть. Указанный вскакивать вряд низкий спорт зато головной.	17
117	Костин Панфил Владленович	Психолог	Невыносимый металл головка сравнение.	15
118	Павлова Нонна Андреевна	Учитель физической культуры	Анализ уничтожение недостаток палка. Командующий возможно вперед рассуждение.	34
119	Андреев Демьян Харлампович	Психолог	Снимать куча цель покинуть. Плод инструкция четко кидать.	6
120	Калинина Анна Вениаминовна	Учитель биологии	Каюта полностью налоговый виднеться степь. Четко постоянный наслаждение ребятишки ведь зарплата.	17
121	Гуляев Савва Аверьянович	Социальный педагог	Ученый возбуждение четыре. Услать падать разуметься лиловый пятеро при издали.	35
122	Воронцова Валентина Ниловна	Учитель русского языка и литературы	Изменение парень секунда функция. Ведь кпсс пространство витрина.	9
123	Мясников Аким Геннадиевич	Заместитель директора по учебной работе	Исполнять чем ход проход дурацкий. Актриса вряд горький рот за тревога сходить.	12
124	Мартынова Варвара Афанасьевна	Учитель русского языка и литературы	Число команда а командир. Призыв легко провал блин природа монета.	27
125	Данилов Самуил Захарьевич	Учитель русского языка и литературы	Трясти деньги развитый ход один.	17
126	Титова Майя Алексеевна	Директор	Ярко следовательно радость подробность. Космос упор банк миллиард банк.	35
127	Белозеров Ян Валерьянович	Психолог	Тута желание жить смелый горький демократия. Песня направо бок бетонный прежний кожа.	40
128	Юдина Ираида Леонидовна	Директор	Райком спалить сынок какой пропаганда бабочка пересечь. Пасть отдел парень рассуждение обида.	24
129	Ефремов Тит Гурьевич	Учитель математики	Полевой художественный отметить госпожа устройство виднеться призыв. Бок четко песня.	25
130	Кулакова Элеонора Борисовна	Заместитель директора по воспитательной работе	Зато предоставить правление. Крутой граница низкий возникновение при.	4
131	Фадеев Кондрат Ефремович	Психолог	Миг дремать бок мусор равнодушный.	19
132	Андреева Валентина Федоровна	Учитель физики	Теория народ пятеро чем слишком приходить. Человечек товар расстегнуть манера.	32
133	Аксенов Богдан Феодосьевич	Социальный педагог	Более мрачно выбирать парень помимо.	12
134	Крюкова Ангелина Олеговна	Учитель химии	Угроза выраженный правление головка. Уничтожение рота промолчать сынок горький обида.	12
135	Хохлов Аскольд Владленович	Заместитель директора по учебной работе	Тута заплакать зеленый задрать школьный дурацкий. Голубчик поезд приличный.	40
136	Лихачева Лидия Натановна	Заместитель директора по учебной работе	Левый спалить налоговый изредка лететь пропадать. Костер табак народ передо мелочь совещание место.	1
137	Суворов Фома Викторович	Заместитель директора по воспитательной работе	Передо эпоха казнь поезд.	40
138	Горбачева Синклитикия Викторовна	Заместитель директора по воспитательной работе	Магазин князь монета сынок жить рабочий мусор. Выражение парень пропасть покидать наткнуться банк.	12
139	Васильев Андроник Феофанович	Учитель английского языка	Торговля передо растеряться. Изредка результат плод командующий прежде.	10
140	Лебедева Фаина Романовна	Социальный педагог	Бригада возникновение упорно серьезный пространство факультет. Хлеб наслаждение сынок.	13
141	Архипов Авксентий Харитонович	Логопед	Коричневый металл успокоиться механический. Невозможно грудь вариант роса понятный степь.	21
142	Алексеева Оксана Александровна	Учитель химии	Находить пасть ярко дружно боец вскакивать валюта. Неправда райком фонарик нож.	16
143	Быков Афанасий Гаврилович	Учитель русского языка и литературы	Реклама трясти интернет хозяйка. Легко оборот господь девка ремень.	21
144	Самойлова Нонна Станиславовна	Учитель биологии	Спалить бочок умолять более.\nОчутиться банк полностью оставить.	23
145	Богданов Радислав Валерианович	Учитель биологии	Вскинуть исполнять советовать висеть равнодушный госпожа. Угол поколение висеть горький.	11
146	Сорокина Екатерина Рубеновна	Учитель биологии	Рис покидать выраженный белье поговорить дорогой жидкий спалить. Изменение банк точно исследование.	4
147	Беляев Влас Анисимович	Учитель истории	Оставить ход изредка изба. Освобождение естественный потом блин левый товар.	39
148	Васильева Алина Александровна	Учитель английского языка	Прежде запустить необычный издали сынок головка роскошный выразить.	25
149	Красильников Селиван Елизарович	Учитель биологии	Неожиданно близко поставить а художественный виднеться.	14
150	Маслова Ирина Антоновна	Социальный педагог	Вариант означать дремать бетонный актриса.	32
151	Горбунов Игнатий Борисович	Учитель биологии	Тревога пространство набор конструкция. Следовательно полюбить сустав.	10
152	Емельянова Ираида Вячеславовна	Учитель истории	Советовать передо тысяча остановить.	40
153	Елисеев Ираклий Демидович	Социальный педагог	Песня число ведь отдел правление второй. Запеть заработать пропаганда спорт.	25
154	Беспалова Татьяна Богдановна	Логопед	Куча скрытый господь мера снимать заявление. Анализ угол приходить выраженный.	17
155	Моисеев Степан Харламович	Учитель химии	Эффект сверкающий ярко. Исследование палата висеть крыса. Заработать господь возмутиться девка.	8
156	Сысоева Нонна Руслановна	Учитель физической культуры	Вряд славный лететь возможно. Рассуждение лететь вскакивать витрина картинка способ интернет.	1
157	Макаров Олимпий Марсович	Учитель истории	Проход достоинство приходить висеть командир чувство. Район поставить предоставить что бок.	30
158	Суворова Татьяна Тимуровна	Учитель английского языка	Ребятишки ведь развитый.	2
159	Гусев Бажен Афанасьевич	Директор	Второй каюта виднеться банк плод. Костер мимо недостаток проход монета июнь.	23
160	Гусева Таисия Юрьевна	Учитель биологии	Коммунизм боец совет невыносимый. Исполнять расстегнуть беспомощный результат бак девка медицина.	24
161	Королев Георгий Трифонович	Учитель истории	Человечек что что пространство слишком инструкция приличный плод.	26
162	Исакова Елена Эдуардовна	Учитель математики	Лапа через пятеро медицина теория бок монета.	37
163	Александров Зиновий Денисович	Учитель русского языка и литературы	Валюта невозможно прежний носок задрать. Недостаток уничтожение потянуться естественный зима.	36
164	Дьячкова Ангелина Никифоровна	Учитель русского языка и литературы	Факультет передо новый аллея сопровождаться. Призыв разводить металл заложить пол.	17
165	Панов Богдан Александрович	Психолог	Грустный угодный социалистический провинция. Дьявол актриса ставить запеть.	34
166	Смирнова Ирина Геннадиевна	Учитель английского языка	Дрогнуть мелькнуть монета холодно триста затянуться механический. Новый приятель сынок функция.	32
167	Виноградов Кирилл Всеволодович	Учитель истории	Означать холодно сверкающий. Вздрогнуть перебивать счастье покинуть пятеро.	38
168	Шарова Галина Викторовна	Учитель физической культуры	Скользить разнообразный домашний чем миф посидеть. Палата тута поколение пастух каюта.	27
169	Богданов Виталий Афанасьевич	Учитель биологии	Роскошный дьявол мелочь металл голубчик дружно штаб спорт. Крутой более социалистический спасть.	4
170	Яковлева Иванна Вадимовна	Учитель математики	Дальний эпоха спалить. Желание результат серьезный ставить торопливый.	24
171	Константинов Кирилл Артёмович	Учитель физики	Сопровождаться недостаток смертельный хотеть редактор тюрьма ленинград. Выбирать спорт вскинуть.	37
172	Селиверстова Раиса Максимовна	Учитель математики	О какой голубчик падаль гулять сынок. Полностью хозяйка карандаш пространство поколение заложить.	35
173	Доронин Фортунат Викентьевич	Заместитель директора по учебной работе	Дурацкий понятный господь анализ запретить. Дурацкий радость выгнать свежий выдержать передо.	2
174	Мухина Майя Романовна	Учитель английского языка	Мгновение достоинство четко растеряться функция. Предоставить необычный металл столетие наткнуться.	1
175	Артемьев Клавдий Филатович	Учитель биологии	Секунда уничтожение конструкция мелькнуть функция войти район назначить.	24
176	Калашникова Светлана Харитоновна	Социальный педагог	Другой художественный фонарик. Рай бегать ярко результат.	27
177	Дорофеев Давыд Харламович	Учитель информатики	Тута освобождение палата плод выраженный скрытый интеллектуальный. Монета способ печатать.	14
178	Доронина Фаина Макаровна	Учитель биологии	Неправда ягода костер важный.\nВряд академик возникновение нож идея находить. Миф кольцо через.	38
179	Савин Федосий Филатович	Учитель математики	Штаб ночь мимо важный коммунизм тревога развитый. Багровый монета мимо порт рис четыре потянуться.	27
180	Зыкова Октябрина Эдуардовна	Учитель информатики	Цепочка наткнуться роса желание находить миф грудь. Отдел ленинград точно легко научить сутки жить.	14
181	Сидоров Тит Артемьевич	Учитель информатики	Коллектив выражаться славный намерение. Счастье ремень ответить висеть адвокат ленинград носок.	22
182	Лобанова Эмилия Афанасьевна	Учитель физической культуры	Ставить сбросить миг тусклый. Непривычный забирать сутки штаб. Тюрьма чувство поговорить адвокат.	15
183	Максимов Андрей Евсеевич	Заместитель директора по воспитательной работе	Приличный социалистический тесно сбросить плясать задержать. Наступать отдел тревога научить.	27
184	Евдокимова Майя Афанасьевна	Учитель химии	Выражение неудобно ученый мера граница сходить. Намерение зато госпожа привлекать мотоцикл.	11
185	Куликов Селиверст Ефимьевич	Учитель физики	Монета постоянный вообще райком засунуть. Пасть новый слишком поезд крутой похороны.	33
186	Карпова Варвара Львовна	Учитель физики	Успокоиться академик прежде реклама задрать. Эпоха сбросить уронить совет.	12
187	Макаров Гурий Денисович	Директор	Что рот угроза спорт. Сохранять постоянный за пространство человечек.	35
188	Мельникова Ираида Юльевна	Учитель английского языка	Отъезд забирать низкий невозможно темнеть. Устройство тута шлем мягкий желание школьный.	12
189	Быков Любомир Давыдович	Учитель информатики	Редактор исследование бак хотеть интеллектуальный призыв.	8
190	Константинова Майя Ниловна	Заместитель директора по воспитательной работе	Штаб иной недостаток назначить спешить одиннадцать. Какой пастух адвокат природа.	13
191	Орехов Олег Алексеевич	Учитель физической культуры	Выкинуть крыса выраженный мелькнуть. Решение миг научить актриса граница сутки.	34
192	Потапова Жанна Михайловна	Психолог	Зарплата понятный зеленый полоска тяжелый тревога. Хозяйка свежий расстегнуть изображать вообще.	39
193	Горбунов Савва Гурьевич	Заместитель директора по воспитательной работе	Единый славный трубка пасть выразить. Помолчать рай домашний пасть. Миф сынок спешить салон.	38
194	Сазонова Светлана Натановна	Учитель истории	Бетонный табак смертельный процесс мгновение ложиться.	26
195	Жданов Потап Александрович	Учитель математики	Второй хлеб вчера бок. Левый построить висеть угол неожиданно.	17
196	Ситникова Лукия Евгеньевна	Учитель истории	Строительство налоговый приятель разнообразный мелькнуть отражение анализ функция.	18
197	Бирюков Адам Игнатович	Учитель русского языка и литературы	Изредка ныне низкий граница четыре новый медицина.	14
198	Большакова Иванна Тарасовна	Заместитель директора по учебной работе	Висеть оборот район советовать. Мягкий бак страсть правый пастух конференция.	1
199	Морозов Велимир Демьянович	Учитель физической культуры	Демократия покидать валюта коричневый плод. Мимо ботинок плясать разуметься сверкающий угол.	39
200	Копылова Евдокия Яковлевна	Учитель физики	Необычный что лететь светило. Прежде подробность помимо. Рис а триста народ выражаться.	2
\.


--
-- Data for Name: Employee_Subject_Competence; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Employee_Subject_Competence" ("PK_Subject", "PK_Employee") FROM stdin;
\.


--
-- Data for Name: Infrastructure; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Infrastructure" ("PK_Infrastructure", "Name") FROM stdin;
1	Спортзал
2	Бассейн
3	Библиотека
4	Лаборатория
5	Компьютерный класс
6	Актовый зал
7	Столовая
8	Медицинский кабинет
9	Спортивная площадка
10	Мастерские
\.


--
-- Data for Name: Inspection; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Inspection" ("PK_Inspection", "Date", "Result", "Prescription_Number", "PK_School", has_violations, violation_type, is_resolved, resolution_date, description) FROM stdin;
1	2023-10-14	Требуется устранение нарушений	ПР-5343	81	f	\N	f	\N	\N
2	2023-03-17	Выявлены нарушения в документации	ПР-4371	81	f	\N	f	\N	\N
3	2020-03-15	Выявлены незначительные нарушения	ПР-4088	118	f	\N	f	\N	\N
4	2022-05-24	Нарушений не выявлено	ПР-3929	118	f	\N	f	\N	\N
5	2021-10-06	Выявлены незначительные нарушения	ПР-7430	95	f	\N	f	\N	\N
6	2024-09-26	Выявлены незначительные нарушения	ПР-9527	99	f	\N	f	\N	\N
7	2023-02-05	Нарушений не выявлено	ПР-4587	99	f	\N	f	\N	\N
8	2022-09-26	Выявлены незначительные нарушения	ПР-4334	13	f	\N	f	\N	\N
9	2022-10-26	Нарушений не выявлено	ПР-2131	13	f	\N	f	\N	\N
10	2025-02-02	Выявлены нарушения в документации	ПР-1501	187	f	\N	f	\N	\N
11	2023-05-28	Нарушений не выявлено	ПР-2306	184	f	\N	f	\N	\N
12	2021-05-28	Требуется устранение нарушений	ПР-8910	183	f	\N	f	\N	\N
13	2022-04-08	Требуется устранение нарушений	ПР-8884	183	f	\N	f	\N	\N
14	2020-10-17	Проверка пройдена успешно	ПР-7093	128	f	\N	f	\N	\N
15	2022-01-24	Нарушений не выявлено	ПР-9148	128	f	\N	f	\N	\N
16	2020-09-02	Выявлены незначительные нарушения	ПР-9797	168	f	\N	f	\N	\N
17	2020-01-15	Выявлены незначительные нарушения	ПР-9136	45	f	\N	f	\N	\N
18	2021-04-08	Нарушений не выявлено	ПР-8158	45	f	\N	f	\N	\N
19	2022-05-08	Нарушений не выявлено	ПР-9907	45	f	\N	f	\N	\N
20	2024-09-08	Нарушений не выявлено	ПР-2270	138	f	\N	f	\N	\N
21	2020-03-01	Требуется устранение нарушений	ПР-6270	26	f	\N	f	\N	\N
22	2022-10-15	Требуется устранение нарушений	ПР-5760	26	f	\N	f	\N	\N
23	2021-08-10	Выявлены нарушения в документации	ПР-8604	56	f	\N	f	\N	\N
24	2023-03-18	Требуется устранение нарушений	ПР-2850	56	f	\N	f	\N	\N
25	2023-09-06	Требуется устранение нарушений	ПР-2313	35	f	\N	f	\N	\N
26	2021-01-05	Нарушений не выявлено	ПР-9725	35	f	\N	f	\N	\N
27	2024-01-18	Проверка пройдена успешно	ПР-9368	145	f	\N	f	\N	\N
28	2025-02-23	Требуется устранение нарушений	ПР-9638	145	f	\N	f	\N	\N
29	2020-02-24	Проверка пройдена успешно	ПР-2195	145	f	\N	f	\N	\N
30	2022-09-20	Выявлены нарушения в документации	ПР-5407	185	f	\N	f	\N	\N
31	2020-11-26	Выявлены незначительные нарушения	ПР-7338	185	f	\N	f	\N	\N
32	2021-08-23	Требуется устранение нарушений	ПР-7683	114	f	\N	f	\N	\N
33	2024-09-02	Требуется устранение нарушений	ПР-3106	41	f	\N	f	\N	\N
34	2025-12-04	Выявлены незначительные нарушения	ПР-6644	41	f	\N	f	\N	\N
35	2024-06-05	Выявлены нарушения в документации	ПР-6115	100	f	\N	f	\N	\N
36	2022-03-28	Нарушений не выявлено	ПР-5194	23	f	\N	f	\N	\N
37	2024-11-23	Требуется устранение нарушений	ПР-8369	23	f	\N	f	\N	\N
38	2022-01-22	Выявлены нарушения в документации	ПР-2839	23	f	\N	f	\N	\N
39	2021-12-21	Выявлены нарушения в документации	ПР-1624	122	f	\N	f	\N	\N
40	2023-04-25	Проверка пройдена успешно	ПР-6341	107	f	\N	f	\N	\N
41	2023-12-13	Выявлены незначительные нарушения	ПР-8032	107	f	\N	f	\N	\N
42	2025-10-24	Требуется устранение нарушений	ПР-4899	107	f	\N	f	\N	\N
43	2025-12-08	Выявлены незначительные нарушения	ПР-3326	61	f	\N	f	\N	\N
44	2021-02-21	Выявлены незначительные нарушения	ПР-6445	61	f	\N	f	\N	\N
45	2024-09-01	Выявлены нарушения в документации	ПР-2131	61	f	\N	f	\N	\N
46	2020-04-04	Нарушений не выявлено	ПР-5504	55	f	\N	f	\N	\N
47	2021-10-24	Требуется устранение нарушений	ПР-2243	55	f	\N	f	\N	\N
48	2020-02-08	Нарушений не выявлено	ПР-6993	101	f	\N	f	\N	\N
49	2024-10-28	Нарушений не выявлено	ПР-3517	101	f	\N	f	\N	\N
50	2023-07-23	Выявлены нарушения в документации	ПР-3174	101	f	\N	f	\N	\N
51	2021-06-12	Проверка пройдена успешно	ПР-1136	146	f	\N	f	\N	\N
52	2024-02-09	Проверка пройдена успешно	ПР-9210	125	f	\N	f	\N	\N
53	2020-01-24	Нарушений не выявлено	ПР-3366	27	f	\N	f	\N	\N
54	2021-03-11	Выявлены нарушения в документации	ПР-3870	83	f	\N	f	\N	\N
55	2022-08-21	Выявлены нарушения в документации	ПР-7602	83	f	\N	f	\N	\N
56	2023-03-24	Требуется устранение нарушений	ПР-4884	83	f	\N	f	\N	\N
57	2024-10-19	Выявлены нарушения в документации	ПР-7696	87	f	\N	f	\N	\N
58	2021-02-18	Нарушений не выявлено	ПР-4976	163	f	\N	f	\N	\N
59	2021-09-06	Требуется устранение нарушений	ПР-3565	163	f	\N	f	\N	\N
60	2025-08-02	Нарушений не выявлено	ПР-2383	163	f	\N	f	\N	\N
61	2021-03-05	Выявлены нарушения в документации	ПР-2212	144	f	\N	f	\N	\N
62	2025-06-24	Нарушений не выявлено	ПР-8242	68	f	\N	f	\N	\N
63	2024-09-20	Проверка пройдена успешно	ПР-3488	84	f	\N	f	\N	\N
64	2024-03-02	Проверка пройдена успешно	ПР-7441	84	f	\N	f	\N	\N
65	2020-05-07	Выявлены нарушения в документации	ПР-9670	113	f	\N	f	\N	\N
66	2022-01-11	Нарушений не выявлено	ПР-6492	113	f	\N	f	\N	\N
67	2024-08-25	Требуется устранение нарушений	ПР-4036	140	f	\N	f	\N	\N
68	2021-11-23	Нарушений не выявлено	ПР-4719	140	f	\N	f	\N	\N
69	2025-04-04	Проверка пройдена успешно	ПР-5364	152	f	\N	f	\N	\N
70	2020-04-26	Нарушений не выявлено	ПР-6611	152	f	\N	f	\N	\N
71	2025-09-20	Нарушений не выявлено	ПР-6208	152	f	\N	f	\N	\N
72	2024-11-14	Нарушений не выявлено	ПР-7717	143	f	\N	f	\N	\N
73	2025-07-19	Требуется устранение нарушений	ПР-3581	143	f	\N	f	\N	\N
74	2020-11-28	Требуется устранение нарушений	ПР-2292	143	f	\N	f	\N	\N
75	2021-06-02	Нарушений не выявлено	ПР-8014	78	f	\N	f	\N	\N
76	2024-11-13	Требуется устранение нарушений	ПР-4807	78	f	\N	f	\N	\N
77	2024-12-18	Выявлены незначительные нарушения	ПР-7074	139	f	\N	f	\N	\N
78	2025-01-10	‚лпў«Ґ­л бҐамҐ§­лҐ ­ агиҐ­Ёп б ­Ёв а­ле ­®а¬	Џђ-1001	101	t	‘ ­ЏЁЌ	f	\N	Ћвбгвбвўгов г¬лў «м­ЁЄЁ ў Є« бб е
79	2025-01-12	Ќ агиҐ­Ёп Ї®¦ а­®© ЎҐ§®Ї б­®бвЁ	Џђ-1002	103	t	Џ®¦ а­ п ЎҐ§®Ї б­®бвм	f	\N	‡ Ї б­лҐ ўле®¤л § Ў«®ЄЁа®ў ­л
80	2025-01-15	Џа®Ў«Ґ¬л б гзҐЎ­®© ¤®Єг¬Ґ­в жЁҐ©	Џђ-1003	105	t	„®Єг¬Ґ­в жЁп	f	\N	Ћвбгвбвўгов ¦га­ «л гбЇҐў Ґ¬®бвЁ
81	2025-01-18	Ќ агиҐ­Ёп ®еа ­л ваг¤ 	Џђ-1004	107	t	Ћеа ­  ваг¤ 	f	\N	ЌҐв  ЇвҐзҐЄ ЇҐаў®© Ї®¬®йЁ
82	2024-12-05	Ќ агиҐ­Ёп ў ®аЈ ­Ё§ жЁЁ ЇЁв ­Ёп	Џђ-1005	102	t	‘ ­ЏЁЌ	t	2024-12-20	ЏЁйҐЎ«®Є ­Ґ б®®вўҐвбвў®ў « ­®а¬ ¬
83	2024-12-10	Ќ агиҐ­Ёп н«ҐЄва®ЎҐ§®Ї б­®бвЁ	Џђ-1006	104	t	Џ®¦ а­ п ЎҐ§®Ї б­®бвм	t	2024-12-25	ЋЎ­ аг¦Ґ­  ­ҐЁбЇа ў­ п Їа®ў®¤Є 
84	2024-12-15	ЋвбгвбвўЁҐ «ЁжҐ­§Ё© г ЇаҐЇ®¤ ў вҐ«Ґ©	Џђ-1007	106	t	„®Єг¬Ґ­в жЁп	t	2024-12-30	“ 2-е гзЁвҐ«Ґ© Їа®ба®зҐ­л «ЁжҐ­§ЁЁ
85	2024-12-20	Ќ агиҐ­Ёп Ї® ®еа ­Ґ ваг¤  ў бЇ®ав§ «Ґ	Џђ-1008	108	t	Ћеа ­  ваг¤ 	t	2025-01-05	Ћвбгвбвў®ў «® § йЁв­®Ґ Ї®ЄалвЁҐ
86	2024-11-10	Ќ агиҐ­Ёп ў а Ў®вҐ ЎЁЎ«Ё®вҐЄЁ	Џђ-1009	109	t	‘ ­ЏЁЌ	f	\N	‚ ЎЁЎ«Ё®вҐЄҐ Ї®ўлиҐ­­ п ў« ¦­®бвм
87	2024-11-15	Џа®Ў«Ґ¬л б ®в®Ї«Ґ­ЁҐ¬	Џђ-1010	111	t	Џ®¦ а­ п ЎҐ§®Ї б­®бвм	t	2024-11-30	ЌҐЁбЇа ў­®бвм Є®вҐ«м­®©
88	2024-11-20	Ќ агиҐ­Ёп ў ўҐ¤Ґ­ЁЁ Є« бб­ле ¦га­ «®ў	Џђ-1011	113	t	„®Єг¬Ґ­в жЁп	f	\N	ЌҐ ўбҐ ¦га­ «л § Ї®«­Ґ­л
89	2024-11-25	Ќ агиҐ­Ёп вҐе­ЁЄЁ ЎҐ§®Ї б­®бвЁ ў « Ў®а в®аЁЁ	Џђ-1012	115	t	Ћеа ­  ваг¤ 	t	2024-12-10	Ћвбгвбвў®ў «Ё § йЁв­лҐ ®зЄЁ
90	2024-10-05	Ќ агиҐ­Ёп ­  бЇ®авЁў­®© Ї«®й ¤ЄҐ	Џђ-1013	120	t	Ћеа ­  ваг¤ 	f	\N	ЌҐЁбЇа ў­®Ґ бЇ®авЁў­®Ґ ®Ў®аг¤®ў ­ЁҐ
91	2024-09-15	Ќ агиҐ­Ёп ў бв®«®ў®©	Џђ-1014	120	t	‘ ­ЏЁЌ	t	2024-10-01	ЌҐб®®вўҐвбвўЁҐ вҐ¬ЇҐа вга­®Ј® аҐ¦Ё¬ 
92	2024-08-20	Џа®ўҐаЄ  ¤®Єг¬Ґ­в®ў	Џђ-1015	120	f	\N	\N	\N	‚бҐ ¤®Єг¬Ґ­вл ў Ї®ап¤ЄҐ
93	2024-07-10	Ќ агиҐ­Ёп ўҐ­вЁ«пжЁЁ	Џђ-1019	130	t	‘ ­ЏЁЌ	t	2024-07-25	ЌҐЁбЇа ў­ п ўҐ­вЁ«пжЁп ў Є ЎЁ­Ґв е
94	2024-07-15	Ќ агиҐ­Ёп ®бўҐйҐ­Ёп	Џђ-1020	132	t	‘ ­ЏЁЌ	f	\N	ЌҐ¤®бв в®з­®Ґ ®бўҐйҐ­ЁҐ ў Є« бб е
95	2024-07-20	Ќ агиҐ­Ёп нў Єг жЁ®­­ле ЇгвҐ©	Џђ-1021	134	t	Џ®¦ а­ п ЎҐ§®Ї б­®бвм	t	2024-08-05	‡ Ја®¬®¦¤Ґ­л нў Єг жЁ®­­лҐ ўле®¤л
96	2024-07-25	ЋвбгвбвўЁҐ бҐавЁдЁЄ в®ў ­  ®Ў®аг¤®ў ­ЁҐ	Џђ-1022	136	t	„®Єг¬Ґ­в жЁп	f	\N	ЌҐв бҐавЁдЁЄ в®ў ­  Є®¬ЇмовҐал
97	2024-07-30	Ќ агиҐ­Ёп ў ¬Ґ¤ЁжЁ­бЄ®¬ Є ЎЁ­ҐвҐ	Џђ-1023	138	t	Ћеа ­  ваг¤ 	t	2024-08-15	Џа®ба®зҐ­л ¬Ґ¤ЁЄ ¬Ґ­вл
\.


--
-- Data for Name: Review; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Review" ("PK_Review", "Author", "Text", "Date", "Rating", "PK_School", user_id, is_approved, moderated_by, moderated_at, moderation_comment, is_deleted, deleted_by, deleted_at, deletion_reason) FROM stdin;
1	parent	Задержать перебивать вздрогнуть разнообразный. Освободить товар ложиться покидать. Промолчать висеть предоставить издали народ развернуться приходить пол. Потом плод бак увеличиваться бак а изменение намерение. Песня остановить зато волк правый естественный развитый идея.	2026-01-11	4	68	2	t	\N	\N	\N	f	\N	\N	\N
2	region_admin	Идея белье тяжелый угроза. Житель вскакивать тяжелый уронить беспомощный. Лететь беспомощный приятель выраженный прежний намерение спорт. Обида монета правильный теория. Поколение неудобно порода цвет смеяться задержать.	2026-01-11	4	68	5	t	\N	\N	\N	f	\N	\N	\N
3	region_admin	Магазин человечек редактор ярко провал строительство. Приятель сверкающий за труп торговля ход снимать задержать.	2026-01-11	5	68	5	t	\N	\N	\N	f	\N	\N	\N
4	school_admin	Армейский еврейский неправда командир монета исследование правление. Дыхание угроза плавно естественный.	2026-01-11	5	68	4	t	\N	\N	\N	f	\N	\N	\N
5	teacher	Миг лететь ломать аллея спешить крыса уничтожение. Приятель пропадать природа премьера неожиданный вздрагивать. Интеллектуальный а неудобно район налоговый ломать. Вариант человечек премьера мотоцикл эпоха.	2026-01-11	3	68	3	t	\N	\N	\N	f	\N	\N	\N
6	admin	Висеть один секунда самостоятельно. Иной ягода развернуться ручей поздравлять запеть.	2026-01-11	4	68	1	t	\N	\N	\N	f	\N	\N	\N
7	school_admin	Светило плод падаль освобождение снимать коричневый. Тусклый следовательно правление расстройство выдержать.	2026-01-11	5	68	4	t	\N	\N	\N	f	\N	\N	\N
8	parent	Картинка заплакать багровый строительство полюбить анализ видимо.	2026-01-11	4	68	2	t	\N	\N	\N	f	\N	\N	\N
9	region_admin	Эффект валюта основание тревога. Карандаш медицина товар картинка расстегнуть единый проход.	2026-01-11	5	120	5	t	\N	\N	\N	f	\N	\N	\N
10	region_admin	Поколение иной кпсс. Счастье избегать через задрать художественный картинка.	2026-01-11	4	126	5	t	\N	\N	\N	f	\N	\N	\N
11	teacher	Число передо точно совещание аллея подробность. Инструкция социалистический сравнение перебивать иной витрина. Космос трясти число пропадать покидать белье. Способ командир спорт передо ночь назначить ответить коричневый. Невыносимый поезд каюта деловой налево. Грудь грустный способ печатать коллектив уронить заведение. Место табак через темнеть вообще граница хлеб.	2026-01-11	5	126	3	t	\N	\N	\N	f	\N	\N	\N
12	parent	Палец коллектив развитый за тесно умолять место боец. Через бровь премьера некоторый заработать актриса. Еврейский бабочка триста угроза бегать.	2026-01-11	4	126	2	t	\N	\N	\N	f	\N	\N	\N
13	school_admin	Ленинград лапа запретить миллиард. Бетонный ответить совещание налоговый изучить кольцо инструкция редактор. Привлекать горький ставить необычный одиннадцать команда редактор эффект.	2026-01-11	3	126	4	t	\N	\N	\N	f	\N	\N	\N
14	region_admin	Приличный заявление упорно помимо запеть. Витрина ответить запретить еврейский бак изображать эпоха. Потрясти степь трясти белье.	2026-01-11	3	126	5	t	\N	\N	\N	f	\N	\N	\N
15	teacher	Ярко висеть бок бабочка вряд очередной. Смеяться танцевать число заявление прощение миф.	2026-01-11	3	126	3	t	\N	\N	\N	f	\N	\N	\N
16	admin	Разуметься ягода наткнуться соответствие. Расстройство разнообразный гулять магазин. Избегать самостоятельно лететь желание. Сынок пробовать о увеличиваться подробность смеяться пересечь бабочка. Присесть девка исследование командир выражение. Гулять выдержать плавно пропадать ботинок снимать беспомощный.	2026-01-11	5	126	1	t	\N	\N	\N	f	\N	\N	\N
17	region_admin	Дружно мелочь порядок невозможно белье ложиться. Добиться забирать потом возбуждение труп угроза редактор. При славный запеть счастье. Славный чувство монета валюта. Июнь вряд страсть палата степь ответить вывести.	2026-01-11	4	126	5	t	\N	\N	\N	f	\N	\N	\N
18	parent	Соответствие кидать цель непривычный. Секунда спешить рабочий пастух тяжелый ручей белье. Ягода четко мелькнуть помолчать.	2026-01-11	4	126	2	t	\N	\N	\N	f	\N	\N	\N
19	admin	Вытаскивать пламя падаль актриса выражаться. Пятеро разуметься прощение желание. Термин монета тута сутки. Правление настать оборот очутиться единый выражаться.	2026-01-11	4	29	1	t	\N	\N	\N	f	\N	\N	\N
20	admin	Господь бок бак спешить художественный невозможно ярко. Терапия четыре запеть космос порядок. Висеть механический коричневый виднеться второй необычный мгновение. Рабочий стакан уничтожение карман нажать передо. Горький полностью житель освободить. Угодный очко механический перебивать плясать.	2026-01-11	4	29	1	t	\N	\N	\N	f	\N	\N	\N
21	school_admin	За мелочь цель угол военный господь задрать. Солнце единый покидать падать степь эффект. Передо заложить помолчать решение редактор порог. Мгновение лететь коробка тусклый около. Рассуждение дорогой спалить сынок роскошный совещание. Нажать актриса команда прошептать более хозяйка оборот.	2026-01-11	4	29	4	t	\N	\N	\N	f	\N	\N	\N
22	admin	Монета кпсс чем темнеть сверкающий.	2026-01-11	3	29	1	t	\N	\N	\N	f	\N	\N	\N
23	school_admin	Близко кузнец материя июнь. Порог посидеть вскинуть господь нож ботинок функция. Торговля крутой идея при. Неправда светило отметить миг девка исследование. Дыхание даль чем. Мягкий дыхание палка полностью.	2026-01-11	3	29	4	t	\N	\N	\N	f	\N	\N	\N
24	admin	Бегать потом порядок мелькнуть. Миг написать полюбить тута смертельный назначить кожа.	2026-01-11	3	29	1	t	\N	\N	\N	f	\N	\N	\N
25	parent	Плод сбросить угроза способ выбирать господь. Крутой полюбить монета предоставить. Заплакать порт приятель банк.	2026-01-11	3	146	2	t	\N	\N	\N	f	\N	\N	\N
26	school_admin	Отметить доставать разуметься картинка салон головной. Постоянный рис приходить дурацкий мучительно угол спорт.	2026-01-11	3	146	4	t	\N	\N	\N	f	\N	\N	\N
27	parent	Витрина вскакивать доставать торговля развитый. Решетка болото растеряться плавно спичка задержать аж.	2026-01-11	5	146	2	t	\N	\N	\N	f	\N	\N	\N
28	parent	Выбирать вскинуть посвятить полевой ложиться находить багровый. Болото триста смеяться.	2026-01-11	3	146	2	t	\N	\N	\N	f	\N	\N	\N
29	parent	Казнь сверкать решение свежий пространство ярко боец. Мера предоставить число.	2026-01-11	5	146	2	t	\N	\N	\N	f	\N	\N	\N
30	teacher	Ломать затянуться освободить а.	2026-01-11	3	146	3	t	\N	\N	\N	f	\N	\N	\N
31	parent	Отдел роскошный пятеро мотоцикл социалистический находить вытаскивать солнце. Слишком тысяча спалить вскинуть наткнуться.	2026-01-11	4	37	2	t	\N	\N	\N	f	\N	\N	\N
32	region_admin	Тяжелый сбросить приличный кожа. Угроза горький прежний еврейский горький. Еврейский казнь неожиданно горький порог степь. О бетонный возникновение беспомощный.	2026-01-11	4	37	5	t	\N	\N	\N	f	\N	\N	\N
33	teacher	Трясти ответить число угодный чем роскошный носок.	2026-01-11	5	37	3	t	\N	\N	\N	f	\N	\N	\N
34	teacher	Правление холодно неожиданный. Коммунизм прелесть написать. Постоянный пламя палец скрытый.	2026-01-11	3	37	3	t	\N	\N	\N	f	\N	\N	\N
35	parent	Добиться один что выраженный. Пробовать ныне господь.	2026-01-11	4	37	2	t	\N	\N	\N	f	\N	\N	\N
36	school_admin	Более процесс горький легко мера. Порядок естественный ручей функция монета прежде. Рис команда видимо легко армейский. Изба бочок правильный спичка.	2026-01-11	5	37	4	t	\N	\N	\N	f	\N	\N	\N
37	parent	Успокоиться блин наслаждение цвет приходить. Голубчик сутки господь рот голубчик плод. Тревога отдел головной боец очко советовать. Монета иной деловой потрясти карман. Избегать деловой ответить заведение что холодно палка. Наткнуться очутиться грустный ботинок социалистический господь.	2026-01-11	3	37	2	t	\N	\N	\N	f	\N	\N	\N
38	parent	Бочок протягивать пространство правление сравнение. Слишком пересечь лететь покидать скрытый встать. Мелькнуть изучить механический второй.	2026-01-11	5	54	2	t	\N	\N	\N	f	\N	\N	\N
39	school_admin	Слишком наслаждение госпожа. Художественный степь низкий мучительно господь пол монета.	2026-01-11	3	54	4	t	\N	\N	\N	f	\N	\N	\N
40	teacher	Функция оставить совещание ремень находить.	2026-01-11	3	110	3	t	\N	\N	\N	f	\N	\N	\N
41	region_admin	Бригада тюрьма непривычный достоинство выбирать точно около покинуть. Лапа кольцо миг остановить народ. Дурацкий потрясти выкинуть висеть услать. Провинция степь плод невыносимый светило промолчать задержать. Правильный скользить головка разводить виднеться бочок скользить экзамен.	2026-01-11	5	110	5	t	\N	\N	\N	f	\N	\N	\N
42	parent	Сопровождаться домашний возмутиться хозяйка. Страсть механический желание. Умирать лапа пространство кидать уничтожение материя точно достоинство.	2026-01-11	5	110	2	t	\N	\N	\N	f	\N	\N	\N
43	region_admin	Около совет устройство конструкция мгновение девка.	2026-01-11	5	110	5	t	\N	\N	\N	f	\N	\N	\N
44	admin	Житель растеряться уточнить вздрагивать дьявол. Песня да оборот порт запеть. Серьезный умолять академик бок следовательно порт ответить.	2026-01-11	5	110	1	t	\N	\N	\N	f	\N	\N	\N
45	region_admin	Пятеро отдел спорт художественный. Теория рис число еврейский означать. Плавно промолчать мелькнуть домашний очко сходить зима. Товар очутиться остановить наступать неправда салон провал изба.	2026-01-11	5	110	5	t	\N	\N	\N	f	\N	\N	\N
46	school_admin	Запеть порт возможно заложить да нож порог.	2026-01-11	5	11	4	t	\N	\N	\N	f	\N	\N	\N
47	parent	Поздравлять настать ремень поставить дрогнуть вздрагивать выражение. Выгнать важный устройство спорт свежий сохранять набор спичка.	2026-01-11	4	11	2	t	\N	\N	\N	f	\N	\N	\N
48	teacher	Подземный рабочий рай бабочка постоянный скользить. За выгнать ярко счастье отметить тяжелый торговля. Волк редактор приятель. Дружно посидеть близко бок салон выразить славный юный. Порода мусор приятель банда металл. Роскошный приятель прощение жидкий левый задрать что.	2026-01-11	3	11	3	t	\N	\N	\N	f	\N	\N	\N
49	parent	Неправда актриса умирать порог подземный. Отдел естественный зарплата бак танцевать написать спорт. Ярко дьявол легко совет господь равнодушный смертельный исследование.	2026-01-11	5	11	2	t	\N	\N	\N	f	\N	\N	\N
50	teacher	Экзамен палата какой заплакать цель.	2026-01-11	4	11	3	t	\N	\N	\N	f	\N	\N	\N
51	admin	Крыса невозможно плод дьявол заработать ночь. Новый следовательно магазин холодно головной. Страсть порода пропаганда танцевать.	2026-01-11	5	11	1	t	\N	\N	\N	f	\N	\N	\N
52	admin	Выраженный интеллектуальный помолчать покинуть передо район анализ. Тюрьма собеседник командир важный. Перебивать реклама тяжелый спешить премьера грустный. Эффект изображать пробовать. Важный отъезд прощение естественный песенка уронить.	2026-01-11	3	130	1	t	\N	\N	\N	f	\N	\N	\N
53	teacher	Премьера рассуждение зачем четыре. Изучить жестокий тюрьма. Мучительно пропасть расстегнуть куча бабочка изредка металл.	2026-01-11	4	130	3	t	\N	\N	\N	f	\N	\N	\N
54	school_admin	Выражаться прощение витрина госпожа. Конференция расстегнуть коричневый торопливый демократия июнь падать.	2026-01-11	3	130	4	t	\N	\N	\N	f	\N	\N	\N
55	parent	Район устройство привлекать трясти инфекция вообще потом. Народ художественный ягода применяться пища костер. Дошлый полоска рис пятеро вытаскивать вперед. Устройство сынок торопливый бровь задержать.	2026-01-11	3	130	2	t	\N	\N	\N	f	\N	\N	\N
56	parent	Заплакать горький беспомощный князь наткнуться. Тусклый сбросить очередной деньги что советовать эпоха. Строительство жестокий возбуждение вскакивать бочок строительство изображать. Светило эпоха спорт лапа. Сравнение уточнить юный отдел.	2026-01-11	4	130	2	t	\N	\N	\N	f	\N	\N	\N
57	teacher	Налоговый металл спорт светило слишком приятель лететь.	2026-01-11	5	91	3	t	\N	\N	\N	f	\N	\N	\N
58	parent	Ярко болото легко идея тысяча научить вскинуть.	2026-01-11	4	91	2	t	\N	\N	\N	f	\N	\N	\N
59	admin	Дальний ягода возникновение командование бок монета магазин. Столетие подземный запеть материя. Вчера пламя выбирать мальчишка солнце деньги проход. Угроза триста прощение князь заработать. Возможно цвет желание. Рабочий запустить набор мелькнуть июнь.	2026-01-11	5	91	1	t	\N	\N	\N	f	\N	\N	\N
60	region_admin	Сохранять новый кузнец возмутиться ученый. Плод дорогой неудобно лиловый очутиться. Анализ виднеться банк поставить вариант похороны легко. Вытаскивать процесс правильный сходить. Страсть наступать нож.	2026-01-11	5	91	5	t	\N	\N	\N	f	\N	\N	\N
61	region_admin	Развитый поезд затянуться. Рай заработать смертельный следовательно деньги миф. Выражение мимо беспомощный отражение новый бак при забирать.	2026-01-11	4	91	5	t	\N	\N	\N	f	\N	\N	\N
62	teacher	Печатать опасность лиловый изредка правый. Адвокат социалистический подробность рабочий нож. Войти полевой мимо сверкать совещание спалить страсть. Свежий доставать руководитель ныне отражение. Пол командование солнце головка.	2026-01-11	3	91	3	t	\N	\N	\N	f	\N	\N	\N
63	teacher	Палата понятный одиннадцать угол солнце уничтожение. Горький военный промолчать командование рот вариант.	2026-01-11	3	91	3	t	\N	\N	\N	f	\N	\N	\N
64	admin	Строительство угодный материя угодный. Художественный потом бак вперед рай. Дремать угол тревога прежний. Ребятишки легко горький.	2026-01-11	5	91	1	t	\N	\N	\N	f	\N	\N	\N
65	admin	Бровь правление ручей упорно монета.	2026-01-11	5	91	1	t	\N	\N	\N	f	\N	\N	\N
66	teacher	Багровый спалить вздрогнуть даль расстегнуть темнеть успокоиться. Песенка госпожа выкинуть единый за кольцо сустав. Пространство командование войти коричневый тюрьма падаль витрина. Материя угроза столетие социалистический запретить рис теория. Холодно хотеть сынок командующий пересечь.	2026-01-11	4	75	3	t	\N	\N	\N	f	\N	\N	\N
67	region_admin	Рай услать подземный войти ребятишки. Хозяйка услать неправда нажать необычный. Ложиться написать пастух сомнительный провинция командующий нож.	2026-01-11	3	75	5	t	\N	\N	\N	f	\N	\N	\N
68	region_admin	Банда цепочка сутки избегать еврейский костер. Лапа граница виднеться носок.	2026-01-11	4	75	5	t	\N	\N	\N	f	\N	\N	\N
69	parent	Конструкция бок понятный направо некоторый правление советовать. Избегать строительство демократия.	2026-01-11	3	75	2	t	\N	\N	\N	f	\N	\N	\N
70	school_admin	Порог мелькнуть магазин художественный еврейский кузнец анализ дьявол. Цвет запеть прежний аллея передо командующий о. Торговля возбуждение посидеть разводить девка рай пропадать. Изменение миг функция.	2026-01-11	5	75	4	t	\N	\N	\N	f	\N	\N	\N
71	admin	Предоставить крыса дружно успокоиться успокоиться. Правый четко пища славный тысяча.	2026-01-11	5	115	1	t	\N	\N	\N	f	\N	\N	\N
72	admin	Написать более выражаться природа расстегнуть. Основание экзамен недостаток скрытый.	2026-01-11	4	115	1	t	\N	\N	\N	f	\N	\N	\N
73	school_admin	Скрытый вскакивать равнодушный провал. Инвалид добиться терапия материя миг.	2026-01-11	5	115	4	t	\N	\N	\N	f	\N	\N	\N
74	admin	Космос полевой вытаскивать обида витрина бабочка экзамен. Плавно ныне умирать господь жестокий рай. При зарплата песня фонарик опасность серьезный чувство.	2026-01-11	4	115	1	t	\N	\N	\N	f	\N	\N	\N
75	parent	Налоговый коробка миф процесс. Мимо металл боец полюбить. Покидать плясать роса освобождение присесть.	2026-01-11	3	115	2	t	\N	\N	\N	f	\N	\N	\N
76	admin	Счастье да заложить призыв решетка порода назначить. Ребятишки холодно природа разуметься сынок издали выгнать каюта. Девка лететь банда столетие цвет. Левый избегать носок уничтожение.	2026-01-11	3	115	1	t	\N	\N	\N	f	\N	\N	\N
77	region_admin	Точно набор покинуть невозможно снимать свежий чувство дыхание. Упорно протягивать решетка трубка хотеть палка. Возмутиться следовательно посвятить мягкий наткнуться космос желание упорно.	2026-01-11	5	115	5	t	\N	\N	\N	f	\N	\N	\N
78	region_admin	Изображать девка рот что изображать самостоятельно табак. Вчера неожиданно посвятить дрогнуть девка интернет. Мимо пол самостоятельно идея житель пропадать. Неожиданный домашний космос способ сверкающий плод пол. Совещание табак подробность.	2026-01-11	3	115	5	t	\N	\N	\N	f	\N	\N	\N
79	teacher	Мера привлекать запеть даль иной. Хлеб тесно плод печатать палец прошептать очередной горький. Исполнять материя висеть исследование.	2026-01-11	5	115	3	t	\N	\N	\N	f	\N	\N	\N
80	parent	Отъезд цепочка носок плавно. Собеседник советовать за приятель лиловый встать горький. Неправда смелый ботинок бровь новый деньги. Исполнять мелькнуть функция фонарик опасность.	2026-01-11	3	166	2	t	\N	\N	\N	f	\N	\N	\N
81	region_admin	Табак серьезный правление около жидкий роса. Степь вчера потянуться указанный процесс.	2026-01-11	3	166	5	t	\N	\N	\N	f	\N	\N	\N
82	admin	Лететь проход вообще пасть жестокий. Рассуждение реклама ведь доставать неправда кожа холодно. Развитый грудь прежний выражаться увеличиваться рис основание бок. Выражаться построить свежий магазин горький карандаш.	2026-01-11	3	166	1	t	\N	\N	\N	f	\N	\N	\N
83	school_admin	Уничтожение добиться сомнительный мучительно смертельный умолять реклама. Спорт поезд посидеть банда. Чем зима ход редактор. Эпоха зима тяжелый картинка деньги роса отражение равнодушный.	2026-01-11	3	24	4	t	\N	\N	\N	f	\N	\N	\N
84	parent	Кольцо академик невозможно виднеться. Через бригада отражение спорт непривычный князь что. Школьный прежде инфекция вздрогнуть витрина.	2026-01-11	3	24	2	t	\N	\N	\N	f	\N	\N	\N
85	admin	Результат зачем плавно коллектив магазин сопровождаться пламя. Находить зарплата командующий. При возникновение успокоиться. Угол художественный полностью применяться.	2026-01-11	4	24	1	t	\N	\N	\N	f	\N	\N	\N
86	teacher	Проход пространство правый мусор жидкий пространство неожиданно. Задержать господь прощение валюта ведь дыхание. Медицина мелочь человечек неожиданно левый цвет дошлый. Прелесть исследование эпоха построить чувство ремень. Багровый правление реклама торговля плясать полюбить пропаганда.	2026-01-11	4	24	3	t	\N	\N	\N	f	\N	\N	\N
87	region_admin	Разводить низкий присесть протягивать. Магазин умолять бровь плод коммунизм. Виднеться засунуть точно сынок мимо пол.	2026-01-11	5	24	5	t	\N	\N	\N	f	\N	\N	\N
88	region_admin	Пропадать ответить точно функция функция горький. Избегать заработать возмутиться. Деловой художественный мелочь шлем песня нервно. Серьезный бегать салон полевой дурацкий поздравлять. Уточнить степь отметить. Необычный вывести смеяться торопливый военный ручей.	2026-01-11	4	24	5	t	\N	\N	\N	f	\N	\N	\N
89	teacher	Отражение упор провинция. Сустав задрать адвокат плод сынок танцевать остановить.	2026-01-11	5	24	3	t	\N	\N	\N	f	\N	\N	\N
179	school_admin	Неправда правление набор зарплата. Увеличиваться дошлый мусор увеличиваться куча оборот.	2026-01-11	4	191	4	t	\N	\N	\N	f	\N	\N	\N
90	teacher	Появление функция выраженный. Подробность вскакивать угроза дошлый. Подробность мучительно спалить слишком сверкать тревога тута выгнать.	2026-01-11	3	24	3	t	\N	\N	\N	f	\N	\N	\N
91	school_admin	Фонарик хозяйка через головка отдел. Художественный дорогой банк песенка.	2026-01-11	4	24	4	t	\N	\N	\N	f	\N	\N	\N
92	teacher	Посидеть левый мягкий чувство миллиард. Грудь район ответить миллиард столетие головка освобождение. Мрачно сынок господь печатать торговля изредка мелочь.	2026-01-11	3	24	3	t	\N	\N	\N	f	\N	\N	\N
93	region_admin	Интернет жидкий вздрагивать запеть металл рассуждение. Ботинок сопровождаться спешить соответствие. Вывести трясти мелькнуть пробовать даль. Легко изменение палка неудобно поколение вскинуть.	2026-01-11	3	99	5	t	\N	\N	\N	f	\N	\N	\N
94	school_admin	Важный спасть место изучить мрачно горький картинка славный. Подземный роскошный армейский заявление что спешить помолчать неожиданно. Войти совет иной посвятить вариант. Крутой функция монета. Неправда заплакать опасность приличный освободить. Сбросить ставить приятель носок.	2026-01-11	5	99	4	t	\N	\N	\N	f	\N	\N	\N
95	parent	Карандаш обида девка горький ход. Каюта отметить кидать сходить холодно экзамен.	2026-01-11	5	99	2	t	\N	\N	\N	f	\N	\N	\N
96	admin	Вариант коллектив вряд возможно выгнать уронить тесно. Актриса другой сутки слать что возмутиться горький.	2026-01-11	5	99	1	t	\N	\N	\N	f	\N	\N	\N
97	region_admin	Роскошный оставить природа дошлый. Кидать очередной дыхание передо потянуться зарплата помимо.	2026-01-11	5	99	5	t	\N	\N	\N	f	\N	\N	\N
98	admin	Ребятишки сверкать пища ночь. Запретить исполнять изредка совет левый лапа. Радость падать мера четко.	2026-01-11	5	99	1	t	\N	\N	\N	f	\N	\N	\N
99	region_admin	Домашний боец палка аж запеть равнодушный. Скользить художественный пересечь спасть экзамен передо. Налево выгнать трубка соответствие. Ложиться вздрагивать потрясти провал поезд протягивать социалистический. Естественный тусклый теория полюбить помимо. Строительство спешить июнь привлекать жидкий холодно желание. Войти слать указанный неправда кпсс ведь что.	2026-01-11	3	99	5	t	\N	\N	\N	f	\N	\N	\N
100	parent	Ныне рассуждение тревога каюта. Скрытый слишком пастух деловой. Разуметься близко умирать снимать провал болото пастух. Терапия металл дошлый мера изба. Мгновение чувство командующий вчера пол головной пробовать.	2026-01-11	4	99	2	t	\N	\N	\N	f	\N	\N	\N
101	school_admin	Пятеро домашний поезд пространство слишком наслаждение. Социалистический некоторый похороны деловой выраженный.	2026-01-11	4	99	4	t	\N	\N	\N	f	\N	\N	\N
102	region_admin	Казнь место зима освободить конференция космос. Встать выраженный направо расстройство. Проход кожа смертельный основание табак выражаться заведение. Потом конструкция расстегнуть нервно.	2026-01-11	5	94	5	t	\N	\N	\N	f	\N	\N	\N
103	teacher	Социалистический крыса запеть бочок рот.	2026-01-11	4	94	3	t	\N	\N	\N	f	\N	\N	\N
104	parent	Мальчишка о горький мрачно. Освободить умолять грудь оставить солнце мгновение. Виднеться адвокат очередной подробность.	2026-01-11	4	94	2	t	\N	\N	\N	f	\N	\N	\N
105	parent	Совет растеряться наслаждение неправда непривычный непривычный пространство. Близко подробность бегать демократия.	2026-01-11	5	94	2	t	\N	\N	\N	f	\N	\N	\N
106	teacher	Подробность подробность применяться очко премьера поговорить господь. Командующий пропасть дошлый близко пропадать факультет набор. Покидать направо ягода бетонный забирать запустить ягода встать. Коммунизм житель радость горький уничтожение процесс рабочий.	2026-01-11	3	94	3	t	\N	\N	\N	f	\N	\N	\N
107	region_admin	Школьный коричневый порог дрогнуть. Прошептать торопливый демократия команда непривычный вариант металл рот. Угроза заплакать хозяйка. Райком дружно задержать видимо цепочка пасть ведь умолять. Поговорить невыносимый спалить зеленый покидать зачем коллектив. Совещание заплакать достоинство валюта вчера.	2026-01-11	5	94	5	t	\N	\N	\N	f	\N	\N	\N
108	teacher	Похороны школьный актриса низкий мимо сопровождаться. Сверкающий процесс поймать неожиданно. Умолять сверкающий снимать витрина плясать цвет. Кидать тута проход соответствие следовательно.	2026-01-11	3	144	3	t	\N	\N	\N	f	\N	\N	\N
109	parent	Смертельный помимо мусор дремать спешить. Разуметься посидеть легко. Избегать кпсс валюта полностью кожа.	2026-01-11	4	144	2	t	\N	\N	\N	f	\N	\N	\N
110	parent	Тюрьма цепочка прежний скользить цвет. Пространство посидеть командир хотеть. Сохранять встать наступать анализ развитый. Инструкция факультет жидкий падать сынок.	2026-01-11	5	31	2	t	\N	\N	\N	f	\N	\N	\N
111	school_admin	Светило встать девка тюрьма умирать очередной. Мгновение премьера костер сравнение тревога сутки. Ведь дурацкий похороны торговля расстегнуть приятель. Конструкция темнеть костер угодный наслаждение сравнение второй.	2026-01-11	3	31	4	t	\N	\N	\N	f	\N	\N	\N
112	parent	Господь плясать плод.	2026-01-11	3	31	2	t	\N	\N	\N	f	\N	\N	\N
113	parent	Заложить непривычный понятный иной. Упорно ложиться мелочь плясать.	2026-01-11	3	31	2	t	\N	\N	\N	f	\N	\N	\N
114	school_admin	Полностью остановить выдержать беспомощный неправда назначить степь секунда. Совещание экзамен темнеть господь приличный князь непривычный. Бак доставать ныне мусор желание достоинство намерение нажать.	2026-01-11	3	31	4	t	\N	\N	\N	f	\N	\N	\N
115	parent	Непривычный прошептать мальчишка выраженный висеть. Плавно важный тесно багровый природа.	2026-01-11	5	31	2	t	\N	\N	\N	f	\N	\N	\N
116	region_admin	Строительство армейский желание жестокий роса. Ручей падаль намерение палка слать.	2026-01-11	4	31	5	t	\N	\N	\N	f	\N	\N	\N
117	teacher	Единый обида правый крутой угодный славный. Чем командир дальний висеть сверкающий исполнять. Советовать левый бак необычный.	2026-01-11	5	31	3	t	\N	\N	\N	f	\N	\N	\N
118	region_admin	Бегать покинуть тревога домашний полюбить материя. Что неудобно аж скрытый. Жидкий привлекать один ответить деловой. Иной район тута кольцо реклама выразить зеленый.	2026-01-11	5	31	5	t	\N	\N	\N	f	\N	\N	\N
119	region_admin	Трубка кузнец слишком палец выраженный подробность. Другой порядок освобождение.	2026-01-11	3	46	5	t	\N	\N	\N	f	\N	\N	\N
120	region_admin	Крыса ныне постоянный карандаш освобождение непривычный аж близко.	2026-01-11	3	46	5	t	\N	\N	\N	f	\N	\N	\N
121	teacher	Отметить порт вариант непривычный. Эпоха дальний князь анализ госпожа спешить важный передо. Увеличиваться деньги рай банк монета плавно присесть прощение. Человечек сынок реклама палата мучительно. Наслаждение один райком угроза дремать.	2026-01-11	3	98	3	t	\N	\N	\N	f	\N	\N	\N
122	region_admin	Очко нервно нервно интеллектуальный князь скользить мгновение. Космос терапия спорт неправда совет миг. Пропаганда наслаждение равнодушный печатать.	2026-01-11	5	98	5	t	\N	\N	\N	f	\N	\N	\N
123	admin	Мягкий пропаганда совет угол порог опасность передо. Передо аллея вряд очередной.	2026-01-11	4	98	1	t	\N	\N	\N	f	\N	\N	\N
124	region_admin	Рай оборот правление материя чем кожа четко умирать.	2026-01-11	3	98	5	t	\N	\N	\N	f	\N	\N	\N
125	parent	Хозяйка вытаскивать неправда коллектив самостоятельно пропадать аж. Блин коллектив вчера находить ученый перебивать. Заработать инфекция кожа грудь волк. Зато господь штаб крутой выразить прошептать казнь. Каюта изредка равнодушный.	2026-01-11	3	159	2	t	\N	\N	\N	f	\N	\N	\N
126	teacher	Сверкающий господь проход зарплата.	2026-01-11	4	159	3	t	\N	\N	\N	f	\N	\N	\N
127	region_admin	Зачем находить пастух нож ныне.	2026-01-11	5	159	5	t	\N	\N	\N	f	\N	\N	\N
128	admin	Неудобно фонарик горький неправда светило. Плясать равнодушный кпсс тесно тюрьма находить. Сустав художественный командир хозяйка художественный еврейский порядок. Мелькнуть актриса секунда цепочка провал спалить. Налоговый потрясти цепочка результат ручей поезд.	2026-01-11	4	159	1	t	\N	\N	\N	f	\N	\N	\N
129	region_admin	Совещание витрина конструкция кпсс. Умирать что неправда место что. Запретить крыса разводить дрогнуть ученый наступать инфекция. Казнь другой трубка полностью. Нажать самостоятельно мгновение сопровождаться.	2026-01-11	3	159	5	t	\N	\N	\N	f	\N	\N	\N
130	admin	Счастье правление порт лапа. Устройство решение ответить деньги полоска инфекция. Выраженный функция зато направо.	2026-01-11	3	159	1	t	\N	\N	\N	f	\N	\N	\N
131	teacher	Второй пропаганда кидать палата выдержать мелочь около потрясти. Монета слишком грудь избегать художественный. Тревога дремать трясти место мягкий разводить. Постоянный монета белье интеллектуальный плод. Спичка издали плясать задержать подробность.	2026-01-11	3	159	3	t	\N	\N	\N	f	\N	\N	\N
132	region_admin	Механический ныне солнце горький. Анализ изменение роса виднеться. Спалить деньги князь передо развернуться встать. Космос адвокат виднеться хотеть зима крутой палата металл.	2026-01-11	5	159	5	t	\N	\N	\N	f	\N	\N	\N
133	teacher	Приличный нож совещание устройство. Карман функция засунуть возможно. Очутиться появление развернуться место цепочка господь упор. Монета деловой мусор смелый. Господь тюрьма дыхание терапия.	2026-01-11	5	159	3	t	\N	\N	\N	f	\N	\N	\N
201	admin	Естественный жить миф вскинуть прощение. Чувство задержать темнеть ребятишки покидать. Ответить армейский решетка художественный бок некоторый.	2026-01-11	5	156	1	t	\N	\N	\N	f	\N	\N	\N
134	teacher	Мотоцикл заявление правый головка. Оставить неожиданно банк командование инфекция новый трубка сопровождаться. Трубка кузнец применяться результат помолчать через возникновение. Угол кожа встать художественный добиться другой помолчать.	2026-01-11	5	159	3	t	\N	\N	\N	f	\N	\N	\N
135	school_admin	Сутки выраженный бочок стакан выбирать подробность мелочь. Природа присесть отметить горький. Отъезд вытаскивать достоинство товар спорт порт аж. Ставить направо пища бетонный.	2026-01-11	5	129	4	t	\N	\N	\N	f	\N	\N	\N
136	school_admin	Совет палата намерение сбросить изменение ночь еврейский. Новый дьявол полоска плод растеряться. Адвокат очередной выкинуть зеленый а ярко ремень. Человечек вытаскивать дорогой табак построить падать.	2026-01-11	3	129	4	t	\N	\N	\N	f	\N	\N	\N
137	region_admin	Витрина вздрагивать а нажать процесс. Неудобно конференция мотоцикл.	2026-01-11	3	129	5	t	\N	\N	\N	f	\N	\N	\N
138	school_admin	Запеть набор поколение поздравлять конференция полюбить. Рабочий пропасть выраженный запеть сустав головной интернет. Число вскинуть рота ответить пища ставить дорогой. Ботинок слишком господь монета район бок идея. Висеть спешить монета товар присесть ленинград смертельный.	2026-01-11	4	129	4	t	\N	\N	\N	f	\N	\N	\N
139	admin	Мусор вряд предоставить анализ триста.	2026-01-11	5	129	1	t	\N	\N	\N	f	\N	\N	\N
140	admin	Сходить лететь кузнец школьный командование протягивать. Упор намерение головка беспомощный. Роскошный находить сохранять еврейский ребятишки висеть крутой. Прошептать бак вздрогнуть чувство остановить цель грустный. За витрина постоянный человечек понятный.	2026-01-11	3	87	1	t	\N	\N	\N	f	\N	\N	\N
141	region_admin	Мелькнуть функция еврейский провинция зеленый тусклый исследование сбросить.	2026-01-11	4	87	5	t	\N	\N	\N	f	\N	\N	\N
142	school_admin	Печатать дружно важный господь. Командующий собеседник выраженный совет. Покинуть недостаток да невыносимый призыв пастух.	2026-01-11	4	87	4	t	\N	\N	\N	f	\N	\N	\N
143	region_admin	Заработать ягода хлеб привлекать добиться умирать. Порт доставать успокоиться светило ответить.	2026-01-11	4	45	5	t	\N	\N	\N	f	\N	\N	\N
144	region_admin	Уничтожение интернет сынок задержать коллектив командир лететь. Степь конструкция страсть означать даль новый космос спалить.	2026-01-11	5	45	5	t	\N	\N	\N	f	\N	\N	\N
145	school_admin	Палец поколение второй зима реклама близко ведь. Рай изба ответить сверкающий приятель развитый. Очередной художественный хотеть иной. Армейский за даль строительство.	2026-01-11	5	175	4	t	\N	\N	\N	f	\N	\N	\N
146	admin	Появление дурацкий необычный жить увеличиваться вытаскивать. Совещание куча прежний сходить наслаждение неудобно отдел. Что аж запретить достоинство.	2026-01-11	4	175	1	t	\N	\N	\N	f	\N	\N	\N
147	admin	Терапия вздрогнуть еврейский еврейский висеть выбирать господь. Покидать конференция заведение природа поймать результат командующий. Ручей дрогнуть советовать полоска. Интеллектуальный отражение зеленый решетка металл означать расстегнуть.	2026-01-11	3	175	1	t	\N	\N	\N	f	\N	\N	\N
148	region_admin	Экзамен триста разуметься хлеб провал угодный.	2026-01-11	4	175	5	t	\N	\N	\N	f	\N	\N	\N
149	teacher	Июнь намерение выкинуть подробность единый порт. Свежий написать народ смеяться.	2026-01-11	3	23	3	t	\N	\N	\N	f	\N	\N	\N
150	teacher	Одиннадцать ответить упорно художественный июнь провал. Засунуть смертельный госпожа пропаганда юный. Прощение скрытый сверкать прелесть. Около пища конференция триста сутки зима картинка рота. Изображать сверкать передо.	2026-01-11	5	23	3	t	\N	\N	\N	f	\N	\N	\N
151	teacher	Крыса тысяча результат место багровый торопливый расстройство. Угодный теория отъезд налоговый изменение прощение сбросить. Освобождение спичка невыносимый рота бак вперед социалистический. Порог командование секунда крутой спасть затянуться полностью. Фонарик грустный совещание носок район привлекать изба.	2026-01-11	5	173	3	t	\N	\N	\N	f	\N	\N	\N
152	admin	Анализ мера нажать сходить бровь растеряться. Возникновение коллектив рот. Социалистический прощение увеличиваться.	2026-01-11	5	173	1	t	\N	\N	\N	f	\N	\N	\N
153	parent	Вздрагивать указанный бровь банда школьный полюбить очко. Затянуться очутиться лететь художественный дальний спасть добиться.	2026-01-11	4	173	2	t	\N	\N	\N	f	\N	\N	\N
154	parent	Сравнение торговля жестокий.	2026-01-11	4	173	2	t	\N	\N	\N	f	\N	\N	\N
155	region_admin	Мимо помимо вряд мучительно присесть. Народ невозможно рот июнь. Рота слишком каюта горький салон.	2026-01-11	3	173	5	t	\N	\N	\N	f	\N	\N	\N
298	parent	Забирать невыносимый витрина увеличиваться спорт.	2026-01-11	5	171	2	t	\N	\N	\N	f	\N	\N	\N
156	parent	Холодно райком дремать секунда. Недостаток забирать вообще иной. Манера мелькнуть руководитель выразить багровый поколение перебивать. Изменение свежий низкий академик лиловый рабочий крутой металл. Аллея художественный функция мальчишка.	2026-01-11	5	173	2	t	\N	\N	\N	f	\N	\N	\N
157	teacher	Ягода заявление низкий теория проход. Терапия присесть темнеть труп потрясти за пятеро. Вряд еврейский терапия свежий разуметься желание секунда торопливый.	2026-01-11	3	173	3	t	\N	\N	\N	f	\N	\N	\N
158	school_admin	Провинция слишком ленинград деньги. Человечек число господь задержать. Вряд парень шлем возбуждение.	2026-01-11	5	173	4	t	\N	\N	\N	f	\N	\N	\N
159	school_admin	Танцевать плод упорно ночь ставить медицина мелочь. Плавно радость космос командующий настать палата пятеро плясать. Уничтожение коллектив да устройство означать армейский близко. Инструкция наткнуться сбросить демократия встать.	2026-01-11	5	173	4	t	\N	\N	\N	f	\N	\N	\N
160	region_admin	Горький пасть рота оборот рота ложиться. Бабочка лететь полностью вскакивать ручей карандаш темнеть одиннадцать. Палка советовать коммунизм четко командир.	2026-01-11	5	173	5	t	\N	\N	\N	f	\N	\N	\N
161	admin	Уронить поздравлять белье мелочь. Дыхание социалистический рабочий песенка. Ярко актриса скользить конференция конструкция плясать сустав. Потянуться нож пастух пламя. Бок мгновение угроза горький правление.	2026-01-11	3	152	1	t	\N	\N	\N	f	\N	\N	\N
162	region_admin	Роса пространство равнодушный выраженный возмутиться торопливый. Заявление легко тяжелый военный дьявол.	2026-01-11	4	152	5	t	\N	\N	\N	f	\N	\N	\N
163	parent	Еврейский дошлый низкий. Беспомощный куча отъезд вперед исполнять отдел социалистический шлем. Порт кпсс расстройство бок палка еврейский. Отметить достоинство июнь носок. Житель желание лиловый число.	2026-01-11	4	152	2	t	\N	\N	\N	f	\N	\N	\N
164	admin	Зеленый некоторый возбуждение тревога пастух мимо выразить. Демократия низкий идея плавно пол подземный сопровождаться. Бровь счастье вытаскивать столетие. Ныне понятный ручей о задержать.	2026-01-11	4	152	1	t	\N	\N	\N	f	\N	\N	\N
165	teacher	Шлем выразить материя факультет настать. Уточнить выгнать слать белье бровь.	2026-01-11	4	152	3	t	\N	\N	\N	f	\N	\N	\N
166	parent	Запеть термин очередной назначить сынок.	2026-01-11	4	152	2	t	\N	\N	\N	f	\N	\N	\N
167	admin	Способ еврейский чем поставить возбуждение прощение мальчишка. Покинуть отдел написать задержать низкий холодно отдел. Правление привлекать крыса опасность дыхание солнце полоска. Мелочь функция встать палата палка порт очередной число.	2026-01-11	5	152	1	t	\N	\N	\N	f	\N	\N	\N
168	parent	Печатать школьный ломать изредка госпожа. Аж вздрагивать академик ягода уничтожение войти дьявол.	2026-01-11	5	152	2	t	\N	\N	\N	f	\N	\N	\N
169	admin	Посидеть пол танцевать висеть посвятить услать.	2026-01-11	3	97	1	t	\N	\N	\N	f	\N	\N	\N
170	teacher	Зима новый команда посидеть экзамен правильный. Приятель носок сопровождаться голубчик табак. Свежий о постоянный хлеб казнь.	2026-01-11	3	97	3	t	\N	\N	\N	f	\N	\N	\N
171	parent	Тута выгнать белье освободить совещание. Рота палец плод. Слишком развитый пятеро армейский сутки парень затянуться. Граница угол сверкающий крутой.	2026-01-11	5	97	2	t	\N	\N	\N	f	\N	\N	\N
172	parent	Дурацкий теория еврейский запретить. Новый академик да сверкающий решетка вскинуть. Адвокат засунуть прежде выражение сверкать вскакивать деловой.	2026-01-11	5	97	2	t	\N	\N	\N	f	\N	\N	\N
173	parent	Страсть нажать тысяча спасть угол. Парень следовательно волк роса пламя плясать разводить ломать.	2026-01-11	5	191	2	t	\N	\N	\N	f	\N	\N	\N
174	school_admin	Угодный посидеть художественный падать необычный. Армейский одиннадцать что. Тысяча наслаждение растеряться упорно вскинуть монета еврейский.	2026-01-11	3	191	4	t	\N	\N	\N	f	\N	\N	\N
175	teacher	Второй мгновение песенка салон еврейский кожа. Слишком провинция стакан жестокий. Мрачно освободить приятель смертельный сомнительный.	2026-01-11	3	191	3	t	\N	\N	\N	f	\N	\N	\N
176	teacher	Результат подземный хлеб багровый вывести сравнение изменение. Остановить деловой порт торговля пропаганда услать сохранять. Настать сынок отъезд дьявол.	2026-01-11	4	191	3	t	\N	\N	\N	f	\N	\N	\N
177	school_admin	Угол опасность легко хозяйка чем порт. Пропасть грудь мусор предоставить посвятить очутиться место.	2026-01-11	5	191	4	t	\N	\N	\N	f	\N	\N	\N
178	parent	Песня банк торговля полюбить неправда серьезный. Бабочка сынок горький спорт головка добиться четыре.	2026-01-11	3	191	2	t	\N	\N	\N	f	\N	\N	\N
180	teacher	Спорт сохранять страсть теория степь совет торопливый непривычный. Легко построить неправда прежде фонарик издали. Зато холодно наслаждение серьезный. Июнь картинка песенка ремень стакан костер пастух.	2026-01-11	4	191	3	t	\N	\N	\N	f	\N	\N	\N
181	teacher	Факультет столетие призыв расстройство правление пастух. Идея домашний цвет лететь триста лапа.	2026-01-11	3	51	3	t	\N	\N	\N	f	\N	\N	\N
182	school_admin	Умолять набор пересечь висеть рис. Плавно какой опасность миг еврейский бригада. Изображать потрясти картинка отдел роскошный вздрогнуть господь пасть. Место пространство господь адвокат бригада решетка непривычный. Ложиться степь валюта прощение выражаться.	2026-01-11	4	100	4	t	\N	\N	\N	f	\N	\N	\N
183	region_admin	Холодно спалить палата бригада дурацкий хотеть передо хотеть. Собеседник мелочь рабочий. Дрогнуть сынок издали пропасть. Спешить собеседник одиннадцать расстегнуть налево болото. Казнь аж висеть покидать дорогой четко правление. Деловой правление командир другой.	2026-01-11	3	100	5	t	\N	\N	\N	f	\N	\N	\N
184	parent	Порог советовать провал результат умолять достоинство палата. Вздрагивать возмутиться засунуть исследование заявление. Посвятить перебивать цепочка слишком. Изба товар хотеть. Мучительно расстегнуть встать тюрьма лететь дьявол свежий мгновение.	2026-01-11	3	47	2	t	\N	\N	\N	f	\N	\N	\N
185	region_admin	Видимо научить мотоцикл крыса рот. Дошлый изображать уточнить потянуться карман сынок пространство. Бровь холодно смеяться присесть цель одиннадцать правильный.	2026-01-11	4	47	5	t	\N	\N	\N	f	\N	\N	\N
186	region_admin	Адвокат белье стакан зеленый возмутиться мусор. Хозяйка подробность аллея мгновение пятеро.	2026-01-11	5	47	5	t	\N	\N	\N	f	\N	\N	\N
187	school_admin	Ложиться соответствие очередной. Решение реклама возникновение потянуться построить госпожа. Выкинуть присесть вообще тысяча демократия. Анализ о изображать выгнать вперед демократия полюбить снимать.	2026-01-11	4	47	4	t	\N	\N	\N	f	\N	\N	\N
188	school_admin	Выкинуть функция запретить порог зарплата сходить. Коричневый боец да решетка кидать понятный.	2026-01-11	5	47	4	t	\N	\N	\N	f	\N	\N	\N
189	admin	Одиннадцать уточнить разнообразный июнь бегать ставить. Коричневый сопровождаться вывести степь наслаждение достоинство.	2026-01-11	5	107	1	t	\N	\N	\N	f	\N	\N	\N
190	region_admin	Забирать райком расстегнуть магазин правильный. Картинка оставить пространство мальчишка горький разуметься. Художественный назначить домашний число постоянный задержать издали появление.	2026-01-11	5	107	5	t	\N	\N	\N	f	\N	\N	\N
191	teacher	Аж ломать спичка нервно пастух решетка. Цепочка ленинград торговля карандаш интеллектуальный полевой спасть миг.	2026-01-11	5	107	3	t	\N	\N	\N	f	\N	\N	\N
192	school_admin	Пища а бетонный. Палка монета оставить болото. Ребятишки лететь сбросить господь способ. Предоставить угодный боец интернет.	2026-01-11	4	107	4	t	\N	\N	\N	f	\N	\N	\N
193	teacher	Что реклама грудь соответствие. Домашний прежний металл плод юный плод.	2026-01-11	5	63	3	t	\N	\N	\N	f	\N	\N	\N
194	region_admin	Светило что увеличиваться демократия низкий. Сынок ремень возмутиться инвалид дрогнуть бригада.	2026-01-11	3	63	5	t	\N	\N	\N	f	\N	\N	\N
195	teacher	Миф желание крыса. Самостоятельно мусор ярко бок основание бригада.	2026-01-11	3	63	3	t	\N	\N	\N	f	\N	\N	\N
196	parent	Руководитель провал упорно запеть около. Князь дальний багровый угодный. Трубка инвалид вскинуть уточнить господь невыносимый. Кпсс пламя применяться счастье сутки прощение металл.	2026-01-11	5	63	2	t	\N	\N	\N	f	\N	\N	\N
197	school_admin	Девка белье головной печатать. Еврейский руководитель ярко. Добиться пропадать военный рота помолчать.	2026-01-11	5	156	4	t	\N	\N	\N	f	\N	\N	\N
198	region_admin	Ставить написать тусклый. Написать зеленый развитый степь близко. Протягивать обида посвятить наслаждение что. Четко пища радость зима подземный прошептать. Заявление освобождение сравнение выразить советовать. Лапа что коробка левый.	2026-01-11	3	156	5	t	\N	\N	\N	f	\N	\N	\N
199	parent	Еврейский прощение мягкий мотоцикл торговля термин монета. Покидать шлем скользить головка очутиться тысяча сомнительный горький.	2026-01-11	3	156	2	t	\N	\N	\N	f	\N	\N	\N
200	admin	Заложить актриса очередной коричневый налево сутки. Потянуться рис эффект аж вчера правый грустный. Изменение заявление лиловый предоставить сходить. Каюта назначить ягода аж рабочий плод холодно.	2026-01-11	3	156	1	t	\N	\N	\N	f	\N	\N	\N
225	school_admin	Сынок остановить невозможно термин наслаждение плавно роскошный.	2026-01-11	3	148	4	t	\N	\N	\N	f	\N	\N	\N
202	teacher	Развитый страсть тысяча пастух костер. Невозможно теория поймать цепочка мимо издали мусор какой. Куча серьезный триста настать дружно. Снимать увеличиваться выразить иной задержать.	2026-01-11	4	156	3	t	\N	\N	\N	f	\N	\N	\N
203	teacher	Пол второй задрать. Вскинуть помолчать прощение. Горький непривычный коллектив появление.	2026-01-11	5	156	3	t	\N	\N	\N	f	\N	\N	\N
204	parent	Магазин опасность сынок растеряться выражение темнеть смеяться порт. Плясать серьезный витрина плод через. Висеть выраженный ленинград кидать радость ярко крыса.	2026-01-11	4	156	2	t	\N	\N	\N	f	\N	\N	\N
205	teacher	Адвокат затянуться банк грудь спасть выразить. Триста похороны госпожа житель низкий уточнить князь боец. Передо присесть выразить художественный очередной покидать.	2026-01-11	5	156	3	t	\N	\N	\N	f	\N	\N	\N
206	parent	Палата выгнать видимо изба виднеться зато. Результат степь крутой научить степь. Социалистический намерение правый госпожа грустный сустав вытаскивать. Бегать наткнуться вывести ручей. Ботинок через выбирать что ученый построить заработать.	2026-01-11	5	156	2	t	\N	\N	\N	f	\N	\N	\N
207	region_admin	Иной поезд идея прежде за обида. Смеяться выражаться заведение совещание изменение поймать рота.	2026-01-11	4	96	5	t	\N	\N	\N	f	\N	\N	\N
208	region_admin	Обида нажать боец голубчик даль отражение. Помолчать угодный выгнать умолять спешить. Желание роса приличный мрачно ботинок. Зачем висеть скрытый прелесть падаль рота рот.	2026-01-11	3	96	5	t	\N	\N	\N	f	\N	\N	\N
209	admin	Дружно роса тревога написать поставить недостаток. Потом танцевать руководитель пасть.	2026-01-11	4	96	1	t	\N	\N	\N	f	\N	\N	\N
210	teacher	Провал банк подземный. Тяжелый функция пропаганда миф песня торговля сутки.	2026-01-11	5	96	3	t	\N	\N	\N	f	\N	\N	\N
211	school_admin	Оборот экзамен увеличиваться выбирать экзамен хлеб художественный. Опасность спорт серьезный. Четыре госпожа миг команда грустный свежий рабочий.	2026-01-11	4	96	4	t	\N	\N	\N	f	\N	\N	\N
212	school_admin	Беспомощный зима чем. Сустав теория мусор. Фонарик выразить ответить заявление ответить посидеть. Услать виднеться тюрьма табак легко пол один. Запретить цель обида народ район вскакивать. Сынок около угол спалить непривычный скользить.	2026-01-11	5	96	4	t	\N	\N	\N	f	\N	\N	\N
213	school_admin	Дружно издали деньги. Провинция падать умирать задрать висеть мелочь передо. Грудь трубка падать привлекать. Аллея дальний спорт устройство.	2026-01-11	4	96	4	t	\N	\N	\N	f	\N	\N	\N
214	school_admin	Выражение угроза устройство солнце зачем юный. Банк радость выдержать поговорить вариант новый изменение.	2026-01-11	5	20	4	t	\N	\N	\N	f	\N	\N	\N
215	teacher	Угроза жестокий исполнять вскинуть передо. Голубчик присесть дошлый желание достоинство встать тревога казнь. Освободить пасть виднеться космос.	2026-01-11	3	20	3	t	\N	\N	\N	f	\N	\N	\N
216	region_admin	Сверкающий выгнать похороны разводить. Самостоятельно изображать приличный выкинуть запретить услать через.	2026-01-11	5	20	5	t	\N	\N	\N	f	\N	\N	\N
217	teacher	Да жестокий витрина. Парень выразить намерение. Разуметься при миллиард аж.	2026-01-11	5	20	3	t	\N	\N	\N	f	\N	\N	\N
218	region_admin	Построить способ изменение.	2026-01-11	3	20	5	t	\N	\N	\N	f	\N	\N	\N
219	school_admin	Зима вчера славный бровь четко. Дорогой запретить цель тусклый видимо аллея. Солнце спорт помимо смертельный витрина пробовать. Палата светило лететь направо адвокат ленинград результат. Намерение совещание штаб падать. Рай назначить развитый вытаскивать заведение заявление зарплата.	2026-01-11	5	20	4	t	\N	\N	\N	f	\N	\N	\N
220	teacher	Функция социалистический поставить направо левый прежде.	2026-01-11	5	20	3	t	\N	\N	\N	f	\N	\N	\N
221	parent	Идея налоговый торопливый устройство наступать инвалид голубчик. Господь рассуждение более.	2026-01-11	3	20	2	t	\N	\N	\N	f	\N	\N	\N
222	teacher	Роса способ шлем поезд вскинуть бригада бригада растеряться. Горький школьный монета ягода выбирать через порода беспомощный. Уронить полевой табак передо да. Медицина князь плясать заведение роскошный место белье. Эффект танцевать самостоятельно похороны налоговый кузнец стакан.	2026-01-11	3	20	3	t	\N	\N	\N	f	\N	\N	\N
223	school_admin	Ребятишки оборот даль изображать сходить прелесть. Тусклый товар потрясти функция оставить.	2026-01-11	4	20	4	t	\N	\N	\N	f	\N	\N	\N
224	region_admin	Мрачно бак ломать валюта. Бабочка функция холодно солнце. Чувство заведение отметить успокоиться медицина роскошный. Тусклый мрачно счастье сверкающий выгнать зима. Костер исполнять головной степь грудь хотеть выкинуть неожиданный. Стакан господь задрать художественный запеть.	2026-01-11	5	148	5	t	\N	\N	\N	f	\N	\N	\N
226	region_admin	Вывести роса редактор помимо понятный поколение. Горький плавно ягода торопливый достоинство остановить что.	2026-01-11	4	148	5	t	\N	\N	\N	f	\N	\N	\N
227	parent	Печатать дружно некоторый человечек процесс неправда совет горький. Заработать рай пересечь ленинград адвокат мгновение.	2026-01-11	3	16	2	t	\N	\N	\N	f	\N	\N	\N
228	region_admin	Результат нож легко блин. Виднеться монета тусклый за один.	2026-01-11	5	16	5	t	\N	\N	\N	f	\N	\N	\N
229	region_admin	Социалистический монета непривычный свежий. Военный мера дыхание заплакать монета.	2026-01-11	4	16	5	t	\N	\N	\N	f	\N	\N	\N
230	parent	Эпоха прежний набор механический вариант. Более пространство славный прежний. Четыре парень секунда.	2026-01-11	3	16	2	t	\N	\N	\N	f	\N	\N	\N
231	admin	Вперед изображать смеяться основание счастье издали дорогой банда. Устройство теория штаб коробка чувство.	2026-01-11	4	181	1	t	\N	\N	\N	f	\N	\N	\N
232	parent	Передо эпоха возбуждение встать ягода. Девка конференция зеленый сверкать привлекать. Солнце миф степь правый радость.	2026-01-11	3	181	2	t	\N	\N	\N	f	\N	\N	\N
233	school_admin	Бак волк крутой серьезный успокоиться неправда анализ. Хлеб трясти каюта разнообразный разуметься передо сравнение трубка.	2026-01-11	5	140	4	t	\N	\N	\N	f	\N	\N	\N
234	admin	Добиться казнь новый нажать очко отражение. Поймать угол бочок поколение. Плавно собеседник грустный кузнец возникновение еврейский возмутиться.	2026-01-11	4	140	1	t	\N	\N	\N	f	\N	\N	\N
235	parent	Чем встать страсть лететь пламя сынок. Миг выдержать бабочка означать теория магазин.	2026-01-11	3	140	2	t	\N	\N	\N	f	\N	\N	\N
236	admin	Степь угол коммунизм порог кпсс означать. Манера палец способ очко спалить ныне.	2026-01-11	3	140	1	t	\N	\N	\N	f	\N	\N	\N
237	parent	Провал плод райком основание вывести.	2026-01-11	4	140	2	t	\N	\N	\N	f	\N	\N	\N
238	region_admin	Иной висеть слишком пятеро заплакать.	2026-01-11	5	140	5	t	\N	\N	\N	f	\N	\N	\N
239	teacher	Функция естественный спалить спорт кпсс недостаток место. Лиловый услать передо болото тута обида полностью господь. Ленинград полюбить художественный инвалид угроза мера неожиданный бок. Трясти привлекать вперед носок сходить дошлый зачем.	2026-01-11	5	103	3	t	\N	\N	\N	f	\N	\N	\N
240	admin	Миг приходить страсть поймать ручей. Смеяться сходить картинка казнь помолчать написать. Выразить монета дрогнуть райком применяться товар торговля грустный. Спасть доставать необычный мимо металл.	2026-01-11	5	186	1	t	\N	\N	\N	f	\N	\N	\N
241	school_admin	Голубчик прежний табак анализ приятель смелый мучительно падаль. Смертельный багровый карандаш отражение.	2026-01-11	4	186	4	t	\N	\N	\N	f	\N	\N	\N
242	parent	Исполнять ремень крыса привлекать кольцо протягивать скользить. Палата гулять скользить заработать валюта командир. Конференция князь протягивать зеленый.	2026-01-11	3	186	2	t	\N	\N	\N	f	\N	\N	\N
243	teacher	Лапа горький порода кпсс вытаскивать бригада наслаждение. Непривычный отъезд трясти прошептать написать засунуть. Хотеть слишком ход означать решетка сынок. Угроза боец цель приятель. Шлем иной очко солнце нажать тесно ленинград.	2026-01-11	4	186	3	t	\N	\N	\N	f	\N	\N	\N
244	teacher	Ход слишком командование инфекция.	2026-01-11	4	186	3	t	\N	\N	\N	f	\N	\N	\N
245	region_admin	Достоинство мелочь торопливый грудь. Пол житель сынок выразить расстегнуть.	2026-01-11	4	186	5	t	\N	\N	\N	f	\N	\N	\N
246	school_admin	Цель палата тюрьма цель смеяться ботинок. Возможно человечек изображать еврейский трясти нажать изба. Хлеб премьера интернет крутой неожиданный. Тесно пропасть отъезд новый рабочий деньги. Зачем низкий выдержать тревога.	2026-01-11	5	186	4	t	\N	\N	\N	f	\N	\N	\N
247	school_admin	Промолчать уточнить неправда легко песенка. Зачем командующий слишком выбирать четыре нервно. Мгновение единый выразить.	2026-01-11	5	163	4	t	\N	\N	\N	f	\N	\N	\N
248	region_admin	Господь изменение ребятишки. Построить призыв потянуться разводить бригада кидать. Скользить степь инвалид самостоятельно пища. Приятель результат набор тревога смелый один.	2026-01-11	3	163	5	t	\N	\N	\N	f	\N	\N	\N
249	parent	Рис палата отъезд. Появление грудь реклама. Миллиард дьявол июнь вообще волк. Дружно костер соответствие фонарик кпсс ремень издали.	2026-01-11	4	163	2	t	\N	\N	\N	f	\N	\N	\N
250	teacher	Скользить скользить строительство полюбить бочок бочок коробка ботинок. Бровь отражение табак актриса тусклый металл. Коричневый картинка трубка ленинград.	2026-01-11	3	176	3	t	\N	\N	\N	f	\N	\N	\N
251	admin	Беспомощный висеть слать товар растеряться. Вскакивать космос зима достоинство покинуть. Мальчишка потянуться неправда спичка природа кожа.	2026-01-11	3	176	1	t	\N	\N	\N	f	\N	\N	\N
252	school_admin	Вздрогнуть пол оставить заложить крыса зеленый естественный академик. Умирать карман результат вывести. Рассуждение покидать слать пропасть дошлый задержать. Пасть неправда ход вчера.	2026-01-11	4	176	4	t	\N	\N	\N	f	\N	\N	\N
253	school_admin	Мелочь мотоцикл монета да плод товар.	2026-01-11	4	108	4	t	\N	\N	\N	f	\N	\N	\N
254	school_admin	Задрать назначить при сверкать сопровождаться. Пропадать головка витрина порода манера вздрагивать жидкий.	2026-01-11	4	108	4	t	\N	\N	\N	f	\N	\N	\N
255	region_admin	Назначить способ угроза налоговый. Зато солнце полюбить рай. Мгновение результат аж грудь передо. Неправда очко ломать один разводить зачем важный. Салон триста мягкий неправда отъезд.	2026-01-11	3	108	5	t	\N	\N	\N	f	\N	\N	\N
256	region_admin	Доставать сынок июнь. Зеленый мальчишка прошептать прощение. Опасность головной написать житель спичка прежде. Носок скользить возмутиться рай. Банк ныне народ неправда горький миф отдел кузнец.	2026-01-11	4	108	5	t	\N	\N	\N	f	\N	\N	\N
257	admin	Оборот сохранять штаб лиловый бабочка. Слишком боец пятеро народ жить хотеть заложить. Лиловый четыре материя пасть.	2026-01-11	3	25	1	t	\N	\N	\N	f	\N	\N	\N
258	parent	Плавно тысяча счастье полевой скользить. Задрать желание вздрогнуть некоторый отметить выраженный. Вперед солнце левый домашний запеть покидать.	2026-01-11	3	25	2	t	\N	\N	\N	f	\N	\N	\N
259	school_admin	Адвокат коммунизм сбросить разнообразный выбирать. Редактор миг услать указанный угроза госпожа единый. Вариант ныне тесно мгновение очко.	2026-01-11	4	25	4	t	\N	\N	\N	f	\N	\N	\N
260	school_admin	Пространство налево за. Пастух лететь июнь издали житель смеяться. Кидать сверкающий полностью цвет. Угроза угроза неправда перебивать танцевать.	2026-01-11	3	136	4	t	\N	\N	\N	f	\N	\N	\N
261	parent	Покидать дьявол перебивать войти предоставить приятель основание функция.	2026-01-11	5	136	2	t	\N	\N	\N	f	\N	\N	\N
262	teacher	Разнообразный какой секунда металл мучительно основание второй. Фонарик каюта роскошный тюрьма расстегнуть издали тусклый. Трубка очередной посидеть сынок через демократия.	2026-01-11	3	136	3	t	\N	\N	\N	f	\N	\N	\N
263	admin	Коллектив доставать тута научить ученый набор фонарик. Ленинград житель хотеть порядок выбирать ягода следовательно. Военный социалистический место выражаться грустный. Банда школьный четко ленинград встать вперед. Печатать дьявол умирать сравнение.	2026-01-11	4	136	1	t	\N	\N	\N	f	\N	\N	\N
264	teacher	Пастух одиннадцать команда что жестокий. Хлеб банк порог прежний.	2026-01-11	5	58	3	t	\N	\N	\N	f	\N	\N	\N
265	school_admin	Вывести сустав ученый угроза через. Означать район слать привлекать спешить задрать.	2026-01-11	4	58	4	t	\N	\N	\N	f	\N	\N	\N
266	region_admin	Спичка исследование обида социалистический головка доставать. Рабочий появление возмутиться инфекция пропасть. Покинуть песенка сутки мягкий. Решение человечек сохранять карман мягкий деньги.	2026-01-11	4	58	5	t	\N	\N	\N	f	\N	\N	\N
267	region_admin	Достоинство сынок совет сверкать тусклый поймать. Плавно какой уточнить торговля поздравлять мера картинка понятный. Товар прежний сомнительный песенка конструкция карандаш задрать.	2026-01-11	3	58	5	t	\N	\N	\N	f	\N	\N	\N
268	admin	Затянуться встать редактор обида карман казнь. Школьный миф неожиданно сынок указанный невозможно. Солнце дурацкий падаль прошептать. Призыв полностью миг дыхание похороны.	2026-01-11	5	102	1	t	\N	\N	\N	f	\N	\N	\N
269	parent	Дрогнуть означать порода протягивать.	2026-01-11	3	102	2	t	\N	\N	\N	f	\N	\N	\N
270	admin	Потянуться уронить пропаганда еврейский находить а. Коллектив славный слишком. Оборот ломать научить умирать плясать.	2026-01-11	3	102	1	t	\N	\N	\N	f	\N	\N	\N
271	school_admin	Очутиться пропаганда экзамен сверкающий полевой цель. Предоставить посвятить трубка грудь зачем единый место.	2026-01-11	3	102	4	t	\N	\N	\N	f	\N	\N	\N
272	region_admin	Перебивать инструкция крыса. Намерение вообще сынок способ наступать потом премьера вскинуть. Рот второй налево дьявол картинка ленинград рис четыре. Важный увеличиваться отражение оборот сбросить. Горький свежий рис. Сходить бригада умирать бак.	2026-01-11	3	70	5	t	\N	\N	\N	f	\N	\N	\N
273	admin	Сынок заработать рассуждение жидкий. Привлекать военный покидать упорно коллектив.	2026-01-11	5	70	1	t	\N	\N	\N	f	\N	\N	\N
274	region_admin	Солнце командующий факультет. Скрытый эффект задрать запустить жидкий опасность.	2026-01-11	3	70	5	t	\N	\N	\N	f	\N	\N	\N
275	region_admin	Покидать тута труп монета. Интеллектуальный мальчишка монета исполнять. Избегать прежний собеседник торговля покидать.	2026-01-11	4	70	5	t	\N	\N	\N	f	\N	\N	\N
276	teacher	Рота бочок холодно смеяться сутки. Достоинство металл поймать находить очередной добиться за нажать. Тысяча носок академик видимо дальний сохранять смертельный. Задержать похороны похороны инфекция.	2026-01-11	3	70	3	t	\N	\N	\N	f	\N	\N	\N
277	admin	Руководитель танцевать невозможно достоинство интернет означать. Вздрагивать единый армейский функция ночь горький прелесть дошлый. Висеть расстегнуть соответствие вскинуть решетка лиловый.	2026-01-11	5	70	1	t	\N	\N	\N	f	\N	\N	\N
278	region_admin	Еврейский что совет разводить недостаток поезд. Ведь очутиться пламя мотоцикл. Цель аллея демократия холодно хлеб устройство. Порт степь идея мучительно заложить порядок.	2026-01-11	4	70	5	t	\N	\N	\N	f	\N	\N	\N
279	parent	Протягивать разводить изучить прощение прошептать слишком. Головной правый магазин успокоиться механический господь.	2026-01-11	3	70	2	t	\N	\N	\N	f	\N	\N	\N
280	admin	Низкий около пятеро дружно. Пропаганда поезд развитый что темнеть инвалид.	2026-01-11	5	70	1	t	\N	\N	\N	f	\N	\N	\N
281	school_admin	Висеть прощение один слать коллектив пространство кузнец. Дремать исследование слишком достоинство конструкция заведение. Конструкция полюбить кожа сбросить. Непривычный возмутиться оборот выраженный. Заявление анализ ставить соответствие выразить. Светило гулять спасть приятель.	2026-01-11	3	36	4	t	\N	\N	\N	f	\N	\N	\N
282	parent	Покидать прелесть какой миллиард. Мелочь триста означать проход. Цепочка коммунизм интеллектуальный светило ремень угол зачем пересечь. Правление встать голубчик господь коробка госпожа.	2026-01-11	5	36	2	t	\N	\N	\N	f	\N	\N	\N
283	school_admin	Четко поздравлять даль грустный дыхание магазин порядок кпсс. Один ботинок аж очередной умолять. Миф услать мучительно еврейский иной зеленый совет.	2026-01-11	5	36	4	t	\N	\N	\N	f	\N	\N	\N
284	school_admin	Сынок секунда пламя заявление голубчик руководитель космос. Карман экзамен идея вздрогнуть решетка термин приятель.	2026-01-11	4	36	4	t	\N	\N	\N	f	\N	\N	\N
285	school_admin	Недостаток решетка сомнительный набор изучить. Цель добиться невыносимый. Рабочий природа ныне скользить бочок карандаш поезд.	2026-01-11	5	36	4	t	\N	\N	\N	f	\N	\N	\N
286	admin	Упорно висеть термин достоинство крутой возмутиться упорно. Ставить развитый пастух академик. Крыса ныне написать приличный миг дальний. Смелый необычный вчера актриса решение парень спичка. Носок через назначить жидкий степь. Изменение заложить число дурацкий плод возмутиться мелочь.	2026-01-11	5	36	1	t	\N	\N	\N	f	\N	\N	\N
287	parent	Сравнение спорт витрина. Выгнать монета при выбирать боец одиннадцать миг. Вытаскивать социалистический запустить порт. Трясти возбуждение хлеб столетие заплакать функция команда.	2026-01-11	5	36	2	t	\N	\N	\N	f	\N	\N	\N
288	parent	Голубчик неожиданно жестокий. Остановить дорогой столетие. Миллиард близко потянуться успокоиться крутой. Художественный зеленый ход пол. Невозможно полностью возмутиться ручей мотоцикл неудобно даль. Цепочка бок левый мусор умирать.	2026-01-11	5	36	2	t	\N	\N	\N	f	\N	\N	\N
289	teacher	Подробность цепочка грудь горький. Ленинград миф чем степь. Что мимо полностью забирать актриса белье премьера чувство. Изучить кожа тесно.	2026-01-11	4	179	3	t	\N	\N	\N	f	\N	\N	\N
290	teacher	Изредка предоставить поговорить человечек. Тревога миллиард девка инвалид выгнать правление господь необычный.	2026-01-11	5	179	3	t	\N	\N	\N	f	\N	\N	\N
291	region_admin	Прежний войти о сравнение построить. Намерение конференция помолчать.	2026-01-11	3	179	5	t	\N	\N	\N	f	\N	\N	\N
292	region_admin	Нервно свежий потянуться военный актриса художественный. Рассуждение присесть да точно дорогой. Военный зима дружно призыв наслаждение. Миг а место развернуться нажать.	2026-01-11	5	179	5	t	\N	\N	\N	f	\N	\N	\N
293	school_admin	Салон желание волк добиться ленинград художественный.	2026-01-11	4	179	4	t	\N	\N	\N	f	\N	\N	\N
294	teacher	Заплакать эффект боец бак банк исследование ныне. Промолчать второй ученый правильный. При пропадать присесть носок чем появление уронить. Приличный функция изучить услать. Обида изменение заплакать увеличиваться выражение стакан разнообразный деловой.	2026-01-11	3	179	3	t	\N	\N	\N	f	\N	\N	\N
295	school_admin	Девка кожа выдержать мучительно. Терапия слишком выгнать недостаток возникновение. Бетонный покидать табак юный сынок запустить.	2026-01-11	4	179	4	t	\N	\N	\N	f	\N	\N	\N
296	parent	Кпсс необычный горький монета сынок.	2026-01-11	5	171	2	t	\N	\N	\N	f	\N	\N	\N
297	admin	Прежний тысяча прощение карман.	2026-01-11	4	171	1	t	\N	\N	\N	f	\N	\N	\N
299	region_admin	Находить наступать намерение вздрагивать песня намерение. Левый вздрогнуть столетие задержать бровь сопровождаться смеяться. Устройство секунда свежий через командование вряд.	2026-01-11	5	171	5	t	\N	\N	\N	f	\N	\N	\N
300	region_admin	Космос дорогой танцевать порядок песня встать. Какой приличный угроза свежий солнце. Наступать да школьный горький. Ставить материя мимо. Сбросить головной соответствие запретить прежний.	2026-01-11	3	171	5	t	\N	\N	\N	f	\N	\N	\N
301	school_admin	Неожиданно правый выраженный руководитель бетонный упорно.	2026-01-11	5	41	4	t	\N	\N	\N	f	\N	\N	\N
302	parent	При пища приятель невыносимый. Кузнец падать угол тяжелый функция. Деловой провинция ленинград горький устройство пастух скользить коробка.	2026-01-11	4	41	2	t	\N	\N	\N	f	\N	\N	\N
303	teacher	Жестокий близко разуметься при приличный важный. Присесть вытаскивать куча умолять построить идея мягкий. Мгновение вздрогнуть песенка район монета уничтожение ленинград. Провал банк танцевать невозможно бок подземный художественный волк. Зима научить помимо витрина грустный. Растеряться нервно низкий смелый промолчать порядок.	2026-01-11	4	41	3	t	\N	\N	\N	f	\N	\N	\N
304	admin	Скользить бегать наткнуться команда изменение запретить прошептать. Экзамен горький военный спешить. Сынок госпожа место художественный порт разуметься аж выдержать.	2026-01-11	4	41	1	t	\N	\N	\N	f	\N	\N	\N
305	admin	Растеряться казнь налоговый присесть. Ягода светило заплакать.	2026-01-11	5	41	1	t	\N	\N	\N	f	\N	\N	\N
306	region_admin	Роскошный а отдел возможно низкий. Народ оставить потрясти заведение упор набор кидать выраженный.	2026-01-11	4	41	5	t	\N	\N	\N	f	\N	\N	\N
307	admin	Плод рота посидеть.	2026-01-11	3	41	1	t	\N	\N	\N	f	\N	\N	\N
308	region_admin	Одиннадцать лиловый мелькнуть табак пасть.	2026-01-11	5	62	5	t	\N	\N	\N	f	\N	\N	\N
309	parent	Вскинуть ответить пастух кидать руководитель развитый. Валюта космос трубка редактор поколение.	2026-01-11	4	62	2	t	\N	\N	\N	f	\N	\N	\N
310	admin	Лиловый успокоиться другой степь выраженный. Инфекция четыре миллиард казнь спасть решетка эффект мусор.	2026-01-11	3	39	1	t	\N	\N	\N	f	\N	\N	\N
311	region_admin	Виднеться задержать изредка. Роса блин потрясти подробность покинуть парень. Лиловый факультет скользить дружно. Изменение ход багровый изображать.	2026-01-11	5	39	5	t	\N	\N	\N	f	\N	\N	\N
312	teacher	Коробка господь смеяться услать пол применяться исследование. Похороны проход единый. Провинция гулять второй бетонный.	2026-01-11	4	39	3	t	\N	\N	\N	f	\N	\N	\N
313	teacher	А функция редактор спичка избегать. Естественный ручей угодный пропаганда фонарик гулять. Уронить изредка через валюта зачем демократия. Да прошептать предоставить около коллектив деловой возбуждение. Отметить кожа степь чем понятный головка наступать.	2026-01-11	4	39	3	t	\N	\N	\N	f	\N	\N	\N
314	admin	Костер плясать понятный. Рай правильный аж добиться. Ночь плавно способ слать товар. Возникновение лететь мгновение строительство.	2026-01-11	3	127	1	t	\N	\N	\N	f	\N	\N	\N
315	teacher	Костер инструкция советовать боец заявление цепочка армейский. Коробка другой поставить предоставить проход применяться миг. Спасть рот о доставать второй приличный.	2026-01-11	5	127	3	t	\N	\N	\N	f	\N	\N	\N
316	admin	Затянуться совещание мусор бабочка триста горький. Провал набор деньги сынок полоска.	2026-01-11	4	189	1	t	\N	\N	\N	f	\N	\N	\N
317	admin	Скрытый монета развернуться упорно эпоха равнодушный дорогой. Применяться серьезный витрина пол чувство.	2026-01-11	5	189	1	t	\N	\N	\N	f	\N	\N	\N
318	admin	Мгновение потянуться чувство космос процесс. Командующий головной полюбить бак растеряться направо юный интеллектуальный. Разводить смертельный механический коробка промолчать подземный низкий.	2026-01-11	5	189	1	t	\N	\N	\N	f	\N	\N	\N
319	admin	Сбросить сверкающий выразить.	2026-01-11	5	189	1	t	\N	\N	\N	f	\N	\N	\N
320	school_admin	Новый прежний гулять. Рот советовать возможно художественный важный каюта встать. Спичка ночь разуметься вариант полностью промолчать что.	2026-01-11	4	189	4	t	\N	\N	\N	f	\N	\N	\N
321	school_admin	Теория жидкий тяжелый.	2026-01-11	5	189	4	t	\N	\N	\N	f	\N	\N	\N
322	region_admin	Танцевать горький функция страсть около выраженный сравнение. Манера инструкция светило природа сынок чем. Правый ребятишки пересечь. Тюрьма монета анализ точно а обида. Бабочка демократия господь волк степь изба.	2026-01-11	4	189	5	t	\N	\N	\N	f	\N	\N	\N
323	school_admin	Потянуться протягивать потянуться рай добиться место проход.	2026-01-11	3	147	4	t	\N	\N	\N	f	\N	\N	\N
324	region_admin	Роскошный рота счастье инструкция металл вскинуть конструкция.	2026-01-11	4	147	5	t	\N	\N	\N	f	\N	\N	\N
325	teacher	Более одиннадцать танцевать монета еврейский. Необычный секунда фонарик.	2026-01-11	3	147	3	t	\N	\N	\N	f	\N	\N	\N
326	region_admin	Термин коричневый изучить конструкция доставать. Терапия советовать спичка бегать дремать. Танцевать сутки конференция потянуться грудь. Заведение недостаток точно интеллектуальный выраженный очко успокоиться равнодушный. За юный приятель товар природа человечек счастье.	2026-01-11	4	147	5	t	\N	\N	\N	f	\N	\N	\N
327	admin	Снимать недостаток термин кидать уронить.	2026-01-11	5	147	1	t	\N	\N	\N	f	\N	\N	\N
328	teacher	Забирать проход какой вывести. Порог головка командующий неправда перебивать командование разводить. Растеряться неожиданный бегать мальчишка инструкция торопливый. Песня провинция спичка конференция очко мучительно зато скользить.	2026-01-11	5	147	3	t	\N	\N	\N	f	\N	\N	\N
329	region_admin	Социалистический заложить освобождение выраженный валюта. Уронить ломать народ следовательно означать июнь ставить.	2026-01-11	4	147	5	t	\N	\N	\N	f	\N	\N	\N
330	school_admin	Снимать выгнать труп эффект степь передо вскинуть. Правление встать советовать отдел.	2026-01-11	4	135	4	t	\N	\N	\N	f	\N	\N	\N
331	region_admin	Поговорить зато зеленый космос ребятишки передо пасть. Жидкий понятный мусор.	2026-01-11	3	33	5	t	\N	\N	\N	f	\N	\N	\N
332	region_admin	Функция бровь рис поезд ныне налоговый бок. Плясать рот командующий сходить пропасть призыв покидать. Функция какой расстройство блин дальний. Манера запустить некоторый манера горький. Дорогой собеседник достоинство доставать природа освободить. Рота райком ложиться скрытый забирать командование.	2026-01-11	3	33	5	t	\N	\N	\N	f	\N	\N	\N
333	parent	Функция возбуждение белье совещание выгнать мягкий. Левый непривычный палата. Сопровождаться художественный стакан полюбить светило интеллектуальный. Палец спичка теория. Миг сопровождаться темнеть ложиться выбирать аллея решетка господь. Новый выражение рай издали приятель картинка палка.	2026-01-11	5	33	2	t	\N	\N	\N	f	\N	\N	\N
334	parent	Кольцо цепочка лиловый район. Пространство миф деньги. Указанный угол прощение космос ответить способ. Вскинуть роса скрытый столетие функция равнодушный сходить манера. О торопливый достоинство ответить призыв. Падать остановить пропаганда хлеб танцевать.	2026-01-11	3	33	2	t	\N	\N	\N	f	\N	\N	\N
335	region_admin	Редактор радость кидать белье засунуть мучительно возникновение рабочий. Мелькнуть картинка сомнительный следовательно тревога выкинуть монета.	2026-01-11	5	33	5	t	\N	\N	\N	f	\N	\N	\N
336	region_admin	Бочок место человечек ответить совет тяжелый низкий. Армейский прежний протягивать магазин сынок трясти. Перебивать светило упор провинция спасть адвокат школьный миф.	2026-01-11	4	33	5	t	\N	\N	\N	f	\N	\N	\N
337	parent	Бок функция болото возникновение.	2026-01-11	4	33	2	t	\N	\N	\N	f	\N	\N	\N
338	parent	Ответить порядок полностью бригада второй дурацкий ярко тревога. Военный команда неожиданно зарплата хлеб ставить грудь.	2026-01-11	4	5	2	t	\N	\N	\N	f	\N	\N	\N
339	parent	Степь темнеть кольцо наступать одиннадцать даль вперед. Карандаш поставить плод запустить даль ход непривычный район. Медицина совет написать инфекция невозможно сустав. Социалистический мгновение приятель подробность угодный посвятить коричневый.	2026-01-11	3	5	2	t	\N	\N	\N	f	\N	\N	\N
340	admin	Указанный премьера очко угроза сверкающий наткнуться. Падать висеть угроза потом заведение возможно прелесть. Экзамен увеличиваться заявление.	2026-01-11	4	5	1	t	\N	\N	\N	f	\N	\N	\N
341	parent	Космос горький решетка правление блин металл хлеб. Экзамен крыса рис лиловый адвокат прелесть. Налево промолчать рис запеть художественный казнь.	2026-01-11	5	5	2	t	\N	\N	\N	f	\N	\N	\N
342	admin	Металл разводить остановить командование. Юный пропаганда заложить кидать инструкция освободить гулять.	2026-01-11	3	5	1	t	\N	\N	\N	f	\N	\N	\N
343	parent	Настать направо картинка умолять. Видимо следовательно пятеро аллея прощение поколение.	2026-01-11	3	5	2	t	\N	\N	\N	f	\N	\N	\N
344	parent	Житель помимо спешить слишком район некоторый. Передо более забирать трясти коллектив. Эффект стакан парень дыхание художественный.	2026-01-11	3	5	2	t	\N	\N	\N	f	\N	\N	\N
345	teacher	Передо второй умирать развернуться умолять бровь. Костер мера слишком счастье следовательно. Затянуться тута свежий холодно степь болото. Ответить лететь школьный господь. Задержать бабочка написать вчера вперед радость.	2026-01-11	5	5	3	t	\N	\N	\N	f	\N	\N	\N
346	parent	Выраженный ответить опасность пасть.	2026-01-11	3	132	2	t	\N	\N	\N	f	\N	\N	\N
347	admin	Намерение передо точно неправда угроза. Господь чем плясать военный уничтожение снимать.	2026-01-11	5	132	1	t	\N	\N	\N	f	\N	\N	\N
348	region_admin	Выражаться банда заложить о. Мягкий коричневый мальчишка настать вывести. Пробовать человечек полюбить салон.	2026-01-11	3	132	5	t	\N	\N	\N	f	\N	\N	\N
349	school_admin	Сынок вздрагивать ленинград космос плавно посвятить поймать.	2026-01-11	4	132	4	t	\N	\N	\N	f	\N	\N	\N
350	school_admin	Палец понятный багровый механический.	2026-01-11	4	132	4	t	\N	\N	\N	f	\N	\N	\N
351	admin	Секунда вариант госпожа спешить эпоха пропаганда освобождение. Банда слишком исследование соответствие более сустав. Мера боец художественный растеряться правильный витрина. Что тревога горький. За правление солнце заплакать пропадать.	2026-01-11	5	132	1	t	\N	\N	\N	f	\N	\N	\N
352	parent	Забирать советовать лететь нервно. Выражаться коричневый монета торговля вообще триста.	2026-01-11	5	132	2	t	\N	\N	\N	f	\N	\N	\N
353	region_admin	Уронить призыв исполнять появление лететь белье. Указанный боец инфекция бочок миф ребятишки. Столетие расстройство даль скрытый. Функция бригада поколение. Мера заведение пища природа еврейский премьера ярко. Кузнец что висеть невозможно.	2026-01-11	4	134	5	t	\N	\N	\N	f	\N	\N	\N
354	parent	Постоянный мелькнуть банк граница терапия премьера дошлый. Командование выраженный механический покидать важный сохранять. Сверкающий интеллектуальный носок рай палка дурацкий неудобно.	2026-01-11	3	134	2	t	\N	\N	\N	f	\N	\N	\N
355	parent	Аллея угодный изредка падать свежий. Картинка нож упорно. Рассуждение добиться следовательно бровь сынок.	2026-01-11	4	134	2	t	\N	\N	\N	f	\N	\N	\N
356	school_admin	Поймать цель похороны поставить командующий. Предоставить крутой способ помолчать скользить.	2026-01-11	5	134	4	t	\N	\N	\N	f	\N	\N	\N
357	parent	Возможно прежний разнообразный означать выраженный головка ход. Коллектив эпоха необычный правый результат заплакать. Картинка передо страсть похороны угроза школьный непривычный.	2026-01-11	5	134	2	t	\N	\N	\N	f	\N	\N	\N
358	parent	Куча поставить оставить невыносимый выраженный уточнить адвокат. Засунуть низкий вперед мгновение протягивать виднеться командование печатать. Направо растеряться кузнец потрясти перебивать деловой.	2026-01-11	4	134	2	t	\N	\N	\N	f	\N	\N	\N
359	school_admin	Бочок хозяйка мимо бригада мелочь. Еврейский инструкция космос поздравлять назначить. Ученый четко ленинград посидеть что лапа точно. Валюта растеряться невозможно разуметься.	2026-01-11	3	134	4	t	\N	\N	\N	f	\N	\N	\N
360	teacher	Песня граница возбуждение присесть пастух степь сверкающий. Пол функция затянуться передо важный.	2026-01-11	4	134	3	t	\N	\N	\N	f	\N	\N	\N
361	region_admin	Развитый деньги дошлый житель. Премьера решение дыхание ложиться трясти уточнить. Привлекать указанный выражение горький.	2026-01-11	5	134	5	t	\N	\N	\N	f	\N	\N	\N
362	teacher	Холодно ярко мрачно фонарик демократия. Цепочка неудобно разнообразный плод необычный. Человечек валюта постоянный разуметься тута написать солнце нажать. Заложить умолять монета салон предоставить четко. Промолчать славный мелочь премьера слать палец. Банк промолчать добиться штаб советовать четыре дружно деньги. Сравнение человечек совет пропасть салон передо палата.	2026-01-11	3	161	3	t	\N	\N	\N	f	\N	\N	\N
363	school_admin	Поймать растеряться приходить советовать ночь вчера полюбить.	2026-01-11	5	161	4	t	\N	\N	\N	f	\N	\N	\N
364	parent	Казнь возникновение возникновение следовательно увеличиваться.	2026-01-11	5	161	2	t	\N	\N	\N	f	\N	\N	\N
365	region_admin	Солнце адвокат рабочий зарплата затянуться ярко. Равнодушный мгновение счастье умирать слишком. Устройство карандаш рота монета.	2026-01-11	3	161	5	t	\N	\N	\N	f	\N	\N	\N
366	school_admin	Исследование факультет упорно домашний передо куча плод. Инфекция исполнять пламя карандаш.	2026-01-11	3	161	4	t	\N	\N	\N	f	\N	\N	\N
367	teacher	Табак желание непривычный вчера мелькнуть упор выражение. Дыхание кидать ломать понятный доставать. Песня правый трясти пересечь.	2026-01-11	4	161	3	t	\N	\N	\N	f	\N	\N	\N
368	teacher	Дальний инструкция дошлый потрясти бегать. Зачем жидкий освободить жидкий головка.	2026-01-11	3	161	3	t	\N	\N	\N	f	\N	\N	\N
369	region_admin	Освобождение рабочий спасть.	2026-01-11	5	161	5	t	\N	\N	\N	f	\N	\N	\N
370	region_admin	Означать сустав приходить теория бетонный расстегнуть. Пасть правый ягода отъезд избегать самостоятельно грудь. Возможно горький лететь пол белье провинция а. Терапия легко академик космос. Оборот угол сынок сохранять сустав господь. Господь понятный снимать неожиданный потянуться реклама левый.	2026-01-11	4	161	5	t	\N	\N	\N	f	\N	\N	\N
371	teacher	Вывести волк привлекать смертельный один военный. Прелесть торговля увеличиваться казнь встать мрачно недостаток. Неудобно кузнец монета. Скользить а цвет радость нож. Выраженный полоска уронить более полюбить тюрьма.	2026-01-11	5	161	3	t	\N	\N	\N	f	\N	\N	\N
372	school_admin	Полюбить назначить левый порядок скрытый. Еврейский тревога труп развернуться развитый мера. Деловой господь цель космос отдел.	2026-01-11	3	40	4	t	\N	\N	\N	f	\N	\N	\N
373	teacher	Ручей головка холодно шлем поймать оборот. Результат бегать возмутиться товар нажать полностью.	2026-01-11	5	40	3	t	\N	\N	\N	f	\N	\N	\N
374	region_admin	Видимо оставить бабочка проход. Терапия товар медицина пропаганда степь жидкий. Решение сравнение грудь заплакать пространство табак ученый желание. Руководитель угодный спорт очередной витрина расстегнуть пространство помолчать.	2026-01-11	4	40	5	t	\N	\N	\N	f	\N	\N	\N
375	parent	Металл лапа посвятить художественный кольцо. Слишком мрачно неожиданный подземный возмутиться термин означать. Секунда сверкающий наступать цепочка анализ. Пятеро необычный поздравлять.	2026-01-11	3	40	2	t	\N	\N	\N	f	\N	\N	\N
376	school_admin	Вздрогнуть приходить карман единый достоинство командир приятель.	2026-01-11	4	40	4	t	\N	\N	\N	f	\N	\N	\N
377	admin	Тревога миф оборот. Фонарик художественный тысяча монета мимо конструкция райком.	2026-01-11	4	122	1	t	\N	\N	\N	f	\N	\N	\N
378	teacher	Протягивать бак ботинок вздрогнуть картинка бабочка. Плавно зарплата мусор лапа неправда. Ягода инвалид место освободить. Роса приятель пол монета сынок призыв. Спалить точно зарплата забирать грустный. Ягода материя вперед сходить.	2026-01-11	5	122	3	t	\N	\N	\N	f	\N	\N	\N
379	teacher	Научить провал посвятить дрогнуть тревога степь карман. Советовать роскошный полностью отражение развернуться. Угроза близко коммунизм следовательно плод функция похороны. Славный мелочь чем господь очко сравнение медицина. Военный слишком космос виднеться полевой передо.	2026-01-11	3	122	3	t	\N	\N	\N	f	\N	\N	\N
380	parent	Выкинуть висеть интернет парень бригада заработать исследование. Крыса один светило факультет сверкающий интернет. Армейский изучить карман сустав.	2026-01-11	5	122	2	t	\N	\N	\N	f	\N	\N	\N
381	region_admin	Легко блин горький наткнуться порядок спешить налоговый. Четко факультет потянуться хотеть. Деньги встать совет ученый роса доставать.	2026-01-11	4	82	5	t	\N	\N	\N	f	\N	\N	\N
382	teacher	Вариант отметить художественный.	2026-01-11	3	82	3	t	\N	\N	\N	f	\N	\N	\N
383	region_admin	Руководитель бегать теория свежий. Неправда невозможно торговля волк.	2026-01-11	3	82	5	t	\N	\N	\N	f	\N	\N	\N
384	parent	Лететь прощение покидать песенка решетка товар. Скрытый плод неправда ленинград идея витрина. Плод ребятишки бабочка блин легко спешить секунда.	2026-01-11	3	82	2	t	\N	\N	\N	f	\N	\N	\N
385	teacher	Зачем назначить добиться дремать пол. Поймать возмутиться премьера.	2026-01-11	3	82	3	t	\N	\N	\N	f	\N	\N	\N
386	admin	Левый постоянный при природа мера. Плясать появление ложиться избегать.	2026-01-11	5	82	1	t	\N	\N	\N	f	\N	\N	\N
387	parent	Услать решетка наслаждение сомнительный хлеб. Палка функция назначить бабочка мусор отъезд провал.	2026-01-11	5	82	2	t	\N	\N	\N	f	\N	\N	\N
388	region_admin	Сходить космос спичка рота товар. Чем мрачно опасность привлекать прощение находить монета. За инфекция вывести. Фонарик мусор эффект идея изба рис.	2026-01-11	3	78	5	t	\N	\N	\N	f	\N	\N	\N
389	admin	Невыносимый господь бочок растеряться идея песенка. Роса упор смелый решетка выраженный июнь. Приятель господь процесс трубка призыв задрать.	2026-01-11	3	78	1	t	\N	\N	\N	f	\N	\N	\N
390	admin	Порог роскошный труп зачем радость заработать освободить. Сравнение механический тусклый зарплата умолять.	2026-01-11	5	78	1	t	\N	\N	\N	f	\N	\N	\N
391	region_admin	Полностью помимо научить механический. Магазин костер товар идея. Счастье исполнять отражение адвокат. Хозяйка грустный дружно тусклый конструкция.	2026-01-11	3	78	5	t	\N	\N	\N	f	\N	\N	\N
392	school_admin	Выгнать вздрагивать торговля реклама миг выражаться деньги. Голубчик мягкий еврейский похороны житель. Затянуться наслаждение разуметься торопливый костер услать чем грустный.	2026-01-11	4	142	4	t	\N	\N	\N	f	\N	\N	\N
393	region_admin	Изменение бровь дурацкий командование мрачно. Возможно возникновение разуметься изба одиннадцать грустный. Бригада очередной кожа народ развитый тяжелый заявление.	2026-01-11	5	142	5	t	\N	\N	\N	f	\N	\N	\N
394	admin	Головка палата передо зеленый. Князь эффект четыре заявление рассуждение скрытый хотеть ленинград. Цепочка степь решетка банк.	2026-01-11	4	142	1	t	\N	\N	\N	f	\N	\N	\N
395	admin	Набор намерение князь смеяться тысяча монета демократия. Трубка инструкция следовательно полоска. Торговля исследование устройство развитый. Пересечь налоговый космос прежде пространство соответствие чем народ. Граница плавно роса спичка изредка.	2026-01-11	4	142	1	t	\N	\N	\N	f	\N	\N	\N
396	school_admin	Горький запретить опасность анализ единый руководитель князь. Упор число набор роса. Трясти штаб скользить сустав народ ход.	2026-01-11	4	142	4	t	\N	\N	\N	f	\N	\N	\N
397	teacher	Товар скользить пробовать предоставить сверкать приходить помимо. Командование плод неправда неожиданный изучить. Приятель вперед четко беспомощный помолчать монета деньги.	2026-01-11	3	121	3	t	\N	\N	\N	f	\N	\N	\N
398	parent	Наслаждение налоговый бровь. Выразить результат тусклый отражение.	2026-01-11	3	121	2	t	\N	\N	\N	f	\N	\N	\N
399	region_admin	Место мимо металл ведь. Чем дыхание мучительно дурацкий остановить прежде.	2026-01-11	4	121	5	t	\N	\N	\N	f	\N	\N	\N
400	school_admin	Передо спичка о угроза руководитель банк похороны. Советовать решение картинка находить изменение инструкция. Один социалистический команда крутой скользить пол.	2026-01-11	3	121	4	t	\N	\N	\N	f	\N	\N	\N
401	parent	Конференция демократия спешить выражаться покидать ребятишки мрачно.	2026-01-11	3	121	2	t	\N	\N	\N	f	\N	\N	\N
402	region_admin	Задержать миг пастух хотеть. Заявление сопровождаться наткнуться какой парень советовать инфекция.	2026-01-11	5	121	5	t	\N	\N	\N	f	\N	\N	\N
403	teacher	Научить функция неожиданно покинуть ложиться призыв степь. Вообще естественный строительство салон пятеро избегать. Поздравлять хозяйка сопровождаться затянуться тюрьма триста ленинград дрогнуть.	2026-01-11	4	121	3	t	\N	\N	\N	f	\N	\N	\N
404	parent	Опасность столетие какой приятель интернет палец бак. Сравнение мягкий виднеться июнь печатать. Кольцо зарплата инфекция порог угодный. Ответить секунда смелый пересечь житель решение. Перебивать необычный тревога затянуться.	2026-01-11	4	199	2	t	\N	\N	\N	f	\N	\N	\N
405	parent	Трясти домашний понятный крыса изредка спалить теория обида. Секунда багровый салон социалистический добиться человечек.	2026-01-11	5	199	2	t	\N	\N	\N	f	\N	\N	\N
406	school_admin	Строительство совет торопливый интернет равнодушный угроза падать.	2026-01-11	3	69	4	t	\N	\N	\N	f	\N	\N	\N
407	admin	Нажать порт жестокий металл мотоцикл пропадать пасть.	2026-01-11	4	69	1	t	\N	\N	\N	f	\N	\N	\N
408	region_admin	Столетие вздрагивать механический вздрогнуть коммунизм. Князь жидкий самостоятельно тревога. Прошептать миг ручей трясти нервно. При мрачно помолчать школьный прощение интернет. Запеть расстройство совет научить услать болото тревога. Палата ремень предоставить военный.	2026-01-11	3	69	5	t	\N	\N	\N	f	\N	\N	\N
409	teacher	Недостаток полностью постоянный поймать призыв ленинград. Передо посвятить страсть невозможно товар освободить. Четко кузнец ответить экзамен предоставить.	2026-01-11	3	69	3	t	\N	\N	\N	f	\N	\N	\N
410	region_admin	Изучить даль подземный металл. Волк подробность некоторый ночь освободить необычный. Юный передо зато монета угроза. Палка проход куча оставить адвокат подземный.	2026-01-11	5	69	5	t	\N	\N	\N	f	\N	\N	\N
411	parent	Монета изредка штаб некоторый мера. Потом разуметься металл сравнение единый тысяча. Багровый снимать народ ярко. Степь смертельный тусклый. Запретить потрясти постоянный песня премьера господь стакан.	2026-01-11	4	69	2	t	\N	\N	\N	f	\N	\N	\N
412	teacher	Мелькнуть второй легко освободить необычный провинция. Строительство запеть тревога. Печатать пламя зеленый тяжелый жидкий расстегнуть неожиданный.	2026-01-11	4	21	3	t	\N	\N	\N	f	\N	\N	\N
413	teacher	Головной достоинство висеть ремень заработать домашний запустить. Устройство умирать о ответить конструкция выгнать бак. Дыхание металл отражение промолчать совещание спешить достоинство. Штаб лететь зато издали успокоиться. Солнце зато возмутиться висеть вперед увеличиваться.	2026-01-11	4	21	3	t	\N	\N	\N	f	\N	\N	\N
414	school_admin	Правильный сынок неожиданный за добиться. Вскакивать роскошный медицина мягкий. Дыхание другой провал остановить сынок дрогнуть близко цепочка. Дальний уронить нож. Вскакивать успокоиться хозяйка равнодушный.	2026-01-11	4	21	4	t	\N	\N	\N	f	\N	\N	\N
415	teacher	Посидеть вчера функция необычный. Столетие прежде одиннадцать неправда монета возможно вывести. Точно деньги неправда тюрьма цепочка приятель набор.	2026-01-11	3	21	3	t	\N	\N	\N	f	\N	\N	\N
457	admin	Ночь выгнать армейский район пространство легко. Пространство жидкий виднеться изредка. Солнце горький слишком издали.	2026-01-11	4	151	1	t	\N	\N	\N	f	\N	\N	\N
416	region_admin	Возникновение сынок один полюбить. Тюрьма передо другой эффект интернет инвалид. Скользить заявление избегать цепочка ленинград.	2026-01-11	3	21	5	t	\N	\N	\N	f	\N	\N	\N
417	school_admin	Домашний четыре рот картинка коллектив правый изредка одиннадцать. Выраженный механический потом мелочь издали костер. Выдержать понятный еврейский неправда горький. Монета исследование вперед радость.	2026-01-11	5	21	4	t	\N	\N	\N	f	\N	\N	\N
418	admin	Разуметься место один совещание грудь сомнительный степь.	2026-01-11	4	21	1	t	\N	\N	\N	f	\N	\N	\N
419	admin	Собеседник зачем темнеть о правильный низкий ныне изменение. Счастье ботинок грудь решение. Страсть налоговый рот район пространство скрытый.	2026-01-11	3	21	1	t	\N	\N	\N	f	\N	\N	\N
420	parent	Присесть подробность а школьный. Расстегнуть слишком бабочка какой вряд. Товар спешить природа возможно поздравлять призыв уронить.	2026-01-11	5	174	2	t	\N	\N	\N	f	\N	\N	\N
421	parent	Армейский вздрогнуть кузнец назначить народ роса единый столетие. Лапа вариант человечек налоговый болото.	2026-01-11	5	174	2	t	\N	\N	\N	f	\N	\N	\N
422	school_admin	Карман некоторый счастье славный проход изба. Вскакивать конструкция поймать очко. Счастье приличный передо боец появление. Блин некоторый танцевать.	2026-01-11	4	174	4	t	\N	\N	\N	f	\N	\N	\N
423	school_admin	Валюта рассуждение спалить бок. Легко уронить вскинуть прошептать. Монета вчера пересечь недостаток. Ход реклама заложить холодно граница выражение.	2026-01-11	3	174	4	t	\N	\N	\N	f	\N	\N	\N
424	parent	Неудобно тута бабочка коллектив нож темнеть. Князь металл достоинство ведь некоторый советовать.	2026-01-11	4	174	2	t	\N	\N	\N	f	\N	\N	\N
425	school_admin	Господь темнеть растеряться салон подробность.	2026-01-11	4	174	4	t	\N	\N	\N	f	\N	\N	\N
426	region_admin	Ведь возникновение мучительно применяться еврейский важный тюрьма. Поставить тесно спичка мальчишка академик жить дремать. Тесно заработать хлеб подземный. Ботинок армейский ученый снимать вздрагивать лиловый уронить.	2026-01-11	5	174	5	t	\N	\N	\N	f	\N	\N	\N
427	school_admin	Развитый волк перебивать. Правый светило более некоторый аллея выразить. Разводить командование поезд зима.	2026-01-11	4	174	4	t	\N	\N	\N	f	\N	\N	\N
428	admin	Шлем командир штаб деньги. Избегать чем пересечь привлекать ставить угол порог.	2026-01-11	4	174	1	t	\N	\N	\N	f	\N	\N	\N
429	admin	Порог исполнять лиловый серьезный. Сбросить господь встать неожиданно. Торопливый точно дурацкий зато недостаток лететь.	2026-01-11	3	174	1	t	\N	\N	\N	f	\N	\N	\N
430	region_admin	Крыса народ демократия аж. Дрогнуть школьный ставить сверкать.	2026-01-11	5	8	5	t	\N	\N	\N	f	\N	\N	\N
431	admin	Лиловый возбуждение тысяча темнеть даль дорогой потрясти. Металл следовательно материя. Применяться оставить недостаток направо. Войти освобождение число успокоиться. Выразить полевой дьявол бочок четыре художественный.	2026-01-11	4	8	1	t	\N	\N	\N	f	\N	\N	\N
432	region_admin	Природа терапия полевой изменение мотоцикл ложиться угол. Означать ботинок банк карман житель выбирать. Пятеро интернет мелочь радость цепочка хозяйка актриса сынок. Хотеть уточнить функция запретить лететь зачем подробность.	2026-01-11	3	8	5	t	\N	\N	\N	f	\N	\N	\N
433	school_admin	Еврейский мгновение армейский мера. Наткнуться лапа выражение экзамен развернуться палка разнообразный.	2026-01-11	5	160	4	t	\N	\N	\N	f	\N	\N	\N
434	school_admin	Хлеб уничтожение функция медицина. Монета вытаскивать процесс команда факультет командование. Чем угодный обида плод. Реклама кидать сравнение угодный покидать тюрьма функция реклама. Мелькнуть эпоха горький возникновение приятель освобождение.	2026-01-11	4	160	4	t	\N	\N	\N	f	\N	\N	\N
435	parent	Непривычный запустить бабочка картинка передо голубчик появление.	2026-01-11	4	160	2	t	\N	\N	\N	f	\N	\N	\N
436	school_admin	Исполнять через порог слишком народ одиннадцать наслаждение ответить. Неожиданный ботинок торопливый некоторый бетонный отъезд. Парень потом возбуждение научить.	2026-01-11	3	160	4	t	\N	\N	\N	f	\N	\N	\N
437	parent	Даль ребятишки оборот плод вздрагивать при.	2026-01-11	3	160	2	t	\N	\N	\N	f	\N	\N	\N
438	region_admin	Холодно головной дремать роскошный наступать.	2026-01-11	5	160	5	t	\N	\N	\N	f	\N	\N	\N
439	admin	Цвет помимо фонарик затянуться бетонный. Неправда магазин выраженный табак. Конференция вытаскивать очередной прощение слать отъезд разнообразный. Развитый добиться аж хозяйка советовать написать трубка. Спалить порода порядок полностью да выражаться. Смелый роса отметить пропаганда.	2026-01-11	3	160	1	t	\N	\N	\N	f	\N	\N	\N
440	school_admin	Посвятить наткнуться поговорить правильный отъезд обида мягкий. Ответить смертельный ягода тяжелый. Важный коллектив триста пятеро картинка указанный. Славный исследование лиловый пропадать легко терапия.	2026-01-11	3	74	4	t	\N	\N	\N	f	\N	\N	\N
441	region_admin	Князь угроза изучить кожа равнодушный. Тяжелый совет гулять зеленый поймать адвокат народ. Дружно смеяться бригада самостоятельно прежде сынок. Похороны конференция плод предоставить поздравлять.	2026-01-11	5	74	5	t	\N	\N	\N	f	\N	\N	\N
442	region_admin	Советовать чувство процесс бровь плавно казнь соответствие угроза. Решетка необычный порог.	2026-01-11	4	149	5	t	\N	\N	\N	f	\N	\N	\N
443	school_admin	Очутиться палец спорт князь точно подземный обида. Около идея трубка тута. Актриса ложиться поймать идея зарплата.	2026-01-11	4	149	4	t	\N	\N	\N	f	\N	\N	\N
444	parent	Прелесть провал приятель экзамен мимо. Невозможно степь пространство изображать уничтожение мелькнуть. Угодный интеллектуальный банк житель следовательно плясать. Необычный девка адвокат деньги.	2026-01-11	4	149	2	t	\N	\N	\N	f	\N	\N	\N
445	teacher	Райком манера оставить монета одиннадцать совет. Академик выраженный мимо мимо. Вытаскивать отражение штаб изба функция механический задрать. Тесно цвет написать совет руководитель.	2026-01-11	3	149	3	t	\N	\N	\N	f	\N	\N	\N
446	admin	Аж плясать райком вообще. Поговорить затянуться обида смелый багровый задержать. Прелесть вытаскивать крыса иной. Запретить постоянный багровый слать зима трясти багровый. Промолчать освобождение палата монета. Вывести намерение функция предоставить рассуждение стакан валюта видимо.	2026-01-11	5	149	1	t	\N	\N	\N	f	\N	\N	\N
447	region_admin	Цвет дьявол наступать а заработать. Носок лапа ложиться вскинуть. Пламя равнодушный торговля тревога пробовать около совет руководитель. Неожиданно подробность плод оставить соответствие. Казнь карман ручей палец.	2026-01-11	5	149	5	t	\N	\N	\N	f	\N	\N	\N
448	region_admin	Обида намерение угол господь нажать совет головка. Возбуждение человечек похороны секунда бригада эффект уничтожение. Карандаш скрытый ставить нервно зарплата число. Пробовать очутиться стакан спалить. Поколение термин освобождение тревога.	2026-01-11	4	149	5	t	\N	\N	\N	f	\N	\N	\N
449	school_admin	Потянуться развернуться доставать. Интеллектуальный пятеро дружно князь пространство исследование невыносимый спалить. Полевой назначить радость полевой угодный самостоятельно вздрагивать. Вряд кидать коробка анализ.	2026-01-11	5	149	4	t	\N	\N	\N	f	\N	\N	\N
450	school_admin	Доставать дыхание изба. Господь пятеро результат мусор. Отметить процесс художественный дремать изучить изображать.	2026-01-11	4	149	4	t	\N	\N	\N	f	\N	\N	\N
451	parent	Падаль каюта наслаждение сынок. Наслаждение бетонный вытаскивать зарплата даль интернет вскакивать. Армейский запустить видимо отражение карман посидеть около. Войти июнь приличный задержать палата цепочка пропасть. Миф жестокий изменение бригада функция настать. Увеличиваться казнь а каюта космос намерение песенка.	2026-01-11	3	7	2	t	\N	\N	\N	f	\N	\N	\N
452	parent	Коробка важный ручей чем банк вытаскивать избегать. Угол потянуться каюта блин передо кузнец ставить потянуться. Плавно понятный вскинуть банк. Забирать упорно какой налоговый порог горький задержать оставить. Направо банк мусор вскинуть затянуться витрина. Наткнуться похороны радость слишком жидкий цвет.	2026-01-11	4	59	2	t	\N	\N	\N	f	\N	\N	\N
453	admin	Анализ сутки блин исполнять привлекать. Висеть успокоиться кольцо магазин ручей. Смеяться остановить гулять пробовать анализ волк. Висеть мягкий при ручей.	2026-01-11	5	59	1	t	\N	\N	\N	f	\N	\N	\N
454	parent	Трубка механический налево аллея. Багровый сынок зарплата спасть житель серьезный возникновение горький. О вариант промолчать армейский жестокий потом конструкция. Ботинок тюрьма исполнять за способ. Нажать тесно салон заложить выбирать призыв назначить.	2026-01-11	3	59	2	t	\N	\N	\N	f	\N	\N	\N
455	region_admin	Штаб казнь похороны засунуть потом. Что растеряться построить войти изображать анализ. Рис мальчишка радость бак. Падать легко протягивать неожиданный мгновение виднеться командующий. Цвет счастье потом расстройство проход. Приличный кожа магазин призыв. Правление коммунизм второй поколение пропасть рота сопровождаться.	2026-01-11	5	59	5	t	\N	\N	\N	f	\N	\N	\N
456	school_admin	Вздрагивать вытаскивать спорт. Точно сбросить казнь реклама дружно.	2026-01-11	4	151	4	t	\N	\N	\N	f	\N	\N	\N
458	teacher	Заявление наступать зеленый слать. Прежде спичка угроза один.	2026-01-11	5	151	3	t	\N	\N	\N	f	\N	\N	\N
459	school_admin	Лететь следовательно призыв смеяться жить. Указанный банк выраженный зима провал вариант снимать поймать.	2026-01-11	4	151	4	t	\N	\N	\N	f	\N	\N	\N
460	parent	Разуметься заплакать остановить крутой мальчишка изучить полюбить. Нажать лететь за неправда. Применяться следовательно ложиться. Серьезный близко монета чем.	2026-01-11	3	151	2	t	\N	\N	\N	f	\N	\N	\N
461	region_admin	Терапия сомнительный интернет запустить выгнать.	2026-01-11	4	151	5	t	\N	\N	\N	f	\N	\N	\N
462	region_admin	Желание палец проход способ. Умирать ребятишки полоска витрина расстегнуть второй умирать.	2026-01-11	3	151	5	t	\N	\N	\N	f	\N	\N	\N
463	teacher	Чем поздравлять сохранять коммунизм ломать потянуться беспомощный. Уронить дальний соответствие ставить.	2026-01-11	5	151	3	t	\N	\N	\N	f	\N	\N	\N
464	school_admin	Болото господь поздравлять район юный. Цвет вывести изображать виднеться.	2026-01-11	3	184	4	t	\N	\N	\N	f	\N	\N	\N
465	school_admin	Налоговый налево изображать. Приятель горький пропадать задрать порядок.	2026-01-11	3	184	4	t	\N	\N	\N	f	\N	\N	\N
466	region_admin	Военный военный совещание райком сверкать палка да. Покинуть пересечь ведь.	2026-01-11	4	184	5	t	\N	\N	\N	f	\N	\N	\N
467	admin	Падать чувство оборот валюта куча юный. Витрина граница монета понятный.	2026-01-11	3	184	1	t	\N	\N	\N	f	\N	\N	\N
468	region_admin	Мгновение приходить поезд цепочка анализ. Команда важный пропасть смертельный спасть. Низкий при аллея ремень. Ход ныне иной рассуждение.	2026-01-11	4	184	5	t	\N	\N	\N	f	\N	\N	\N
469	school_admin	Провал самостоятельно задержать счастье освободить единый ложиться палата. Место обида болото неожиданный висеть мимо. Вряд эффект горький основание помимо.	2026-01-11	3	184	4	t	\N	\N	\N	f	\N	\N	\N
470	parent	Четыре изучить пропадать ручей бак командующий. Слать мрачно передо непривычный рот уточнить парень.	2026-01-11	3	184	2	t	\N	\N	\N	f	\N	\N	\N
471	parent	Порядок вывести следовательно висеть остановить привлекать исполнять. Волк упорно собеседник основание а падать анализ. Заложить термин непривычный промолчать выкинуть. Поколение смелый появление. Блин валюта эффект миллиард расстегнуть.	2026-01-11	3	49	2	t	\N	\N	\N	f	\N	\N	\N
472	admin	Триста возмутиться редактор торговля. Недостаток ставить сверкающий палата рота.	2026-01-11	3	49	1	t	\N	\N	\N	f	\N	\N	\N
473	admin	Коммунизм ответить вывести задержать. Изменение точно дошлый табак уничтожение.	2026-01-11	4	49	1	t	\N	\N	\N	f	\N	\N	\N
474	school_admin	Пространство скрытый валюта.	2026-01-11	5	49	4	t	\N	\N	\N	f	\N	\N	\N
475	parent	Расстройство трясти четыре совещание. Голубчик командир набор уничтожение цепочка аллея. Боец расстройство скрытый инвалид. Миллиард лететь избегать цепочка жидкий расстегнуть основание. Запустить сустав заявление инвалид процесс банк зато.	2026-01-11	5	49	2	t	\N	\N	\N	f	\N	\N	\N
476	admin	Болото передо означать что палата ныне прежний. Остановить господь премьера упорно.	2026-01-11	3	118	1	t	\N	\N	\N	f	\N	\N	\N
477	region_admin	Очко житель очередной карман цвет манера интернет спичка. Освобождение проход естественный интернет достоинство.	2026-01-11	4	118	5	t	\N	\N	\N	f	\N	\N	\N
478	parent	Возмутиться сынок непривычный уронить спешить. Военный заведение коммунизм труп.	2026-01-11	4	118	2	t	\N	\N	\N	f	\N	\N	\N
479	parent	Вскакивать близко похороны металл команда зеленый тяжелый.	2026-01-11	4	118	2	t	\N	\N	\N	f	\N	\N	\N
480	admin	Металл интернет кузнец дошлый прежде способ дурацкий. Наступать означать спешить мгновение.	2026-01-11	4	118	1	t	\N	\N	\N	f	\N	\N	\N
481	teacher	Пастух конференция смертельный исследование наступать совет. Проход ложиться настать кольцо. Боец мальчишка естественный приходить невозможно печатать.	2026-01-11	4	118	3	t	\N	\N	\N	f	\N	\N	\N
482	teacher	Какой товар возможно предоставить. Подробность пол миг нож заработать витрина. Протягивать металл выраженный.	2026-01-11	5	118	3	t	\N	\N	\N	f	\N	\N	\N
483	teacher	Решетка голубчик висеть провинция важный скрытый. Монета освободить хозяйка чувство.	2026-01-11	4	118	3	t	\N	\N	\N	f	\N	\N	\N
484	admin	Счастье приятель пища вперед. Казнь терапия заявление назначить доставать витрина тусклый.	2026-01-11	4	170	1	t	\N	\N	\N	f	\N	\N	\N
485	school_admin	Гулять равнодушный кпсс факультет дорогой оставить мучительно. Полевой процесс белье блин светило заявление изредка. Печатать предоставить актриса научить. Успокоиться подземный правление.	2026-01-11	3	170	4	t	\N	\N	\N	f	\N	\N	\N
486	school_admin	Пространство мусор естественный. Наткнуться направо успокоиться полоска. Перебивать заплакать что.	2026-01-11	3	48	4	t	\N	\N	\N	f	\N	\N	\N
487	admin	Казнь четко расстегнуть сопровождаться райком нажать мера. Анализ дыхание нажать потрясти успокоиться куча. Чувство пламя поговорить крыса сбросить способ вообще.	2026-01-11	4	48	1	t	\N	\N	\N	f	\N	\N	\N
488	school_admin	Житель одиннадцать трясти природа очутиться рассуждение скрытый. Упорно избегать вариант столетие.	2026-01-11	3	43	4	t	\N	\N	\N	f	\N	\N	\N
489	parent	Умирать достоинство слишком девка мусор. Приличный торопливый полюбить тесно бегать отъезд адвокат. Ломать дремать спешить лететь зеленый развернуться хлеб.	2026-01-11	5	43	2	t	\N	\N	\N	f	\N	\N	\N
490	admin	Наткнуться степь художественный вздрагивать. Подробность заработать потрясти да. Военный юный функция подземный уничтожение.	2026-01-11	5	43	1	t	\N	\N	\N	f	\N	\N	\N
491	region_admin	Социалистический художественный пища вариант армейский. Секунда правый штаб посвятить космос монета.	2026-01-11	5	43	5	t	\N	\N	\N	f	\N	\N	\N
492	region_admin	Пробовать растеряться постоянный спасть. Появление одиннадцать указанный следовательно мелькнуть нажать домашний прежний.	2026-01-11	3	43	5	t	\N	\N	\N	f	\N	\N	\N
493	admin	Изучить естественный сохранять возмутиться. Носок скользить бак прощение заложить. Тревога место банда тяжелый полюбить. Научить наткнуться эффект грустный виднеться доставать. Житель горький угроза бочок порт неудобно.	2026-01-11	4	43	1	t	\N	\N	\N	f	\N	\N	\N
494	school_admin	Пропасть карандаш смертельный угроза картинка.	2026-01-11	5	109	4	t	\N	\N	\N	f	\N	\N	\N
495	region_admin	Пламя тяжелый кольцо. Фонарик кузнец коммунизм жить налоговый. Командир приличный руководитель привлекать. Район горький полностью сходить коммунизм картинка. Прежде труп труп расстегнуть.	2026-01-11	5	109	5	t	\N	\N	\N	f	\N	\N	\N
496	parent	Сохранять спорт бровь намерение.	2026-01-11	3	109	2	t	\N	\N	\N	f	\N	\N	\N
497	admin	Функция самостоятельно мусор торопливый четко. Палата житель невыносимый сынок сынок поставить настать.	2026-01-11	3	109	1	t	\N	\N	\N	f	\N	\N	\N
498	region_admin	Банк промолчать носок дружно конструкция неправда парень. Свежий уточнить применяться уронить пламя райком человечек разуметься. Сверкать более ботинок.	2026-01-11	5	109	5	t	\N	\N	\N	f	\N	\N	\N
499	teacher	Снимать прелесть лиловый песня советовать. Ложиться лиловый оставить. Зачем необычный а пастух.	2026-01-11	4	109	3	t	\N	\N	\N	f	\N	\N	\N
500	teacher	Иной дружно ремень картинка плод уронить мелькнуть. Неправда монета пол страсть витрина. Инструкция сравнение увеличиваться. Темнеть означать пропадать научить карандаш штаб тусклый.	2026-01-11	3	109	3	t	\N	\N	\N	f	\N	\N	\N
501	admin	Один услать пропасть что невозможно. Беспомощный появление угодный пространство потянуться спичка.	2026-01-11	3	109	1	t	\N	\N	\N	f	\N	\N	\N
502	parent	Печатать очутиться отметить основание способ тяжелый дурацкий ремень. Функция дорогой куча. Плясать идея зеленый одиннадцать функция хотеть функция.	2026-01-11	3	109	2	t	\N	\N	\N	f	\N	\N	\N
503	admin	Мелькнуть головной военный намерение. Школьный налоговый жить желание пламя художественный радость. Инвалид за плавно пробовать. Уточнить командир помимо уничтожение багровый совещание.	2026-01-11	3	109	1	t	\N	\N	\N	f	\N	\N	\N
504	school_admin	Столетие карман тесно провинция.	2026-01-11	3	95	4	t	\N	\N	\N	f	\N	\N	\N
505	school_admin	Салон уточнить вскинуть ныне заработать угроза. Сутки славный услать коммунизм единый природа.	2026-01-11	5	95	4	t	\N	\N	\N	f	\N	\N	\N
506	region_admin	Невыносимый налево песня дыхание. Тюрьма дыхание находить вскакивать жидкий интернет.	2026-01-11	4	55	5	t	\N	\N	\N	f	\N	\N	\N
507	teacher	Издали порт гулять развернуться. Беспомощный неправда степь вскинуть домашний инфекция какой. Горький кожа умолять вывести мимо. Зима висеть очередной чувство порог. Поймать заложить механический вздрогнуть.	2026-01-11	3	55	3	t	\N	\N	\N	f	\N	\N	\N
508	region_admin	Сверкающий ставить издали более серьезный. Изредка присесть монета идея.	2026-01-11	5	17	5	t	\N	\N	\N	f	\N	\N	\N
509	teacher	Написать назначить демократия. Потом зеленый наслаждение смертельный князь посвятить. Космос помимо бабочка прелесть. Цепочка танцевать встать возможно.	2026-01-11	4	17	3	t	\N	\N	\N	f	\N	\N	\N
510	school_admin	Кольцо шлем товар полоска рис плясать ремень. Картинка возмутиться страсть понятный торговля школьный наступать деловой. Подземный природа бегать деловой монета тута художественный спешить.	2026-01-11	3	17	4	t	\N	\N	\N	f	\N	\N	\N
511	teacher	Неожиданно сохранять собеседник правый. Низкий вряд скрытый штаб мрачно фонарик сходить. Хозяйка дорогой анализ способ цель. Карандаш пропадать призыв прежний выбирать низкий издали невыносимый. Палец чем следовательно товар передо бок провал.	2026-01-11	5	17	3	t	\N	\N	\N	f	\N	\N	\N
512	region_admin	Помимо соответствие передо металл хлеб.	2026-01-11	4	172	5	t	\N	\N	\N	f	\N	\N	\N
513	parent	Совещание лиловый армейский тута.	2026-01-11	4	172	2	t	\N	\N	\N	f	\N	\N	\N
514	teacher	Успокоиться народ бак основание художественный засунуть каюта. Блин каюта зачем сопровождаться бровь увеличиваться. Армейский научить актриса войти новый.	2026-01-11	5	172	3	t	\N	\N	\N	f	\N	\N	\N
515	school_admin	Посвятить стакан костер мальчишка наслаждение. Направо неожиданный прошептать уронить.	2026-01-11	4	85	4	t	\N	\N	\N	f	\N	\N	\N
516	school_admin	Аллея монета картинка мимо. Сынок что академик предоставить вперед вчера. Расстегнуть нервно человечек чувство применяться расстегнуть за.	2026-01-11	5	177	4	t	\N	\N	\N	f	\N	\N	\N
517	teacher	Заявление настать встать. Жестокий эпоха сверкающий солнце.	2026-01-11	5	177	3	t	\N	\N	\N	f	\N	\N	\N
518	parent	Написать через столетие пятеро спешить запретить. Направо мучительно миг монета грудь зеленый. Угроза шлем потом при уронить точно ночь рабочий.	2026-01-11	4	177	2	t	\N	\N	\N	f	\N	\N	\N
519	admin	Хлеб пятеро важный палец потянуться разнообразный. Непривычный июнь спалить. Ход левый парень тюрьма.	2026-01-11	4	177	1	t	\N	\N	\N	f	\N	\N	\N
520	parent	Решение мимо серьезный степь да. Экзамен заложить задержать белье степь цель устройство. Естественный порт выраженный мера коммунизм. Металл пища ломать командир деньги задержать беспомощный неожиданно.	2026-01-11	3	177	2	t	\N	\N	\N	f	\N	\N	\N
521	region_admin	Девка собеседник прежде. Табак славный слишком. Хозяйка плясать сомнительный засунуть исследование мальчишка неожиданно назначить. Одиннадцать понятный выгнать намерение. Разводить коммунизм бак ученый. Терапия спешить манера.	2026-01-11	3	177	5	t	\N	\N	\N	f	\N	\N	\N
522	school_admin	Песенка передо народ цепочка аллея монета солнце. Цвет мотоцикл разводить сопровождаться присесть. Художественный грудь около мотоцикл пропадать граница полюбить. Процесс монета рай.	2026-01-11	3	177	4	t	\N	\N	\N	f	\N	\N	\N
523	region_admin	Командир ныне торопливый. Посвятить ломать страсть растеряться даль результат сверкающий граница. Привлекать академик обида. Природа интернет функция природа волк руководитель июнь. Ботинок провинция цель пастух оборот тысяча ночь исполнять. Свежий счастье назначить банда потом.	2026-01-11	4	177	5	t	\N	\N	\N	f	\N	\N	\N
524	admin	Кпсс парень отъезд дьявол лапа. Остановить налоговый теория четыре. Угроза очередной что полоска хлеб опасность. Художественный сходить природа остановить изредка.	2026-01-11	3	177	1	t	\N	\N	\N	f	\N	\N	\N
525	teacher	Мелочь сбросить поколение вариант. Тюрьма висеть порядок кожа хотеть передо доставать.	2026-01-11	4	177	3	t	\N	\N	\N	f	\N	\N	\N
526	parent	Заложить гулять вздрагивать художественный ответить недостаток потянуться хозяйка. Солнце четко место сопровождаться очко миф. Заявление порода возникновение цвет отъезд. Написать интернет зима носок смелый столетие лапа. Интеллектуальный манера возможно прелесть точно пробовать покидать отъезд.	2026-01-11	3	89	2	t	\N	\N	\N	f	\N	\N	\N
527	school_admin	Спешить головка растеряться спорт мера славный серьезный. Советовать ведь приятель школьный природа песенка. Космос спорт механический мелькнуть.	2026-01-11	4	89	4	t	\N	\N	\N	f	\N	\N	\N
528	admin	Помимо покидать вывести поставить. Научить покинуть помолчать горький отъезд.	2026-01-11	5	89	1	t	\N	\N	\N	f	\N	\N	\N
529	admin	Сбросить четыре холодно предоставить. Тревога табак деньги непривычный задрать.	2026-01-11	3	89	1	t	\N	\N	\N	f	\N	\N	\N
530	parent	Помолчать изредка зима хозяйка выбирать дальний. Спешить рассуждение ягода некоторый инвалид. Сравнение сынок выразить инфекция умирать. Зима тревога рассуждение печатать район.	2026-01-11	4	89	2	t	\N	\N	\N	f	\N	\N	\N
531	region_admin	Одиннадцать художественный счастье металл. Господь перебивать бок мелочь покидать подробность исполнять приходить. Ставить карандаш экзамен поговорить ленинград пасть вскинуть. Госпожа смелый магазин интернет головка уронить цвет зеленый. Угол валюта изображать поезд пространство уронить передо.	2026-01-11	3	89	5	t	\N	\N	\N	f	\N	\N	\N
532	parent	Дрогнуть подземный кожа падать полоска увеличиваться расстегнуть. Тысяча витрина поставить неожиданный вытаскивать исполнять трясти.	2026-01-11	4	89	2	t	\N	\N	\N	f	\N	\N	\N
533	region_admin	Самостоятельно палата кожа уничтожение. Возбуждение уронить сынок носок поезд господь новый вообще. Соответствие неудобно выбирать юный выкинуть витрина степь. Расстройство лететь помимо освободить поставить зеленый. Похороны боец невыносимый коллектив монета висеть.	2026-01-11	5	89	5	t	\N	\N	\N	f	\N	\N	\N
534	admin	Армейский металл банда что пропаганда неудобно. Вздрагивать сынок спорт ярко палата. Горький провал бровь уронить домашний функция дошлый ученый. Второй коричневый палец. Костер головной палец светило.	2026-01-11	5	178	1	t	\N	\N	\N	f	\N	\N	\N
535	school_admin	Художественный недостаток командующий бок теория.	2026-01-11	4	178	4	t	\N	\N	\N	f	\N	\N	\N
536	admin	Что прежний вздрогнуть.	2026-01-11	4	178	1	t	\N	\N	\N	f	\N	\N	\N
537	parent	Дыхание услать вообще поколение ход горький художественный. Выдержать пропадать грудь жестокий девка.	2026-01-11	3	178	2	t	\N	\N	\N	f	\N	\N	\N
538	admin	Народ тесно спорт термин вперед.	2026-01-11	5	178	1	t	\N	\N	\N	f	\N	\N	\N
539	teacher	Что успокоиться налоговый бровь промолчать зачем. Банда передо о сверкающий анализ освобождение.	2026-01-11	4	178	3	t	\N	\N	\N	f	\N	\N	\N
\.


--
-- Data for Name: School; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."School" ("Official_Name", "Legal_Adress", "Phone", "Email", "Website", "Founding_Date", "Number_of_Students", "License", "Accreditation", "PK_School", "PK_Type_of_School", "PK_Settlement", is_active, created_at, updated_at, created_by) FROM stdin;
Романовоская средняя школа	село Романово, бул. Революции, д. 1	+7 (3854) 197957	school1@altai.edu.ru	http://school1.altai.edu.ru	2001-01-14	1019	Лицензия №Л035-53959 от 11.01.2026	Аккредитация №А246 от 11.01.2026	1	5	30	t	2026-01-11 12:40:09.393064	2026-01-11 12:40:09.393077	1
Вечерняя школа №2	село Солтон, бул. Октябрьский, д. 82 к. 6	+7 (3857) 999812	school2@altai.edu.ru	http://school2.altai.edu.ru	1993-02-28	698	Лицензия №Л035-41324 от 11.01.2026	Аккредитация №А580 от 11.01.2026	2	6	37	t	2026-01-11 12:40:09.480491	2026-01-11 12:40:09.4805	1
Коррекционная школа №3	поселок Павловск, пер. Лазо, д. 5/2 стр. 922	+7 (3859) 550038	school3@altai.edu.ru	http://school3.altai.edu.ru	1986-02-22	1013	Лицензия №Л035-61543 от 11.01.2026	Аккредитация №А546 от 11.01.2026	3	4	14	t	2026-01-11 12:40:09.525012	2026-01-11 12:40:09.52502	1
Гимназия №4	село Целинное, наб. Короленко, д. 66 стр. 2/2	+7 (3856) 736385	school4@altai.edu.ru	http://school4.altai.edu.ru	2001-08-03	1165	Лицензия №Л035-51383 от 11.01.2026	Аккредитация №А732 от 11.01.2026	4	6	42	t	2026-01-11 12:40:09.546966	2026-01-11 12:40:09.546973	1
Усть-Калманкаская гимназия	село Усть-Калманка, ш. Новосельское, д. 3/2 стр. 71	+7 (3854) 640098	school5@altai.edu.ru	http://school5.altai.edu.ru	1950-09-24	200	Лицензия №Л035-19472 от 11.01.2026	Аккредитация №А495 от 11.01.2026	5	2	40	t	2026-01-11 12:40:09.567403	2026-01-11 12:40:09.567411	1
Коррекционная школа №6	город Рубцовск, бул. Приморский, д. 718 стр. 99	+7 (3853) 444713	school6@altai.edu.ru	http://school6.altai.edu.ru	1970-05-01	1447	Лицензия №Л035-98598 от 11.01.2026	Аккредитация №А826 от 11.01.2026	6	1	3	t	2026-01-11 12:40:09.586999	2026-01-11 12:40:09.587009	1
Бийская гимназия	город Бийск, бул. Минский, д. 2/6	+7 (3857) 668970	school7@altai.edu.ru	http://school7.altai.edu.ru	1969-10-01	575	Лицензия №Л035-38118 от 11.01.2026	Аккредитация №А366 от 11.01.2026	7	1	2	t	2026-01-11 12:40:09.599453	2026-01-11 12:40:09.599461	1
Школа-интернат №8	село Усть-Калманка, ул. Покровская, д. 9/1 стр. 8	+7 (3854) 870285	school8@altai.edu.ru	http://school8.altai.edu.ru	1969-03-26	378	Лицензия №Л035-74150 от 11.01.2026	Аккредитация №А135 от 11.01.2026	8	7	40	t	2026-01-11 12:40:09.611886	2026-01-11 12:40:09.611893	1
Вечерняя школа №9	поселок Калманка, ул. Дальняя, д. 9	+7 (3857) 312063	school9@altai.edu.ru	http://school9.altai.edu.ru	1985-01-26	1920	Лицензия №Л035-29438 от 11.01.2026	Аккредитация №А984 от 11.01.2026	9	6	18	t	2026-01-11 12:40:09.623464	2026-01-11 12:40:09.623472	1
Топчихаская гимназия	село Топчиха, алл. Дорожная, д. 9 к. 71	+7 (3859) 248022	school10@altai.edu.ru	http://school10.altai.edu.ru	1976-05-28	1344	Лицензия №Л035-83012 от 11.01.2026	Аккредитация №А566 от 11.01.2026	10	5	39	t	2026-01-11 12:40:09.636278	2026-01-11 12:40:09.636285	1
Курьяская средняя школа	село Курья, ш. Циолковского, д. 7	+7 (3854) 652717	school11@altai.edu.ru	http://school11.altai.edu.ru	1971-01-16	1215	Лицензия №Л035-57260 от 11.01.2026	Аккредитация №А895 от 11.01.2026	11	6	34	t	2026-01-11 12:40:09.649278	2026-01-11 12:40:09.649284	1
Новоалтайский лицей	город Новоалтайск, ш. Азина, д. 9/9	+7 (3852) 548898	school12@altai.edu.ru	http://school12.altai.edu.ru	1992-05-17	1262	Лицензия №Л035-38490 от 11.01.2026	Аккредитация №А848 от 11.01.2026	12	5	4	t	2026-01-11 12:40:09.664494	2026-01-11 12:40:09.664501	1
Белокурихаская гимназия	город Белокуриха, пр. Прудный, д. 1/7	+7 (3858) 844856	school13@altai.edu.ru	http://school13.altai.edu.ru	1975-01-06	1710	Лицензия №Л035-16897 от 11.01.2026	Аккредитация №А578 от 11.01.2026	13	7	10	t	2026-01-11 12:40:09.675629	2026-01-11 12:40:09.675636	1
Школа с углубленным изучением информатики №14	поселок Благовещенка, наб. Пирогова, д. 413	+7 (3854) 467388	school14@altai.edu.ru	http://school14.altai.edu.ru	1963-11-17	121	Лицензия №Л035-66922 от 11.01.2026	Аккредитация №А491 от 11.01.2026	14	3	22	t	2026-01-11 12:40:09.693509	2026-01-11 12:40:09.693516	1
Школа-интернат №15	село Топчиха, бул. Пограничный, д. 80 к. 4	+7 (3856) 594461	school15@altai.edu.ru	http://school15.altai.edu.ru	1974-02-05	332	Лицензия №Л035-71467 от 11.01.2026	Аккредитация №А115 от 11.01.2026	15	6	39	t	2026-01-11 12:40:09.693521	2026-01-11 12:40:09.693524	1
Школа с углубленным изучением химии №16	поселок Калманка, бул. 50 лет Октября, д. 117 к. 186	+7 (3858) 927846	school16@altai.edu.ru	http://school16.altai.edu.ru	1980-12-17	855	Лицензия №Л035-77423 от 11.01.2026	Аккредитация №А441 от 11.01.2026	16	5	18	t	2026-01-11 12:40:09.693528	2026-01-11 12:40:09.693531	1
Коррекционная школа №17	город Заринск, пер. Черноморский, д. 7/9 стр. 39	+7 (3858) 775159	school17@altai.edu.ru	http://school17.altai.edu.ru	1968-09-06	1279	Лицензия №Л035-90921 от 11.01.2026	Аккредитация №А524 от 11.01.2026	17	2	5	t	2026-01-11 12:40:09.709487	2026-01-11 12:40:09.709494	1
Шипуновоская гимназия	поселок Шипуново, алл. Волочаевская, д. 251 стр. 1	+7 (3854) 129692	school18@altai.edu.ru	http://school18.altai.edu.ru	1950-08-03	1800	Лицензия №Л035-27500 от 11.01.2026	Аккредитация №А549 от 11.01.2026	18	5	15	t	2026-01-11 12:40:09.71982	2026-01-11 12:40:09.719827	1
Лицей №19	поселок Поспелиха, пер. Кузнечный, д. 7 стр. 6/8	+7 (3852) 977348	school19@altai.edu.ru	http://school19.altai.edu.ru	2004-08-12	243	Лицензия №Л035-43263 от 11.01.2026	Аккредитация №А418 от 11.01.2026	19	5	17	t	2026-01-11 12:40:09.72872	2026-01-11 12:40:09.728729	1
Кадетская школа №20	город Барнаул, ул. Кутузова, д. 12 к. 1/1	+7 (3857) 654958	school20@altai.edu.ru	http://school20.altai.edu.ru	2002-11-05	638	Лицензия №Л035-18357 от 11.01.2026	Аккредитация №А736 от 11.01.2026	20	2	1	t	2026-01-11 12:40:09.736897	2026-01-11 12:40:09.736905	1
Средняя общеобразовательная школа №21	поселок Волчиха, пер. Спортивный, д. 2/8 стр. 744	+7 (3857) 185647	school21@altai.edu.ru	http://school21.altai.edu.ru	1999-10-25	1281	Лицензия №Л035-46782 от 11.01.2026	Аккредитация №А555 от 11.01.2026	21	4	24	t	2026-01-11 12:40:09.747649	2026-01-11 12:40:09.747656	1
Школа-интернат №22	село Петропавловское, ул. Олимпийская, д. 3	+7 (3856) 351384	school22@altai.edu.ru	http://school22.altai.edu.ru	1995-03-23	210	Лицензия №Л035-59854 от 11.01.2026	Аккредитация №А983 от 11.01.2026	22	2	35	t	2026-01-11 12:40:09.756315	2026-01-11 12:40:09.756323	1
Ребрихаский лицей	село Ребриха, бул. Осенний, д. 64 стр. 790	+7 (3856) 230006	school23@altai.edu.ru	http://school23.altai.edu.ru	1975-05-19	375	Лицензия №Л035-55063 от 11.01.2026	Аккредитация №А436 от 11.01.2026	23	2	28	t	2026-01-11 12:40:09.768277	2026-01-11 12:40:09.768283	1
Благовещенкаский лицей	поселок Благовещенка, ш. Новостройка, д. 6 к. 35	+7 (3854) 371913	school24@altai.edu.ru	http://school24.altai.edu.ru	1966-01-19	957	Лицензия №Л035-99918 от 11.01.2026	Аккредитация №А866 от 11.01.2026	24	7	22	t	2026-01-11 12:40:09.768288	2026-01-11 12:40:09.768291	1
Угловскский лицей	село Угловское, пер. Дорожников, д. 1/8 к. 45	+7 (3855) 667967	school25@altai.edu.ru	http://school25.altai.edu.ru	2001-11-02	1111	Лицензия №Л035-93401 от 11.01.2026	Аккредитация №А169 от 11.01.2026	25	4	32	t	2026-01-11 12:40:09.781815	2026-01-11 12:40:09.781823	1
Средняя общеобразовательная школа №26	город Алейск, бул. Заозерный, д. 497 стр. 91	+7 (3854) 138940	school26@altai.edu.ru	http://school26.altai.edu.ru	1964-11-13	744	Лицензия №Л035-39857 от 11.01.2026	Аккредитация №А432 от 11.01.2026	26	1	8	t	2026-01-11 12:40:09.792488	2026-01-11 12:40:09.792499	1
Школа с углубленным изучением обществознания №27	село Петропавловское, пр. Школьный, д. 6	+7 (3858) 408659	school27@altai.edu.ru	http://school27.altai.edu.ru	1988-12-01	1585	Лицензия №Л035-82331 от 11.01.2026	Аккредитация №А754 от 11.01.2026	27	1	35	t	2026-01-11 12:40:09.792504	2026-01-11 12:40:09.792508	1
Кадетская школа №28	поселок Кулунда, алл. Новая, д. 65 стр. 4/4	+7 (3858) 765122	school28@altai.edu.ru	http://school28.altai.edu.ru	1998-11-04	908	Лицензия №Л035-50697 от 11.01.2026	Аккредитация №А159 от 11.01.2026	28	1	21	t	2026-01-11 12:40:09.80606	2026-01-11 12:40:09.806069	1
Рубцовская средняя школа	город Рубцовск, пр. Николаева, д. 36 к. 2/5	+7 (3853) 751889	school29@altai.edu.ru	http://school29.altai.edu.ru	1965-09-03	1746	Лицензия №Л035-44645 от 11.01.2026	Аккредитация №А141 от 11.01.2026	29	7	3	t	2026-01-11 12:40:09.806073	2026-01-11 12:40:09.806077	1
Шелаболихаская средняя школа	поселок Шелаболиха, алл. Радищева, д. 9/3 стр. 5/6	+7 (3859) 985626	school30@altai.edu.ru	http://school30.altai.edu.ru	1985-09-28	950	Лицензия №Л035-82287 от 11.01.2026	Аккредитация №А839 от 11.01.2026	30	5	25	t	2026-01-11 12:40:09.820686	2026-01-11 12:40:09.820694	1
Угловскская средняя школа	село Угловское, ш. Шахтерское, д. 6/9 стр. 48	+7 (3853) 151846	school31@altai.edu.ru	http://school31.altai.edu.ru	1953-09-11	847	Лицензия №Л035-99995 от 11.01.2026	Аккредитация №А686 от 11.01.2026	31	7	32	t	2026-01-11 12:40:09.820698	2026-01-11 12:40:09.820701	1
Школа-интернат №32	село Целинное, ул. Новостройка, д. 354	+7 (3856) 542996	school32@altai.edu.ru	http://school32.altai.edu.ru	1985-02-09	1738	Лицензия №Л035-63799 от 11.01.2026	Аккредитация №А598 от 11.01.2026	32	5	42	t	2026-01-11 12:40:09.820705	2026-01-11 12:40:09.820708	1
Средняя общеобразовательная школа №33	поселок Шипуново, ш. Производственное, д. 8/1	+7 (3852) 680141	school33@altai.edu.ru	http://school33.altai.edu.ru	1951-11-07	1002	Лицензия №Л035-66755 от 11.01.2026	Аккредитация №А749 от 11.01.2026	33	4	15	t	2026-01-11 12:40:09.820711	2026-01-11 12:40:09.820715	1
Вечерняя школа №34	село Зональное, пер. Запорожский, д. 1/7 к. 9	+7 (3857) 436870	school34@altai.edu.ru	http://school34.altai.edu.ru	1958-08-20	1790	Лицензия №Л035-26151 от 11.01.2026	Аккредитация №А607 от 11.01.2026	34	2	36	t	2026-01-11 12:40:09.844724	2026-01-11 12:40:09.844731	1
Павловский лицей	поселок Павловск, пр. Астраханский, д. 9 стр. 3/9	+7 (3854) 746408	school35@altai.edu.ru	http://school35.altai.edu.ru	1986-05-14	691	Лицензия №Л035-86680 от 11.01.2026	Аккредитация №А966 от 11.01.2026	35	2	14	t	2026-01-11 12:40:09.844735	2026-01-11 12:40:09.844739	1
Заринская гимназия	город Заринск, пр. Бабушкина, д. 761	+7 (3853) 256474	school36@altai.edu.ru	http://school36.altai.edu.ru	2003-12-17	1255	Лицензия №Л035-82458 от 11.01.2026	Аккредитация №А874 от 11.01.2026	36	1	5	t	2026-01-11 12:40:09.844743	2026-01-11 12:40:09.844746	1
Вечерняя школа №37	город Новоалтайск, пер. Коминтерна, д. 424 к. 449	+7 (3857) 781244	school37@altai.edu.ru	http://school37.altai.edu.ru	1982-02-20	817	Лицензия №Л035-81406 от 11.01.2026	Аккредитация №А172 от 11.01.2026	37	6	4	t	2026-01-11 12:40:09.844749	2026-01-11 12:40:09.844753	1
Лицей №38	поселок Калманка, ш. Союзное, д. 9/4	+7 (3858) 485905	school38@altai.edu.ru	http://school38.altai.edu.ru	1988-10-02	1057	Лицензия №Л035-73878 от 11.01.2026	Аккредитация №А469 от 11.01.2026	38	6	18	t	2026-01-11 12:40:09.844756	2026-01-11 12:40:09.844759	1
Лицей №39	поселок Волчиха, ул. Хуторская, д. 4 стр. 9	+7 (3858) 308546	school39@altai.edu.ru	http://school39.altai.edu.ru	1959-01-17	1524	Лицензия №Л035-33732 от 11.01.2026	Аккредитация №А324 от 11.01.2026	39	7	24	t	2026-01-11 12:40:09.844763	2026-01-11 12:40:09.844766	1
Гимназия №40	город Белокуриха, ул. Деповская, д. 945 стр. 503	+7 (3853) 404992	school40@altai.edu.ru	http://school40.altai.edu.ru	1964-12-27	170	Лицензия №Л035-30731 от 11.01.2026	Аккредитация №А966 от 11.01.2026	40	7	10	t	2026-01-11 12:40:09.844769	2026-01-11 12:40:09.844772	1
Школа с углубленным изучением физики №41	село Целинное, ш. Севастопольское, д. 1/3	+7 (3858) 822371	school41@altai.edu.ru	http://school41.altai.edu.ru	1992-10-07	770	Лицензия №Л035-39354 от 11.01.2026	Аккредитация №А812 от 11.01.2026	41	7	42	t	2026-01-11 12:40:09.844776	2026-01-11 12:40:09.844779	1
Коррекционная школа №42	поселок Шипуново, пр. Подлесный, д. 82	+7 (3856) 289503	school42@altai.edu.ru	http://school42.altai.edu.ru	1979-10-17	546	Лицензия №Л035-97006 от 11.01.2026	Аккредитация №А294 от 11.01.2026	42	7	15	t	2026-01-11 12:40:09.844782	2026-01-11 12:40:09.844785	1
Школа-интернат №43	поселок Солонешное, бул. Рылеева, д. 5/7 к. 4	+7 (3858) 764676	school43@altai.edu.ru	http://school43.altai.edu.ru	1982-12-28	1519	Лицензия №Л035-90208 от 11.01.2026	Аккредитация №А297 от 11.01.2026	43	1	27	t	2026-01-11 12:40:09.914969	2026-01-11 12:40:09.914976	1
Коррекционная школа №44	село Курья, пр. Радужный, д. 4/4 к. 40	+7 (3858) 800578	school44@altai.edu.ru	http://school44.altai.edu.ru	1974-11-06	1905	Лицензия №Л035-40039 от 11.01.2026	Аккредитация №А506 от 11.01.2026	44	6	34	t	2026-01-11 12:40:09.91498	2026-01-11 12:40:09.914984	1
Лицей №45	город Камень-на-Оби, бул. Кошевого, д. 1 стр. 70	+7 (3858) 429282	school45@altai.edu.ru	http://school45.altai.edu.ru	1956-11-10	370	Лицензия №Л035-31492 от 11.01.2026	Аккредитация №А718 от 11.01.2026	45	7	6	t	2026-01-11 12:40:09.926467	2026-01-11 12:40:09.926476	1
Школа с углубленным изучением английского языка №46	город Змеиногорск, алл. Минская, д. 167 стр. 908	+7 (3856) 846092	school46@altai.edu.ru	http://school46.altai.edu.ru	1955-12-09	1599	Лицензия №Л035-10264 от 11.01.2026	Аккредитация №А384 от 11.01.2026	46	2	12	t	2026-01-11 12:40:09.936837	2026-01-11 12:40:09.936848	1
Лицей №47	поселок Шелаболиха, наб. Парковая, д. 3/5 к. 7	+7 (3852) 528502	school47@altai.edu.ru	http://school47.altai.edu.ru	1951-02-27	852	Лицензия №Л035-84778 от 11.01.2026	Аккредитация №А845 от 11.01.2026	47	2	25	t	2026-01-11 12:40:09.936853	2026-01-11 12:40:09.936858	1
Кадетская школа №48	город Горняк, бул. Кавказский, д. 77	+7 (3858) 901614	school48@altai.edu.ru	http://school48.altai.edu.ru	1971-10-07	371	Лицензия №Л035-95705 от 11.01.2026	Аккредитация №А573 от 11.01.2026	48	1	11	t	2026-01-11 12:40:09.951286	2026-01-11 12:40:09.951295	1
Коррекционная школа №49	поселок Благовещенка, пер. Хуторской, д. 6/5 к. 2	+7 (3852) 315013	school49@altai.edu.ru	http://school49.altai.edu.ru	1974-05-12	1079	Лицензия №Л035-77286 от 11.01.2026	Аккредитация №А434 от 11.01.2026	49	1	22	t	2026-01-11 12:40:09.951299	2026-01-11 12:40:09.951302	1
Школа с углубленным изучением биологии №50	город Камень-на-Оби, наб. Воронежская, д. 22 стр. 11	+7 (3853) 827938	school50@altai.edu.ru	http://school50.altai.edu.ru	1983-03-11	154	Лицензия №Л035-61409 от 11.01.2026	Аккредитация №А727 от 11.01.2026	50	2	6	t	2026-01-11 12:40:09.951306	2026-01-11 12:40:09.951309	1
Коррекционная школа №51	город Алейск, алл. Волжская, д. 5/5 стр. 400	+7 (3855) 384095	school51@altai.edu.ru	http://school51.altai.edu.ru	1996-04-28	57	Лицензия №Л035-15154 от 11.01.2026	Аккредитация №А838 от 11.01.2026	51	3	8	t	2026-01-11 12:40:09.971453	2026-01-11 12:40:09.971463	1
Вечерняя школа №52	село Угловское, алл. Высоцкого, д. 8/3 стр. 1	+7 (3856) 815528	school52@altai.edu.ru	http://school52.altai.edu.ru	1976-08-02	1034	Лицензия №Л035-94993 от 11.01.2026	Аккредитация №А951 от 11.01.2026	52	4	32	t	2026-01-11 12:40:10.013071	2026-01-11 12:40:10.013081	1
Кулундаская гимназия	поселок Кулунда, алл. Крылова, д. 8/9 стр. 264	+7 (3854) 426956	school53@altai.edu.ru	http://school53.altai.edu.ru	1994-05-11	96	Лицензия №Л035-84274 от 11.01.2026	Аккредитация №А275 от 11.01.2026	53	7	21	t	2026-01-11 12:40:10.048177	2026-01-11 12:40:10.048185	1
Шелаболихаская средняя школа	поселок Шелаболиха, ул. Демьяна Бедного, д. 948 к. 493	+7 (3853) 535767	school54@altai.edu.ru	http://school54.altai.edu.ru	1950-07-13	1325	Лицензия №Л035-53312 от 11.01.2026	Аккредитация №А773 от 11.01.2026	54	7	25	t	2026-01-11 12:40:10.084701	2026-01-11 12:40:10.084709	1
Средняя общеобразовательная школа №55	село Целинное, пер. Черемушки, д. 3/2 стр. 42	+7 (3859) 103756	school55@altai.edu.ru	http://school55.altai.edu.ru	1988-06-24	1371	Лицензия №Л035-15341 от 11.01.2026	Аккредитация №А327 от 11.01.2026	55	5	42	t	2026-01-11 12:40:10.112045	2026-01-11 12:40:10.112052	1
Кулундаская гимназия	поселок Кулунда, ул. Щербакова, д. 716 к. 5/8	+7 (3854) 595007	school56@altai.edu.ru	http://school56.altai.edu.ru	1955-03-28	1361	Лицензия №Л035-68687 от 11.01.2026	Аккредитация №А395 от 11.01.2026	56	1	21	t	2026-01-11 12:40:10.127476	2026-01-11 12:40:10.127484	1
Школа с углубленным изучением химии №57	поселок Шипуново, алл. Семашко, д. 618 стр. 711	+7 (3854) 244755	school57@altai.edu.ru	http://school57.altai.edu.ru	2005-04-28	95	Лицензия №Л035-65030 от 11.01.2026	Аккредитация №А346 от 11.01.2026	57	2	15	t	2026-01-11 12:40:10.142322	2026-01-11 12:40:10.14233	1
Кадетская школа №58	село Топчиха, бул. Астраханский, д. 6/3 стр. 85	+7 (3858) 445367	school58@altai.edu.ru	http://school58.altai.edu.ru	1990-07-24	1410	Лицензия №Л035-53065 от 11.01.2026	Аккредитация №А717 от 11.01.2026	58	2	39	t	2026-01-11 12:40:10.163618	2026-01-11 12:40:10.163626	1
Романовоская гимназия	село Романово, бул. Белинского, д. 8	+7 (3856) 739324	school59@altai.edu.ru	http://school59.altai.edu.ru	1970-03-06	948	Лицензия №Л035-87436 от 11.01.2026	Аккредитация №А521 от 11.01.2026	59	7	30	t	2026-01-11 12:40:10.177435	2026-01-11 12:40:10.177443	1
Белокурихаская гимназия	город Белокуриха, бул. Николаева, д. 9/1 к. 334	+7 (3859) 938088	school60@altai.edu.ru	http://school60.altai.edu.ru	2005-06-16	825	Лицензия №Л035-78347 от 11.01.2026	Аккредитация №А698 от 11.01.2026	60	4	10	t	2026-01-11 12:40:10.190234	2026-01-11 12:40:10.190241	1
Коррекционная школа №61	село Зональное, пр. Народный, д. 5/9 стр. 9	+7 (3853) 932482	school61@altai.edu.ru	http://school61.altai.edu.ru	1999-01-03	351	Лицензия №Л035-28867 от 11.01.2026	Аккредитация №А364 от 11.01.2026	61	2	36	t	2026-01-11 12:40:10.199995	2026-01-11 12:40:10.200002	1
Ребрихаская гимназия	село Ребриха, пр. Автомобилистов, д. 5/3	+7 (3856) 405701	school62@altai.edu.ru	http://school62.altai.edu.ru	1950-06-20	816	Лицензия №Л035-17658 от 11.01.2026	Аккредитация №А231 от 11.01.2026	62	3	28	t	2026-01-11 12:40:10.215389	2026-01-11 12:40:10.215396	1
Школа с библиотекой №6	село Угловское, ул. наб. Розы Люксембург, 45	+7 (3857) 659830	library_school6@altai.edu.ru	\N	1976-09-01	329	\N	\N	211	7	32	t	2026-01-11 12:40:12.085133	2026-01-11 12:40:12.085141	1
Школа с углубленным изучением русского языка №63	город Алейск, ул. Некрасова, д. 90	+7 (3854) 356331	school63@altai.edu.ru	http://school63.altai.edu.ru	1968-02-10	301	Лицензия №Л035-58242 от 11.01.2026	Аккредитация №А905 от 11.01.2026	63	3	8	t	2026-01-11 12:40:10.2154	2026-01-11 12:40:10.215404	1
Кадетская школа №64	город Яровое, пр. Слободской, д. 6/4 к. 5	+7 (3857) 475292	school64@altai.edu.ru	http://school64.altai.edu.ru	1985-02-24	824	Лицензия №Л035-66702 от 11.01.2026	Аккредитация №А502 от 11.01.2026	64	2	9	t	2026-01-11 12:40:10.228264	2026-01-11 12:40:10.228272	1
Змеиногорский лицей	город Змеиногорск, пер. Приморский, д. 4/1	+7 (3853) 113886	school65@altai.edu.ru	http://school65.altai.edu.ru	1959-02-23	1068	Лицензия №Л035-90564 от 11.01.2026	Аккредитация №А316 от 11.01.2026	65	5	12	t	2026-01-11 12:40:10.236694	2026-01-11 12:40:10.236701	1
Мамонтовоская гимназия	село Мамонтово, алл. Заливная, д. 5 стр. 5/8	+7 (3859) 783026	school66@altai.edu.ru	http://school66.altai.edu.ru	1975-04-20	590	Лицензия №Л035-53486 от 11.01.2026	Аккредитация №А103 от 11.01.2026	66	7	29	t	2026-01-11 12:40:10.24779	2026-01-11 12:40:10.247797	1
Школа-интернат №67	поселок Красногорское, ул. Авиационная, д. 9 к. 3	+7 (3852) 541907	school67@altai.edu.ru	http://school67.altai.edu.ru	1961-04-17	82	Лицензия №Л035-71592 от 11.01.2026	Аккредитация №А321 от 11.01.2026	67	2	26	t	2026-01-11 12:40:10.258367	2026-01-11 12:40:10.258379	1
Школа-интернат №68	город Рубцовск, ул. Боровая, д. 9 стр. 2/1	+7 (3859) 704875	school68@altai.edu.ru	http://school68.altai.edu.ru	1956-04-14	1815	Лицензия №Л035-37296 от 11.01.2026	Аккредитация №А870 от 11.01.2026	68	7	3	t	2026-01-11 12:40:10.268902	2026-01-11 12:40:10.26891	1
Школа с углубленным изучением математики №69	город Барнаул, наб. Есенина, д. 649	+7 (3858) 360290	school69@altai.edu.ru	http://school69.altai.edu.ru	1972-11-13	1589	Лицензия №Л035-90910 от 11.01.2026	Аккредитация №А378 от 11.01.2026	69	6	1	t	2026-01-11 12:40:10.280851	2026-01-11 12:40:10.280858	1
Школа-интернат №70	село Хабары, бул. Достоевского, д. 722 к. 829	+7 (3855) 414568	school70@altai.edu.ru	http://school70.altai.edu.ru	1975-03-10	831	Лицензия №Л035-98223 от 11.01.2026	Аккредитация №А852 от 11.01.2026	70	2	41	t	2026-01-11 12:40:10.292139	2026-01-11 12:40:10.292148	1
Гимназия №71	город Змеиногорск, алл. Подгорная, д. 9	+7 (3859) 331524	school71@altai.edu.ru	http://school71.altai.edu.ru	1968-09-12	1547	Лицензия №Л035-44789 от 11.01.2026	Аккредитация №А219 от 11.01.2026	71	5	12	t	2026-01-11 12:40:10.292153	2026-01-11 12:40:10.292158	1
Коррекционная школа №72	село Быстрый Исток, ш. Кирпичное, д. 1/6 стр. 8/2	+7 (3855) 357088	school72@altai.edu.ru	http://school72.altai.edu.ru	1986-01-10	798	Лицензия №Л035-76047 от 11.01.2026	Аккредитация №А377 от 11.01.2026	72	6	31	t	2026-01-11 12:40:10.304741	2026-01-11 12:40:10.304752	1
Кадетская школа №73	село Курья, бул. Медицинский, д. 5/6	+7 (3854) 200757	school73@altai.edu.ru	http://school73.altai.edu.ru	1999-07-18	1062	Лицензия №Л035-67360 от 11.01.2026	Аккредитация №А587 от 11.01.2026	73	4	34	t	2026-01-11 12:40:10.316775	2026-01-11 12:40:10.316783	1
Гимназия №74	поселок Павловск, ул. Мельничная, д. 50	+7 (3858) 795550	school74@altai.edu.ru	http://school74.altai.edu.ru	1979-07-12	1189	Лицензия №Л035-47157 от 11.01.2026	Аккредитация №А926 от 11.01.2026	74	4	14	t	2026-01-11 12:40:10.326666	2026-01-11 12:40:10.326673	1
Гимназия №75	село Усть-Калманка, наб. Таманская, д. 2/4 к. 2/9	+7 (3855) 699644	school75@altai.edu.ru	http://school75.altai.edu.ru	1952-10-08	1010	Лицензия №Л035-19435 от 11.01.2026	Аккредитация №А792 от 11.01.2026	75	6	40	t	2026-01-11 12:40:10.336023	2026-01-11 12:40:10.336031	1
Вечерняя школа №76	поселок Смоленское, пр. Горняцкий, д. 568 к. 12	+7 (3858) 443254	school76@altai.edu.ru	http://school76.altai.edu.ru	1973-09-14	1852	Лицензия №Л035-60353 от 11.01.2026	Аккредитация №А686 от 11.01.2026	76	2	20	t	2026-01-11 12:40:10.349821	2026-01-11 12:40:10.349827	1
Средняя общеобразовательная школа №77	поселок Павловск, наб. Леонова, д. 1/3	+7 (3859) 275736	school77@altai.edu.ru	http://school77.altai.edu.ru	2005-09-09	1133	Лицензия №Л035-59091 от 11.01.2026	Аккредитация №А551 от 11.01.2026	77	2	14	t	2026-01-11 12:40:10.349831	2026-01-11 12:40:10.349835	1
Школа с углубленным изучением английского языка №78	село Топчиха, ш. Калинина, д. 628 стр. 75	+7 (3857) 544295	school78@altai.edu.ru	http://school78.altai.edu.ru	2006-10-28	284	Лицензия №Л035-56594 от 11.01.2026	Аккредитация №А495 от 11.01.2026	78	3	39	t	2026-01-11 12:40:10.349838	2026-01-11 12:40:10.349842	1
Шипуновоская средняя школа	поселок Шипуново, алл. Сахалинская, д. 6 к. 25	+7 (3854) 237622	school79@altai.edu.ru	http://school79.altai.edu.ru	1972-12-12	1053	Лицензия №Л035-43598 от 11.01.2026	Аккредитация №А712 от 11.01.2026	79	3	15	t	2026-01-11 12:40:10.349845	2026-01-11 12:40:10.349848	1
Средняя общеобразовательная школа №80	поселок Кулунда, пр. Речной, д. 41 к. 43	+7 (3857) 952489	school80@altai.edu.ru	http://school80.altai.edu.ru	1952-04-19	1820	Лицензия №Л035-98485 от 11.01.2026	Аккредитация №А188 от 11.01.2026	80	2	21	t	2026-01-11 12:40:10.349852	2026-01-11 12:40:10.349855	1
Школа-интернат №81	село Мамонтово, пер. Димитрова, д. 54 стр. 795	+7 (3855) 269001	school81@altai.edu.ru	http://school81.altai.edu.ru	1954-03-14	758	Лицензия №Л035-15577 от 11.01.2026	Аккредитация №А178 от 11.01.2026	81	2	29	t	2026-01-11 12:40:10.349858	2026-01-11 12:40:10.349861	1
Вечерняя школа №82	село Петропавловское, алл. Чернышевского, д. 127 к. 3	+7 (3852) 691210	school82@altai.edu.ru	http://school82.altai.edu.ru	1981-06-09	1747	Лицензия №Л035-43409 от 11.01.2026	Аккредитация №А617 от 11.01.2026	82	4	35	t	2026-01-11 12:40:10.373176	2026-01-11 12:40:10.373183	1
Школа с библиотекой №7	село Романово, ул. наб. Седова, 7	+7 (3854) 476278	library_school7@altai.edu.ru	\N	1977-09-01	566	\N	\N	212	3	30	t	2026-01-11 12:40:12.089726	2026-01-11 12:40:12.089734	1
Шелаболихаская гимназия	поселок Шелаболиха, пр. Главный, д. 24 стр. 3/3	+7 (3859) 274213	school83@altai.edu.ru	http://school83.altai.edu.ru	1997-07-23	310	Лицензия №Л035-74152 от 11.01.2026	Аккредитация №А397 от 11.01.2026	83	3	25	t	2026-01-11 12:40:10.373187	2026-01-11 12:40:10.373191	1
Средняя общеобразовательная школа №84	город Бийск, ш. Мичурина, д. 824	+7 (3857) 661618	school84@altai.edu.ru	http://school84.altai.edu.ru	2002-02-15	377	Лицензия №Л035-27705 от 11.01.2026	Аккредитация №А744 от 11.01.2026	84	1	2	t	2026-01-11 12:40:10.386431	2026-01-11 12:40:10.386439	1
Коррекционная школа №85	поселок Калманка, пр. Болотный, д. 4 стр. 427	+7 (3854) 418488	school85@altai.edu.ru	http://school85.altai.edu.ru	2000-05-03	553	Лицензия №Л035-67465 от 11.01.2026	Аккредитация №А496 от 11.01.2026	85	3	18	t	2026-01-11 12:40:10.397983	2026-01-11 12:40:10.397991	1
Школа с углубленным изучением русского языка №86	село Усть-Калманка, пр. Фрунзе, д. 7/7 к. 252	+7 (3858) 216062	school86@altai.edu.ru	http://school86.altai.edu.ru	1982-02-18	1823	Лицензия №Л035-18145 от 11.01.2026	Аккредитация №А990 от 11.01.2026	86	5	40	t	2026-01-11 12:40:10.397995	2026-01-11 12:40:10.397998	1
Гимназия №87	село Ребриха, ш. Докучаева, д. 89	+7 (3856) 822402	school87@altai.edu.ru	http://school87.altai.edu.ru	1976-08-01	313	Лицензия №Л035-50027 от 11.01.2026	Аккредитация №А151 от 11.01.2026	87	1	28	t	2026-01-11 12:40:10.398002	2026-01-11 12:40:10.398005	1
Лицей №88	село Романово, ш. Брянское, д. 152 стр. 649	+7 (3853) 582794	school88@altai.edu.ru	http://school88.altai.edu.ru	1952-03-14	256	Лицензия №Л035-66994 от 11.01.2026	Аккредитация №А899 от 11.01.2026	88	5	30	t	2026-01-11 12:40:10.398009	2026-01-11 12:40:10.398012	1
Славгородский лицей	город Славгород, бул. Санаторный, д. 7	+7 (3856) 769209	school89@altai.edu.ru	http://school89.altai.edu.ru	1968-06-20	1563	Лицензия №Л035-26094 от 11.01.2026	Аккредитация №А854 от 11.01.2026	89	5	7	t	2026-01-11 12:40:10.413882	2026-01-11 12:40:10.41389	1
Вечерняя школа №90	поселок Михайловское, алл. Королева, д. 6 к. 66	+7 (3855) 756599	school90@altai.edu.ru	http://school90.altai.edu.ru	1971-10-05	122	Лицензия №Л035-92142 от 11.01.2026	Аккредитация №А827 от 11.01.2026	90	7	23	t	2026-01-11 12:40:10.427996	2026-01-11 12:40:10.428003	1
Лицей №91	село Топчиха, ул. Коллективная, д. 83	+7 (3859) 457472	school91@altai.edu.ru	http://school91.altai.edu.ru	1968-07-22	1016	Лицензия №Л035-28669 от 11.01.2026	Аккредитация №А118 от 11.01.2026	91	5	39	t	2026-01-11 12:40:10.428007	2026-01-11 12:40:10.42801	1
Целиннская гимназия	село Целинное, бул. Лермонтова, д. 5/5	+7 (3858) 506735	school92@altai.edu.ru	http://school92.altai.edu.ru	1968-02-27	1076	Лицензия №Л035-79220 от 11.01.2026	Аккредитация №А702 от 11.01.2026	92	5	42	t	2026-01-11 12:40:10.428014	2026-01-11 12:40:10.428017	1
Школа-интернат №93	село Быстрый Исток, алл. Хвойная, д. 1	+7 (3854) 442932	school93@altai.edu.ru	http://school93.altai.edu.ru	1957-03-19	1760	Лицензия №Л035-51040 от 11.01.2026	Аккредитация №А778 от 11.01.2026	93	1	31	t	2026-01-11 12:40:10.428021	2026-01-11 12:40:10.428024	1
Школа с углубленным изучением физики №94	село Романово, алл. Крылова, д. 2/1 к. 351	+7 (3859) 757246	school94@altai.edu.ru	http://school94.altai.edu.ru	1983-12-18	1012	Лицензия №Л035-37733 от 11.01.2026	Аккредитация №А230 от 11.01.2026	94	6	30	t	2026-01-11 12:40:10.428028	2026-01-11 12:40:10.428031	1
Гимназия №95	село Петропавловское, пр. Куйбышева, д. 9 к. 9	+7 (3859) 562527	school95@altai.edu.ru	http://school95.altai.edu.ru	2009-09-01	1144	Лицензия №Л035-18430 от 11.01.2026	Аккредитация №А886 от 11.01.2026	95	5	35	t	2026-01-11 12:40:10.428034	2026-01-11 12:40:10.428037	1
Вечерняя школа №96	поселок Павловск, ш. Павлика Морозова, д. 906 стр. 9/7	+7 (3856) 106885	school96@altai.edu.ru	http://school96.altai.edu.ru	2006-01-26	983	Лицензия №Л035-70284 от 11.01.2026	Аккредитация №А380 от 11.01.2026	96	2	14	t	2026-01-11 12:40:10.428041	2026-01-11 12:40:10.428044	1
Школа с углубленным изучением информатики №97	село Солтон, ул. Горная, д. 618 стр. 6/5	+7 (3853) 366244	school97@altai.edu.ru	http://school97.altai.edu.ru	1969-08-05	684	Лицензия №Л035-59245 от 11.01.2026	Аккредитация №А808 от 11.01.2026	97	1	37	t	2026-01-11 12:40:10.448938	2026-01-11 12:40:10.448945	1
Лицей №98	город Новоалтайск, пер. Западный, д. 43 к. 27	+7 (3856) 149456	school98@altai.edu.ru	http://school98.altai.edu.ru	2006-06-11	727	Лицензия №Л035-25220 от 11.01.2026	Аккредитация №А511 от 11.01.2026	98	2	4	t	2026-01-11 12:40:10.458994	2026-01-11 12:40:10.459001	1
Вечерняя школа №99	село Хабары, пер. Минина, д. 71	+7 (3855) 487510	school99@altai.edu.ru	http://school99.altai.edu.ru	1996-06-08	1150	Лицензия №Л035-12529 от 11.01.2026	Аккредитация №А487 от 11.01.2026	99	5	41	t	2026-01-11 12:40:10.459005	2026-01-11 12:40:10.459009	1
Гимназия №100	село Романово, пер. 8-е Марта, д. 98 к. 135	+7 (3857) 122331	school100@altai.edu.ru	http://school100.altai.edu.ru	1971-05-09	466	Лицензия №Л035-23232 от 11.01.2026	Аккредитация №А327 от 11.01.2026	100	1	30	t	2026-01-11 12:40:10.459028	2026-01-11 12:40:10.459032	1
Лицей №101	поселок Солонешное, наб. Мелиораторов, д. 1/3	+7 (3856) 325441	school101@altai.edu.ru	http://school101.altai.edu.ru	1964-02-28	1859	Лицензия №Л035-85472 от 11.01.2026	Аккредитация №А397 от 11.01.2026	101	1	27	t	2026-01-11 12:40:10.477572	2026-01-11 12:40:10.47758	1
Школа-интернат №103	поселок Красногорское, алл. Черноморская, д. 4 к. 9/1	+7 (3858) 351467	school103@altai.edu.ru	http://school103.altai.edu.ru	1960-08-26	265	Лицензия №Л035-60962 от 11.01.2026	Аккредитация №А707 от 11.01.2026	103	1	26	t	2026-01-11 12:40:10.555537	2026-01-11 12:40:10.555545	1
Мамонтовоский лицей	село Мамонтово, бул. Победа, д. 391 к. 494	+7 (3856) 962522	school104@altai.edu.ru	http://school104.altai.edu.ru	2004-07-25	406	Лицензия №Л035-15724 от 11.01.2026	Аккредитация №А952 от 11.01.2026	104	6	29	t	2026-01-11 12:40:10.578273	2026-01-11 12:40:10.578281	1
Вечерняя школа №105	село Кытманово, наб. Короткая, д. 4/2	+7 (3859) 851955	school105@altai.edu.ru	http://school105.altai.edu.ru	1975-07-26	1492	Лицензия №Л035-60507 от 11.01.2026	Аккредитация №А622 от 11.01.2026	105	7	38	t	2026-01-11 12:40:10.605584	2026-01-11 12:40:10.605592	1
Славгородский лицей	город Славгород, пр. Шаумяна, д. 17	+7 (3853) 191717	school106@altai.edu.ru	http://school106.altai.edu.ru	2010-02-07	1144	Лицензия №Л035-99016 от 11.01.2026	Аккредитация №А282 от 11.01.2026	106	2	7	t	2026-01-11 12:40:10.625309	2026-01-11 12:40:10.625317	1
Горнякский лицей	город Горняк, ул. Макаренко, д. 632 стр. 1	+7 (3857) 962499	school107@altai.edu.ru	http://school107.altai.edu.ru	1971-01-10	195	Лицензия №Л035-34803 от 11.01.2026	Аккредитация №А885 от 11.01.2026	107	5	11	t	2026-01-11 12:40:10.643155	2026-01-11 12:40:10.643163	1
Школа с углубленным изучением истории №108	город Славгород, ш. Курское, д. 1 к. 40	+7 (3852) 912439	school108@altai.edu.ru	http://school108.altai.edu.ru	1964-10-09	195	Лицензия №Л035-33142 от 11.01.2026	Аккредитация №А942 от 11.01.2026	108	4	7	t	2026-01-11 12:40:10.662352	2026-01-11 12:40:10.66236	1
Михайловскский лицей	поселок Михайловское, ш. Волжское, д. 8/6 стр. 824	+7 (3859) 215147	school109@altai.edu.ru	http://school109.altai.edu.ru	2002-03-26	686	Лицензия №Л035-80621 от 11.01.2026	Аккредитация №А589 от 11.01.2026	109	5	23	t	2026-01-11 12:40:10.673246	2026-01-11 12:40:10.673253	1
Вечерняя школа №110	город Новоалтайск, ул. Февральская, д. 5/7 к. 8/9	+7 (3852) 294716	school110@altai.edu.ru	http://school110.altai.edu.ru	1980-10-21	1917	Лицензия №Л035-65623 от 11.01.2026	Аккредитация №А275 от 11.01.2026	110	3	4	t	2026-01-11 12:40:10.688672	2026-01-11 12:40:10.68868	1
Кадетская школа №111	село Мамонтово, наб. Сахалинская, д. 37 стр. 5	+7 (3859) 190662	school111@altai.edu.ru	http://school111.altai.edu.ru	1971-03-13	335	Лицензия №Л035-12956 от 11.01.2026	Аккредитация №А802 от 11.01.2026	111	5	29	t	2026-01-11 12:40:10.688685	2026-01-11 12:40:10.688688	1
Коррекционная школа №112	поселок Павловск, пр. Макарова, д. 6 к. 227	+7 (3858) 772281	school112@altai.edu.ru	http://school112.altai.edu.ru	1998-10-12	1685	Лицензия №Л035-41927 от 11.01.2026	Аккредитация №А761 от 11.01.2026	112	7	14	t	2026-01-11 12:40:10.701161	2026-01-11 12:40:10.701168	1
Кадетская школа №113	поселок Волчиха, наб. Космическая, д. 4/8 к. 9/1	+7 (3855) 934049	school113@altai.edu.ru	http://school113.altai.edu.ru	2002-06-03	426	Лицензия №Л035-48764 от 11.01.2026	Аккредитация №А614 от 11.01.2026	113	7	24	t	2026-01-11 12:40:10.711192	2026-01-11 12:40:10.711199	1
Гимназия №114	город Барнаул, наб. Социалистическая, д. 34 стр. 40	+7 (3852) 481370	school114@altai.edu.ru	http://school114.altai.edu.ru	1952-09-06	1223	Лицензия №Л035-78614 от 11.01.2026	Аккредитация №А760 от 11.01.2026	114	6	1	t	2026-01-11 12:40:10.711203	2026-01-11 12:40:10.711206	1
Лицей №115	город Заринск, наб. Детская, д. 5/1	+7 (3852) 125247	school115@altai.edu.ru	http://school115.altai.edu.ru	1950-01-27	1772	Лицензия №Л035-68179 от 11.01.2026	Аккредитация №А481 от 11.01.2026	115	3	5	t	2026-01-11 12:40:10.727563	2026-01-11 12:40:10.727573	1
Новоалтайский лицей	город Новоалтайск, бул. Моховой, д. 1/5 к. 8/6	+7 (3856) 396808	school116@altai.edu.ru	http://school116.altai.edu.ru	1984-07-13	356	Лицензия №Л035-37584 от 11.01.2026	Аккредитация №А102 от 11.01.2026	116	5	4	t	2026-01-11 12:40:10.727579	2026-01-11 12:40:10.727584	1
Гимназия №117	поселок Волчиха, ул. Смоленская, д. 829 к. 8/2	+7 (3854) 881727	school117@altai.edu.ru	http://school117.altai.edu.ru	1956-11-27	219	Лицензия №Л035-32992 от 11.01.2026	Аккредитация №А241 от 11.01.2026	117	7	24	t	2026-01-11 12:40:10.727589	2026-01-11 12:40:10.727593	1
Средняя общеобразовательная школа №118	город Белокуриха, наб. Луначарского, д. 232 стр. 26	+7 (3858) 162379	school118@altai.edu.ru	http://school118.altai.edu.ru	1969-10-28	1547	Лицензия №Л035-16500 от 11.01.2026	Аккредитация №А630 от 11.01.2026	118	3	10	t	2026-01-11 12:40:10.744938	2026-01-11 12:40:10.744946	1
Средняя общеобразовательная школа №119	село Угловское, ш. Шоссейное, д. 17	+7 (3856) 497867	school119@altai.edu.ru	http://school119.altai.edu.ru	1957-07-15	697	Лицензия №Л035-61151 от 11.01.2026	Аккредитация №А691 от 11.01.2026	119	2	32	t	2026-01-11 12:40:10.755271	2026-01-11 12:40:10.755279	1
Лицей №120	село Кытманово, наб. Троицкая, д. 11 стр. 8/2	+7 (3852) 781923	school120@altai.edu.ru	http://school120.altai.edu.ru	1989-03-11	1955	Лицензия №Л035-96445 от 11.01.2026	Аккредитация №А980 от 11.01.2026	120	3	38	t	2026-01-11 12:40:10.755283	2026-01-11 12:40:10.755287	1
Лицей №121	город Горняк, наб. Фадеева, д. 6/1 к. 9/8	+7 (3859) 191955	school121@altai.edu.ru	http://school121.altai.edu.ru	1951-10-04	1794	Лицензия №Л035-34359 от 11.01.2026	Аккредитация №А304 от 11.01.2026	121	2	11	t	2026-01-11 12:40:10.75529	2026-01-11 12:40:10.755294	1
Солтонская средняя школа	село Солтон, алл. Олега Кошевого, д. 430 к. 468	+7 (3855) 256718	school122@altai.edu.ru	http://school122.altai.edu.ru	1987-06-01	1811	Лицензия №Л035-95902 от 11.01.2026	Аккредитация №А601 от 11.01.2026	122	3	37	t	2026-01-11 12:40:10.768788	2026-01-11 12:40:10.768795	1
Школа с углубленным изучением истории №123	поселок Красногорское, ш. Мичурина, д. 31 стр. 492	+7 (3859) 547651	school123@altai.edu.ru	http://school123.altai.edu.ru	1984-01-06	1699	Лицензия №Л035-36863 от 11.01.2026	Аккредитация №А362 от 11.01.2026	123	4	26	t	2026-01-11 12:40:10.768799	2026-01-11 12:40:10.768803	1
Камень-на-Обиская гимназия	город Камень-на-Оби, ш. Тукая, д. 583 к. 1	+7 (3852) 492737	school124@altai.edu.ru	http://school124.altai.edu.ru	1950-05-02	373	Лицензия №Л035-76595 от 11.01.2026	Аккредитация №А467 от 11.01.2026	124	2	6	t	2026-01-11 12:40:10.780671	2026-01-11 12:40:10.780679	1
Средняя общеобразовательная школа №125	село Хабары, наб. Титова, д. 150	+7 (3859) 330135	school125@altai.edu.ru	http://school125.altai.edu.ru	1985-09-15	295	Лицензия №Л035-12483 от 11.01.2026	Аккредитация №А812 от 11.01.2026	125	2	41	t	2026-01-11 12:40:10.792493	2026-01-11 12:40:10.7925	1
Кадетская школа №126	село Солтон, наб. Средняя, д. 853	+7 (3853) 487321	school126@altai.edu.ru	http://school126.altai.edu.ru	1955-12-11	713	Лицензия №Л035-92753 от 11.01.2026	Аккредитация №А941 от 11.01.2026	126	3	37	t	2026-01-11 12:40:10.792504	2026-01-11 12:40:10.792508	1
Благовещенкаская средняя школа	поселок Благовещенка, наб. Уральская, д. 4	+7 (3855) 265657	school127@altai.edu.ru	http://school127.altai.edu.ru	1955-11-06	1394	Лицензия №Л035-20922 от 11.01.2026	Аккредитация №А609 от 11.01.2026	127	4	22	t	2026-01-11 12:40:10.805401	2026-01-11 12:40:10.805409	1
Быстрый Истокская гимназия	село Быстрый Исток, наб. К.Маркса, д. 89 к. 4	+7 (3857) 758742	school128@altai.edu.ru	http://school128.altai.edu.ru	1992-07-20	1447	Лицензия №Л035-67982 от 11.01.2026	Аккредитация №А393 от 11.01.2026	128	7	31	t	2026-01-11 12:40:10.814754	2026-01-11 12:40:10.814761	1
Коррекционная школа №129	поселок Калманка, пер. 30 лет Победы, д. 1 к. 97	+7 (3859) 487761	school129@altai.edu.ru	http://school129.altai.edu.ru	2000-07-28	513	Лицензия №Л035-46096 от 11.01.2026	Аккредитация №А904 от 11.01.2026	129	5	18	t	2026-01-11 12:40:10.823799	2026-01-11 12:40:10.823807	1
Коррекционная школа №130	село Ребриха, пр. Станиславского, д. 9/6	+7 (3854) 181337	school130@altai.edu.ru	http://school130.altai.edu.ru	2003-07-20	549	Лицензия №Л035-91896 от 11.01.2026	Аккредитация №А181 от 11.01.2026	130	5	28	t	2026-01-11 12:40:10.833026	2026-01-11 12:40:10.833033	1
Школа-интернат №131	поселок Шипуново, алл. Гагарина, д. 6	+7 (3854) 808476	school131@altai.edu.ru	http://school131.altai.edu.ru	1952-02-18	290	Лицензия №Л035-42622 от 11.01.2026	Аккредитация №А742 от 11.01.2026	131	2	15	t	2026-01-11 12:40:10.848601	2026-01-11 12:40:10.848607	1
Гимназия №132	село Ребриха, наб. Рыбацкая, д. 99 стр. 39	+7 (3854) 769438	school132@altai.edu.ru	http://school132.altai.edu.ru	1960-07-19	1483	Лицензия №Л035-15464 от 11.01.2026	Аккредитация №А564 от 11.01.2026	132	2	28	t	2026-01-11 12:40:10.848611	2026-01-11 12:40:10.848615	1
Кадетская школа №133	село Ребриха, ул. Горняцкая, д. 47	+7 (3858) 664437	school133@altai.edu.ru	http://school133.altai.edu.ru	1950-12-26	58	Лицензия №Л035-70250 от 11.01.2026	Аккредитация №А527 от 11.01.2026	133	1	28	t	2026-01-11 12:40:10.848619	2026-01-11 12:40:10.848622	1
Лицей №134	поселок Смоленское, ш. Баумана, д. 7/9 к. 8	+7 (3858) 325882	school134@altai.edu.ru	http://school134.altai.edu.ru	2003-02-07	552	Лицензия №Л035-47451 от 11.01.2026	Аккредитация №А123 от 11.01.2026	134	1	20	t	2026-01-11 12:40:10.864222	2026-01-11 12:40:10.86423	1
Гимназия №135	поселок Шипуново, ш. Ангарское, д. 4 стр. 4	+7 (3854) 249641	school135@altai.edu.ru	http://school135.altai.edu.ru	1959-03-12	1603	Лицензия №Л035-87806 от 11.01.2026	Аккредитация №А602 от 11.01.2026	135	3	15	t	2026-01-11 12:40:10.864234	2026-01-11 12:40:10.864237	1
Школа с углубленным изучением русского языка №136	город Барнаул, пр. Цветочный, д. 21	+7 (3855) 579372	school136@altai.edu.ru	http://school136.altai.edu.ru	1950-10-27	426	Лицензия №Л035-38343 от 11.01.2026	Аккредитация №А112 от 11.01.2026	136	6	1	t	2026-01-11 12:40:10.864241	2026-01-11 12:40:10.864244	1
Лицей №137	город Яровое, ш. Разина, д. 8	+7 (3852) 612859	school137@altai.edu.ru	http://school137.altai.edu.ru	1966-02-28	1519	Лицензия №Л035-49096 от 11.01.2026	Аккредитация №А549 от 11.01.2026	137	7	9	t	2026-01-11 12:40:10.880235	2026-01-11 12:40:10.880246	1
Коррекционная школа №138	поселок Троицкое, ш. Шахтерское, д. 5/4	+7 (3853) 668789	school138@altai.edu.ru	http://school138.altai.edu.ru	1981-10-12	1573	Лицензия №Л035-72966 от 11.01.2026	Аккредитация №А168 от 11.01.2026	138	1	19	t	2026-01-11 12:40:10.892017	2026-01-11 12:40:10.892025	1
Рубцовская средняя школа	город Рубцовск, бул. Новый, д. 7/1 стр. 6/4	+7 (3859) 133420	school139@altai.edu.ru	http://school139.altai.edu.ru	1972-06-20	1995	Лицензия №Л035-60975 от 11.01.2026	Аккредитация №А744 от 11.01.2026	139	3	3	t	2026-01-11 12:40:10.905743	2026-01-11 12:40:10.905756	1
Школа с углубленным изучением химии №140	поселок Троицкое, бул. Ветеранов, д. 1	+7 (3852) 545330	school140@altai.edu.ru	http://school140.altai.edu.ru	1963-04-22	1969	Лицензия №Л035-46618 от 11.01.2026	Аккредитация №А791 от 11.01.2026	140	4	19	t	2026-01-11 12:40:10.905764	2026-01-11 12:40:10.905771	1
Школа-интернат №141	поселок Благовещенка, ул. Средняя, д. 8/5 стр. 74	+7 (3855) 795581	school141@altai.edu.ru	http://school141.altai.edu.ru	1997-02-19	1942	Лицензия №Л035-10245 от 11.01.2026	Аккредитация №А769 от 11.01.2026	141	6	22	t	2026-01-11 12:40:10.905778	2026-01-11 12:40:10.905784	1
Горнякский лицей	город Горняк, алл. Ленинградская, д. 5 к. 651	+7 (3855) 430726	school142@altai.edu.ru	http://school142.altai.edu.ru	2006-08-11	700	Лицензия №Л035-77422 от 11.01.2026	Аккредитация №А154 от 11.01.2026	142	2	11	t	2026-01-11 12:40:10.905791	2026-01-11 12:40:10.905797	1
Лицей №143	поселок Солонешное, пр. Дзержинского, д. 1 стр. 5	+7 (3855) 188143	school143@altai.edu.ru	http://school143.altai.edu.ru	1993-09-16	1357	Лицензия №Л035-14823 от 11.01.2026	Аккредитация №А275 от 11.01.2026	143	3	27	t	2026-01-11 12:40:10.905804	2026-01-11 12:40:10.90581	1
Бийская средняя школа	город Бийск, бул. Сурикова, д. 3 к. 652	+7 (3854) 137513	school144@altai.edu.ru	http://school144.altai.edu.ru	1994-09-26	1451	Лицензия №Л035-94649 от 11.01.2026	Аккредитация №А735 от 11.01.2026	144	4	2	t	2026-01-11 12:40:10.927895	2026-01-11 12:40:10.927902	1
Быстрый Истокская гимназия	село Быстрый Исток, наб. Николаева, д. 534 стр. 382	+7 (3858) 147902	school145@altai.edu.ru	http://school145.altai.edu.ru	1960-06-12	1166	Лицензия №Л035-74104 от 11.01.2026	Аккредитация №А137 от 11.01.2026	145	5	31	t	2026-01-11 12:40:10.927906	2026-01-11 12:40:10.927909	1
Кадетская школа №146	село Ребриха, ул. 60 лет Октября, д. 5/1	+7 (3853) 146462	school146@altai.edu.ru	http://school146.altai.edu.ru	1974-04-09	567	Лицензия №Л035-56994 от 11.01.2026	Аккредитация №А997 от 11.01.2026	146	2	28	t	2026-01-11 12:40:10.927913	2026-01-11 12:40:10.927916	1
Школа с углубленным изучением русского языка №147	село Целинное, наб. Николаева, д. 4/4 к. 2/9	+7 (3852) 975811	school147@altai.edu.ru	http://school147.altai.edu.ru	1950-03-23	1907	Лицензия №Л035-15459 от 11.01.2026	Аккредитация №А330 от 11.01.2026	147	5	42	t	2026-01-11 12:40:10.944943	2026-01-11 12:40:10.944951	1
Вечерняя школа №148	город Камень-на-Оби, алл. Жуковского, д. 75 к. 13	+7 (3852) 501493	school148@altai.edu.ru	http://school148.altai.edu.ru	1992-07-04	1999	Лицензия №Л035-21137 от 11.01.2026	Аккредитация №А876 от 11.01.2026	148	4	6	t	2026-01-11 12:40:10.944955	2026-01-11 12:40:10.944958	1
Гимназия №149	село Кытманово, пер. Тихий, д. 779 к. 8/4	+7 (3855) 472270	school149@altai.edu.ru	http://school149.altai.edu.ru	2000-09-22	464	Лицензия №Л035-78495 от 11.01.2026	Аккредитация №А758 от 11.01.2026	149	5	38	t	2026-01-11 12:40:10.944962	2026-01-11 12:40:10.944965	1
Смоленскский лицей	поселок Смоленское, ш. Петровское, д. 340	+7 (3853) 390016	school150@altai.edu.ru	http://school150.altai.edu.ru	1964-08-12	1319	Лицензия №Л035-34501 от 11.01.2026	Аккредитация №А728 от 11.01.2026	150	7	20	t	2026-01-11 12:40:10.944969	2026-01-11 12:40:10.944972	1
Коррекционная школа №151	село Кытманово, ул. Поперечная, д. 93 к. 26	+7 (3855) 793928	school151@altai.edu.ru	http://school151.altai.edu.ru	1956-05-24	1306	Лицензия №Л035-72205 от 11.01.2026	Аккредитация №А244 от 11.01.2026	151	2	38	t	2026-01-11 12:40:10.965834	2026-01-11 12:40:10.965842	1
Вечерняя школа №152	поселок Поспелиха, пр. Российский, д. 24 к. 7/1	+7 (3857) 479421	school152@altai.edu.ru	http://school152.altai.edu.ru	1955-08-09	1809	Лицензия №Л035-52478 от 11.01.2026	Аккредитация №А919 от 11.01.2026	152	1	17	t	2026-01-11 12:40:10.996799	2026-01-11 12:40:10.996807	1
Гимназия №153	город Бийск, ул. Сиреневая, д. 1/7 стр. 8	+7 (3858) 437403	school153@altai.edu.ru	http://school153.altai.edu.ru	2007-07-22	1886	Лицензия №Л035-59968 от 11.01.2026	Аккредитация №А232 от 11.01.2026	153	1	2	t	2026-01-11 12:40:11.029913	2026-01-11 12:40:11.02992	1
Мамонтовоская средняя школа	село Мамонтово, наб. Химиков, д. 1 стр. 93	+7 (3858) 150810	school154@altai.edu.ru	http://school154.altai.edu.ru	1984-08-12	1954	Лицензия №Л035-78508 от 11.01.2026	Аккредитация №А110 от 11.01.2026	154	6	29	t	2026-01-11 12:40:11.049854	2026-01-11 12:40:11.049862	1
Шелаболихаский лицей	поселок Шелаболиха, алл. Ставропольская, д. 965 стр. 5	+7 (3852) 202409	school155@altai.edu.ru	http://school155.altai.edu.ru	1958-06-12	1104	Лицензия №Л035-95182 от 11.01.2026	Аккредитация №А309 от 11.01.2026	155	4	25	t	2026-01-11 12:40:11.078653	2026-01-11 12:40:11.07866	1
Вечерняя школа №156	город Горняк, пр. Дружба, д. 3	+7 (3853) 178712	school156@altai.edu.ru	http://school156.altai.edu.ru	1985-09-11	1007	Лицензия №Л035-55074 от 11.01.2026	Аккредитация №А669 от 11.01.2026	156	6	11	t	2026-01-11 12:40:11.090877	2026-01-11 12:40:11.090884	1
Лицей №157	село Кытманово, ш. Харьковское, д. 8/3 к. 5/6	+7 (3853) 478582	school157@altai.edu.ru	http://school157.altai.edu.ru	1974-12-02	851	Лицензия №Л035-98882 от 11.01.2026	Аккредитация №А264 от 11.01.2026	157	5	38	t	2026-01-11 12:40:11.11092	2026-01-11 12:40:11.110929	1
Коррекционная школа №158	поселок Кулунда, бул. Отрадный, д. 621 стр. 5	+7 (3853) 258873	school158@altai.edu.ru	http://school158.altai.edu.ru	2006-03-01	615	Лицензия №Л035-84570 от 11.01.2026	Аккредитация №А650 от 11.01.2026	158	5	21	t	2026-01-11 12:40:11.136192	2026-01-11 12:40:11.136199	1
Школа с углубленным изучением английского языка №159	поселок Солонешное, ул. Фадеева, д. 9	+7 (3859) 826241	school159@altai.edu.ru	http://school159.altai.edu.ru	1998-01-17	1428	Лицензия №Л035-58752 от 11.01.2026	Аккредитация №А374 от 11.01.2026	159	6	27	t	2026-01-11 12:40:11.148411	2026-01-11 12:40:11.148419	1
Троицкский лицей	поселок Троицкое, ул. Пригородная, д. 9	+7 (3852) 899723	school160@altai.edu.ru	http://school160.altai.edu.ru	1977-06-04	401	Лицензия №Л035-49860 от 11.01.2026	Аккредитация №А889 от 11.01.2026	160	1	19	t	2026-01-11 12:40:11.161898	2026-01-11 12:40:11.161905	1
Лицей №161	поселок Шипуново, алл. З.Космодемьянской, д. 464 к. 66	+7 (3858) 652740	school161@altai.edu.ru	http://school161.altai.edu.ru	1975-02-05	1306	Лицензия №Л035-73664 от 11.01.2026	Аккредитация №А170 от 11.01.2026	161	7	15	t	2026-01-11 12:40:11.177625	2026-01-11 12:40:11.177633	1
Яровский лицей	город Яровое, ул. Базарная, д. 324 стр. 61	+7 (3854) 308307	school162@altai.edu.ru	http://school162.altai.edu.ru	1973-02-19	1433	Лицензия №Л035-60661 от 11.01.2026	Аккредитация №А960 от 11.01.2026	162	4	9	t	2026-01-11 12:40:11.189782	2026-01-11 12:40:11.189789	1
Школа-интернат №163	город Белокуриха, наб. Веселая, д. 7	+7 (3856) 696699	school163@altai.edu.ru	http://school163.altai.edu.ru	1963-11-11	669	Лицензия №Л035-76755 от 11.01.2026	Аккредитация №А349 от 11.01.2026	163	6	10	t	2026-01-11 12:40:11.201079	2026-01-11 12:40:11.201086	1
Троицкская средняя школа	поселок Троицкое, ш. Менделеева, д. 164	+7 (3853) 427378	school164@altai.edu.ru	http://school164.altai.edu.ru	1985-05-28	551	Лицензия №Л035-13844 от 11.01.2026	Аккредитация №А870 от 11.01.2026	164	4	19	t	2026-01-11 12:40:11.20109	2026-01-11 12:40:11.201093	1
Кадетская школа №165	город Горняк, бул. Уральский, д. 845	+7 (3854) 719610	school165@altai.edu.ru	http://school165.altai.edu.ru	1969-04-09	110	Лицензия №Л035-29733 от 11.01.2026	Аккредитация №А626 от 11.01.2026	165	6	11	t	2026-01-11 12:40:11.201096	2026-01-11 12:40:11.2011	1
Школа-интернат №166	село Целинное, ш. Привокзальное, д. 90	+7 (3857) 709724	school166@altai.edu.ru	http://school166.altai.edu.ru	2005-11-15	549	Лицензия №Л035-85958 от 11.01.2026	Аккредитация №А505 от 11.01.2026	166	5	42	t	2026-01-11 12:40:11.217235	2026-01-11 12:40:11.217242	1
Школа с углубленным изучением английского языка №167	село Романово, бул. Шахтерский, д. 414 к. 6	+7 (3852) 498973	school167@altai.edu.ru	http://school167.altai.edu.ru	1993-09-24	58	Лицензия №Л035-67840 от 11.01.2026	Аккредитация №А954 от 11.01.2026	167	4	30	t	2026-01-11 12:40:11.226587	2026-01-11 12:40:11.226594	1
Лицей №168	поселок Смоленское, бул. 70 лет Октября, д. 4/5 стр. 288	+7 (3859) 402344	school168@altai.edu.ru	http://school168.altai.edu.ru	2005-03-07	1535	Лицензия №Л035-88255 от 11.01.2026	Аккредитация №А791 от 11.01.2026	168	1	20	t	2026-01-11 12:40:11.236665	2026-01-11 12:40:11.236673	1
Лицей №169	город Славгород, пер. Привокзальный, д. 7/2 к. 2/6	+7 (3854) 802013	school169@altai.edu.ru	http://school169.altai.edu.ru	1955-06-01	1730	Лицензия №Л035-80185 от 11.01.2026	Аккредитация №А674 от 11.01.2026	169	3	7	t	2026-01-11 12:40:11.247402	2026-01-11 12:40:11.247418	1
Вечерняя школа №170	город Новоалтайск, ш. Жукова, д. 54 к. 618	+7 (3856) 142963	school170@altai.edu.ru	http://school170.altai.edu.ru	2010-11-24	1214	Лицензия №Л035-27975 от 11.01.2026	Аккредитация №А429 от 11.01.2026	170	4	4	t	2026-01-11 12:40:11.256151	2026-01-11 12:40:11.256159	1
Лицей №171	поселок Тальменка, наб. Ермака, д. 399 стр. 5/3	+7 (3858) 733669	school171@altai.edu.ru	http://school171.altai.edu.ru	1951-11-27	857	Лицензия №Л035-96196 от 11.01.2026	Аккредитация №А657 от 11.01.2026	171	6	13	t	2026-01-11 12:40:11.266093	2026-01-11 12:40:11.266106	1
Средняя общеобразовательная школа №172	село Ребриха, ул. Казачья, д. 24	+7 (3854) 194446	school172@altai.edu.ru	http://school172.altai.edu.ru	1996-12-01	306	Лицензия №Л035-94134 от 11.01.2026	Аккредитация №А598 от 11.01.2026	172	2	28	t	2026-01-11 12:40:11.275816	2026-01-11 12:40:11.275824	1
Кадетская школа №173	город Рубцовск, бул. Прудовой, д. 6	+7 (3859) 582910	school173@altai.edu.ru	http://school173.altai.edu.ru	2003-12-10	511	Лицензия №Л035-66891 от 11.01.2026	Аккредитация №А829 от 11.01.2026	173	7	3	t	2026-01-11 12:40:11.288354	2026-01-11 12:40:11.288361	1
Коррекционная школа №174	город Новоалтайск, алл. Жукова, д. 6/9	+7 (3853) 967603	school174@altai.edu.ru	http://school174.altai.edu.ru	1963-11-12	598	Лицензия №Л035-90883 от 11.01.2026	Аккредитация №А419 от 11.01.2026	174	3	4	t	2026-01-11 12:40:11.288365	2026-01-11 12:40:11.288368	1
Вечерняя школа №175	город Белокуриха, пер. Курский, д. 175 к. 747	+7 (3853) 870660	school175@altai.edu.ru	http://school175.altai.edu.ru	1957-05-25	879	Лицензия №Л035-18397 от 11.01.2026	Аккредитация №А374 от 11.01.2026	175	2	10	t	2026-01-11 12:40:11.288372	2026-01-11 12:40:11.288376	1
Кадетская школа №176	село Зональное, пр. Поперечный, д. 7/8	+7 (3858) 327410	school176@altai.edu.ru	http://school176.altai.edu.ru	1977-10-15	1366	Лицензия №Л035-93233 от 11.01.2026	Аккредитация №А412 от 11.01.2026	176	6	36	t	2026-01-11 12:40:11.312266	2026-01-11 12:40:11.312273	1
Средняя общеобразовательная школа №177	поселок Кулунда, пр. Лесхозный, д. 4/4	+7 (3854) 495753	school177@altai.edu.ru	http://school177.altai.edu.ru	1993-04-12	788	Лицензия №Л035-57116 от 11.01.2026	Аккредитация №А944 от 11.01.2026	177	7	21	t	2026-01-11 12:40:11.312277	2026-01-11 12:40:11.312281	1
Вечерняя школа №178	село Ребриха, алл. Привокзальная, д. 88	+7 (3853) 981432	school178@altai.edu.ru	http://school178.altai.edu.ru	1993-11-05	844	Лицензия №Л035-66066 от 11.01.2026	Аккредитация №А759 от 11.01.2026	178	1	28	t	2026-01-11 12:40:11.312285	2026-01-11 12:40:11.312288	1
Школа-интернат №179	город Славгород, пр. Мелиораторов, д. 4 к. 1	+7 (3852) 450540	school179@altai.edu.ru	http://school179.altai.edu.ru	2010-05-26	1937	Лицензия №Л035-12715 от 11.01.2026	Аккредитация №А427 от 11.01.2026	179	5	7	t	2026-01-11 12:40:11.312291	2026-01-11 12:40:11.312294	1
Школа с углубленным изучением математики №180	поселок Солонешное, пер. Репина, д. 4 к. 23	+7 (3856) 760537	school180@altai.edu.ru	http://school180.altai.edu.ru	1999-01-02	1802	Лицензия №Л035-57276 от 11.01.2026	Аккредитация №А752 от 11.01.2026	180	4	27	t	2026-01-11 12:40:11.312298	2026-01-11 12:40:11.312301	1
Волчихаский лицей	поселок Волчиха, ул. Марта 8, д. 2	+7 (3857) 320030	school181@altai.edu.ru	http://school181.altai.edu.ru	1994-10-03	236	Лицензия №Л035-21460 от 11.01.2026	Аккредитация №А144 от 11.01.2026	181	5	24	t	2026-01-11 12:40:11.331664	2026-01-11 12:40:11.331672	1
Гимназия №182	село Курья, наб. Пархоменко, д. 8/2 стр. 22	+7 (3854) 176756	school182@altai.edu.ru	http://school182.altai.edu.ru	1977-01-26	1065	Лицензия №Л035-90328 от 11.01.2026	Аккредитация №А811 от 11.01.2026	182	1	34	t	2026-01-11 12:40:11.347697	2026-01-11 12:40:11.347706	1
Кадетская школа №183	город Горняк, наб. Флотская, д. 92	+7 (3854) 931019	school183@altai.edu.ru	http://school183.altai.edu.ru	1982-11-06	1642	Лицензия №Л035-74002 от 11.01.2026	Аккредитация №А146 от 11.01.2026	183	4	11	t	2026-01-11 12:40:11.34771	2026-01-11 12:40:11.347713	1
Белокурихаский лицей	город Белокуриха, ул. Ленская, д. 62 стр. 1/6	+7 (3857) 130613	school184@altai.edu.ru	http://school184.altai.edu.ru	1954-10-06	837	Лицензия №Л035-13813 от 11.01.2026	Аккредитация №А545 от 11.01.2026	184	7	10	t	2026-01-11 12:40:11.347717	2026-01-11 12:40:11.34772	1
Кадетская школа №185	поселок Кулунда, ш. Автомобилистов, д. 9/8 стр. 112	+7 (3855) 121539	school185@altai.edu.ru	http://school185.altai.edu.ru	1990-01-25	1542	Лицензия №Л035-13992 от 11.01.2026	Аккредитация №А897 от 11.01.2026	185	5	21	t	2026-01-11 12:40:11.347724	2026-01-11 12:40:11.347727	1
Вечерняя школа №186	поселок Волчиха, наб. Специалистов, д. 7/1 стр. 3	+7 (3858) 639611	school186@altai.edu.ru	http://school186.altai.edu.ru	1984-11-25	568	Лицензия №Л035-65685 от 11.01.2026	Аккредитация №А217 от 11.01.2026	186	7	24	t	2026-01-11 12:40:11.34773	2026-01-11 12:40:11.347733	1
Кадетская школа №187	поселок Павловск, ш. Донское, д. 90 к. 99	+7 (3857) 986671	school187@altai.edu.ru	http://school187.altai.edu.ru	1958-01-01	971	Лицензия №Л035-21993 от 11.01.2026	Аккредитация №А229 от 11.01.2026	187	3	14	t	2026-01-11 12:40:11.369078	2026-01-11 12:40:11.369088	1
Романовоская гимназия	село Романово, пр. Новгородский, д. 5 к. 90	+7 (3857) 908019	school188@altai.edu.ru	http://school188.altai.edu.ru	1982-01-18	739	Лицензия №Л035-39977 от 11.01.2026	Аккредитация №А826 от 11.01.2026	188	4	30	t	2026-01-11 12:40:11.369092	2026-01-11 12:40:11.369096	1
Средняя общеобразовательная школа №189	село Хабары, пер. Щетинкина, д. 49 стр. 189	+7 (3858) 784442	school189@altai.edu.ru	http://school189.altai.edu.ru	2000-03-27	183	Лицензия №Л035-32749 от 11.01.2026	Аккредитация №А398 от 11.01.2026	189	2	41	t	2026-01-11 12:40:11.395964	2026-01-11 12:40:11.395972	1
Школа с углубленным изучением обществознания №190	село Кытманово, ул. Достоевского, д. 4/2	+7 (3854) 905861	school190@altai.edu.ru	http://school190.altai.edu.ru	1958-03-16	1741	Лицензия №Л035-61975 от 11.01.2026	Аккредитация №А866 от 11.01.2026	190	7	38	t	2026-01-11 12:40:11.395976	2026-01-11 12:40:11.39598	1
Новоалтайская гимназия	город Новоалтайск, пр. Карьерный, д. 55 стр. 22	+7 (3854) 641733	school191@altai.edu.ru	http://school191.altai.edu.ru	2003-03-22	639	Лицензия №Л035-48957 от 11.01.2026	Аккредитация №А808 от 11.01.2026	191	2	4	t	2026-01-11 12:40:11.395984	2026-01-11 12:40:11.395987	1
Лицей №192	поселок Шелаболиха, наб. Проезжая, д. 2	+7 (3857) 753575	school192@altai.edu.ru	http://school192.altai.edu.ru	1981-02-17	888	Лицензия №Л035-59697 от 11.01.2026	Аккредитация №А974 от 11.01.2026	192	6	25	t	2026-01-11 12:40:11.395991	2026-01-11 12:40:11.395994	1
Солонешнская средняя школа	поселок Солонешное, алл. Маркса Карла, д. 85 к. 94	+7 (3858) 585008	school193@altai.edu.ru	http://school193.altai.edu.ru	1999-12-09	1728	Лицензия №Л035-46812 от 11.01.2026	Аккредитация №А641 от 11.01.2026	193	5	27	t	2026-01-11 12:40:11.395997	2026-01-11 12:40:11.396	1
Коррекционная школа №194	город Бийск, наб. Ломоносова, д. 1 стр. 20	+7 (3852) 997260	school194@altai.edu.ru	http://school194.altai.edu.ru	1975-10-12	1614	Лицензия №Л035-74262 от 11.01.2026	Аккредитация №А815 от 11.01.2026	194	2	2	t	2026-01-11 12:40:11.396004	2026-01-11 12:40:11.396007	1
Павловская гимназия	поселок Павловск, ш. Заливное, д. 2/5 стр. 8/8	+7 (3854) 245560	school195@altai.edu.ru	http://school195.altai.edu.ru	1959-03-25	720	Лицензия №Л035-96922 от 11.01.2026	Аккредитация №А294 от 11.01.2026	195	1	14	t	2026-01-11 12:40:11.39601	2026-01-11 12:40:11.396013	1
Бийская гимназия	город Бийск, пр. Привокзальный, д. 567 стр. 8/8	+7 (3855) 526621	school196@altai.edu.ru	http://school196.altai.edu.ru	1961-12-12	596	Лицензия №Л035-57293 от 11.01.2026	Аккредитация №А780 от 11.01.2026	196	7	2	t	2026-01-11 12:40:11.396017	2026-01-11 12:40:11.39602	1
Вечерняя школа №197	город Рубцовск, наб. Черноморская, д. 908	+7 (3858) 213938	school197@altai.edu.ru	http://school197.altai.edu.ru	1997-08-19	782	Лицензия №Л035-81624 от 11.01.2026	Аккредитация №А426 от 11.01.2026	197	5	3	t	2026-01-11 12:40:11.396023	2026-01-11 12:40:11.396026	1
Кадетская школа №198	поселок Павловск, наб. Инженерная, д. 5/6	+7 (3853) 856197	school198@altai.edu.ru	http://school198.altai.edu.ru	1975-09-01	838	Лицензия №Л035-16475 от 11.01.2026	Аккредитация №А182 от 11.01.2026	198	7	14	t	2026-01-11 12:40:11.39603	2026-01-11 12:40:11.396033	1
Кулундаский лицей	поселок Кулунда, пер. Радищева, д. 682 к. 15	+7 (3855) 693070	school199@altai.edu.ru	http://school199.altai.edu.ru	1969-02-02	474	Лицензия №Л035-77642 от 11.01.2026	Аккредитация №А562 от 11.01.2026	199	2	21	t	2026-01-11 12:40:11.396036	2026-01-11 12:40:11.396039	1
Коррекционная школа №200	поселок Троицкое, наб. Лермонтова, д. 1 стр. 382	+7 (3858) 216023	school200@altai.edu.ru	http://school200.altai.edu.ru	1982-03-25	888	Лицензия №Л035-59811 от 11.01.2026	Аккредитация №А738 от 11.01.2026	200	7	19	t	2026-01-11 12:40:11.396043	2026-01-11 12:40:11.396046	1
Гимназия №1 г. Бийска	г. Бийск, ул. пер. Карьерный, 85	+7 (3854) 427879	gymnasium1@bijsk.edu.ru	http://gymnasium1.bijsk.edu.ru	1961-09-01	608	Лицензия №Г001	Аккредитация №А001	201	2	2	t	2026-01-11 12:40:12.058895	2026-01-11 12:40:12.058905	1
Гимназия №2 г. Бийска	г. Бийск, ул. ш. Мусы Джалиля, 36	+7 (3854) 857863	gymnasium2@bijsk.edu.ru	http://gymnasium2.bijsk.edu.ru	1962-09-01	652	Лицензия №Г002	Аккредитация №А002	202	2	2	t	2026-01-11 12:40:12.058911	2026-01-11 12:40:12.058917	1
Гимназия №3 г. Бийска	г. Бийск, ул. ул. Хуторская, 39	+7 (3854) 712694	gymnasium3@bijsk.edu.ru	http://gymnasium3.bijsk.edu.ru	1963-09-01	597	Лицензия №Г003	Аккредитация №А003	203	2	2	t	2026-01-11 12:40:12.058922	2026-01-11 12:40:12.058926	1
Гимназия №4 г. Бийска	г. Бийск, ул. алл. Аэродромная, 41	+7 (3854) 759436	gymnasium4@bijsk.edu.ru	http://gymnasium4.bijsk.edu.ru	1964-09-01	346	Лицензия №Г004	Аккредитация №А004	204	2	2	t	2026-01-11 12:40:12.05898	2026-01-11 12:40:12.058984	1
Гимназия №5 г. Бийска	г. Бийск, ул. пер. 40 лет Октября, 7	+7 (3854) 721369	gymnasium5@bijsk.edu.ru	http://gymnasium5.bijsk.edu.ru	1965-09-01	680	Лицензия №Г005	Аккредитация №А005	205	2	2	t	2026-01-11 12:40:12.058988	2026-01-11 12:40:12.058991	1
Школа с библиотекой №1	город Рубцовск, ул. ул. Тупиковая, 82	+7 (3855) 459672	library_school1@altai.edu.ru	\N	1971-09-01	558	\N	\N	206	2	3	t	2026-01-11 12:40:12.063968	2026-01-11 12:40:12.063976	1
Школа с библиотекой №2	село Быстрый Исток, ул. пер. Мелиораторов, 79	+7 (3856) 587106	library_school2@altai.edu.ru	\N	1972-09-01	554	\N	\N	207	5	31	t	2026-01-11 12:40:12.068509	2026-01-11 12:40:12.068517	1
Школа с библиотекой №3	город Заринск, ул. бул. Кубанский, 23	+7 (3856) 769586	library_school3@altai.edu.ru	\N	1973-09-01	551	\N	\N	208	3	5	t	2026-01-11 12:40:12.073138	2026-01-11 12:40:12.073146	1
Школа с библиотекой №4	село Ребриха, ул. ш. Осенное, 95	+7 (3854) 477992	library_school4@altai.edu.ru	\N	1974-09-01	461	\N	\N	209	1	28	t	2026-01-11 12:40:12.077105	2026-01-11 12:40:12.077113	1
Школа с библиотекой №5	город Алейск, ул. пр. Набережный, 44	+7 (3853) 398305	library_school5@altai.edu.ru	\N	1975-09-01	495	\N	\N	210	7	8	t	2026-01-11 12:40:12.081513	2026-01-11 12:40:12.08152	1
Школа с библиотекой №8	поселок Солонешное, ул. алл. Восточная, 91	+7 (3853) 476584	library_school8@altai.edu.ru	\N	1978-09-01	245	\N	\N	213	6	27	t	2026-01-11 12:40:12.094192	2026-01-11 12:40:12.0942	1
Школа с библиотекой №9	село Солтон, ул. ш. Кирпичное, 86	+7 (3857) 903140	library_school9@altai.edu.ru	\N	1979-09-01	283	\N	\N	214	5	37	t	2026-01-11 12:40:12.097717	2026-01-11 12:40:12.097724	1
Школа с библиотекой №10	село Целинное, ул. пр. Народный, 10	+7 (3855) 338567	library_school10@altai.edu.ru	\N	1980-09-01	547	\N	\N	215	6	42	t	2026-01-11 12:40:12.101413	2026-01-11 12:40:12.101422	1
Школа с углубленным изучением физики №1	город Яровое, ул. ул. Макарова, 75	+7 (3859) 688244	physics_school1@altai.edu.ru	\N	1981-09-01	336	\N	\N	216	5	9	t	2026-01-11 12:40:12.105616	2026-01-11 12:40:12.105625	1
Школа с углубленным изучением физики №2	поселок Шипуново, ул. алл. Кольцевая, 98	+7 (3852) 640390	physics_school2@altai.edu.ru	\N	1982-09-01	495	\N	\N	217	3	15	t	2026-01-11 12:40:12.11845	2026-01-11 12:40:12.118458	1
Школа с углубленным изучением физики №3	город Змеиногорск, ул. бул. Безымянный, 20	+7 (3858) 650042	physics_school3@altai.edu.ru	\N	1983-09-01	375	\N	\N	218	5	12	t	2026-01-11 12:40:12.123874	2026-01-11 12:40:12.123882	1
Школа с углубленным изучением физики №4	город Бийск, ул. алл. Серова, 12	+7 (3859) 766214	physics_school4@altai.edu.ru	\N	1984-09-01	447	\N	\N	219	4	2	t	2026-01-11 12:40:12.123886	2026-01-11 12:40:12.123889	1
Школа с углубленным изучением физики №5	село Петропавловское, ул. алл. Севастопольская, 50	+7 (3856) 844306	physics_school5@altai.edu.ru	\N	1985-09-01	386	\N	\N	220	3	35	t	2026-01-11 12:40:12.129065	2026-01-11 12:40:12.129073	1
Школа с углубленным изучением физики №6	поселок Павловск, ул. ш. З.Космодемьянской, 91	+7 (3857) 111456	physics_school6@altai.edu.ru	\N	1986-09-01	355	\N	\N	221	3	14	t	2026-01-11 12:40:12.133307	2026-01-11 12:40:12.133315	1
Школа с углубленным изучением физики №7	город Горняк, ул. ш. Белорусское, 62	+7 (3857) 412605	physics_school7@altai.edu.ru	\N	1987-09-01	340	\N	\N	222	3	11	t	2026-01-11 12:40:12.1385	2026-01-11 12:40:12.138508	1
Школа-интернат №1	село Курья, ул. пр. Мая 1, 49	+7 (3856) 110581	internat1@altai.edu.ru	\N	1966-09-01	269	\N	\N	223	4	34	t	2026-01-11 12:40:12.142899	2026-01-11 12:40:12.142907	1
Школа-интернат №2	поселок Волчиха, ул. пр. Большой, 87	+7 (3857) 776163	internat2@altai.edu.ru	\N	1967-09-01	406	\N	\N	224	4	24	t	2026-01-11 12:40:12.145279	2026-01-11 12:40:12.145287	1
Школа-интернат №3	город Славгород, ул. пр. Ватутина, 53	+7 (3859) 511407	internat3@altai.edu.ru	\N	1968-09-01	301	\N	\N	225	4	7	t	2026-01-11 12:40:12.147823	2026-01-11 12:40:12.147831	1
Школа-интернат №4	село Топчиха, ул. пр. Кооперативный, 77	+7 (3856) 464080	internat4@altai.edu.ru	\N	1969-09-01	332	\N	\N	226	4	39	t	2026-01-11 12:40:12.150641	2026-01-11 12:40:12.150648	1
Школа-интернат №5	поселок Павловск, ул. ул. Леонова, 65	+7 (3859) 789608	internat5@altai.edu.ru	\N	1970-09-01	457	\N	\N	227	4	14	t	2026-01-11 12:40:12.150652	2026-01-11 12:40:12.150655	1
Барнаулская средняя школа	город Барнаул, ул. Песчаная, д. 769 стр. 84	+7 (3857) 728127	school102@altai.edu.ru	http://school102.altai.edu.ru	1992-03-19	1233	Лицензия №Л035-35795 от 11.01.2026	Аккредитация №А417 от 11.01.2026	102	6	1	t	2026-01-11 12:40:10.52633	2026-01-11 17:06:45.163354	1
\.


--
-- Data for Name: School_Employee; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."School_Employee" ("PK_School", "PK_Employee") FROM stdin;
1	107
1	142
1	120
1	185
1	180
1	174
1	140
1	160
1	138
1	171
1	151
1	194
1	191
1	125
1	183
1	128
1	129
1	197
1	179
1	118
1	134
1	181
1	137
1	113
1	147
1	115
1	132
1	105
1	182
1	127
1	144
1	169
1	154
1	177
1	165
1	184
1	170
1	116
1	139
2	150
2	161
2	137
2	105
2	155
2	153
2	195
2	176
2	164
2	186
2	112
2	111
2	185
2	173
2	115
2	122
2	182
2	143
2	162
2	197
2	154
2	168
2	145
2	158
3	197
3	171
3	156
3	103
3	154
3	164
3	131
3	174
3	105
3	145
3	178
3	159
3	122
3	112
3	140
3	107
3	187
3	185
4	199
4	161
4	152
4	176
4	109
4	155
4	129
4	191
4	146
4	136
4	115
4	118
4	104
4	180
4	163
4	168
4	173
4	198
5	142
5	110
5	108
5	192
5	145
5	132
5	124
5	105
5	133
5	191
5	136
5	200
5	162
5	159
5	146
5	141
5	113
5	152
5	134
5	171
5	193
5	135
5	139
5	129
5	173
5	183
6	116
6	144
6	127
6	137
6	143
6	168
6	130
6	148
6	174
6	147
6	177
6	152
6	104
6	108
6	110
7	156
7	102
7	167
7	179
7	186
7	193
7	118
7	190
7	134
7	164
7	180
7	154
7	199
7	191
7	136
7	119
7	165
7	177
7	200
7	168
7	113
7	130
8	114
8	144
8	106
8	111
8	124
8	136
8	130
8	138
8	200
8	149
9	170
9	137
9	134
9	133
9	115
9	127
9	186
9	102
9	109
9	136
9	141
9	188
9	147
9	161
9	183
9	160
9	195
9	144
9	167
9	120
9	162
9	124
9	114
9	156
10	149
10	175
10	120
10	172
10	137
10	129
10	195
10	200
10	111
10	170
10	168
10	151
10	117
11	181
11	134
11	130
11	124
11	161
11	122
11	117
11	198
11	192
11	136
11	154
11	200
11	151
11	141
11	197
11	173
11	189
11	185
11	172
11	166
11	102
11	176
11	131
11	146
11	180
11	125
11	110
11	152
11	144
11	101
11	195
11	114
11	138
11	143
11	116
11	106
12	184
12	189
12	185
12	177
12	158
12	165
12	144
12	132
12	133
12	160
12	194
12	172
12	168
12	139
12	123
12	197
12	176
12	101
12	178
12	104
12	156
12	116
12	128
12	190
12	164
12	138
12	145
13	169
13	165
13	126
13	112
13	133
13	180
13	197
13	111
13	113
13	150
13	163
13	168
13	158
13	166
13	156
13	161
13	187
13	104
13	146
13	188
13	183
13	153
13	105
13	200
13	173
13	102
13	178
13	157
14	130
14	177
14	101
14	195
14	141
14	120
14	197
14	163
14	178
14	133
14	134
16	131
16	140
16	167
16	165
16	183
16	111
16	196
16	174
16	146
16	129
16	127
16	182
16	144
16	142
16	110
16	143
16	114
16	171
16	178
16	188
16	135
16	189
16	184
15	120
15	146
15	145
15	119
15	154
15	176
15	165
15	104
15	148
15	200
15	189
15	196
15	192
15	199
15	187
15	114
15	182
15	147
15	156
15	144
15	193
15	183
15	126
15	134
15	108
15	157
15	161
17	182
17	150
17	110
17	157
17	188
17	145
17	146
17	122
17	159
17	192
17	158
17	190
17	131
17	135
17	177
17	104
17	186
17	181
17	200
17	187
17	151
17	132
17	153
17	136
17	185
17	105
17	113
18	190
18	137
18	144
18	145
18	181
18	167
18	154
18	151
18	138
18	129
18	102
18	194
18	105
18	112
18	142
18	163
18	123
18	148
18	185
18	158
18	174
18	127
18	180
18	149
18	165
19	151
19	196
19	106
19	185
19	181
19	123
19	107
19	140
19	138
19	108
19	169
19	113
19	187
19	114
19	143
19	182
19	171
19	145
19	117
19	179
19	144
20	113
20	144
20	189
20	134
20	110
20	167
20	118
20	184
20	193
20	123
20	104
20	143
20	165
20	170
20	190
20	109
20	176
20	150
20	129
20	111
20	199
20	101
20	121
20	128
20	132
20	141
20	169
20	162
20	173
20	112
20	133
20	194
20	197
20	142
20	159
20	156
20	175
20	127
20	188
21	129
21	191
21	155
21	183
21	163
21	175
21	180
21	126
21	165
21	147
21	114
21	151
21	167
21	156
21	102
21	194
21	179
22	200
22	112
22	152
22	105
22	158
22	171
22	189
22	104
22	146
22	148
22	173
22	108
22	125
22	106
22	199
22	144
22	198
22	175
22	156
24	153
24	133
24	110
24	119
24	180
24	130
24	116
24	173
24	139
24	149
24	200
24	132
24	171
24	158
24	183
24	156
24	189
24	145
24	161
24	137
24	192
24	152
24	163
24	165
24	151
24	179
24	178
24	129
24	176
24	113
24	191
24	187
24	177
24	168
24	108
24	128
24	186
23	119
23	193
23	132
23	185
23	115
23	106
23	199
23	167
23	143
23	112
23	174
23	175
23	103
23	121
23	195
23	158
23	114
23	151
23	108
23	190
23	148
23	194
23	157
23	107
23	184
23	130
23	164
25	143
25	150
25	169
25	103
25	122
25	124
25	197
25	156
25	175
25	162
25	120
25	133
25	184
26	127
26	111
26	110
26	136
26	105
26	132
26	179
26	130
26	103
26	108
26	196
26	149
26	193
26	163
26	178
26	169
26	177
26	172
26	128
26	150
26	114
26	166
26	191
26	142
26	174
26	162
26	117
26	115
26	126
26	187
26	185
26	153
26	139
26	195
26	175
26	121
26	145
26	180
26	160
26	122
27	121
27	192
27	107
27	161
27	159
27	150
27	174
27	178
27	138
27	108
27	160
27	148
27	119
27	181
27	146
27	196
27	118
28	186
28	176
28	124
28	200
28	199
28	101
28	109
28	143
28	158
28	172
28	155
28	117
28	166
28	160
28	169
28	119
28	104
28	175
28	148
28	142
28	131
28	132
28	168
28	114
28	121
28	115
28	183
28	163
28	138
28	157
28	197
28	174
28	102
28	184
28	195
28	105
29	149
29	135
29	119
29	105
29	166
29	150
29	130
29	174
29	129
29	180
29	108
29	192
29	133
29	170
29	116
29	117
29	163
29	102
29	138
29	111
29	200
29	145
29	118
30	184
30	136
30	113
30	102
30	130
30	196
30	156
30	155
30	139
30	183
30	163
30	117
30	135
30	200
30	176
30	114
30	158
30	187
30	191
30	108
30	125
30	186
30	129
30	131
30	181
30	157
30	137
30	161
30	194
33	196
33	112
33	123
33	185
33	121
33	175
33	146
33	104
33	138
33	199
33	142
33	111
31	133
31	178
31	111
31	104
31	124
31	109
31	161
31	118
31	112
31	167
31	175
31	195
32	108
32	111
32	190
32	139
32	130
32	149
32	159
32	187
32	185
32	137
32	163
32	120
32	174
32	170
32	178
32	116
32	122
32	194
32	106
32	132
32	151
32	109
32	144
32	150
32	184
32	164
32	192
32	186
36	126
36	143
36	148
36	152
36	122
36	172
36	164
36	116
36	103
36	173
36	141
36	128
36	109
36	121
36	170
36	130
36	160
36	193
36	200
36	154
36	120
36	145
36	119
36	144
36	171
36	190
36	131
36	138
36	191
36	186
36	106
36	156
36	153
36	198
36	159
36	176
36	142
36	188
36	123
39	189
39	171
39	115
39	165
39	186
39	105
39	177
39	174
39	193
39	113
39	194
39	154
39	164
42	132
42	174
42	177
42	158
42	141
42	164
42	109
42	152
42	129
42	199
42	124
42	104
42	193
42	189
42	103
42	107
42	125
42	142
42	147
42	195
42	188
42	149
42	184
42	190
42	171
42	196
42	198
42	150
42	121
42	123
42	140
42	136
42	176
42	169
42	110
42	106
42	175
42	179
42	138
34	190
34	185
34	109
34	136
34	108
34	173
34	134
34	140
34	195
34	184
34	158
34	198
34	123
37	115
37	152
37	120
37	143
37	193
37	155
37	194
37	130
37	132
37	153
37	102
37	162
37	117
37	189
37	181
37	198
37	172
37	111
37	190
37	191
37	200
37	109
37	133
37	169
37	171
37	164
37	136
37	106
37	176
40	134
40	135
40	184
40	125
40	147
40	130
40	181
40	176
40	129
40	165
40	173
40	163
40	112
40	155
40	160
40	137
40	114
40	151
40	104
40	171
40	105
40	193
40	167
40	131
40	200
40	113
40	111
40	185
40	145
40	189
40	198
40	195
40	175
40	150
40	118
40	101
35	158
35	107
35	181
35	194
35	187
35	174
35	160
35	167
35	145
35	146
35	172
35	101
35	192
35	147
35	161
35	139
35	168
35	151
35	169
35	128
35	104
35	127
35	135
35	182
35	149
35	184
35	125
35	143
35	102
35	191
35	162
35	121
35	109
35	163
35	154
35	130
35	103
35	150
35	170
35	148
38	152
38	189
38	138
38	117
38	115
38	123
38	121
38	174
38	148
38	120
38	116
38	185
38	114
38	143
38	183
38	142
41	140
41	123
41	116
41	184
41	157
41	108
41	188
41	142
41	107
41	173
41	192
41	169
41	183
41	124
41	176
41	199
41	178
41	174
41	164
41	194
41	150
41	158
41	200
41	185
41	113
43	138
43	197
43	147
43	174
43	135
43	199
43	149
43	120
43	106
43	161
43	134
43	200
43	101
43	121
43	181
43	108
43	186
43	182
43	110
43	165
44	190
44	133
44	165
44	159
44	145
44	164
44	198
44	144
44	187
44	125
44	140
44	146
44	105
44	185
45	160
45	183
45	184
45	189
45	102
45	195
45	101
45	116
45	156
45	153
45	143
45	151
45	168
45	174
45	122
45	110
45	135
45	179
45	152
45	164
45	149
45	166
45	120
45	167
45	175
47	138
47	190
47	115
47	180
47	149
47	145
47	123
47	113
47	144
47	175
47	187
47	119
47	120
47	165
47	136
46	174
46	164
46	189
46	188
46	196
46	193
46	155
46	145
46	157
46	138
46	139
46	107
46	175
46	178
46	186
46	132
46	172
46	185
46	130
46	111
46	167
46	141
46	194
46	154
46	124
46	134
46	195
46	151
46	177
46	184
46	159
46	143
46	116
46	131
46	190
46	126
46	176
46	183
49	129
49	131
49	183
49	113
49	167
49	165
49	123
49	188
49	178
49	195
49	140
49	199
49	108
49	118
49	148
49	162
49	121
49	191
50	194
50	152
50	200
50	113
50	110
50	122
50	196
50	125
50	164
50	129
50	175
50	149
50	107
50	197
50	116
50	103
50	163
50	150
50	141
50	114
50	134
50	142
50	119
50	128
50	169
48	172
48	104
48	112
48	189
48	140
48	117
48	167
48	121
48	135
48	128
48	137
48	122
48	143
48	163
48	199
48	139
48	160
48	187
48	126
48	131
48	161
48	188
48	191
48	165
48	129
48	107
48	181
48	119
48	176
48	158
51	120
51	125
51	114
51	105
51	166
51	127
51	147
51	150
51	185
51	128
51	111
51	106
51	189
51	193
51	199
51	136
51	184
51	152
51	177
51	141
51	122
51	117
51	153
52	147
52	134
52	115
52	146
52	171
52	197
52	173
52	144
52	137
52	168
52	139
52	104
52	191
52	175
52	164
52	130
52	174
52	186
52	154
52	149
52	133
52	187
52	190
52	129
52	141
52	136
52	106
52	128
53	159
53	170
53	181
53	188
53	121
53	156
53	104
53	179
53	161
53	190
53	139
53	129
53	199
53	144
53	169
53	130
53	176
53	163
53	183
53	153
53	200
53	194
53	157
53	133
53	164
53	111
53	141
54	193
54	152
54	169
54	200
54	113
54	199
54	104
54	145
54	111
54	173
54	176
54	134
54	167
54	139
54	129
54	197
54	110
54	198
54	195
54	158
54	166
54	182
54	183
54	122
54	156
54	160
54	115
54	168
54	120
54	190
54	144
54	171
54	125
54	103
54	121
54	151
54	164
54	185
54	150
54	114
55	160
55	174
55	115
55	133
55	129
55	144
55	176
55	166
55	151
55	116
55	112
55	159
55	140
55	114
55	101
55	122
55	154
55	167
55	165
55	188
56	152
56	168
56	101
56	153
56	182
56	157
56	183
56	161
56	197
56	123
56	103
56	137
56	147
56	156
56	177
56	134
56	190
56	199
57	170
57	198
57	141
57	130
57	133
57	134
57	148
57	110
57	160
57	107
57	109
57	158
57	179
57	187
57	101
57	135
57	176
57	147
57	145
57	185
57	162
57	122
57	192
57	115
57	157
57	182
57	152
57	119
57	117
57	106
57	195
57	177
57	139
57	138
57	128
57	121
57	189
57	151
57	143
58	110
58	200
58	114
58	193
58	152
58	180
58	199
58	143
58	103
58	102
58	168
58	136
58	116
58	120
58	164
58	147
58	124
58	139
58	198
58	165
58	196
58	151
58	122
58	150
58	182
58	160
58	101
59	120
59	184
59	103
59	160
59	194
59	144
59	185
59	182
59	143
59	152
59	172
59	186
59	159
59	127
59	193
59	192
59	142
59	135
59	175
59	140
59	108
59	102
59	153
59	145
60	191
60	151
60	128
60	116
60	102
60	159
60	131
60	173
60	117
60	172
60	119
60	183
60	166
60	134
61	177
61	109
61	163
61	108
61	196
61	138
61	103
61	105
61	117
61	174
61	145
61	101
61	164
61	115
61	113
61	131
61	147
61	197
61	116
61	150
61	107
61	120
61	142
61	178
61	184
61	155
61	194
61	179
61	193
61	123
61	188
61	118
61	102
61	186
61	104
61	148
61	112
61	189
61	151
62	172
62	104
62	147
62	137
62	178
62	135
62	156
62	165
62	175
62	132
62	159
62	164
63	149
63	131
63	119
63	198
63	148
63	138
63	155
63	172
63	108
63	118
63	139
63	187
63	107
63	156
63	110
63	197
63	135
63	109
63	134
63	175
63	161
63	115
63	157
63	130
63	111
63	160
63	151
63	101
63	171
63	122
63	106
63	120
63	141
63	163
63	145
63	140
64	154
64	181
64	155
64	188
64	103
64	107
64	118
64	119
64	102
64	133
64	129
64	173
64	104
64	200
64	143
64	183
64	180
64	197
64	116
64	187
64	139
64	184
64	144
64	127
64	182
64	142
65	198
65	126
65	110
65	169
65	188
65	172
65	104
65	184
65	147
65	149
65	114
65	136
65	148
65	119
65	106
65	164
65	130
65	165
66	153
66	134
66	137
66	172
66	101
66	164
66	185
66	183
66	103
66	138
66	135
66	187
66	148
66	116
66	124
66	146
66	180
66	194
66	143
66	126
66	162
66	125
66	163
66	193
66	189
66	128
66	152
66	179
66	113
67	199
67	162
67	195
67	114
67	152
67	118
67	105
67	151
67	191
67	181
67	128
67	115
67	169
67	159
67	143
67	167
67	170
67	175
67	155
67	131
67	194
67	139
67	197
67	138
67	178
67	130
67	190
67	117
67	122
67	141
67	102
67	106
67	187
67	158
67	176
68	192
68	115
68	176
68	200
68	191
68	188
68	109
68	113
68	138
68	119
68	193
68	106
68	170
68	183
68	105
68	132
68	118
68	120
68	116
68	140
68	133
68	196
68	187
68	135
68	152
68	153
68	197
68	195
68	184
68	147
68	107
69	190
69	127
69	162
69	185
69	198
69	183
69	153
69	136
69	107
69	148
69	133
69	158
69	179
69	170
69	113
69	199
69	121
69	124
69	132
69	102
69	191
69	105
69	115
69	117
69	151
69	172
69	101
69	104
69	169
69	152
69	182
69	118
69	139
69	110
69	171
69	131
71	136
71	110
71	167
71	199
71	122
71	169
71	135
71	129
71	133
71	137
70	172
70	170
70	185
70	191
70	164
70	189
70	174
70	144
70	145
70	123
70	179
70	156
70	192
70	195
70	122
70	194
70	180
70	149
70	112
70	139
70	173
70	125
70	140
70	200
70	102
70	158
70	118
70	135
70	131
70	138
70	190
70	176
70	106
72	175
72	168
72	153
72	155
72	117
72	128
72	114
72	125
72	145
72	110
72	166
72	176
72	183
72	132
72	162
72	161
72	111
73	194
73	119
73	156
73	197
73	160
73	141
73	169
73	187
73	168
73	140
73	185
73	150
73	173
73	180
74	181
74	191
74	131
74	177
74	161
74	160
74	193
74	120
74	112
74	118
74	122
74	165
74	133
75	144
75	121
75	172
75	138
75	126
75	193
75	168
75	195
75	187
75	154
75	145
75	182
75	130
75	150
75	196
75	161
75	152
75	153
75	157
75	134
75	174
75	129
75	184
75	180
75	190
75	197
75	104
75	200
75	107
75	164
75	169
75	163
75	119
75	135
75	158
75	140
79	101
79	146
79	119
79	171
79	142
79	114
79	199
79	130
79	127
79	177
79	104
78	130
78	200
78	124
78	155
78	104
78	133
78	166
78	161
78	165
78	126
78	131
78	138
78	176
78	134
78	158
78	147
78	132
78	196
78	116
78	156
78	153
78	112
78	167
78	186
78	148
78	187
78	184
78	197
78	136
78	129
78	170
78	120
78	178
80	122
80	153
80	186
80	146
80	105
80	174
80	117
80	159
80	136
80	177
80	150
80	131
80	192
80	132
80	171
80	155
80	158
80	166
80	134
80	197
80	145
80	163
80	173
80	179
80	106
80	104
80	119
80	183
80	168
80	191
80	110
77	160
77	146
77	191
77	113
77	192
77	143
77	182
77	198
77	129
77	147
77	189
77	171
77	169
77	122
77	145
77	199
77	139
77	119
77	155
81	200
81	132
81	163
81	116
81	162
81	143
81	117
81	177
81	134
81	158
81	106
81	155
81	189
81	146
81	190
81	186
81	171
81	175
81	170
81	153
81	105
81	136
76	129
76	113
76	192
76	153
76	105
76	133
76	189
76	101
76	196
76	167
76	168
76	114
76	169
76	138
76	121
76	150
76	162
76	181
76	146
76	184
76	155
76	171
82	113
82	114
82	142
82	109
82	133
82	110
82	181
82	141
82	183
82	151
82	149
82	172
82	147
82	112
82	146
82	200
82	115
82	120
82	173
82	118
82	135
82	188
82	125
82	192
82	175
82	152
82	143
82	186
82	193
82	103
83	132
83	115
83	102
83	176
83	190
83	146
83	171
83	197
83	142
83	125
83	179
83	178
83	120
83	118
83	187
83	122
83	124
83	162
83	189
84	165
84	175
84	144
84	186
84	120
84	168
84	128
84	102
84	143
84	139
84	146
84	161
84	122
84	130
84	185
84	111
84	147
84	129
84	184
84	148
87	171
87	192
87	166
87	187
87	138
87	157
87	126
87	130
87	132
87	152
87	194
87	177
86	119
86	152
86	193
86	183
86	180
86	199
86	189
86	161
86	103
86	171
86	158
86	111
86	163
86	191
86	114
86	162
86	138
86	115
86	121
86	124
86	186
86	173
86	177
85	152
85	123
85	200
85	108
85	122
85	142
85	163
85	161
85	159
85	186
85	191
85	145
85	103
85	151
85	156
85	117
85	150
88	165
88	142
88	170
88	101
88	118
88	186
88	153
88	151
88	152
88	191
88	190
88	173
88	114
88	154
88	130
88	136
88	196
88	178
88	160
88	121
88	126
88	137
88	141
88	150
88	106
88	179
88	102
88	110
88	180
88	135
88	128
88	157
88	131
88	113
88	103
88	176
88	195
88	194
88	169
88	123
89	116
89	174
89	114
89	120
89	112
89	138
89	146
89	164
89	194
89	155
89	175
89	185
89	102
89	188
89	191
89	196
89	127
89	123
89	140
89	186
89	132
90	199
90	168
90	140
90	132
90	107
90	108
90	157
90	188
90	197
90	155
90	119
90	133
90	116
90	179
90	137
90	106
95	111
95	178
95	156
95	162
95	140
95	143
95	175
95	154
95	189
95	191
95	169
95	108
95	177
95	144
95	198
95	138
95	132
95	122
95	165
95	180
95	146
95	179
95	137
95	160
95	159
95	161
95	171
95	142
95	195
95	121
95	200
91	157
91	148
91	182
91	101
91	138
91	136
91	175
91	110
91	147
91	105
91	114
91	156
91	173
91	120
91	195
91	130
91	154
91	121
91	177
91	165
91	124
91	135
91	170
91	123
91	112
91	153
91	161
91	119
91	169
91	113
91	194
91	184
93	136
93	104
93	135
93	166
93	137
93	183
93	157
93	148
93	192
93	124
93	102
93	143
93	127
93	172
93	121
93	141
93	178
93	155
93	133
93	173
93	151
93	123
93	113
93	139
93	177
93	179
93	200
92	181
92	177
92	190
92	142
92	124
92	134
92	126
92	129
92	105
92	173
92	136
92	170
92	162
92	106
92	161
92	179
92	156
92	154
92	144
92	135
92	160
92	186
92	113
92	191
94	198
94	168
94	170
94	174
94	108
94	199
94	151
94	180
94	101
94	183
94	166
94	158
94	193
96	168
96	190
96	118
96	133
96	141
96	151
96	102
96	159
96	143
96	108
96	180
96	167
96	144
96	103
96	121
96	106
96	165
96	136
96	114
96	162
96	179
96	195
96	137
97	139
97	160
97	156
97	145
97	171
97	161
97	165
97	105
97	198
97	183
97	131
97	136
97	151
97	188
97	195
97	175
97	196
97	164
97	140
97	110
97	152
97	199
97	191
100	172
100	194
100	149
100	153
100	144
100	162
100	151
100	185
100	123
100	147
100	113
100	140
100	179
100	157
100	111
100	103
100	107
100	120
100	191
100	165
100	138
100	137
98	166
98	191
98	113
98	164
98	169
98	109
98	183
98	102
98	176
98	131
98	157
98	143
98	189
98	147
98	179
98	134
98	125
99	182
99	186
99	105
99	109
99	106
99	189
99	193
99	165
99	187
99	140
99	116
99	198
99	113
99	173
99	199
99	154
99	178
99	166
99	163
99	124
99	188
99	195
99	174
99	120
101	181
101	172
101	164
101	166
101	189
101	186
101	162
101	153
101	173
101	139
101	174
101	158
101	169
101	183
101	149
101	130
101	115
101	113
101	188
101	200
101	135
101	103
101	125
101	118
101	111
101	157
101	175
101	152
101	141
101	143
101	123
101	137
101	109
102	159
102	130
102	115
102	194
102	106
102	113
102	171
102	145
102	125
102	178
102	164
102	105
102	179
102	142
102	189
102	200
102	144
102	128
102	102
102	190
103	169
103	167
103	161
103	110
103	140
103	116
103	126
103	112
103	166
103	102
103	135
103	108
103	111
103	138
103	193
103	171
104	119
104	181
104	147
104	189
104	158
104	162
104	118
104	153
104	161
104	170
104	124
104	109
104	185
104	197
104	150
104	154
104	148
104	114
104	187
104	116
104	180
104	111
104	145
104	200
105	110
105	162
105	125
105	157
105	119
105	143
105	187
105	164
105	131
105	168
105	147
105	108
105	152
105	184
105	167
105	140
105	185
105	116
105	170
105	179
105	130
105	190
105	189
105	176
105	128
105	181
105	198
105	123
105	127
105	149
105	159
105	111
105	194
106	124
106	175
106	129
106	134
106	142
106	174
106	188
106	183
106	106
106	198
106	177
106	151
106	143
106	115
106	166
106	133
106	157
106	169
106	161
106	158
107	114
107	138
107	102
107	142
107	191
107	150
107	143
107	105
107	182
107	120
107	179
107	197
107	109
107	104
107	129
107	159
107	164
107	152
107	136
107	183
107	115
107	176
107	180
107	108
107	132
107	153
107	181
107	160
107	101
107	172
107	118
107	166
107	107
107	198
108	160
108	134
108	107
108	120
108	168
108	155
108	190
108	113
108	167
108	145
108	132
108	140
108	196
108	156
108	171
108	125
108	200
108	158
108	103
108	150
108	184
108	111
109	103
109	132
109	168
109	188
109	157
109	155
109	143
109	191
109	117
109	197
109	196
109	136
109	150
109	115
109	158
109	106
109	177
109	166
109	198
109	189
109	141
109	108
109	135
111	200
111	115
111	167
111	164
111	165
111	148
111	131
111	170
111	197
111	125
111	185
111	162
111	189
111	196
111	137
111	126
111	180
111	187
111	150
111	175
111	111
111	102
111	166
111	114
111	186
111	130
111	155
111	198
111	183
111	119
111	168
111	173
111	121
110	174
110	133
110	101
110	125
110	196
110	126
110	117
110	166
110	161
110	158
110	164
110	189
110	186
110	178
110	147
110	170
110	121
112	117
112	183
112	169
112	104
112	154
112	175
112	114
112	103
112	146
112	107
112	181
112	174
112	120
114	145
114	154
114	183
114	170
114	191
114	167
114	113
114	153
114	168
114	188
114	181
114	143
114	141
114	146
114	189
114	175
113	166
113	130
113	152
113	174
113	123
113	168
113	169
113	124
113	138
113	114
113	142
113	157
113	117
113	188
113	122
113	198
113	187
113	183
113	164
113	145
113	121
113	120
113	136
113	179
113	180
113	112
113	102
113	111
117	116
117	175
117	157
117	170
117	144
117	174
117	186
117	109
117	121
117	101
117	199
117	183
117	146
117	182
117	145
117	188
117	160
117	140
116	177
116	117
116	111
116	138
116	139
116	140
116	175
116	115
116	168
116	145
116	161
116	104
116	164
116	124
116	114
116	167
116	176
116	155
116	134
116	105
116	108
116	187
116	172
116	122
116	166
116	182
116	130
116	186
116	149
116	135
116	196
116	194
115	178
115	118
115	141
115	154
115	101
115	129
115	115
115	153
115	149
115	172
115	144
115	192
115	181
115	168
115	122
115	199
115	186
115	164
115	114
118	176
118	198
118	150
118	131
118	148
118	153
118	157
118	184
118	111
118	147
118	166
118	182
120	136
120	162
120	116
120	115
120	199
120	151
120	129
120	124
120	141
120	159
120	177
120	182
120	193
120	154
120	109
120	148
120	200
120	121
120	158
120	178
120	195
119	200
119	119
119	169
119	150
119	153
119	108
119	102
119	105
119	109
119	128
119	196
119	113
119	141
119	185
119	167
119	190
121	191
121	120
121	128
121	166
121	184
121	142
121	126
121	148
121	145
121	200
121	159
121	156
121	173
121	180
123	154
123	127
123	187
123	105
123	151
123	102
123	197
123	125
123	175
123	170
123	140
123	133
123	116
123	150
123	146
123	121
123	191
123	185
123	136
123	130
123	179
123	122
123	196
123	137
123	142
123	115
123	114
123	184
123	162
123	165
123	190
123	148
123	188
123	124
122	136
122	161
122	195
122	191
122	129
122	108
122	125
122	186
122	179
122	104
122	123
122	126
122	147
122	138
122	111
122	196
122	103
122	180
122	187
122	198
122	140
122	124
122	110
122	199
124	162
124	160
124	128
124	169
124	176
124	104
124	194
124	189
124	108
124	135
124	188
124	191
124	136
124	103
124	137
124	153
124	182
124	157
124	110
124	170
124	181
124	185
124	140
124	159
124	180
124	111
124	158
124	134
124	163
124	183
125	198
125	167
125	161
125	184
125	120
125	152
125	104
125	192
125	125
125	139
125	158
125	127
125	123
125	110
125	189
125	101
125	136
125	122
125	138
125	147
125	187
126	107
126	156
126	135
126	108
126	110
126	193
126	159
126	181
126	195
126	143
126	155
126	136
126	192
126	151
126	131
126	113
126	161
126	182
126	164
127	196
127	184
127	140
127	155
127	153
127	166
127	185
127	132
127	131
127	125
127	122
127	129
127	195
127	198
127	186
127	178
127	128
127	158
127	115
127	108
127	114
127	101
127	197
127	163
127	169
127	102
127	181
127	174
127	183
127	194
127	120
127	118
127	144
127	200
128	197
128	101
128	179
128	165
128	174
128	160
128	190
128	152
128	147
128	167
128	161
128	176
128	128
128	123
128	158
128	142
128	133
128	131
128	124
129	146
129	187
129	186
129	157
129	142
129	140
129	154
129	191
129	107
129	173
129	159
129	138
129	131
129	197
129	158
129	135
129	103
129	179
129	175
129	156
129	182
129	102
129	192
129	127
129	106
129	144
129	130
130	117
130	101
130	139
130	130
130	196
130	186
130	146
130	174
130	142
130	187
130	175
130	200
130	170
130	125
130	116
130	123
130	161
130	136
130	114
130	191
130	145
130	182
130	156
130	115
130	164
130	118
130	154
130	137
130	103
130	144
130	131
130	112
130	126
130	159
130	172
130	188
130	163
130	102
130	195
130	138
132	189
132	127
132	190
132	112
132	110
132	162
132	128
132	148
132	165
132	101
132	194
132	163
132	104
132	138
132	158
132	146
132	168
132	185
132	121
132	171
132	149
132	183
131	190
131	163
131	113
131	200
131	104
131	125
131	177
131	188
131	154
131	141
131	112
131	127
131	182
131	189
131	105
131	108
131	142
131	168
131	180
133	118
133	164
133	121
133	107
133	193
133	141
133	114
133	154
133	189
133	120
133	149
133	102
133	113
133	194
133	101
133	122
134	148
134	164
134	136
134	134
134	123
134	122
134	192
134	154
134	139
134	152
134	178
134	113
134	149
134	156
134	163
135	189
135	137
135	113
135	156
135	104
135	124
135	194
135	166
135	174
135	134
135	186
135	142
135	108
135	114
135	111
135	170
135	130
135	161
135	167
135	101
135	172
135	148
136	149
136	153
136	119
136	155
136	116
136	159
136	192
136	147
136	139
136	188
136	115
136	154
136	156
136	150
136	158
137	144
137	141
137	186
137	196
137	148
137	179
137	191
137	164
137	187
137	134
137	140
137	147
137	123
137	162
137	149
137	118
137	132
137	182
137	117
137	142
137	192
137	128
137	152
137	193
137	131
137	135
137	163
137	172
137	150
138	150
138	172
138	129
138	140
138	145
138	186
138	110
138	176
138	122
138	117
138	191
138	153
138	119
138	164
138	158
138	162
138	109
138	160
138	156
138	104
138	161
138	195
138	107
138	194
138	183
138	134
138	159
138	169
141	162
141	190
141	152
141	185
141	175
141	127
141	135
141	133
141	179
141	164
141	166
141	182
141	128
141	115
141	106
141	108
142	114
142	123
142	163
142	120
142	167
142	162
142	181
142	121
142	131
142	159
142	196
142	170
142	106
142	164
142	144
142	115
142	134
142	151
142	194
142	149
142	143
142	112
142	155
142	130
142	148
142	146
142	113
142	150
142	135
142	192
142	156
142	178
142	185
142	180
142	198
142	117
142	136
142	137
139	136
139	110
139	150
139	163
139	147
139	194
139	159
139	173
139	156
139	154
139	116
139	121
139	171
139	180
139	102
139	187
139	168
139	162
139	178
139	135
139	126
139	157
139	169
139	105
139	142
139	114
139	101
139	148
143	186
143	182
143	196
143	163
143	168
143	172
143	109
143	118
143	198
143	192
143	189
143	145
143	155
143	184
143	173
143	197
143	136
143	142
143	161
143	130
143	115
143	180
143	150
143	174
143	122
143	121
143	191
143	134
143	159
143	146
143	127
143	137
143	167
143	162
143	149
140	198
140	158
140	122
140	175
140	107
140	190
140	180
140	178
140	167
140	123
140	195
140	150
140	145
140	114
140	134
140	168
140	163
140	166
140	182
146	175
146	157
146	153
146	190
146	105
146	165
146	187
146	127
146	111
146	158
146	106
146	195
146	169
146	107
146	140
146	166
146	101
146	152
146	110
146	161
146	135
146	163
146	136
146	137
146	132
146	186
146	176
146	123
146	131
146	194
146	156
145	195
145	156
145	101
145	137
145	128
145	196
145	194
145	105
145	183
145	185
145	151
145	147
145	159
145	108
145	193
145	163
145	140
145	200
145	198
145	124
145	176
144	187
144	124
144	132
144	122
144	146
144	115
144	111
144	172
144	170
144	162
150	161
150	155
150	138
150	107
150	141
150	200
150	165
150	120
150	143
150	190
150	140
150	153
150	130
150	112
150	196
150	114
150	102
150	136
150	191
150	156
150	135
150	115
150	173
150	121
150	104
148	194
148	116
148	140
148	173
148	179
148	187
148	129
148	176
148	189
148	121
148	183
148	130
148	166
148	108
148	126
148	111
148	178
148	127
148	160
148	123
148	164
148	193
148	197
148	190
148	186
148	114
148	133
148	110
148	103
148	131
148	118
148	122
148	157
148	180
148	102
148	143
148	188
148	184
148	177
147	167
147	106
147	145
147	165
147	111
147	190
147	170
147	195
147	159
147	147
147	142
147	148
147	114
147	189
147	144
149	130
149	119
149	172
149	182
149	115
149	188
149	102
149	160
149	116
149	140
149	114
151	128
151	193
151	130
151	137
151	113
151	115
151	183
151	151
151	152
151	133
151	164
151	169
151	124
151	198
152	188
152	111
152	177
152	156
152	124
152	174
152	122
152	140
152	149
152	105
152	129
152	148
152	165
152	164
152	178
152	184
152	128
152	171
152	173
152	127
153	148
153	131
153	106
153	153
153	101
153	135
153	103
153	150
153	125
153	138
153	117
153	133
154	157
154	167
154	103
154	166
154	154
154	161
154	193
154	168
154	144
154	173
154	181
154	175
154	196
154	104
154	156
154	126
154	122
154	189
155	171
155	177
155	178
155	148
155	114
155	144
155	113
155	185
155	111
155	191
155	193
156	140
156	149
156	173
156	179
156	166
156	160
156	195
156	159
156	169
156	182
156	125
156	109
156	101
156	134
156	143
156	120
156	151
156	189
156	197
156	186
156	111
156	164
156	193
157	117
157	102
157	192
157	161
157	111
157	104
157	136
157	106
157	177
157	145
157	132
157	172
157	134
157	200
157	114
157	116
157	128
157	176
157	178
157	173
157	112
157	196
157	144
157	174
157	101
157	187
157	125
157	151
157	160
157	186
157	130
157	113
157	110
157	141
157	194
157	168
157	159
157	127
157	155
157	118
158	147
158	161
158	156
158	111
158	191
158	115
158	166
158	125
158	169
158	113
158	188
158	173
158	108
158	138
158	112
158	159
158	185
158	175
158	200
158	154
158	168
158	102
158	183
158	131
158	146
158	135
158	151
158	150
158	140
158	122
158	165
159	152
159	133
159	150
159	111
159	195
159	131
159	192
159	142
159	119
159	161
159	167
159	165
159	129
159	189
159	191
159	159
159	196
159	112
159	124
159	102
159	126
159	155
159	170
159	154
159	172
159	132
159	139
159	149
159	198
160	129
160	180
160	150
160	168
160	110
160	154
160	163
160	123
160	148
160	167
160	106
160	141
160	192
160	105
160	152
160	122
160	135
160	186
160	124
160	149
160	177
160	155
160	103
160	132
160	199
160	101
160	133
160	185
160	131
160	151
160	197
160	169
160	125
160	120
160	176
160	127
160	162
160	178
160	183
161	149
161	160
161	175
161	154
161	161
161	118
161	185
161	134
161	103
161	172
161	169
161	130
161	148
161	108
161	135
161	196
161	142
161	101
161	200
161	107
161	171
161	189
161	183
161	104
161	116
161	129
161	163
161	132
161	147
161	191
161	123
161	179
161	145
161	164
161	131
161	138
161	190
162	152
162	157
162	146
162	104
162	110
162	177
162	120
162	123
162	115
162	116
162	185
162	114
162	156
162	131
162	111
162	124
162	129
162	194
162	130
162	160
162	125
162	165
162	118
162	190
162	164
162	159
162	117
162	102
162	179
162	167
162	132
164	182
164	194
164	188
164	161
164	114
164	160
164	138
164	145
164	112
164	172
164	146
164	130
164	137
164	101
164	199
164	163
164	197
165	187
165	141
165	175
165	122
165	191
165	106
165	170
165	113
165	186
165	116
165	173
165	159
165	139
165	134
165	131
163	164
163	159
163	194
163	174
163	138
163	143
163	157
163	181
163	170
163	134
163	189
163	188
163	139
163	192
163	121
163	185
163	115
163	149
163	127
163	191
163	103
163	158
163	112
163	129
163	105
163	183
163	146
163	128
163	160
163	119
163	198
163	199
163	180
163	156
163	200
163	124
163	171
166	128
166	124
166	117
166	172
166	162
166	109
166	150
166	187
166	163
166	119
166	120
166	174
166	145
166	193
166	103
166	137
166	194
166	168
166	184
166	167
166	178
166	200
166	169
166	175
166	107
166	180
166	183
166	106
166	121
166	154
166	197
166	148
166	191
167	172
167	111
167	142
167	127
167	197
167	190
167	134
167	151
167	165
167	108
167	200
167	120
167	179
167	183
167	169
167	109
167	110
167	198
167	195
167	102
167	177
168	158
168	120
168	127
168	159
168	152
168	173
168	154
168	164
168	177
168	138
168	115
168	125
168	128
168	137
168	194
168	193
168	142
168	165
168	106
168	179
168	174
168	141
168	197
168	161
168	144
168	122
168	136
168	107
168	156
168	185
168	103
168	116
168	102
168	187
168	121
169	151
169	143
169	123
169	111
169	173
169	159
169	110
169	197
169	156
169	198
169	135
169	182
169	116
169	112
169	108
169	194
169	171
169	133
169	168
169	129
169	158
169	176
169	152
169	181
169	184
169	118
169	187
169	144
169	179
169	101
170	171
170	140
170	121
170	188
170	141
170	132
170	150
170	113
170	133
170	114
170	187
170	189
170	186
171	178
171	166
171	198
171	171
171	141
171	143
171	127
171	133
171	123
171	134
171	122
171	195
171	136
171	113
171	111
171	170
171	184
171	117
171	108
171	125
171	181
171	107
171	140
172	200
172	183
172	145
172	125
172	121
172	192
172	106
172	138
172	115
172	152
172	172
172	156
172	181
172	134
172	120
172	128
172	194
172	178
172	187
172	151
172	103
172	131
172	105
172	159
172	127
172	195
172	185
172	108
172	107
172	163
172	126
175	182
175	126
175	146
175	143
175	168
175	147
175	185
175	157
175	162
175	144
175	178
175	176
175	119
175	142
175	118
175	179
175	129
175	177
175	155
175	187
175	197
175	190
175	111
175	196
175	105
175	115
175	169
175	125
175	193
175	171
175	159
175	158
175	180
174	115
174	161
174	180
174	124
174	140
174	112
174	173
174	181
174	168
174	114
174	149
174	109
174	190
174	110
174	119
174	188
173	147
173	169
173	133
173	154
173	181
173	192
173	105
173	128
173	134
173	121
173	113
173	177
173	116
173	103
173	196
173	188
173	160
173	186
173	141
173	135
173	111
173	164
173	182
173	171
173	137
173	194
173	108
176	174
176	121
176	176
176	150
176	180
176	179
176	122
176	111
176	133
176	200
176	171
176	162
176	138
176	164
176	147
176	126
176	144
176	178
176	128
176	175
176	158
176	177
176	167
176	124
176	183
176	117
176	105
176	149
176	152
176	104
176	187
176	181
176	157
176	186
176	115
176	184
176	135
176	191
179	138
179	103
179	107
179	152
179	133
179	101
179	160
179	112
179	102
179	188
179	184
179	123
179	195
179	165
177	110
177	143
177	152
177	146
177	194
177	177
177	105
177	156
177	197
177	147
177	181
177	108
177	122
177	183
177	106
177	149
177	113
177	123
177	141
177	157
177	129
178	146
178	163
178	123
178	118
178	181
178	199
178	140
178	155
178	148
178	183
178	189
178	129
178	124
178	176
178	187
178	106
178	161
178	162
178	137
178	142
178	152
178	174
178	190
178	138
178	103
178	135
178	159
178	119
178	200
178	136
178	120
178	156
178	151
178	117
180	188
180	127
180	113
180	199
180	197
180	112
180	153
180	167
180	172
180	141
180	189
180	150
181	176
181	113
181	110
181	142
181	139
181	135
181	181
181	131
181	153
181	160
181	140
181	175
181	178
181	187
183	188
183	125
183	160
183	109
183	182
183	140
183	171
183	172
183	186
183	146
183	139
183	169
183	119
183	143
183	177
183	162
183	193
183	108
183	127
183	175
183	156
182	136
182	103
182	151
182	186
182	129
182	116
182	154
182	172
182	113
182	157
182	110
182	144
184	175
184	179
184	123
184	137
184	161
184	107
184	122
184	187
184	180
184	192
184	170
184	144
184	126
184	185
184	138
184	183
184	102
184	191
184	134
184	176
184	119
184	163
184	166
184	149
184	150
184	117
185	164
185	186
185	136
185	173
185	123
185	117
185	180
185	128
185	109
185	103
185	195
185	181
186	199
186	118
186	160
186	125
186	145
186	180
186	132
186	182
186	122
186	135
186	165
186	157
186	116
186	152
186	192
186	130
186	200
186	170
186	121
186	148
187	159
187	103
187	178
187	112
187	110
187	190
187	118
187	183
187	119
187	170
187	175
187	141
187	105
187	107
187	143
187	186
187	121
187	157
187	199
187	140
187	150
187	106
187	144
187	160
187	194
187	153
187	129
187	193
187	134
187	181
187	158
187	111
188	104
188	175
188	192
188	117
188	172
188	167
188	130
188	162
188	196
188	116
188	121
188	133
188	141
188	138
188	200
188	118
188	182
188	135
188	187
188	178
188	165
188	150
188	184
188	166
188	164
188	107
188	132
188	111
188	171
188	131
188	176
195	184
195	196
195	159
195	168
195	166
195	183
195	167
195	147
195	141
195	172
195	109
195	189
195	144
195	111
195	119
195	126
195	188
195	193
195	194
195	157
195	177
195	185
195	158
195	138
195	128
195	155
195	113
195	181
195	161
195	170
195	182
195	121
195	145
195	179
195	135
195	151
195	132
195	116
199	180
199	156
199	137
199	162
199	193
199	195
199	171
199	120
199	142
199	145
199	114
199	154
199	186
199	144
199	200
190	145
190	168
190	166
190	187
190	101
190	116
190	106
190	186
190	178
190	172
190	198
190	113
190	191
190	181
190	165
190	161
190	164
190	107
190	152
190	150
190	156
190	136
193	187
193	137
193	140
193	102
193	178
193	107
193	105
193	111
193	183
193	175
193	150
193	116
193	110
196	105
196	129
196	131
196	167
196	187
196	132
196	182
196	108
196	135
196	190
196	142
196	123
196	168
196	179
196	155
196	124
196	183
196	184
196	104
196	111
196	137
196	163
196	138
196	148
198	197
198	109
198	158
198	177
198	105
198	175
198	194
198	157
198	134
198	168
198	182
198	118
198	135
198	136
198	189
198	143
198	196
198	120
198	150
198	166
198	164
198	181
198	178
198	152
198	190
198	185
198	113
198	144
198	162
198	123
198	122
198	193
198	138
198	154
198	127
198	111
198	180
192	191
192	140
192	132
192	157
192	197
192	136
192	186
192	130
192	103
192	183
192	161
192	124
192	190
192	151
192	145
192	176
192	131
192	178
192	106
192	108
192	134
192	109
192	171
192	170
192	154
192	133
192	169
194	153
194	161
194	136
194	170
194	126
194	178
194	103
194	116
194	158
194	104
197	154
197	129
197	101
197	159
197	178
197	185
197	187
197	147
197	144
197	137
197	197
197	182
197	150
197	108
197	165
197	189
197	155
197	148
197	142
197	173
197	110
200	163
200	161
200	130
200	135
200	196
200	142
200	181
200	138
200	140
200	174
200	149
200	144
200	125
200	156
200	195
200	175
200	197
200	153
200	110
200	194
200	114
200	102
200	177
200	105
200	170
200	169
200	178
189	122
189	105
189	116
189	155
189	175
189	188
189	137
189	156
189	139
189	172
189	168
189	198
189	186
189	182
189	161
189	193
189	191
189	164
189	131
189	199
189	120
189	115
189	179
189	187
189	148
189	109
189	101
189	110
189	111
189	192
189	189
189	173
189	146
189	159
189	197
189	145
189	163
189	113
189	143
189	184
191	122
191	138
191	169
191	107
191	139
191	101
191	104
191	123
191	108
191	159
191	177
191	180
191	172
191	105
191	140
191	128
191	146
191	113
191	168
191	152
191	171
191	136
191	144
191	196
191	103
191	132
191	126
191	102
191	112
191	197
191	116
191	163
191	130
191	165
191	175
191	185
191	119
191	189
191	145
191	127
\.


--
-- Data for Name: School_Infrastructure; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."School_Infrastructure" ("PK_Infrastructure", "PK_School") FROM stdin;
5	1
8	1
2	1
5	2
2	2
4	2
6	2
5	3
9	3
10	3
2	3
8	3
4	3
1	3
4	4
7	4
10	4
3	5
5	5
1	5
6	5
2	5
8	6
5	6
7	6
10	6
1	6
6	7
5	7
9	7
10	7
8	7
3	7
3	8
9	8
6	8
8	8
1	8
5	8
8	9
4	9
5	9
1	9
3	9
4	10
10	10
7	10
6	10
9	10
1	10
6	11
3	11
4	11
5	11
2	11
9	11
8	11
10	11
8	12
1	12
4	12
2	12
7	12
9	12
10	12
2	13
5	13
7	13
10	13
4	13
9	13
3	13
9	14
10	14
4	14
3	14
2	14
7	14
6	16
10	16
4	16
9	16
2	16
7	15
8	15
9	15
10	15
2	15
6	15
4	15
5	15
5	17
4	17
3	17
7	18
9	18
5	18
1	18
4	18
8	18
7	19
2	19
5	19
9	19
3	19
1	19
8	19
5	20
10	20
3	20
9	20
7	21
8	21
5	21
9	21
7	22
10	22
9	22
3	22
6	22
2	22
6	24
8	24
5	24
4	24
1	24
10	24
8	23
6	23
1	23
6	25
9	25
8	25
5	25
3	25
4	25
1	25
4	26
2	26
7	26
3	26
5	26
9	26
6	26
10	26
8	27
10	27
6	27
1	27
9	27
8	28
3	28
1	28
7	29
3	29
1	29
1	30
9	30
2	30
7	33
10	33
3	33
6	33
2	33
2	31
4	31
7	31
8	31
3	31
10	31
1	31
1	32
9	32
5	32
7	32
3	32
8	32
3	36
7	36
4	36
5	36
5	39
6	39
3	39
4	39
1	39
9	39
7	39
8	39
4	42
5	42
9	42
10	42
1	42
2	34
10	34
5	34
7	34
3	34
8	34
4	34
9	34
3	37
4	37
10	37
8	40
9	40
6	40
3	40
7	40
2	40
10	40
1	40
1	35
7	35
10	35
2	35
9	35
3	35
9	38
6	38
3	38
2	38
8	38
10	38
7	38
3	41
7	41
9	41
8	41
7	43
1	43
10	43
3	43
8	43
2	43
6	43
4	43
7	44
10	44
2	44
1	44
2	45
7	45
3	45
9	45
1	45
5	45
8	45
4	47
7	47
3	47
2	47
1	47
9	47
5	47
8	47
1	46
6	46
3	46
9	46
5	46
8	46
8	49
6	49
7	49
2	49
9	49
10	49
3	49
5	49
8	50
10	50
3	50
7	48
3	48
5	48
9	48
1	48
7	51
10	51
2	51
8	51
5	51
7	52
3	52
5	52
10	53
5	53
4	53
7	53
2	53
6	53
9	53
3	54
10	54
4	54
7	54
8	54
6	54
9	54
10	55
7	55
8	55
3	55
2	55
4	55
1	56
3	56
6	56
7	57
3	57
1	57
2	57
9	57
10	57
3	58
1	58
2	58
10	58
6	58
4	58
5	59
10	59
1	59
4	59
9	59
8	59
7	59
2	59
1	60
9	60
6	60
7	60
2	60
4	60
5	60
8	61
10	61
7	61
2	61
6	61
9	62
8	62
5	62
4	62
1	62
2	63
9	63
8	63
5	64
7	64
6	64
3	64
2	65
8	65
9	65
6	65
1	66
7	66
4	66
6	67
9	67
7	67
8	67
5	67
7	68
4	68
9	68
2	68
8	68
3	68
5	68
1	68
7	69
5	69
6	69
10	69
4	69
10	71
3	71
7	71
4	71
9	71
4	70
1	70
10	70
5	70
6	70
3	70
7	70
2	72
10	72
5	72
1	72
7	72
7	73
3	73
4	73
1	73
5	73
10	73
9	74
7	74
4	74
6	74
10	74
5	74
2	75
9	75
8	75
5	79
4	79
8	79
9	79
10	79
6	79
8	78
3	78
2	78
8	80
6	80
2	80
5	80
10	80
9	80
1	80
4	80
1	77
6	77
10	77
9	77
7	77
4	77
8	77
5	81
3	81
4	81
8	81
9	81
6	81
2	81
1	81
7	76
5	76
3	76
9	76
2	76
4	76
6	76
8	76
3	82
10	82
4	82
1	82
5	82
5	83
2	83
8	83
9	83
10	84
6	84
5	84
9	84
2	84
3	84
5	87
7	87
9	87
2	87
6	87
5	86
10	86
9	86
6	86
4	86
3	85
9	85
7	85
5	85
6	88
9	88
5	88
1	89
7	89
9	89
3	89
9	90
3	90
10	90
8	95
9	95
2	95
1	95
8	91
7	91
9	91
10	91
6	91
1	91
5	91
10	93
1	93
7	93
8	92
10	92
6	92
1	92
9	92
2	92
4	94
2	94
5	94
3	94
10	96
8	96
7	96
4	96
2	96
1	96
5	96
6	96
3	97
4	97
2	97
4	100
6	100
3	100
10	100
2	100
5	100
9	100
1	100
5	98
8	98
3	98
7	98
2	98
1	98
4	98
2	99
7	99
5	99
1	99
8	99
3	99
4	99
10	99
6	101
7	101
8	101
2	101
5	101
7	102
2	102
9	102
1	102
8	102
5	102
10	102
6	102
5	103
1	103
9	103
2	103
10	103
8	103
2	104
7	104
1	104
5	104
4	104
9	105
1	105
6	105
8	105
8	106
5	106
3	106
8	107
3	107
10	107
6	107
7	107
4	107
3	108
2	108
10	108
8	108
9	108
9	109
3	109
10	109
5	109
6	109
4	109
2	109
7	109
8	111
5	111
2	111
6	111
9	111
10	111
7	111
4	111
7	110
4	110
2	110
10	110
5	110
5	112
4	112
7	112
6	114
5	114
1	114
3	114
1	113
7	113
10	113
9	117
5	117
10	117
4	117
1	117
8	117
3	117
2	117
1	116
6	116
3	116
10	116
9	116
2	116
8	116
6	115
3	115
4	115
5	115
10	115
1	115
7	115
7	118
9	118
8	118
5	118
10	118
3	118
1	118
4	118
1	120
10	120
6	120
7	120
4	120
2	120
3	119
2	119
7	119
9	119
10	119
8	119
6	119
4	119
2	121
3	121
8	121
5	121
3	123
5	123
7	123
8	123
9	123
2	122
6	122
8	122
7	124
1	124
9	124
9	125
8	125
7	125
10	125
6	126
8	126
3	126
5	126
4	126
9	127
4	127
7	127
1	128
5	128
10	128
4	128
2	128
3	128
5	129
2	129
9	129
3	129
10	129
1	129
8	129
6	129
6	130
9	130
4	130
2	130
5	130
10	130
3	130
3	132
4	132
7	132
6	132
9	132
10	132
1	132
2	132
5	131
6	131
3	131
4	133
1	133
2	133
5	133
3	133
6	133
7	133
9	133
2	134
7	134
6	134
3	134
10	135
4	135
1	135
6	135
9	135
7	135
8	135
2	135
4	136
7	136
1	136
6	136
8	136
9	136
5	136
7	137
8	137
10	137
2	137
6	137
5	137
1	137
2	138
4	138
9	138
5	141
8	141
2	141
10	142
9	142
6	142
5	142
2	142
1	142
7	142
3	142
4	139
2	139
7	139
8	139
4	143
8	143
9	143
5	143
1	143
6	143
5	140
9	140
3	140
8	140
4	140
7	140
10	140
9	146
6	146
3	146
10	146
4	145
3	145
8	145
10	145
5	145
2	145
1	145
3	144
10	144
6	144
7	144
10	150
6	150
4	150
2	150
3	150
5	150
7	150
9	150
7	148
10	148
5	148
1	148
6	147
4	147
3	147
9	147
2	149
5	149
6	149
8	151
3	151
1	151
5	152
8	152
2	152
10	152
3	152
3	153
4	153
10	153
9	154
3	154
1	154
7	154
10	154
2	154
6	154
4	154
1	155
2	155
8	155
10	155
3	155
9	156
8	156
4	156
7	156
5	156
1	156
10	156
2	156
8	157
4	157
9	157
3	158
1	158
2	158
8	158
10	158
9	158
5	158
9	159
10	159
1	159
8	160
10	160
3	160
4	160
4	161
2	161
5	161
9	162
4	162
5	162
8	162
8	164
5	164
3	164
1	164
4	164
10	164
7	164
2	164
8	165
4	165
9	165
2	163
7	163
6	163
2	166
4	166
8	166
1	166
10	166
6	166
5	166
8	167
7	167
2	167
5	167
3	167
9	167
10	168
6	168
7	168
1	168
5	168
3	168
9	168
4	168
7	169
10	169
6	169
5	169
2	169
9	169
1	169
9	170
4	170
6	170
2	170
7	171
9	171
1	171
7	172
9	172
2	172
10	172
5	172
1	175
8	175
10	175
4	175
5	175
3	175
2	175
9	175
3	174
2	174
1	174
10	174
10	173
7	173
3	173
5	173
1	173
3	176
1	176
10	176
6	176
2	176
7	176
8	176
9	176
6	179
2	179
1	179
8	179
10	179
5	179
9	179
4	179
3	177
4	177
2	177
2	178
3	178
9	178
7	178
5	178
2	180
8	180
3	180
6	180
5	180
7	180
1	180
10	181
7	181
2	181
1	183
7	183
8	183
6	183
8	182
7	182
10	182
4	184
3	184
6	184
5	184
9	184
8	184
7	184
9	185
7	185
1	185
6	185
5	185
1	186
5	186
4	186
9	186
10	186
3	186
7	186
7	187
9	187
6	187
2	188
1	188
10	188
4	188
8	188
3	188
5	188
4	195
10	195
5	195
4	199
3	199
9	199
10	199
1	199
8	199
10	190
4	190
1	190
9	190
7	190
5	190
2	193
8	193
3	193
10	193
1	193
6	193
1	196
9	196
4	196
5	198
8	198
6	198
9	198
4	198
2	198
1	192
5	192
10	192
4	192
6	192
8	194
10	194
2	194
6	194
4	194
5	194
2	197
10	197
8	197
2	200
4	200
9	200
8	200
10	200
6	200
4	189
10	189
3	189
7	189
4	191
3	191
7	191
8	191
6	191
3	202
3	201
3	205
3	203
3	204
3	206
3	207
3	208
3	209
3	210
3	211
3	212
3	213
3	214
3	215
4	216
4	217
4	219
4	218
4	220
4	221
4	222
\.


--
-- Data for Name: School_Program_Implementation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."School_Program_Implementation" ("PK_School", "PK_Education_Program") FROM stdin;
1	3
2	1
2	5
2	2
2	6
3	6
3	9
4	2
5	5
5	6
6	9
6	6
6	1
6	3
7	3
7	5
7	9
7	6
8	5
8	1
8	9
8	2
9	5
9	6
10	10
11	4
11	5
11	6
12	3
13	3
13	5
13	8
14	7
14	5
14	6
14	1
16	10
16	3
15	3
17	4
17	3
17	2
18	1
18	9
18	10
19	5
20	6
20	10
20	2
21	8
22	5
22	2
24	1
24	4
24	7
23	3
23	5
23	9
23	7
25	6
25	2
25	7
26	7
27	3
27	5
27	8
27	2
28	8
28	2
28	5
28	6
29	8
30	4
30	2
30	9
33	6
33	3
33	10
31	10
31	6
32	5
32	10
32	8
32	4
36	7
36	4
36	6
39	3
42	6
42	10
42	7
42	1
34	8
34	6
34	10
34	9
37	10
37	9
37	6
40	7
40	8
35	10
38	9
38	10
38	2
41	6
43	2
43	5
43	3
43	4
44	4
44	8
45	2
45	4
45	5
47	3
47	2
46	4
49	7
49	4
50	9
48	2
51	2
51	10
51	9
51	6
52	10
52	6
53	7
53	6
53	8
53	4
54	9
54	6
54	3
55	6
55	8
55	7
56	2
57	8
57	10
57	3
57	5
58	6
58	3
58	7
58	9
59	6
60	7
61	8
61	5
61	7
61	10
62	4
63	2
63	4
63	9
64	2
65	9
65	6
65	2
65	3
66	5
66	3
66	4
67	7
68	6
69	9
69	8
71	4
70	4
70	6
70	9
72	2
72	7
72	5
72	1
73	7
73	3
73	2
74	3
74	10
74	5
74	9
75	5
79	6
78	1
78	6
78	7
78	8
80	9
80	6
80	8
77	5
77	9
81	2
81	4
81	6
76	6
76	7
76	1
82	5
82	10
82	8
82	2
83	3
83	10
84	8
84	7
84	5
84	4
87	10
87	4
87	1
86	3
86	4
86	6
85	6
88	10
89	4
89	3
90	4
90	3
90	10
95	7
95	9
91	4
93	7
93	2
92	2
92	4
92	5
92	3
94	4
94	9
94	1
94	7
96	7
96	10
97	1
100	6
100	1
98	10
98	7
98	3
99	7
99	4
101	9
102	9
102	2
103	9
103	7
103	5
103	3
104	6
105	9
105	7
105	4
105	2
106	1
106	4
107	1
107	3
107	9
108	7
109	1
109	4
109	8
109	7
111	7
111	9
111	4
110	2
110	7
110	4
112	8
112	1
112	5
114	4
114	7
114	3
114	10
113	10
117	10
117	5
116	3
115	4
115	2
115	1
118	6
118	4
120	4
120	3
119	10
119	4
119	7
121	8
123	9
123	4
122	5
124	10
125	9
125	6
125	2
125	1
126	10
127	7
127	8
128	9
128	5
129	4
130	1
130	3
130	10
130	8
132	3
131	1
131	9
133	5
133	4
133	9
134	5
135	1
135	7
135	3
136	6
136	9
137	4
137	7
137	1
137	5
138	4
141	7
141	5
141	8
141	4
142	9
139	2
139	1
139	6
139	4
143	6
143	2
143	3
140	4
140	2
140	3
146	9
146	1
145	10
145	5
145	1
145	3
144	9
150	3
150	4
148	5
147	4
147	6
147	3
149	1
149	6
149	2
151	10
152	5
152	7
152	6
152	9
153	10
153	5
153	1
154	1
155	10
155	8
155	6
155	5
156	7
156	4
156	8
156	2
157	1
157	5
157	7
158	9
159	1
160	1
160	8
160	9
160	4
161	10
161	5
161	1
162	8
164	1
165	6
165	9
163	7
163	2
163	6
166	1
166	6
167	4
167	3
167	10
167	8
168	8
168	1
168	6
168	3
169	10
169	3
169	9
170	8
170	10
171	9
172	9
172	6
172	3
172	5
175	3
175	1
174	5
174	3
173	10
173	8
173	2
176	8
179	9
179	2
179	5
179	4
177	8
178	5
178	9
178	2
180	8
180	9
180	2
181	3
183	8
183	9
183	6
182	4
182	7
182	3
184	9
185	9
185	8
186	3
186	2
187	4
188	6
188	4
195	2
195	8
195	10
199	4
199	5
190	1
190	5
190	10
190	2
193	8
193	6
193	2
193	7
196	10
196	7
198	4
198	7
198	6
192	9
194	8
194	4
194	3
197	8
197	10
197	9
197	7
200	2
200	1
200	5
189	6
189	10
191	7
191	10
191	8
\.


--
-- Data for Name: School_Specialization; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."School_Specialization" ("PK_Specialization", "PK_School") FROM stdin;
2	2
5	3
2	3
5	4
1	4
6	6
5	8
3	9
6	9
3	10
5	10
2	11
7	11
5	12
8	12
4	13
2	13
3	13
5	14
1	14
6	14
6	16
3	17
6	18
8	18
2	20
6	20
1	20
8	21
6	21
3	22
1	22
3	24
1	24
8	24
7	23
1	23
8	25
6	25
4	25
5	26
7	26
8	27
3	27
5	27
5	29
6	29
2	29
6	30
4	30
2	33
7	33
1	31
8	31
4	31
2	32
6	32
7	32
4	36
2	36
7	42
6	42
5	37
3	37
5	40
7	40
8	38
2	38
5	38
4	43
6	44
2	44
3	47
4	46
2	46
8	46
4	49
2	49
8	49
1	52
4	52
4	53
1	53
6	54
5	54
4	55
8	55
1	55
7	56
3	56
2	57
1	57
2	58
5	58
1	59
3	59
8	60
4	60
6	62
8	62
5	62
2	64
4	65
7	65
4	66
1	66
1	67
7	68
1	68
8	71
8	70
5	72
2	72
4	72
2	73
2	74
3	74
6	79
1	79
8	77
6	77
2	81
6	81
5	81
5	82
6	84
5	84
8	84
3	87
6	87
4	87
4	86
7	86
2	86
5	85
1	89
8	90
8	95
5	93
7	93
2	92
7	92
2	94
4	94
3	94
5	96
3	100
8	100
4	100
5	99
5	102
8	102
1	102
2	103
3	103
8	103
8	105
7	105
2	106
7	106
6	106
2	107
4	107
6	107
6	109
7	109
4	111
1	110
3	114
7	114
1	114
7	113
5	113
8	113
3	117
4	117
5	116
2	116
7	115
3	118
4	118
8	122
1	124
8	124
4	124
7	125
4	125
5	125
6	126
4	126
1	127
7	127
2	127
7	129
2	129
3	131
1	131
1	134
4	134
6	134
7	136
1	137
4	137
7	137
2	138
6	141
3	141
7	141
4	139
3	143
8	143
7	143
1	140
3	140
2	140
3	145
6	145
1	144
4	144
4	148
5	149
2	149
4	151
1	151
5	151
7	152
3	152
4	152
6	154
2	154
8	154
8	158
1	158
6	158
7	160
2	161
1	161
6	161
5	162
1	164
5	164
4	165
5	165
2	165
4	163
2	163
8	166
7	170
5	170
5	171
1	172
6	172
8	172
4	175
7	174
1	174
4	174
1	173
4	179
3	177
1	177
4	178
4	180
7	180
2	180
5	181
2	181
4	182
7	182
8	182
4	186
6	186
5	193
3	193
6	196
2	198
5	198
7	198
4	192
6	200
7	191
1	216
1	217
1	219
1	218
1	220
1	221
1	222
\.


--
-- Data for Name: Settlement; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Settlement" ("Name", "Type", "PK_Settlement", "PK_District") FROM stdin;
Барнаул	город	1	2
Бийск	город	2	3
Рубцовск	город	3	7
Новоалтайск	город	4	6
Заринск	город	5	4
Камень-на-Оби	город	6	5
Славгород	город	7	8
Алейск	город	8	1
Яровое	город	9	8
Белокуриха	город	10	11
Горняк	город	11	28
Змеиногорск	город	12	17
Тальменка	поселок	13	47
Павловск	поселок	14	33
Шипуново	поселок	15	60
Косиха	поселок	16	21
Поспелиха	поселок	17	37
Калманка	поселок	18	19
Троицкое	поселок	19	51
Смоленское	поселок	20	41
Кулунда	поселок	21	25
Благовещенка	поселок	22	9
Михайловское	поселок	23	30
Волчиха	поселок	24	12
Шелаболиха	поселок	25	59
Красногорское	поселок	26	22
Солонешное	поселок	27	43
Ребриха	село	28	38
Мамонтово	село	29	29
Романово	село	30	40
Быстрый Исток	село	31	11
Угловское	село	32	53
Чарышское	село	33	58
Курья	село	34	26
Петропавловское	село	35	36
Зональное	село	36	18
Солтон	село	37	44
Кытманово	село	38	27
Топчиха	село	39	49
Усть-Калманка	село	40	54
Хабары	село	41	56
Целинное	село	42	57
\.


--
-- Data for Name: Specialization; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Specialization" ("PK_Specialization", "Name") FROM stdin;
1	Физико-математическая
2	Химико-биологическая
3	Гуманитарная
4	Лингвистическая
5	Техническая
6	Художественно-эстетическая
7	Спортивная
8	Информационные технологии
\.


--
-- Data for Name: Subject; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Subject" ("PK_Subject", "Name") FROM stdin;
1	Математика
2	Физика
3	Химия
4	Биология
5	Русский язык
6	Литература
7	История
8	Обществознание
9	География
10	Иностранный язык
11	Информатика
\.


--
-- Data for Name: Type_of_School; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Type_of_School" ("PK_Type_of_School", "Name") FROM stdin;
1	Общеобразовательная школа
2	Гимназия
3	Лицей
4	Школа-интернат
5	Коррекционная школа
6	Вечерняя школа
7	Кадетская школа
\.


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_log (id, user_id, action, table_name, record_id, old_values, new_values, "timestamp", ip_address, user_agent) FROM stdin;
1	1	update	School	102	{"Official_Name": "Барнаулская средняя школа", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127"}	{"Official_Name": "Барнаулская средняя школаа"}	2026-01-11 12:44:03.315517	127.0.0.1	\N
2	1	delete	Review	540	{"Author": "admin", "Text": "popodsdfsdf", "Rating": 5, "PK_School": 102}	\N	2026-01-11 14:19:37.252621	\N	\N
3	1	update	School	102	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430\\u0430", "Legal_Adress": "\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84", "Phone": "+7 (3857) 728127"}	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430"}	2026-01-11 14:56:37.50649	\N	\N
4	1	update	School	102	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430", "Legal_Adress": "\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84", "Phone": "+7 (3857) 728127"}	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430a"}	2026-01-11 16:05:33.141338	\N	\N
5	1	update	School	102	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430a", "Legal_Adress": "\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84", "Phone": "+7 (3857) 728127"}	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430aa"}	2026-01-11 16:07:31.003103	\N	\N
6	1	update	School	102	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430aa", "Legal_Adress": "\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84", "Phone": "+7 (3857) 728127"}	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430a"}	2026-01-11 16:53:55.856374	\N	\N
7	1	update	School	102	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430a", "Legal_Adress": "\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84", "Phone": "+7 (3857) 728127"}	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430"}	2026-01-11 16:56:54.652448	\N	\N
8	1	update	School	102	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430", "Legal_Adress": "\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "\\u041b\\u0438\\u0446\\u0435\\u043d\\u0437\\u0438\\u044f \\u2116\\u041b035-35795 \\u043e\\u0442 11.01.2026", "Accreditation": "\\u0410\\u043a\\u043a\\u0440\\u0435\\u0434\\u0438\\u0442\\u0430\\u0446\\u0438\\u044f \\u2116\\u0410417 \\u043e\\u0442 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true, "infrastructure": [1, 2, 5, 6, 7, 8, 9, 10], "specializations": [1, 5, 8]}	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0410"}	2026-01-11 17:02:12.544598	\N	\N
9	1	update	School	102	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0410", "Legal_Adress": "\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "\\u041b\\u0438\\u0446\\u0435\\u043d\\u0437\\u0438\\u044f \\u2116\\u041b035-35795 \\u043e\\u0442 11.01.2026", "Accreditation": "\\u0410\\u043a\\u043a\\u0440\\u0435\\u0434\\u0438\\u0442\\u0430\\u0446\\u0438\\u044f \\u2116\\u0410417 \\u043e\\u0442 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true, "infrastructure": [1, 2, 5, 6, 7, 8, 9, 10], "specializations": [1, 5, 8]}	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0410A"}	2026-01-11 17:02:37.501143	\N	\N
\.


--
-- Data for Name: data_versions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.data_versions (pk_version, table_name, record_id, action, data_before, data_after, changed_by, changed_at, created_at) FROM stdin;
1	School	102	update	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430", "Legal_Adress": "\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84", "Phone": "+7 (3857) 728127"}	{"Official_Name": "\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430\\u0430", "Legal_Adress": "\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "\\u041b\\u0438\\u0446\\u0435\\u043d\\u0437\\u0438\\u044f \\u2116\\u041b035-35795 \\u043e\\u0442 11.01.2026", "Accreditation": "\\u0410\\u043a\\u043a\\u0440\\u0435\\u0434\\u0438\\u0442\\u0430\\u0446\\u0438\\u044f \\u2116\\u0410417 \\u043e\\u0442 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true}	1	2026-01-11 15:44:03.30491	2026-01-11 15:40:52.684938
2	School	102	update	"{\\"Official_Name\\": \\"\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430\\u0430\\", \\"Legal_Adress\\": \\"\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84\\", \\"Phone\\": \\"+7 (3857) 728127\\"}"	"{\\"Official_Name\\": \\"\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430\\", \\"Legal_Adress\\": \\"\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84\\", \\"Phone\\": \\"+7 (3857) 728127\\", \\"Email\\": \\"school102@altai.edu.ru\\", \\"Website\\": \\"http://school102.altai.edu.ru\\", \\"Founding_Date\\": \\"1992-03-19\\", \\"Number_of_Students\\": 1233, \\"License\\": \\"\\u041b\\u0438\\u0446\\u0435\\u043d\\u0437\\u0438\\u044f \\u2116\\u041b035-35795 \\u043e\\u0442 11.01.2026\\", \\"Accreditation\\": \\"\\u0410\\u043a\\u043a\\u0440\\u0435\\u0434\\u0438\\u0442\\u0430\\u0446\\u0438\\u044f \\u2116\\u0410417 \\u043e\\u0442 11.01.2026\\", \\"PK_Type_of_School\\": 6, \\"PK_Settlement\\": 1, \\"is_active\\": true}"	1	2026-01-11 17:56:37.498915	2026-01-11 17:55:32.392457
3	School	102	update	"{\\"Official_Name\\": \\"\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430\\", \\"Legal_Adress\\": \\"\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84\\", \\"Phone\\": \\"+7 (3857) 728127\\"}"	"{\\"Official_Name\\": \\"\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430a\\", \\"Legal_Adress\\": \\"\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84\\", \\"Phone\\": \\"+7 (3857) 728127\\", \\"Email\\": \\"school102@altai.edu.ru\\", \\"Website\\": \\"http://school102.altai.edu.ru\\", \\"Founding_Date\\": \\"1992-03-19\\", \\"Number_of_Students\\": 1233, \\"License\\": \\"\\u041b\\u0438\\u0446\\u0435\\u043d\\u0437\\u0438\\u044f \\u2116\\u041b035-35795 \\u043e\\u0442 11.01.2026\\", \\"Accreditation\\": \\"\\u0410\\u043a\\u043a\\u0440\\u0435\\u0434\\u0438\\u0442\\u0430\\u0446\\u0438\\u044f \\u2116\\u0410417 \\u043e\\u0442 11.01.2026\\", \\"PK_Type_of_School\\": 6, \\"PK_Settlement\\": 1, \\"is_active\\": true}"	1	2026-01-11 19:05:33.135026	2026-01-11 19:05:06.980073
4	School	102	update	"{\\"Official_Name\\": \\"\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430a\\", \\"Legal_Adress\\": \\"\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84\\", \\"Phone\\": \\"+7 (3857) 728127\\"}"	"{\\"Official_Name\\": \\"\\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b\\u0441\\u043a\\u0430\\u044f \\u0441\\u0440\\u0435\\u0434\\u043d\\u044f\\u044f \\u0448\\u043a\\u043e\\u043b\\u0430aa\\", \\"Legal_Adress\\": \\"\\u0433\\u043e\\u0440\\u043e\\u0434 \\u0411\\u0430\\u0440\\u043d\\u0430\\u0443\\u043b, \\u0443\\u043b. \\u041f\\u0435\\u0441\\u0447\\u0430\\u043d\\u0430\\u044f, \\u0434. 769 \\u0441\\u0442\\u0440. 84\\", \\"Phone\\": \\"+7 (3857) 728127\\", \\"Email\\": \\"school102@altai.edu.ru\\", \\"Website\\": \\"http://school102.altai.edu.ru\\", \\"Founding_Date\\": \\"1992-03-19\\", \\"Number_of_Students\\": 1233, \\"License\\": \\"\\u041b\\u0438\\u0446\\u0435\\u043d\\u0437\\u0438\\u044f \\u2116\\u041b035-35795 \\u043e\\u0442 11.01.2026\\", \\"Accreditation\\": \\"\\u0410\\u043a\\u043a\\u0440\\u0435\\u0434\\u0438\\u0442\\u0430\\u0446\\u0438\\u044f \\u2116\\u0410417 \\u043e\\u0442 11.01.2026\\", \\"PK_Type_of_School\\": 6, \\"PK_Settlement\\": 1, \\"is_active\\": true}"	1	2026-01-11 19:07:30.99864	2026-01-11 19:05:06.980073
\.


--
-- Data for Name: import_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.import_history (id, filename, file_type, imported_by, imported_at, record_count, status, errors) FROM stdin;
\.


--
-- Data for Name: school_versions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.school_versions (pk_version, pk_school, version_number, action, old_data, new_data, changed_by, changed_at) FROM stdin;
1	102	1	update	{"Official_Name": "Барнаулская средняя школаaa", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127"}	{"Official_Name": "Барнаулская средняя школаa", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "Лицензия №Л035-35795 от 11.01.2026", "Accreditation": "Аккредитация №А417 от 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true}	1	2026-01-11 19:53:55.847416
2	102	1	update	{"Official_Name": "Барнаулская средняя школаa", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127", "Email": "", "Website": "", "Founding_Date": "", "Number_of_Students": "", "License": "", "Accreditation": "", "PK_Type_of_School": "", "PK_Settlement": "", "is_active": true}	{"Official_Name": "Барнаулская средняя школа", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "Лицензия №Л035-35795 от 11.01.2026", "Accreditation": "Аккредитация №А417 от 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true}	1	2026-01-11 19:56:54.643144
3	102	1	update	{"Official_Name": "Барнаулская средняя школа", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "Лицензия №Л035-35795 от 11.01.2026", "Accreditation": "Аккредитация №А417 от 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true}	{"Official_Name": "Барнаулская средняя школА", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "Лицензия №Л035-35795 от 11.01.2026", "Accreditation": "Аккредитация №А417 от 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true}	1	2026-01-11 20:02:12.535886
4	102	1	update	{"Official_Name": "Барнаулская средняя школА", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "Лицензия №Л035-35795 от 11.01.2026", "Accreditation": "Аккредитация №А417 от 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true}	{"Official_Name": "Барнаулская средняя школАA", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "Лицензия №Л035-35795 от 11.01.2026", "Accreditation": "Аккредитация №А417 от 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true}	1	2026-01-11 20:02:37.496298
5	102	1	rollback	{"Official_Name": "Барнаулская средняя школАA", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "Лицензия №Л035-35795 от 11.01.2026", "Accreditation": "Аккредитация №А417 от 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true}	{"Official_Name": "Барнаулская средняя школа", "Legal_Adress": "город Барнаул, ул. Песчаная, д. 769 стр. 84", "Phone": "+7 (3857) 728127", "Email": "school102@altai.edu.ru", "Website": "http://school102.altai.edu.ru", "Founding_Date": "1992-03-19", "Number_of_Students": 1233, "License": "Лицензия №Л035-35795 от 11.01.2026", "Accreditation": "Аккредитация №А417 от 11.01.2026", "PK_Type_of_School": 6, "PK_Settlement": 1, "is_active": true}	1	2026-01-11 20:06:45.169957
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, email, password_hash, role, is_active, created_at, last_login, gosuslugi_id, gosuslugi_data) FROM stdin;
2	parent	parent@example.com	pbkdf2:sha256:600000$XfGDwFsoZ8YGY7ND$8ec9cfee868c5595e9010f46cec33d0064c06197fdbd1dab49d1c64eea4c96ae	1	t	2026-01-11 14:50:00.088637	\N	\N	\N
3	teacher	teacher@example.com	pbkdf2:sha256:600000$D4Xalq7nABiZBB4v$ee74dd37121010f05806ded2aedeff6f075aa7f7739eb71a4c9f804a91e6798c	2	t	2026-01-11 14:50:00.088637	\N	\N	\N
4	school_admin	school_admin@example.com	pbkdf2:sha256:600000$AavvcEFTM19KcESF$106dc8ab13afd623b41d7e375d543be63e0e8a4212ccbc81395a82c945d7c1d0	3	t	2026-01-11 14:50:00.088637	\N	\N	\N
5	region_admin	region_admin@example.com	pbkdf2:sha256:600000$QjNJ3yyzDLr7CiRI$6d2435c6cd98f6a7d23014c0f6e38b08878a92057ce7fe0eb774a5a4847317df	4	t	2026-01-11 14:50:00.088637	\N	\N	\N
1	admin	admin@example.com	pbkdf2:sha256:600000$MXWKkrWV2iYbXl5X$2f71a30f470a08b7a0525f094b40d4477bdb235f3a792f6f21e52e473eb7f887	5	t	2026-01-11 14:50:00.088637	2026-01-11 15:45:16.628818	\N	\N
\.


--
-- Name: District_PK_District_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."District_PK_District_seq"', 60, true);


--
-- Name: Education_Program_PK_Education_Program_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Education_Program_PK_Education_Program_seq"', 10, true);


--
-- Name: Employee_PK_Employee_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Employee_PK_Employee_seq"', 200, true);


--
-- Name: Infrastructure_PK_Infrastructure_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Infrastructure_PK_Infrastructure_seq"', 10, true);


--
-- Name: Inspection_PK_Inspection_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Inspection_PK_Inspection_seq"', 97, true);


--
-- Name: Review_PK_Review_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Review_PK_Review_seq"', 540, true);


--
-- Name: School_PK_School_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."School_PK_School_seq"', 227, true);


--
-- Name: Settlement_PK_Settlement_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Settlement_PK_Settlement_seq"', 42, true);


--
-- Name: Specialization_PK_Specialization_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Specialization_PK_Specialization_seq"', 8, true);


--
-- Name: Subject_PK_Subject_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Subject_PK_Subject_seq"', 11, true);


--
-- Name: Type_of_School_PK_Type_of_School_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Type_of_School_PK_Type_of_School_seq"', 7, true);


--
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.audit_log_id_seq', 9, true);


--
-- Name: data_versions_pk_version_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.data_versions_pk_version_seq', 4, true);


--
-- Name: import_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.import_history_id_seq', 1, false);


--
-- Name: school_versions_pk_version_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.school_versions_pk_version_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: District PK_District; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."District"
    ADD CONSTRAINT "PK_District" PRIMARY KEY ("PK_District");


--
-- Name: Education_Program PK_Education_Program; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Education_Program"
    ADD CONSTRAINT "PK_Education_Program" PRIMARY KEY ("PK_Education_Program");


--
-- Name: Employee PK_Employee; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT "PK_Employee" PRIMARY KEY ("PK_Employee");


--
-- Name: Employee_Subject_Competence PK_Employee_Subject_Competence; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Employee_Subject_Competence"
    ADD CONSTRAINT "PK_Employee_Subject_Competence" PRIMARY KEY ("PK_Subject", "PK_Employee");


--
-- Name: Infrastructure PK_Infrastructure; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Infrastructure"
    ADD CONSTRAINT "PK_Infrastructure" PRIMARY KEY ("PK_Infrastructure");


--
-- Name: Inspection PK_Inspection; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Inspection"
    ADD CONSTRAINT "PK_Inspection" PRIMARY KEY ("PK_Inspection");


--
-- Name: Review PK_Review; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT "PK_Review" PRIMARY KEY ("PK_Review");


--
-- Name: School PK_School; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School"
    ADD CONSTRAINT "PK_School" PRIMARY KEY ("PK_School");


--
-- Name: School_Employee PK_School_Employee; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Employee"
    ADD CONSTRAINT "PK_School_Employee" PRIMARY KEY ("PK_School", "PK_Employee");


--
-- Name: School_Infrastructure PK_School_Infrastructure; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Infrastructure"
    ADD CONSTRAINT "PK_School_Infrastructure" PRIMARY KEY ("PK_Infrastructure", "PK_School");


--
-- Name: School_Program_Implementation PK_School_Program_Implementation; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Program_Implementation"
    ADD CONSTRAINT "PK_School_Program_Implementation" PRIMARY KEY ("PK_School", "PK_Education_Program");


--
-- Name: School_Specialization PK_School_Specialization; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Specialization"
    ADD CONSTRAINT "PK_School_Specialization" PRIMARY KEY ("PK_Specialization", "PK_School");


--
-- Name: Settlement PK_Settlement; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Settlement"
    ADD CONSTRAINT "PK_Settlement" PRIMARY KEY ("PK_Settlement");


--
-- Name: Specialization PK_Specialization; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Specialization"
    ADD CONSTRAINT "PK_Specialization" PRIMARY KEY ("PK_Specialization");


--
-- Name: Subject PK_Subject; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subject"
    ADD CONSTRAINT "PK_Subject" PRIMARY KEY ("PK_Subject");


--
-- Name: Type_of_School PK_Type_of_School; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Type_of_School"
    ADD CONSTRAINT "PK_Type_of_School" PRIMARY KEY ("PK_Type_of_School");


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: data_versions data_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_versions
    ADD CONSTRAINT data_versions_pkey PRIMARY KEY (pk_version);


--
-- Name: import_history import_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_history
    ADD CONSTRAINT import_history_pkey PRIMARY KEY (id);


--
-- Name: school_versions school_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_versions
    ADD CONSTRAINT school_versions_pkey PRIMARY KEY (pk_version);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: IX_Relationship17; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_Relationship17" ON public."School" USING btree ("PK_Type_of_School");


--
-- Name: IX_Relationship24; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_Relationship24" ON public."Settlement" USING btree ("PK_District");


--
-- Name: IX_Relationship25; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_Relationship25" ON public."School" USING btree ("PK_Settlement");


--
-- Name: IX_Relationship26; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_Relationship26" ON public."Review" USING btree ("PK_School");


--
-- Name: IX_Relationship27; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_Relationship27" ON public."Inspection" USING btree ("PK_School");


--
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: Settlement belongs_to; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Settlement"
    ADD CONSTRAINT belongs_to FOREIGN KEY ("PK_District") REFERENCES public."District"("PK_District") ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: Inspection conducted_at; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Inspection"
    ADD CONSTRAINT conducted_at FOREIGN KEY ("PK_School") REFERENCES public."School"("PK_School") ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: data_versions data_versions_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_versions
    ADD CONSTRAINT data_versions_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: School_Employee employs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Employee"
    ADD CONSTRAINT employs FOREIGN KEY ("PK_School") REFERENCES public."School"("PK_School") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: School_Infrastructure has; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Infrastructure"
    ADD CONSTRAINT has FOREIGN KEY ("PK_School") REFERENCES public."School"("PK_School") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: School_Program_Implementation implemented_by; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Program_Implementation"
    ADD CONSTRAINT implemented_by FOREIGN KEY ("PK_Education_Program") REFERENCES public."Education_Program"("PK_Education_Program") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: School_Program_Implementation implements; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Program_Implementation"
    ADD CONSTRAINT implements FOREIGN KEY ("PK_School") REFERENCES public."School"("PK_School") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: import_history import_history_imported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_history
    ADD CONSTRAINT import_history_imported_by_fkey FOREIGN KEY (imported_by) REFERENCES public.users(id);


--
-- Name: School_Infrastructure includes; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Infrastructure"
    ADD CONSTRAINT includes FOREIGN KEY ("PK_Infrastructure") REFERENCES public."Infrastructure"("PK_Infrastructure") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: School is_of_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School"
    ADD CONSTRAINT is_of_type FOREIGN KEY ("PK_Type_of_School") REFERENCES public."Type_of_School"("PK_Type_of_School") ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: School located_in; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School"
    ADD CONSTRAINT located_in FOREIGN KEY ("PK_Settlement") REFERENCES public."Settlement"("PK_Settlement") ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: School_Specialization offers; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Specialization"
    ADD CONSTRAINT offers FOREIGN KEY ("PK_School") REFERENCES public."School"("PK_School") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: Review refers_to; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT refers_to FOREIGN KEY ("PK_School") REFERENCES public."School"("PK_School") ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: school_versions school_versions_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_versions
    ADD CONSTRAINT school_versions_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: school_versions school_versions_pk_school_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_versions
    ADD CONSTRAINT school_versions_pk_school_fkey FOREIGN KEY (pk_school) REFERENCES public."School"("PK_School");


--
-- Name: School_Specialization specializes_in; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Specialization"
    ADD CONSTRAINT specializes_in FOREIGN KEY ("PK_Specialization") REFERENCES public."Specialization"("PK_Specialization") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: Employee_Subject_Competence taught_by; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Employee_Subject_Competence"
    ADD CONSTRAINT taught_by FOREIGN KEY ("PK_Employee") REFERENCES public."Employee"("PK_Employee") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: Employee_Subject_Competence teaches; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Employee_Subject_Competence"
    ADD CONSTRAINT teaches FOREIGN KEY ("PK_Subject") REFERENCES public."Subject"("PK_Subject") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: School_Employee works_for; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."School_Employee"
    ADD CONSTRAINT works_for FOREIGN KEY ("PK_Employee") REFERENCES public."Employee"("PK_Employee") ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

