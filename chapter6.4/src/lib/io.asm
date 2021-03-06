; Ratsos

[bits 32]

global io_hlt
global io_in8, io_out8
global io_in16, io_out16
global io_in32, io_out32
global io_mov8, io_mov16,  io_mov32
global io_lgdt, io_lidt
global io_interrupt

[section .text]

io_hlt:       ; void io_hlt
    hlt
    ret


io_in8:       ; uint8 io_in8(uint16 port)
    mov dx,[esp+4]
    mov al,0
    in  al,dx
    ret

io_out8:      ; void io_out8(uint16 port,uint8 data)
    mov dx,[esp+4]
    mov al,[esp+8]
    out dx, al
    ret

io_in16:      ; uint16 io_in16(uint16 port)
    mov dx,[esp+4]
    mov ax,0
    in  ax,dx
    ret

io_out16:     ; void io_out16(uint16 port,uint16 data)
    mov dx,[esp+4]
    mov ax,[esp+8]
    out dx, ax
    ret

io_in32:      ; uint32 io_ind(uint16 port)
    mov dx,[esp+4]
    mov eax,0
    in  eax,dx
    ret

io_out32:     ; void io_outd(uint16 port,uint32 data)
    mov dx,[esp+4]
    mov eax,[esp+8]
    out dx,eax
    ret

io_mov8:      ; void io_mov8(uint32*  src,uint32* dest, int count);
    push ecx
    cld
    mov esi,[esp+4]
    mov edi,[esp+8]
    mov ecx,[esp+12]
    rep movsb
    pop ecx
    ret

io_mov16:     ; void io_mov16(uint32* src,uint32* dest, int count);
    push ecx
    cld
    mov esi,[esp+4]
    mov edi,[esp+8]
    mov ecx,[esp+12]
    rep movsw
    pop ecx
    ret

io_mov32:     ; void io_mov32(uint32* src,uint32* dest, int count);
    push ecx
    cld
    mov esi,[esp+4]
    mov edi,[esp+8]
    mov ecx,[esp+12]
    rep movsd
    pop ecx
    ret


io_lgdt:      ; void io_lgdt(uint64 p_gdt)
    mov eax, [esp+4]
    lgdt [eax]
    ret

io_lidt:      ; void io_lidt(uint64 p_gdt)
    mov eax, [esp+4]
    lidt [eax]
    ret

io_interrupt: ; void io_interrupt(void* func)
    pushad
    mov al,0x20
    out 0xa0, al
    out 0x20, al
    mov ebx,[esp+8]
    mov ecx,4
    mul ebx
    add ebx,[esp+4]
    call [ebx]
    popad
    iretd
