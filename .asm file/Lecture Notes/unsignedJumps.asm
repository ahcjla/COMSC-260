;examples of unsigned jumps
;

;for unsigned numbers use: JB, JA, JE (and variations like JNA, JNE etc)


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

;************************CODE SEGMENT****************************

.code

main PROC

        mov     al,10              ;al = 10
        cmp     al,5               ;compare 10 to 5 (10 > 5)
        jb      below              ;unsigned jump, jb, not taken since 10 > 5 
        ja      above              ;unsigned jump, ja, taken since 10 > 5 (ZF=0,CF=0)
        
        mov     bx,25              ;if the above jumps are not taken, then only possibility is that the
                                   ;numbers are equal. bx gets 25 
        jmp     nextExample        ;go to next example                        
above:
        mov     bx,35              ;bx gets 35
        jmp     nextExample        ;go to next example

below:
        mov     bx, 45             ;bx gets 45
        
nextExample:
        mov     al,5               ;al = 5
        cmp     al,5               ;compare 5 to 5 (5 ==5)
        jb      below2             ;jb not taken since 5 == 5 
        je      equal              ;je taken since 5 == 5 and above jump was not taken
        
        ;the following line executes only if op1 > op2
        mov     bx,55              ;if the above jumps are not taken, then only 
                                   ;possibility is that op1 > op2 and you don't need to test for it
                            
        jmp     nextExample2       ;go to next example                        
equal:
        mov     bx,65              ;bx gets 65
        jmp     nextExample2       ;go to next example

below2:
        mov     bx, 75             ;bx gets 75
        
nextExample2:
        mov     al,3               ;al = 3
        cmp     al,5               ;compare 3 to 5  (3 < 5)
        jb      below3             ;jb taken since 3 < 5 (ZF=0,CF=1)
        ja      above3             ;ja not taken since 3 < 5 and above jump taken
        
        mov     bx,85              ;if the above jumps are not taken, then only possibility is that the
                                   ;numbers are equal 
                            
        jmp     done               ;go to end                        
above3:
        mov     bx,95              ;bx gets 95
        jmp     done               ;go to end

below3:
        mov     bx, 105            ;bx gets 105
        
done:
   
   	    call	ReadChar		   ;pause execution
	    INVOKE	ExitProcess,0	   ;exit to dos

main ENDP
END main