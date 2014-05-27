.model small 
.stack 10
.code 



start:
	call main

	mov ax, 4c00h 
	int 21h

main:

	mov BYTE PTR dl, 'a'
	
	;mov cx, 10h
next:
	call putc
	inc dl
	cmp dl, 'z'
	jle next
	ret 

putc:
	mov ah, 2 
	int 21h
	ret
	

end start


