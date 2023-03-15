; csc 221-80
; project 08
; Program description: converts lower case string of max 64 characters to upper case abd numbers to their binary value
; Author: Achraf El Khatib
; Date: 11-20-2020 
;

INCLUDE Irvine32.inc
INCLUDE Macros.inc
MAX = 63
.data 
	input BYTE MAX+1 DUP(0),0

.code
main PROC
	mwrite <"Enter a string of max 64 characters: ">
	mov edx, OFFSET input
	mov ecx, LENGTHOF input
	call readString										;gets the input string form the user
	call toUpper										;calls toUpper to upper case the lower case characters


	exit
main ENDP
;  Description: Loop through the string and changes the lower case characters to upper case
;  Recieves:    EDX: address of the string to look at 
;               ECX: number of element in string 
;  Returns:     EDX: the string modified to upper case
;  Requires: 
toUpper PROC USES EDX 					;Method used to upper case lower case characters in a string
	TOP:							 	;loop to upper case every letter in a string						
		mov al, [edx]					;moves element into al

		cmp al, '0'						;compares element in al to  0
		jb characterCheck				;jumps to characterCheck if character is below 0 in ascii table
		
		cmp al, '9'						;comapares element in al to 9
		ja characterCheck				;jumps to characterCheck if character is above 9 in ascii table
		
		jmp digit						;jumps to digit if the element in al is a digit
		
		digit:
			mov ebx, TYPE BYTE
			and al, 00001111b			;adds the binary value 00001111 to the element to make it one bite	
			call WriteBinB				;writes the one bite binary number
			call crlf
			jmp SKIP					;jumps to skip after the binary number is printed
		
		characterCheck:
			cmp al, BYTE PTR 32d		;compares element in al to unprintable characters
			jbe SKIP					;jumps to skip if character is unprintable
			
			cmp al, 'a' 				;compares element to the first lower case alphabetical character 
			jb overRule					;jumps to overRule if character is lower then lower case a

			cmp al, 'z'					;compares element to the last lower case alphabetical character 
			ja overRule					;jumps to overRule if character is higher then lower case z

			and al, 11011111b			;adds the binary value 11011111 to the elements binary number to change the character from lower case to upper case
			call WriteChar				;moves the element after upper case to the string
			call crlf
			jmp SKIP
		
		overRule:					
		cmp al, BYTE PTR 32d		;compares element in al to unprintable characters
		jbe SKIP					;jumps to skip if character is unprintable
		
		call WriteChar				;writes character on screen
		call crlf					;creates a new line
		
		SKIP:
		inc edx 					;increases the edx value in order to go through every position in the string
	loop TOP
	ret

toUpper ENDP

END main
