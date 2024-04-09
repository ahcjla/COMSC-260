;Examples of addressing memory - 
;

.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

mPrtStr macro   arg1          ;arg1 is replaced by the name of character to be displayed
         push edx             ;save eax
         mov edx, offset arg1 ;character to display should be in al
         call WriteString     ;display character in al
         pop edx              ;restore eax
ENDM

;mPrtChar will print a single char to the console
mPrtChar MACRO  arg1            ;arg1 is replaced by char to be displayed
         push eax               ;save eax
         mov  al, arg1          ;al = char to display
         call WriteChar         ;display char to console
         pop  eax               ;restore eax
ENDM

;mPrtDec will print a dec number to the console
mPrtDec  MACRO  arg1            ;arg1 is replaced by the name of string to be displayed
         push eax               ;save eax
         mov  eax, arg1         ;eax = dec num to print
         call WriteDec          ;display dec num to console
         pop  eax               ;restore eax
ENDM

;*************************PROTOTYPES*****************************

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

ReadChar PROTO  ;Irvine code for getting a single char from keyboard
				;Character is stored in the al register.
			    ;Can be used to pause program execution until key is hit.

				WriteChar PROTO
				WriteString PROTO

WriteChar PROTO         ;Irvine code to write character stored in al to console

WriteDec PROTO          ;Irvine code to write number stored in eax
                        ;to console in decimal

LF       equ     0Ah                   ; ASCII Line Feed

;************************DATA SEGMENT***************************

.data

num1 real4 2.5
num2 real4 7.25

;************************CODE SEGMENT****************************

.code

main PROC
fld num1
fld num2

    call	ReadChar		                ;pause execution
	INVOKE	ExitProcess,0	                ;exit to dos

main ENDP
END main