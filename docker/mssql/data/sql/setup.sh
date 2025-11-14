#!/bin/bash
# Setup script for SQL Server database initialization

echo "Waiting for SQL Server to start..."
sleep 30

echo "Creating database..."
docker compose exec -T mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'MyStrongPass123!' -Q "CREATE DATABASE testdb;"

if [ $? -eq 0 ]; then
    echo "Database created successfully"

    echo "Loading sample data..."
    docker compose exec -T mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'MyStrongPass123!' -d testdb -i /docker-entrypoint-initdb.d/init.sql

    if [ $? -eq 0 ]; then
        echo "Sample data loaded successfully"

        echo "Verifying data..."
        docker compose exec -T mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'MyStrongPass123!' -d testdb -Q "SELECT COUNT(*) AS TotalDocuments FROM documents;"

        echo "Setup completed!"
    else
        echo "Failed to load sample data"
        exit 1
    fi
else
    echo "Failed to create database"
    exit 1
fi
