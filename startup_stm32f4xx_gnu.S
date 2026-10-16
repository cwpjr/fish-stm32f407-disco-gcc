.syntax unified
.cpu cortex-m4
.thumb




















































#define CMSIS_C // __weak void HardFault_Handler( void ) { NVIC_SystemReset()
 //#define CMSIS_ASM

 //      MODULE  ?cstartup       //????


.section CSTACK, "aw", %nobits

 //        SECTION .intvec:CODE:NOROOT(2)
.section .intvec, "a", %progbits

.extern __iar_program_start
.extern FM3_COLD
.extern FMx_SYSTICK_ISR
#ifdef CMSIS_C
.extern HardFault_Handler
#endif
.extern NVIC_SystemReset

.global __vector_table

__vector_table:
        .word _estack


        .word Reset_Handler
        .word NMI_Handler
        .word HardFault_Handler
        .word MemManage_Handler
        .word BusFault_Handler
        .word UsageFault_Handler
        .word 0
        .word 0
        .word 0
        .word 0
        .word SVC_Handler
        .word DebugMon_Handler
        .word 0
        .word PendSV_Handler
        .word SysTick_Handler


        .word WWDG_IRQHandler
        .word PVD_IRQHandler
        .word TAMP_STAMP_IRQHandler
        .word RTC_WKUP_IRQHandler
        .word FLASH_IRQHandler
        .word RCC_IRQHandler
        .word EXTI0_IRQHandler
        .word EXTI1_IRQHandler
        .word EXTI2_IRQHandler
        .word EXTI3_IRQHandler
        .word EXTI4_IRQHandler
        .word DMA1_Stream0_IRQHandler
        .word DMA1_Stream1_IRQHandler
        .word DMA1_Stream2_IRQHandler
        .word DMA1_Stream3_IRQHandler
        .word DMA1_Stream4_IRQHandler
        .word DMA1_Stream5_IRQHandler
        .word DMA1_Stream6_IRQHandler
        .word ADC_IRQHandler
        .word CAN1_TX_IRQHandler
        .word CAN1_RX0_IRQHandler
        .word CAN1_RX1_IRQHandler
        .word CAN1_SCE_IRQHandler
        .word EXTI9_5_IRQHandler
        .word TIM1_BRK_TIM9_IRQHandler
        .word TIM1_UP_TIM10_IRQHandler
        .word TIM1_TRG_COM_TIM11_IRQHandler
        .word TIM1_CC_IRQHandler
        .word TIM2_IRQHandler
        .word TIM3_IRQHandler
        .word TIM4_IRQHandler
        .word I2C1_EV_IRQHandler
        .word I2C1_ER_IRQHandler
        .word I2C2_EV_IRQHandler
        .word I2C2_ER_IRQHandler
        .word SPI1_IRQHandler
        .word SPI2_IRQHandler
        .word USART1_IRQHandler
        .word USART2_IRQHandler
        .word USART3_IRQHandler
        .word EXTI15_10_IRQHandler
        .word RTC_Alarm_IRQHandler
        .word OTG_FS_WKUP_IRQHandler
        .word TIM8_BRK_TIM12_IRQHandler
        .word TIM8_UP_TIM13_IRQHandler
        .word TIM8_TRG_COM_TIM14_IRQHandler
        .word TIM8_CC_IRQHandler
        .word DMA1_Stream7_IRQHandler
        .word FSMC_IRQHandler
        .word SDIO_IRQHandler
        .word TIM5_IRQHandler
        .word SPI3_IRQHandler
        .word UART4_IRQHandler
        .word UART5_IRQHandler
        .word TIM6_DAC_IRQHandler
        .word TIM7_IRQHandler
        .word DMA2_Stream0_IRQHandler
        .word DMA2_Stream1_IRQHandler
        .word DMA2_Stream2_IRQHandler
        .word DMA2_Stream3_IRQHandler
        .word DMA2_Stream4_IRQHandler
        .word ETH_IRQHandler
        .word ETH_WKUP_IRQHandler
        .word CAN2_TX_IRQHandler
        .word CAN2_RX0_IRQHandler
        .word CAN2_RX1_IRQHandler
        .word CAN2_SCE_IRQHandler
        .word OTG_FS_IRQHandler
        .word DMA2_Stream5_IRQHandler
        .word DMA2_Stream6_IRQHandler
        .word DMA2_Stream7_IRQHandler
        .word USART6_IRQHandler
        .word I2C3_EV_IRQHandler
        .word I2C3_ER_IRQHandler
        .word OTG_HS_EP1_OUT_IRQHandler
        .word OTG_HS_EP1_IN_IRQHandler
        .word OTG_HS_WKUP_IRQHandler
        .word OTG_HS_IRQHandler
        .word DCMI_IRQHandler
        .word CRYP_IRQHandler
        .word HASH_RNG_IRQHandler
        .word FPU_IRQHandler
