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


### PYQT GUI
All data is accessiblie in the iocsh but sometimes it's simpler with a graphical GUI. The graphical GUI is generic and can be used to control motors and to read/write data to individual process variables (PV:s). 

#### Prepare shell and start GUI
1. Start a new terminal/shell by pressing the blach button ">_" in upper left corner of screen 
2. Activate conda environment in order to use the correct python module versions
```
source activate ecmccomgui_py35
```

3. Go to GUI repo:
```
cd
cd source/ecmccomgui
```
4. Start GUI:

```
python ecmcGuiMain.py
```
5. Choose process variable (PV = IOC_TEST:Axis1):

ioc prefix: "IOC_TEST:"

pv name: "Axis1"


6. Start GUI for stepper axis:

press the "open gui" button

