#PURPOSE -  This function is used to calculate
#           the square of a number

.section .data

#there is no global data

.section .text
.globl _start
.globl square

_start:
    pushl   $4          # pushes the value to calculate the square
                        # onto the stack, this is the procedure
                        # argument
    call    square      # calling square
    addl    $4, %esp    # cleaning up the argument value pushed on stack
    movl    %eax, %ebx  # moves the returned value from square (%eax)
                        # to %ebx, since the return value must be there
    movl    $1, %eax    # exit syscall
    int     $0x80       # making syscall


# the square function definition
.type square,@function
square:
    pushl   %ebp            # pushing ebp to stack so it can be used
    movl    %esp, %ebp      # getting current stack pointer to base pointer

    movl    8(%ebp), %eax   # moving the square proc argument to %eax
                            # since %ebp holds the old ebp, then return
                            # value, and then the arg (after 2 longs)
    imull   %eax, %eax      # squaring the value and storing at %eax return

    movl    %ebp, %esp      # cleanup: moving back %esp and %ebp to the values
    popl    %ebp            # they had before the function call
    ret                     # returning with the value
                            
