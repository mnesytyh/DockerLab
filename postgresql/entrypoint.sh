#!/bin/bash

function postgres_start()
{
    pg_ctlcluster 15 main start
    until pg_isready -h localhost -p 5432
    do
        echo "Waiting for PostgreSQL to start..."
        sleep 1
    done
    echo "PostgreSQL has been initialized."    
}

if test -z "$(ls -A /var/lib/postgresql)"; then
    pg_createcluster 15 main 
    postgres_start
    psql -c "CREATE DATABASE wiki;"
    psql -c "CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD';            
            CREATE USER wikijs WITH PASSWORD 'wikijsrocks';
            GRANT ALL PRIVILEGES ON DATABASE wiki TO wikijs;
            ALTER DATABASE wiki OWNER TO wikijs;"
else
    postgres_start
fi
tail -f /dev/null


