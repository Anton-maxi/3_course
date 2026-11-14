-- Сценарій створення і заповнення таблиць: Script.sql (лаб 1), inserts.sql (лаб 2), нові INSERT (лаб 3)

CREATE TABLE positions (
    position_id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,

    CONSTRAINT PK_positions PRIMARY KEY (position_id),
    CONSTRAINT UQ_positions_name UNIQUE (name)
);

-- persons/1
CREATE TABLE persons (
    person_id BIGINT GENERATED ALWAYS AS IDENTITY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    birth_date DATE NOT NULL,
    rnokpp CHAR(10) NOT NULL,
    passport_series VARCHAR(2),
    passport_number VARCHAR(9) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    address VARCHAR(255),
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,

    CONSTRAINT PK_persons PRIMARY KEY (person_id),
    CONSTRAINT UQ_persons_rnokpp UNIQUE (rnokpp),
    CONSTRAINT UQ_persons_passport UNIQUE NULLS NOT DISTINCT (passport_series, passport_number),
    CONSTRAINT UQ_persons_phone UNIQUE (phone),
    CONSTRAINT UQ_persons_email UNIQUE (email),
    CONSTRAINT CK_persons_rnokpp CHECK (rnokpp ~ '^[0-9]{10}$')
);

-- companies/5
CREATE TABLE companies (
    company_id BIGINT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    edrpou CHAR(8) NOT NULL,
    legal_address VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    registered_at TIMESTAMPTZ DEFAULT now() NOT NULL,

    CONSTRAINT PK_companies PRIMARY KEY (company_id),
    CONSTRAINT UQ_companies_edrpou UNIQUE (edrpou),
    CONSTRAINT CK_companies_edrpou CHECK (edrpou ~ '^[0-9]{8}$')
);

-- account_statuses/8 (довідник)
CREATE TABLE account_statuses (
    status_code VARCHAR(20),
    name VARCHAR(50) NOT NULL,

    CONSTRAINT PK_account_statuses PRIMARY KEY (status_code),
    CONSTRAINT UQ_account_statuses_name UNIQUE (name)
);

-- operation_types/10 (довідник)
CREATE TABLE operation_types (
    type_code VARCHAR(20),
    name VARCHAR(50) NOT NULL,

    CONSTRAINT PK_operation_types PRIMARY KEY (type_code),
    CONSTRAINT UQ_operation_types_name UNIQUE (name)
);

-- operation_statuses/11 (довідник)
CREATE TABLE operation_statuses (
    status_code VARCHAR(20),
    name VARCHAR(50) NOT NULL,

    CONSTRAINT PK_operation_statuses PRIMARY KEY (status_code),
    CONSTRAINT UQ_operation_statuses_name UNIQUE (name)
);

-- clients/2
CREATE TABLE clients (
    client_id BIGINT GENERATED ALWAYS AS IDENTITY,
    person_id BIGINT NOT NULL,
    registered_at TIMESTAMPTZ DEFAULT now() NOT NULL,

    CONSTRAINT PK_clients PRIMARY KEY (client_id),
    CONSTRAINT UQ_clients_person_id UNIQUE (person_id),
    CONSTRAINT FK_clients_persons FOREIGN KEY (person_id)
        REFERENCES persons (person_id) ON DELETE RESTRICT
);

-- employees/3
CREATE TABLE employees (
    employee_id BIGINT GENERATED ALWAYS AS IDENTITY,
    person_id BIGINT NOT NULL,
    position_id INT NOT NULL,
    hire_date DATE NOT NULL,
    dismissal_date DATE,
    education VARCHAR(255) NOT NULL,

    CONSTRAINT PK_employees PRIMARY KEY (employee_id),
    CONSTRAINT UQ_employees_person_id UNIQUE (person_id),
    CONSTRAINT FK_employees_persons FOREIGN KEY (person_id)
        REFERENCES persons (person_id) ON DELETE RESTRICT,
    CONSTRAINT FK_employees_positions FOREIGN KEY (position_id)
        REFERENCES positions (position_id) ON DELETE RESTRICT,
    CONSTRAINT CK_employees_dates CHECK (dismissal_date IS NULL OR dismissal_date >= hire_date)
);

-- company_members/6 (залежна)
CREATE TABLE company_members (
    company_id BIGINT,
    person_id BIGINT,
    role_in_company VARCHAR(100) NOT NULL,
    granted_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    revoked_at TIMESTAMPTZ,

    CONSTRAINT PK_company_members PRIMARY KEY (company_id, person_id),
    CONSTRAINT FK_company_members_persons FOREIGN KEY (person_id)
        REFERENCES persons (person_id) ON DELETE CASCADE,
    CONSTRAINT FK_company_members_companies FOREIGN KEY (company_id)
        REFERENCES companies (company_id) ON DELETE CASCADE,
    CONSTRAINT CK_members_dates CHECK (revoked_at IS NULL OR revoked_at >= granted_at)
);

