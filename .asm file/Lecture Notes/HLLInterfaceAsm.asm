;Example of an assembly language procedure to be called from C++.

;Since C++ is 32 bit the syntax below allows the assembly to 
;compiled as 32 bit providing you use a 32 bit assembler like
;the one that comes with Visual C++ 2008 Express Edition

.386      ;identifies minimum CPU for this program

.MODEL flat, stdcall    ;flat - protected mode program

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack


WriteChar PROTO         ;write the character in al to the console


;************************DATA SEGMENT***************************

.data


;************************CODE SEGMENT****************************
.code

;notice that this asm file does not contain a main function since
;it is just going to be a file of asm functions
;and the caller will be responsible for the main function

;************** multiply - signed dword multiplication
;
;       ENTRY - operand 1 and operand 2 are on the stack
;                         
;       EXIT  - EDX:EAX = result (operand 1 * operand 2) 
;       (for this assignment the product is assumed to fit 
;        in EAX and EDX is ignored)
;
;       REGS  - EAX,EBX,EDX,FLAGS
;
;       cpp prototype- extern "C" int __stdcall multiply(int,int);
;
;       note: - Before calling multiply push operand 2 onto the 
;                 stack and then push operand 1.
;
;
;
multiply PROC operand1:DWORD, operand2:DWORD

    ;no need for mov ebp,esp etc since that code is
    ;generated automatically because of the way the parameters
    ;are declared above.

    mov eax, operand1   ;eax = operand1
    imul operand2       ;edx:eax = eax * operand2

    ;no need for mov esp,ebp etc since that code is
    ;generated automatically

    ret

multiply ENDP

;************** DspDword - display DWORD in decimal
;
;
;       ENTRY - operand is on the stack. Operand is number to display. 
;       EXIT  - none
;       REGS  - EAX,EBX,EDX,ESI,EFLAGS
;
;       cpp prototyoe- extern "C" void __stdcall DspDword(int);
;
;       DspDword was originally written by Paul Lou and Gary Montante to display a
;       64 bit number and to use stack parameters.
;       It was modified to work with 32 bits and Irvine library by Fred Kennedy
;
;-------------- Input Parameters
        
    ;ret           ebp + 4
    ;ebp           ebp + 0
    ;byte array beginning = ebp - 1 

    ;1000h | 
    ; 0FCh | 1280           [ebp + 8]
    ; 0F8h | return address [ebp + 4]
    ; 0F4h | ebp            [ebp + 0]  <--EBP
    ; 0F3h |  ?             [ebp - 1]  buffer + 11
    ; 0F2h |  ?             [ebp - 2]  buffer + 10
    ; 0F1h | '0'            [ebp - 3]  buffer + 9
    ; 0F0h | '0'            [ebp - 4]  buffer + 8
    ; 0EFh | '0'            [ebp - 5]  buffer + 7
    ; 0EEh | '0'            [ebp - 6]  buffer + 6
    ; 0EDh | '0'            [ebp - 7]  buffer + 5
    ; 0ECh | '0'            [ebp - 8]  buffer + 4
    ; 0EBh | '1'            [ebp - 9]  buffer + 3
    ; 0EAh | '2'            [ebp - 10] buffer + 2
    ; 0E9h | '8'            [ebp - 11] buffer + 1
    ; 0E8h | '0'            [ebp - 12] buffer + 0
    ; 0E4h | eax            [ebp - 16]
    ; 0E0h | ebx            [ebp - 20]
    ; 0DCh | edx            [ebp - 24]
    ; 0D8h | edi            [ebp - 28] <--ESP

    ;digits are peeled off and put on stack in reverse order (right to left)
    
    
DspDword proc uses eax ebx edx edi,   ;registers to save and restore
              number:dword            ;parameter will be stored in number
              local buffer[12]:byte   ;allocate memory for a local array of 12 bytes
              
;"uses" directive automatically generates the asm code to push and pop the listed registers    
;"number:dword" automatically generates the asm code to work with a parameter on the stack
;"local buffer[12]:byte" automatically generates the asm code to allocate memory for 12 bytes on the stack

              
    mov     edi,0                  ;edi = offset from beginning of buffer
    mov 	ebx,10                 ;ebx = divisior for peeling off decimal digits

    mov     eax, number            ;number to print must be in eax for div

;each time through loop peel off one digit (division by 10),
;convert the digit to ascii and store the digit in the stack

;the use of the buffer local array means that to save a character onto the stack that we start
;at ebp -12 (buffer[0]) and move towards ebp -1 (buffer[11]) which is different
;than the DspDword we did previously where we started at ebp -1 and moved towards ebp - 12


next_hex:
    mov    edx,0                   ;set edx to 0 for edx:eax / 10
    div    ebx                     ;eax = quotient = dividend shifted right
                                   ;next time through loop quotient becomes
                                   ;new dividend.
    add    dl,'0'                  ;remainder is the digit to print
                                   ;convert digit to ascii
    mov    buffer[edi],dl          ; Save next converted digit in buffer on stack
    inc    edi                     ;move up in stack
    cmp    edi, 10                 ;only save 10 digits
    jl     next_hex                ; repeat until 10 digits on stack
    dec    edi                     ; when above loop ends we have gone 1 byte too far
                                   ; so back up one byte

;loop to display all digits stored in byte array on stack
DISPLAY_NEXT:      
    cmp    edi,0                   ;are we done processing digits?
    jl     DONE10                  ;repeat loop as long as edi >= 0
    mov    al,buffer[edi]          ;copy digit to display from stack to al
    call   WriteChar               ;display digit
    dec    edi                     ;edi = edi - 1
    jmp    DISPLAY_NEXT            ;repeat
DONE10:
    ret
DspDword endp

END
;----------------------------------------------
