; *************************************************************
; Student Name: Aurelia Kisanaga
; COMSC-260 Fall 2021
; Date: 13 September 2021
; Assignment #2
; Version of Visual Studio used (2015)(2017)(2019): 2019
; Did program compile? Yes
; Did program produce correct results? Yes
; Is code formatted correctly including indentation, spacing and vertical alignment? Yes
; Is every line of code commented? Yes
;
; Estimate of time in hours to complete assignment: 1 hour 
;
; In a few words describe the main challenge in writing this program: efficiency is difficult
;
; Short description of what program does:
; Output with given message and calculate the equation to be output to console
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

WriteHex PROTO         ;write the number stored in eax to the console as a hex number
                       ;before calling WriteHex put the number to write into eax

WriteString PROTO      ; write null-terminated string to console
                       ; edx contains the address of the string to write
                       ; before calling WriteString put the address of the string to write into edx
                       ; e.g. mov edx, offset message address of message is copied to edx

ExitProcess PROTO,dwExitCode:DWORD          ; exit to the operating system

ReadChar PROTO         ;Irvine code for getting a single char from keyboard
                       ;Character is stored in the al register.
                       ;Can be used to pause program execution until key is hit.

WriteChar PROTO        ;Irvine code for printing a single char to the console.
                       ;Character to be printed must be in the al register.


;************************ Constants ***************************

    LF       equ     0Ah                   ; ASCII Line Feed

;************************DATA SEGMENT***************************

.data

    num1            dword       0B7FB84h               ;initialize num1 = 0B7FB84h
    num2            dword       157h                   ;initialize num2 = 157h
    num3            dword       0ADC1547h              ;initialize num2 = 0ADC1547h
    num4            dword       17A25A9h               ;initialize num1 = 17A25A9h
    num5            dword       0B461ACBh              ;initialize num2 = 0B461ACBh
    num6            dword       0D2494h                ;initialize num1 = 0D2494h
    num7            dword       514AB2h                ;initialize num2 = 514AB2h

    progName        byte        "Program 2 by Aurelia Kisanaga",LF,LF,0         ; program number and name of author
    expression      byte        "num1+num2*(num3%num4)-num5/num6-num7=",0       ; equation expression
    exitMessage     byte        'h',LF,LF,"Hit any key to exit!",0              ;'h' is to be placed before the exit message but after the heaxdecimal value

;************************CODE SEGMENT****************************

.code

main PROC

;************************CALCULATION****************************

    ;num1+num2*(num3%num4)-num5/num6-num7

    ; (num3%num4)
    mov     eax, num3                   ;eax = 0ADC1547h
    mov     ebx, num4                   ;ebx = 17A25A9h
    mov     edx, 0                      ;edx = 00000000h
    div     ebx                         ;eax = 00000007h, edx = 00850DA8h
    
    ; num2*(num3%num4)
    mov     eax, num2                   ;eax = 00000157h
    mov     ecx, edx                    ;ecx = 00850DA8h
    mul     ecx                         ;eax = B2454C18h
    mov     edi, eax                    ;edi = B2454C18h

    ; num5/num6
    mov     eax, num5                   ;eax = 0B461ACBh
    mov     edx, 0                      ;edx = 00000000h
    mov     ecx, num6                   ;ecx = 0D2494h
    div     ecx                         ;eax = 000000DBh, edx = 0007D02F 

    ; num1+num2*(num3%num4)
    add     edi, num1                   ;edi = B2454C18h + 0B7FB84h = B2FD479Ch

    ; num1+num2*(num3%num4)-num5/num6
    sub     edi, eax                    ;edi = B2FD479Ch + 000000DBh = B2FD46C1h

    ; num1+num2*(num3%num4)-num5/num6-num7
    sub     edi, num7                   ;edi = B2FD46C1h + 514AB2h = B2ABFC0Fh
    mov     eax, edi                    ;copy register edi to register eax = B2ABFC0Fh



;************************OUTPUT TO CONSOLE****************************

    ; print program number and name
    mov     edx, offset progName        ;edx = address of zero termined string
    call    WriteString                 ;print string to console

    ; print the expression
    mov     edx, offset expression      ;edx = address of zero termined string
    call    WriteString                 ;print string to console

    ; print the output after the expression
    call    WriteHex                    ;print hexadecimal value of eax to console
    
    ; print the exit message
    mov     edx, offset exitMessage     ;edx = address of zero termined string
    call    WriteString                 ;print string to console


    call    ReadChar                    ;Pause program execution while user inputs a non-displayed char
    INVOKE	ExitProcess,0               ;exit to dos: like C++ exit(0)

main ENDP
END main