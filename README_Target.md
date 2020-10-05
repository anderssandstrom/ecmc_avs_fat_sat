# ecmc_avs_fat_sat: Target
This file describes the work flow for commisoing of the stepper of the Target instrument

### Motor
1. Connect motor gnd to connector J2 of Technosoft drive (important!!).
2. Connect motor phases to conenctor J2 of Technosoft drive.

[Datasheet: iPOS8020, stepper drive](doc/crate/datasheets/iPOS8020_P029.026.E221.DSH_.10G.pdf)

#### Change motor current
The delivery state setting of the motor current is 10A. Measurement of the actual current showed that a setting of 12A approx corresponds to 10A RMS.

The current can be changes by updating the ECMC_EC_DRIVE_CURRENT variable in the  [target.script](target.script) file. 

NOTE: The current can only be changed in integer steps of Amps in the range 2A..14A.

Example: Set current to 5A
```
# Several current settings are available for this motor (2A..14A). Motor max current is 10A RMS
# NOTE: Setting 12A results in approx 10A RMS current (measured with current clamps and scope)
epicsEnvSet("ECMC_EC_DRIVE_CURRENT",          "5")     # Set current in Amps here (only integers)
```
WARNING: Be sure to not set a higher current than what the motor is rated for otherwise it might overheat. 

NOTE: After updating the [target.script](target.script) the EPICS ioc needs to be restarted in order to load the new setting.


### AMO encoder

Instructions on how to verify AMO encoder functionality:

[AMO verification](README_Target_Amo.md)


### Limit switches:
Limits are feed from 24V digital output (EL2819) to 24V digital input (EL1004). There are two jumpers installed in the crate that should be replaced with the actual switches.
1. Connect low limit between output 1 of EL2819 and input 1 of EL1004(replace jumper with switch).
2. Connect high limit between output 2 of EL2819 and input 2 of EL1004 (replace jumper with switch).

[Datasheet: EL2819, 24V output terminal](doc/crate/datasheets/EL2819.pdf)

[Datasheet: EL1004, 24V input terminal](doc/crate/datasheets/EL1004.pdf)


### Resolver:
The Resolver should be connected to the EL7201 terminal.

[Datasheet: El7201, resolver input terminal](doc/crate/datasheets/EL7201.pdf)


### ecmc EPICS ioc
The EtherCAT hardware in the crate is controlled by an [EPICS](https://epics.anl.gov) module called [ecmc](https://github.com/epics-modules/ecmc) and configured through a epics module called [ecmccfg](https://github.com/paulscherrerinstitute/ecmccfg). All needed softwares have already been installed on the controller. 

Notes on motor configuration:
The hardware is currently configured to run a stepper motor in open loop in the unit motor degrees (360 correspons to one rev of the motor). Any gears have not yet been configured. If needed the motion can be configured to any unit or scaling needed. Then please supply information on gears and scalings (from motor axis to the desired unit).

Notes on resolver configuration:
The reolsvers have not yet been scaled. However, it should be enough to see that you get increasing/decreasing signal on the resolver while running the stepper motor.

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
An EPICS ioc (input/output controller) needs to be started in order to control the hardware. The "fat_sat.script" file contains configurations of hardware for running a stepper axis with a pythron motor.
```
iocsh.bash target.script
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
2 | IOC_TEST: | ec0-s4-EL5021-PosAct  | SinCos encoder terminal Actual position (Amo encoder) [raw counts]
3 | IOC_TEST: | ec0-s5-EL7201-Enc-PosAct  | Resolver  terminal Actual position [raw counts]
4 | IOC_TEST: | ec0-s1-EL1004-BI1  | Digital input 1 for switches []
5 | IOC_TEST: | ec0-s1-EL1004-BI2  | Digital input 2 for switches []
6 | IOC_TEST: | ec0-s1-EL1004-BI3  | Digital input 3 for switches []
7 | IOC_TEST: | ec0-s1-EL1004-BI4  | Digital input 4 for switches []

All accesible PVs are listed in: [PVs](pvs.log)

## Command line utilities

Data is also accessible through command line tools:

* camonitor <prefix><pv name>       : Continiously print new values of the selected pv when the value changes
 
* caput <prefix><pv name> <value>   : Write value to the  selected pv
 
* caget <prefix><pv name>           : Read value of selected pv 
 
NOTE: These commands are only accesible in a prepared shell (see heading above). You need to run this command in a new terminal:

```
. /epics/base-7.0.3.1/require/3.1.2/bin/setE3Env.bash

```
 
Example: 
```
camonitor IOC_TEST:ec0-s4-EL5021-PosAct

IOC_TEST:ec0-s4-EL5021-PosAct 2020-09-29 16:19:49.907665 750
IOC_TEST:ec0-s4-EL5021-PosAct 2020-09-29 16:19:49.908665 751
IOC_TEST:ec0-s4-EL5021-PosAct 2020-09-29 16:19:49.909665 752
IOC_TEST:ec0-s4-EL5021-PosAct 2020-09-29 16:19:49.910665 753
IOC_TEST:ec0-s4-EL5021-PosAct 2020-09-29 16:19:49.911665 754
...

```

Example: Monitoring resolver value and all 4 digital inputs switch (BI1..4)
```
camonitor IOC_TEST:ec0-s5-EL7201-Enc-PosAct IOC_TEST:ec0-s1-EL1004-BI1 IOC_TEST:ec0-s1-EL1004-BI2 IOC_TEST:ec0-s1-EL1004-BI3 IOC_TEST:ec0-s1-EL1004-BI4

IOC_TEST:ec0-s5-EL7201-Enc-PosAct 2020-09-29 16:19:49.907665 750
IOC_TEST:ec0-s1-EL1004-BI1 2020-09-29 16:19:49.907665 1
IOC_TEST:ec0-s1-EL1004-BI2 2020-09-29 16:19:49.907665 1
IOC_TEST:ec0-s1-EL1004-BI3 2020-09-29 16:19:49.907665 0
IOC_TEST:ec0-s1-EL1004-BI4 2020-09-29 16:19:49.907665 0
IOC_TEST:ec0-s5-EL7201-Enc-PosAct 2020-09-29 16:19:49.908665 751
IOC_TEST:ec0-s5-EL7201-Enc-PosAct 2020-09-29 16:19:49.909665 752
IOC_TEST:ec0-s5-EL7201-Enc-PosAct 2020-09-29 16:19:49.910665 753
IOC_TEST:ec0-s5-EL7201-Enc-PosAct 2020-09-29 16:19:49.911665 754
...

``` 

Example: Use the "-g10" option in order to see the complete value (if for instance a value is dispalyed in a format not suitable, could happen for encoders)..
``` 
//Dispaly without exponant with 10 digits.
camonitor -g10 IOC_TEST:ec0-s5-EL7201-Enc-PosAct
``` 

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
