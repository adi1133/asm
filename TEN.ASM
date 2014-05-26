.model small 
.stack 10 
.data 
	mesaj db 'Hello, world!', 0Dh, 0Ah, '$'
.code 



start:
	mov ax, @data 
	mov ds, ax 
	
	mov cx, 10h

lol:		
	call main
	loop lol

	mov ax, 4c00h 
	int 21h

main:
	push bp
	mov bp, sp

	mov dx, offset mesaj
	mov ah, 9 
	int 21h 

	pop bp
	ret

end start


