[BITS 16]
[ORG 0x1000]

start:
    cli
    call set_video_mode
    call print_interface
    call print_newline
    call shell
    jmp $

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
    mov bh, 0x00
    mov bl, 0x1F
.next_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next_char
.done:
    ret

print_newline:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

print_interface:
    mov si, header
    call print_string
    call print_newline
    mov si, menu
    call print_string
    call print_newline
    ret

shell:
    mov si, prompt
    call print_string
    call read_command
    call print_newline
    call execute_command
    jmp shell

read_command:
    mov di, command_buffer
    xor cx, cx
.read_loop:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D
    je .done_read
    cmp al, 0x08
    je .handle_backspace
    cmp cx, 150
    jge .done_read
    stosb
    mov ah, 0x0E
    mov bl, 0x1F
    int 0x10
    inc cx
    jmp .read_loop

.handle_backspace:
    cmp di, command_buffer
    je .read_loop
    dec di
    dec cx
    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .read_loop

.done_read:
    mov byte [di], 0
    ret

execute_command:
    mov si, command_buffer
    cmp byte [si], 'P'
    je check_print
    cmp byte [si], 'C'
    je check_cls
    cmp byte [si], 'R'
    je check_reboot
    cmp byte [si], 'S'
    je check_shutdown
    cmp byte [si], 'L'
    je check_loop
    cmp byte [si], 'N'
    je check_nop
    cmp byte [si], 'B'  
    je check_banner
    call unknown_command
    ret

check_banner:
    call do_banner
    ret  

do_banner:
    call print_interface
    call print_newline
    ret

check_nop:
    call nop_command
    jmp shell

nop_command:
.loop_nop:
    mov ah, 0x01
    int 0x16
    jz .continue_nop
    mov ah, 0x00
    int 0x16
    cmp al, 'q'
    je .done_nop
.continue_nop:
    jmp .loop_nop
.done_nop:
    ret

check_print:
    cmp byte [si + 1], 'R'
    je do_print
    call unknown_command
    ret

do_print:
    mov si, command_buffer + 5
    call print_string
    call print_newline
    ret

do_reboot:
    db 0x0EA
    dw 0x0000
    dw 0xFFFF

do_shutdown:
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15
    ret

do_cls:
    mov cx, 25
.clear_loop:
    call print_newline
    loop .clear_loop
    ret

check_cls:
    cmp byte [si + 1], 'L'
    je do_cls
    call unknown_command
    ret

check_reboot:
    cmp byte [si + 1], 'E'
    je do_reboot
    call unknown_command
    ret

check_shutdown:
    cmp byte [si + 1], 'H'
    je do_shutdown
    call unknown_command
    ret

check_loop:
    cmp byte [si + 1], 'O'
    je do_loop
    call unknown_command
    ret

do_loop:
    mov si, command_buffer + 6
    cmp byte [si], 0
    je .done
.loop:
    mov ah, 0x01
    int 0x16
    jz .continue_loop
    mov ah, 0x00
    int 0x16
    cmp al, 'q'
    je .done
.continue_loop:
    push si
    call print_string
    call print_newline
    pop si
    jmp .loop
.done:
    ret

unknown_command:
    mov si, unknown_msg
    call print_string
    call print_newline
    ret

header db '============================= RBladeOS v0.3 ====================================', 0
menu db 'Commands: PRINT, CLS, REBOOT, SHUT, LOOP, NOP, BANNER', 0
prompt db '[RBLADEOS] > ', 0
command_buffer db 150 dup(0)
unknown_msg db 'Unknown command.', 0
