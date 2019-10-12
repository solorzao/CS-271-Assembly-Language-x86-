TITLE Math Magician     (mathmagician.asm)

; Author: Oliver Solorzano
; Last Modified: 17 Jan 2019
; OSU email address: solorzao@oregonstate.edu
; Course number/section: CS 271 
; Project Number: Program 1               Due Date: 20 Jan 2019
; Description: This a program that asks user to enter two numbers, 
; and then calculates the sum, difference, product, quotient, and 
; the remainder of the numbers.

INCLUDE Irvine32.inc

.data

number_1	DWORD	?			;first integer to be entered by user
number_2	DWORD	?			;second integer to be entered by user
intro_1		BYTE	"      Math Magician    by Oliver Solorzano", 0
instr_1		BYTE	"Please enter two numbers. I will then show you the sum, difference, product, quotient, and remainder of those numbers.", 0
instr_2		BYTE	"Enter your first number: ", 0
instr_3		BYTE	"Enter your second number: ", 0
mult_result	DWORD	?			;stores result of multiplication
add_result	DWORD	?			;stores result of addition
sub_result	DWORD	?			;stores result of subtraction
quo_result	DWORD	?			;stores result of division (quotient)
rem_result	DWORD	?			;stores result of division (remainder)
equals		BYTE	" = ", 0	;equal sign
addition	BYTE	" + ", 0	;plus sign
subtract	BYTE	" - ", 0	;subtraction sign
multiply	BYTE	" x ", 0	;multiplication sign
divide		BYTE	" / ", 0	;divide sign
remainder	BYTE	" remainder ", 0	
goodbye		BYTE	"Yer' a math wizard Harry!", 0


.code
main PROC

;print introduction

	mov		edx, OFFSET intro_1		;load introduction
	call	WriteString				;print intro to user
	call	CrLf
	call	CrLf

;get the numbers
	
	mov		edx, OFFSET instr_1		;load instruction
	call	WriteString				;print instruction to user
	mov		edx, OFFSET instr_2		;load second instruction
	call	CrLf
	call	CrLf
	call	WriteString				;tell user to enter first number
	call	ReadInt
	mov		number_1, eax			;store first number in memory
	mov		edx, OFFSET instr_3		;load third instruction
	call	CrLf
	call	WriteString				;tell user to enter second number
	call	ReadInt
	mov		number_2, eax			;store second number in memory

;add the numbers

	mov		eax, number_1			;load first number into register
	add		eax, number_2			;add second number to register
	mov		add_result, eax			;move result to memory

;subtract number 2 from number 1

	mov		eax, number_1			;load first number into register
	sub		eax, number_2			;subtract second number from first 
	mov		sub_result, eax			;move result to memory

;multiply the numbers

	mov		eax, number_1			;load first number to register
	mov		ebx, number_2			;load second number to different register
	mul		ebx						;multiply first and second number
	mov		mult_result, eax		;move result to memory

;divide number 1 by number 2

	mov		edx, 0					;set register to 0 to ensure junk value isn't divided
	mov		eax, number_1			;load first number into register
	mov		ebx, number_2			;load second number into register
	div		ebx						;divide number 1 by number 2
	mov		quo_result, eax			;move quotient result to memory
	mov		rem_result, edx			;move remainder result to memory

;display the results

;display addition results

	call	CrLf
	mov		eax, number_1			
	call	WriteDec				;print first number to user
	mov		edx, OFFSET addition	
	call	WriteString				;print addition symbol to user
	mov		eax, number_2
	call	WriteDec				;print second number to user
	mov		edx, OFFSET equals		
	call	WriteString				;print equals symbol to user
	mov		eax, add_result
	call	WriteDec				;print result addition result to user

;display subtraction results
	
	call	CrLf
	mov		eax, number_1			
	call	WriteDec				;print first number to user
	mov		edx, OFFSET subtract	
	call	WriteString				;print subtraction symbol to user
	mov		eax, number_2			
	call	WriteDec				;print second number to user
	mov		edx, OFFSET equals
	call	WriteString				;print equals symbol to user
	mov		eax, sub_result
	call	WriteDec				;print subtraction result to user

;display multiplication results

	call	CrLf					
	mov		eax, number_1			
	call	WriteDec				;print first number to user
	mov		edx, OFFSET multiply
	call	WriteString				;print multiplication symbol to user
	mov		eax, number_2
	call	WriteDec				;print second number to user
	mov		edx, OFFSET equals
	call	WriteString				;print equals symbol to user
	mov		eax, mult_result
	call	WriteDec				;print multiplication result to user

;display division results

	call	CrLf
	mov		eax, number_1		
	call	WriteDec				;print first number to user
	mov		edx, OFFSET divide
	call	WriteString				;print division symbol to user
	mov		eax, number_2
	call	WriteDec				;print second number to user
	mov		edx, OFFSET equals
	call	WriteString				;print equals symbol to user
	mov		eax, quo_result
	call	WriteDec				;print quotient result to user
	mov		edx, OFFSET remainder
	call	WriteString				;print remainder result to user
	mov		eax, rem_result
	call	WriteDec				;print division result to user
	call	CrLf

;say goodbye

	call	CrLf
	mov		edx, OFFSET goodbye			;load goodbye message
	call	WriteString					;print goodbye message to user

	exit	; exit to operating system
main ENDP

END main
