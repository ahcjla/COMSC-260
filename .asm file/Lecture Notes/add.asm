;Example of using the add instruction

;add instruction - 
;
; General form: 
;       ADD operand1,operand2
; Description:
;         operand1 = operand1 + operand2
; Allowable operands:
;         reg,reg  -  reg,mem  -  reg,immed
;         mem,reg  -  mem,immed
; Flags changed:
;         O,S,Z,A,P,C
; Note:
;         Both operands must be of the same size.  
;         Can be unsigned or signed binary integers.


.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;*************************PROTOTYPES*****************************

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

ReadChar PROTO                      ;Irvine code for getting a single char from keyboard
				                    ;Character is stored in the al register.
			                        ;Can be used to pause program execution until key is hit.


WriteHex PROTO                      ;Irvine function to write a hex number in EAX to the console


;************************DATA SEGMENT***************************

.data

    aNum    word   0ABC7h
    bNum    dword  98C456CCh

;************************CODE SEGMENT****************************

.code

main PROC

mov eax, 27
cmp eax, 18

    call    ReadChar        ; Pause program execution while user inputs a non-displayed char
    INVOKE	ExitProcess,0   ;exit to dos: like C++ exit(0)

main ENDP
END main