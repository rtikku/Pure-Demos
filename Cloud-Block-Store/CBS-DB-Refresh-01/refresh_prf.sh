#!/bin/bash

## ssh should be setup for password less login
## on the target, os login user should have its profile set in .bashrc (non-interactive login) 


# Site-Specific


export ORACLE_SID=VISPRF
export MOUNT_POINT_DATA=/d07
export MOUNT_POINT_FRA=/d08

export ORACLE_HOME=/u01/oracle/VIS/12.1.0

export FLASH_ARRAY_PREM=sn1-x10r2-d01-17
export FLASH_ARRAY_CBS=10.0.3.136
export FA_USER=cbsdemo
export FA_PASS=cbsdemo

export SUFFIX=$1

export PG_NAME_SRC=oracle-rt-ebiz-02-VISPROD-PG

export SRC_NAME_PTRN=ebiz-02-VISPROD
export TGT_NAME_PTRN=ebiz-05-${ORACLE_SID}




sqlplus -s / as sysdba << EOF

shutdown immediate;

EOF

sdate=$(date +"%s")

sudo umount $MOUNT_POINT_DATA
sudo umount $MOUNT_POINT_FRA

./copypg.py --prem-array-name $FLASH_ARRAY_PREM --cbs-array $FLASH_ARRAY_CBS --user $FA_USER --password $FA_PASS --srcPG $PG_NAME_SRC --debug Y  --suffix $SUFFIX --src-name-pattern $SRC_NAME_PTRN --tgt-name-pattern $TGT_NAME_PTRN


sudo mount $MOUNT_POINT_DATA
sudo mount $MOUNT_POINT_FRA


mv ${MOUNT_POINT_DATA}/oracle/VISPROD ${MOUNT_POINT_DATA}/oracle/$ORACLE_SID


mkdir -p ${MOUNT_POINT_FRA}/oracle/${ORACLE_SID}/data
mkdir -p ${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/12.1.0/admin/${ORACLE_SID}

mkdir -p ${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/control
mkdir -p ${MOUNT_POINT_FRA}/oracle/${ORACLE_SID}/control




sqlplus -s / as sysdba << EOF

startup nomount 
-- @/home/oracle/cbsdemo/cr_ctrl_visdev.sql
CREATE CONTROLFILE SET DATABASE "${ORACLE_SID}" RESETLOGS  NOARCHIVELOG
    MAXLOGFILES 32
    MAXLOGMEMBERS 5
    MAXDATAFILES 512
    MAXINSTANCES 8
    MAXLOGHISTORY 1530
LOGFILE
  GROUP 1 '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/log3.dbf'  SIZE 300M BLOCKSIZE 512,
  GROUP 2 '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/log2.dbf'  SIZE 300M BLOCKSIZE 512,
  GROUP 3 '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/log1.dbf'  SIZE 300M BLOCKSIZE 512
-- STANDBY LOGFILE
DATAFILE
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys2.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys3.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys4.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys5.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys6.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys7.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys8.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys9.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys10.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sys11.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sysaux01.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/sysaux02.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/system12.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/system13.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/system14.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/undotbs001.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/omo1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/archive1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/undotbs002.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/undotbs003.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/apps_ts_interface.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/media1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/media2.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/media3.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/nologging1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/nologging3.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/queues1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/queues2.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/reference1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/reference2.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/summary1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/summary2.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/summary3.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/summary4.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/summary5.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/summary6.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/summary7.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data2.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data3.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data4.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data5.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data6.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data7.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data8.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data9.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data10.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data11.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data12.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data13.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data14.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data15.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data16.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data17.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data18.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data19.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data20.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data21.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data22.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data23.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data24.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data25.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data26.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_data27.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx2.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx3.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx4.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx5.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx6.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx7.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx8.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx9.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx10.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx11.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx12.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx13.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx14.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx15.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx16.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx17.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx18.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx19.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx20.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/tx_idx21.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/system15.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/system16.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/system17.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/system18.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/system19.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/system20.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/ctx1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/a_ref03.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/dcm.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/a_ref04.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/a_ref05.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/dm_olaptrain_arc.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/opmtr01.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/odm.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/owb1.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/owb2.dbf',
  '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/xdb01.dbf'
CHARACTER SET AL32UTF8;
recover database using backup controlfile until cancel;
${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/log1.dbf
alter database open resetlogs;

  
ALTER TABLESPACE TEMP ADD TEMPFILE '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/temp01.dbf'
     SIZE 2000M REUSE AUTOEXTEND OFF;
ALTER TABLESPACE TEMP ADD TEMPFILE '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/temp02.dbf'
     SIZE 2000M REUSE AUTOEXTEND OFF;
ALTER TABLESPACE TEMP ADD TEMPFILE '${MOUNT_POINT_DATA}/oracle/${ORACLE_SID}/data/temp0001.dbf'
     SIZE 1048576000  REUSE AUTOEXTEND OFF;


@show_space


EOF



edate=$(date +"%s")

./show_validation_rec.sh ${ORACLE_SID}


echo " "
date "+%m/%d/%Y %H:%M:%S"
echo " "
echo " "
echo " "
ddiff=$(($edate-$sdate))
echo "Total Time: $(($ddiff / 60)) minutes and $(( $ddiff % 60 )) seconds"
echo " "
echo " "

