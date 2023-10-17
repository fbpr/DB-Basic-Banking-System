-- DDL
-- CREATE TABLE CUSTOMERS
CREATE TABLE IF NOT EXISTS customers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address TEXT,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(15) NOT NULL,
  createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
  updatedAt TIMESTAMP DEFAULT NOW(),
  deletedAt TIMESTAMP
);

-- CREATE TABLE ACCOUNTS
CREATE TABLE IF NOT EXISTS accounts (
  id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(id),
  balance BIGINT NOT NULL,
  createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
  updatedAt TIMESTAMP DEFAULT NOW(),
  deletedAt TIMESTAMP
);

-- CREATE ENUM FOR TRANSACTION_TYPE
CREATE TYPE transaction_type AS ENUM ('deposit', 'withdraw');
-- CREATE TABLE TRANSACTIONS
CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  account_id INT REFERENCES accounts(id),
  transaction_type transaction_type NOT NULL,
  amount BIGINT NOT NULL,
  description VARCHAR(255),
  createdAt TIMESTAMP NOT NULL DEFAULT NOW()
);

-- DML 
-- INSERT CUSTOMERS TABLE
INSERT INTO customers (name, address, email, phone)
VALUES ('John Doe', 'DKI Jakarta', 'john.doe@gmail.com', '62123456789');

INSERT INTO customers (name, address, email, phone)
VALUES ('Sergio Barber', 'Surabaya', 'sergio.barber@gmail.com', '62123456799');

INSERT INTO customers (name, address, email, phone)
VALUES ('Katherine Simon', 'Bandung', 'katherine.simon@gmail.com', '62123456778');

INSERT INTO customers (name, address, email, phone)
VALUES ('Shannon Payne', 'Semarang', 'shannon.payne@gmail.com', '62123456278');

INSERT INTO customers (name, address, email, phone)
VALUES ('Connor Munoz', 'Bogor', 'connor.munoz@gmail.com', '62123456178');

-- INSERT ACCOUNTS TABLE
INSERT INTO accounts (customer_id, balance) 
VALUES (1, 100000);

INSERT INTO accounts (customer_id, balance) 
VALUES (2, 200000);

INSERT INTO accounts (customer_id, balance) 
VALUES (3, 150000);

INSERT INTO accounts (customer_id, balance) 
VALUES (4, 300000);

INSERT INTO accounts (customer_id, balance) 
VALUES (5, 500000);

-- INSERT TRANSACTIONS TABLE
INSERT INTO transactions (account_id, transaction_type, amount, description) 
VALUES (1, 'deposit', 100000, 'salary');

INSERT INTO transactions (account_id, transaction_type, amount, description)
VALUES (2, 'withdraw', 50000, 'foods');

INSERT INTO transactions (account_id, transaction_type, amount, description) 
VALUES (3, 'deposit', 150000, 'salary');

INSERT INTO transactions (account_id, transaction_type, amount, description) 
VALUES (4, 'withdraw', 100000, 'drinks');

INSERT INTO transactions (account_id, transaction_type, amount, description) 
VALUES (5, 'deposit', 500000, 'bonus');

-- READ ALL DATA FROM ALL TABLES
SELECT * FROM customers;
SELECT * FROM accounts;
SELECT * FROM transactions;

-- READ CUSTOMER DATA WITH ACCOUNT ID AND BALANCE
SELECT a.id, c.name, a.balance
FROM customers c 
JOIN accounts a
ON c.id = a.customer_id;

-- UPDATE CUSTOMER PHONE
UPDATE customers
SET phone = '62123456744'
WHERE id = 1;

-- UPDATE ACCOUNT balance
UPDATE accounts
SET balance = balance + 100000
WHERE id = 1;

-- DELETE TRANSACTION
DELETE FROM transactions WHERE id = 1;

-- CREATE INDEXING
CREATE INDEX index_account ON "accounts"(id);
CREATE INDEX index_transaction ON "transactions"(id);

-- STORED PROCEDURE ADD CUSTOMER
CREATE OR REPLACE PROCEDURE add_customer(
    IN name VARCHAR(255),
    IN address TEXT,
    IN email VARCHAR(255),
    IN phone VARCHAR(15)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO customers (name, address, email, phone) VALUES (name, address, email, phone);
END;
$$;

-- STORED PROCEDURE CREATE ACCOUNT
CREATE OR REPLACE PROCEDURE create_account(
    IN customer_id INT,
    IN balance BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO accounts (customer_id, balance) VALUES (customer_id, balance);
END;
$$;

-- RUN PROCEDURE
CALL add_customer('Trevor Tran', 'Solo', 'trevor.tran@gmail.com', '62134546565');
CALL create_account(2, 350000);

-- CTE RECENT DEPOSITS FOR A WEEK
WITH recent_deposits AS (
  SELECT id, account_id, amount
  FROM transactions
  WHERE transaction_type = 'deposit'
  AND createdAt >= CURRENT_DATE - INTERVAL '1 WEEK'
)
SELECT * FROM recent_deposits;
