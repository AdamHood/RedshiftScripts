/* Look for tables that need to be "analyze"d and generate the necessary statements
*/

SELECT database, schema || '.' || "table" AS "table", stats_off, 'analyze ' || schema."table" || ';' as query
FROM svv_table_info 
WHERE stats_off > 5 
ORDER BY 2;