# ecmc_avs_fat_sat:
This repo is dedicated to the SAT/FAT commisoning/verification of components of the Target Drive Unit (TDU) and Bifrost instrument.
Components that can be tested for target:

* Stepper Motors (X,Y,Z) [Datasheet](doc/stepper/phytron_datasheet.pdf)
* Resolvers (X,Y,Z) [Datasheet](doc/stepper/phytron_datasheet.pdf)
* Switches (X,Y,Z) 
* Master AMO encoder (Rotation) [Datasheet](doc/amo_encoder/amosinEncoder.pdf)

Components that can be tested for bifrost:
* Stepper Motor
* Switches
* Posital SSI encoder for Bifrost
 
 
[Hardware](doc/crate/overview.jpg)

## Startup of sat_fat_box:
1. Open Rittal box/crate
2. Connect white HDMI cable to a HDMI screen
3. Connect keyboard and mouse to white usb cables
4. Connect power cord to 3-phase power
5. Switch breaker in lower left corner to ON
6. The controller should now be starting up...

## Connect hardware and start of EPICS IOC:
The Target and Bifrost application uses different motors and feedbacks and therefore uses different configurations of hardware and IOC.

1. [Target](README_Target.md)
 
2. [Bifrost](README_Bifrost.md)


## PYQT GUI
Some instruction on how to start a GUI can be found here:
 [GUI](https://github.com/anderssandstrom/ecmccomgui/blob/master/README_gui.md)