-- accounts/7
CREATE TABLE accounts (
    account_id BIGINT GENERATED ALWAYS AS IDENTITY,
    iban CHAR(29) NOT NULL,
    client_id BIGINT,
    company_id BIGINT,
    currency CHAR(3) DEFAULT 'UAH' NOT NULL,
    balance NUMERIC(15,2) DEFAULT 0 NOT NULL,
    status_code VARCHAR(20) NOT NULL,
    opened_at DATE DEFAULT CURRENT_DATE NOT NULL,
    closed_at DATE,

    CONSTRAINT PK_accounts PRIMARY KEY (account_id),
    CONSTRAINT UQ_accounts_iban UNIQUE (iban),
    CONSTRAINT FK_accounts_clients FOREIGN KEY (client_id)
        REFERENCES clients (client_id) ON DELETE RESTRICT,
    CONSTRAINT FK_accounts_companies FOREIGN KEY (company_id)
        REFERENCES companies (company_id) ON DELETE RESTRICT,
    CONSTRAINT FK_accounts_account_statuses FOREIGN KEY (status_code)
        REFERENCES account_statuses (status_code) ON DELETE RESTRICT,
    CONSTRAINT CK_accounts_iban CHECK (iban ~ '^UA[0-9]{27}$'),
    CONSTRAINT CK_accounts_owner CHECK (num_nonnulls(client_id, company_id) = 1),
    CONSTRAINT CK_accounts_currency CHECK (currency IN ('UAH', 'USD', 'EUR')),
    CONSTRAINT CK_accounts_balance  CHECK (balance >= 0),
    CONSTRAINT CK_accounts_closed CHECK ((closed_at IS NOT NULL) = (status_code = 'closed'))
);

-- operations/9
CREATE TABLE operations (
    operation_id BIGINT GENERATED ALWAYS AS IDENTITY,
    account_id BIGINT NOT NULL,
    target_account_id BIGINT,
    type_code VARCHAR(20) NOT NULL,
    amount NUMERIC(15,2) NOT NULL,
    requested_by BIGINT NOT NULL,
    confirmed_by BIGINT,
    status_code VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    confirmed_at TIMESTAMPTZ,
    note VARCHAR(500),

    CONSTRAINT PK_operations PRIMARY KEY (operation_id),
    CONSTRAINT FK_operations_accounts FOREIGN KEY (account_id)
        REFERENCES accounts (account_id) ON DELETE RESTRICT,
       CONSTRAINT FK_operations_accounts_payee FOREIGN KEY (target_account_id)
        REFERENCES accounts (account_id) ON DELETE RESTRICT,
    CONSTRAINT FK_operations_operation_types FOREIGN KEY (type_code)
        REFERENCES operation_types (type_code) ON DELETE RESTRICT,
    CONSTRAINT FK_operations_persons FOREIGN KEY (requested_by)
        REFERENCES persons (person_id) ON DELETE RESTRICT,
    CONSTRAINT FK_operations_employees FOREIGN KEY (confirmed_by)
        REFERENCES employees (employee_id) ON DELETE RESTRICT,
    CONSTRAINT FK_operations_operation_statuses FOREIGN KEY (status_code)
        REFERENCES operation_statuses (status_code) ON DELETE RESTRICT,
    CONSTRAINT CK_operations_amount CHECK (amount > 0),
    CONSTRAINT CK_operations_target CHECK (((target_account_id IS NOT NULL) = (type_code = 'transfer')) AND (target_account_id IS NULL OR target_account_id <> account_id)),
    CONSTRAINT CK_operations_confirm CHECK (((status_code = 'pending') = (confirmed_by IS NULL)) AND ((confirmed_by IS NULL) = (confirmed_at IS NULL)))
);


-- Початкові дані довідників (15)

INSERT INTO account_statuses (status_code, name) VALUES ('open', 'Відкритий'), ('blocked', 'Заблокований'), ('closed', 'Закритий');
INSERT INTO operation_types (name, type_code) VALUES ('Внесення', 'deposit'), ('Зняття', 'withdrawal'), ('Переказ', 'transfer');
INSERT INTO operation_statuses (name, status_code) VALUES ('Очікування', 'pending'), ('Виконано', 'done'), ('Відхилено', 'rejected');
INSERT INTO positions (name) VALUES ('касир'), ('менеджер'), ('фінансовий аналітик');
-- Наповнення таблиць тестовими даними (усі дані вигадані).
-- Запускати після Script.sql (він перестворює таблиці, тож ідентифікатори починаються з 1).
-- Довідники account_statuses, operation_types, operation_statuses, positions
-- уже мають по 3 рядки з Script.sql, нижче додаємо ще по 2.
 
