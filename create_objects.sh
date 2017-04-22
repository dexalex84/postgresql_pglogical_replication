# create table in source db
docker-compose exec --user postgres db_source psql -d db -c "\
create table if not exists public.person \
(                                        \
	id serial primary key,               \
	name character varying(100),         \
	age int,                             \
	sex char(1),                         \
	tabnum character varying(10)         \
);"

# create table in dest db
docker-compose exec --user postgres db_dest psql -d db -c "\
create table if not exists public.person \
(                                        \
	id serial primary key,               \
	name character varying(100),         \
	age int,                             \
	sex char(1),                         \
	tabnum character varying(10)         \
);"

 # insert data to db_source 
 docker-compose exec --user postgres db_source psql -d db -c "
 insert into public.person (name, age, sex, tabnum)     
 select  						 
	'alex',33,'m','qwerty' 				
 union all					 	
 select  					 	
	'paul',55,'m','1234'	 			
 union all					 	
 select  					 	
	'dron',44,'m','qwerty'	 			
 union all					 	
 select                                                 
	'cathrine',28,'f','9999'; "

 # create foreign data wrapper on dest for table public.person for better testing

 docker-compose exec --user postgres db_dest psql -d db -c "
 CREATE EXTENSION postgres_fdw; "

 docker-compose exec --user postgres db_dest psql -d db -c "
 CREATE SERVER db_source_server
        FOREIGN DATA WRAPPER postgres_fdw
        OPTIONS (host 'db_source', port '5432', dbname 'db'); "

 docker-compose exec --user postgres db_dest psql -d db -c "
 CREATE FOREIGN TABLE public.db_source_person (
        id int,
	name character varying(100),
	age int,
	sex char(1),
	tabnum character varying(10) 
 )
        SERVER db_source_server
        OPTIONS (schema_name 'public', table_name 'person');"

 docker-compose exec --user postgres db_dest psql -d db -c "
 CREATE USER MAPPING FOR postgres
        SERVER db_source_server
        OPTIONS (user 'postgres', password 'postgres');"
 
