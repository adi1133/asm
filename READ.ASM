.model small 
.stack 10
.data 
	mesaj db 0Dh,0Ah, '$'
.code 


start:
	call main

	mov ax, 4c00h 
	int 21h

main:
	push bp
	mov bp, sp
	

	call read
	mov cx, ax
	call endl
	mov ax, cx
	;mov ax, 123
	call dec
	call endl
	
	pop bp
	

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

putc:
	mov ah, 2 
	int 21h
	ret

endl:
	mov ax, @data 
	mov ds, ax 
	mov dx, offset mesaj
	mov ah, 9 
	int 21h 
	ret
	
putspc:
	mov dl, ' '
	call putc
	ret
	

end start


