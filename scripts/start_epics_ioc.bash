#!/usr/bin/env bash
#
#   author  : Anders Sandström
#   email   : anders.sandstrom@esss.se
#   date    : Thursday, June 25, 2020
#   version : 0.0.1

# Set vars
cd
. /epics/base-7.0.3.1/require/3.1.2/bin/setE3Env.bash 
cd ~/sources/ecmc_avs_fat_sat

# Start ioc
iocsh.bash fat_sat.script 
