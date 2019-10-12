TITLE IO Procedures     (IOProcedures.asm)

; Author: Oliver Solorzano
; Last Modified: 15 Mar 2019
; OSU email address: solorzao@oregonstate.edu
; Course number/section: CS 271 W 2019
; Project Number: 6A      Due Date: 17 Mar 2019
; Description: This program takes 10 validated integers and stores the numeric
; values in an array. It then displays the numbers, their sum, and their average. 

INCLUDE Irvine32.inc

LIMIT = 10			;user can only enter ten values
MAX = 2147483647	;max unsigned int value
MIN = 0				;min unsigned int value

;getString Macro
;receives: none
;returns: user input as string
;preconditions:  validated user input
;registers changed: eax, edx, ecx, edi

getString	MACRO 
	
	push	eax
	push	edx
	push	ecx
	push	edi

	mov		ecx, 32			;set input size limit
	mov		edx, [ebp+16]	;move temp into edx
	mov		edi, [ebp+8]	;move strLen address into edi
	call	ReadString		;store string in temp
	mov		[edi], eax		;store length in strLen
	
	pop		edi
	pop		ecx
	pop		edx
	pop		eax
	
ENDM

;displayString Macro
;receives: string address
;returns: outputs string to user
;preconditions:  string address with string
;registers changed: edx

displayString	MACRO str

	push	edx

	mov		edx, str		;move string to edx, print
	call	WriteString

	pop		edx

ENDM

.data

intArray	DWORD	LIMIT DUP(?)		;array to hold integer values
temp		BYTE	33 DUP(?)			;temp string for user input/output
final		BYTE	33 DUP(?)			;final string for reversed values
tempChar	DWORD	?					;holds value of al for conversion
storeInt	DWORD	?					;holds converted string byte as int
strLen		DWORD	?					;holds length of string
average		DWORD	?					;average value ints entered by user
sum			DWORD	?					;sum of values entered by user
intro1		BYTE	"Programming Assignment 6A: Designing low-level I/O procedures",0
intro2		BYTE	"Programmed by: Oliver Solorzano",0
instr1		BYTE	"Please provide 10 unsigned decimal integers.", 0
instr2		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
instr3		BYTE	"After you have finished inputting the raw numbers I will display a list",0
instr4		BYTE	"of the integers, their sum, and their average value.",0
prompt1		BYTE	"Please enter an unsigned number: ",0
prompt2		BYTE	"Please try again: ",0
error		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
feedback1	BYTE	"You entered the following numbers: ",0
feedback2	BYTE	"The sum of these numbers is: ",0
feedback3	BYTE	"The average is: ",0
feedback4	BYTE	"Thanks for playing! Goodbye",0

;main procedure, controls program flow
;receives: none
;returns: none
;preconditions:  none
;registers changed: none

.code
main PROC
	
	pushad
	push	OFFSET intro1
	push	OFFSET intro2
	push	OFFSET instr1
	push	OFFSET instr2
	push	OFFSET instr3
	push	OFFSET instr4
	call	introduction		;call intro procedure
	popad

	pushad
	push	OFFSET tempChar
	push	OFFSET storeInt
	push	OFFSET prompt1
	push	OFFSET prompt2
	push	OFFSET error
	push	OFFSET temp
	push	OFFSET intArray
	push	OFFSET strLen
	call	ReadVal				;call procedure to get user input and store
	popad

	pushad
	push	OFFSET intArray
	push	OFFSET sum
	push	OFFSET average
	call	calculate			;call procedure to find average and sum
	popad

	pushad
	push	OFFSET final
	push	OFFSET temp
	push	OFFSET feedback1
	push	OFFSET feedback2
	push	OFFSET feedback3
	push	OFFSET feedback4
	push	OFFSET intArray
	push	OFFSET sum
	push	OFFSET average
	call	WriteVal			;call procedure to convert values to strings and display
	popad

	exit	; exit to operating system
