TITLE Composite Numbers     (CompositeNumbers.asm)

; Author: Oliver Solorzano
; Last Modified: 16 Feb 2019
; OSU email address: solorzao@oregonstate.edu
; Course number/section: CS 271 W 2019
; Project Number: Program #4          Due Date: 17 Feb 2019
; Description: This is a program that calculates composite numbers in
; the range of 1-400. It asks the user how many composites the would 
; like displayed, then proceeds to calculate and display all of the 
; composite numbers up to and including that term.  

INCLUDE Irvine32.inc

UPPER_LIMIT = 400				;upper limit for Fibonacci terms
LOWER_LIMIT = 1

.data
n			DWORD	?			;total composite numbers chosen by user
k			DWORD	?			;current nth term, used for checking if composite
tenLine		DWORD	0			;counter to keep track of amount of numbers on line
intro1		BYTE	"Composite Numbers",0
intro2		BYTE	"Programmed by Oliver Solorzano",0
prompt1		BYTE	"Enter the number of composite numbers you would like to see. ",0
prompt2		BYTE	"Up to 400 composites may be displayed. ",0
prompt3		BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
prompt4		BYTE	"Out of range. Enter a number in [1 .. 400]:  ",0
goodbye		BYTE	"Program ended, Goodbye ", 0
space		BYTE	"     ", 0

.code

main PROC
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

	exit	; exit to operating system

main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

introduction PROC

	mov		edx,OFFSET intro1		;print program name to user
	call	WriteString
	call	Crlf
	mov		edx, OFFSET intro2		;print programmer name to user
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET prompt1		;tell user about program
	call	WriteString
	call	Crlf
	mov		edx,OFFSET prompt2		;tell user range of terms they can enter
	call	WriteString
	call	CrLf
	ret

introduction ENDP

;Procedure to number of composites requested by user.
;receives: none
;returns: number of composites needed
;preconditions:  none
;registers changed: edx, eax

getUserData PROC

;Display instructions 
	
	mov		edx, OFFSET prompt3		;ask user for input
	call	WriteString
	call	ReadInt
	mov		n, eax					;store number of terms in n
	call	validate				;call function to check if input is valid

	ret

getUserData ENDP

;Procedure to validate user input
;receives: Initial user input
;returns: valid input to use in check later
;preconditions:  needs inital input from user
;registers changed: edx, eax

validate PROC

check:

	cmp		n, LOWER_LIMIT		;check user number to see if under lower limit
	jl		inputAgain					;if less than lower limit, ask again
	cmp		n, UPPER_LIMIT		;check user number to see if over upper limit
	jg		inputAgain					;if greater than upper limit, ask again
	
	ret

inputAgain:

	mov		edx, OFFSET prompt4			;tell user input is invalid
	call	WriteString
	call	ReadInt					
	mov		n, eax						;store new value
	jmp		check						;check value again

validate ENDP

;Procedure to check for composite numbers 
;receives: validated user input
;returns: composite numbers, until number requested by user is reached
;preconditions:  needs validated input
;registers changed: edx, eax, ebx, ecx

showComposites PROC

	call	CrLf
	mov		k, 4			;set intial number to 4, 4 is first possible composite
	mov		tenLine, 0	;intialize accumulator
	mov		ecx, n			;enter number of times to execute the loop(number of composite #'s needed), only decrement when composite number is reached
	jmp		compositeCheck	;start composite check

;create new line after reaching five terms

printOk:

	call	printComposite			;call function to print composite
	jmp		endCheck				;jump to end of composite check loop

;execute composite check for desired number of terms

compositeCheck:

	mov		edx, 0					;set register to 0 to ensure junk value isn't divided
	mov		eax, k					;load current number into register
	mov		ebx, 2					;load 2 into register
	div		ebx						;divide number 1 by number 2
	cmp		edx, 0					;check to see if remainder is 0
	je		printOk					;if remainder is 0, number is composite, print

	mov		edx, 0					;set register to 0 to ensure junk value isn't divided
	mov		eax, k					;load current number into register
	mov		ebx, 3					;load 3 into register
	div		ebx						;divide number 1 by number 2
	cmp		edx, 0					;check to see if remainder is 0
	je		printOk					;if remainder is 0, number is composite, print

	mov		edx, 0					;set register to 0 to ensure junk value isn't divided
	mov		eax, k					;load current number into register
	mov		ebx, 5					;load 5 into register
	div		ebx						;divide number 1 by number 2
	cmp		edx, 0					;check to see if remainder is 0
	je		printOk					;if remainder is 0, number is composite, print

	mov		edx, 0					;set register to 0 to ensure junk value isn't divided
	mov		eax, k					;load current number into register
	mov		ebx, 7					;load 7 into register
	div		ebx						;divide number 1 by number 2
	cmp		edx, 0					;check to see if remainder is 0
	je		printOk					;if remainder is 0, number is composite, print

	inc		ecx						;if not composite, increment to keep counter same

endCheck:
	
	inc		k						;increment by 1 to check next number in sequence
	loop	compositeCheck			;repeat until ecx is 0
	
	ret

showComposites ENDP

;Procedure to print composite numbers 
;receives: composite number, number counter 
;returns: prints number to user, creates new line after every 3 numbers
;preconditions:  needs composite number
;registers changed: edx, ecx


printComposite PROC

	mov		eax, k	
	cmp		k, 5				;if k is 5 or 7, can be false positive in composite check
	je		baseCase			
	cmp		k, 7
	je		baseCase
	call	WriteDec			;print value of k in eax
	mov		edx, OFFSET space	;print space after number
	call	WriteString		
	inc		tenLine				;increment number counter
	cmp		tenLine, 10			;if number counter has reached 3, make new line
	je		nextLine			
	jl		return				;if number count below 3, skip

baseCase:
	inc		ecx					;skip base cases and increment ecx counter to keep same
	jmp		return

nextLine:

	mov		tenLine, 0			;reset number counter
	call	CrLf				;create new line

return:
	
	ret

printComposite ENDP

;Procedure to print goodbye
;receives: none
;returns: goodbye message to user
;preconditions:  none
;registers changed: edx

farewell PROC

	call	CrLf
	call	CrLf
	mov		edx, OFFSET goodbye		;say goodbye to user once completed
	call	WriteString

	ret

farewell ENDP

END main

