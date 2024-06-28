#!/bin/bash
set -e

export DB_USER
export DB_PASS

/etc/init.d/postgresql start

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
    CREATE DATABASE orders;
    CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASS';
    GRANT ALL PRIVILEGES ON DATABASE orders TO $DB_USER;
EOSQL

# Connect to the movies database to create the table
psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "orders" <<-EOSQL
    CREATE TABLE orders (
        id SERIAL PRIMARY KEY,
        user_id INT,
        number_of_items INT,
        total_amount INT
    );
    GRANT ALL PRIVILEGES ON TABLE orders TO $DB_USER;
    GRANT ALL ON SEQUENCE orders_id_seq TO $DB_USER;
EOSQL

/etc/init.d/postgresql stop

exec /usr/lib/postgresql/16/bin/postgres -D /var/lib/postgresql/16/main -c config_file=/etc/postgresql/16/main/postgresql.conf