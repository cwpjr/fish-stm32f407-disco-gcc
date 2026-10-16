 //      FISH_STM32F4_SOC_INIT.s

 // ART init stuff
.equ DCEN, 0x00000400
.equ ICEN, 0x00000200
.equ PRFTEN, 0x00000100
.equ LATENCY_5WS, 0x00000005
.section .text, "ax", %progbits
.balign 4, 255
initART:
	.word DOCOL, strva, (ICEN | DCEN | PRFTEN | LATENCY_5WS), FLASH_ACR
	.word SEMIS


.section .text, "ax", %progbits
.balign 4, 255
copyintvecs:
	.word .+5
.section .text, "ax", %progbits
ldr y, =RAM_INTVECS
	mov	x, #0 // BOOT REMAP IN MAIN FLASH ALIASED AT 0
 //      mov32   x, = FLASH_START
	mov	k, #128
.thumb_func
_copyintvecs:
	ldr	w, [x], #4
	str	w, [y], #4
	subs	k, k, #1
	bne	_copyintvecs
	NEXT
.ltorg

 //HEADERLESS SoCinit:        ( -- )
 //      Initialize main subsystems here.
 //      Initialize SYSCLOCK to system clock frequency in Hz.
 //      Use of IRC, external xtal's and PLL done here.
 //      Initialize SYSTICK only to use system clock.
 //      SYSTICK eventually to be initiatlized for tasker IRQ.
 //      Enable CLKOUT.

.section .text, "ax", %progbits
.balign 4, 255
SoCinit:
  .word DOCOL
  .word copyintvecs
 // VTOR for 205 issue fixed in stm32F205RC.icf
 // VTOR_PATCH set in 205 config Options Assembly Preprocessor
#ifndef VTOR_PATCH
  .word strkk, RAM_INTVECS, VTOR
#endif

#ifdef SLOW_POWERUP
 // DELAY SIGNON MESSAGE OUTPUT UNTIL SERIAL BOARD POWERED UP
  .word LIT, 500, MS
#endif

 //---------------------------XRC HCLK PCLK1 AND PCLK2---------------------------
#if STM32F4_XRC08_168MHZ | STM32F205RC_XRC10_118MHZ

  .word atk,RCC_CR, ork,1, strk,RCC_CR
  .word strva,0,RCC_CFGR
  .word atk,RCC_CR, andk,0x0FEF6FFFF, strk,RCC_CR
  .word strva,0x24003010,RCC_PLLCFGR
  .word atk,RCC_CR, andk,0x0FFFBFFFF, strk,RCC_CR
  .word strva,0,RCC_CIR

.equ RCC_CR_HSEON, 0x00010000

  .word atk,RCC_CR, ork,RCC_CR_HSEON, strk,RCC_CR

.equ RCC_CR_HSERDY, 0x00020000
  .word begin, atk,RCC_CR, andk,RCC_CR_HSERDY, until

.equ RCC_APB1ENR_PWREN, 0x10000000
.equ PWR_CR_PMODE, 0x4000

 // Enable high performance mode, System frequency up to 168 MHz
  .word atk,RCC_APB1ENR, ork, RCC_APB1ENR_PWREN, strk,RCC_APB1ENR
  .word atk,PWR_CR, ork,PWR_CR_PMODE, strk,PWR_CR

.equ RCC_CFGR_HPRE_DIV1, 0x00000000
.equ RCC_CFGR_PPRE2_DIV2, 0x00008000
.equ RCC_CFGR_PPRE1_DIV4, 0x00001400

 // DEFINE OTHER SYSTEM CLOCKS FOR USER AND BAUD CALC
 // PCLK2 = HCLK / 2
 // PCLK2 = USB PCLK1 = UART
  .word LIT, RCC_CFGR, LIT, RCC_CFGR_HPRE_DIV1, SETBITS
  .word LIT, RCC_CFGR, LIT, RCC_CFGR_PPRE2_DIV2, SETBITS
  .word LIT, RCC_CFGR, LIT, RCC_CFGR_PPRE1_DIV4, SETBITS
.equ PCLK2, SYSTEMCLOCK / 2
.equ PCLK1, SYSTEMCLOCK / 4
 //STM32F205RC_XRC10_118MHZ
 //PCLK2   EQU     59000000        // 38444C0h
 //PCLK1   EQU     29500000        // 1C22260h
 // STM32F4_XRC08_168MHZ
 //PCLK2   EQU     84000000        // 501BD00h
 //PCLK1   EQU     42000000        // 280DE80h


/* VIC: OK, I figured out what I was trying to do... 't'was a failed experiment.
"Magic" 157 MHz won't work (even with a different xtal)
because it would bugger-up the USB, which *needs* 48 MHz.
Right now WITH THESE PLL SETTINGS the clock is in fact 144 MHz.
.equ PLL_Mbits, 4
.equ PLL_N, 144
.equ PLL_Nbits, (PLL_N << 6)
.equ PLL_P, 2
.equ PLL_Pbits, (((PLL_P >> 1) -1) << 16)
.equ PLL_Q, 6
.equ PLL_Qbits, (PLL_Q << 24)
*/

 // This is for 168MHz HCLK | SYSCLK PCLK2 = 134MHz PCLK1 = 42MHz
 // pROTOTYPING STP RPM 205 CLOCK
#ifdef STM32F205RC_XRC10_118MHZ

 //PLL_Mbits       EQU     5
 //PLL_N           EQU     118
 // STMCUBE says 10 * 236
