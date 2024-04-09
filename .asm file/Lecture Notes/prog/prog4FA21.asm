;Insert main comment block here


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

mPrtStr  MACRO  arg1            ;arg1 is replaced by the name of string to be displayed
         push edx               ;save edx on the stack
         mov edx, offset arg1   ;address of str to display should be in dx
         call WriteString       ;display 0 terminated string
         pop edx                ;restore edx from stack
ENDM



;*************************PROTOTYPES*****************************

ExitProcess PROTO,
    dwExitCode:DWORD    ;from Win32 api not Irvine to exit to dos with exit code


WriteDec PROTO          ;Irvine code to write number stored in eax
                        ;to console in decimal

ReadChar PROTO          ;Irvine code for getting a single char from keyboard
				        ;Character is stored in the al register.
			            ;Can be used to pause program execution until key is hit.

WriteChar PROTO         ;write the character in al to the console

WriteString PROTO		;Irvine code to write null-terminated string to output
                        ;EDX points to string

                     
;************************  Constants  ***************************

    LF         equ     0Ah                   ; ASCII Line Feed
    
;************************DATA SEGMENT***************************

.data
    inputA  byte 0,0,0,0,1,1,1,1
    inputB  byte 0,0,1,1,0,0,1,1
    carryIn byte 0,1,0,1,0,1,0,1
    ARRAY_SIZE equ sizeof carryIn         

    ;The total bytes of the carryIn array is stored in the ARRAY_SIZE constant.

    ;You can add LFs to the strings below for proper output line spacing
    ;but do not change anything between the quotes ("do not change").

    ;I will be using a comparison program to compare your output to mine and
    ;the spacing must match exactly.

    ;Do not change the name of the variables below.

    endingMsg           byte "Hit any key to exit!",0

    ;Change my name to your name
    titleMsg            byte "Program 4 by Fred Kennedy",LF,0

    testingAdderMsg     byte " Testing Adder",0

    inputAMsg              byte "   Input A: ",0
    inputBMsg              byte "   Input B: ",0
    carryinMsg             byte "  Carry in: ",0
    sumMsg                 byte "       Sum: ",0
    carryoutMsg            byte " Carry Out: ",0

    dashes              byte " ------------",0


;************************CODE SEGMENT****************************

.code

main PROC

    ;write code for main function here. 

	call    ReadChar		;pause execution
	INVOKE	ExitProcess,0   ;exit to dos: like C++ exit(0)

main ENDP


;************** Adder – Simulate a full Adder circuit  
;  Adder will simulate a full Adder circuit that will add together 
;  3 input bits and output a sum bit and a carry bit
;
;    Each input and output represents one bit.
;
;  Note: do not access the arrays in main directly in the Adder function. 
;        The data must be passed into this function via the required registers below.
;
;       ENTRY - EAX = input bit A 
;               EBX = input bit B
;               ECX = Cin (carry in bit)
;       EXIT  - EAX = sum bit
;               ECX = carry out bit
;       REGS  -  (list registers you use)
;
;       For the inputs in the input columns you should get the 
;       outputs in the output columns below:
;
;        input                  output
;     eax  ebx   ecx   =      eax     ecx
;      A  + B +  Cin   =      Sum     Cout
;      0  + 0 +   0    =       0        0
;      0  + 0 +   1    =       1        0
;      0  + 1 +   0    =       1        0
;      0  + 1 +   1    =       0        1
;      1  + 0 +   0    =       1        0
;      1  + 0 +   1    =       0        1
;      1  + 1 +   0    =       0        1
;      1  + 1 +   1    =       1        1
;
;   Note: the Adder function does not do any output. 
;         All the output is done in the main function.
;
;Do not change the name of the Adder function.
;
;See additional specifications for the Adder function on the 
;class web site.
;
;You should use the AND, OR and XOR instructions to simulate the full adder circuit.
;
;You should save any registers whose values change in this function 
;using push and restore them with pop.
;
;The saving of the registers should
;be done at the top of the function and the restoring should be done at
;the bottom of the function.
;
;Note: do not save any registers that return a value (ecx and eax).
;
;Each line of the Adder function must be commented and you must use the 
;usual indentation and formating like in the main function.
;
;Do not delete this comment block. FA21 Every function should have 
;a comment block before it describing the function. 

;Don't forget the "ret" instruction at the end of the function


Adder proc
;Write code here to save registers that change that do not return a value. 
;ecx and eax return a value so do not save them.

;Since only registers on the left of the ',' change, sometimes it is possible
;to rearrange your operands so that a register does not change
;and will not have to be saved.

;Write code here to simulate the full adder circuit. 

;Note: it is not efficient to use push and pop to save and restore intermediate values

;Write code here to restore registers that were saved at the top of the Adder function.

Adder endp

END main