# PostgreSQL to PostresSQL streaming replication via pglogical by 2ndquadrant

## This docker-compose project:
1) creates 2 PostgreSQL server "db_source" and "db_dest" and database with name "db"
2) creates table public.person with fields:
	```id serial primary key,
	name character varying(100),
	age int,
	sex char(1),
	tabnum character varying(10)```
3) creates function for updating data on source
4) creates and initialize publish / subscription replication between servers via pglogical extension on both servers
5) starts updating source
6) u can see how data changes on dest DB

## Installation
1) run: docker-compose up -d
2) wait about 2 minutes until see rows:

  ```< SOME DATE UTC > LOG:  redirecting log output to logging collector process  ```
  ```< SOME DATE UTC > HINT:  Future log output will appear in directory "pg_log".```

  in db_source log (run: ```docker-compose logs -f db_source``` to see log )
3) run: ./prepare.sh
4) run: ./start_update_source.sh
5) connect to <host ip>:5442 via pgAdmin or psql
   run:
   ```select 'SRC' src,* from public.db_source_person order by id;
	  select 'DST' src,* from public.person order by id;```

## Problems
 Found that replication of truncate command is not working, therefore this type of changing source is disabled now
