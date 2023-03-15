; csc 221-80
; project 01
; Program description: Hello world program 
; Author: Achraf El Khatib
; Date: 9-29-2020

INCLUDE Irvine32.inc
.data
	;declare data variables
message BYTE "Hello World!", 13,10,0 ;declared message as a byte and saved the message "hello world!" into it

.code
main PROC
	;write code here
	mov edx, offset message 
	call writeString ;calls the message into the console
	
	exit ;exits the code
main ENDP
END main 
