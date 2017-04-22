# init source 
# create extension pglogical
docker-compose exec --user postgres db_source psql -d db -c " CREATE EXTENSION pglogical; "
	
# create pglogical node 
docker-compose exec --user postgres db_source psql -d db -c " SELECT pglogical.create_node( 
    node_name := 'provider1',
    dsn := 'host=db_source port=5432 dbname=db'
); "

## DEBUG!!  docker-compose exec --user postgres db_source psql -d db -c " SELECT pglogical.create_replication_set( 'new_set', true, true, true, true); "

# set objects for replication 
docker-compose exec --user postgres db_source psql -d db -c " SELECT pglogical.replication_set_add_all_tables('default', ARRAY['public']); "

# init dest 
# create extension pglogical
docker-compose exec --user postgres db_dest psql -d db -c " CREATE EXTENSION pglogical; "

# create pglogical node 
docker-compose exec --user postgres db_dest psql -d db -c " 
SELECT pglogical.create_node(
    node_name := 'subscriber1',
    dsn := 'host=db_dest port=5432 dbname=db'
); "

# create subscription 
docker-compose exec --user postgres db_dest psql -d db -c " 
SELECT pglogical.create_subscription(
    subscription_name := 'subscription1',
    provider_dsn := 'host=db_source port=5432 dbname=db'
); "