AFT_INTVEC:




.thumb
.weak Reset_Handler
.section .text, "ax", %progbits
.thumb_func
Reset_Handler:
        B      FM3_COLD

.weak NMI_Handler
.section .text, "ax", %progbits
.thumb_func
NMI_Handler:
        B NMI_Handler

#ifdef CMSIS_ASM
.weak HardFault_Handler
.section .text, "ax", %progbits
.thumb_func
HardFault_Handler:

        B NVIC_SystemReset

#endif

.weak MemManage_Handler
.section .text, "ax", %progbits
.thumb_func
MemManage_Handler:
        B MemManage_Handler

.weak BusFault_Handler
.section .text, "ax", %progbits
.thumb_func
BusFault_Handler:
        B BusFault_Handler

.weak UsageFault_Handler
.section .text, "ax", %progbits
.thumb_func
UsageFault_Handler:
        B UsageFault_Handler

.weak SVC_Handler
.section .text, "ax", %progbits
.thumb_func
SVC_Handler:
        B SVC_Handler

.weak DebugMon_Handler
.section .text, "ax", %progbits
.thumb_func
DebugMon_Handler:
        B DebugMon_Handler

.weak PendSV_Handler
.section .text, "ax", %progbits
.thumb_func
PendSV_Handler:
        B PendSV_Handler

.weak SysTick_Handler
.section .text, "ax", %progbits
.thumb_func
SysTick_Handler:


        B FMx_SYSTICK_ISR

.weak WWDG_IRQHandler
.section .text, "ax", %progbits
.thumb_func
WWDG_IRQHandler:
        B WWDG_IRQHandler

.weak PVD_IRQHandler
.section .text, "ax", %progbits
.thumb_func
PVD_IRQHandler:
        B PVD_IRQHandler

.weak TAMP_STAMP_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TAMP_STAMP_IRQHandler:
        B TAMP_STAMP_IRQHandler

.weak RTC_WKUP_IRQHandler
.section .text, "ax", %progbits
.thumb_func
RTC_WKUP_IRQHandler:
        B RTC_WKUP_IRQHandler

.weak FLASH_IRQHandler
.section .text, "ax", %progbits
.thumb_func
FLASH_IRQHandler:
        B FLASH_IRQHandler

.weak RCC_IRQHandler
.section .text, "ax", %progbits
.thumb_func
RCC_IRQHandler:
        B RCC_IRQHandler

.weak EXTI0_IRQHandler
.section .text, "ax", %progbits
.thumb_func
EXTI0_IRQHandler:
        B EXTI0_IRQHandler

.weak EXTI1_IRQHandler
.section .text, "ax", %progbits
.thumb_func
EXTI1_IRQHandler:
        B EXTI1_IRQHandler

.weak EXTI2_IRQHandler
.section .text, "ax", %progbits
.thumb_func
EXTI2_IRQHandler:
        B EXTI2_IRQHandler

.weak EXTI3_IRQHandler
.section .text, "ax", %progbits
.thumb_func
EXTI3_IRQHandler:
        B EXTI3_IRQHandler

.weak EXTI4_IRQHandler
.section .text, "ax", %progbits
.thumb_func
EXTI4_IRQHandler:
        B EXTI4_IRQHandler

.weak DMA1_Stream0_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA1_Stream0_IRQHandler:
        B DMA1_Stream0_IRQHandler

.weak DMA1_Stream1_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA1_Stream1_IRQHandler:
        B DMA1_Stream1_IRQHandler

.weak DMA1_Stream2_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA1_Stream2_IRQHandler:
        B DMA1_Stream2_IRQHandler

.weak DMA1_Stream3_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA1_Stream3_IRQHandler:
        B DMA1_Stream3_IRQHandler

.weak DMA1_Stream4_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA1_Stream4_IRQHandler:
        B DMA1_Stream4_IRQHandler

.weak DMA1_Stream5_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA1_Stream5_IRQHandler:
        B DMA1_Stream5_IRQHandler

.weak DMA1_Stream6_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA1_Stream6_IRQHandler:
        B DMA1_Stream6_IRQHandler

.weak ADC_IRQHandler
.section .text, "ax", %progbits
.thumb_func
ADC_IRQHandler:
        B ADC_IRQHandler

.weak CAN1_TX_IRQHandler
.section .text, "ax", %progbits
.thumb_func
CAN1_TX_IRQHandler:
        B CAN1_TX_IRQHandler

.weak CAN1_RX0_IRQHandler
.section .text, "ax", %progbits
.thumb_func
CAN1_RX0_IRQHandler:
        B CAN1_RX0_IRQHandler

