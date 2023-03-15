; csc 221-80
; project 07
; Program description: converts lower case string of max 64 characters to upper case 
; Author: Achraf El Khatib
; Date: 11-13-2020 
;

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data 
	input BYTE 64 DUP(-1),0

.code
main PROC
	mwrite <"Enter a string of max 64 characters: ">
	mov edx, OFFSET input
	mov ecx, LENGTHOF input
	call readString										;gets the input string form the user
	call toUpper										;calls toUpper to upper case the lower case characters
	call crlf											;adds an empty space line
	call WriteString									;writes the string after the toUpper

	exit
main ENDP
;  Description: Loop through the string and changes the lower case characters to upper case
;  Recieves:    EDX: address of the string to look at 
;               ECX: number of element in string 
;  Returns:     EDX: the string modified to upper case
;  Requires: 
toUpper PROC USES EDX 				;Method used to upper case lower case characters in a string
	TOP:							;loop to upper case every letter in a string						
		mov al, [edx]				;moves element into al

		cmp al, BYTE PTR 32d		;compares element in al to unprintable characters
		jbe SKIP					;jumps to skip if character is unprintable

		cmp al, 'a' 				;compares element to the first lower case alphabetical character 
		jb SKIP						;jumps to skip if character is lower then lower case a

		cmp al, 'z'					;compares element to the last lower case alphabetical character 
		ja SKIP						;jumps to skip if character is higher then lower case z

		and al, 11011111b			;adds the binary value 11011111 to the elements binary number to change the character from lower case to upper case
		mov [edx], al				;moves the element after upper case to the string
		
		SKIP:
		
		inc edx 					;increases the edx value in order to go through every position in the string
	loop TOP
	ret

toUpper ENDP

END main