-- account_statuses/8 (довідник)
INSERT INTO account_statuses (status_code, name) VALUES
    ('frozen', 'Заморожений'),
    ('dormant', 'Неактивний');
 
-- operation_types/10 (довідник)
INSERT INTO operation_types (type_code, name) VALUES
    ('payment', 'Оплата'),
    ('fee', 'Комісія');
 
-- operation_statuses/11 (довідник)
INSERT INTO operation_statuses (status_code, name) VALUES
    ('cancelled', 'Скасовано'),
    ('expired', 'Прострочено');
 
-- positions/4 (довідник)
INSERT INTO positions (name) VALUES
    ('юрист'),
    ('кредитний спеціаліст');
 
-- persons/1 (1-5 клієнти, 6-10 працівники)
INSERT INTO persons (last_name, first_name, middle_name, birth_date, rnokpp, passport_series, passport_number, phone, email, address, password_hash) VALUES
    ('Коваленко', 'Ірина', 'Миколаївна', '1990-04-15', '3000000001', 'КА', '100001', '+380500000001', 'iryna.test@example.com', 'м. Київ, вул. Тестова, 1', 'hash_test_01'),
    ('Мельник', 'Андрій', 'Олегович', '1985-09-02', '3000000002', 'КБ', '100002', '+380500000002', 'andrii.test@example.com', 'м. Львів, вул. Тестова, 2', 'hash_test_02'),
    ('Бондаренко', 'Олена', NULL, '1995-12-20', '3000000003', NULL, '000000003', '+380500000003', 'olena.test@example.com', 'м. Одеса, вул. Тестова, 3', 'hash_test_03'),
    ('Ткаченко', 'Максим', 'Сергійович', '1988-06-30', '3000000004', 'КВ', '100004', '+380500000004', NULL, NULL, 'hash_test_04'),
    ('Кравченко', 'Дарина', 'Вікторівна', '2000-01-25', '3000000005', NULL, '000000005', '+380500000005', 'daryna.test@example.com', 'м. Харків, вул. Тестова, 5', 'hash_test_05'),
    ('Шевчук', 'Тетяна', 'Іванівна', '1982-07-11', '3000000006', 'КГ', '100006', '+380500000006', 'tetiana.test@example.com', 'м. Київ, вул. Тестова, 6', 'hash_test_06'),
    ('Бойко', 'Віталій', 'Петрович', '1979-02-18', '3000000007', 'КД', '100007', '+380500000007', 'vitalii.test@example.com', 'м. Київ, вул. Тестова, 7', 'hash_test_07'),
    ('Лисенко', 'Наталія', 'Андріївна', '1992-10-05', '3000000008', NULL, '000000008', '+380500000008', 'natalia.test@example.com', 'м. Київ, вул. Тестова, 8', 'hash_test_08'),
    ('Савченко', 'Роман', 'Дмитрович', '1987-03-27', '3000000009', 'КЕ', '100009', '+380500000009', 'roman.test@example.com', 'м. Київ, вул. Тестова, 9', 'hash_test_09'),
    ('Мороз', 'Юлія', 'Олексіївна', '1994-08-14', '3000000010', NULL, '000000010', '+380500000010', 'yuliia.test@example.com', 'м. Київ, вул. Тестова, 10', 'hash_test_10');
 
-- clients/2
INSERT INTO clients (person_id) VALUES (1), (2), (3), (4), (5);
 
-- employees/3
INSERT INTO employees (person_id, position_id, hire_date, dismissal_date, education) VALUES
    (6, 1, '2019-03-01', NULL, 'Вища, економіка'),
    (7, 2, '2015-09-15', NULL, 'Вища, менеджмент'),
    (8, 3, '2020-06-10', NULL, 'Вища, фінанси'),
    (9, 1, '2018-01-20', '2023-05-31', 'Середня спеціальна'),
    (10, 5, '2022-11-01', NULL, 'Вища, банківська справа');
 
