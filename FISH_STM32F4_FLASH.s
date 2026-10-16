 // FISH_STM32F4_FLASH.s
 // FLASH_SAVE, FLASH_FORGET, FLASH_SCAN and support :NONAME's

/* 2DO:
 // FLASH_SAVE LEAVING HERE ON STACK
---
 // SAVE PAGE IF ENOUGH ROOM LEFT FOR THIS SAVE
FLPT:
 // NOT IMPLEMENTED YET!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
---
 // DETERMINE IF ASSUREPAGE NEEDED, IF SO REWRITE AND INCORPORATE
---
 // MAKE IRQ Wordcat AND ADD:
 //:NONAME CMSIS_DISABLE_IRQS ( -- )
 //:NONAME CMSIS_ENABLE_IRQS ( -- )
*/

 //	FLASH_SAVE FLASH_SAVE:	( -- ) Save RAM to Flash
 //      EVERY SAVE HAS A HEADER SET FOR FLASH_SCAN TO USE
 //      ALIGNED HERE IS BOUNDARY OF NEW WRITE
 //      SAVES ARE CONTIGUOUS WORDS USING x32 WRITE SETTING
.section .text, "ax", %progbits
FLASH_SAVE_NFA:
	.byte 0x80+10
	.ascii "FLASH_SAV"
	.byte 'E'+0x80
.balign 4, 255
	.word WC_IRQ_NFA
FLASH_SAVE:
	.word DOCOL
 // SOMETHING TO SAVE TEST - IF LATEST IS NOT IN ROM
	.word LATEST, DBASE, LESSTHAN
	.word ZBRAN
        .word FLPT-.

        .word CR
        .word PDOTQ
        .byte 15
        .ascii "NOTHING TO SAVE"
.balign 4, 255
	.word SEMIS

 // SINGLE ENTRY FROM ABOVE
 // SAVE PAGE IF ENOUGH ROOM LEFT FOR THIS SAVE
FLPT:
 // NOT IMPLEMENTED YET!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        .word FPADDR, AT
        .word LIT, FLASH_PPAGE
        .word EQUAL
 // DC32 NOOP
        .word ZBRAN
        .word FSAVE-.

FSLASTPAGE:
        .word CR
        .word PDOTQ
        .byte 20
        .ascii "LAST FLASH AVAIL USED"
.balign 4, 255
        .word SEMIS

 // Setup for saving - Assumes no error in relocation
 // Based on relocating UP and Latest to FPVAR and FPCURR
FSAVE:
 // MAKE SURE HERE IS ALIGNED
        .word ALIGN32_DP_FF_PAD
 // FPA SHOULD BE SET BY FLASH_SCAN IN WARM OR BY FISH OR FISH_ONLY
 // FPCURR AND FPVAR SAVE
	.word UP_SV, AT, FPVAR, STORE
	.word LATEST, TOFA
 //	DC32	LATEST, TOFRA ALL RELOCS NEED TO ADD TO BASE!
        .word FPCURR, STORE

 // KEEP RELOCATING ONE WORD AT A TIME UNTIL RECHING FIRST WORD (DBASE)
FS_BEGIN:
	.word LATEST, DBASE, EQUAL
        .word ZBRAN
        .word FS_RWORD-.

 // AFTER LAST WORD RELOCATED
FS_WRITE:
	.word FLASHWRITE
	.word DBASE, DP_SV, STORE
	.word FPVAR, AT, UP_SV, STORE
	.word FPCURR, AT, CURRENT_SV, STORE

 // FLASH_SAVE Finish
FS_EXIT:
        .word FLASH_SCAN
        .word CR, DOTVARSPACE, DOTDICTSPACE
	.word SEMIS

FS_RWORD:
	.word LATEST, RWORD
	.word BRAN
        .word FS_BEGIN-.


 //:NONAME	FPADDR:	( -- addr ) Flash Page Addreess to operate on.
.section .text, "ax", %progbits
FPADDR:
	.word DOCON, FPA


 //:NONAME	FPCURR:	( -- addr ) Flash Page CURRENT is NFA of last word saved in Flash.
.section .text, "ax", %progbits
FPCURR:
	.word DOCON, FPC


 //:NONAME	FPVAR:	( -- addr ) Flash Page VAR is UP value when Flash page saved.
.section .text, "ax", %progbits
FPVAR:
	.word DOCON, FPSV

 //:NONAME >FA TOFA:	( addr -- raddr ) Relocate address relative to FPADDR.
 //	Convert WORD addresses to flash using FPADDR, which must be initialized.
