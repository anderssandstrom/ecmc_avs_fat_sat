# ecmc_avs_fat_sat: Bifrost
This file describes the work flow for commisoing of the stepper of the Bifrost instrument

## Commisioning of one stepper axis:
Each stepper axis needs to be tested separately.

### Motor
1. Connect motor gnd to connector J2 of Technosoft drive (important!!).
2. Connect motor phases to conenctor J2 of Technosoft drive.

[Datasheet: iPOS8020, stepper drive](doc/crate/datasheets/iPOS8020_P029.026.E221.DSH_.10G.pdf)

Also see cabling [Cabling details](doc/bifrost/N056_AVS_cabling_proposal_V2.pdf).

#### Change motor current
The delivery state setting of the motor current is 5A. Measurement of the actual current showed that a setting of 12A approx corresponds to actual current of 10A RMS.

The current can be changes by updating the ECMC_EC_DRIVE_CURRENT variable in the [bifrost.script](bifrost.script) file or [bifrost_posital.script](bifrost_posital.script). 

NOTE: The current can only be changed in integer steps of Amps int the range 2A..17A.

Example: Set current to 7A
```
# Several current settings are available for this motor (2A..17A). Motor max current is 12A RMS
# NOTE: Setting 12A results in approx 10A RMS current (measured with current clamps and scope)
epicsEnvSet("ECMC_EC_DRIVE_CURRENT",          "7")     # Set current in Amps here (only integers)

```
WARNING: Be sure to not set a higher current than what the motor is rated for otherwise it might overheat. 

NOTE: After updating any of the [bifrost.script](bifrost.script) or [bifrost_posital.script](bifrost_posital.script) files, the EPICS ioc needs to be restarted in order to load the new settings.

### Limit switches:
Limit (S2, S4) and Kill switches (S1, S5) are fed from 24V digital outputs (EL2819) to 24V digital inputs (EL1004) by wiring two switches cables coming from box 1 and 2.  For the FAT the actual Kill switches from box 1 need to be wired to the Limit Switches inputs to allow for the move over the full travel range between the two kill switches. The real limit switches are connected to additional inputs just for the reading of the switching position. Movements beyond the kill switches to the mechanical end stop need to be performed with bridged switches input (bridges either in the switches boxes on the detector or in the control box). Machine safety will be ensured by Emergency Stop buttons.

Currently there are two jumpers installed in the crate that should be replaced with the actual switches by connecting the cables from the boxes:
	1.	Connect the +24V of the cable from box 1 (Kill switches) to the output 1 of EL2819
	2.	Connect low limit function (i.e. kill switch -, S5) to input 1 of EL1004.
	3.	Connect high limit function (i.e. kill switch +, S1) to input 2 of EL1004.
	4.	Use output 2 of EL2819 and inputs 3 and 4 of EL1004 to connect the real limit switches S4 and S2 through the switches cable from box 2

[Datasheet: EL2819, 24V output terminal](doc/crate/datasheets/EL2819.pdf)

[Datasheet: EL1004, 24V input terminal](doc/crate/datasheets/EL1004.pdf)

[Limit switches E-plan](doc/bifrost/N056_Switches_Mod_V1.pdf)

Also see cabling [Cabling details](doc/bifrost/N056_AVS_cabling_proposal_V2.pdf).
 
### SSI encoder:

WARNING: The cable with M23 connector is prepared for the target application (AMO sin/cos encoder) and should NOT be connected to the Posital encoder.

For the POSITAL SSI encoder a dedicated cable with M23 connector needs to be connected to the Beckhoff terminals:
	1.	Connect encoder signals to CH1 of the EL5002 terminal
	2.	Connect +24V of the encoder to output 3 of EL2819
	3.	Connect 0V and the DIR and RESET inputs to pin 3, 4 and 5 of EL9189

[Datasheet: EL5002, SSI encoder input terminal](doc/crate/datasheets/EL5002.pdf)

Also see cabling [Cabling details](doc/bifrost/N056_AVS_cabling_proposal_V2.pdf).