.equ PLL_Mbits, 10
.equ PLL_N, 236
.equ PLL_Nbits, (PLL_N << 6)
.equ PLL_P, 2
.equ PLL_Pbits, (((PLL_P >> 1) -1) << 16)
.equ PLL_Q, 5
.equ PLL_Qbits, (PLL_Q << 24)
#endif
#ifdef STM32F4_XRC08_168MHZ
.equ PLL_Mbits, 8
.equ PLL_N, 336
 //or
 //PLL_Mbits       EQU     4
 //PLL_N           EQU     168

.equ PLL_Nbits, (PLL_N << 6)
.equ PLL_P, 2
.equ PLL_Pbits, (((PLL_P >> 1) -1) << 16)
.equ PLL_Q, 7
.equ PLL_Qbits, (PLL_Q << 24)
#endif

.equ RCC_PLLCFGR_PLLSRC_HSE, 0x00400000

  .word strkk,(PLL_Mbits | PLL_Nbits | PLL_Pbits | RCC_PLLCFGR_PLLSRC_HSE | PLL_Qbits), RCC_PLLCFGR

.equ RCC_CR_PLLON, 0x01000000

  .word atk,RCC_CR, ork,RCC_CR_PLLON, strk,RCC_CR

.equ RCC_CR_PLLRDY, 0x02000000
  .word begin, atk,RCC_CR, andk,RCC_CR_PLLRDY, until
  .word initART

.equ RCC_CFGR_SW, 0x00000003
.equ RCC_CFGR_SW_PLL, 0x00000002


  .word atk,RCC_CFGR, andk,(~RCC_CFGR_SW), strk,RCC_CFGR
  .word atk,RCC_CFGR, ork,RCC_CFGR_SW_PLL, strk,RCC_CFGR

.equ RCC_CFGR_SWS, 0x0000000C
.equ RCC_CFGR_SWS_PLL, 0x00000008


  .word begin, atk,RCC_CFGR,andk,RCC_CFGR_SWS, LIT,RCC_CFGR_SWS_PLL, EQUAL, until

.equ RCC_CFGR_I2SSRC, 0x00800000
 //* PLLI2S clock used as I2S clock source */
 //RCC->CFGR &= ~RCC_CFGR_I2SSRC

.equ PLLI2S_N, 192
.equ PLLI2S_Nbits, (PLLI2S_N << 6)
.equ PLLI2S_R, 5
.equ PLLI2S_Rbits, (PLLI2S_R << 28)

  .word strkk,(PLLI2S_Nbits | PLLI2S_Rbits), RCC_PLLI2SCFGR

.equ RCC_CR_PLLI2SON, 0x04000000
.equ RCC_CR_PLLI2SRDY, 0x08000000

  .word atk,RCC_CR, ork,RCC_CR_PLLI2SON, strk,RCC_CR
  .word begin, atk,RCC_CR, andk,RCC_CR_PLLI2SRDY, until

#endif // #if STM32F4_XRC08_168MHZ | STM32F205RC_XRC10_118MHZ

 // Set SYSCLOCK = SYSTEMCLOCK defined in FISH_STM32F4_EQUATES.s
 // in Assembler -> Preprocessor -> Defined Symbols
  .word strva, SYSTEMCLOCK, SYSCLOCK

 //------------------------USART3 & GPIO I/O-------------------------------------
 // SETUP USART3 I/O FOR UART3_INIT
 //      SETBITS SETBITS:	( addr val -- ) OR val bits into addr.
 //  DC32  LIT, RCC_AHB1ENR, LIT, 5h, SETBITS
  .word LIT, RCC_AHB1ENR, LIT, 0b10000111, SETBITS

 // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 // ADD GPIO CLK to C include GPIOH to use XRC as GPIO clk
  .word LIT, RCC_APB1ENR, LIT, 0x40000, SETBITS
 // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  .word strva, 0x00007700, GPIOC_AFRH

 // rmwamd standalone low level ILK macro and rmwamd prim.
 // STM DISCO BOARD:    Pc10 TX, pc11 RX, PC0 GND
  .word rmwamd, GPIOC_MODER,0x00F00003,0x00A00001
  .word strva, 0x200C, USART3_CR1

 //---------------------------USART3_INIT TEST-----------------------------------
/*
 // SET BAUD HERE FOR TESTING CHANGE OF BAUD IN UART3_INIT
 // OVER8=0 = 16x OVERSAMPLING
#ifdef STM32F4_XRC08_168MHZ
BAUDRATE	SET	((273 << 4 | 7))
 //BAUDRATE	SET	((136 << 8 | 11))
 //BAUDRATE	SET	((45 << 6 | 13))
 //BAUDRATE	SET	((22 << 4 | 8))
#endif
#ifdef STM32F4_IRC16_16MHZ
 // 682h DIV_Mantissa = 68H DIV_fraction = 2
BAUDRATE        SET     ((104 << 4 | 2))
#endif
  .word strva, BAUDRATE, USART3_BRR
*/

#ifdef XON_XOFF
 // Asign CTS signal pin
#endif

#ifdef CTS_RTS
 // Assign RTS = OUTPUT CTS = INPUT signals to pins
#endif

#ifdef CLKOUT
 // Turn CLKOUT on and SET divide by...
#endif

 // SYSTICK SECTION: (SysTick uses the processor clock.)
 // SYST_RVR (Reload value) not set until user does with MS or DELAY.
 // SYSTICK TIMER ENABLE: Bit 0 = 1
 // SYSTICK CLKSOURCE: Bit 2 = 0 (SYSTEM CLOCK/2 OR 8)
 // SYSTICK CLKSOURCE: Bit 2 = 1 (SYSTEM CLOCK)
 //  DC32    strva, 5, SYST_CSR    // SYSCLK NO IRQ
  .word strva, 7, SYST_CSR

  .word SEMIS
