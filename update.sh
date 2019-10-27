#!/bin/bash
echo "This should set up the psql database with some sample data,"
echo "and allow you to run the API locally"
dropdb lunches; createdb lunches; psql lunches -af source.sql
psql lunches -af load.sql
echo "Database should be made now, access by typing 'psql lunches'"
sudo docker run --name tutorial -p 5433:5432 \
                -e POSTGRES_PASSWORD=mysecretpassword \
                -d postgres
sudo docker cp api-schema.sql  tutorial:/api-schema.sql
sudo docker exec -it tutorial psql -U postgres -f api-schema.sql postgres
echo "API should be set up. Open a new window of terminal"
echo "and run the line './postgrest tutorial.conf' "
echo "It should say 'Attempting to connect to the database... connection successful"