.section .text, "ax", %progbits
.balign 4, 255
TOFA:
	.word .+5
.section .text, "ax", %progbits
	POP2t
	LDR	w, = 0x0FFFFF // 08100000 FLASH ADDR lIMIT
	ANDS	t, t, w // Strip RAM address
	LDR	w, = FPA
	LDR	w, [w] // Get Flash save start address
	ADDS	t, t, w // add offset
	TPUSH
.ltorg


 //:NONAME RWORD:	( nfa -- ) Relocate this word relative to FPADDR
 //	Relocate word specified by it's NFA to FPADDR relative addresses
 //	Handle case of CON/VAR, PDOTQ and LIT by not relocating them.
 //      RLIT's WILL BE RELOCATED - LIT's WILL NOT.
.section .text, "ax", %progbits
RWORD:
	.word DOCOL
	.word PFA, DUP, TOR
	.word CFA

CFA_CREATE_DOES_GOTO:
        .word DUP, AT
        .word LIT, CREATE_DOES_GOTO
        .word EQUAL
        .word ZBRAN
        .word RW_DOCONVAR-.

        .word FOURP, DUP, DUP
        .word AT, TOFA
        .word SWAP, STORE
	.word BRAN
        .word RW_UNTIL-.

RW_DOCONVAR:
 // CHECK FOR DOCON AND DOVAR
        .word DUP, AT
	.word LIT, DOCON
	.word EQUAL

        .word OVER, AT
	.word LIT, DOVAR
	.word EQUAL

        .word OR
        .word ZBRAN
        .word RW_BEGIN-.
 // IS DOCON OR DOVAR
	.word DROP
	.word BRAN
        .word RW_LFA-.

 // CFA -- BECOMES EACH WORD IN BODY OF THIS DEFINITION
RW_BEGIN:
	.word FOURP, DUP, AT
CFA_LIT:
	.word LIT, LIT, EQUAL
	.word ZBRAN
        .word CFA_PDOTQ-.
 // IS LITERAL SO SKIP OVER IT'S DATA
	.word FOURP
	.word BRAN
        .word RW_BEGIN-.

CFA_PDOTQ:
	.word DUP, AT
	.word LIT, PDOTQ, EQUAL
	.word ZBRAN
        .word CFA_SEMIS-.
 // PDOTQ SO BYPASS TEXT AND LOOK FOR NEXT WORD IN THIS DEFINITION
	.word DUP, FOURP, CAT
	.word PLUS
	.word ALIGNED
	.word BRAN
        .word RW_BEGIN-.

CFA_SEMIS:
	.word DUP, AT
	.word LIT, SEMIS, EQUAL
	.word ZEQU, ZBRAN
        .word RW_UNTIL-.

RELOCATE_RAM_ADDR:
 // NOT AT SEMIS - IF A RAM ADDRESS THEN IT's OK TO RELOCATE!
	.word DUP, AT
	.word DBASE, GREATERTHAN
	.word ZBRAN
        .word RW_BEGIN-.
 // THIS IS A RAM ADDRESS THAT NEEDS TO BE RELOCATED TO A FLASH ADDRESS
 // LIT's were left alone but RLIT value will be relocated here
	.word DUP, DUP, AT
	.word TOFA
        .word SWAP, STORE
	.word BRAN
        .word RW_BEGIN-.

RW_UNTIL:
 // ADDRESS OF SEMI IN THIS DEFINITION
	.word DROP
RW_LFA: // RELOCATE LFA AND SET CURRENT/LATEST TO Next WORD
	.word RFROM
	.word LFA, DUP, AT
	.word DUP
	.word CURRENT_SV, STORE
	.word TOFA, SWAP, STORE
	.word SEMIS


 //------------------------------------------------------------------------------
 //:NONAME FLASH_SCAN:       ( -- ) SCAN FLASH FOR SAVED CODE
 //      Patch in FLASH_SAVE'd Code.
.section .text, "ax", %progbits
FLASH_SCAN:
	.word DOCOL

 // FLASH_PPAGE can be reserved and Hard_fault if accessed!
        .word LIT, FLASH_SPAGE
CHECK_NEXT_FLASH_SAVE:
        .word DUP, LIT, FPA, STORE
        .word DUP, TOR
        .word AT
        .word SYSCLK
        .word SUBB
        .word ZBRAN
        .word LINK_FLASHCODE_SEGMENT-.

 // NO CODE FOUND TO LINK EXIT
        .word RFROM, DROP, SEMIS

