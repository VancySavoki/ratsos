

#include "../include/stdint.h"
#include "../include/io.h"
#include "../include/global.h"
#include "../include/interrupt.h"
#include "../include/console.h"

#define IDT_DESC_COUNT 0x21

struct gate_desc idt[IDT_DESC_COUNT];
void* handler_table[IDT_DESC_COUNT];

void set_interrupt_desc(struct gate_desc *p_gate_desc, uint8 attr, void* handler)
{
    p_gate_desc->handler_offset_low = (uint32)handler & 0x0000ffff;
    p_gate_desc->selector = SELECTOR_CODE;
    p_gate_desc->dw_count = 0;
    p_gate_desc->attribute = attr;
    p_gate_desc->handler_offset_high = ((uint32)handler & 0xffff0000) >> 16;
}

void init_interrupt_desc()
{
    for (int i = 0; i < IDT_DESC_COUNT; i++)
    {
        set_interrupt_desc(&idt[i], IDT_DESC_ATTR_DPL0, handler_table[i]);
    }
}

void init_pic()
{   
    io_outb(PIC0_IMR, 0xff); 
    io_outb(PIC1_IMR, 0xff);

    //master
    io_outb(PIC0_ICW1, 0x11);
    io_outb(PIC0_ICW2, 0x20);
    io_outb(PIC0_ICW3, 0x04);
    io_outb(PIC0_ICW4, 0x01);

    //slaver
    io_outb(PIC1_ICW1, 0x11);
    io_outb(PIC1_ICW2, 0x28);
    io_outb(PIC1_ICW3, 0x02);
    io_outb(PIC1_ICW4, 0x01);

     /* 打开主片上IR0,也就是目前只接受时钟产生的中断 */
    io_outb(PIC0_IMR, 0xfb); 
    io_outb(PIC1_IMR, 0xff);
}

void init_idt()
{

    init_interrupt_desc();
    init_pic();
    uint64 idt_info = ((sizeof(idt) - 1) |((uint64)idt << 16));
    io_lidt(&idt_info);
    char *str2 = "init_idt completed\n";
    putstring(str2);
}
