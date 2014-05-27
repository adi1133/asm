.model small 
.stack 10 
;.data 
;	mesaj db 'Hello, world!', 0Dh, 0Ah, '$'
.code 



start:
	;mov ax, @data 
	;mov ds, ax 
	
	

	
	call main

	mov ax, 4c00h 
	int 21h

main:
	push bp
	mov bp, sp

	dec sp
	mov BYTE PTR bp[-1], 'a'
	
	;mov cx, 10h
next:
	call putc
	inc BYTE PTR bp[-1]

	cmp BYTE PTR bp[-1], 'z'

	jle next
	
	inc sp
	
	
	pop bp
	ret 

putc:
	mov dl, bp[-1]
	mov ah, 2 
	int 21h
	ret
	

end start


