#!/bin/bash
 run_count=3600
 i=0
 iteration=0
 
 for i in $( eval echo {1..$run_count} )
 do
    iteration=$((iteration + 1))
    echo running function public.person_update iteration: $iteration
    docker-compose exec --user postgres db_source psql -d db -c 'select public.sp_update_table();'
 done
