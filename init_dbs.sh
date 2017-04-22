#!/bin/bash
# create source database 
docker-compose exec --user postgres db_source psql -c "create database db;"
# create dest database 
docker-compose exec --user postgres db_dest psql -c "create database db;"
