#!/bin/bash
set -e

export DB_USER
export DB_PASS

# Ensure required environment variables are set
if [[ -z "$POSTGRES_USER" || -z "$POSTGRES_DB" || -z "$DB_USER" || -z "$DB_PASS" ]]; then
    echo "Error: Required environment variables are not set."
    exit 1
fi

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS orders;
    CREATE USER username WITH ENCRYPTED PASSWORD 'password';
    GRANT ALL PRIVILEGES ON DATABASE orders TO username;
    GRANT ALL PRIVILEGES ON SCHEMA public TO username;
    CREATE TABLE IF NOT EXISTS orders (
        id SERIAL PRIMARY KEY,
        user_id INT,
        number_of_items INT,
        total_amount INT
    );
    GRANT ALL PRIVILEGES ON TABLE orders TO username;
    GRANT ALL ON SEQUENCE orders_id_seq TO username;
EOSQL
