;example of a function using registers to pass in arguments

.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;*************************PROTOTYPES*****************************
ReadChar PROTO						;Irvine code for getting a single char from keyboard
									;Character is stored in the al register.
									;Can be used to pause program execution until key is hit.

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

;************************DATA SEGMENT***************************

.data

;************************CODE SEGMENT****************************

.code

main proc

    mov     eax, 12h        ;ebx = 12h
    mov     ebx, 102h       ;eax = 102h
    mov     ecx, 15h        ;edx = 15h
    call	Add3	        ;add 3 operands

	call    ReadChar		;pause execution
	INVOKE	ExitProcess,0   ;exit to dos: like C++ exit(0)

main endp


;************** add3 - unsigned dword addition - add 3 integers
;
;       ENTRY – eax = operand1, ebx = operand2, ecx = operand3
;                         
;       EXIT  - EAX = result  (operand 1 + operand 2 + operand 3) 
;                     (any carry is ignored so the answer must fit in 32 bits)
;       REGS  - EAX,FLAGS
;
;       note: - Before calling doAdd populate eax with operand 1, ebx with op2 and ecx with op3
;

Add3 proc

	add	    eax,ebx		    ;eax = operand1 (eax) + operand2 (ebx)
	add     eax,ecx		    ;eax = eax (operand1 + operand2) + operand 3

	ret                     ;pop return address off stack and put into eip register

Add3 endp
END main