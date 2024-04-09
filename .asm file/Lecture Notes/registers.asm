;Example of using 32 bit registers

;32 bit registers that can be subdivided into 16 bit and 8 bit registers are:
;eax, ebx, ecx, edx

;  32 bit  16 bit   8 bit high    8 bit low
;  eax      ax          ah            al
;  ebx      bx          bh            bl
;  ecx      cx          ch            cl
;  edx      dx          dh            dl

;for example eax can be diagrammed as follows(ebx, ecx and edx are similar):

;|        |     |    |
;<--------eax--------> 32 bits (dword)
;         |          |
;         <----ax----> 16 bits (word)
;         |     |    |
;         <-ah-><-al-> ah and al 8 bits each (byte)

;Note: the upper 16 bits of a 32 bit register is not directly accessible
;
;Registers that have a lower half (16 bits) that cannot be further subdivided are:

;  32 bit  16 bit  (no 8 bit parts)
;   esi      si
;   edi      di
;   ebp      bp
;   esp      sp   (esp contains the address of where you are on the stack)

;for example esi can be diagrammed as follows(edi, ebp and esp are similar):

;|        |          |
;<--------esi--------> 32 bits (dword)
;         |          |
;         <----si----> 16 bits (word)


;Hex digits

;Each hex digit occupies 4 bits. 4 bits is also called a nibble.
;2 hex digits occupies 8 bits (1 byte)
;Each register holds 32 bits or 4 bytes = 8 hex digits
            
.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;*************************PROTOTYPES*****************************

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

;************************DATA SEGMENT***************************

.data

;************************CODE SEGMENT****************************

.code

main PROC

    ;note: hex numbers that begin with a letter must have a 0 in front
    ;otherwise the compiler thinks it is an undefined identifier
    ;and you will get a compile error
 
    mov     eax, 012FFAC0h  ;eax = 012FFAC0h ax = FAC0h ah = FAh al = C0h
    mov     ax, 1BACh       ;eax = 012F1BACh ax = 1BACh ah = 1Bh al = ACh
    mov     ah, 0Fh         ;eax = 012F0FACh ax = 0FACh ah = 0Fh al = ACh
    mov     al, 4h          ;eax = 012F0F04h ax = 0F04h ah = 0Fh al = 04h
    mov     eax,1h          ;eax = 00000001h ax = 0001h ah = 00h al = 01h

	INVOKE	ExitProcess,0   ;exit to dos: like C++ exit(0)

main ENDP
END main