main ENDP

;intro procedure, prints description and instructions to user
;receives: string address
;returns: outputs strings
;preconditions:  string addresses with strings
;registers changed: edx

introduction PROC

	push	ebp
	mov		ebp, esp		;set up stack frame

	mov		edx, [ebp+28]	;print intro1
	call	WriteString
	call	CrLf 
	mov		edx, [ebp+24]	;print intro2
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, [ebp+20]	;print instr1
	call	WriteString
	call	CrLf
	mov		edx, [ebp+16]	;print instr2
	call	WriteString
	call	CrLf
	mov		edx, [ebp+12]	;print instr3
	call	WriteString
	call	CrLf
	mov		edx, [ebp+8]	;print instr4
	call	WriteString
	call	CrLf
	call	CrLf

	pop		ebp	
	ret		24				;clear stack

introduction ENDP

;readVal procedure, gets user string and stores as numeric
;receives: user input
;returns: converted strings into int array
;preconditions:  none
;registers changed: edx, esi, edi, eax, ebx

ReadVal PROC

	push	ebp
	mov		ebp, esp	;set up stack frame
	mov		ebx, 0		;set valid int counter
	jmp		default
again:

	push	edx
	mov		edx, [ebp+20]	;output error message
	call	WriteString
	call	CrLf
	mov		edx, [ebp+24]
	call	WriteString
	mov		esi, [ebp+16]	;load address of user input into esi
	getString	
	pop		edx
	
	jmp		check
default:
	push	edx
	mov		edx, [ebp+28]	;print prompt1
	call	WriteString
	mov		esi, [ebp+16]	;load address of user input into esi
	getString	
	pop		edx
check:
	mov		edi, [ebp+8]	;load strLen address to edi
	mov		ecx, [edi]		;load string length into ecx
	mov		edi, [ebp+32]	;load address of storeInt into edi
	mov		eax, 0			;reset storeInt value for next int
	mov		[edi], eax
	
advance:
	cld						;set forward
	lodsb
	cmp		al,48			; '0' is character 48
	jb		again
	cmp		al, 57			; '9' is character 57
	ja		again
	push	esi
	mov		esi, [ebp+36]	;move tempChar address to esi
	mov		[esi], al
	call	convertToNum		;convert to numeric
	pop		esi
	loop	advance

	mov		edi, [ebp+32]			;load address of stored int
	cmp		DWORD PTR [edi], MIN	;check to see if greater than min
	jl		again
	cmp		DWORD PTR [edi], MAX	;check to see if greater than max
	jg		again

valid:
	push	esi
	mov		esi, [ebp+12]		;load address of array
	mov		eax, 4				;load dword size into eax
	mul		ebx					;multiply size by count to get next spot in array
	mov		edx, [edi]			;move int value to edx
	add		esi, eax
	mov		[esi], edx			;move edx value to place in array
	pop		esi
	inc		ebx					;inc counter
	cmp		ebx, LIMIT			;see if 10 valid ints have been reached
	jl		default

	pop		ebp	
	ret		32				;clear stack

ReadVal ENDP

;convertToNum procedure, converts strings to numeric
;receives: string
;returns: int value in array
;preconditions:  validated string input
;registers changed: eax, ebx, edi

convertToNum	PROC 

	push	eax
	push	ebx
	push	edi

	mov		ebx, 10			;set ebx to ten
	mov		edi, [ebp+32]	;move storeInt address to edi
	push	eax
	mov		eax, [edi]		;move value of storeInt to eax
	mul		ebx				;multiply by 10
	mov		[edi], eax		;move multiplied value to storeInt
	pop		eax
	push	esi
	mov		[esi], al			;mov char val to eax
	mov		eax, [esi]
	pop		esi
	sub		eax, 48			;subtract 48 from char value
	add		[edi], eax		;add

	pop		edi
	pop		ebx
	pop		eax

	ret
convertToNum ENDP

