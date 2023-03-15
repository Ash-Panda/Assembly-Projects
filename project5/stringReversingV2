; csc 221-80
; project 04
; Program description: reversing a string
; Author: Achraf El Khatib
; Date: 10-18-2020 

INCLUDE Irvine32.inc
INCLUDE macros.inc

MAX = 64
.data

	source       BYTE MAX DUP(' '),0
	destination  BYTE LENGTHOF source DUP(' '),0
	sizeOfString DWORD ?
	ask BYTE "Enter a String: ",0
.code
main proc
    
    mov edx, OFFSET ask
    call WriteString
	
    mov edx, OFFSET source                 
    mov ecx, LENGTHOF source
    call ReadString                 
    
	mov sizeOfString, eax         
	mov esi, OFFSET source
	mov ecx, SIZEOF source
	
    call revstr
	
	call WriteString
	
	exit
main ENDP



revstr PROC
	mov ecx, sizeOfString
	mov esi, 0
  
	storeChar:
		movzx eax, source[esi]
		push eax
		inc esi
	loop storeChar
	
	mov ecx, sizeOfString
	mov esi, 0
	
	reversal:
		pop eax
		mov destination[esi], al
		inc esi
	loop reversal
	
	mov edx, offset destination
	ret
	
revstr ENDP

END main
