# ecmc_avs_fat_sat: Bifrost
This file describes the work flow for commisoing of the stepper of the Bifrost instrument

## Commisioning of one stepper axis:
Each stepper axis needs to be tested separately.

### Motor
1. Connect motor gnd to connector J2 of Technosoft drive (important!!).
2. Connect motor phases to conenctor J2 of Technosoft drive.

[Datasheet: iPOS8020, stepper drive](doc/crate/datasheets/iPOS8020_P029.026.E221.DSH_.10G.pdf)

### Limit switches:
Limits are feed from 24V digital output (EL2819) to 24V digital input (EL1004). There are two jumpers installed in the crate that should be replaced with the actual switches.
1. Connect low limit between output 1 of EL2819 and input 1 of EL1004(replace jumper with switch).
2. Connect high limit between output 2 of EL2819 and input 2 of EL1004 (replace jumper with switch).

[Datasheet: EL2819, 24V output terminal](doc/crate/datasheets/EL2819.pdf)

[Datasheet: EL1004, 24V input terminal](doc/crate/datasheets/EL1004.pdf)


### SSI encoder:

WARNING: The cable with M23 connector is prepared for the target application (AMO sin/cos encoder) and should NOT be connected to the Posital encoder. 

The posital encoder should be connected to CH1 of the EL5002 terminal.

[Datasheet: EL5002, SSI encoder input terminal](doc/crate/datasheets/EL5002.pdf)




### ecmc EPICS ioc
The EtherCAT hardware in the crate is controlled by an [EPICS](https://epics.anl.gov) module called [ecmc](https://github.com/epics-modules/ecmc) and configured through a epics module called [ecmccfg](https://github.com/paulscherrerinstitute/ecmccfg). All needed softwares have already been installed on the controller. 

Notes on motor configuration:
The hardware is currently configured to run a stepper motor in open loop in the unit motor degrees (360 correspons to one rev of the motor). Any gears have not yet been configured. If needed the motion can be configured to any unit or scaling needed. Then please supply information on gears and scalings (from motor axis to the desired unit).

Notes on encoder configuration:
The Posital encoder have not yet been included in the configuration since ESS did not have a encoder of this type. Encoders have been ordered so a configuration file will be available within short. Please contact anders.sandstrom@esss.se for information.

#### Prepare shell
1. Start a new terminal window (press black button ">_" in upper left corner of screen):

![New terminal](doc/gui/newterminal_small.png)

2. Go to the ecmc_avs_fat_sat repo top dir:
```
cd sources/ecmc_avs_fat_sat
```
3. Set paths to EPICS binaries:
```
. /epics/base-7.0.3.1/require/3.1.2/bin/setE3Env.bash

```

![Set e3 environment](doc/gui/e3env_small.png)

#### Start ioc for stepper axis:
An EPICS ioc (input/output controller) needs to be started in order to control the hardware. The "fat_sat.script" file contains configurations of hardware for running a stepper axis with a Stögra motor.
```
iocsh.bash bifrost.script
```

To exit the iocsh (if needed) type "exit" or ctrl-C keys 
```
exit
```

## PYQT GUI
Some instruction on how to start a GUI can be found here:
 [GUI](https://github.com/anderssandstrom/ecmccomgui/blob/master/README_gui.md)
 
### Intressting PVs for use in GUI

Item | Prefix| Pv name | Description
--- | --- | --- | --- |
1 | IOC_TEST: | Axis1  | Motor record for stepper
2 | IOC_TEST: | ec0-s3-EL5002-CH1-PosAct  | SSI terminal ch1 Actual position [raw counts]

## Command line utilities

Data is also accessible through command line tools:

* camonitor <prefix><pv name>       : Continiously print new values of the selected pv when the value changes
 
* caput <prefix><pv name> <value>   : Write value to the  selected pv
 
* caget <prefix><pv name>           : Read value of selected pv 
 
NOTE: These commands are only accesible in a prepared shell (see heading above).
(You need to run this command . /epics/base-7.0.3.1/require/3.1.2/bin/setE3Env.bash in the terminal)
 
Example: Monitoring SSI encoder value
```
camonitor IOC_TEST:ec0-s3-EL5002-CH1-PosAct

IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.907665 750
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.908665 751
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.909665 752
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.910665 753
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.911665 754
...

``` 
