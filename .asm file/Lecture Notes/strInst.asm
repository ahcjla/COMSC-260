; string processing - taken from chapter 20 of the class notes 
; by Paul Lou and Gary Montante 
; Modified and converted to 32 bits and the Irvine library by Fred Kennedy

;============================================
; [L]oad [E]ffective [A]ddress - LEA
; lea copies the address of operand2 (variable) into operand1 (register)
;
; For example:
; lea ebx, someVar
;
; The above copies the address of someVar into ebx and is the same as
; mov ebx, offset someVar
;============================================

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

;The $ is current location counter for where you are currently in this case in the data section
;You can use $ - label to get the size of a variable

source1		byte	"I love assembly"
SOURCE1_LEN equ $ - source1            ;size of source1 in bytes
dest1	    byte  SOURCE1_LEN dup(?)

source2		byte	"assembly is fun"
SOURCE2_LEN equ $ - source2            ;size of source2 in bytes
dest2	    byte  SOURCE2_LEN dup(?)

source3		byte	"assemblers like to mov things"
SOURCE3_LEN equ $ - source3            ;size of source3 in bytes
dest3	    byte  SOURCE3_LEN dup(?)

array1	    dword  10,25,30,40,50
ARRAY1_LEN  equ ($ - array1) / 4       ;size of array1 in dwords
array2		dword  10,25,30,40,50
ARRAY2_LEN  equ ($ - array2) / 4       ;size of array2 in dwords
array3		dword  10,25,35,40,50
ARRAY3_LEN  equ ($ - array3) / 4       ;size of array3 in dwords

.code

main proc

;****************************************************
;    copy one string to another using regular loop
;****************************************************

    ;lea esi, source1 is the same as mov esi, offset source1
    
    ;source1 - "I love assembly"
    ;dest1 - uninitialized

	lea     esi, source1        ;address of string to copy goes into esi
	lea     edi, dest1          ;address of string to copy to goes into edi
	mov	    ecx, SOURCE1_LEN	;ECX = loop count = length of string to copy
	jecxz   done				; jump if ecx = 0, oops, nothing to copy
    ;DIRECTION = forward(INC ESI/EDI)
again:
	mov     al,byte ptr [esi]	;AL = next byte 
    mov     byte ptr [edi],al   ;Copy it across
    inc     esi					;ESI = ready for next byte
    inc     edi					;EDI = ready for next byte
	loop    again				;Repeat CX times
      
done:
       
;****************************************************
;    copy one string to another using lodsb and stosb
;        (use lodsw and ax for words)
;        (use lodsd and eax for dwords)
;
; lodsb - copy from byte ptr [esi] to AL 
;       - automatically increment esi if direction flag cleared (cld) 
;       - automatically decrement esi if direction flag set (std)
; stosb - copy from AL to byte ptr [edi] 
;       - automatically increment edi if direction flag cleared (cld) 
;       - automatically decrement edi if direction flag set (std)
;****************************************************

    ;source2 - "assembly is fun"
    ;dest2 - uninitialized

	lea	    esi, source2	    ;ESI = source
	lea	    edi, dest2	        ;EDI = destination
	mov	    ecx,SOURCE2_LEN     ;ECX = loop count
	cld				            ;DIRECTION = forward(INC ESI/EDI)
	jecxz   done2               ;  jump if ecx = 0, oops, nothing to copy
	
again2:	
	lodsb			            ;AL = byte ptr [esi]
	stosb			            ;byte ptr [edi] = AL , copy it
	loop	again2		        ;Repeat CX times
	
done2: 	
    
;****************************************************
;    copy one string to another using movsb and rep
;        (use movsw for copying words)
;        (use movsd for copying dwords)
;
; movsb - copy from byte ptr [esi] to byte ptr [edi] 
;       - automatically increment esi and edi if direction flag cleared (cld) 
;       - automatically decrement esi and edi if direction flag set (std)
; rep - repeat string instruction ecx number of times
;****************************************************

    ;source3 - "assemblers like to mov things"
    ;dest3 - uninitialized

    lea     esi, source3        ;ESI = source
	lea     edi, dest3	        ;EDI = destination
	mov     ecx,SOURCE3_LEN	    ;ECX = loop count - num of entries to copy

    cld                         ;forward direction
	rep     movsb               ;execute movsb ecx number of times
	
