# hb88_nano_9k_8x8_rand
Tang Nano 9k and Hackerboxes 88.  Generates random numbers and displays on 8x8 LED matrix.

## User Interface

DIP switches:  Set a seed value for the pseudo random number generator.  

SW1:  Resets the random number generator.
SW2:  Changes the update speed of the display.  

## Useful Links

* [Hackerboxes 88 Site](https://hackerboxes.com/products/hackerbox-0088-fpga-lab)
* [Hackerboxes 88 Instructables](https://www.instructables.com/HackerBox-0088-FPGA-Lab/)
* [Lushay Labes Setup Instructions](https://learn.lushaylabs.com/getting-setup-with-the-tang-nano-9k/)

# Theory of Operation

## Random Number Generator

This is a pseudo random number generator based on a Fibonacci LFSR as described in this [Wikipedia article](https://en.wikipedia.org/wiki/Linear-feedback_shift_register).  It uses a 64-bit register.  On each input clock, the register is shifted to the left 1 bit position with XNOR used to generate a new bit 0.  I selected the TAP position based on this [app note](https://docs.xilinx.com/v/u/en-US/xapp052).  It takes 64 clocks to generate an entirely new random number.  

In this project, the random number generator is constantly running.  A new random number is captured and displayed at a rate much slower than clock speed.  

## 8x8 Dispaly

The 8x8 display is driven 1 row at a time.  All column positions are driven to the appropriate value when the row is turned on.  Persistence of vision makes it appear like all rows are on at the same time.  If the clock was slowed way down you would be able to see the rows are driven one at at time from top to bottom.  

The data driven is brought in as a 64-bit value and flopped on the re-start at the top row.  

## Button Debounce

I used a basic button debounce method as described [here](https://www.fpga4student.com/2017/04/simple-debouncing-verilog-code-for.html).  Rather than instantiate flops, I just wrote some code to build the 2 sequential d flip-flops.  I also simplified the clock divider.  

