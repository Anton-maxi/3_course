-- Наповнення таблиць тестовими даними (усі дані вигадані).
INSERT INTO account_statuses (status_code, name) VALUES ('open', 'Відкритий'), ('blocked', 'Заблокований'), ('closed', 'Закритий');
INSERT INTO operation_types (name, type_code) VALUES ('Внесення', 'deposit'), ('Зняття', 'withdrawal'), ('Переказ', 'transfer');
INSERT INTO operation_statuses (name, status_code) VALUES ('Очікування', 'pending'), ('Виконано', 'done'), ('Відхилено', 'rejected');
INSERT INTO positions (name) VALUES ('касир'), ('менеджер'), ('фінансовий аналітик');


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