### Cabling details:

[Cabling details](doc/bifrost/N056_AVS_cabling_proposal_V2.pdf)


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
An EPICS ioc (input/output controller) needs to be started in order to control the hardware. The "bifrost.script" file contains configurations of hardware for running a stepper axis in open loop with a Stögra motor.
```
iocsh.bash bifrost.script
```

In the above script the SSI encoder is not configured (since we had no posital encoder available at the time of shipment of the crate). After reciveing a posital encoder the "bifrost_posital.script" was generated (also open loop stepper but encoder value can be read through pv "IOC_TEST:ec0-s3-EL5002-CH1-PosAct").

NOTE: The "bifrost_posital.script" is not tested on the real crate (but should work anyway).

```
iocsh.bash bifrost_posital.script
```

To exit the iocsh (if needed) type "exit" or ctrl-C keys 
```
exit
```

## Start ioc for stepper, encoder and output trigger
A new startup script [bifrost_posital_trigg.script](bifrost_posital_trigg.script) have been added. This script includes the same settings as [bifrost_posital.script](bifrost_posital.script) but also includes some [PLC-code](plc/trigg.plc) for triggering of external position measurement equipment (laser tracker). The PLC-code sets an output trigger when the motion axis passes a predefined posiiton of the Posital SSI encoder (in any direction).

NOTE: An over/underflow of the encoder signal will not result in any trigger, therefore can the predefined trigger position not be 0 or 2^30.

The EPICS IOC with trigger functionalities can be started by the following command:
```
iocsh.bash bifrost_posital_trigg.script
```

The predefined position can be set by writing to the "IOC_TEST:Set-TriggPos1-RB" pv.

Example: Write 1000 to trigger position by cmd line tools (see below for cmd line tool instructions):
```
 caput IOC_TEST:Set-TriggPos1-RB 1000
```
Note: You can also use GUI with the follwing info (see below for GUI instructions):
* prefix = "IOC_TEST:" 
* pvname = "Set-TriggPos1-RB"

Method:
In order to minimize the effects of jitter due to sampling rate it's a good idea to make tests from both motion directions and average the two readings of the external position measurement equipment. This would cancel out jitter from the EtherCAT bus cycle (4ms delays).