;calculate procedure
;receives: int array
;returns: sum and average of int array values
;preconditions:  int array
;registers changed: esi, edi, ecx, eax, ebx, edx

calculate PROC

	push	ebp
	mov		ebp, esp	;set up stack frame

	mov		esi, [ebp+16]	;load int array
	mov		edi, [ebp+12]	;load sum variable
	mov		ecx, 10			;set counter to array size

accumulator:
	mov		eax, 4				;load dword size into eax
	mov		ebx, ecx			;load current count into ebx
	dec		ebx					;dec ebx to get right spot in array
	mul		ebx					;multiply size by count to get next spot in array
	mov		edx, [esi+eax]		;load value in array position to edx
	add		[edi], edx			;add edx to sum
	loop	accumulator			;keep looping until end of array

	mov		esi, [ebp+8]		;load average variable
	mov		edx, 0				;set register to 0 to ensure junk value isn't divided
	mov		eax, [edi]			;load total sum into eax
	mov		ebx, 10				;load array size into register
	div		ebx					;divide number total by number of terms in array
	mov		[esi], eax			;move quotient result to average variable

	pop		ebp
	ret		12					;clear stack

calculate ENDP

;WriteVal procedure, calls convert procedure, prints converted strings to user
;receives: numeric values in array
;returns: prints converted values as strings
;preconditions:  int array
;registers changed: esi, ebx

WriteVal PROC
	push	ebp
	mov		ebp, esp
	
	mov		esi, [ebp+16]		;load array address
	mov		ebx, 0				;set counter
	call	CrLf
	displayString [ebp+32]		;display message to user
	call	CrLf
	jmp		throughArray

addPunctuation:

	mov		al, 44
	call	WriteChar
	mov		al, 32				;create spaces
	call	WriteChar
throughArray:

	call	convertToChar 
	displayString [ebp+40]		;display converted string
	add		esi, 4				;move to next spot in array
	inc		ebx
	cmp		ebx, LIMIT			;if array size hasn't been reached, keep iterating
	jl		addPunctuation

	call	CrLf
	displayString [ebp+28]		;display sum message
	mov		esi, [ebp+12]		;load sum address
	call	convertToChar
	displayString [ebp+40]		;display converted sum

	call	CrLf
	displayString [ebp+24]		;display average message
	mov		esi, [ebp+8]		;load average value address
	call	convertToChar
	displayString [ebp+40]		;display converted sum
	call	CrLf
	call	CrLf

	displayString [ebp+20]		;display end message

	pop		ebp
	ret		36					;clear stack
WriteVal ENDP

;convertToChar procedure, converts numeric values to string
;receives: numeric values in array
;returns: string values from numeric
;preconditions:  int array values
;registers changed: eax, ebx, edi, edx, esi, ecx

convertToChar	PROC
	
	push	eax
	push	ebx
	push	edi
	push	edx
	push	esi
	push	ecx

	mov		edi, [ebp+36]			;load address to temp string variable
	cld
	mov		eax, [esi]				;load initial number into register
	mov		ecx, 0

keepMoving:
	mov		edx, 0					;set register to 0 to ensure junk value isn't divided
	mov		ebx, 10					;load second number into register
	div		ebx						;divide number 1 by number 2
	push	eax
	add		edx, 48					;add 48 to remainder to make char
	mov		eax, edx				;mov char value to al register
	stosb	
	pop		eax
	inc		ecx
	cmp		eax, 0
	jne		keepMoving


	mov		esi, [ebp+36]
	mov		edi, [ebp+40]			;first byte of outString
	add		esi, ecx
	dec		esi

reverse:
	std					;get characters from end to beginning
	lodsb				;store characters from beginning to end
	cld
	stosb
	loop	reverse

	mov	al, 0			;add null terminator to new string
	stosb

	pop		ecx
	pop		esi
	pop		edx
	pop		edi
	pop		ebx
	pop		eax

	ret
convertToChar ENDP


END main

