	#327348934 Atara Razin
 
    .section    .rodata
strForSize: .string "%d"
strForString:   .string "%s"
strForFirstSizePrint:	.string "Please enter the first size:"
strForFirstStringPrint:	.string "Please enter the first string:"
strForSecondSizePrint:	.string "Please enter the second size:"
strForSecondStringPrint:	.string "Please enter the second string:"
    ########
    .text
.globl main
    .type main,@function
main:
    pushq   %r12
    pushq   %r14
    pushq   %r15   
    pushq   %rbp            #save the old frame pointer
    movq    %rsp, %rbp      #create the new frame pointer
 
    #first pstring
    subq    $4, %rsp        #create one byte on the stack for the int for scanf
    movq    %rsp, %r14      #have a register r14 save its address
       
    #request first size
    movq    $strForFirstSizePrint, %rdi   #first param to printf-string
    movq    $0, %rax   
    call    printf
    movq    $0, %rax

    #get first size
    movq    $strForSize, %rdi   #first param to scanf, %d
    movq    %r14, %rsi      #the address of the int, second param
    movq    $0, %rax   
    call    scanf
    movq    $0, %rax
 
    movq    $0, %r10        #r10=NULL  
    movl    (%r14), %r10d       #put the int that we recieved into r10
    subq    %r10, %rsp      #create pstring[0] bytes of space
    subq    $2, %rsp        #add one for the first size char and one for the \0
    movq    %rsp, %r15      #move the new allocated bytes into the register r15
    movb    (%r14), %r9b
    movb    %r9b, (%r15)        #move the size char into the first place in the pstring
    addq    $1, %r15        #increase the place of r15 by one, so that we can begin scanning by the first place not the zeroth

    #request first string
    movq    $strForFirstStringPrint, %rdi   #first param to printf-string
    movq    $0, %rax   
    call    printf
    movq    $0, %rax

    movq    $strForString, %rdi #first param to scanf
    movq    %r15, %rsi      #move r15 the pstring as second argument
    movq    $0, %rax   
    call    scanf
    movq    $0, %rax
 
    subq    $1, %r15        #have r15 point to the zeroth place of the string, not the first
 
    #second pstring
    #subq   $4, %rsp        #create one byte on the stack for the int for scanf
    #movq   %rsp, %r14      #have a register r14 save its address
       
	 #request second size
    movq    $strForSecondSizePrint, %rdi   #first param to printf-string
    movq    $0, %rax   
    call    printf
    movq    $0, %rax

    movq    $strForSize, %rdi   #first param to scanf, %d
    movq    %r14, %rsi      #the address of the int, second param
    movq    $0, %rax   
    call    scanf
    movq    $0, %rax
 
    movq    $0, %r10        #r10=NULL  
    movl    (%r14), %r10d       #put the int that we recieved into r10
    subq    %r10, %rsp      #create pstring[0] bytes of space
    subq    $2, %rsp        #add one for the first size char and one for the \0
    movq    %rsp, %r12      #move the new allocated bytes into the register r10
    movb    (%r14), %r9b
    movb    %r9b, (%r12)        #move the size char into the first place in the pstring
    addq    $1, %r12        #increase the place of r12 by one, so that we can begin scanning by the first place not the zeroth

  #request second string
    movq    $strForSecondStringPrint, %rdi   #first param to printf-string
    movq    $0, %rax   
    call    printf
    movq    $0, %rax

    movq    $strForString, %rdi #first param to scanf
    movq    %r12, %rsi      #move r12 the pstring as second argument
    movq    $0, %rax   
    call    scanf
    movq    $0, %rax
 
    subq    $1, %r12        #have r12 point to the zeroth place of the string, not the first
    movq    $strForSize, %rdi   #first param to scanf, %d
    movq    %r14, %rsi      #the address of the int, second param
    movq    $0, %rax   
    call    scanf
    movq    $0, %rax
   
    #call run_func
    movq    $0, %rdi
    movb    (%r14), %dil       #param option int
    movq    %r15, %rsi      #param first pstring
    movq    %r12, %rdx    #param second pstring
    movq    $0, %rax   
    call    run_func
    movq    $0, %rax
   
    #clean up, restore what was popped onto the stack
    movq    %rbp, %rsp  #restore the old stack pointer - release all used memory.
    popq    %rbp        #restore old frame pointer (the caller function frame)
    popq    %r15
    popq    %r14
    popq    %r12
    ret         #return to caller function (OS)
