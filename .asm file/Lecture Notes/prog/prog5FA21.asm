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

;mPrtChar 
;usage: mPrtChar character
;ie to display a character like 'X'say:
;mPrtChar 'X'
mPrtChar MACRO  arg1    ;arg1 is replaced by the name of string to be displayed
         push eax       ;save eax on stack
         mov al, arg1   ;address of str to display should be in dx
         call WriteChar ;display 0 terminated string
         pop eax        ;restore eax to its original value
ENDM


;*************************PROTOTYPES*****************************

ExitProcess PROTO,
    dwExitCode:DWORD    ;from Win32 api not Irvine to exit to dos with exit code


WriteInt PROTO          ;Irvine code to write number stored in eax
                        ;to console in signed decimal.
                        ;Each postive number is printed with a leading '+'
                        ;Each negative number is printed with a leading '-'

ReadChar PROTO          ;Irvine code for getting a single char from keyboard
				        ;Character is stored in the al register.
			            ;Can be used to pause program execution until key is hit.

WriteChar PROTO         ;write the character in al to the console

WriteString PROTO		;Irvine code to write null-terminated string to output
                        ;EDX points to string

                     
;************************  Constants  ***************************

    LF     EQU     0Ah  ; ASCII Line Feed

;************************DATA SEGMENT***************************

.data
 
    ;You can add LFs to the strings below for proper output line spacing
    ;but do not change anything between the quotes ("do not change").

    ;I will be using a comparison program to compare your output to mine and
    ;the spacing must match exactly.

    endingMsg           byte "Hit any key to exit!",0

    ;Change my name to your name
    titleMsg            byte "Program 4 by Fred Kennedy",LF,0

    ;do not change any of the data below

    operand1 dword   -2147483600,-2147482612,-5,1062741823,2147483547, 0, -94567 ,4352687,-249346713,-678, -2147483643,32123, -2147483646
    operators byte    '-', '+','*', '*', '%', '/',  '/', '+','/', '%','-','*','/'
    operand2 dword    -200,12, 2, 2, -5630, 543,   385, 19786,43981, 115,5,31185,365587

    ARRAY_SIZE equ sizeof  operand2
   


;************************CODE SEGMENT****************************

.code

main PROC

    ;write code for main function here. 
    ;compile your program often to avoid a cascading set of errors that are hard to debug.

	call    ReadChar		;pause execution
	INVOKE	ExitProcess,0   ;exit to dos: like C++ exit(0)

main ENDP

;************** doSub - dword subtraction
;
;       ENTRY - operand 1 and operand 2 are pushed on the stack
;
;       EXIT  -EAX = result   (operand 1 - operand 2)
;       REGS  - List registers changed in this function
;
;       note: Before calling doSub push operand 2 onto the stack and then push operand 1.
;
;       to call doSub in main function:
;                         push  2                ;32 bit operand2
;                         push  8                ;32 bit operand1
;                         call doSub             ;8 – 2 = 6 (answer in eax)
;
;--------------
;The same circuits can be used for addition and subtraction because
;negative numbers are stored in twos complement form.
;
;You can do a subtraction by doing a twos complement and then doing addition.
;
;To prove that this is true do not use the sub instruction in doSub
;but use the following method to do the subtraction:

;do a twos complement (neg instruction) on operand 2 then
;add operand 1 + operand 2 and store the answer in  EAX.

doSub proc

    ;start your code here

doSub endp

;************** doAdd - dword addition
;
;       ENTRY – operand 1 and operand 2 are on the stack
;                         
;       EXIT  - EAX = result  (operand 1 + operand 2) (any carry is ignored so the answer must fit in 32 bits)
;       REGS  - List registers changed in this function
;
;       note: Before calling doAdd push operand 2 onto the stack and then push operand 1.
;
;
;       to call doAdd in main function:
;                          push 2                ;32 bit operand2
;                          push  3               ;32 bit operand1
;                          call doAdd            ;3 + 2 = 5 (answer in eax)
;
;
;--------------
;Add operand1 to operand2 and store the answer in EAX

;Note: any carry is ignored so the answer must fit in 32 bits
;Note you must keep the operands in the correct order: op1+op2 not op2+op1.

doAdd proc

    ;start your code here

doAdd endp



;************** doMult - signed dword multiplication
;
;       ENTRY - operand 1 and operand 2 are on the stack
;                         
;       EXIT  - EDX:EAX = result (operand 1 * operand 2) 
;       (for this assignment the product is assumed to fit in EAX and EDX is ignored)
;
;       REGS  - List registers changed in this function
;
;       note: Before calling doMult push operand 2 onto the stack and then push operand 1.
;
;       to call doMult in main function:
;                      push  3                  ;32 bit operand2
;                      push  5                  ;32 bit operand1
;                      call doMult              ; 5 * 3 = 15 (answer in eax)
;
;--------------
;Take operand1 times operand2 using signed multiplication and the result is returned in EDX:EAX.
;Note: this function does signed multiplication not unsigned. See imul.asm on canvas.

;Only use the single operand version of imul.

;Please note that this program assumes the product fits in EAX. 
;If part of the produce is in EDX, it is ignored.
;Note you must keep the operands in the correct order: op1*op2 not op2*op1.

doMult proc

    ;start your code here

doMult endp


;************** doDiv - signed dword / dword division
;
;       ENTRY - operand 1(dividend) and operand 2(divisor) are on the stack
;
;       EXIT  - EAX = quotient
;                     EDX = remainder
;       REGS  - List registers changed in this function
;
;       note: Before calling doDiv push operand 2(divisor) onto the stack and then push operand 1(dividend).
;
;        to call doDiv in main function:
;               push 4                ;32 bit operand2 (Divisor)
;               push  19              ;32 bit operand1 (Dividend)
;               call doDiv            ;19/ 4 = 4 R3(4 = quotient in eax, 3 =  remainder in edx )
;
;--------------

;Take operand1 /operand 2 and the quotient is returned in EAX and the
; remainder is returned in EDX. 

;doDiv does signed division. See idiv.asm on the class web site.

;Note: since we are doing signed division you should sign extend parameter 1 into 
;edx using CDQ instead of zeroing out edx. SP21

;Note: after calling doDiv for the modulus operation (%) look at the value 
;that is returned in edx which is the remainder. 

;Note: doDiv does not process the modulus operator. 

doDiv proc

    ;start your code here

doDiv endp






END main