LINK_FLASHCODE_SEGMENT:
 //      PAGE PASSES SYSCLK VERIFICATION, LINK IT
        .word R, FPADDR, STORE
        .word R, LIT, 8, PLUS
        .word DUP, AT
        .word CURRENT_SV
        .word STORE
        .word FOURP, AT
        .word UP_SV, STORE

        .word CR
        .word PDOTQ
        .byte 23
        .ascii "ADDED WORDS FROM ADDR "
.balign 4, 255
        .word R, DOTHEX

        .word RFROM, FOURP, AT
        .word BRAN
        .word CHECK_NEXT_FLASH_SAVE-.


 //:NONAME ASSUREPAGE: ( fpa -- next-fpa) Verify this Flash page has code or is empty.
 //      Make sure PAGE IN fpa page is erased and let user know what you do.
 //      NOT TESTED YET: erase this page and tell user<<<<<<<<<<<<<<<<<<<<<<<<<<<

 // 2 STACK ITEMS LEFT ON EXIT, BOTH ARE fpa+1000H LIKE WHATS PUT ON r<<<<<<<<<<<

.section .text, "ax", %progbits
ASSUREPAGE:
        .word DOCOL
        .word DUP
 //        DC32    LIT, FLASH_WR_SIZE      // PAGE SIZE WERE WRITING
        .word PLUS
        .word TOR
        .word DUP

APNEXT:
        .word AT
        .word ONEP
        .word ZBRAN
        .word APCONT-.

 //      ERASE THIS PAGE                 // -- fpa
 //        DC32    FLASHPREP
 //        DC32    FLASHESEC
        .word CR
        .word PDOTQ
        .byte 23
        .ascii "ERASED BAD FLASH PAGE  "
.balign 4, 255
        .word DOTHEX

 //        DC32    CR, DOTS // DEBUG
        .word DROP

        .word RFROM, DROP
        .word SEMIS

 //      SO FAR SO GOOD
APCONT: // -- addr
        .word FOURP, DUP
        .word DUP, R, SWAP
        .word SUBB
        .word ZBRAN
        .word APGOOD-.

        .word BRAN
        .word APNEXT-.

APGOOD: // addr
        .word CR
        .word PDOTQ
        .byte 14
        .ascii "FLASH PAGE OK "
.balign 4, 255
 //        DC32    DROP, LIT, FLASH_WR_SIZE      // PAGE SIZE WERE WRITING
        .word SUBB
        .word DOTHEX

APDONE:
        .word RFROM, DROP
        .word SEMIS

 //------------------------------------------------------------------------------
 //	FLASH_FORGET FLASH_FORGET:	( --  ) Erase All User Flash Pages

.section .text, "ax", %progbits
FLASH_FORGET_NFA:
	.byte 0x80+12
	.ascii "FLASH_FORGE"
	.byte 'T'+0x80
.balign 4, 255
	.word FLASH_SAVE_NFA
FLASH_FORGET:
        .word DOCOL
        .word PDOTQ
        .byte 23
        .ascii "TAKES ABOUT 6 SECONDS! "
.balign 4, 255
        .word CMSIS_DISABLE_IRQS
        .word FLASH_UNLOCK
        .word FLASH_NOT_BSY
 // Erase sector at a time
 // ?Break this out to a primitive looping from sector 4/5 to 11
 // 4 Words / 32 bytes per sector erase - 7 = 28 words / 112 bytes
 // Sector 4 is 64k, sector 0-3 are 16k, together they equal 1rst 128k of flash.
 // 5 to 11 are the 7 other 128k sectors that amount to the full 1mb of flash.

 // 01 is start 02 is x32 2 is 4th sector 2 is sector erase
 // 5 3 LSL 2 + .H 2Ah  ok, go fish in BASE 10d
 // 6 3 LSL 2 + .H 32h  ok, go fish in BASE 10d
 // 7 3 LSL 2 + .H 3Ah  ok, go fish in BASE 10d
 // 8 3 LSL 2 + .H 42h  ok, go fish in BASE 10d

 //        DC32    strva, 010222h, FLASH_CR        // erase sector 4 0x08010000h
 //        DC32    FLASH_NOT_BSY   // VERIFY NOT BUSY
        .word strva, 0x01022A, FLASH_CR
        .word FLASH_NOT_BSY
        .word strva, 0x010232, FLASH_CR
        .word FLASH_NOT_BSY
        .word strva, 0x01023A, FLASH_CR
        .word FLASH_NOT_BSY
        .word strva, 0x010242, FLASH_CR
        .word FLASH_NOT_BSY
        .word strva, 0x01024A, FLASH_CR
        .word FLASH_NOT_BSY
        .word strva, 0x010252, FLASH_CR
        .word FLASH_NOT_BSY
        .word strva, 0x01025A, FLASH_CR
        .word FLASH_NOT_BSY
 // Lock Flash again
        .word FLASH_LOCK
        .word CMSIS_ENABLE_IRQS

 //      RESET DICTIONARY and FLASH POINTERS APPROPRIATELY
