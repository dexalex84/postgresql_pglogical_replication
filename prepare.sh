echo create DB on source and dest servers
./init_dbs.sh

echo create table "public.person" on source and dest servers
./create_objects.sh

echo init publisher / subscription
./create_sync.sh

echo create function "public.sp_update_table ()" on source
docker cp create_function.sql db_source:/tmp
docker-compose exec  --user postgres db_source psql -d db -f /tmp/create_function.sql
