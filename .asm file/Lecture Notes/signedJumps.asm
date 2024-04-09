;examples of signed and unsigned jumps
;
;Warning: per the examples below, signed and unsigned jumps may produce
;different results

;for signed numbers use: JL, JG (and variations like JNL etc)
;for unsigned numbers use: JB, JA (and variations like JNA etc)


.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack


;*************************PROTOTYPES*****************************

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

ReadChar PROTO  ;Irvine code for getting a single char from keyboard
				;Character is stored in the al register.
			    ;Can be used to pause program execution until key is hit.

;************************DATA SEGMENT***************************

.data

       byte1    byte   -16
       byte2    byte	20

;************************CODE SEGMENT****************************

.code

main PROC
        mov     al,byte1        ;al = -16 (F0) (240 dec)
        cmp     al,byte2        ;signed comparison -16 < 20
                                ;unsigned comparison 240 > 20
        jb      unsigned1       ;unsigned jump not taken since 240 > 20
        jl      signed1         ;signed jump taken since -16 < 20
        
        mov     bx,25           ;bx gets 25
unsigned1:
        mov     bx,35           ;bx gets 35

signed1:
        cmp     al,byte2        ;signed comparison -16 < 20
                                ;unsigned comparison 240 > 20
        jg      signed2         ;signed jump not taken since -16 < 20
        ja      done            ;unsigned jump taken since 240 > 20 
        mov     bx,30           ;bx gets 30
signed2:
        mov     bx,40           ;bx gets 40
done: 
    
   	    call	ReadChar	    ;pause execution
	    INVOKE	ExitProcess,0   ;exit to dos

main ENDP
END main