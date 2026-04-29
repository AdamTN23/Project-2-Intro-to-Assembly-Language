# Assembly Lab: Input/Output and Doubling

## Problem for Project 2:

Implement an assembly language program that reads from the command line a number, doubles that number, and then prints out "The double is: " and the doubled number. 

## How to Build and Execute the Doubling Project

1. **Compile the following:**

   ```bash 
   gcc -nostdlib -m32 -no-pie double.s -o double
   ```

2. **Now input the following in the terminal with your choice of number to calculate it's double**

   ```bash
   ./double (input your number to calculate double)