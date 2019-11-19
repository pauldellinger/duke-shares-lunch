#!/bin/bash
echo "This should set up the psql database with some sample data,"
echo "and allow you to run the API"
dropdb lunches; createdb lunches; psql lunches -af build-db.sql
psql lunches -af auth.sql
echo "Database should be made now, access by typing 'psql lunches'"
echo "API should be set up. Open a new window of terminal"
echo "and run the line './postgrest tutorial.conf' "
echo "It should say 'Attempting to connect to the database... connection successful"
