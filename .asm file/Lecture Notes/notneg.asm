;The code below are examples of using not and neg
;
; not flips the bits of a reg or mem. For example:
; mov al, 00001011
; not al   ;al = 11110100

; neg does a twos complement of a reg or mem (flip bits and add 1). For example:
; mov al, 2  ;al= 00000010
; neg al   ;al = FEh = -2 = 1111111110


.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;*************************PROTOTYPES*****************************

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

DumpRegs PROTO  ;Irvine code for printing registers to the screen

ReadChar PROTO  ;Irvine code for getting a single char from keyboard
				;Character is stored in the al register.
			    ;Can be used to pause program execution until key is hit.

;************************DATA SEGMENT***************************

.data

;************************CODE SEGMENT****************************

.code

main PROC

    ;example of using not and neg to do two's complement
    ;not flips the bits (1's become 0's and 0's become 1's)

    mov     al, 5           ;al = 5 = 00000101b
    not     al              ;flip the bits = 11111010b
    add     al, 1           ;add 1 : al = -5 = 11111011b

    ;neg flips the bits and adds 1
    neg     al              ;do two's complement on al 11111011b -> 00000101b
                            ;al = 5

   	call	ReadChar		;pause execution
	INVOKE	ExitProcess,0	;exit to dos

main ENDP
END main