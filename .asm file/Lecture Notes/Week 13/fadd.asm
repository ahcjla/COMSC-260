;fadd.asm
;Author: Fred Kennedy - Diablo Valley College

;This program gives examples of using the various forms of the fadd fp instruction and the fld,fstp and fst floating point instructions

;   - fld pushes floating point numbers onto the floating point stack
;   - fstp copies st(0) to an operand and pops the fp stack
;   - fst copies st(0) to an operand but does not pop the fp stack

;This program slso demonstrates using SetfloatPlaces and DspFPStack from the KennedyDspFloat.lib

;Note: Before compiling this program you must include Irvine32.lib and KennedyDspfloat.lib in your project

;fadd instruction - 
;
; General form: 
;       FADD - no operand (st(0) added to st(1) result in st(1). st(0) popped leaving result in st(0))
;       FADD m32fp (real4 memory operand added to st(0), result in st(0) (st(0)+= operand)
;       FADD m64fp (real8 memory operand added to st(0), result in st(0) (st(0)+= operand)
;       FADD st(0), st(i) (st(0) += st(i)) i  is any FP register 0 - 7.
;       FADD st(i), st(0) (st(i) += st(0))i  is any FP register 0 - 7.
;


.386                    ;identifies minimum CPU for this program

.MODEL flat,stdcall     ;flat - protected mode program
                        ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096              ;allocate 4096 bytes (1000h) for stack

;mPrtChar macro - Display a character in al
mPrtChar  MACRO  arg1    ; arg1 is replaced by the name of character to be displayed
    push eax             ; save eax
    mov al, arg1         ; character to display should be in al
    call WriteChar       ; display character in al
    pop eax              ; restore eax
ENDM

;mPrtFPStack macro - Display fp stack followed by LF
mPrtFPStack macro
    call DspFPStack      ;Display fp stack without fp registers
    mPrtChar LF          ;print a LF
ENDM

; *************************CONSTANTS*****************************

	LF equ 0Ah          ;line feed


;*************************PROTOTYPES*****************************

ExitProcess  PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine to exit to OS

DspFPStack PROTO        ;prints the fp stack st(0) - st(7) in column form. Does not include the fp register number


SetFloatPlaces PROTO    ;sets the number of places a float should round to while printing 
                        ;The default places is 1.
                        ;populate ecx with the number of places to round a floating point num to
                        ;then call SetFloatPlaces.
                        ;If the places to round to  is 2 then 7.466
                        ;would display as 7.47 after calling DspFloat or DspFloatP
                        ;The rounding is for printing purposes only and
                        ;does not change the original number.
                        ;The places to round to does not change until
                        ;you call SetFloatPlaces again.

WriteChar PROTO         ;Irvine function to display the character in al to the console

ReadChar PROTO          ;Irvine code for getting a single char from keyboard
				        ;Character is stored in the al register.
			            ;Can be used to pause program execution until key is hit.



;************************DATA SEGMENT***************************

.data

    ;fp numbers declared as real8, double precision, 64-bit floating point numbers
    fnum1   real8  32.9813
    fnum2   real8  234.32567
    fnum3   real8   ?

;************************CODE SEGMENT****************************

.code

main PROC

    ;Note: to view the floating point stack you should right click
    ;in the register window and click on floating point

    mov         ecx, 5              ;ecx = number of places to print fp to: 5 places ie 32.98130
    call        SetFloatPlaces      ;set number of places to print fp to

    mPrtFPStack                     ;display empty floating point stack with the following code
                                    ;call DspFPStack
                                    ;mPrtChar LF

    ;call        DspFPStack          ;display the fp stack
    ;mPrtChar    LF                  ;print a LF

    ;push fnum1 and fnum2 onto the floating point stack to be added together    
    fld         fnum1               ;st(0) = 32.9813

    mPrtFPStack                     ;display floating point stack after pushing fnum1
    
    ;push fnum2 onto fp stack
    fld         fnum2               ;st(0) = 234.32567 st(1) = 32.9813

    mPrtFPStack                     ;display floating point stack after pushing fnum2
    
    ;no operand version of fadd
    fadd                            ;st(1) = st(1) + st(0)then st(0) popped leaving sum in st(0)
                                    ; = 234.32567 + 32.9813= 2.6730696999999997e+0002 = 267.30697

    mPrtFPStack                     ;display floating point stack after fadd
      
    fld         fnum1               ;st(0) = 32.9813

    mPrtFPStack                     ;display floating point stack after pushing fnum1

    ;memory operand version of fadd : st(0) += memory operand
    fadd        fnum2               ;st(0) += fnum2 = st(0) = 32.9813 + 234.32567 = 267.30967

    mPrtFPStack                     ;display floating point stack after fadd
           
    fld         fnum1               ;st(0) = 32.9813

    mPrtFPStack                     ;display floating point stack after pushing fnum1

    fld         fnum2               ;st(0) = 234.32567 st(1) = 32.9813

    mPrtFPStack                     ;display floating point stack after pushing fnum2

    ;add 2 floating point registers - one must be st(0) : st(0) = st(0) + st(i)  (i can be 0-7)
    fadd        st(0),st(3)         ;st(0) = 234.32567 + 267.30967 = 5.0163263999999998e+0002 = 501.63264

    mPrtFPStack                     ;display floating point stack after fadd

    fld         fnum1               ;st(0) = 32.9813

    mPrtFPStack                     ;display floating point stack after pushing fnum1

    fld         fnum2               ;st(0) = 234.32567 st(1) = 32.9813

    mPrtFPStack                     ;display floating point stack after pushing fnum2

    ;add 2 floating point registers: one must be st(0) ; st(i) = st(i) + st(0) ( i can be 0-7)
    fadd        st(4),st(0)         ;st(4) = 267.30967 + 234.32567 = 5.0163263999999998e+0002 = 501.6326

    mPrtFPStack                     ;display floating point stack after fadd

    ;copy address of fnum3 to ebx so you can drag ebx to memory window to see how it changes
    mov         ebx, offset fnum3   ;ebx = address of fnum3 to view fnum3 in mem window

    ;FSTP - copy top of stack (st(0)) to memory or to a floating point register then pop FP stack
    fstp        fnum3               ;fnum3 = st(0)  then pop  FP stack

    mPrtFPStack                     ;display floating point stack after popping value from top of fp stack

    ;FST - copy top of stack (st(0)) to memory or to a floating point register. Doesn't pop FP stack
    fst         st(7)               ;st(7) = st(0) don't pop  FP stack

    ;don't use mPrtFPStack here since LF not needed
    call        DspFPStack          ;display floating point stack after copying value from top of fp stack. No pop.

    call        ReadChar            ;pause execution of program
	INVOKE	    ExitProcess,0       ;exit to dos: like C++ exit(0)

main ENDP
END main