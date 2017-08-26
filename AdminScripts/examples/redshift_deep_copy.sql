--
--Performs a "deep copy" to re-sort table and purge deleted rows
--

--Load into temp table and then swap out with destination table
create table schema_name.new_table (like schema_name.old_table);
insert into schema_name.new_table
select * from schema_name.old_table;

-- Swap the tables out
drop table schema_name.old_table;
alter table schema_name.new_table rename to schema_name.old_table;

--Put the grants back
alter table schema_name.old_table owner to proper_owner_name;
--Grant access to appropriate users
--grant all on schema_name.old_table owner to proper_owner_name;

--Update stats
analyze schema_name.old_table;

