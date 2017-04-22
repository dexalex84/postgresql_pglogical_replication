create or replace function public.sp_update_table ()
returns int
as
$BODY$
declare v_insert_upd_ver float :=0;
declare v_i_name int :=0;
declare chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';				
declare v_j int:=0;
declare v_j_max int:=0;
declare v_age int:=0;
declare v_max_num int:=0;
declare v_tabnum character varying(100);
declare v_ver float:=0;
declare v_id int:=0;
declare v_count_rows int:=0;
begin
	drop table if exists tt_names ;
	create temp table tt_names (id serial,name character varying(100), sex char(1));

	insert into tt_names (name,sex)
	select 'alex','m'
	union 
	select 'paul','m'
	union 
	select 'dron','m'
	union 
	select 'cathrine','f'
	union 
	select 'max','m'
	union 
	select 'josh','m'
	union 
	select 'john','m'
	union 	
	select 'arnold','m'
	union 		
	select 'mila','f'
	union 		
	select 'mary','f'		
	union 		
	select 'kira','f'	
	union 	
	select 'alexis','f';

	v_i_name:=ceil(random()*8);
	v_age:=ceil(random()*80);

	v_max_num:= (select max(id) from public.person);
	v_count_rows:=(select count(*) from public.person);
	v_id:=ceil( random() * v_max_num );
	raise notice 'v_max_num= %,v_count_rows=%,v_id=%',v_max_num,v_count_rows,v_id;
	-- generate v_tabnum
	v_j_max := ceil( random() * 10 );
	v_tabnum:='';
	
	for v_j in 1..v_j_max loop
		v_tabnum = v_tabnum || chars[1+random()*(array_length(chars, 1)-1)];
	end loop;

	v_ver := random();
	if v_ver < 0.33 and v_count_rows<>0 then 
		-- update row
		update public.person
		set name = (select name from tt_names where id = v_i_name limit 1)
		    ,age = v_age
		    ,sex = (select sex from tt_names where id = v_i_name limit 1)
		    ,tabnum = v_tabnum 
		where id = v_id;
		raise notice 'update row v_ver= %, v_id= %',v_ver,v_id;
	elsif ( v_ver>= 0.33 and v_ver < 0.8 ) or v_count_rows=0 then 
		-- insert row
		insert into public.person (id, name, age, sex, tabnum)
		select 
		     coalesce(v_max_num,0) + 1
		    ,(select name from tt_names where id = v_i_name limit 1)
		    ,v_age
		    ,(select sex from tt_names where id = v_i_name limit 1)
		    ,v_tabnum;
		-- delete row
		raise notice 'insert row v_ver= %',v_ver;
	elsif v_ver>=0.8 and v_ver<0.97 and v_count_rows<>0 then
		delete from public.person where id = v_id;
		raise notice 'delete row v_ver= %, v_id%= ',v_ver,v_id;
	else
		--truncate public.person;
		--raise notice 'truncate row v_ver= %',v_ver;
                raise notice 'skip truncate!! TODO';

	
	end if;

	
	PERFORM pg_sleep(1);

	return 0;
end
$BODY$
language 'plpgsql';

