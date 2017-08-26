--
--  Redshift utility queries
--

-- What is currently running
select *,duration/60000000 as minutes
from stv_recents;


-- Table definition, including distribution, sortkey, and compression
set search_path to reporting,transform,ingest;
SELECT
 p.tablename
 ,p.column
 ,p.encoding
 ,p.type
 ,p.distkey
 ,p.sortkey
 ,p.notnull
FROM pg_table_def p
WHERE tablename ='omn_traffic_browser_agg_2017_06'
and schemaname='ingest'
order by tablename,"column"
;

-- View load errors
select * from stl_load_errors
order by starttime desc

-- View locks
select * from stv_locks sl
inner join  svv_table_info sti on sl.table_id=sti.table_id

-- Disk usage for a table
-- Updated as table loads so you can see progress
set search_path to reporting,transform;
show search_path;
select trim(name) as tablename, slice, col, sum(num_values) as rows
from svv_diskusage
where name='omn_traffic_browser_agg_2017_06'
and col=0
group by 1,2,3
order by 1,2,3;

--Disk usage for cluster
--Includes space reserved for Redshift overhead
select
  sum(capacity)/1024 as capacity_gbytes,
  sum(used)/1024 as used_gbytes,
  (sum(capacity) - sum(used))/1024 as free_gbytes
from
  stv_partitions where part_begin=0;

-- Disk usage by disk
select owner, host, diskno, used, capacity,
(used-tossed)/capacity::numeric *100 as pctused 
from stv_partitions order by owner;

--Tables with unsorted region > 10%
select * from SVV_TABLE_INFO where unsorted > 10