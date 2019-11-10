#!/bin/bash

## ssh should be setup for password less login
## on the target, os login user should have its profile set in .bashrc (non-interactive login) 


# Site-Specific

export ORACLE_DBNAME_SRC=VIS
export ORACLE_SID_SRC=VIS
export ORACLE_HOME_SRC=/u01/oracle/VIS/12.1.0

export ORACLE_DBNAME_TGT=VIS
export ORACLE_SID_TGT=VIS
export ORACLE_HOME_TGT=/u01/oracle/VIS/12.1.0

export DB_HOST_TGT=10.0.3.105

export DB_HOST_USER_TGT=oracle

export DB_PORT_TGT=1521

export DB_USER_TGT=apps

export DB_PASS_TGT=apps


#export FLASH_ARRAY=10.21.121.26
export FLASH_ARRAY=10.0.3.136
export FA_USER=cbsdemo

export PG_NAME_SRC=oracle-rt-ebiz-02-PG
export PG_NAME_TGT=oracle-rt-ebiz-04-PG

#export MOUNT_POINT_LIST_SRC="/u02"
export MOUNT_POINT_LIST_TGT="/d01,/d02"







./shutdown.sh 


for i in $(echo ${MOUNT_POINT_LIST_TGT} | sed "s/,/ /g")
do
  ssh -l root ${DB_HOST_TGT}  umount "$i"

done




