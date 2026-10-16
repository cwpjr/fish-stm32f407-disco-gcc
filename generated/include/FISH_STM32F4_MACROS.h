
 //#define ss      // "single-step" switch for debug/shakedown testing

 //------------------------------------------------------------------------------
 //	Inner Interpreter Macros
 //	Beauty is you can put any ISA in a macro and no prob till referenced!
.macro NEXT
 // ARMv7-M Thumb = .+5
	ldr	w, [i], #4
 // ARMv6-M Thumb = .+4
 //        LDM	i!, {w}	// get IP->cfa to w, incr i after
	NEXT1
.endm
#ifndef ss
 // ARMv7-M Thumb = .+5
.macro NEXT1
	BIC	w, w, #3
	LDR	x, [w], #4
	BX	x
 // ARMv6-M Thumb = .+4
 //	LDM	w!, {x}		// contents of cfa, (pfa), -> x, bump w to cfa+4
 //	BLX	x		// w preserves cfa+4 (pfa) for DOCOL's benefit
.endm

 // ELSE
#else
.macro NEXT1
	LDR	x, =ssNEXT1 // meta-single-step for debugging
	BX	x
.endm
 // LTORG
#endif
 // ENDIF

.macro TPUSH
	PUSHt // push t to p, pre decrement p
	NEXT
.endm

.macro DPUSH
	PUSHw // push w to p, post decrement p
	TPUSH
.endm

 //------------------------------------------------------------------------------
 //      FISH STACK MACRO's
 //	Beauty is you can put any ISA in a macro and no prob till referenced!
 // 	Cortex M0 THUMB only does STMia and LDMia
 //	I (rstack value to pstack) expects POP to be post increment
 //	Meaning that TOS is = to current p or r
 //	Therefore PUSH is pre decrement

.macro PUSHt
	STR	t, [p, #-4]! // Pre-increment
 //      SUBS	p, p, #4	// push t to p, pre decrement p
 //	STR	t, [p]
.endm

.macro POP2t
	LDR	t, [p],#4 // Post-increment
 //#ifndef TOSCT
 //	LDR	t, [p]		// pop tos to t, post increment p
 //#endif
 //      ADDS	p, p, #4
.endm

.macro NDPOP2t
	LDR	t, [p]
.endm

.macro PUSHn
	STR	n, [p, #-4]!
 //	SUBS	p, p, #4	// push n to p, pre decrement p
 //	STR	n, [p]
.endm

.macro POP2n
	LDR	n, [p],#4
 //	LDR	n, [p]
 //	ADDS	p, p, #4
.endm

.macro PUSHw
	STR	w, [p, #-4]!
 //      SUBS	p, p, #4	//  push w to p, pre decrement p
 //	STR	w, [p]
.endm

.macro POP2w
	LDR	w, [p],#4
 //	LDR	w, [p]
 //	ADDS	p, p, #4
.endm

.macro NDPOP2w
	LDR	w, [p]
.endm

.macro PUSHx
	STR	x, [p, #-4]!
 //	SUBS	p, p, #4	//  push x to p, pre decrement p
 //	STR	x, [p]
.endm

.macro POP2x
	LDR	x, [p],#4
 //	LDR	x, [p]
 //	ADDS	p, p, #4
.endm

.macro NDPOP2x
	LDR	x, [p]
.endm

.macro PUSHi
	STR	i, [p, #-4]!
 //	SUBS	p, p, #4	// push i to p, pore increment p
 //	STR	i, [p]
.endm

.macro POP2i
	LDR	i, [p],#4
 //	LDR	i, [p]
 //	ADDS	p, p, #4
.endm

.macro PUSHt2r
	STR	t, [r, #-4]!
 //	SUBS	r, r, #4	//  push t to r, pre decrement r
 //	STR	t, [r]
.endm

.macro PUSHi2r
        STR	i, [r, #-4]!
 //	SUBS	r, r, #4	//  push i to r, pre decrement r
 //	STR	i, [r]
.endm

.macro POPr2i
	LDR	i, [r],#4
 //	LDR i, [r]		//  pop r to i, post increment r
 //	ADDS	r, r, #4
.endm

 //POP2p	MACRO
 //	ENDM
 //POP2PC	MACRO
 //	ENDM

.macro POPr2t
	LDR	t, [r],#4
 //	LDR	t, [r]
 //	ADDS	r, r, #4
.endm

.macro PUSHn2r
	STR	n, [r, #-4]!
 //	SUBS	r, r, #4	//  push t to r, pre decrement r
 //	STR	n, [r]
.endm

.macro PUSHw2r
	STR	w, [r, #-4]!
 //	SUBS	r, r, #4	//  push w to r, pre decrement r
 //	STR	w, [r]
.endm

.macro LIT2t
 // as in xeq token at ToS setup for lit
	LDR	t, [i], #4
 //      LDM	i!, {t}	// fetch memory p points to into {t}, inc i
.endm

.macro POPp2w
 // as in xeq token on ToS setup for exec
        LDR	w, [p], #4
 //      LDM	p!, {w}	// fetch memory p points to into {w}, inc p
.endm

.macro ILK reg

        ldr	\reg, [i], #4
.endm

