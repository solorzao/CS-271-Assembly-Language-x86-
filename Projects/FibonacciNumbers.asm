TITLE Fibonacci Numbers     (FibonacciNumbers.asm)

; Author: Oliver Solorzano
; Last Modified: 24 Jan 2019
; OSU email address: solorzao@oregonstate.edu
; Course number/section: CS 271
; Project Number: Assignment #2     Due Date: 27 Jan 2019
; Description: This is a program that calculates and displays 
; Fibonacci numbers up to an "nth" term, as chosen by the user.

INCLUDE Irvine32.inc

UPPER_LIMIT = 46				;upper limit for Fibonacci terms

.data
fibTotal	DWORD	?			;total Fibonacci numbers chosen by user
prevValue	DWORD	?			;previous value
fiveLine	DWORD	?			;counter to keep track of values on line
userName	BYTE	33 DUP(0)	;string entered by user
intro1		BYTE	"Fibonacci Numbers",0
intro2		BYTE	"Programmed by Oliver Solorzano",0
prompt1		BYTE	"What is your name? ",0
prompt2		BYTE	"Enter the number of Fibonacci terms to be displayed. ",0
prompt3		BYTE	"Give the number as an integer in the range [1 .. 46]. ", 0
prompt4		BYTE	"Out of range. Enter a number in [1 .. 46]. ", 0
response1	BYTE	"Hello, ", 0
goodbye		BYTE	"Goodbye, ", 0
space		BYTE	"     ", 0

.code
main PROC
;Display intro
	mov		edx,OFFSET intro1		;print program name to user
	call	WriteString
	call	Crlf
	mov		edx, OFFSET intro2		;print programmer name to user
	call	WriteString
	call	CrLf
	call	CrLf

;Display instructions (get user name)
	mov		edx, OFFSET prompt1		;ask user for name
	call	WriteString
	mov		edx, OFFSET userName	;store user name
	mov		ecx, 32
	call	ReadString
	call	Crlf

;Say hello
	mov		edx, OFFSET response1	;say hello to user
	call	WriteString
	mov		edx, OFFSET userName	;print user name
	call	WriteString
	call	CrLf

;Display second set of instructions
	mov		edx,OFFSET prompt2		;ask user for number of fibonacci terms
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt3
	call	WriteString
	call	ReadInt
	mov		FibTotal, eax			;store number of terms in FibTotal

;validate the input

numberCheck:
	cmp		eax, UPPER_LIMIT		;check user number to see if past upper limit
	jle		inputOK					;if ok proceed to calculate
	mov		edx, OFFSET prompt4		;if not ok, tell user and ask again
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		fibtotal, eax
	jg		numberCheck				;repeat until input is valid

;initialize accumulator and loop control
inputOK:

	mov		fiveLine, 0		;intialize accumulator
	mov		eax, 1			;first number in sequence
	mov		ebx, 0			;second number in sequence
	mov		ecx, fibTotal	;calculate number of times to execute the loop

;create new line after reaching five terms
nextLine:
	mov		fiveLine, 0		;reset number counter
	call	CrLf			;create new line
	jmp		fibSequence		;jump back to continue fibonacci sequence

;execute fibonacci sequence for desired number of terms
fibSequence:
	call	WriteDec			;print current value
	mov		prevValue, eax		;store previous value
	add		eax, ebx			;add previous value to first number
	mov		ebx, prevValue		;change value of second number to previous value of first number
	mov		edx, OFFSET space	;print fibonacci number to user
	call	WriteString		
	inc		fiveLine			;increment number counter
	cmp		fiveLine, 5			;if number counter has reached 5, make new line
	je		nextLine
	loop	fibSequence				;repeat until ecx is 0

endProgram:
    call	CrLf
	call	CrLf
	mov		edx, OFFSET goodbye		;say goodbye to user once completed
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString

	exit				;exit to operating system
main ENDP

END main
