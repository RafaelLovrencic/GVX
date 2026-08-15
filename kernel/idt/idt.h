#ifndef IDT_H
#define IDT_H

typedef struct {
    uint16_t offset_1;
    uint16_t selector;
    uint8_t ist;
    uint8_t type_attribs;
    uint16_t offset_2;
    uint32_t offset_3;
    uint32_t reserved;
} __attribute__((packed)) gate_descriptor;


extern gate_descriptor idt[256];


void IDT_init(void);

#endif
