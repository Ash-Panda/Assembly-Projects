; csc 221-80
; project 02
; Program description:  subtracting in hex
; Author: Achraf El Khatib
; Date: 10-02-2020

INCLUDE Irvine32.inc
.data

	num DWORD 400h
	constant DWORD 1DFh

.code
main PROC

	mov eax, num
	sub eax, constant
	
	call WriteHex 

	exit
main ENDP 
END main
