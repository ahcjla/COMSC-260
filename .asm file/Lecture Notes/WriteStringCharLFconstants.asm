;WriteStringCharLFconstants.asm

;Example of using the Irvine library functions WriteString and WriteChar
;Also example of declaring and using the LF constant
;and declaring and writing zero terminated strings to the console

.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack


;*************************PROTOTYPES*****************************

WriteString PROTO		; write null-terminated string to output
                        ;EDX points to string

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

ReadChar PROTO  ;Irvine code for getting a single char from keyboard
				;Character is stored in the al register.
			    ;Can be used to pause program execution until key is hit.

WriteChar PROTO ;Irvine code for printing a single char to the console.
				;Character to be printed must be in the al register.
	    

;************************  Constants  ***************************

    LF       equ     0Ah                   ; ASCII Line Feed

;************************DATA SEGMENT***************************

.data

    ;create strings with embedded line feeds

    openingMsg          byte  "Hello!",LF,LF,0  
    rainMsg             byte  "It looks like",LF,       
                              "it is going to rain today!",LF,LF,0
    tomorrowMsg         byte  "Tomorrow " 
                        byte  "it will be clear!",0 
    endingMsg           byte  LF,LF,"Hit any key to exit!",0

;************************CODE SEGMENT****************************

.code

main PROC

	;Example of using the Irvine WriteChar function to print 1 character.
	;Character must be in the al register
	
	mov		al,'H'				        ;al = 'H'
	call	WriteChar			        ;print 'H' to console
	mov		al,LF				        ;al = 0Ah (line feed)
	call	WriteChar			        ;print line feed (cursor goes to next line)
	
	;examples of printing a zero terminated string to the console.
	;Address of the string must be in the edx register

    mov		edx, offset openingMsg      ;edx = address of zero termined string
    call	WriteString                 ;print string to console

    mov		edx,  offset rainMsg        ;edx = address of zero termined string
    call	WriteString                 ;print string to console

	mov		al,LF				        ;al = 0Ah (line feed)
	call	WriteChar			        ;print line feed (cursor goes to next line)

    mov		edx, offset tomorrowMsg     ;edx = address of zero termined string
    call	WriteString                 ;print string to console

    mov		edx, offset endingMsg       ;edx = address of zero termined string
    call	WriteString                 ;print string to console

	call	ReadChar		            ;pause execution
	INVOKE	ExitProcess,0	            ;exit to dos: like C++ exit(0)

main ENDP
END main