 // FISH_STM32F4_STARTUP.s
 //-----------------------------------FM3_COLD-----------------------------------
#ifdef USE_CMAIN
.global RET2c
#endif

.section .text, "ax", %progbits
.balign 4, 255
.global FM3_COLD
.global __iar_program_start
.thumb_func
__iar_program_start:
 // No MAIN() entry point!
 // :NONAME FM0_COLD ( -- ) Reset Vector entry point. Setup FISH Virtual Machine.
.thumb_func
FM3_COLD:
 // Initialize DICT RAM segment

	ldr	n, = 0x11111111 // fill pattern
	ldr	t, = RAM_START // START OF RAM WHERE DICT IS ALLOCATED
 // IN MEMMAP segment
	ldr	y, = RAM_INIT_END // BEFORE UNINT SECTION IN MEMMAP
.thumb_func
_fillRAM:
	str	n, [t]
	adds	t, t, #4
	cmp	t, y
	blo	_fillRAM

#ifdef USE_CMAINAAS
 //	PUSH lr to sp for BYE
 //	SUB	sp, sp, #4
 //	MOV	t, lr
 //	STR	t, [sp]
#endif

	LDR  	p, =PINIT // my parameters
	LDR  	r, =RINIT // p and r = FISH operating enviorment,
 // r = return stack.
 // ADR works here because it loads a PC releative offset!
 // Not a anywhere 32 bit addr - use LDR for that!
	ADR	i, FM4_WARM // i is the interpreter pointer.
	PUSHi2r // FM4_WARM is 5-6 lines down from here Go FISH!
	NEXT

.ltorg

 //---------------------------------FM4_WARM-------------------------------------
 // :NONAME FM4_WARM ( -- ) Start of FISH interpretation PRE-EXECUTION. then QUIT
.section .text, "ax", %progbits
.balign 4, 255
FM4_WARM:
#ifdef TESTRAM
    .word flogRAM
#endif
    .word FWARM
    .word SoCinit
    .word UART3_INIT

 // TEST CODE GOES HERE - Pre FISH Execution Environment
WTEST:

 // COPIES CODE TO RAM - CHECK FISH CODE FOR THIS KIND OF RELOCATION!
 // RELEATIVELY LINKED PRIOR DEFNITIONS!
 //        DC32    FLASH_TEST_CODE_IN_RAM
 // FLASH OPS CAN BE PERFORMED FROM FLASH WITH POTENTIAL WAIT STATES
 //        DC32    FLASH_TEST_CODE_IN_FLASH      // EXECUTES IN FLASH

 // TEST CODE END
FWARM_STARTING_UP:
 //        DC32    DOTS            // SHOW ANY STACK ARTIFACTS HERE
    .word CR
	.word LIT, 0xFB, EMIT
	.word LIT, 0xF7, EMIT
	.word CR
	.word COLD

#ifdef USE_CMAIN
	.word RET2c
#endif
 //------------------------ for meta-single-stepping ----------------------------
 //:NONAME ssNEXT ( -- ) System Internal hi level breakpoint.
.section .text, "ax", %progbits
.balign 4, 255
.thumb_func
ssNEXT1:
	LDM	w!, {x} // contents of cfa, (pfa), -> x, bump w to cfa+4
	MOV     pc, x // w preserves cfa+4 (pfa) for DOCOL's benefit

 //---------------------------- SYSTICK ISR -------------------------------------
 // STI_ON: 7 E000E010h !  STI_OFF: 5 E000E010h !
 // Restore lr to pc, save all working registers!

.global FMx_SYSTICK_ISR
.section .text, "ax", %progbits
.balign 4, 255
.thumb_func
FMx_SYSTICK_ISR:
 // Start of the working asm isr-------------------------------------------------
 // save what you use
    PUSH    { t, n, lr}
    LDR     n, = STICKER
    LDR     t, [n]
    ADDS    t, t, #1
    STR     t, [n]
 // restore what was being used
    POP     { t, n, pc } // exec lr -> pc
 // End of the working asm isr---------------------------------------------------
.ltorg

 // LABEL FOR HI-LEVEL WORD ISR CREATE WORD!
.section .text, "ax", %progbits
.balign 4, 255
ISR_SEMIS:
	.word .+5
.section .text, "ax", %progbits
	POPr2i // SEMIS to balance DOCOL!!!
    POP     { r0-r5, r10-r12, pc }

#if 0
 // Start of the Hi-Level WORD ISR Test------------------------------------------
 // The Hi-Level WORD ISR Pre amble.
.thumb_func
DOCOL_ISR:
    PUSH    { r0-r5, r10-r12, lr }
	LDR	w,  [PC, #0XC] //= MY_LTORG The High Level Target LTORG Label.

	NEXT1 // -> SEMIS_ISR RETURN required instead of SEMIS!

 // The Hi-Level WORD ISR Post amble.
.thumb_func
MY_LTORG_ISR_SEMIS:
 // .+8 = correct target DOCOL entry to Hi Level WORD Label because of LTORG
	.word .+8
 //>>>>>>>>>>>>>>THIS IS WHERE HI-LEVEL WORD CFA AS LTORG GOES!!!!!!!!!!!!!!!!!!!
    .word NONAME_STCTR_INCR
 //>>>>>>>>>>>>>>THIS IS WHERE HI-LEVEL WORD CFA AS LTORG GOES!!!!!!!!!!!!!!!!!!!
.section .text, "ax", %progbits
	POPr2i // SEMIS to balance DOCOL!!!
    POP     { r0-r5, r10-r12, pc }

 // The test Hi-Level target WORD.
.section .text, "ax", %progbits
.balign 4, 255
NONAME_STCTR_INCR:
    .word DOCOL
    .word ONE, STCTR, PSTORE
 //        DC32    STCTR, QUES   // Works showing longer execution can be done.
    .word MY_LTORG_ISR_SEMIS
 // End of the Hi-Level WORD ISR Test--------------------------------------------
 // NOTE: LTORG manual in this section!
#endif

/*
 //-------------------------- ISR's and inline ASM ------------------------------
 //:NONAME ISR_FISH Hi level call of FISH word from ISA
 //      Save all regs and index a table of CFA's = execute if non-zero

 //:NONAME ILA Inline Assembly code execution
.section .text, "ax", %progbits
.balign 4, 255
ILA:
	.word DOCOL
    .word NOOP
 //	DC32	ASM_START	// HW ISSUE
 //	NOP
 // DC32    ASM_END
	.word SEMIS
*/
