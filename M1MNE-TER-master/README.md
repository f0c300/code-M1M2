M1MNE-TER
=========

TER 2014 : Modbus/TCP on embedded systems - school project


Here are the source and explanations for the next student to take it further.
The project is about communicating with the modbus protocol between a 
beaglebone black and a computer, and then we used an i2c sensor to transfer 
temperatures measurement over the network. The output goes on a file and is 
read by gnuplot.
This little project works on a local network with the beaglebone and the 
computer directly wired with an ethernet cable.

You may read rapport.pdf first.

##How to set it up?

###client vs server
the files in the server folder are meant to be one the beaglebone, the client 
ones on the computer

###dependencies
You'll need to install the [libmodbus] (https://github.com/stephane/libmodbus) 
library and eventually to use symbolic links to be able to use pkg-config.

On the server side, we used [iolib] (http://bit.ly/1kC9Sqd) be carefull with 
the linking on the .c file.
We also used i2c-dev to get the temperature from the tmp102.

Also be sure to have gnuplot installed on the host computer.

###network
With this configuration in the programs, the computer adress should be 
192.168.1.101 and the beaglebone's 192.168.1.100

##The programs

Once everything is installed and ok, you can compile the different programs.  
(read the Makefiles)
- modbusclient/server writes and read some registers
- ledclient/server lights a led depending on a coil status
- tempclient/sever gets temperatures measurements and outputs it on gnuplot


