;Example of using a while loop to print out a byte array


.386                   ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096             ;allocate 4096 bytes (1000h) for stack

;*************************PROTOTYPES*****************************

ExitProcess PROTO,
    dwExitCode:DWORD    ;from Win32 api not Irvine to exit to dos with exit code

ReadChar PROTO          ;Irvine code for getting a single char from keyboard
				        ;Character is stored in the al register.
			            ;Can be used to pause program execution until key is hit.

WriteChar PROTO         ;Irvine code to write character stored in al to console

WriteDec PROTO          ;Irvine code to write number stored in eax
                        ;to console in decimal

;************************  Constants  ***************************

LF       equ     0Ah                   ; ASCII Line Feed

;************************DATA SEGMENT***************************

.data
                ;offset   0  1  2 3 
    testArray   byte     34,45,23,45        ;byte array
    ARRAY_SIZE  equ     sizeof testArray    ;ARRAY_SIZE = total bytes in array


;************************CODE SEGMENT****************************

.code

Main PROC

    ;confirm the array size
    mov     eax, ARRAY_SIZE         ;eax = ARRAY_SIZE in bytes
    call    WriteDec                ;print the number in eax
 
    mov     al, LF                  ;copy Line Feed to al
    call    WriteChar               ;print line feed

    ;while loop to print out array
    ;iterate through the array until all bytes have been processed.

    mov     esi  , 0                ;esi is the offset from the beginning of the array.
                                    ;Initialize esi to 0 since the first element of the
                                    ;is at testArray + 0
loopTop:
    cmp     esi  , ARRAY_SIZE       ;compare esi to the total bytes of the array
    jae     done                    ;if we have processed all bytes then done
    
    movzx   eax,testArray[esi]      ;copy the byte at [testArray + esi] into eax
    call    WriteDec                ;print the number in eax

    mov     al, ' '                 ;al = space
    call    WriteChar               ;print the space

    inc     esi                     ;esi contains the offset from the beginning of the array. 
                                    ;add 1 to esi so that testArray + esi   points to the 
                                    ;next element of the byte array 

    jmp     loopTop                 ;repeat loop
    
done:      
    call    ReadChar                ;pause execution
	INVOKE  ExitProcess,0           ;exit to dos: like C++ exit(0)

Main ENDP

END Main