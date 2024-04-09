;Example of using push and pop to save values on the stack


;stack facts 1-4 (facts 5 and 6 dealing with function calls left off)
;  1. The stack operates in a LIFO fashion: [L]ast [I]n [F]irst [O]ut.
;     The last item pushed onto the stack is the first thing removed.
;  2. the stack grows from high memory to low memory
;  3. The main benefit of the stack is memory reuse.
;     Data that is popped off the stack allows for other data to reuse 
;     the memory space  that was occupied by the previous data.
;  4. ESP contains the stack pointer which always points to the top of stack.


;to look at the stack, open a memory window and drag the ESP
;register to memory window.

;Since the stack grows from high memory to low memory, you may have to
;scroll up in the memory window to watch items being pushed onto the stack

.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;Irvine32.lib contains the code for DumpRegs and many other Irvine
;functions

;*************************PROTOTYPES*****************************

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

WriteHex PROTO  ;write number stored in eax
                ;to console in hex

ReadChar PROTO  ;Irvine code for getting a single char from keyboard
				;Character is stored in the al register.
			    ;Can be used to pause program execution until key is hit.

;************************DATA SEGMENT***************************

.data
        qnum qword 12345678ABCDEF45h
        numArray   byte  10,  20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150
        num1 dword 12345678h

        num2 byte 5Dh,4h
num3 word 3Ch
num4 dword 2AECDh


;************************CODE SEGMENT****************************

.code

main PROC

mov   EAX, 12ABCDEFh
mov EBX, 12345678h
mov AX, 1234h
mov BX, 0BCDh
mov BL, AH

    mov esi, offset numArray
    add esi, 4
    mov ebx, 8
    mov al, [esi + ebx]

    mov eax, dword ptr qnum+4

    ;save eax, var1 and an imm value onto the stack
    ;mov     eax, 0AAAAAAAAh     ;eax = DDDDDDDDh
    ;mov     ebx, 0BBBBBBBBh     ;ebx = EEEEEEEEh
    ;mov     ecx, 0CCCCCCCCh     ;ecx = FFFFFFFFh
    
    ;save eax, var1 and an imm value onto the stack
    ;push    eax                 ;save eax on stack
    ;push    ebx                 ;save ebx on stack
    ;push    ecx                 ;save ecx on stack

    ;change values stored in eax, ebx and ecx
    ;mov     eax, 0DDDDDDDDh     ;eax = DDDDDDDDh
    ;mov     ebx, 0EEEEEEEEh     ;ebx = EEEEEEEEh
    ;mov     ecx, 0FFFFFFFFh     ;ecx = FFFFFFFFh
    
   
    ;restore eax, ebx and ecx to original values by popping saved values off stack
    ;pop values into registers in reverse order they were pushed.
    ;pop     ecx                 ;restore ecx
    ;pop     ebx                 ;restore ebx
    ;pop     eax                 ;restore eax

    ;the following illustrates stack reuse
    ;push    ecx                 ;save ecx on the stack
    ;pop     eax                 ;restore ecx to eax - not as efficient as mov eax, ecx

    mov eax, 15h
    mov ebx, 0CDh
    mov ecx, 0FFh
    push eax
    pop ecx
    push ebx
    push 0EFh
    pop eax
    push ecx
    push eax

    pop ecx
    pop ebx
    pop eax

    call    ReadChar            ;pause execution
    INVOKE  ExitProcess,0       ;exit to dos

main ENDP

END main