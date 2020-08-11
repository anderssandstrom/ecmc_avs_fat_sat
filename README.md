# ecmc_avs_fat_sat:
This repo is dedicated to the SAT/FAT commisoning/verification of components of the Target Drive Unit (TDU).
Components that can be tested:
* Stepper Motors (X,Y,Z)
* Resolvers (X,Y,Z)
* Switches (X,Y,Z)
* Master AMO encoder (Rotation)

## Startup of sat_fat_box:
1. Open Rittal box/crate
2. Connect white HDMI cable to a HDMI screen
3. Connect keyboard and mouse to white usb cables
4. Connect power cord to 3-phase power
5. Switch breaker in lower left corner
6. The controller should now be starting up.

## Commisioning of one stepper axis:
Each stepper axis needs to be tested separately.

### Motor
1. Connect motor gnd to connector J2 of Technosoft drive.
2. Connect motor phases to conenctor J2 of Technosoft drive.

[Datasheet: iPOS8020, stepper drive](doc/crate/datasheets/iPOS8020_P029.026.E221.DSH_.10G.pdf)

### Limit switches:
Limits are feed from 24V digital output (EL2819) to 24V digital input (EL1004). There are two jumpers installed in the crate that should be replaced with actual sensors.
1. Connect low limit to input 1 of EL2004 (replace jumper with switch).
2. Connect high limit to input 2 of EL2004 (replace jumper with switch).

[Datasheet: EL2819, 24V output terminal](doc/crate/datasheets/EL2819.pdf)

[Datasheet: EL1004, 24V input terminal](doc/crate/datasheets/EL1004.pdf)


### Resolver:
The Resolver should be connected to the EL7201 terminal.

[Datasheet: El7201, resolver input terminal](doc/crate/datasheets/EL7201.pdf)