-- companies/5
INSERT INTO companies (name, edrpou, legal_address, phone, email) VALUES
    ('ТОВ «Тест-Меркурій»', '10000001', 'м. Київ, вул. Бізнесова, 1', '+380440000001', 'info1@example.com'),
    ('ТОВ «Тест-Альфа»', '10000002', 'м. Львів, вул. Бізнесова, 2', '+380320000002', 'info2@example.com'),
    ('ФОП Тест-Бета', '10000003', 'м. Одеса, вул. Бізнесова, 3', '+380480000003', NULL),
    ('ТОВ «Тест-Гамма»', '10000004', 'м. Харків, вул. Бізнесова, 4', '+380570000004', 'info4@example.com'),
    ('ТОВ «Тест-Дельта»', '10000005', 'м. Дніпро, вул. Бізнесова, 5', '+380560000005', 'info5@example.com');
 
-- company_members/6
INSERT INTO company_members (company_id, person_id, role_in_company, granted_at, revoked_at) VALUES
    (1, 1, 'директор', '2023-01-10 10:00:00+02', NULL),
    (1, 2, 'бухгалтер', '2023-02-01 10:00:00+02', NULL),
    (2, 3, 'директор', '2023-03-15 10:00:00+02', NULL),
    (3, 4, 'власник', '2023-04-20 10:00:00+02', NULL),
    (4, 5, 'директор', '2023-05-05 10:00:00+02', NULL),
    (2, 4, 'бухгалтер', '2024-03-01 10:00:00+02', '2025-03-01 10:00:00+02');
 
-- accounts/7
INSERT INTO accounts (iban, client_id, company_id, currency, balance, status_code, opened_at, closed_at) VALUES
    ('UA000000000000000000000000001', 1, NULL, 'UAH', 15000.00, 'open', '2022-05-10', NULL),
    ('UA000000000000000000000000002', 2, NULL, 'USD', 2500.50, 'open', '2022-08-21', NULL),
    ('UA000000000000000000000000003', 3, NULL, 'UAH', 0.00, 'closed', '2021-02-14', '2024-08-01'),
    ('UA000000000000000000000000004', NULL, 1, 'UAH', 120000.00, 'open', '2023-01-12', NULL),
    ('UA000000000000000000000000005', NULL, 2, 'EUR', 8000.00, 'open', '2023-03-20', NULL),
    ('UA000000000000000000000000006', 4, NULL, 'UAH', 500.00, 'blocked', '2023-06-01', NULL),
    ('UA000000000000000000000000007', NULL, 3, 'UAH', 45000.00, 'open', '2023-04-25', NULL);
 
-- operations/9
INSERT INTO operations (account_id, target_account_id, type_code, amount, requested_by, confirmed_by, status_code, created_at, confirmed_at, note) VALUES
    (1, NULL, 'deposit', 5000.00, 1, 1, 'done', '2025-09-01 10:00:00+02', '2025-09-01 10:05:00+02', 'Внесення готівки'),
    (2, NULL, 'withdrawal', 300.00, 2, 1, 'done', '2025-09-02 11:00:00+02', '2025-09-02 11:03:00+02', 'Зняття готівки'),
    (1, 4, 'transfer', 1500.00, 1, 2, 'done', '2025-09-03 12:00:00+02', '2025-09-03 12:10:00+02', 'Переказ на рахунок компанії'),
    (4, 7, 'transfer', 2000.00, 1, 3, 'done', '2025-09-04 09:30:00+02', '2025-09-04 09:45:00+02', 'Оплата послуг'),
    (1, NULL, 'withdrawal', 20000.00, 1, 3, 'rejected', '2025-09-05 14:00:00+02', '2025-09-05 14:02:00+02', 'Недостатньо коштів'),
    (2, NULL, 'deposit', 100.00, 2, NULL, 'pending', '2025-09-06 16:00:00+02', NULL, NULL);

INSERT INTO operations (account_id, target_account_id, type_code, amount, requested_by, confirmed_by, status_code, created_at, confirmed_at, note) VALUES
    (1, NULL, 'deposit', 2000.00, 1, 1, 'done', '2026-02-10 10:00:00+01', '2026-02-10 10:05:00+01', 'Внесення готівки'),
    (2, NULL, 'deposit', 150.00, 2, 2, 'done', '2026-05-18 12:30:00+02', '2026-05-18 12:34:00+02', 'Внесення готівки'),
    (4, NULL, 'deposit', 10000.00, 1, 3, 'done', '2026-09-03 09:15:00+02', '2026-09-03 09:20:00+02', 'Внесення на рахунок компанії'),
    (1, NULL, 'withdrawal', 500.00, 1, 1, 'done', '2026-03-01 11:00:00+01', '2026-03-01 11:04:00+01', 'Зняття готівки');

INSERT INTO clients (person_id) VALUES (6);
