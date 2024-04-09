;main comment block here 


.386                    ;identifies minimum CPU for this program

.MODEL flat,stdcall     ;flat - protected mode program
                        ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096              ;allocate 4096 bytes (1000h) for stack

mPrtChar  MACRO  arg1    ;arg1 is replaced by the name of character to be displayed
         push eax        ;save eax
         mov al, arg1    ;character to display should be in al
         call WriteChar  ;display character in al
         pop eax         ;restore eax
ENDM


mPrtStr macro   arg1          ;arg1 is replaced by the name of character to be displayed
         push edx             ;save eax
         mov edx, offset arg1 ;character to display should be in al
         call WriteString     ;display character in al
         pop edx              ;restore eax
ENDM

;*************************PROTOTYPES*****************************

ExitProcess PROTO,
    dwExitCode:DWORD    ;from Win32 api not Irvine to exit to dos with exit code

ReadChar PROTO          ;Irvine code for getting a single char from keyboard
				        ;Character is stored in the al register.
			            ;Can be used to pause program execution until key is hit.

WriteChar PROTO         ;Irvine code to write character stored in al to console

WriteString PROTO		;write null-terminated string to console
                        ;EDX points to string

WriteDec PROTO          ;Irvine code to write number stored in eax
                        ;to console in decimal


;************************  Constants  ***************************

LF       equ     0Ah                   ; ASCII Line Feed

;************************DATA SEGMENT***************************

.data

    ;inputs for testing the Shifter function
    inputA  byte 0,1,0,1,0,1,0,1
    inputB  byte 0,0,1,1,0,0,1,1
    inputC  byte 1,1,1,1,0,0,0,0
    ARRAY_SIZE equ SIZEOF inputC         

    ;numbers for testing DoLeftShift
    nums   dword 10101010101010101010101010101010b,
                 01010101010101010101010101010101b,
                 11010101011101011101010101010111b
    NUM_SIZE EQU SIZEOF nums          ;total bytes in the nums array

    NUM_OF_BITS EQU SIZEOF(DWORD) * 8 ;Total bits for a dword

    ;You can add LFs to the strings below for proper output line spacing
    ;but do not change anything between the quotes "do not change".
    ;You can also combine messages where appropriate.

    ;I will be using a comparison program to compare your output to mine and
    ;the spacing must match exactly.

    endingMsg           byte LF,"Hit any key to exit!",LF,0

    ;Change my name to your name
    titleMsg            byte "Program 6 by Aurelia Kisanaga",LF,LF,0

    testingShifterMsg   byte "Testing Shifter",LF,0
    testingDspBinMsg    byte "Testing DspBin",LF,0

    enabledMsg          byte "(Shifting enabled C = 1, Disabled C = 0)",LF,0

    header       byte  "A B C | Output",LF,0

    dashes byte "------------------------------------",LF,0

    space byte " ",0

;************************CODE SEGMENT****************************

.code

Main PROC

;start student code here

    mov         edx, 0                  ;sets edx to 0
    mPrtStr     titleMsg                ;prints out title message
    mPrtStr     testingShifterMsg       ;prints shifter message
    mPrtStr     enabledMsg              ;prints enabled message
    mPrtStr     dashes                  ;prints dashes
    mPrtStr     header                  ;prints headers

;See Canvas for the pseudo code for the main function

loop1:
    cmp         edx, ARRAY_SIZE         ;compare if edx is equal to array size
    je          done1                   ;if true then jump to done1

    mov         cl, inputC[edx]         ;moves inputC at edx index into cl
    mov         bl, inputB[edx]         ;moves inputB at edx index into bl
    mov         al, inputA[edx]         ;moves inputA at edx index into al

    movzx       eax, al                 ;copies al to eax
    call        WriteDec                ;prints eax

    push        eax                     ;push eax on stack

    mPrtStr     space                   ;prints a space
    movzx       eax, bl                 ;copies bl to eax 
    call        WriteDec                ;prints eax
    mPrtStr     space                   ;prints a space
    movzx       eax, cl                 ;copies cl to eax
    call        WriteDec                ;prints eax

    pop         eax                     ;pop eax from stack

    call        Shifter                 ;call Shifter function
    mPrtStr     space                   ;prints a space
    mPrtChar    '|'                     ;prints a |
    mPrtStr     space                   ;prints a space
    call        WriteDec                ;prints eax
    mPrtChar    LF                      ;prints a newline

    inc         edx                     ;increments edx
    jmp         loop1                   ;jumps to top
        
