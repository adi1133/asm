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

	
	

	;mov byte ptr [sp], 1
	
	call main
	loop lol

	mov ax, 4c00h 
	int 21h

main:
	push bp
	mov bp, sp

	push 'x'
	mov dl, bp[-2]
	mov ah, 2 
	int 21h 
	
	inc sp
	inc sp
	;add sp, 2
	
	
	pop bp
	ret 

end start


