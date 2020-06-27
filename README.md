# Intro

The main objective of all those scripts is having the complete ledger of Beancount
inserted in a table of a PosgreSQL Database.
The file **import_csv.sh** do:

* Delete (if exist) the old table with all the transactions
* Generate the CSV from the current bean file
* Create the table in the database
* Import the data to the table
* Erase all the spaces in front and behind all the string entries.

You must create a database in Postgres with an user and password and fill all the variables at beginnig of the file.

To avoid having to give the password all time, create the file ~/.pgpass and
Input your information in the following format:

    hostname:port:database:username:password

Do not add string quotes around your field values.
You can also use * as a wildcard for your port/database fields.

You must chmod 0600 ~/.pgpass in order for it to not be silently ignored by psql.
