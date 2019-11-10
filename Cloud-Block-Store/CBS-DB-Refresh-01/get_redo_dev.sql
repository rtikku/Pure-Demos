set echo off
set feed off
set term off
set head off
set pages 0
col fn format a35 heading 'File Name'
col status format a8
col sq format 99999 heading 'Seq#'
spool reco.gsql

select 'recover database until cancel using backup controlfile;' from dual;
 select substr(f.member,1,instr(f.member,'prod')-1) ||'dev'||substr(f.member,instr(f.member,'prod')+4) fn
  from v$log l, v$logfile f
 where l.group# = f.group#
   and l.status != 'INACTIVE'
order by first_change#
/
spool off
select 'exit' from dual;
exit
