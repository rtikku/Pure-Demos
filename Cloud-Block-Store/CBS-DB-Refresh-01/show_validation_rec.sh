

export ORACLE_SID=$1

sqlplus -s system/manager @show_validation_rec.sql

