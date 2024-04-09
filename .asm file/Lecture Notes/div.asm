;div (divide) instruction 
;
;(From class notes by Gary Montante and Paul Lou)
;(Modified by Fred Kennedy for 32 bits and Irvine Library)
;
; General form:
; DIV	operand
; Description (unsigned DIVision):
; If operand is 8 bits then
;       AL = AX / operand8		(quotient)
;       AH = AX mod operand8	(remainder)
; If operand is 16 bits then
;       AX = DX:AX / operand16	(quotient)
;       DX = DX:AX mod operand16 (remainder)
; If operand is 32 bits then
;       EAX = EDX:EAX / operand32	(quotient)
;       EDX = EDX:EAX mod operand32 (remainder)
; Allowable operands:
;       reg - mem
; Flags changed:
;       None.
; Note:
;       Both operands are treated as unsigned binary integers.  
;       Division by zero may give unpredictable results (probably  INT 00h ) 
;
;
;  div op2  |divisor |dividend |
; example   |op2     |   op1   |  quotient | remainder
;-----------------------------------------------------
; div ebx   |dword   | edx:eax |   eax     | edx 
; div cx    | word   |  dx:ax  |    ax     | dx
; div cl    | byte   |  ax     |    al     | ah


.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;*************************PROTOTYPES*****************************

ExitProcess PROTO,
    dwExitCode:DWORD    ;from Win32 api not Irvine to exit to dos with exit code

ReadChar PROTO          ;Irvine code for getting a single char from keyboard
                        ;Character is stored in the al register.
                        ;Can be used to pause program execution until key is hit.


;************************DATA SEGMENT***************************

.data
        byte1   byte        49h                 ;byte1 = 49h
        byte2	byte	    23h                 ;byte2 = 23h
        word1	word	    0234h               ;word1 = 0234h
        word2	word	    0A274h              ;word2 = 0A274h
        word3   word        1234h               ;word3 = 1234h
        word4   word        10h                 ;word4 = 10h
                                                ;byte #    3   2    1  0
        dword1  dword       1234abcdh           ;dword1 = [12][34][ab][cd]h
        dword2  dword       5A274h              ;dword2 = 5A274h

                                                ;byte #     7   6   5  4   3    2   1   0 
        qword1  qword       1234567890abcdefh   ;qword1 = [12][34][56][78][90][ab][cd][ef]h
       

        
;****************Addressing bytes****************

;You can refer to individual bytes of a variable by adding an
;integer to a variable name: qword1+4 would refer to byte 4 of qword1

;The byte counting starts on the right (lowest byte) with 0.

;For example for qword1 defined above the byte numbering is as follows:

;  7   6   5   4   3   2   1   0
;[12][34][56][78][90][ab][cd][ef]h

;The following syntax can be used to copy the first 4 bytes of qword1 (90abcdefh) into eax:

;mov	    eax,dword ptr qword1+0      ;starting at byte 0 copy 4 bytes into eax

;the syntax, "dword ptr" says qword1 points to a dword so 4 bytes will be copied.

;If you wanted to copy 2 bytes you would use "word ptr":

;mov	    ax,word ptr qword1+4    ;starting at byte 4 copy 2 bytes (5678h)  into ax
        
.code

Main PROC

;---- BYTE / BYTE (convert byte to word, then divide)
    movzx	ax,byte1                ;ax = 0049h 
    div     byte2                   ;quotient in  AL = AX/byte2 =  49h/23h = 2 
                                    ;remainder in AH = 3h

;---- WORD/BYTE

    mov	    ax,word1                ;ax = 0234h  (word dividend)
    div	    byte1	                ;quotient in  AL = AX/byte1 =  0234h/49h = 7h
                                    ;remainder in AH = 35h 

;---- WORD/WORD (convert word to dword, then divide)

    mov	    ax,word1                ; AX contains word dividend = 0234h
    mov     dx,0	                ;DX:AX pair= word1 converted to dword (4 bytes)
    div	    word2	                ;quotient in AX = DX:AX/word2 = 0000 0234h/0A274h = 0
                                    ;Remainder in DX = 234h
;---- DWORD/WORD 
    mov	    ax,word ptr dword1+0    ;AX = abcdh (low word of dword1)
    mov	    dx,word ptr dword1+2	;DX = 1234h (high word of dword1)
    div     word2                   ;quotient in AX = DX:AX/word2 
                                    ;               = 1234 ABCD/0A274h
                                    ;               = 1CB0h
                                    ;Remainder in DX = 4C0Dh

;---- QWORD/DWORD
    mov	    eax,dword ptr qword1+0  ;EAX = 90abcdefh (low dword of qword1)
    mov	    edx,dword ptr qword1+4	;EDX = 12345678h (high dword of qword1)
    
    div     dword1                  ;quotient in EAX  = EDX:EAX/dword1 
                                    ;                 = 12345678 90abcdefh/ 1234abcdh
                                    ;                 = FFFB5022h
                                    ;Remainder in EDX = 0AFDECB5h


;----problem if quotient won't fit in destination
; For example if you divide a DWORD/WORD and the answer won't fit in a WORD
;  you will get an error since quotient won't fit in ax
;---the following example illustrates the problem and a solution

    ;mov	    ax,word ptr dword1+0    ;AX = abcdh (low word of dword1)
    ;mov	    dx,word ptr dword1+2	;DX = 1234h (high word of dword1)    
    ;div	    word4	                ;1234abcdh/10h = 1234abch 
                                        ;;;              = dword quotient will not fit in word (AX)
                                        ;During stepping in debugger you may get 
                                        ;error and program will halt.
                      
;solution to above problem: convert dword to qword and word to dword
    ;convert dword to qword
    mov    eax,dword1               ;EAX = 1234abcdh
    mov    edx,0                    ;                   EDX : EAX now contains the 
                                    ;qword dividend:00000000 1234abcdh
    ;convert word to dword 
    movzx  ecx,word4                ;ecx = 0010h

    ;divide edx:eax by ecx
    div    ecx                      ;quotient in EAX =     EDX :  EAX    /  ECX 
                                    ;                = 00000000 1234abcdh/00000010h
                                    ;                = 001234abch
                                    ;Remainder in EDX =0000000dh

;---- division by zero will crash program
    mov	    ax,word1                ;ax = word1 = 234h
    mov     bl,0                    ;BL= 00h
    div     bl                      ;will cause unpredictable results and program may crash
     
    call    ReadChar                ;pause execution
	INVOKE  ExitProcess,0           ;exit to dos: like C++ exit(0)

Main ENDP

END Main