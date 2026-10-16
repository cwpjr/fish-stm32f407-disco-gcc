CROSS_COMPILE ?= arm-none-eabi-
CC := $(CROSS_COMPILE)gcc
OBJCOPY := $(CROSS_COMPILE)objcopy
SIZE := $(CROSS_COMPILE)size
NM := $(CROSS_COMPILE)nm

BUILD_DIR ?= build/gcc
CPUFLAGS := -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard
ASM_DEFINES := -DFISH_PubRel_WORDSET -DFISH_Debug_WORDSET -DSTM32F4_XRC08_168MHZ
CFLAGS := $(CPUFLAGS) -std=gnu11 -Os -ffreestanding -ffunction-sections -fdata-sections -fno-common -Wall -Wextra
ASFLAGS := $(CPUFLAGS) $(ASM_DEFINES) -I.
LDFLAGS := $(CPUFLAGS) -nostdlib -Wl,--gc-sections -Wl,-Map,$(BUILD_DIR)/fish.map -Tstm32f407vg_gnu.ld

FORTH_INCLUDES := \
	FISH_STM32F4_MAIN_INCLUDES.h \
	FISH_AUTHOR.h \
	FISH_IAR.h \
	ioSTM32F4x7x.h \
	FISH_ARM_CORTEX_M_REGS.h \
	FISH_STM32F4_MACROS.h \
	FISH_RM_CONFIG_\#DEFINES.h \
	FISH_STM32F4_EQUATES.h \
	FISH_STM32F4_MEMMAP.s \
	FISH_STM32F4_SLIB.s \
	FISH_STM32F4_STARTUP.s \
	FISH_STM32F4_Peripheral_Register_ADDRS.h \
	FISH_CO_MSGS.h \
	FISH_STM32F4_UART3_INIT.s \
	FISH_STM32F4_FLASH.s \
	FISH_RM_MSGS.h \
	FISH_STM32F4_SOC_INIT.s
OBJECTS := $(BUILD_DIR)/FISH_STM32F4_Forth_GNU.o $(BUILD_DIR)/startup_stm32f4xx_gnu.o $(BUILD_DIR)/main.o

.PHONY: all clean size
all: $(BUILD_DIR)/fish.hex $(BUILD_DIR)/fish.sym $(BUILD_DIR)/fish.map

$(BUILD_DIR)/FISH_STM32F4_Forth_GNU.o: FISH_STM32F4_Forth_GNU.S $(FORTH_INCLUDES)
	mkdir -p $(BUILD_DIR)
	$(CC) $(ASFLAGS) -c $< -o $@

$(BUILD_DIR)/startup_stm32f4xx_gnu.o: startup_stm32f4xx_gnu.S
	mkdir -p $(BUILD_DIR)
	$(CC) $(CPUFLAGS) -c $< -o $@

$(BUILD_DIR)/main.o: main.c stm32f4xx.h system_stm32f4xx.h core_cm4.h core_cm4_simd.h core_cmFunc.h core_cmInstr.h
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/fish.elf $(BUILD_DIR)/fish.map &: $(OBJECTS) stm32f407vg_gnu.ld
	$(CC) $(LDFLAGS) $(OBJECTS) -lgcc -o $(BUILD_DIR)/fish.elf

$(BUILD_DIR)/fish.hex: $(BUILD_DIR)/fish.elf
	$(OBJCOPY) -O ihex $< $@

$(BUILD_DIR)/fish.sym: $(BUILD_DIR)/fish.elf
	$(NM) -n -S $< > $@

size: $(BUILD_DIR)/fish.elf
	$(SIZE) $<

clean:
	rm -rf $(BUILD_DIR)