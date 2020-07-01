#!/bin/python3

# Script to import the file prices.bean into a table in PostgreSQL
# Run the script to:
#   * Delete (if exist) the old table with all the values
#   * Create the table in the database
#   * Import the data to the table
#   * Done ;-)

# To avoid having to give the password all time, create the file ~/.pgpass.
# Input your information in the following format: hostname:port:database:username:password
# Do not add string quotes around your field values.
# You can also use * as a wildcard for your port/database fields.
# You must chmod 0600 ~/.pgpass in order for it to not be silently ignored by psql.


import psycopg2
import psycopg2.extras

FILE = "prices.bean"
HOST = '123.123.123.123'
DB = 'db_in_postgresql'
DB_USER = 'user_in_postgresql'
TABLE = 'prices'
PASS = "my_very_secret"
PORT = "5432"

# avoid getting empty lines from the file


def lines_not_empty(f):
    for li in f:
        line = li.rstrip()
        if line:
            yield line


try:
    connection = psycopg2.connect(
        user=DB_USER,
        password=PASS,
        host=HOST,
        port=PORT,
        database=DB,
    )
    # Connect to the database
    cursor = connection.cursor()

    # Delete and create the new table
    sql_drop = f"DROP TABLE IF EXISTS {TABLE};"
    cursor.execute(sql_drop)

    sql_create = f"CREATE TABLE {TABLE}(date DATE, item VARCHAR, price NUMERIC, currency VARCHAR);"
    cursor.execute(sql_create)

    with open(FILE) as fp:
        for line in lines_not_empty(fp):
            field = line.split()
            date = field[0]
            item = field[2]
            price = field[3]
            currency = field[4]
            sql_insert = f"INSERT INTO {TABLE}(date, item, price, currency)\
                VALUES('{date}','{item}','{price}','{currency}');"
            cursor.execute(sql_insert)

    # Commit the changes
    connection.commit()

except (Exception, psycopg2.Error) as error:
    print("Error while connecting to PostgreSQL", error)
finally:
    # closing database connection.
    if connection:
        cursor.close()
        connection.close()
        # print("PostgreSQL connection is closed")
