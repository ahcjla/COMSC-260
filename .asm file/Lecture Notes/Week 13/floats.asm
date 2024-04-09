;Example of how 4 byte floating point numbers are represented in memory
;
;Also an example of using the KennedyDspFloat.lib to display floating point numbers.
;
;Note: before compiling this file include the following in your VS project
;
;irvine32.lib
;KennedyDspfloat.lib

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

mPrtChar MACRO  arg1     ;arg1 is replaced by the name of character to be displayed
         push eax        ;save eax
         mov al, arg1    ;character to display should be in al
         call WriteChar  ;display character in al
         pop eax         ;restore eax
ENDM

;*************************CONSTANTS*****************************

    LF  equ 0AH

;*************************PROTOTYPES*****************************

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

ReadChar PROTO          ;Irvine code for getting a single char from keyboard
				        ;Character is stored in the al register.
			            ;Can be used to pause program execution until any key is hit.

WriteChar PROTO         ;Irvine code to write the character in al to the console

DspBinExpMan32 proto    ;KennedyDspFloat.lib function to print in binary the floating point number on top of 
                        ;the floating point stack in IEEE short floating point format
                        ;as 1 sign bit space 8 exponent bits space 23 mantissa bits
                        ;ie 0 01111110 01000000000000000000000

DspFloat proto          ;KennedyDspFloat.lib function to print the floating point number on top of 
                        ;the floating point stack to the number of places set by SetFloatPlaces.
                        ;ie 12.1250 if places is 4

SetFloatPlaces proto    ;KennedyDspFloat.lib function to set the number of places to print a floating point number to.
                        ;Populate ecx with the number of places to print to, then call SetFloatPlaces

WriteString proto       ;Irvine code to print a zero terminated string to the console.
                        ;Before calling WriteString populate edx with the address of the string

;************************DATA SEGMENT***************************

	.data

    ;An array of floating point numbers declared as real4
    ;real4 is in IEEE short floating point format (4 bytes, same as float type in C++)

    floats real4 12.625,   ;lecture
                  0.625,   ;lecture
                  0.1,     ;lecture
                 -7.6875,  ;worksheet
                 -4.5,     ;worksheet
                  0.0,
                  1.0,
                -10.1875
    ARRAY_SIZE equ sizeof floats    ;size of floats in bytes

    blankLn byte LF,LF,0

;************************CODE SEGMENT****************************

.code

main PROC

    ;to view how a floating point number looks in memory
    ;copy the address of the varible to ebx then drag ebx to memory window

    ;use DspBinExpMan32 to display the float in binary so you can compare it to a manually calculated value
    ;DspBinExpMan32 to displays the float in binary as 1 sign bit space 8 exponent bits space 23 mantissa bits
    
    mov      ebx, offset floats  ;copy the address of the varible then drag ebx to memory window
                                 ;to view how floating point numbers look in memory

    mov      ecx, 4              ;Number of places to print to is 4. 
    call     setfloatPlaces      ;set the numbr of places to print to which is in ecx

    mov      esi,0               ;set counter to 0

loopTop:
    cmp      esi, ARRAY_SIZE     ;compare counter to ARRAY_SIZE 
    jae      done                ;when counter reaches ARRAY_SIZE loop is done

    fld      floats[esi]         ;push fp number onto fp stack
    call     DspFloat            ;display fp number in st(0)

    mPrtChar LF                  ;print a LF

    call     DspBinExpMan32      ;display fp number in st(0) in binary
    mPrtStr  blankLn             ;print a blank line

    add      esi, sizeof real4   ;increment counter by size of real4
    jmp      loopTop             ;repeat loop
done:

   	call	 ReadChar		     ;pause execution
	INVOKE	 ExitProcess,0	     ;exit to dos

main ENDP
END main