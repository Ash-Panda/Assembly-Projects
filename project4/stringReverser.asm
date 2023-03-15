; csc 221-80
; project 04
; Program description: reversing a string
; Author: Achraf El Khatib
; Date: 10-18-2020 

INCLUDE Irvine32.inc
INCLUDE macros.inc

MAX = 64
.data

	input BYTE MAX DUP(' '),0
	string BYTE MAX DUP(' '),0
	ask BYTE "Enter a String: ",0
	result BYTE "OUTPUT:",0
	actual_length DWORD ?
.code
main proc
    
    mov edx, OFFSET ask
    call WriteString
	
    mov edx, OFFSET input                 
    mov ecx, LENGTHOF input
    call ReadString                 
    
	mov actual_length, eax         
		mov esi, OFFSET input
		mov ecx, SIZEOF input
    call ShowBuffer
	
	exit
main ENDP



ShowBuffer PROC
    mov ebx, 0
	mov edx, actual_length
    LOOP1:
        mov eax, 0             
        mov al, bl             
		mov al, [esi]           
        mov [string + edx], al
		dec edx
		add esi, TYPE BYTE      
        inc bl                  
    loop LOOP1
    
	mov ebx, 0
	call crlf
	
	mov esi, OFFSET string
	mov ecx, SIZEOF string
	
	mov edx, OFFSET result
	call WriteString
	
	LOOP2:
		mov eax, 0
		mov al, bl
		mov al, [esi]
		call WriteChar
		add esi, TYPE BYTE
		inc bl
	loop LOOP2
	
	call crlf
	ret
	
ShowBuffer ENDP

END main