FF_FINISH:
 // IF NO WORDS IN RAM TEST
	.word RBASE, LATEST
        .word GREATERTHAN
        .word ZBRAN
        .word RAMWORDS-.
 // RESET ALL POINTERS
        .word FISH_ONLY
 // RESET FPA
        .word BRAN
        .word FFDONE-.

 // Preserve words in ram exit point.
RAMWORDS:
 //        DC32    LIT, TASK_NFA         // Fish WITH TASKER IN RAM starts here
#ifdef FISH_PubRel_WORDSET
        .word LIT, WC_FISH_PubRel_NFA
#endif
#ifdef FISH_NXP_M0_PRO_WORDCAT
        .word LIT, WC_FISH_PRO_NFA
#endif
        .word DBASE, PFA, LFA
        .word STORE

 // FLASH_FORGET Finish
FFDONE:
        .word strva, FLASH_SPAGE, FPA
        .word LIT, 0x11111111, DUP, FPCURR, STORE, FPVAR, STORE
 // Show results
        .word FLASH_SCAN
        .word CR, DOTVARSPACE, DOTDICTSPACE
        .word SEMIS

 //--------------------- Flash code copied to ram test --------------------------

 //:NONAME FLASH_TCODE_COPY ( End Start -- ) Copy Flash code to ram
.section .text, "ax", %progbits
.balign 4, 255
FLASH_TCODE_COPY:
	.word .+5
.section .text, "ax", %progbits
.balign 4, 255
        POP2t // LDR     t, =FLASH_TCODE_START
        POP2n // LDR     n, =FLASH_TCODE_END
        LDR     w, =FLASH_CODE_SRAM2_START
.thumb_func
FLASH_COPY_LOOP:
        LDR     y, [t], #4
        STR     y, [w], #4
        cmp     t, n
        BNE     FLASH_COPY_LOOP
        NEXT

 // Each one will use FLASH_RAMCODE_EXEC after copying it's code to ram..
 //:NONAME FLASH_RAMCODE_EXEC ( -- )
.section .text, "ax", %progbits
FLASH_RAMCODE_EXEC:
        .word LIT, FLASH_CODE_SRAM2_START
        .word EXEC
        .word SEMIS

 // Prototype for each function
 //:NONAME FLASH_TEST_RAMCODE ( -- )
.section .text, "ax", %progbits
FLASH_TEST_CODE_IN_RAM:
        .word DOCOL
        .word LIT, FLASH_TCODE_END
        .word LIT, FLASH_TCODE_START
        .word FLASH_TCODE_COPY
	.word FLASH_RAMCODE_EXEC
        .word SEMIS

 //:NONAME FLASHWRITE:	( --  ) Save Ram to Flash using FPADDR and valid HERE.
 //	Header need to be completed at this point.
 //      FPADDR needs to be Flash HERE, where the next save goes.
 //      But current FPADDR must be uused for save
.section .text, "ax", %progbits
FLASHWRITE:
	.word DOCOL
/* THIS WAS ADDED BECAUSE 2ND SAVE BOMBED WITH FPCURR -> HEADER NOT DBASE START
 // SET FPCURR TO NEW LATEST
        .word FPADDR, AT
        .word LIT, 16, PLUS
        .word FPCURR, STORE
 .word NOOP
 */
        .word CMSIS_DISABLE_IRQS
        .word FLASH_UNLOCK
        .word FLASH_NOT_BSY
 // Set PSIZE to x32 and the Program Start bit
        .word strva,  0x0201, FLASH_CR
 // SAVE FPA AS HEADER ADDR
        .word FPADDR, AT, TOR
 // BUMP FPA TO DICT OFFSET
        .word LIT, 16, FPADDR, PSTORE
 // COPY DBASE TO HERE TO FLASH
 // AFTER RWORD IS HERE VALID????
	.word HERE, TOR
	.word DBASE
 //        DC32    RBASE
