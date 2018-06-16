# FIFO
This is a simple FIFO queue implementation in Verilog for the Modern Computer Architectures course (2016-2017) of Harokopio University.

## Prerequisites
1. Verilog compiler. Use `apt-get install iverilog` or follow [this guide](http://iverilog.wikia.com/wiki/Installation_Guide) to install.
2. [__Optional__] [GTKWave](http://gtkwave.sourceforge.net/) for visual representation. Install using `apt-get install gtkwave`

## To execute this FIFO implementation you have to:
1. Clone this repository using: `https://github.com/galexandridis/fifo.git`
2. Move to the folder of the repository `cd fifo`
3. Compile using `iverilog fifo.v -o fifo.out`
4. Execute using `./fifo.out`
5. To see the diagrams produced use `gtkwave fifo.vcd`
