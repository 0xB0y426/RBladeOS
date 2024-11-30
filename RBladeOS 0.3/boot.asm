[BITS 16]
[ORG 0x7C00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax

    call set_video_mode

    mov bl, 0x01
    mov cx, 2000
    mov di, 0xB800
    rep stosw

    mov si, message
    mov di, 0xB800
    call print_string

    mov ah, 0x00
    int 0x16

    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, 0x1000
    int 0x13

    jmp 0x1000

set_video_mode:
    mov ax, 0x03
    int 0x10
    mov ah, 0x0B
    mov bh, 0x00
    mov bl, 0x01
    int 0x10
    ret

print_string:
    mov ah, 0x0E
.print_char:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .print_char
.done:
    ret

message db "                      Bootloader RBladeOS 0.3", 13, 10
        db "Thank you for booting and choosing RBladeOS! Press any key to continue.", 0

times 510 - ($ - $$) db 0
dw 0xAA55
