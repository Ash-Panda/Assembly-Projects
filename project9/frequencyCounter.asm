; csc 221-80
; project 09
; Program description: counts the letter frequencies in the text document
; Author: Achraf El Khatib
; Date: 12-06-2020 
;
;  letter_freq_starter.asm
;
;  Starter file for ASCII letter frequency analyzer start file   
;               asks user for a file name 
;               open files
;               reads file into buffer 
;               show the file 
;               ADD - counts the number of EXTENDED ASCII chars (all 256) 
;               ADD - displays count for each ASCII value  
; 

INCLUDE Irvine32.inc
INCLUDE macros.inc

MAX=26                                          ; 26 letters A-Z
BUFFER_SIZE = 8192                              ; Will not be able to read file greater 
.data
   buffer       BYTE    BUFFER_SIZE DUP(?),0    ; buffer for file contents 
   filename     BYTE    80 DUP(0)               ; buffer for filename 
   fileHandle   HANDLE  ?                       ; access to file (set in open_file proc) 
   bufSize      DWORD   BUFFER_SIZE             ; size buffer/#char read-set ReadTheFile
   freqs        DWORD   MAX DUP(0)              ; buffer holds count frequencies of 'A'-'Z' 
   

.code
    main PROC

        ; get filename
        mov edx,OFFSET filename
        mov ecx,SIZEOF filename
        call GetFileName            ; askes and fills in filename buffer

        ; open the file 
        call OpenTheFile			 ; uses filename sets fileHandle
        jc QUIT                 	 ; there was an error so quit program 

        ; read the file text into buffer
        mov edx,OFFSET buffer 
        mov ecx,BUFFER_SIZE 
        call ReadTheFile            ; uses fileHandle; fill buffer
        mov bufSize, eax            ; save number of chars in buffer - set by ReadTheFile

        call ShowTheFile            ; displays buffer (WriteString) 
        mov eax, 3000               ; pause for 3 seconds 
        call Delay    

        ; convert to upper case
        mov edx,OFFSET buffer		
        mov ecx,BUFFER_SIZE 
    	mov esi, OFFSET freqs
		call ToUpper				; calls ToUpper to upper case the letters in the array
   
        ; show count 
		call printer				; calls printer to print the frequencies saved in the esi array

        ; close file
        mov eax,fileHandle 
        call CloseFile          
      QUIT:
        exit
    main ENDP




   
   ; Discription: Let user input a filename.
   ; Receives: edx - address of buffer for filename
   ;           ecx - size of filename buffer -1  
   ; Returns : eax - number of characters in filename 
   ;           modifies the filename buffer
   ; Requires: one extra space in filenme buffer for null 
   GetFileName PROC  USES EDX ECX
      mWrite "Enter an input filename: " 
      call ReadString
      ret
   GetFileName ENDP


    ; Discription: Open the file for input. 
    ; Receives: edx - address of buffer with the filename
    ; Returns : set carry flag is failes to open file 
    ; Requires: fileHandle (fileHandle  HANDLE ?) to be declaired (.data) 
    OpenTheFile PROC USES EDX
        call OpenInputFile              ; irvine proc calls win32 IPA
        mov fileHandle,eax
		
        ; Check for errors.
        cmp   eax,INVALID_HANDLE_VALUE  ; error opening file?
        jne FILE_OK			; no: skip
        mWrite <"Cannot open file: ">   ; error message  
        mov edx, OFFSET filename        ; 
        call WriteString                ; print filename
        stc                             ; error so set carry flag     
        jmp DONE                        ; jump over clearing the CF
      FILE_OK:		                ; file is ok we are done
      	clc                             ; clear the carry flag
      DONE:
        ret                                   
    OpenTheFile ENDP


    ; Discription: Read the file into a buffer. 
    ; Receives: EDX - address of buffer with the filename
    ; Returns : EAX - number of cahrsread in 
    ;           CF    set carry flag is failes to  read file 
    ; Requires: the files ahs been opened (OpenTheFile) 
    ReadTheFile PROC  USES EDX ESI
        mov esi, edx                    ; save address of buffer
	call ReadFromFile               ; irvine proc call win32 API
	jnc CHECK_BUFFER_SIZE           ; if CF NOT we failed to read file 
	mWriteln "Error reading file "  ; error message
        stc                             ; error - set cary flag to signal error 
        ret                             ; could not read the file so exit

	CHECK_BUFFER_SIZE:              ; was buffer big enough?
	cmp eax,BUFFER_SIZE             ; 
	jb BUF_SIZE_OK                  ; yep !!
	mWriteln "Error reading file"   ; error message
	mWriteln " Buffer too small to read "
        stc                             ; error - set cary flag to signal error 
        ret                             ; could not read the file so exit
	
        BUF_SIZE_OK:
        add esi, eax                    ; mov the end of buffer 
	mov [esi], BYTE PTR 0           ; insert null terminator
	mWrite "File size: " 	        ; display file size
	call WriteDec
	call Crlf
        clc                             ; no errro so clear CF			
	ret
    ReadTheFile ENDP
	

    ; Discription: Dispalys the contents of a buffer. 
    ; Receives: edx - address of buffer
    ; Returns :  
    ; Requires:  
   ShowTheFile PROC
      ; Display the buffer.
      mWrite <"Buffer:",0dh,0ah,0dh,0ah>
      call WriteString
      call Crlf
      call Crlf
      ret
    ShowTheFile ENDP	




    ; Description:
    ;      prints the frequencies in the array for each letter
    ; Receives:  EAX 
	;			 ESI
    ; Returns :  
    ; Requires:
    printer PROC USES EAX ESI
        mov al, 'A'
		TOP:
			cmp al, 'A'					; if char is less then 'A' 
			jb DONE						; skip
			cmp al, 'Z'					; if char is more then 'Z'
			ja DONE						; skip
				
			call WriteChar				; write characters
			mwrite <": ">				
			inc al						; move to next index
			push eax					; save index
			mov eax, [esi]				; get count
			call writeDec				; print it
			call crlf					; new line
			add esi, TYPE DWORD			; move to next 
			pop eax						; restore index
			jmp SKIP					
			DONE:						
				ret						
			SKIP:		
		loop TOP		
		ret
		
    printer ENDP

	;Description:
	;			  counts the amount of usage each letter has and saves them in ESI
	;Receives: EAX
	;Returns: ESI
	
	
	countLetter PROC USES EDX ESI EBX

		cmp al, 'A'					;if given character is less then 'A'
		jb done						;skip
		cmp al, 'Z'					;if given character is more then 'Z'
		ja done						;skip
		
		sub al, 'A'					;convert to a number between 0-25 so it acts as an index
		mov bl, TYPE DWORD			;scale index for size of array elements
		mul bl						;multiplies al by bl and saves it to al
		add esi, eax				;address of the letter in the array
		add DWORD PTR [esi], 1		;add 1 to the letter count
		
		done:
			ret
			
	countLetter ENDP
	
    ; Description:
    ;       prints letter freq as historgram  
    ; Receives:  ESI address of array to print
    ; Returns :  
    ; Requires:
	



    ;  Description: converts lowercase letters to upper case letters
    ;  Recieves:    EDX  - address of buffer
    ;               ECX  - num of char user gave 
    ;  Returns:     buffer has been changed 
    ;  Requires: 
	ToUpper PROC USES EDX

		TOP:
			mov al, [edx]					;moves element into al
			
			cmp al, BYTE PTR 32d			;compares element in al to unprintable characters
			jbe SKIP						;jumps to skip if character is unprintable
			
			cmp al, 'a'						;compares element to the first lower case alphabetical character 
			jb SKIP							;jumps to skip if character is lower then lower case a
			
			cmp al, 'z'						;compares element to the last lower case alphabetical character
			ja SKIP							;jumps to skip if character is higher then lower case z
			
			and al, 11011111b				;adds the binary value 11011111 to the elements binary number to change the character from lower case to upper case
            mov [edx], al					;moves the element after upper case to the string
			
			call countLetter				; calls countLetter to save the frequencies in the ESI array
			
			SKIP:
				inc edx
        loop TOP
		ret
	ToUpper ENDP


END main
