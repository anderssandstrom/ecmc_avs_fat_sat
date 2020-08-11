# ecmc_avs_fat_sat:
This repo is dedicated to the SAT/FAT commisoning/verification of componentes of the Target Drive Unit (TDU).
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

## Commisioning of one axis:
One Stepper
Motor:
1. Connect motor gnd to Technosoft drive
2. Connect motor phases direct to Technosoft drive

## Limits:
Limits are feed from 24V digital output (EL2819) to 24V digital input (EL1004). There are two jumpers installed in the crate that should be replaced with actual sensors.
1. Connect low limit to input 1 of EL2004 (replace jumper with switch)
2. Connect high limit to input 2 of EL2004 (replace jumper with switch)

## Resolver:
 The Resolver shoud be connected to the EL7201 terminal.

