; *************************************************************
; Student Name: Aurelia Kisanaga
; COMSC-260 Fall 2021
; Date: 1 September 2021
; Assignment #1
; Version of Visual Studio used (2015)(2017)(2019): 2019
; Did program compile? Yes
; Did program produce correct results? Yes
; Is code formatted correctly including indentation, spacing and vertical alignment? Yes
; Is every line of code commented? Yes
;
; Estimate of time in hours to complete assignment: 4 hours
;
; In a few words describe the main challenge in writing this program:
; the calculations for registers are quite confusing at first
;
; Short description of what program does:
; Calculating the eax register from a given formula
;
; *************************************************************
; Reminder: each assignment should be the result of your
; individual effort with no collaboration with other students.
;
; Reminder: every line of code must be commented and formatted
; per the ProgramExpectations.pdf file on the class web site
; *************************************************************


.386                   ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs


.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;*************************PROTOTYPES*****************************

ExitProcess PROTO, dwExitCode:DWORD ;from Win32 api not Irvine

ReadChar PROTO                      ;Irvine code for getting a single char from keyboard
				                    ;Character is stored in the al register.
			                        ;Can be used to pause program execution until key is hit.


WriteHex PROTO                      ;Irvine function to write a hex number in EAX to the console


;************************DATA SEGMENT***************************

.data

    num1    word   0FEEDh      ;initialize num1 = 0000FEEDh
    num2    word   0DEEDh      ;initialize num2 = 0000DEEDh

;************************CODE SEGMENT****************************

.code

main PROC
    
    ;initializing registers 
    mov     ebx, 0BBBBFFFFh    ;ebx = 0BBBBFFFFh
    mov     eax, 0AAAAFFFFh    ;eax = 0AAAAFFFFh
    mov     ecx, 0E4C7FFFDh    ;ecx = 0E4C7FFFDh
    mov     edx, 0FFFFFFFFh    ;edx = 0FFFFFFFFh
    mov     bl,  11111010b     ;bl = 11111010b = FAh = 250 (base 10)
    mov     bh,  249d          ;bh = 249d = F9h = 11111001b
    mov     dx,  0FFD8h        ;dx = FFD8h
    


    ;eax = num1 - num2 - bl + bh + ecx - dx
    movzx   eax, num1          ;copy num1 to ax and zero all upper part. eax = 0000FEEDh
    movzx   esi, num2          ;copy num2 to si and zero all upper part. esi = 0000DEEDh
    sub     eax, esi           ;eax = eax - esi = 00002000h
    movzx   esi, bl            ;copy bl to si and zero all upper part. esi = 000000FAh
    sub     eax, esi           ;eax = eax - esi = 00001F06h
    movzx   ebx, bh            ;copy bh to bl and zero all upper part. ebx = 000000F9h
    add     eax, ebx           ;eax = eax + ebx = 00001FFFh
    add     eax, ecx           ;eax = eax + ecx = E4C81FFCh
    movzx   edx, dx            ;copy dx to edx and zero all upper part. edx = 0000FFD8h
    sub     eax, edx           ;eax = eax - edx = E4C72024h


    call    WriteHex           ;printing the result output to console program

    call    ReadChar           ;Pause program execution while user inputs a non-displayed char
    INVOKE	ExitProcess,0      ;exit to dos: like C++ exit(0)

main ENDP
END main