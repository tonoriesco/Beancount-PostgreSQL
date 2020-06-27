#!/bin/bash

# Create a database in Postgres with an user and password.
# Run the script to:
#   * Delete (if exist) the old table with all the transactions
#   * Generate the CSV from the current bean file
#   * Create the table in the database
#   * Import the data to the table
#   * Erase all the spaces in front and behind all the string entries.
#   * Done ;-)

# To avoid having to give the password all time, create the file ~/.pgpass. 
# Input your information in the following format: hostname:port:database:username:password 
# Do not add string quotes around your field values. 
# You can also use * as a wildcard for your port/database fields.
# You must chmod 0600 ~/.pgpass in order for it to not be silently ignored by psql.

HOST='123.123.123.123'
DB='db_in_postgresql'
DB_USER='user_in_postgresql'
TABLE='bean'
CSV_FILE='main.csv'
BEAN_FILE='main.bean'


# Delete the old DB

psql -h $HOST -d $DB -U $DB_USER -c "DROP TABLE IF EXISTS $TABLE CASCADE;"

# Generate CSV
bean-query -f csv  -o $CSV_FILE $BEAN_FILE 'select date, payee, narration, account, number, currency, tags'

# Create tabla bean
psql -h $HOST -d $DB -U $DB_USER -c "CREATE TABLE $TABLE(
    date DATE, 
    payee VARCHAR,  
    narration VARCHAR, 
    account VARCHAR, 
    number real, 
    currency VARCHAR, 
    tags VARCHAR 
);"

# Import the data to the postgress database
cat $CSV_FILE | psql -h $HOST -d $DB -U $DB_USER -c "COPY $TABLE FROM STDIN WITH DELIMITER AS ',' CSV HEADER;"

# Erase all the spaces leading and trailing
psql -h $HOST -d $DB -U $DB_USER -c "
UPDATE $TABLE
SET 
    payee = TRIM (payee),
    narration = TRIM (narration),
    account = TRIM (account),
    currency = TRIM (currency),
    tags = TRIM (tags)

;"