;*****************************************************************
;    compare 2 dword arrays using a regular loop

    ;array1 10,25,30,40,50
    ;array2 10,25,30,40,50

	lea     esi, array1	        ;source
	lea     edi, array2         ;destination
	mov     ecx,ARRAY1_LEN	    ;ecx = loop count
	jecxz   done3               ;jump if ecx = 0, oops, nothing to compare
						        ;DIRECTION = forward(INC ESI/EDI)

again3:	
	mov     eax,dword ptr [edi]	;EAX = next dword
    cmp     dword ptr [esi],eax ;compare 2 dwords
    jne     notSame             ;if dwords are not the same, done 
    add     esi,4               ;advance ESI to next dword
    add     edi,4               ;advance EDI to next dword
	loop    again3	            ;Repeat ECX times

    mov     eax,10              ;arrays are the same if loop exits without jump
    jmp     done3               ;skip different
notSame:
	mov     eax,5               ;else arrays are different

done3:
    
       
;*****************************************************************
;compare 2 dword arrays using cmpsd and repe (repeat while equal)
;        (use cmpsb for comparing 2 byte arrays)
;        (use cmpsw for comparing 2 word arrays)
;
;      cmpsd - compare a dword in a memory block pointed to by esi 
;              to a dword in a memory block pointed to by edi. 
;               cmpsd sets flags like cmp.
;       - automatically increment esi and edi if direction flag cleared (cld) 
;       - automatically decrement esi and edi if direction flag set (std)
;
;      repe  - repeat scan ecx number of times as long as elements are equal 
;      repne - repeat scan ecx number of times as long as elements are not equal(not used below)
;
;      Note: for cmpsb etc the meaning of source and destination is reversed from cmp destination,source
;            for cmpsb etc the comparison is cmpsb source,destination

    ;compare 2 arrays that are the same
    ;ecx       4  3  2  1  0 (value of ecx after comparison)
    ;array1 - 10,25,30,40,50  
    ;array2 - 10,25,30,40,50  

	lea     esi, array1		    ;ESI = source
	lea     edi, array2	        ;EDI = destination
	mov     ecx,ARRAY1_LEN	    ;ECX = loop count = length of shortest array
    cld                         ;forward direction
	repe    cmpsd	            ;repeat compare as long as elements are the same
                                ;and ecx > 0 
	
	je      same5               ;if jump taken, arrays are the same
    ja      above5              ;if jump taken, source > destination
	mov     eax,5               ;source < destination
    jmp     done5               ;skip same
same5:
    mov     eax,25              ;arrays are the same
    jmp     done5               ;skip above
above5:
    mov     eax,30              ;source > destination
done5:

    ;compare 2 arrays that are different
    ;ecx       4  3  2       (value of ecx after comparison)
    ;array1 - 10,25,30,40,50  
    ;array3 - 10,25,35,40,50  
    
	lea     esi, array1		    ;ESI = source
	lea     edi, array3	        ;EDI = destination
	mov     ecx,ARRAY1_LEN	    ;ECX = loop count = length of shortest array
	cld                         ;forward direction
	repe    cmpsd	            ;repeat compare as long as elements are the same
                                ;and ecx > 0
	
	je      same6               ;if jump taken, arrays are the same
    ja      above6              ;if jump taken, source > destination
	mov     eax,8               ;source < destination
    jmp     done6               ;skip same

same6:
    mov     eax, 35             ;arrays are the same
    jmp     done6               ;skip above
above6:
    mov     eax, 18             ;source > destination

done6:

;*****************************************************************
;search dword array for a particular value using scasd and repne(repeat while not equal)
;(use scasb and al for searching a byte array)
;(use scasw and ax for searching a word array)

;      scasd - compare a dword in a memory block pointed to by edi 
;              to EAX - sets flags like cmp
;       - automatically increment edi if direction flag cleared (cld) 
;       - automatically decrement edi if direction flag set (std)
;          
;      repne - repeat scan ecx number of times as long as elements are not equal
;      repe  - repeat scan ecx number of times as long as elements are equal (not used below)

;     ecx   4  3  2
;   array2 10,25,30,40,50

	lea     edi, array2	        ;EDI = destination (array to search)
	mov     eax,30			    ;element to search for   
	mov     ecx,ARRAY2_LEN	    ;ECX = loop count = array length
	cld					        ;scan in forward direction
	repne   scasd			    ;repeat scan until element found or until ECX == 0
						        ;whichever comes first
	je      found			    ;take jump if element found
	mov     eax,5			    ;element not found
    jmp     done7               ;skip found
	
found:
    mov     eax, 42             ;element found

done7:

    call	ReadChar		    ;pause execution
	INVOKE	ExitProcess,0	    ;exit to dos

	ret
	
main endp

END main
