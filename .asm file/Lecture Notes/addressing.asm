;Examples of addressing memory - 
;

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
        num1     dword      10              ;data for example below
        num2     dword      20              ;data for example below
     
           ;offset         0 4 8 12 16 20
        numArray dword     5,3,2, 4,10, 9   ;array for example below

;In the debugger memory address window the above might look like:
;(when you run the program the actual memory addresses would be different)

;0x00D76000  0a 00 00 00  ....
;0x00D76004  14 00 00 00  ....
;0x00D76008  05 00 00 00  ....
;0x00D7600C  03 00 00 00  ....
;0x00D76010  02 00 00 00  ....
;0x00D76014  04 00 00 00  ....
;0x00D76018  0a 00 00 00  ....
;0x00D7601C  09 00 00 00  ....


;************************CODE SEGMENT****************************

.code

main PROC

     ;direct addressing - offset of operand's address is stored directly in the instruction
     mov    eax, num1                       ;address of num1 is stored in instruction
                                            ;copy what is at that address into eax
     mov    eax, [num1]                     ;address of num1 is stored in instruction
                                            ;copy what is at that address into eax
                        
     ;a constant can be added or subtracted from the 
     ;label to form a direct address

     mov    eax, num1 + 4                   ;add 4 bytes to the addess of num1
                                            ;which is the address of num2.
                                            ;Copy the contents of what is at that
                                            ;address to eax
                                            ;(does not add the contents of num1 + 4)
    
     mov    eax, num2 - 4                   ;subtract 4 bytes from the addess of num2
                                            ;which is the address of num1.
                                            ;Copy the contents of what is at that
                                            ;address to eax
                                            ;(does not subtract the contents of num2 - 4)
                          
    ;indirect addressing - offset gotten indirectly from a register encoded
    ;in the instruction

     mov    ebx, offset num2                ;ebx has offset of num2
     mov    eax,[ebx]                       ;copies the contents of the dword found at
                                            ;the address contained in ebx to eax
     ;the following is not indirect addressing
                             
     mov    eax,ebx                         ;copy the contents of ebx to eax
                                            ;eax now holds the address of num2
                        
    ;indexed addressing - like indirect addressing except an offset
    ;is also used
    ;

    ;[register + label]
    
     mov    edx,8                           ;offset of 3rd element of word array
     mov    eax,[edx + numArray]            ;copy the 3rd element of numArray to eax
                                            ;whose address is the address of numArray + 8
     
     ;[label + register]

     mov    ecx,4                           ;offset of 2nd element of word array
     mov    eax,[numArray + ecx ]           ;copy the 2nd element of numArray to eax
                                            ;whose address is the address of numArray + 4
     

     ;[register] + label

     mov    edi,12                          ;offset of 4th element of dword array
     mov    eax,[edi] + numArray            ;copy the 4th element of dword array into eax
     ;mov     eax , edi + numArray          ;illegal 
     ;label + [register] 

     mov    esi,16                          ;offset of 5th element of word array
     mov    eax,numArray + [esi]            ;copy [numArray + 16]: 10
     
     ;label[register]

     mov    ebx, 4                          ;ebx = 4
     mov    eax, numArray[ebx]              ;looks like a 1 dim array except ebx contains
                                            ;an offset which is the number of
                                            ;bytes from the beginning of numArray.

    ;label[register][register]
    mov     ebx,4                           ;ebx has offset
    mov     esi,12                          ;esi has offset
    mov     eax, numArray[ebx][esi]         ;copy the value whose address is 
                                            ;the offset of numArray + ebx (4) +  esi (12)
                                            ;looks like a 2 dimensional array except ebx
                                            ;and esi contain offsets that when added together
                                            ;give the offset from the beginning of the numArray

     ;please note that no example is given for EBP because EBP normally
     ;is reserved for accessing data on the stack 
     
    ;some other combinations for indexed addressing

    mov     ebx,offset numArray             ;ebx has address of numArray
    mov     esi,4                           ;esi has displacement
    mov     eax,[ebx + esi]                 ;copy the value whose address is 
                                            ;ebx(address of numArray) + the displacement in esi (4) 
    mov     eax, [ebx + esi + 4]            ;copy the value whose address is 
                                            ;ebx(address of numArray) +  esi (4) + 4 
     
    ;the following is illegal since memory to memory copies are not allowed                                
    ;mov     dword ptr [ebx + esi + 8], dword ptr [ebx + esi + 4]    ;try to copy mem to mem but illegal  

    ;        offset         0 4 8 12 16 20
    ;    numArray dword     5,3,2, 4,10, 9  ;array for example below
                             
    mov     eax, dword ptr [ebx + esi + 4]  ;solution: copy from memory to a register: copy what is at offset 8: 2
    mov     dword ptr[ebx + esi + 8], eax  ;then copy from the register to memory: overwrite what is at offset 12: 4 becomes 2
                           
    mov     eax, 4[esi + ebx]               ;same as mov eax,[esi + ebx + 4]
    
    ;mov eax, ebx + esi + 2                 ;compile error - invalid use of register 
    ;mov eax, numArray + esi                ;cannot add to contents of register this way   

    call	ReadChar		                ;pause execution
	INVOKE	ExitProcess,0	                ;exit to dos

main ENDP
END main