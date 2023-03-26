	.data
my_id: .quad 316082791
	.section	.rodata			#read only data section
print_signed_long:	.string	"%ld\n"
print_true:			.string	"True\n"
print_false:		.string	"False\n"
	########
	.text	#the beginnig of the code
.globl	main	#the label "main" is used to state the initial point of this program
	.type	main, @function	# the label "main" representing the beginning of a function
main:	# the main function:
	pushq	%rbp		#save the old frame pointer
	movq	%rsp, %rbp	#create the new frame pointer
	pushq	%rbx		#saving a callee save register.

	# 1
	# const char *x = "%d\n";
	# long my_id = 316082791;
	movq	$print_signed_long, %rdi	# rdi = x (=$print_signed_long)
	movq	$my_id, %rax				# mov the address of my_id to rax (temporary register because we want to access the value in the address)
	movq	(%rax), %rsi				# rsi = &my_id
	xorq	%rax, %rax					# we must zero out the rax register before calling printf
	call	printf						# printf(rdi, rsi);

	# 2
	movq	$my_id, %rax	# mov the my_id's second byte to rbx
	movsbq	1(%rax), %rbx	# NOTE that rbx is 64 bits and therefore we should movsbq to extend the sign bit
							# because if dec_2 (which is 8 bits) equals -120, then we also want rbx (64 bits) to equal -120
	movq	(%rax), %rcx	# rcx will hold my_id's value
	movq	%rbx, %rax
	andq	$0x1, %rax		# if (rax&1 == 0) { even } else { odd }
	cmpq	$0x0, %rax
	je		even
odd:
	imulq	$3, %rcx
	jmp		end_if
even:
	# divq divides %rdx:%rax (concatenation of these registers) by its operand
	xorq	%rdx, %rdx	# make sure %rdx:%rax = %rcx = my_id
	movq	%rcx, %rax
	movq	$3, %rsi	# make sure the divq operand (rsi) is 3
	divq	%rsi
	movq	%rdx, %rcx	# the remainder is in rdx, and we want to print rcx
end_if:
	movq	$print_signed_long, %rdi	
	movq	%rcx, %rsi				
	xorq	%rax, %rax					
	call	printf						

	# 3
	movq	$my_id, %rax
	movb	2(%rax), %dl		# byte 3 into dl (first byte of rdx)
	movb	(%rax), %al			# byte 1 into al (first byte of rax)
	xorb	%dl, %al			# xor_13 into al
	cmpb	$127, %al			
	ja		should_print_true	# if (127 < al) { should_print_true } else { should_print_false }
								# we use ja because we want UNSIGNED comparison
should_print_false:
	movq	$print_false, %rdi
	jmp		print_task_3
should_print_true:
	movq	$print_true, %rdi
print_task_3:
	xorq	%rax, %rax
	call	printf

	# 4
	xorq	%rsi, %rsi					# rsi will contain the number of 1's (that we want to print)
	movq	$my_id, %rax				
	movb	3(%rax), %bl				# bl (first byte of rbx) will contain the third byte of my_id
	xorq	%rdx, %rdx					# rdx will be the counter (we want to run 8 iterations, i.e. for each bit)
while_loop:
	inc		%rdx						# rdx++
	cmpq	$8, %rdx					# if (rdx > 8) { end_while_loop }
	ja		end_while_loop
	movb	%bl, %al					
	andb	$0x1, %al					# al contains the first BIT of bl, which means al is either 0 or 1
	addb	%al, %sil					# sil (rsi) += al
	shrb	$1, %bl						# bl >>= 1, i.e. move all bytes to the right
	jmp		while_loop
end_while_loop:
	movq	$print_signed_long, %rdi
	xorq	%rax, %rax
	call	printf

	xorq	%rax, %rax
	movq	-8(%rbp), %rbx	#restoring the save register (%rbx) value, for the caller function.
	movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS).
