.model small 
.stack 10
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
	mov ax, @data 
	mov ds, ax 
	call main

	mov ax, 4c00h 
	int 21h

main:
	push bp
	mov bp, sp
	push 0
	
	mov dx, offset seed_me
	call puts
	call rand
	mov bx, ax

	call endl
	mov dx, offset guess_me
	call puts

main_loop:	
	
	inc bp[-2]
	call endl
	call read
	cmp ax,bx
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
	pop ax
	call dec
	mov dx, offset win_2
	call puts
	call endl
	

	pop bp
	

	ret 


rand: 
	mov ah, 08h
	mov cl, 0
rand_loop:
	int 21h
	xor cl, al
	rol cl, cl ;w00t ?
	cmp al, 0Dh
	jne rand_loop

	mov ah, 0
	mov al, cl
	ret


read:
	push bp
	mov bp, sp
	push 0

	mov ch, 0
;acd
	
	

read_loop:

	mov ah, 01h
	int 21h;
	cmp al, 0Dh
	je read_done

	cmp al, '0'
	jl read_loop
	cmp al, '9'
	jg read_loop

	sub al, '0'
	mov cl, al
	mov ax, bp[-2]
	mov dx, 10
	mul dx
	add ax, cx

	mov bp[-2], ax




	jmp read_loop

read_done:
	pop ax
	pop bp
	ret


dec:
	mov cx, 0
dec_inner:

	mov dx, 0 ; dx has mod result
	mov bx, 10
	div bx

	push dx;
	inc cx;
	cmp ax, 0
	jne dec_inner

dec_print:
	pop dx
	mov dh, 0
	add dl, '0'
	call putc
	loop dec_print
	

	ret;

puts:
	mov ah, 9 
	int 21h 
	ret


putc:
	mov ah, 2 
	int 21h
	ret

endl:		
	mov dx, offset lfcr
	call puts
	ret
	
putspc:
	mov dl, ' '
	call putc
	ret
	

end start


