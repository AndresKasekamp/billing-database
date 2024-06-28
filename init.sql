-- init.sql
-- Create a new database
CREATE DATABASE orders;
-- Connect to the newly created database
\ c orders -- Create a new user with a password
CREATE USER username WITH ENCRYPTED PASSWORD 'password';
-- Grant all privileges on the database to the new user
GRANT ALL PRIVILEGES ON DATABASE orders TO username;
-- Grant privileges on the public schema to the new user
GRANT ALL PRIVILEGES ON SCHEMA public TO username;
-- Create a new table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT,
    number_of_items INT,
    total_amount INT
);
GRANT ALL PRIVILEGES ON TABLE orders TO username;