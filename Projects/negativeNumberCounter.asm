TITLE Negative Number Counter    (NegativeNumberCounter.asm)

; Author: Oliver Solorzano
; Last Modified: 11 Feb 2019
; OSU email address: solorzao@oregonstate.edu
; Course number/section: CS 271
; Project Number: Assignment #3     Due Date: 10 Feb 2019
; Description: This is a program that counts and accumulates
; negative numbers input by a user. It then calculates the average
; of those numbers and prints them to the user.

INCLUDE Irvine32.inc

LOWER_LIMIT = -100				;lower limit for user input
UPPER_LIMIT = 0					;limit to stop input		
MID_VALUE = -50

.data
sumTotal	SDWORD	?			;total sum of numbers entered by user
intCounter	DWORD	?			;counter for number of ints entered by user
userInt		SDWORD	?			;current int entered by user
quo_result	SDWORD	?			;quotient value of division
rem_result	SDWORD	?			;remainder value of division
rem_whole	SDWORD	?			;remainder as whole number
userName	BYTE	33 DUP(0)	;string entered by user
intro1		BYTE	"Welcome to the Negative Number Counter by Oliver Solorzano",0
prompt1		BYTE	"What is your name? ", 0
prompt2		BYTE	"Please enter numbers in [-100, -1]. ", 0
prompt3		BYTE	"Enter a non-negative number when you are finished to see results. ", 0
prompt4		BYTE	"Enter Number: ", 0
prompt5		BYTE	"Out of range. Enter a number in [-100, -1]. ", 0
prompt6		BYTE	"You entered ", 0
prompt7		BYTE	" valid numbers.", 0
prompt8		BYTE	"The sum of your valid numbers is ", 0
prompt9		BYTE	"The rounded average is ", 0
response1	BYTE	"Hello, ", 0
goodbye		BYTE	"Thank you for using the Negative Number Counter! Goodbye, ", 0
space		BYTE	"     ", 0

.code
main PROC
;Display intro
	mov		edx, OFFSET intro1		;print program name to user
	call	WriteString
	call	CrLf

;Display instructions (get user name)
	mov		edx, OFFSET prompt1		;ask user for name
	call	WriteString
	mov		edx, OFFSET userName	;store user name
	mov		ecx, 32
	call	ReadString

;Say hello
	mov		edx, OFFSET response1	;say hello to user
	call	WriteString
	mov		edx, OFFSET userName	;print user name
	call	WriteString
	call	CrLf

;Display second set of instructions
	mov		edx, OFFSET prompt2		;ask user for negative numbers in ranges
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt3     ;tell user how to exit program
	call	WriteString
	mov		intCounter, 0			;initialize counter to 0
	mov		sumTotal, 0				;initialize starting sum to 0
	call	CrLf
	
numberInput:

	mov		edx, OFFSET prompt4		;ask user for input
	call	WriteString
	call	ReadInt
	mov		userInt, eax		

;validate the input

numberCheck:

	cmp		userInt, LOWER_LIMIT		;check user number to see if past upper limit
	jl		numberInput
	cmp		userInt, UPPER_LIMIT
	jl		validInput
	cmp		userInt, UPPER_LIMIT
	jge		inputDone

validInput:

	inc		intCounter
	add		sumTotal, eax
	jmp		numberInput

;print input

inputDone:

	mov		edx, OFFSET	prompt6		
	call	WriteString
	mov		eax, intCounter
	call	WriteDec
	mov		edx, OFFSET prompt7
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt8
	call	WriteString
	mov		eax, sumTotal
	call	WriteInt
	call	CrLf

;calculate Average

	mov		eax, sumTotal			;load sum of ints into register
	cdq
	mov		ebx, intCounter			;load total number of ints into register
	idiv	ebx						;divide sum by number of ints
	mov		quo_result, eax			;move quotient result to memory
	mov		rem_result, edx			;move remainder result to memory
	


;round Average

	mov		eax, rem_result
	cdq
	mov		ebx, 100
	mul		ebx
	mov		rem_whole, eax

	mov		eax, rem_whole
	cdq
	mov		ebx, intCounter
	idiv	ebx
	mov		rem_whole, eax

	cmp		rem_whole, -50	
	jl		roundUp
	jge		endProgram

roundUp:

	mov		eax, -1
	add		quo_result, eax


endProgram:
	
	mov		edx, OFFSET prompt9
	call	WriteString
	mov		eax, quo_result
	call	WriteInt
    call	CrLf
	call	CrLf
	mov		edx, OFFSET goodbye		;say goodbye to user once completed
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString

	exit				;exit to operating system
main ENDP

END main
