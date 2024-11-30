
[BITS 16]       
[ORG 0x7C00]        

start:
    mov ax, 0x0000  
    mov ds, ax

    mov ah, 0x02    
    mov al, 1        
    mov ch, 0      
    mov cl, 2     
    mov dh, 0      
    mov bx, 0x1000
    int 0x13        

    jmp 0x1000    

times 510 - ($ - $$) db 0 
dw 0xAA55               
