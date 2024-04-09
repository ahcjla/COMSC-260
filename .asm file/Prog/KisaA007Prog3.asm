; *************************************************************
; Student Name: Aurelia Kisanaga
; COMSC-260 Fall 2021
; Date: 13 September 2021
; Assignment #3
; Version of Visual Studio used (2015)(2017)(2019): 2019
; Did program compile? Yes
; Did program produce correct results? Yes
; Is code formatted correctly including indentation, spacing and vertical alignment? Yes
; Is every line of code commented? Yes
;
; Estimate of time in hours to complete assignment: 2 hours
;
; In a few words describe the main challenge in writing this program:
; jumping and considering the inefficiency is difficult
;
; Short description of what program does:
; allow the user to guess a number generated randomly by the program (computer)
;
; *************************************************************
; Reminder: each assignment should be the result of your
; individual effort with no collaboration with other students.
;
; Reminder: every line of code must be commented and formatted
; per the ProgramExpectations.pdf file on the class web site
; *************************************************************


.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;*******************MACROS********************************

;mPrtStr
;usage: mPrtStr nameOfString
;ie to display a 0 terminated string named message say:
;mPrtStr message

;Macro definition of mPrtStr. Wherever mPrtStr appears in the code
;it will  be replaced with 

mPrtStr  MACRO  arg1    ;arg1 is replaced by the name of string to be displayed
		 push edx				;save edx
         mov  edx, offset arg1  ;address of str to display should be in edx
         call WriteString       ;display 0 terminated string
         pop  edx				;restore edx
ENDM

;Wherever "mPrtStr message" appears in the code it will  be replaced with 
;push edx
;mov edx, offset arg1   
;call WriteString       
;pop edx

;arg1 is replaced with message if that is the name of the string passed in.



;*************************PROTOTYPES*****************************

ExitProcess PROTO,
dwExitCode:DWORD    ;from Win32 api not Irvine to exit to dos with exit code

ReadChar PROTO      ;Irvine code for getting a single char from keyboard
                    ;Character is stored in the al register.
                    ;Can be used to pause program execution until key is hit.

ReadHex PROTO       ;Irvine code to read 32 bit hex number from console
                    ;and store it into eax

WriteString PROTO   ; Irvine code to write null-terminated string to output
                    ; EDX points to string

RandomRange PROTO   ; Returns an unsigned pseudo-random 32-bit integer
                    ; in EAX, between 0 and n-1. If n = Fh a random number
                    ; in the range 0-Eh is generated.  Input parameter: EAX = n.

Randomize PROTO     ; Re-seeds the random number generator with the current time
                    ; in seconds.
				        

;************************  Constants  ***************************

    LF       equ     0Ah                   ; ASCII Line Feed

;************************DATA SEGMENT***************************

.data

    progName        byte    "Program 3 byte Aurelia Kisanaga",LF,0
    guessRange      byte    LF,"Guess a hex number in the range 1h - Fh.",LF,0
    guess           byte    "Guess: ",0
    highGuess       byte    "High! (Guess lower)",LF,0
    lowGuess        byte    "Low! (Guess higher)",LF,0
    correct         byte    "Correct!!",LF,LF,0
    another?        byte    "Do another?('Y' or 'y' to continue. Any other character to exit)",LF,0

    
;************************CODE SEGMENT****************************

.code

main PROC
	
	mPrtStr progName        ;call mPrtStr macro to print zero terminated string
    call    Randomize       ;seed a random number

loop1:
    mPrtStr guessRange      ;call mPrtStr macro to print zero terminated string
    mov     eax, 0Fh        ;set highest number in range in eax (this means range is 0-Eh)
    call    RandomRange     ;generate a random number
    add     eax, 1          ;add 1 to eax so that number is in range (1-Fh)
    mov     edx, eax        ;move random number to edx to be stored and compared later

loop2:
    mPrtStr guess           ;call mPrtStr macro to print zero terminated string
    call    ReadHex         ;asks for user input to be stored in eax
    cmp     eax, edx        ;compare user input (eax) and random number (edx)
    je      correctGuess    ;if both are equal, jump to correctGuess
    ja      tooHigh         ;if user input is higher than random number, jump to tooHigh
    mPrtStr lowGuess        ;else if user input is lower than random number, call mPrtStr macro to print zero terminated string...
    jmp     loop2           ;...and jump back to loop2

tooHigh:
    mPrtStr highGuess       ;call mPrtStr macro to print zero terminated string
    jmp     loop2           ;jump back to loop2

correctGuess:
    mPrtStr correct         ;call mPrtStr macro to print zero terminated string
    mPrtStr another?        ;call mPrtStr macro to print zero terminated string
    call    ReadChar        ;asks for user input in char data type
    cmp     al, 'y'         ;compare if user input is similar to 'y'
    je      loop1           ;if yes, jump to loop1
    cmp     al, 'Y'         ;else, compare user input to 'Y'
    je      loop1           ;if matches, jump to loop1

	INVOKE	ExitProcess,0	;else exit to dos: like C++ exit(0)

main ENDP
END main