# modified recursive factorial not to be recursive
#PURPOSE -  Given a number, this program computes the
#           factorial. For example, the factorial of 
#           3 is 3 * 2 * 1, or 6. The factorial of
#           4 is 4 * 3 * 2 * 1, or 24, and so on.
#           
#This program shows how to call a function recursively.

.section .data

#This program has no global data

.section .text

.globl _start
.globl factorial            #this is unneded unless we want to share
                            #this function among other programs

_start:
    pushl   $4              #The factorial takes one argument - the
                            #number we want a factorial of. So, it
                            #gets pushed
    call    factorial       #run the factorial function
    addl    $4, %esp        #Scrubs the parameter that was pushed on
                            #the stack
    movl    %eax, %ebx      #factorial returns the answer in %eax, but
                            #we want it in %ebx to send it as our exit
                            #status
    movl    $1, %eax        #call the kernel's exit function
    int $0x80

#This is the actual function definition
.type factorial,@function
factorial:
    pushl   %ebp            #standard function stuff - we have to 
                            #restore %ebp to its prior state before
                            #returning, so we have to push it
    movl    %esp, %ebp      #This is because we don't want to modify
                            #the stack pointer, so we use %ebp.

    movl    8(%ebp), %ebx   #This moves the first argument to %eax
                            #4(%ebp) holds the return address, and
                            #8(%ebp) holds the first parameter 
    movl    %ebx, %eax      # put first value on %eax
factorial_loop:
    cmpl    $1, %ebx        #If the number is 1, that is our base 
                            #case, and we simply return (1 is 
                            #already in %eax as the return value)
    je      end_factorial
    decl    %ebx            
    imull   %ebx, %eax      #multiply that by the result of the
                            #last call to factorial (in %eax)
                            #the answer is stored in %eax, which
                            #is good since that's where return
                            #values go.
    jmp     factorial_loop

end_factorial:
    movl    %ebp, %esp      #standard function return stuff - we 
    popl    %ebp            #have to restore %ebp and %esp to where
                            #they were before he function started
    ret                     #return to the function (this pops the
                            #return value too)
    
    

