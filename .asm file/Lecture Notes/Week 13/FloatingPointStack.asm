;FloatingPointStack.asm
;Author: Fred Kennedy - Diablo Valley College

;This program demonstrates how pushing and popping values on and off the fp stack
;effects the fp stack.

;This program also gives examples of using the fld and fstp floating point instructions

;   - fld pushes floating point numbers onto the floating point stack
;   - fstp pops floating point numbers off the floating point stack into an operand

;This program slso demonstrates using SetfloatPlaces and DspFPStackR from the KennedyDspFloat.lib

;Note: Before compiling this program you must include Irvine32.lib and KennedyDspfloat.lib in your project


.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;*******************MACROS********************************

mPrtStr  MACRO  arg1            ;arg1 is replaced by the name of string to be displayed
		 push edx				;save edx
         mov  edx, offset arg1  ;address of str to display should be in edx
         call WriteString       ;display 0 terminated string
         pop  edx				;restore edx
ENDM

mPrtChar MACRO  arg1    ;arg1 is replaced by the name of character to be displayed
         push eax        ;save eax
         mov al, arg1    ;character to display should be in al
         call WriteChar  ;display character in al
         pop eax         ;restore eax
ENDM

;*************************PROTOTYPES*****************************

WriteString PROTO		;Irvine code to Write null-terminated string to console. String address should be in EDX

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

        
ReadChar PROTO          ;Irvine code for getting a single char from keyboard
				        ;Character is stored in the al register.
			            ;Can be used to pause program execution until key is hit.

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

DspFPStackR proto       ;prints the fp stack st(0) - st(7) in column form and includes the fp register number

;************************  Constants  ***************************

    LF       equ     0Ah                   ; ASCII Line Feed

;************************DATA SEGMENT***************************

.data

    emptyStackMsg byte    "Empty FPU stack",LF,0
    fldFnum1Msg   byte LF,"FPU stack after fld fnum1",LF,0
    fldFnum2Msg   byte LF,"FPU stack after fld fnum2",LF,0
    fldFnum3Msg   byte LF,"FPU stack after fld fnum3",LF,0
    fstpFnum1Msg  byte LF,"FPU stack after fstp fnum1",LF,0

    ;variables are declared as real8 which is a 64 bit floating point size
    fnum1   real8  3.75
    fnum2   real8  5.25
    fnum3   real8  8.5

;************************CODE SEGMENT****************************

.code

main PROC
    ;Note: to view the floating point stack in the debugger you should right click
    ;in the register window and click on floating point

    mov     ecx, 2              ;ecx = 2 which is the number of places a fp number should print to
    call    SetFloatPlaces      ;set the number of places a fp number should print to (ecx)

    mPrtStr emptyStackMsg       ;print fp stack display title
    call    DspFPStackR         ;display fp stack including fp registers

    fld     fnum1               ;st(0) = fnum1
    mPrtStr fldFnum1Msg         ;print fp stack display title
    call    DspFPStackR         ;display fp stack including fp registers

    fld     fnum2               ;st(0) = fnum2
    mPrtStr fldFnum2Msg         ;print fp stack display title
    call    DspFPStackR         ;display fp stack including fp registers

    fld     fnum3               ;st(0) = fnum3
    mPrtStr fldFnum3Msg         ;print fp stack display title
    call    DspFPStackR         ;display fp stack including fp registers

    mov     ebx, offset fnum1   ;ebx has address of fnum1
                                ;drag ebx to a memory window to watch fnum1 change with fstp below
                                ;right click in memory window and choose 64-bit floating point

    fstp    fnum1               ;copy st(0) to fnum1 and pop fp stack
    mPrtStr fstpFnum1Msg        ;print fp stack display title
    call    DspFPStackR         ;display fp stack including fp registers

    fstp    fnum1               ;copy st(0) to fnum1 and pop fp stack
    mPrtStr fstpFnum1Msg        ;print fp stack display title
    call    DspFPStackR         ;display fp stack including fp registers

    fstp    fnum1               ;copy st(0) to fnum1 and pop fp stack
    mPrtStr fstpFnum1Msg        ;print fp stack display title
    call    DspFPStackR         ;display fp stack including fp registers

    call    ReadChar            ;pause execution of program
	INVOKE	ExitProcess,0       ;exit to dos: like C++ exit(0)

main ENDP
END main