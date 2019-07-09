#Atara Razin 327348934

	.section	.rodata
	.align 8
.jumpTable:
	.quad	.option50
	.quad	.option51
	.quad	.option52
	.quad	.option53
	.quad	.option54
	.quad	.defaultOption
	.quad	.endProgram

strFormatForScanf51:	.string " %c %c"
strFormatForScanf52:	.string "%d"
defaultStr:		.string "invalid option!\n"
stringForStrlen:	.string "first pstring length: %d, second pstring length: %d\n"
strForSwapCase:		.string "length: %d, string: %s\n"
strForReplaceChar:	.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
strForOp54:		.string "compare result: %d\n"
	########
	.text
.global run_func
	.type run_func,@function
run_func:
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	pushq	%rbp		#save the old frame pointer
	movq	%rsp,	%rbp	#create the new frame pointer
	movq	%rsi, %r12	#save the first pstring in a caller saver register
	movq	%rdx, %r13	#save the second pstring in a caller saver register

	subq $50, %rdi
	cmpq $5, %rdi
	ja	.defaultOption
	jmp	*.jumpTable(,%rdi,8)
	
     .option50:
	movq	%r12, %rdi			#send the first pstring as a parameter to pstrlen
	call	pstrlen
	movq	%rax, %rsi			#move the return value into the second parameter for printf
	movq	%r13, %rdi			#send the second pstring as a parameter to pstrlen
	call	pstrlen
	movq	%rax, %rdx			#move the return value into the thrid parameter to printf
	movq	$stringForStrlen, %rdi		#save the string as the first parameter to printf
	movq	$0, %rax
	call	printf	
	movq	$0, %rax
	jmp	.endProgram

      .option51:
	subq	$1, %rsp			#create one byte on the stack for the char for scanf
	movq	%rsp, %r14			#have a register save its address
	subq	$1, %rsp			#create on byte on the stack for the char for scanf
	movq	%rsp, %r15			#register that will save its address
		
	movq	$strFormatForScanf51, %rdi	#first param to scanf
	movq	%r14, %rsi			#the address of the first char, second param
	movq	%r15, %rdx			#the address of the second char, third param
	movq	$0, %rax	
	call	scanf
	movq	$0, %rax

	movq	%r12 ,%rdi			#first param to replace char -the first spstring
	movq	%r14, %rsi		 	#second param to replacechar - the old char
	movq	%r15, %rdx			#third param to replacechar - the newchar
	call	replaceChar

	movq	%r13 ,%rdi			#first param to replace char -the second pstring
	movq	%r14, %rsi		 	#second param to replacechar - the old char
	movq	%r15, %rdx			#third param to replacechar - the newchar	
	call	replaceChar

	movq	$strForReplaceChar, %rdi	#first param to printf	
	movq	(%r14), %rsi			#copies the value of the address saved in the register into the second param-oldchar
	movq	(%r15), %rdx			#copies the value of the address saved in the register into the third param-newchar
	addq	$1, %r12			#skips the first place of the char, meaning where the size is saved
	movq	%r12, %rcx			#this is the fourth param to printf, the first string
	addq	$1, %r13			#skips the first place of the char, meaning where the size is saved
	movq	%r13, %r8			#fifth param to printf, the second string
	movq	$0, %rax
	call	printf
	movq	$0, %rax
	jmp .endProgram	

      .option52:
	subq	$4, %rsp			#create 4 bytes on the stack for the char for scanf
	movq	%rsp, %r14
	subq	$4, %rsp
	movq	%rsp, %r15
		
	#first scanf
	movq	$strFormatForScanf52, %rdi	#first param to scanf
	movq	%r14, %rsi
	movq	$0, %rax
	call	scanf
	movq	$0, %rax

	#second scanf
	movq	$strFormatForScanf52, %rdi	#first param to scanf
	movq	%r15, %rsi
	movq	$0, %rax
	call	scanf
	movq	$0, %rax

	#params to strijpcy
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	%r14, %rdx
	movq	%r15, %rcx
	call	strijcpy
	
	#params to printf
	movq	$strForSwapCase, %rdi
	movq	$0, %rsi
	movb	(%r12), %sil
	addq	$1, %r12
	movq	%r12, %rdx
	movq	$0, %rax
	call	printf
	movq	$0, %rax

	#print the second string
	movq	$strForSwapCase, %rdi
	movq	$0, %rsi
	movb	(%r13), %sil
	addq	$1, %r13
	movq	%r13, %rdx
	movq	$0, %rax
	call	printf
	movq	$0, %rax

	jmp .endProgram

      .option53:
	movq	%r12, %rdi		#first pstring as param for swapcase
	call 	swapCase
	movq	$strForSwapCase, %rdi	#first param to printf
	movq	$0, %rsi		#zero rsi
	movb	(%r12), %sil		#length second param to printf
	addq	$1, %r12		#increase by one in order to get ride of the size char
	movq	%r12, %rdx		#the string itself-third param to printf
	movq	$0, %rax
	call	printf
	movq	$0, %rax

	movq	%r13, %rdi
	call	swapCase
	movq	$strForSwapCase, %rdi	#first param to printf
	movq	$0, %rsi		#zero rsi
	movb	(%r13), %sil
	addq	$1, %r13
	movq	%r13, %rdx
	movq	$0, %rax
	call	printf
	movq	$0, %rax
	jmp .endProgram
	
      .option54:
	subq	$4, %rsp			#create 4 bytes on the stack for the char for scanf
	movq	%rsp, %r14
	subq	$4, %rsp
	movq	%rsp, %r15
		
	#first scanf
	movq	$strFormatForScanf52, %rdi	#first param to scanf
	movq	%r14, %rsi
	movq	$0, %rax
	call	scanf
	movq	$0, %rax
	#second scanf
	movq	$strFormatForScanf52, %rdi	#first param to scanf
	movq	%r15, %rsi
	movq	$0, %rax
	call	scanf
	movq	$0, %rax

	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	%r14, %rdx
	movq	%r15, %rcx
	call	pstrijcmp
	movq	$0, %rdi
	movq	$strForOp54,%rdi
	movq	$0, %rsi
	movq	%rax, %rsi
	movq	$0, %rax
	call	printf
	movq	$0, %rax
	jmp .endProgram

      .defaultOption:

	movq	$defaultStr,%rdi
	movq	$0,%rax
	call	printf
	movq	$0, %rax	#return value is zero

	.endProgram:
	movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	ret			#return to caller function (OS)

