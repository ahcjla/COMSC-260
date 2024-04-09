;example of declaring variables of different sizes
;and looking in memory to see how they are stored

;the data declarations are modifed from the Irvine file: DataDef.asm

;You should display the register and memory windows.

;You can only display the register and memory windows
;while your program is running.

;You can run your program by stepping with F10.

;then go to debug->windows->registers or use Alt-5
;and debug->windows->memory->memory 1 or use Alt-6

;mov the address of the variable you want to see in memory to a register
;mov edx, offset var1

;copy the address of the variable from the register to the memory window


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

; ----------------- Byte Values ----------------
.data
value1  byte  'A'                   ;stored in mem as 41h
value2  byte   0
value3  byte  'AB'                  ;stored in mem 41h42h
value4  byte   255
value6  byte   ?                    ;? means uninitialized data

list   byte  10, 32, 41h, 00100010b
list2   byte  0Ah, 20h, 'A', 22h    ;'A' is stored as 41h
array1  byte  20 DUP(0)             ;declare an array of 20 bytes
                                    ;each byte initialized to 0
array2  byte  20 DUP('X')           ;declare an array of 20 bytes
                                    ;each byte initialized to 'X'
array3  byte  20 DUP (?)            ;declare an array of 20 bytes
                                    ;each byte is not initialized

greeting1 byte "Good afternoon",0   ;each character of string is stored
                                    ;in a separate byte


; ----------------- Word (2 bytes) Values ---------------------

word1   word   0A5C3h	            ; stored in mem C3A5
word2   word    'AB'                ; stored in mem 42h41h
word3   word    'A','B'             ; stored in mem 41004200h
word4   word   ?		            ; uninitialized
myList  word   1,2,3,4,5	        ; array of words stored as follows
                                    ;0100 0200 0300 0400 0500

                            
; --------------- DoubleWord (4 bytes) Values --------------

val1  dword   12345678h             ;stored in memory 78563412h
val2  dword   20 DUP(0ABCDEF78H)    ;array of 20 DoubleWords
                                    ;each DoubleWord stores 0ABCDEF78H
                                    ;in the following order: 78EFCDABH

; ------- QuadWord (8 bytes) and TenByte Values ------------

quad1  qword  1234567812345678h     ;stored in memory 7856341278563412
ten1   tbyte  1000000000123456789Ah ;what order is this in memory?

;************************CODE SEGMENT****************************

.code

main PROC

    ;mov the address of a variable to a register
    ;so you can look at the variable in memory

    mov     edx, offset value1      ;address of variable is stored in edx
    mov     edx, offset array2      ;address of variable is stored in edx
    mov     edx, offset word1       ;address of variable is stored in edx
    mov     edx, offset word2       ;address of variable is stored in edx
    mov     edx, offset val1        ;address of variable is stored in edx
    mov     edx, offset quad1       ;address of variable is stored in edx

	call	ReadChar		        ;pause execution
	INVOKE	ExitProcess,0	        ;exit to dos: like C++ exit(0)

main ENDP
END main