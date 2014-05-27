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
	mov bp, sp;
	push 123;
	call dec;
	add sp, 2;

	call endl
	mov cx, 100
loop:
	push cx
	call dec
	call putspc
	add sp, 2
	
	loop loop

	
	pop bp
	

	ret 
dec:
	mov ax, WORD PTR bp[-2]
	mov dx, 0 ; dx has mod result
	mov bx, 10
	div bx
	mov WORD PTR bp[-2], ax

	
	add dl, '0'
	call putc
	cmp WORD PTR bp[-2], 0
	jne dec

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


