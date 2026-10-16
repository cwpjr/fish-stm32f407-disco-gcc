 // FISH_STM32Fx_MEMMAP.s
 // STM32F407VG_SRAM128_TCM64
 // STM32F205RC_SRAM128
 // USE LINKER BETTER!!!
 //------------------------------------------------------------------------------
 // FISH FORTH Memory Map for the STM32Fx series
 // Tested:
 // STM32F407vg ARM Cortex M4F series SystemsOnaChip (SoC). STM32F4 Disco Brd.
 // STP STM32F206RC RPM Brd.

 // Create a new section for Temporary Word Dictionairy Section when ready
 // WITH IT'S OWN BASE AND CURRENT POINTERS TO COMPILE INTO,
 // A relocated transitory dictionary segment managed by system words.
 // Transitory dictionaly segment can be created, say as SoC addr constants,
 // used in compiling initialization routines, then un-linked after useage.
 //  SECTION .tcm_pref_temp_dict : DATA(2)
 //RAM_TEMP_DICT        DS8     48000
 //RAM_TEMP_DICT_END:

 // Create a new section for ISR's when ready
 // WITH IT'S OWN BASE AND CURRENT POINTERS TO COMPILE INTO,
 // THAT system words manage the creation/destruction of ISR WORDS.
 //  SECTION .tcm_pref_isr_ramcode : DATA(2)
 //RAM_ISR_AND_CODE        DS8     48000
 //RAM_ISR_AND_CODE_END:

 // Currently linked segements:
 //  These need to be able to fit into 128K RAM chips!
 // .sram_1rst_dict_stdio_bufs IS WHERE THE DICTIONAIRY AND AND I/O BUFFERS ARE
 // .sram_2nd_intvecs_unint is where Ram intvecs and unitialized ram are.
 // .tcm_pref_stacks_and_vars IS WHERE THE FISH STACKS, SYSTEM and USER VARS ARE.

 //----------- Start of RAM = DICTIONAIRY AND Standard I/O Buffers --------------
.section .sram_1rst_dict_stdio_bufs, "aw", %nobits
RAM_START: // RAM_END IS BEFORE UNINT AREA IN .sram2_64K segment
SYSCLOCK: .space (4 * (1))
FPA: .space (4 * (1))
FPC: .space (4 * (1))
FPSV: .space (4 * (1))
 // The above 4 words are the SIGNATURE for saved code in a flash page.
 // The FISH Dictionary starts 0x10 bytes after RBASE (RAMstart)
DICTSPACE_START:
ORIG: .space (1 * (64000))
DICTSPACE_END: // For DICTSPACE calculation
 // Stdio Buffers
PAD: .space (1 * (IOBUFSIZE))
TIB: .space (1 * (IOBUFSIZE))
TIB_DMA: .space (1 * (1024))
TIB_DMA_BUF_END:
 // FLASH_CODE COMMAND BLOCK IN RAM FOR FLASH PROGRAMMING
FLASH_CODE_SRAM2_START:
FLASH_CODE_RS: .space (1 * (68))
FLASH_CODE_SRAM2_END:

 //------------------- SRAM2_64K Ram intvecs and unitialized ram STRUCTURES ----------------
.section .sram_2nd_intvecs_unint, "aw", %nobits

RAM_INTVECS: .space (1 * (128*4))
RAM_INTVECS_END:
RAM_INIT_END: // end of 1's fill

.equ ALL_UNINIT_SRAM2_START, .
 // Define use of this resource.
 // DBAUD and UBAUD USED FOR SAVING BAUDRATE BETWEEN RESETS AND HARD FAULT RESETS
DBAUD: .space (4 * (1))
UBAUD: .space (4 * (1))
 // Free unitialized ram
.equ ALL_UNINIT_SRAM2_FREE_START, .
 // NEEDS TO STOP before block CSTACK, block HEAP WHICH IS DYNAMIC NOW!
.equ ALL_UNINIT_SRAM2_END, SRAM2_CSTACK

 //-------------- RAM Stack, system and use vars STRUCTURES ---------------------
.section .tcm_pref_stacks_and_vars, "aw", %nobits
STICKER: .space (4 * (1))
 // For VARSPACE calculation
RAMVARSPACE_START:
RAMVARSPACE: .space (1 * (64*4))
END_RAMVARSPACE_SV_START:
SV_START:
.balign 4
 // REARRANGE LATER FOR TASKING AND SIZE BASED OFFSETS!!
 // BYTE VALUES
NBASE: .space (4 * (1))
IN: .space (4 * (1))
OUT: .space (4 * (1))
CSTATE: .space (4 * (1))
 // ADDRESS VALUES initialed in FWARM:
INITSO: .space (4 * (1))
INITRO: .space (4 * (1))
INITTIB: .space (4 * (1))
UP: .space (4 * (1))
DP: .space (4 * (1))
CSDP: .space (4 * (1))
FENCE: .space (4 * (1))
CURRENT: .space (4 * (1))
PROMPT: .space (4 * (1))
ERROR_HALT: .space (4 * (1))
SV_END:
 // THESE ARE INITIALIZED WHEN USED AT RUN-TIME
CSP: .space (4 * (1))
NDPL: .space (4 * (1))
NHLD: .space (4 * (1))
 // FISH Stacks
.equ STACKSIZE, 32*4
RPAD: .space (4 * (4))
BOTTOM_RSTACK: .space (4 * (STACKSIZE))
.equ RINIT, .
SPAD: .space (4 * (4))
BOTTOM_PSTACK: .space (4 * (STACKSIZE))
.equ PINIT, .
.equ PSTART, .

