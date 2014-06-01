.model small 
.stack 20
.data 
    lfcr db 0Dh,0Ah, '$'
    seed_me db "Mash random keys and then press enter$"
    guess_me db "Guess the number!$"
    less_guess db "The number is too small!$"
    more_guess db "The number is too big!$"
    win_1 db "You win using $"
    win_2 db " guess(es)!$"

.code 


start:
    mov ax, @data   ;data segment init
    mov ds, ax
    call main       ;game function

    mov ax, 4c00h   ;dos return 0
    int 21h

main:
    push bp         ;create stack frame
    mov bp, sp
    push 0          ;push no of tries to stack
    
    mov dx, offset seed_me;print seed disclaimer
    call puts
    call rand       ;generate random number
    mov bx, ax      ;save random number in safe reg

    call endl       ;print newline
    mov dx, offset guess_me;print game disclaimer
    call puts

main_loop:
    
    inc bp[-2]      ;increment no of tries
    call endl
    call read       ;read a dec number from kb to ax
    cmp ax,bx       ;check game conditions
    jl main_less
    jg main_greater
    je main_win

main_less:
    mov dx, offset less_guess
    call puts
    jmp main_loop
main_greater:
    mov dx, offset more_guess
    call puts
    jmp main_loop
main_win:
    mov dx, offset win_1
    call puts
    pop ax      ;pop number of tries into ax
    call dec    ;print no of tries on screen
    mov dx, offset win_2
    call puts
    call endl
    pop bp      ;destroy stack frame
    ret



;generates random 1 byte no
;returns using ax
rand: 
    mov ah, 08h ;dos call stdin no echo
    ;mov cl, 0  ;accumulate result into cl
rand_loop:
    int 21h     ;read char into al
    xor cl, al  ;mix al into cl
    rol cl, cl  ;w00t ?
    cmp al, 0Dh ;check for return key
    jne rand_loop

    mov ah, 0   ;place result into ax
    mov al, cl
    ret

;reads unsigned int numbers from kb as decimal
;can read a 2 byte number
;range 0 to 2^16 -1
read:
    push bp     ;init stack frame
    mov bp, sp
    push 0      ;push 0 to accumulate result

    mov ch, 0   ;pad cl for casting
    

read_loop:

    mov ah, 01h ;dos stdin with echo
    int 21h;
    cmp al, 0Dh ;check for return key
    je read_done

    cmp al, '0' ;check for valid digit
    jl read_loop
    cmp al, '9'
    jg read_loop

    sub al, '0' ;get digit as int
    mov cl, al  ;save digit in cl
    mov ax, bp[-2];load number read so far
    mov dx, 10  ;make room for extra digit
    mul dx
    add ax, cx  ;add extra digit

    mov bp[-2], ax; save number in ram

    jmp read_loop

read_done:
    pop ax      ;pop number from ram into ax
    pop bp      ;destroy stack frame
    ret

;prints unsigned int numbers from ax as decimal
;prints up to 2 bytes
;range 0 to 2^16 -1

dec:
    mov cx, 0   ;store no of digits

dec_inner:      ;used to consume digits R to L
    mov dx, 0   ;will have modulus result
    mov bx, 10  ;number to divide to
    div bx      ;ax = [dx:ax]/[bx]

    push dx;    ;append digit to stack
    inc cx;     ;incr digit count
    cmp ax, 0   ;check if number is consumed
    jne dec_inner

dec_print:      ;used to reverse the digits
    pop dx      ;pop digit into dx
    mov dh, 0   ;pad with 0
    add dl, '0' ;convert to char
    call putc   ;print char
    loop dec_print

    ret

puts:           ;dos string stdout
    mov ah, 9   ;needs offset loaded into dx
    int 21h 
    ret


putc:           ;dos print char
    mov ah, 2   ;needs char loaded into dl
    int 21h
    ret

endl:           ;print newline
    mov dx, offset lfcr
    call puts
    ret

end start