done1:
    mPrtChar    LF                      ;prints a newline
    mPrtStr     testingDspBinMsg        ;prints testing dspbin message
    mPrtStr     dashes                  ;prints dashes
    mov         edx, 0                  ;clears edx
    jmp         loop2                   ;jumps to second loop

loop2:
    cmp         edx, NUM_SIZE           ;checks to see if edx = size of nums
    je          done2                   ;if true then jump to done2
    mov         eax, nums[edx]          ;copies dword from nums array at that index
    call        DspBin                  ;prints out binary
    add         edx, 4                  ;increments edx by 4 
    mPrtChar    LF                      ;prints new line
    jmp         loop2                   ;jumps back to top
   
done2:
    mPrtStr     endingMsg               ;prints end message


    call        ReadChar                ;pause execution
	INVOKE      ExitProcess,0           ;exit to dos: like C++ exit(0)

Main ENDP



;************** Shifter – Simulate a partial shifter circuit per the circuit diagram in the pdf file.  
;  Shifter will simulate part of a shifter circuit that will input 
;  3 bits and output a shifted or non-shifted bit.
;
;
;   CL--------------------------
;              |               |
;              |               |
;             NOT    BL        |     AL
;              |     |         |     |
;              --AND--         --AND--
;                 |                |
;                 --------OR--------
;                          |
;                          AL
;
; NOTE: To implement the NOT gate use XOR to flip a single bit.
;
; Each input and output represents one bit.
;
;  Note: do not access the arrays in main directly in the Adder function. 
;        The data must be passed into this function via the required registers below.
;
;       ENTRY - AL = input bit A 
;               BL = input bit B
;               CL = enable (1) or disable (0) shift
;       EXIT  - AL = shifted or non-shifted bit
;       REGS  -  (list registers you use)
;
;       For the inputs in the input columns you should get the 
;       output in the output column below.
;
;The chart below shows the output for 
;the given inputs if shifting is enabled (cl = 1)
;If shift is enabled (cl = 1) then output should be the shifted bit (al).
;In the table below shifting is enabled (cl = 1)
;
;        input      output
;     al   bl  cl |   al 
;--------------------------
;      0   0   1  |   0 
;      1   0   1  |   1 
;      0   1   1  |   0 
;      1   1   1  |   1   
;
;The chart below shows the output for 
;the given inputs if shifting is disabled (cl = 0)
;If shift is disabled (cl = 0) then the output should be the non-shifted bit (bl).

;        input      output
;     al   bl  cl |   al 
;--------------------------
;      0   0   0  |   0 
;      1   0   0  |   0 
;      0   1   0  |   1 
;      1   1   0  |   1   

;
;Note: the Shifter function does not do any output to the console.All the output is done in the main function
;
;Do not access the arrays in main directly in the shifter function. 
;The data must be passed into this function via the required registers.
;
;Do not change the name of the Shifter function.
;
;See additional specifications for the Shifter function on Canvas 
;
;You should use AND, OR and XOR to simulate the shifter circuit.
;
;Note: to flip a single bit use XOR do not use NOT.
;
;You should save any registers whose values change in this function 
;using push and restore them with pop.
;
;The saving of the registers should
;be done at the top of the function and the restoring should be done at
;the bottom of the function.
;
;Note: do not save any registers that return a value (eax).FA21
;
;Each line of this function must be commented and you must use the 
;usual indentation and formating like in the main function.
;
;Don't forget the "ret" instruction at the end of the function
;
;Do not delete this comment block. Every function should have 
;a comment block before it describing the function. 


