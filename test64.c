#include <stdint.h>
#include <stdio.h>

void c_entry() {
    
    board_puts("Hello world!\n");
    while(1);
}

void svc_handler(uint32_t svc_num, uint64_t context)
{
    uint32_t i = 0;
    uint32_t reg = 0;
    board_puthex(svc_num);
    for(i = 0; i < 10; i++) {
        reg = *(uint32_t *)context;
        board_puthex(reg);
        context += 8;
    }
}
