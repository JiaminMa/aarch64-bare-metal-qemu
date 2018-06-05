.global reset
.global get_vbar_el1
.global set_vbar_el1
.global el1_exception_vector
.global board_puthex
.global svc_0
.global svc_handler

reset:
    ldr x30, =stack_top	// setup stack
    mov sp, x30

    ldr x0, =el1_exception_vector
    msr vbar_el1, x0
    mrs x0, vbar_el1
   
    //Here's the test data for 
    mov x0, #0x0
    mov x1, #0x1111
    mov x2, #0x2222
    mov x3, #0x3333
    mov x4, #0x4444
    mov x5, #0x5555
    mov x6, #0x6666
    mov x7, #0x7777
    mov x8, #0x8888
    mov x9, #0x9999 

    svc #1

    bl c_entry
    b .

.align 11
el1_exception_vector:
                            //Synchronous El1t
    b .
    .align 7
    b .                     //IRQ El1t
    .align 7                
    b .                     //FIQ El1t
    .align 7                
    b .                     //Error El1t
    .align 7                

                            //Synchronous El1h
    stp x0, x1, [sp, #16 * 0]
    stp x2, x3, [sp, #16 * 1]
    stp x4, x5, [sp, #16 * 2]
    stp x6, x7, [sp, #16 * 3]
    stp x8, x9, [sp, #16 * 4]

    mrs x0, esr_el1
    mov w2, #26    
    lsr w1, w0, w2          //get exception class
    and w2, w0, #0x1ffffff  //get iss description
    
    cmp w1, #0x15
    bne synchronous_el1h_cleanup
    mov w0, w2
    mov x1, sp    
    bl svc_handler

synchronous_el1h_cleanup:
    ldp x0, x1, [sp, #16 * 0]
    ldp x2, x3, [sp, #16 * 1]
    ldp x4, x5, [sp, #16 * 2]
    ldp x6, x7, [sp, #16 * 3]
    ldp x8, x9, [sp, #16 * 4]
    eret
    
    .align 7
    b .                     //IRQ El1h
    .align 7                
    b .                     //FIQ El1h
    .align 7                
    b .                     //Error El1h
    .align 7                

    b .                     //Synchronous 64-bit El0
    .align 7
    b .                     //IRQ 64-bit EL0
    .align 7                
    b .                     //FIQ 64-bit EL0
    .align 7                
    b .                     //Error 64-bit EL0
    .align 7                

    b .                     //Synchronous 32-bit El0
    .align 7
    b .                     //IRQ 32-bit EL0
    .align 7                
    b .                     //FIQ 32-bit EL0
    .align 7                
    b .                     //Error 32-bit EL0
    .align 7                
