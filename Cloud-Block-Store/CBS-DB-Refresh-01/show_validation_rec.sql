

set feedback off
set lines 120

ALTER SESSION SET nls_date_format = 'DD-Mon-YYYY HH24:MI:SS'
/
ALTER SESSION SET nls_timestamp_format = 'DD-Mon-YYYY HH24:MI:SS.FF3'
/
ALTER SESSION SET nls_timestamp_tz_format = 'DD-Mon-YYYY HH24:MI:SS.FF TZH:TZM'
/

col host_name form a20
col colstr form a60 heading FavoriteColor
col ds form a27  heading time


-- set pages 999
-- set termout on
-- set time on
-- set timing on
-- set feedback on

break on row skip 3

SELECT  substr(i.host_name, 1, instr(i.host_name, '.')-1) host_name,instance_name,
        d.ts,
        random_string
FROM    v$instance i, system.pure_demo_vali_table d
ORDER BY d.ts;

exit

