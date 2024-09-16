MEMORY {
    CODE (rx): ORIGIN = 0x00000000, LENGTH = 1024
}

STACK_SIZE = 128;
HEAP_SIZE  = 0;

ENTRY(__reset);

SECTIONS {
    . = 0x00000000;
    .text : ALIGN(4) {
        KEEP(*(.vectors))
        *(.startup)
        *(.text)
        *(.rodata)
        . = ALIGN(4);
        __text_end = .;
    } > CODE

    .data : ALIGN(4) {
        __data_start = .;
        *(.data);
        . = ALIGN(4);
        __data_end = .;
    } > CODE

    .bss : ALIGN(4) {
        __bss_start = .;
        *(.bss)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > CODE

    .heap : ALIGN(4)
    {
        __heap_start = .;
        . += HEAP_SIZE;
        . = ALIGN(4);
        __heap_end = .;
    } > CODE

    /* Use 16-byte aligned stack as per standard RISCV calling convention */
    .stack : ALIGN(16)
    {
      __stack_bottom = .;
      . += STACK_SIZE;
      . = ALIGN(16);
      __stack_top = .;
    } > CODE

    /DISCARD/ : {
        *(.note.GNU-stack)
        *(.gnu_debuglink)
        *(.gnu.lto_*)
    }
}
