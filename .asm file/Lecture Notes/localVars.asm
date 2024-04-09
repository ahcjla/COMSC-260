;Examples of allocating memory for a local variable in a procedure
;
; To allocate memory for a local variable in a function the following setup 
; and cleanup code is required at the top and bottom of your function.
;
; LocalVars  PROC
;**********required code at top**********
;       push	ebp	               
;	    mov	    ebp,esp	     
;       sub     esp, 4              ;allocate memory for local dword
;
;       add code to save registers if any used by function by pushing them onto stack
;       except do not save a register that returns a value to the caller
;
;**********end required code at top of function
;
; main part of function that processes data
;
;**********required code at bottom of function**********
;
;   add code to restore registers if any that were saved at the top 
;   except ebp which is restored below (use pop to restore)
;
;    mov     esp, ebp            ;deallocate memory for local variable by restoring esp
;    pop     ebp                 ;restore ebp
;	 ret                        
;LocalVars ENDP


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
       
    mov     ebp,0aaaabbbbh                  ;EBP = some junk for the demo
    mov     ecx,0ddddeeeeh                  ;ECX = some junk for the demo
    mov     eax,0ffffffffh                  ;EAX = some junk for the demo
    push    26h		                        ;copy parameter to stack: 00000026h
    call	LocalVars                       ;return address pushed on the stack
    add	    esp,4	                        ;remove one dword from the stack
                                            ;if you use ret 4 in function then
                                            ;this line is not needed

    mov     ebp,011115555h	                ;EBP = some junk for the demo
    mov     ecx,02222cccch                  ;ECX = some junk for the demo
    mov     eax,03333ddddh                  ;EAX = some junk for the demo

    push    16h		                        ;copy parm1 to stack: 00000016h

    call	LocalVarsB                      ;return address pushed on the stack

    add	    esp,4	                        ;remove one dword from the stack
                                            ;if you use ret 4 in function then
                                            ;this line is not needed


	call	ReadChar		                ;pause execution
	INVOKE	ExitProcess,0	                ;exit to dos

main ENDP

;******************** LocalVars – local var example
;           ENTRY – dword parameter on stack
;           EXIT  - None
;           REGS  - EAX,ECX

LocalVars  PROC

;-------------------  Stack usage

        ;The stack looks like the following in relation to ebp

        ;orig eax  [ebp - 12]   ffffffffh after push eax
        ;orig ecx  [ebp - 8]    ddddeeeeh after push ecx
        ;                       abcdef89h stored in local var after mov                                
        ;local var [ebp - 4]    after sub esp, 4
        ;orig ebp  [ebp + 0]    aaaabbbbh after push ebp
        ;ret addr  [ebp + 4]    
        ;parm1     [ebp + 8]    00000026h




;in order to keep track of the correct adjustments for the addresses of the 
;parameters and local variables on the stack always do the following
;3 instructions in the following order: 
;push ebp; mov ebp,esp; sub esp, ? (only needed to a allocate mem for local var)


    push	ebp	                            ;Save original value of EBP on stack
	mov	    ebp,esp	                        ;EBP= address of original EBP on stack
			                                ; Aim at a fixed location on the stack so
			                                ;   we can access other stack locations
                                            ;   relative to this location!
    sub     esp, 4                          ;allocate memory for local dword
    push    ecx                             ;save ecx
    push    eax                             ;save eax

    ;brackets [ ] below are needed to dereference the address
    ;this is like *ptr in C++

    mov     dword ptr [ebp - 4],0abcdef89h  ;put abcdef89h in local variable
    mov     eax, [ebp - 4]                  ;mov local variable to eax for viewing

    mov     ecx, [ebp + 8]                  ;put parameter in ecx

    ;add code to perform operations on data...

    pop     eax                             ;restore eax
    pop     ecx                             ;restore ecx
    mov     esp, ebp                        ;deallocate memory for local variable by restoring esp
	pop     ebp                             ;restore ebp
	ret                        

LocalVars ENDP

;******************** LocalVars – local var example
;           ENTRY – dword parameter on stack
;           EXIT  - None
;           REGS  - EAX,ECX

;create user friendly constants to access parameter and local var on stack

$parm       EQU    DWORD PTR [ebp + 8]      ;parameter
$localVar   EQU    DWORD PTR [ebp - 4]      ;local variable

LocalVarsB  PROC

;-------------------  Stack usage
    ;The stack looks like the following in relation to ebp

        ;orig eax  [ebp - 12]   3333ddddh after push eax
        ;orig ecx  [ebp - 8]    2222cccch after push ecx
        ;                       12345678h stored in local var after mov 
        ;local var [ebp - 4]    after sub esp, 4
        ;orig ebp  [ebp + 0]    11115555h after push ebp
        ;ret addr  [ebp + 4]    
        ;parm1     [ebp + 8]    00000016h




;in order to keep track of the correct adjustments for the addresses of the 
;parameters and local variables on the stack always do the following
;4 instructions in the following order: 
;push ebp; mov ebp,esp; sub esp, ? (only needed to a allocate mem for local var),save registers used in proc


    push	ebp	                            ;Save original value of EBP on stack
	mov	    ebp,esp	                        ;EBP= address of original EBP on stack
			                                ; Aim at a fixed location on the stack so
			                                ;   we can access other stack locations
                                            ;   relative to this location!
    sub     esp, 4                          ;allocate memory for local dword
    push    ecx                             ;save ecx before using in procedure
    push    eax                             ;save eax before using in procedure
    
    ;to avoid problems and to avoid points off the above code should always be in the above order

    ;brackets [ ] below are needed to dereference the address
    ;this is like *ptr in C++

    mov     $localVar,12345678h             ;put 12345678h in local variable
    mov     eax, $localVar                  ;mov localVar to eax for viewing
    mov     ecx, $parm                      ;put parameter in ecx

    ;add code to perform operations on data...

    ;to avoid problems and to avoid points off the code below should always be in the following order:
    ;restore registers saved (if any), mov esp, ebp, pop ebp

    pop     eax                             ;restore eax
    pop     ecx                             ;restore ecx
    mov     esp, ebp                        ;deallocate memory for local variable by restoring esp
	pop     ebp                             ;restore ebp
	ret    

LocalVarsB ENDP

END main