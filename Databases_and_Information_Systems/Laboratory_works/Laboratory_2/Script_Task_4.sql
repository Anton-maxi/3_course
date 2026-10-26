DROP TABLE IF EXISTS operations;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS company_members;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS account_statuses;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS operation_statuses;
DROP TABLE IF EXISTS operation_types;
DROP TABLE IF EXISTS persons;

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