FLASH_WRITE_LOOP:
        .word DUP, AT
	.word FPADDR, AT
        .word STORE, FLASH_NOT_BSY
        .word FOUR, FPADDR, PSTORE
        .word FOURP
	.word DUP, R, SUBB
	.word ZBRAN
        .word FLASH_WRITE_EXIT_LOOP-.
        .word BRAN
        .word FLASH_WRITE_LOOP-.
FLASH_WRITE_EXIT_LOOP:
        .word RFROM
        .word DROP, DROP

 // WRITE HEADER WITH ORIGINAL FPA ( 4 WORDS )
 // NEW FPA SET HERE - DOES IT NEED 4+ BUMP HERE?
 // FPVAR AND FPCURR SET IN CALLING FUNCTION - FLASH_SAVE
 // DEFINE SRBASE        DC32    SRBASE, AT, R           // WRITE SYSCLK
        .word LIT, RAM_START, AT, R
        .word STORE, FLASH_NOT_BSY
        .word FPADDR, AT
        .word R, FOURP
        .word STORE, FLASH_NOT_BSY
        .word FPCURR, AT
 //        DC32    LIT, 16, PLUS           // PAST HEADER
        .word R, EIGHT, PLUS
        .word STORE, FLASH_NOT_BSY
        .word FPVAR, AT, RFROM, LIT, 12, PLUS
        .word STORE, FLASH_NOT_BSY
FLASH_WRITE_FINISH:
        .word FLASH_LOCK
        .word CMSIS_ENABLE_IRQS
	.word SEMIS

 //--------------------- Flash code copied to ram test --------------------------
FLASH_TCODE_START:
 // WORDS and CODE to evaluate for copying to RAM ( for each flash function ).

 //:NONAME FLASH_TEST_CODE_IN_FLASH: ( -- )
.section .text, "ax", %progbits
FLASH_TEST_CODE_IN_FLASH:
        .word DOCOL
        .word FLASH_FORGET
        .word CMSIS_DISABLE_IRQS
        .word FLASH_UNLOCK
        .word FLASH_NOT_BSY
 // Set PSIZE to x32 and the Program Start bit
        .word strva,  0x0201, FLASH_CR
        .word strva, 0x08020000, FPA
        .word LIT, 16, DP_SV, PSTORE
        .word NOOP
        .word FLASHWRITE
        .word NOOP
        .word FLASH_FORGET
/* Write and erase test
 // User Code Flash Save starts in sector 5, the 1rst of 7 128k sectors
        .word strva,  -3, 0x08020000
        .word FLASH_NOT_BSY
        .word strva,  -4, 0x08040000
        .word FLASH_NOT_BSY
        .word NOOP
        .word FLASH_FORGET
*/
        .word FLASH_LOCK
        .word CMSIS_ENABLE_IRQS
 // Lock Flash again
        .word SEMIS


.section .text, "ax", %progbits
.balign 4, 255
FLASH_NOT_BSY:
	.word .+5
.section .text, "ax", %progbits
.balign 4, 255
        LDR     n, =FLASH_SR // 40023C00h is FLASH CTRL 40023C0Ch is FLASH_SR
.thumb_func
_WaitBsy10:
        LDR     t, [n]
        LSLS    t, t, #16 // BSY - Bit 16
        BCS     _WaitBsy10
        NEXT
 // Commit literal constants to pool to be copied!
.ltorg

 //:NONAME FLASH_UNLOCK ( -- ) // Unlock Flash Programming Functionality
.section .text, "ax", %progbits
FLASH_UNLOCK:
        .word DOCOL
        .word strva,  0x045670123, FLASH_KEYR
        .word strva,  0x0CDEF89AB, FLASH_KEYR
        .word SEMIS

 //:NONAME FLASH_LOCK ( -- ) // Lock Flash Programming Functionality
.section .text, "ax", %progbits
FLASH_LOCK:
        .word DOCOL
 //      SETBITS SETBITS:	( addr val -- ) OR val bits into addr.
 //        DC32    LIT, FLASH_CR, LIT, 080000000h, SETBITS // Preserve other bits
        .word strva,   0x080000000, FLASH_CR
        .word SEMIS

FLASH_TCODE_END:

