# modified from maximum.s example
#PURPOSE:   This program finds the maximum number of a 
#           set of data items.
#VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# data_items -  contains the item data. A 0 is used
#               to terminate the data.
#

.section .data

data_items:                     # these are the data items
                                # as we have 14 longs with 4 bytes each
                                # the list takes 56 bytes
    .long 3,67,34,100,45,75,54,34,44,33,22,11,66,0 
data_items2:                     
    .long 1,2,3,0 
data_items3:                  
    .long 1,2,3,4,5,0 

.section .text
.globl _start
.globl maximum # so it could be callable from outside

_start:
    pushl   $data_items             # pushing the address of data_items
    call    maximum
    addl    $4, %esp
    movl    %eax, %ebx              # putting %eax (return result) into %ebx for ret val
    pushl   %ebx                    # saving %ebx in stack before function call
    pushl   $data_items2            # pushing the address of data_items
    call    maximum
    addl    $4, %esp
    popl    %ebx                    # poping %ebx back
    addl    %eax, %ebx              # adding max of second list 
    pushl   %ebx                    # saving %ebx in stack before function call
    pushl   $data_items3            # pushing the address of data_items
    call    maximum
    addl    $4, %esp
    popl    %ebx                    # poping %ebx back
    addl    %eax, %ebx              # adding max of third list
    movl    $1, %eax                #1 is the exit() syscall
    int     $0x80                   # making interrupt syscall

.type maximum,@function
maximum:
    pushl   %ebp                # basic func setup, saving base pointer
    movl    %esp, %ebp          # putting stack pointer in base pointer to use
    movl    8(%ebp), %ebx       # putting the list address in %eax
    movl    $0, %edi            # setting %edi to 0
    movl    (%ebx,%edi,4), %ecx # putting the first list value on %eax
    movl    %ecx, %eax          # putting the first val in %eax, since it is
                                # the bigger

start_loop:                     # start the loop
    cmpl $0, %ecx               # check to see if we've hit the end
    je loop_exit
    incl %edi                   # load the next value
    movl (%ebx,%edi,4), %ecx
    cmpl %eax, %ecx             # compare values
    jle start_loop              # jump to loop beginning if the new one isn't bigger
    movl %ecx, %eax             # move the value as the Largest
    jmp start_loop              # jump to loop beginning

loop_exit:
    movl    %ebp, %esp          # cleanup: putting stack pointer back to clean frame
    popl    %ebp                # cleanup: poping base pointer back
    ret                         # returning

