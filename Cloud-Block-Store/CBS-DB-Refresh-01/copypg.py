#!/usr/bin/python3

import os
import sys
import purestorage
import time
import datetime
import collections
import requests
import argparse
import traceback
import logging
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
#requests.packages.urllib3.disable_warnings()



logging.basicConfig(level=logging.INFO, format='%(levelname)s - %(message)s')


def die(msg):
  print("%s"% msg)
  sys.exit(-1)


def debug(str):
    defaultValue=False
    adebug=args['debug']

    if adebug == None:
        debug=defaultValue
    else:
        if  adebug.lower() == 'y' or adebug.lower() == 'yes' or adebug.lower() == 'true':
            debug= not defaultValue
        else:
            debug = defaultValue

    if debug:
        logging.info(str)

def get_pgroup_snaps(array,pg_name,suffix):

  #debug(pg_name);
  #debug(suffix);
  pgrp_snaps = array.get_pgroup(pg['name'],snap=True)
  #debug(pgrp_snaps)
  for snap in array.get_pgroup(pg['name'],snap=True):
    #debug(snap);
    if snap['name'] == pg_name+'.'+suffix:
      return snap;


def get_vol_for_pg_snap(cbs_array,pgrp_snap):
    tgt_volumes = cbs_array.list_volumes(pending=False,snap=True,pgrouplist=pgrp_snap['name'])
    for tgtvol in tgt_volumes:
       tgt_vol_name = tgtvol.get('name');
       #print(tgt_vol_name)
    return tgt_volumes

def get_volume(volName):
    #debug(volName);
    tgt_volumes = cbs_array.list_volumes(pending=False,snap=True)
    for tgtvol in tgt_volumes:
       #tgt_vol_name = tgtvol.get('name').split(":")[1];
       tgt_vol_name = tgtvol.get('name');
       #print(tgt_vol_name)
       if volName == tgt_vol_name:
         return tgtVol 

if __name__ == "__main__":


    parser = argparse.ArgumentParser(description='Oracle Database Snapshot & Replicate script')


    parser.add_argument('--prem-array-name', help='FlashArray Hostname or IP address', required=True)
    parser.add_argument('--cbs-array', help='FlashArray Hostname or IP address', required=True)
    parser.add_argument('--user', help='Username to connect to the FlashArray', default="pureuser")
    parser.add_argument('--password',help='Password to connect to the FlashArray', action="store", default="pureuser")
    
    parser.add_argument('--src-name-pattern',help='', required=True,action='store')
    parser.add_argument('--tgt-name-pattern',help='', required=True,action='store')

    parser.add_argument('--srcPG',help='Protection Group that makes up source DB', required=True,action='store')
    parser.add_argument('--replicatenow',help='Replicate the snapshot now to the targets', action='store_true')
    
    parser.add_argument('--suffix', help='Optional suffix for Volume snapshot', default="%Y%m%d-%H-%M-%S")
    parser.add_argument("--debug", required=False, help='Debug mode (Y/N) - print debug messages')
    
    args = vars(parser.parse_args())
    #args = parser.parse_args()

    #print args
    
    
    if args['suffix'] == "%Y%m%d-%H-%M-%S":
       sfx=datetime.datetime.fromtimestamp(time.time()).strftime(args['suffix'])
    else:
       sfx=args['suffix']
    
    print("Suffix : {}".format(sfx))

    src_name_pattern=args['src_name_pattern']
    tgt_name_pattern=args['tgt_name_pattern']

    debug("Src Pattern : " + src_name_pattern)
    debug("Tgt Pattern : " + tgt_name_pattern)

    # Connect to CBS Array
    try:
       cbs_array = purestorage.FlashArray(args['cbs_array'],args['user'],args['password'])
       cbs_array_info = cbs_array.get()
       print("")
       print("Connected to array : {}".format(cbs_array_info['array_name']))
       print("")
    
    except ValueError:
      die("Error in connecting to the Array.  Check credentials or the REST version !!")
    except Exception as err:
      print("Error in connecting to the Array!! ")
      die(err)
    
    
    
    # Extract Source Volumes
    try:
       #spg = cbs_array.get_pgroup(args['srcPG']);
       #srcVols = spg['volumes']
       for pg in cbs_array.list_pgroups(pending=True, filter="name='{}:{}'".format(args['prem_array_name'],args['srcPG'])):
       #for pg in cbs_array.list_pgroups(pending=True ):
           #print(pg)
           #pgrp_snaps = cbs_array.get_pgroup(pg['name'],snap=True)
           pgrp_snap = get_pgroup_snaps(cbs_array,pg['name'],sfx)
           print ("PG Snap : {}".format(pgrp_snap))
     
           vol_in_pg_snap_list = get_vol_for_pg_snap(cbs_array,pgrp_snap)
           #debug(vlist)



           # for each volume in snapshot, copy it with overwrite option

           for vol in vol_in_pg_snap_list:
             print ("Copying Volume : {}".format(vol['name'])) 
             print("")
             print("")

             local_vol_name = vol['name'].split('.')[2].replace(src_name_pattern,tgt_name_pattern)
             
             #print ("Local Vol Name : {}".format(local_vol_name))
             cbs_array.copy_volume(vol['name'],local_vol_name,overwrite=True)
             print("")
             print("")

    
    except Exception as err:
       print("Source Protection Group Error !!")
       print(traceback.format_exc())
       die(err)
    
    #for vol in srcVols:
    #    print "%s" % vol
    print("Snapshot Date : %s"%  datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S"))
    
    print("")
    print("") 
    
    cbs_array.invalidate_cookie()