Shifter proc

    ;start student code here
    
    ;Save registers that change that do not return a value (push)
    push    ecx             ;pushes ecx onto stack
    push    ebx             ;pushes ebx onto stack

    and     al, cl          ;ands al and cl
    xor     cl, 00000001    ;flips cl bit
    and     bl, cl          ;ands bl and cl
    or      al, bl          ;ors bl and cl

    ;Restore registers that were saved (pop)
    pop     ebx             ;pop ebx from stack
    pop     ecx             ;pop ecx from stack
    
    ret                     ;return to main function



Shifter endp




;************** DspBin - display a Dword in binary including leading zeros
;
;       ENTRY – EAX contains operand1, the number to print in binary
;
;       For Example if parm1 contained contained AC123h the following would print:
;                00000000000010101100000100100011
;       For Example if parm1 contained 0005h the following would print:
;                00000000000000000000000000000101
;
;       EXIT  - None
;       REGS  - List registers you use
;
; to call DspBin:
;               mov eax, 1111000110100b    ;number to print in binary is in eax
;               call DspBin                ; 00000000000000000001111000110100 should print
;     
;       Note: leading zeros do print
;--------------

    ;You should have a loop that will do the following:

    ;The loop should execute NUM_OF_BITS times(32 times) times so that all binary digits will print including leading 0s.

    ;You should use the NUM_OF_BITS constant as the terminating loop condition and not hard code it.
    
    ;You should start at bit 31 down to and including bit 0 so that the digits will 
    ;   print in the correct order, left to right.
    ;Each iteration of the loop will print one binary digit.

    ;Before the loop you should copy eax to a different register. This is the register
    ;you will shift in the loop to copy the leftmost bit to the carry flag

    ;Each time through the loop you should do the following:
    
    ;clear al to 0
    ;shift the bit starting at position 31 to the carry flag. 
    ;(The shifting is done on the register you copied eax to before the loop)
    ;  
    ;   then use a rotate command to copy the carry flag to the right end of al.

    ;Then Use the OR instruction to convert the 1 or 0 to a character ('1' or '0').
    
    ;then print it with WriteChar.

    ;You should keep processing the number until all 32 bits have been printed from bit 31 to bit 0. 
    
    ;Efficiency counts.

    ;DspBin just prints the raw binary number.

    ;No credit will be given for a solution that uses mul, imul, div or idiv. 
    ;
    ;You should save any registers whose values change in this function 
    ;using push and restore them with pop.
    ;
    ;The saving of the registers should
    ;be done at the top of the function and the restoring should be done at
    ;the bottom of the function.
    ;
    ;Each line of this function must be commented and you must use the 
    ;usual indentation and formating like in the main function.
    ;
    ;
    ;Do not delete this comment block. Every function should have 
    ;a comment block before it describing the function. SP21


DspBin proc

    ;start student code here

    ;Save registers that change (push)
    push    eax                 ;push eax to stack
    push    ecx                 ;push ecx to stack

    mov     esi, NUM_OF_BITS    ;esi = the number of bits in dword
    mov     ecx, eax            ;copy eax to ecx

loopTop:
    cmp     esi, 0              ;compare if loop number is zero
    je      done                ;if loops is done then jump 

    mov     al,  0              ;clears al
    shl     ecx, 1              ;shifts ecx to the left by 1
    rcl     al,  1              ;rotates al once to the left
    or      al,  00110000b      ;converts binary to char
    
    call    WriteChar           ;prints char

    dec     esi                 ;deceremnts counter
    jmp     loopTop             ;jumps back to the top

done:
    
    ;restore registers that were saved (pop)
    pop     ecx                 ;pop ecx from stack
    pop     eax                 ;pop eax from stack

    ret                         ;return to main function


DspBin endp

END Main