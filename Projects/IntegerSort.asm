TITLE Random Integer Sorter     (IntegerSort.asm)

; Author: Oliver Solorzano
; Last Modified: 26 Feb 2019
; OSU email address: solorzao@oregonstate.edu
; Course number/section: CS 271 W 2019
; Project Number: Assignment #5          Due Date: 03 Mar 2019
; Description: Program that asks the user to choose the size of a list,
; stores random numbers to fill that list as an array, displays the integers in
; the list, sorts the integers in descending order, calculates and displays 
; the median value, then displays the sorted list.

INCLUDE Irvine32.inc

MIN = 10
MAX = 200
LO = 100
HI = 999

.data

integerArray	DWORD	MAX DUP(?)		;array to hold integer values
userRequest		DWORD	?				;number of integers user would like to see in array
median			DWORD	?				;median value of sorted list
tenLine			DWORD	?				;counter to keep track of amount of numbers on line
intro1			BYTE	"Welcome to Sorting Random Integers		by Oliver Solorzano",0
intro2			BYTE	"This program generates random numbers in the range [100 .. 999], ",0
intro3			BYTE	"displays the original list, sorts the list, and calculates the ",0
intro4			BYTE	"median value. Finally, it displays the list sorted in descending order.",0
prompt1			BYTE	"How many numbers should be generated? Range [10 .. 200] ",0
invalid			BYTE	"Invalid input, please try again. ",0
medResult		BYTE	"The median is: ",0
srtdList		BYTE	"The sorted list: ",0
unSrtdList		BYTE	"The unsorted random numbers: ",0


;main procedure, controls program flow
;receives: none
;returns: none
;preconditions:  none
;registers changed: none

.code
main PROC
	call	randomize			;call randomize to seed random number generation

	push	OFFSET intro1
	push	OFFSET intro2
	push	OFFSET intro3
	push	OFFSET intro4
	call	introduction		;call intro procedure

	push	OFFSET prompt1
	push	OFFSET userRequest
	push	OFFSET invalid
	push	OFFSET prompt1
	call	getData				;call procedure to get user input

	push	OFFSET integerArray
	push	userRequest
	call	fillArray			;call procedure to fill array with random ints

	push	OFFSET integerArray
	push	OFFSET unSrtdList
	push	OFFSET tenLine
	push	userRequest
	call	displayList			;call procedure to display unsorted numbers

	
	push	OFFSET integerArray
	push	userRequest
	call	sortList			;call procedure to sort numbers

	push	OFFSET integerArray
	push	OFFSET median
	push	userRequest
	call	findMedian			;call procedure to find median

	push	OFFSET medResult
	push	median
	call	displayMedian		;call procedure to display median

	push	OFFSET integerArray
	push	OFFSET srtdList
	push	OFFSET tenLine
	push	userRequest
	call	displayList			;call procedure to display sorted numbers

	exit	; exit to operating system
main ENDP

;Procedure to introduce program to user
;receives: addresses for different sections of into
;returns: none
;preconditions:  none
;registers changed: edx

introduction PROC
	push	ebp
	mov		ebp, esp		;set up stack frame

	mov		edx, [ebp+20]	;print intro1
	call	WriteString
	call	CrLf
	call	CrLf 
	mov		edx, [ebp+16]	;print intro2
	call	WriteString
	call	CrLf
	mov		edx, [ebp+12]	;print intro3
	call	WriteString
	call	CrLf
	mov		edx, [ebp+8]	;print intro4
	call	WriteString
	call	CrLf
	call	CrLf

	pop		ebp	
	ret		16				;empty stack

introduction ENDP

;Procedure to get input from user
;receives: address of userRequest, instructions, feedback
;returns: user input in userRequest variable
;preconditions:  none
;registers changed: edx, eax, ebx, edi

getData PROC

	;Display instructions 
	push	ebp					;set up stack frame
	mov		ebp, esp

	mov		edx, [ebp+20]		;ask user for input
	mov		ebx, [ebp+16]		;put address of userRequest in ebx
	call	WriteString
	call	ReadInt
	mov		[ebx], eax			;store number of integers at address in ebx

check:
	mov		edi, [ebp+16]
	mov		[edi], eax
	cmp		DWORD PTR [edi], MIN		;check user number to see if under lower limit
	jl		inputAgain					;if less than lower limit, ask again
	cmp		DWORD PTR [edi], MAX		;check user number to see if over upper limit
	jg		inputAgain					;if greater than upper limit, ask again
	
	pop		ebp
	ret		16					;clear stack

inputAgain:

	mov		edx, [ebp+12]		;tell user input is invalid
	call	WriteString
	call	CrLf
	mov		edx, [ebp+8]
	call	WriteString
	call	ReadInt					
	mov		[ebx], eax			;store new value
	jmp		check				;check value again

getData	ENDP

;Procedure to fill array with random ints, up to what was requested by user
;receives: address of integer array, value of userRequest
;returns: integerArray filled with random integers
;preconditions:  must have validated userRequest 
;registers changed: edx. ecx. edi, eax

fillArray PROC
	
	push	ebp					;set up stack frame
	mov		ebp, esp
	mov		ecx, [ebp+8]		;store number of ints requested in ecx
	mov		edi, [ebp+12]		;store address of integerArray in edi	

next:

	mov		eax, HI				;move HI global constant into eax
	sub		eax, LO				;subtract LO from HI value in eax
	inc		eax					;increment eax to get proper range
	call	RandomRange			
	add		eax, LO				;add the random value to LO to bring back to proper range
	mov		[edi], eax			;move value into current position in array
	add		edi, 4				;move position to next byte in array
	loop	next				;keep looping until the number of ints requested is reached

	pop		ebp					;pop base pointer
	ret		8					;clear stack