## PYQT GUI
Some instruction on how to start a GUI can be found here:
 [GUI](https://github.com/anderssandstrom/ecmccomgui/blob/master/README_gui.md)
 
### Intressting PVs for use in GUI

Item | Prefix| Pv name | Description
--- | --- | --- | --- |
1 | IOC_TEST: | Axis1  | Motor record for stepper
2 | IOC_TEST: | ec0-s3-EL5002-CH1-PosAct  | SSI terminal ch1 Actual position [raw counts]
3 | IOC_TEST: | ec0-s1-EL1004-BI1  | Digital input 1 for switches []
4 | IOC_TEST: | ec0-s1-EL1004-BI2  | Digital input 2 for switches []
5 | IOC_TEST: | ec0-s1-EL1004-BI3  | Digital input 3 for switches []
6 | IOC_TEST: | ec0-s1-EL1004-BI4  | Digital input 4 for switches []
7 | IOC_TEST: | Axis1-PosAct       | Open loop step counter [deg]

All accesible PVs are listed in: [PVs](pvs.log)

## Command line utilities

Data is also accessible through command line tools:

* camonitor <prefix><pv name>       : Continiously print new values of the selected pv when the value changes
 
* caput <prefix><pv name> <value>   : Write value to the  selected pv
 
* caget <prefix><pv name>           : Read value of selected pv 
 
All accesible PVs are listed in: [PVs](pvs.log)

NOTE: These commands are only accesible in a prepared shell (see heading above). You need to run this command in a new terminal:

```
. /epics/base-7.0.3.1/require/3.1.2/bin/setE3Env.bash

```

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
Example: Monitoring SSI encoder value and a switch (BI1)
```
camonitor IOC_TEST:ec0-s3-EL5002-CH1-PosAct IOC_TEST:ec0-s1-EL1004-BI1

IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.907665 750
IOC_TEST:ec0-s1-EL1004-BI1 2020-09-29 16:19:49.907665 1
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.908665 751
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.909665 752
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.910665 753
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.911665 754
...

``` 
Example: Monitoring SSI encoder value and all 4 digital inputs switch (BI1..4)
```
camonitor IOC_TEST:ec0-s3-EL5002-CH1-PosAct IOC_TEST:ec0-s1-EL1004-BI1 IOC_TEST:ec0-s1-EL1004-BI2 IOC_TEST:ec0-s1-EL1004-BI3 IOC_TEST:ec0-s1-EL1004-BI4

IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.907665 750
IOC_TEST:ec0-s1-EL1004-BI1 2020-09-29 16:19:49.907665 1
IOC_TEST:ec0-s1-EL1004-BI2 2020-09-29 16:19:49.907665 1
IOC_TEST:ec0-s1-EL1004-BI3 2020-09-29 16:19:49.907665 0
IOC_TEST:ec0-s1-EL1004-BI4 2020-09-29 16:19:49.907665 0
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.908665 751
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.909665 752
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.910665 753
IOC_TEST:ec0-s3-EL5002-CH1-PosAct 2020-09-29 16:19:49.911665 754
...

``` 

Example: Use the "-g10" option in order to see the complete value (if for instance a value is dispalyed in a format not suitable, could happen for the SSI encoder)..
``` 
# Dispaly without exponant with 10 digits.
camonitor -g10 IOC_TEST:ec0-s3-EL5002-CH1-PosAct

``` 

Example: Log data to file
``` 
# Syntax: camonitor <options> <pvname list> | tee <filename.log>
camonitor -g10 IOC_TEST:ec0-s3-EL5002-CH1-PosAct | tee data.log

``` 
Note: Stop camonitor logging with "Ctrl-C" button combination.


Example: Get help on command: 
``` 
(master) $ camonitor -h

Usage: camonitor [options] <PV name> ...

  -h:       Help: Print this message
  -V:       Version: Show EPICS and CA versions
Channel Access options:
  -w <sec>: Wait time, specifies CA timeout, default is 1.000000 second(s)
  -m <msk>: Specify CA event mask to use.  <msk> is any combination of
            'v' (value), 'a' (alarm), 'l' (log/archive), 'p' (property).
            Default event mask is 'va'
  -p <pri>: CA priority (0-99, default 0=lowest)
Timestamps:
  Default:  Print absolute timestamps (as reported by CA server)
  -t <key>: Specify timestamp source(s) and type, with <key> containing
            's' = CA server (remote) timestamps
            'c' = CA client (local) timestamps (shown in '()'s)
            'n' = no timestamps
            'r' = relative timestamps (time elapsed since start of program)
            'i' = incremental timestamps (time elapsed since last update)
            'I' = incremental timestamps (time since last update, by channel)
            'r', 'i' or 'I' require 's' or 'c' to select the time source
Enum format:
  -n:       Print DBF_ENUM values as number (default is enum string)
Array values: Print number of elements, then list of values
  Default:  Request and print all elements (dynamic arrays supported)
  -# <num>: Request and print up to <num> elements
  -S:       Print arrays of char as a string (long string)
Floating point format:
  Default:  Use %g format
  -e <num>: Use %e format, with a precision of <num> digits
  -f <num>: Use %f format, with a precision of <num> digits
  -g <num>: Use %g format, with a precision of <num> digits
  -s:       Get value as string (honors server-side precision)
  -lx:      Round to long integer and print as hex number
  -lo:      Round to long integer and print as octal number
  -lb:      Round to long integer and print as binary number
Integer number format:
  Default:  Print as decimal number
  -0x:      Print as hex number
  -0o:      Print as octal number
  -0b:      Print as binary number
Alternate output field separator:
  -F <ofs>: Use <ofs> to separate fields in output

Example: camonitor -f8 my_channel another_channel
  (doubles are printed as %f with precision of 8)
``` 
