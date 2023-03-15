; csc 221-80
; project 06
; Program description: counts the amoutns of negative numbers in an array filled with random numbers
; Author: Achraf El Khatib
; Date: 11-09-2020 
;
; 1. Counting Array Values
; Write an application that does the following: 
; 		(1) fill an array with 50 random integers; 
;		(2) loop through the array, displaying each value, 
;			and count the number of negative values; 
;		(3) after the loop finishes, display the count. 
;	
;	Note: The Random32 procedure from the Irvine32 library generates random integers.
;
;
;

INCLUDE Irvine32.inc
INCLUDE Macros.inc


.data
	array DWORD 50 DUP(-1)
.code
main PROC
	mov esi, OFFSET array
	mov ecx, LENGTHOF array  
	call FillArray 						;calls the function that fills the array
	call DisplayArray					;calls the function that display the array
	call CountArray						;calls the function that counts the amount of negative numbers 
	call CRLF
	mwrite <"There was ">
	call WriteDec
	mwrite <" negative values.",13,10>
	exit
main ENDP

;  fill an array with random integers;
;  ESI: address of the array to fill 
;  ECX: number of element in array 
;   
;  uses IRVINE's0 RANDOM proceedure
;
FillArray PROC USES ECX ESI EAX
	call Randomize					; seed random number generator
	TOP:
		call random32				; invloke IRVINE's RANDOw32
		mov [esi], eax				; put new value in array 
		add esi, TYPE DWORD		  	; increament address 
	LOOP TOP
	ret
FillArray ENDP

;  Description: Loop through the array, displaying each value, 
;  Recieves:    ESI: address of the array to look at 
;               ECX: number of element in array 
;  Returns:
;  Requires:    
DisplayArray PROC USES ECX ESI EAX  ; YOU MAY NEED TO ADD MORE TO THIS USES CLAUSE HERE 
	mov EDX, 0  		        	; use as negitive_count (eax is used for WriteInt)
	TOP:
		mov eax, [esi]		    	; move element into EAX
		add esi, TYPE DWORD			; increatemnt esi
		call WriteInt				; write out value 
		mwriteln <" ">				; write aSPACE
	LOOP TOP					
	ret
DisplayArray ENDP

;  Description: Loop through the array countng the number of negative values;
;  Recieves:    ESI: address of the array to look at 
;               ECX: number of element in array 
;  Returns:     EAX: number of negative values 
;  Requires:    
CountArray PROC USES ECX EDX ESI 		; YOU MAY NEED TO ADD MORE TO THIS USES CLAUSE HERE 
	mov EAX, 0                          ; use as negitive_count 
	TOP:
		mov edx, [esi]                  ; move element into EAX
		add esi, TYPE DWORD              		    ; increatemnt esi
		cmp edx, 0                      ; set CPU flags - this will will set Sign flag if eax is negative
		jnl SKIP                        ; jmp over if NOT negative (Jump Not Signed)
		inc eax						    ; incraetent crement EDX (neg count)
		SKIP:
	LOOP TOP
	ret
CountArray ENDP

END main