fillArray ENDP

;Procedure to sort array of random ints in descending order
;receives: address of integerArray, feedback strings, and line counter
;returns: sorted integerArray
;preconditions:  needs filled int array
;registers changed: edx, ecx, eax, esi

sortList PROC					;modified bubble sort code from Chapter 9.5, pg 407 in Assembly Language for x86 Processors(7th ed)

	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]		;move total count into ecx
	dec		ecx					;decrement count by 1
	
L1:
	mov		esi, [ebp+12]		;move address of array into esi
	push	ecx
	
L2:

	mov		eax, [esi]			;move value
	cmp		[esi+4], eax		;if next value in array is less than current, swap
	jl		L3				
	call	exchange

L3:
	add		esi, 4				;move up in array position
	loop	L2

	pop		ecx
	loop	L1

L4:
	pop		ebp
	ret		8					;clear stack

sortList ENDP

;Procedure to swap array values
;receives: array, values to be switched
;returns: switched array values
;preconditions: left value must be greater than right value in array
;registers changed: eax

exchange PROC

	xchg	eax, [esi+4]		;exchange values
	mov		[esi], eax

	ret

exchange ENDP

;Procedure to find median value in array
;receives: value of array size, addresses of median variable and integerArray
;returns: median value in variable
;preconditions:  needs array size
;registers changed: edx, eax, ebx, esi, edi

findMedian PROC

	push	ebp
	mov		ebp, esp				;set up stack frame

	mov		edx, 0					;set register to 0 to ensure junk value isn't divided
	mov		eax, [ebp+8]			;load array size into eax
	mov		ebx, 2					;load 2 into register
	div		ebx						;divide array size by 2
	cmp		edx, 0					;check to see if remainder is 0
	jg		odd1					;if not zero, size is odd, median in center
	je		even1					;if zero, size is even, median is average of two middle numbers

odd1:
	
	mov		ebx, 4					;load 4 into ebx
	mul		ebx						;multiply eax by ebx (4 bytes per value in array)
	mov		esi, [ebp+16]			;move array address into esi
	add		esi, eax				;add eax to esi to shift position to center
	mov		eax, [esi]				;move value at position into eax
	mov		edi, [ebp+12]			;load address of median container
	mov		[edi], eax				;load median into median container
	jmp		finish

even1:
	
	dec		eax					;decrement to get proper position
	mov		ebx, 4				;load 4 into ebx
	mul		ebx					;multiply eax by ebx (4 bytes per value in array)
	mov		esi, [ebp+16]		;move array address into esi
	add		esi, eax			;add eax to esi to shift position to center
	mov		eax, [esi]			;move value at position into eax
	add		esi, 4				;shift esi by 4 to get next value
	mov		ebx, [esi]			;move value to ebx
	add		eax, ebx			;add both values
	mov		ebx, 2				;move 2 to ebx
	div		ebx					;divide eax by to to get average (median)
	cmp		edx, 0				;if remainder is zero, value is even
	jg		roundUp				;if not zero, value ends in .5, round up
	jmp		finish

roundUp:	
	
	inc		eax					;round up truncated int
	jmp		finish

finish:

	mov		edi, [ebp+12]		;load address of median container
	mov		[edi], eax			;load median into median container

	pop		ebp
	ret		12					;clear stack

findMedian ENDP

;Procedure to display median value to user
;receives: value of median, address of output string
;returns: none
;preconditions:  median value
;registers changed: edx, eax

displayMedian PROC
	
	push	ebp
	mov		ebp, esp
	call	CrLf
	mov		edx, [ebp+12]		;load message for median
	call	WriteString			;display
	mov		eax, [ebp+8]		;load median value
	call	WriteDec			;display
	call	CrLf

	pop		ebp
	ret		8					;clear stack

displayMedian ENDP

;Procedure to display ints in array to user
;receives: array size value and addresses of integerArray, line counter, output string
;returns: none
;preconditions:  filled array
;registers changed: edx, esi, edi, ebx, eax

displayList PROC
	
	push	ebp					;set up stack frame
	mov		ebp, esp
	call	CrLf
	mov		edx, [ebp+16]		;print list description
	call	WriteString
	call	CrLf
	mov		edx, [ebp+8]		;store count to go through in edx
	mov		esi, [ebp+20]		;store address of array in esi
	mov		edi, [ebp+12]		;move tenline address into edi	
	jmp		printInt

nextLine:

	mov		ebx, 0				;reset line counter	
	mov		[edi], ebx
	call	CrLf				;create new line
	jmp		wrapUp

printInt:

	mov		eax, [esi]			;start at beginning of array
	call	WriteDec			;print value
	mov		al, 32				;create spaces
	call	WriteChar
	call	WriteChar
	add		esi, 4				;move to next position in array
	mov		eax, 1
	add		[edi], eax			;add value of eax to number stored in address in edi
	cmp		DWORD PTR [edi], 10	
	je		nextLine			;if count has reached ten call next line

wrapUp:

	dec		edx					;decrease total counter
	cmp		edx, 0
	jg		printInt			;repeat if not all of array has been printed

	mov		edi, [ebp+12]		;move tenline address into edi	
	mov		ebx, 0				;reset line counter	for next call
	mov		[edi], ebx

	call	CrLf
	pop		ebp
	ret		20					;clear stack


displayList ENDP

END main