.weak CAN1_RX1_IRQHandler
.section .text, "ax", %progbits
.thumb_func
CAN1_RX1_IRQHandler:
        B CAN1_RX1_IRQHandler

.weak CAN1_SCE_IRQHandler
.section .text, "ax", %progbits
.thumb_func
CAN1_SCE_IRQHandler:
        B CAN1_SCE_IRQHandler

.weak EXTI9_5_IRQHandler
.section .text, "ax", %progbits
.thumb_func
EXTI9_5_IRQHandler:
        B EXTI9_5_IRQHandler

.weak TIM1_BRK_TIM9_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM1_BRK_TIM9_IRQHandler:
        B TIM1_BRK_TIM9_IRQHandler

.weak TIM1_UP_TIM10_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM1_UP_TIM10_IRQHandler:
        B TIM1_UP_TIM10_IRQHandler

.weak TIM1_TRG_COM_TIM11_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM1_TRG_COM_TIM11_IRQHandler:
        B TIM1_TRG_COM_TIM11_IRQHandler

.weak TIM1_CC_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM1_CC_IRQHandler:
        B TIM1_CC_IRQHandler

.weak TIM2_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM2_IRQHandler:
        B TIM2_IRQHandler

.weak TIM3_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM3_IRQHandler:
        B TIM3_IRQHandler

.weak TIM4_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM4_IRQHandler:
        B TIM4_IRQHandler

.weak I2C1_EV_IRQHandler
.section .text, "ax", %progbits
.thumb_func
I2C1_EV_IRQHandler:
        B I2C1_EV_IRQHandler

.weak I2C1_ER_IRQHandler
.section .text, "ax", %progbits
.thumb_func
I2C1_ER_IRQHandler:
        B I2C1_ER_IRQHandler

.weak I2C2_EV_IRQHandler
.section .text, "ax", %progbits
.thumb_func
I2C2_EV_IRQHandler:
        B I2C2_EV_IRQHandler

.weak I2C2_ER_IRQHandler
.section .text, "ax", %progbits
.thumb_func
I2C2_ER_IRQHandler:
        B I2C2_ER_IRQHandler

.weak SPI1_IRQHandler
.section .text, "ax", %progbits
.thumb_func
SPI1_IRQHandler:
        B SPI1_IRQHandler

.weak SPI2_IRQHandler
.section .text, "ax", %progbits
.thumb_func
SPI2_IRQHandler:
        B SPI2_IRQHandler

.weak USART1_IRQHandler
.section .text, "ax", %progbits
.thumb_func
USART1_IRQHandler:
        B USART1_IRQHandler

.weak USART2_IRQHandler
.section .text, "ax", %progbits
.thumb_func
USART2_IRQHandler:
        B USART2_IRQHandler

.weak USART3_IRQHandler
.section .text, "ax", %progbits
.thumb_func
USART3_IRQHandler:
        B USART3_IRQHandler

.weak EXTI15_10_IRQHandler
.section .text, "ax", %progbits
.thumb_func
EXTI15_10_IRQHandler:
        B EXTI15_10_IRQHandler

.weak RTC_Alarm_IRQHandler
.section .text, "ax", %progbits
.thumb_func
RTC_Alarm_IRQHandler:
        B RTC_Alarm_IRQHandler

.weak OTG_FS_WKUP_IRQHandler
.section .text, "ax", %progbits
.thumb_func
OTG_FS_WKUP_IRQHandler:
        B OTG_FS_WKUP_IRQHandler

.weak TIM8_BRK_TIM12_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM8_BRK_TIM12_IRQHandler:
        B TIM8_BRK_TIM12_IRQHandler

.weak TIM8_UP_TIM13_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM8_UP_TIM13_IRQHandler:
        B TIM8_UP_TIM13_IRQHandler

.weak TIM8_TRG_COM_TIM14_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM8_TRG_COM_TIM14_IRQHandler:
        B TIM8_TRG_COM_TIM14_IRQHandler

.weak TIM8_CC_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM8_CC_IRQHandler:
        B TIM8_CC_IRQHandler

.weak DMA1_Stream7_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA1_Stream7_IRQHandler:
        B DMA1_Stream7_IRQHandler

.weak FSMC_IRQHandler
.section .text, "ax", %progbits
.thumb_func
FSMC_IRQHandler:
        B FSMC_IRQHandler

.weak SDIO_IRQHandler
.section .text, "ax", %progbits
.thumb_func
SDIO_IRQHandler:
        B SDIO_IRQHandler

.weak TIM5_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM5_IRQHandler:
        B TIM5_IRQHandler

.weak SPI3_IRQHandler
.section .text, "ax", %progbits
.thumb_func
SPI3_IRQHandler:
        B SPI3_IRQHandler

