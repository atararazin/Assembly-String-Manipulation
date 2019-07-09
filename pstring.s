#Atara Razin 327348934
	.section	.rodata	#read only data section
invalidInput:		.string "invalid input!\n"
	########

	.text	#the beginnig of the code
.globl pstrlen
.globl replaceChar
.globl strijcpy
.globl swapCase
.globl pstrijcmp
	.type pstrlen,@function

pstrlen:
	movq	$0, %rax
	movb	(%rdi), %al	#save the first char in the struct as a return argument
	ret			#return to caller function (OS)

replaceChar:
	movq	(%rsi), %rax	#save oldchar locally
	movq	(%rdx), %r8	#save newchar locally

	addq	$1, %rdi	#skip over the first element because it is the lenth of the pstring
	jmp	.testReplaceChar
	
	.loopBodyReplaceChar:
		cmpb	%al, (%rdi)	#compares the old char to the current char. in C: if(oldchar == *pstring)
		jne	.notOldChar	#if false, skip to the iteration part
		movb	%r8b, (%rdi)	#if true, change the oldchar to the newchar. in C: *pstring == newchar
		
		.notOldChar:
		addq	$1, %rdi	#increase the pointer to the string by one. 
	.testReplaceChar:
		cmpb	$0, (%rdi)	#check if we have reached the '\0'
		jne	.loopBodyReplaceChar
	ret


strijcpy:
	movq	$0, %rax
	movq	$0, %r8
	movb	(%rdx), %al	#saves i locally
	movb	(%rcx), %r8b	#saves j locally

	cmpb	(%rdi), %al	#checks if not valid 
	ja	.notValid
	cmpb	(%rsi), %al
	ja	.notValid
	cmpb	(%rdi), %r8b
	ja	.notValid
	cmpb	(%rsi), %r8b
	ja	.notValid
	
	movq	%rdi, %r10	#saves the first pstring
	addq	%rax, %r10	#increases by i
	addq	$1, %r10	#increase by one to skip over the size char
	movq	%rsi, %r11	#saves the second pstring
	addq	%rax, %r11	#increases by i
	addq	$1, %r11	#increases by one to skip over the char size

	jmp	.testStrijcpy

	.loopBodyStrijcpy:
		cmpb	$0, (%r10)		#if it's the '\0', do nothing
		je	.finish
		cmpb	$0, (%r11)		
		je	.finish
		movb	(%r11), %r9b		#copies from src to dest
		movb	%r9b, (%r10)
		addl	$1, %eax		#increase i by one
		addq	$1, %r10		#increases pstring1 by one
		addq	$1, %r11		#increases pstring2 by one
	.testStrijcpy:
		cmpl	%eax, %r8d		#checks if weve reached the \0
		jae	.loopBodyStrijcpy
		jmp	.finish

	.notValid:
		#prints the not valid warning
		movq	$invalidInput, %rdi
		movq	$0, %rax
		call	printf
		movq	$0, %rax
	
	.finish:
	movq	%rdi, %rax
	ret

swapCase:
	addq	$1, %rdi	#skip over the first element because it is the lenth of the pstring
	jmp	.testSwapCase
    .loopBodySwapCase:
	cmpb	$65, (%rdi)	#checks if less than 65 uppercase A
	jb	.notUpperCase
	cmpb	$90, (%rdi)	#checks if greater than 90 uppercase Z
	ja	.notUpperCase
	addq	$32, (%rdi)	#will increase the ascii value by 32, aka lowercasing it
	jmp	.notALetter	#will skip the following so that it doens't revert back to uppercase
	.notUpperCase:
	
		cmpb	$97, (%rdi)	#checks if less than 97, lowercase a
		jb	.notLowerCase
		cmpb	$122, (%rdi)	#checks if greater than 122 lowercase z
		ja	.notLowerCase
		subq	$32, (%rdi)	#will decrease the ascii value by 32, aka uppercasing it
	.notLowerCase:
	.notALetter:
		addq	$1, %rdi	#increase the pointer to the string by one
    .testSwapCase:
	cmpb	$0, (%rdi)	#check if we have reached the '\0'
	jne	.loopBodySwapCase
	ret

pstrijcmp:
	movq	$0, %rax
	movq	$0, %r8
	movb	(%rdx), %al	#saves i locally
	movb	(%rcx), %r8b	#saves j locally

	cmpb	(%rdi), %al
	ja	.notValid1
	cmpb	(%rsi), %al
	ja	.notValid1
	cmpb	(%rdi), %r8b
	ja	.notValid1
	cmpb	(%rsi), %r8b
	ja	.notValid1
	movq	%rdi, %r10	#saves the first pstring
	addq	%rax, %r10	#increases by i
	addq	$1, %r10	#increases by 1 for the first char
	movq	%rsi, %r11	#saves the second pstring
	addq	%rax, %r11	#increases by i
	addq	$1, %r11	#increase by 1 for the first char

	jmp	.testStrijcmp

	.loopBodyStrijcmp:
		movb	(%r10), %r9b	
		cmpb	%r9b, (%r11)	#compares the two pstrings at place i+1
		je	.increment
		ja	.secondStrBigger
		jb	.firstStrBigger
		.increment:
		addl	$1, %eax	#increments i
		addq	$1, %r10	#increments the first pointer
		addq	$1, %r11	#increments the second pointer
	.testStrijcmp:
		cmpl	%eax, %r8d	#checks if we've reached the \0
		jae	.loopBodyStrijcmp
		jmp	.equals		#we've finished the loop meaning all chars were the same

	.notValid1:
		#print the not valid warning, return -2
		movq	$invalidInput, %rdi
		movq	$0, %rax
		call	printf
		movq	$0, %rax
		movq	$-2, %rax
		jmp	.done
	
	#puts the correct value depending on the loop
	.firstStrBigger:
		movq	$1, %rax
		jmp	.done
	.secondStrBigger:
		movq	$-1, %rax
		jmp	.done
	.equals:
		movq	$0, %rax
		jmp	.done
	.done:
	ret

