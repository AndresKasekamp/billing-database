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
    CREATE DATABASE orders;
    CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASS';
    GRANT ALL PRIVILEGES ON DATABASE orders TO $DB_USER;
    GRANT ALL PRIVILEGES ON SCHEMA public TO $DB_USER;
    CREATE TABLE orders (
        id SERIAL PRIMARY KEY,
        user_id INT,
        number_of_items INT,
        total_amount INT
    );
    GRANT ALL PRIVILEGES ON TABLE orders TO $DB_USER;
    GRANT ALL ON SEQUENCE orders_id_seq TO $DB_USER;
EOSQL
