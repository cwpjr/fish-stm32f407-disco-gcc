 //------------------------------------------------------------------------------
 //$PROJ_DIR$\stm32F205RC.icf
 // This include begins the .sym file
#include "FISH_AUTHOR.h"
 // This include is for generic IAR stuff
#include "FISH_IAR.h"
 //------------------------------------------------------------------------------
 // Include STM32F4 SoC PERIPHERAL REGISTER ADDRESS FILES
#include "ioSTM32F4x7x.h" // Vic MODIFIED FOR STM32F4VG DISCO transformed from .ddf
 //------------------------------------------------------------------------------
#include "FISH_ARM_CORTEX_M_REGS.h"
#include "FISH_STM32F4_MACROS.h"
 //------------------------------------------------------------------------------
 // #defines for XON, -1 TRUE, IO2TP, etc.
 // COPY OF Assembler Preproccesor Defined Symbols for each configuration
#include "FISH_RM_CONFIG_#DEFINES.h"
 //------------------------------------------------------------------------------
 // FLASH, RAM, CLOCK Configurations:
 // Placed in each configurations ( Debug, etc )'s
#include "FISH_STM32F4_EQUATES.h" // #defines of FISH_M0_CONFIG_DEFINES.s
#include "FISH_STM32F4_MEMMAP.s" // SYSTEM AND USER MEMORY MAPPING
 //------------------------------------------------------------------------------
 // Place :NONAME's before dynamic content to make CFA addresses static.
#include "FISH_STM32F4_SLIB.s"
 // Main Include
#include "FISH_STM32F4_STARTUP.s"
