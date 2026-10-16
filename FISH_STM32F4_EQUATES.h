 // FISH STM32F4_EQUATES.h
 // #defines are placed in the Assembler Preproccesor Defined Symbols section.
 // EQUATES are for REAL VALUES used in FISH assembly code
 //
.equ DEFAULT_BAUD, 9600
.equ DEFAULT_BASE, 10
.equ XON_CHAR, 17
.equ XOFF_CHAR, 19
.equ IOBUFSIZE, 96
.equ MAXWORDLEN, 31

#ifdef STM32F4_IRC16_16MHZ
.equ SYSTEMCLOCK, 16000000
#endif
#ifdef STM32F4_IRC16_32MHZ
.equ SYSTEMCLOCK, 32000000
#endif
#ifdef STM32F4_IRC16_48MHZ
.equ SYSTEMCLOCK, 48000000
#endif
#ifdef STM32F205RC_XRC10_118MHZ
 //SYSTEMCLOCK     EQU     210000000       // TEST NO PLL CHANGES FROM XRC08_168mhz
.equ SYSTEMCLOCK, 118000000
#endif
#ifdef STM32F4_XRC08_168MHZ
.equ SYSTEMCLOCK, 168000000
#endif

 //-------------- System memory mapping equates and structures ------------------

 // RAM RUNTIME ADDRS ARE DEINED BY LABELS IN MEMMAP SEGMENTS

.equ FLASH_START, 0x08000000
.equ FLASH_SPAGE, 0x08020000
.equ FLASH_PPAGE, 0x08100000


 // BATTERY BACKED RAM
.equ BBRAM_START, 0x40024000
.equ BBRAM_END, 0x40025000
.equ BBRAM, BBRAM_START

 //-------------- System STACK AND UNINIT mapping equates -----------------------
 // THIS SHOULD BE A STATIC LINK - AT END OF SRAM2...
 // MAP: CSTACK$$Base          0x2001e000         --   Gb  - Linker created -
.equ SRAM2_CSTACK, 0x2001E000


