; *************************************************************
; Student Name: Aurelia Kisanaga
; COMSC-260 Fall 2021
; Date: 20 October 2021
; Assignment #4
; Version of Visual Studio used (2015)(2017)(2019): 2019
; Did program compile? Yes
; Did program produce correct results? Yes
; Is code formatted correctly including indentation, spacing and vertical alignment? Yes
; Is every line of code commented? Yes
;
; Estimate of time in hours to complete assignment: 4 hours
;
; In a few words describe the main challenge in writing this program:
; xor, or, and operators led me to confusion
;
; Short description of what program does:
; 3 input arrays are initalized and the sum and carry out values are printed
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

    endingMsg           byte LF,LF,"Hit any key to exit!",0

    ;Change my name to your name
    titleMsg            byte "Program 4 by Aurelia Kisanaga",LF,0

    testingAdderMsg     byte LF," Testing Adder",0

    inputAMsg           byte LF,LF,"   Input A: ",0
    inputBMsg           byte LF,   "   Input B: ",0
    carryinMsg          byte LF,   "  Carry in: ",0
    sumMsg              byte LF,   "       Sum: ",0
    carryoutMsg         byte LF,   " Carry Out: ",0

    dashes              byte LF," ------------",0


;************************CODE SEGMENT****************************

.code

main PROC

    mPrtStr titleMsg            ; print title message
    mPrtStr dashes              ; print dashes
    mPrtStr testingAdderMsg     ; print testing adder message
    mPrtStr dashes              ; print dashes

    mov     esi, 0              ; initialize esi for incrementation 

loopTop:                        ; start of while loop

    cmp     esi, ARRAY_SIZE     ; compare esi and array size 
    jae     done                ; if esi is more than or equal to array size, jump to done

    mPrtStr inputAMsg           ; print input A: message
    movzx   eax, inputA[esi]    ; copy first value in inputA array (0) to eax and zero out upper values
    call    WriteDec            ; output eax value

    mPrtStr inputBMsg           ; print input B: message
    movzx   ebx, inputB[esi]    ; copy first value in inputB array (0) to ebx and zero out upper values
    mov     eax, ebx            ; copy ebx to eax
    call    WriteDec            ; output eax value (but actually ebx value)

    mPrtStr carryinMsg          ; print carry in: message
    movzx   ecx, carryIn[esi]   ; copy first value in carryIn array (0) to ecx and zero out upper values
    mov     eax, ecx            ; copy ecx to eax
    call    WriteDec            ; output eax value (but actually ecx value)

    movzx   eax, inputA[esi]    ; reinitialize eax to copy first value from inputA array (0)

    call    Adder               ; call Adder function

    mPrtStr dashes              ; print dashes
    mPrtStr sumMsg              ; print sum: message
    call    WriteDec            ; print sum which is stored in eax

    mPrtStr carryoutMsg         ; print carry out: message
    mov     eax,ecx             ; copy ecx value (carry out value) to eax 
    call    WriteDec            ; print carry out value stored in eax

    inc     esi                 ; esi contains the offset in the beginning of the array
                                ; add 1 to esi (increment esi) so that Array[esi] points
                                ; to the next element in the array

    jmp     loopTop             ; repeat while loop
    
done:                           ; if esi is more than or equals to array size, jump here

    mPrtStr endingMsg           ; print ending message
    
	call    ReadChar		    ; pause execution
	INVOKE	ExitProcess,0       ; exit to dos: like C++ exit(0)

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
    
    push    edi         ; save register edi
    push    edx         ; save register edx

    mov     edi, eax    ; copy eax to edi
    xor     eax, ebx    ; xor eax and ebx
    mov     edx, eax    ; copy eax (xor eax and ebx) to edx
    xor     eax, ecx    ; xor eax and ecx which stores the sum value (sum = eax)

    and     ecx, edx    ; 1st AND operator: AND edx with ecx ((xor eax and ebx) AND ecx)
    and     edi, ebx    ; 2nd AND operator: AND edi with ebx (eax AND ebx)
    or      ecx, edi    ; or edx with edi (((xor eax and ebx) AND ecx) OR (eax AND ebx))

    pop     edi         ; restore edi
    pop     edx         ; restore edx

    ret                 ; return to the main function

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