.section .data
msg:    .ascii "The double is: "
len = . - msg

.section .bss
.lcomm buffer, 20 

.section .text
.globl _start
_start:

    # 1. READING FROM COMMAND LINE (32-bit Stack Layout)
    movl (%esp), %ecx   # Get argc from the top of the stack
    cmpl $2, %ecx     # Making sure an argument was provided
    jl exit_prog     # If there is no argument, jump to exit

    movl 8(%esp), %esi    # argv[0] is at 4(%esp), argv[1] is at 8(%esp)

    
    # 2. TEXT TO NUMBER CONVERSION
    xorl %eax, %eax        # Clearing %eax which will hold final math number
    xorl %ecx, %ecx         # Clear %ecx which will hold current character
    movl $10, %ebx        # Base 10 multiplier

atoi_loop:

    movb (%esi), %cl
    cmpb $0, %cl        # Checking if it's the end of string / null terminator
    je do_math         # If its at the end of string, go do the math
    subb $'0', %cl    # Subtract ASCII '0' to get real integer
    mull %ebx          # Multiply %eax by 10 (which the result ends up going to %edx:%eax)
    addl %ecx, %eax    # Adding the new digit to the total
    incl %esi            # Moving to the next character
    jmp atoi_loop       # Loop right back

do_math:

    # 3. DOUBLE THE NUMBER
    shll $1, %eax      # Multiply %eax by 2 (shifting to the left by exactly 1 bit)

    # 4. NUMBER TO TEXT CONVERSION
    movl $buffer, %edi   # Point %edi to empty memory buffer
    addl $19, %edi        # Move to the end of the buffer
    movb $'\n', (%edi)   # Simply putting a newline character at the end
    movl %edi, %esi
    movl $10, %ebx      # This is the base 10 divisor

itoa_loop:

    xorl %edx, %edx      # Clearing the remainder register
    divl %ebx           # Divide %edx:%eax by 10 (the quotient is in %eax, the remainder is in %edx)
    addb $'0', %dl       # Converting the remainder back to ASCII
    decl %edi           # Move backwards in the buffer
    movb %dl, (%edi)     # Store the ASCII character
    cmpl $0, %eax      # Check if the quotient is 0
    jne itoa_loop      # Loop again if it's not zero

    # 5. CALCULATE STRING LENGTH
    incl %esi          # Crating the newline in the length
    subl %edi, %esi     # Length = ending address -starting address

    # 6. PRINT "The double is: "
    movl $4, %eax    # syscall ID for sys_write
    movl $1, %ebx        # File descriptor 1
    movl $msg, %ecx     # Pointer to the message
    movl $len, %edx    # Length of the message
    int $0x80          # syscall

    # 7. PRINT THE NUMBER
    movl $4, %eax      # syscall ID for sys_write 
    movl $1, %ebx    # File descriptor 1 
    movl %edi, %ecx    # Pointing to the converted number string
    movl %esi, %edx  # Length of the number string
    int $0x80      # Invoke syscall

exit_prog:

    # 8. EXIT PROGRAM 
    movl $1, %eax       # syscall ID for sys_exit
    xorl %ebx, %ebx     # Exit status 0
    int $0x80        # Invoke syscall