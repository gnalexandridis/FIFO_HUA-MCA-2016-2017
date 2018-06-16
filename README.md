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

## Explanation

The project consists of 2 modules, the fifo module, which contains the implementation of the FIFO queue and the top module,
which uses the fifo module, in order to confirm that it works correctly.

### Module fifo:
Takes as inputs the signals:
1. clk: used in order to execute the module in every positive pulse of the clock.
2. Cen: enables/disables the module.
3. Reset: resets the queue.
4. Data_IN: input data to store in queue.
5. FIFO_Read_Write: control of read/write operation from/to queue.

Produces as output the signals:
1. FIFO_Empty: 1 when queue is empty.
2. FIFO_Full: 1 when queue is full.
3. FIFO_Last: 1 when queue has 1 free slot remaining.
4. FIFO_Data_Out: output data to read from queue.

Apart from the signals mentioned above, some variables also used are:
1. Data[15:0]: 16-slot table representing the queue's memory.
2. i: index for the initialization/reset of the Data table
3. ptr_r: pointer that holds the position for the read operation from queue. After each read operation it's incremented by 1, in order to show the next position to read. When it reaches the last slot it's starts again from 0.
4. ptr_w: pointer that keeps the write position in the queue (same as ptr_r)
5. cntr: counter of slots used, incremented by 1 in every write operation and decremented by 1 in every read operation, max value: 16, min value: 0