.weak UART4_IRQHandler
.section .text, "ax", %progbits
.thumb_func
UART4_IRQHandler:
        B UART4_IRQHandler

.weak UART5_IRQHandler
.section .text, "ax", %progbits
.thumb_func
UART5_IRQHandler:
        B UART5_IRQHandler

.weak TIM6_DAC_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM6_DAC_IRQHandler:
        B TIM6_DAC_IRQHandler

.weak TIM7_IRQHandler
.section .text, "ax", %progbits
.thumb_func
TIM7_IRQHandler:
        B TIM7_IRQHandler

.weak DMA2_Stream0_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA2_Stream0_IRQHandler:
        B DMA2_Stream0_IRQHandler

.weak DMA2_Stream1_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA2_Stream1_IRQHandler:
        B DMA2_Stream1_IRQHandler

.weak DMA2_Stream2_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA2_Stream2_IRQHandler:
        B DMA2_Stream2_IRQHandler

.weak DMA2_Stream3_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA2_Stream3_IRQHandler:
        B DMA2_Stream3_IRQHandler

.weak DMA2_Stream4_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA2_Stream4_IRQHandler:
        B DMA2_Stream4_IRQHandler

.weak ETH_IRQHandler
.section .text, "ax", %progbits
.thumb_func
ETH_IRQHandler:
        B ETH_IRQHandler

.weak ETH_WKUP_IRQHandler
.section .text, "ax", %progbits
.thumb_func
ETH_WKUP_IRQHandler:
        B ETH_WKUP_IRQHandler

.weak CAN2_TX_IRQHandler
.section .text, "ax", %progbits
.thumb_func
CAN2_TX_IRQHandler:
        B CAN2_TX_IRQHandler

.weak CAN2_RX0_IRQHandler
.section .text, "ax", %progbits
.thumb_func
CAN2_RX0_IRQHandler:
        B CAN2_RX0_IRQHandler

.weak CAN2_RX1_IRQHandler
.section .text, "ax", %progbits
.thumb_func
CAN2_RX1_IRQHandler:
        B CAN2_RX1_IRQHandler

.weak CAN2_SCE_IRQHandler
.section .text, "ax", %progbits
.thumb_func
CAN2_SCE_IRQHandler:
        B CAN2_SCE_IRQHandler

.weak OTG_FS_IRQHandler
.section .text, "ax", %progbits
.thumb_func
OTG_FS_IRQHandler:
        B OTG_FS_IRQHandler

.weak DMA2_Stream5_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA2_Stream5_IRQHandler:
        B DMA2_Stream5_IRQHandler

.weak DMA2_Stream6_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA2_Stream6_IRQHandler:
        B DMA2_Stream6_IRQHandler

.weak DMA2_Stream7_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DMA2_Stream7_IRQHandler:
        B DMA2_Stream7_IRQHandler

.weak USART6_IRQHandler
.section .text, "ax", %progbits
.thumb_func
USART6_IRQHandler:
        B USART6_IRQHandler

.weak I2C3_EV_IRQHandler
.section .text, "ax", %progbits
.thumb_func
I2C3_EV_IRQHandler:
        B I2C3_EV_IRQHandler

.weak I2C3_ER_IRQHandler
.section .text, "ax", %progbits
.thumb_func
I2C3_ER_IRQHandler:
        B I2C3_ER_IRQHandler

.weak OTG_HS_EP1_OUT_IRQHandler
.section .text, "ax", %progbits
.thumb_func
OTG_HS_EP1_OUT_IRQHandler:
        B OTG_HS_EP1_OUT_IRQHandler

.weak OTG_HS_EP1_IN_IRQHandler
.section .text, "ax", %progbits
.thumb_func
OTG_HS_EP1_IN_IRQHandler:
        B OTG_HS_EP1_IN_IRQHandler

.weak OTG_HS_WKUP_IRQHandler
.section .text, "ax", %progbits
.thumb_func
OTG_HS_WKUP_IRQHandler:
        B OTG_HS_WKUP_IRQHandler

.weak OTG_HS_IRQHandler
.section .text, "ax", %progbits
.thumb_func
OTG_HS_IRQHandler:
        B OTG_HS_IRQHandler

.weak DCMI_IRQHandler
.section .text, "ax", %progbits
.thumb_func
DCMI_IRQHandler:
        B DCMI_IRQHandler

.weak CRYP_IRQHandler
.section .text, "ax", %progbits
.thumb_func
CRYP_IRQHandler:
        B CRYP_IRQHandler

.weak HASH_RNG_IRQHandler
.section .text, "ax", %progbits
.thumb_func
HASH_RNG_IRQHandler:
        B HASH_RNG_IRQHandler

.weak FPU_IRQHandler
.section .text, "ax", %progbits
.thumb_func
FPU_IRQHandler:
        B FPU_IRQHandler

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
