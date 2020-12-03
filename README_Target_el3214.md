# ecmc_avs_fat_sat: Add EL3214 PT100 terminal
This file describes the work flow for adding a EL3214 terminal to the test box.

## El3214
EL3214 is a 4 channel analog input for PT100 sensors (and PT1000, and more...):
* Sensor:  PT100 sensors (default)
* Resolution: 0.1 degC
* Connection: 3-wire

[Datasheet: EL3214](doc/crate/datasheets/EL3214.pdf)

## Mounting EL3214 in the test crate box
The EL3214 needs to be mounted right beside the EL7201 in the far right end the etehrcat terminals. The terminal needs to be slided into place. Look in the manuals if not sure how to proceed:
[EL32XX manual](https://download.beckhoff.com/download/document/io/ethercat-terminals/el32xxen.pdf)

## Connecting a sensor to EL3214
The terminal supports 3-wire sensors. If the sensors that should be connected are of type 4-wire, then one wire should not be connected (see datasheet for more info).

## Adding EL3214 to the ecmc config
1. Go to the ecmc_avs_fat_sat repo top dir:
```
cd sources/ecmc_avs_fat_sat
```
2. Make a backup/copy of your current startupfile (if you use other file then backup that file instead):
```
cp target.script target_el3214.script
```
3. Open file for editing
```
code-oss target_el3214.script
```
4. Add config for EL3214 after config of EL7201 and update drive slave index to 7:

```
...
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "5")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=$(ECMC_EC_SLAVE_NUM), HW_DESC=EL7201"

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Add EL3214 here:
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "6")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=$(ECMC_EC_SLAVE_NUM), HW_DESC=EL3214"
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Modify drive slave number to 7 (since it have now moved one position in the chain):
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "7")
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
epicsEnvSet("ECMC_EC_SLAVE_NUM_DRIVE",        "$(ECMC_EC_SLAVE_NUM)")
....
```

The result should look like this roughly:
[target_el3214.script](target_el3214.script)

5. Set paths to EPICS binaries:
```
. /epics/base-7.0.3.1/require/3.1.2/bin/setE3Env.bash
```

6. start ioc to test that the config works:
```
iocsh.bash target_el3214.script
```

7. List EL3214 records (in the iocsh terminal):
```
dbgrep *EL3214*

```

### Intressting PVs for use in GUI

many records/PVs are added. The below table only show the most intressting:

Item | Prefix| Pv name | Description
--- | --- | --- | --- |
1 | IOC_TEST: | ec0-s6-EL3214-AI1  | Channel 1 temperture [degC]
2 | IOC_TEST: | ec0-s6-EL3214-AI1  | Channel 1 temperture [degC]
3 | IOC_TEST: | ec0-s6-EL3214-AI1  | Channel 1 temperture [degC]
4 | IOC_TEST: | ec0-s6-EL3214-AI1  | Channel 1 temperture [degC]

These PV:s can be monitored with the ecmccomgui tool or classical camonitor commands (see other readmes for details). 
