ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
    CCMRAM (rw) : ORIGIN = 0x10000000, LENGTH = 64K
    SRAM1 (rwx) : ORIGIN = 0x20000000, LENGTH = 64K
    SRAM2 (rwx) : ORIGIN = 0x20010000, LENGTH = 64K
}

_estack = ORIGIN(SRAM2) + LENGTH(SRAM2);

SECTIONS
{
    .isr_vector ORIGIN(FLASH) :
    {
        . = ALIGN(4);
        KEEP(*(.intvec))
        . = ALIGN(4);
    } > FLASH

    .text :
    {
        . = ALIGN(4);
        *(.text .text.*)
        *(.rodata .rodata.*)
        . = ALIGN(4);
    } > FLASH

    .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } > FLASH
    .ARM.exidx : { *(.ARM.exidx* .gnu.linkonce.armexidx.*) } > FLASH

    .sram_1rst_dict_stdio_bufs ORIGIN(SRAM1) (NOLOAD) :
    {
        . = ALIGN(4);
        KEEP(*(.sram_1rst_dict_stdio_bufs))
        . = ALIGN(4);
    } > SRAM1

    .sram_2nd_intvecs_unint ORIGIN(SRAM2) (NOLOAD) :
    {
        . = ALIGN(4);
        KEEP(*(.sram_2nd_intvecs_unint))
        . = ALIGN(4);
    } > SRAM2

    .tcm_pref_stacks_and_vars ORIGIN(CCMRAM) (NOLOAD) :
    {
        . = ALIGN(4);
        KEEP(*(.tcm_pref_stacks_and_vars))
        . = ALIGN(4);
    } > CCMRAM

    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data .data.*)
        . = ALIGN(4);
        _edata = .;
    } > SRAM1 AT > FLASH
    _sidata = LOADADDR(.data);

    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss .bss.* COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > SRAM1

    .heap_stack ORIGIN(SRAM2) + LENGTH(SRAM2) - 0x4000 (NOLOAD) :
    {
        _heap_start = .;
        . += 0x2000;
        _heap_end = .;
        _stack_limit = .;
        . += 0x2000;
    } > SRAM2

    /DISCARD/ : { *(.comment) *(.note*) }
}

ASSERT(SIZEOF(.sram_1rst_dict_stdio_bufs) <= LENGTH(SRAM1), "SRAM1 dictionary does not fit")
ASSERT(ADDR(.sram_2nd_intvecs_unint) + SIZEOF(.sram_2nd_intvecs_unint) <= _heap_start, "SRAM2 data overlaps heap/stack")
ASSERT(SIZEOF(.tcm_pref_stacks_and_vars) <= LENGTH(CCMRAM), "CCMRAM data does not fit")