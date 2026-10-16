# FISH Forth for STM32F407VG Discovery (GNU Arm build)

A standalone GNU Arm Embedded build of **FISH** — a 32-bit flash-resident
Forth for ARM Cortex-M — for the STM32F407VG Discovery board, 168 MHz,
`FISH_PubRel_WORDSET` + `FISH_Debug_WORDSET` configuration.

FISH is an F83-derived Forth by Clyde W. Phillips Jr. and A-TEAM FORTH.

## Build

Requires `arm-none-eabi-gcc`, `arm-none-eabi-objcopy`, `arm-none-eabi-nm`,
GNU Make:

```bash
make clean all
make size
```

Artifacts are written to `build/gcc/`: `fish.elf`, `fish.hex` (flash this),
`fish.sym`, `fish.map`. Links with `stm32f407vg_gnu.ld`.

## Console

Serial terminal on USART3: 9600 bps 8n1 by default, XON/XOFF flow control.
Boot prints the FISH signon; `WORDS` lists the dictionary by WORDCAT
category and ends at `NOOP`.

## Run in emulation (Renode)

The image boots to the FISH REPL under
[Renode](https://renode.io) (tested with 1.17 portable):

```bash
# start Renode with a monitor socket
renode --disable-xwt -P 44001 &
# boot, capture the signon, and issue WORDS on the emulated UART3 console
python3 tools/run_renode.py
```

The driver creates the machine from Renode's `stm32f4_discovery`
platform, adds the CCM RAM region (`0x10000000`, 64 KB) the platform
file lacks, loads `build/gcc/fish.elf`, and routes USART3 to a TCP
console on port 44002.

QEMU's `netduinoplus2` does not work for a full boot: its RCC model never
sets HSE/PLL ready bits, so the 168 MHz clock init never completes, and no
USART is wired to a chardev.

## Layout

- `FISH_STM32F4_Forth_GNU.S` — Forth engine and dictionary (GNU syntax)
- `startup_stm32f4xx_gnu.S` / `FISH_STM32F4_STARTUP.s` — vectors, startup
- `FISH_STM32F4_SOC_INIT.s` — clock/SoC init thread (168 MHz from 8 MHz HSE)
- `FISH_STM32F4_UART3_INIT.s` — USART3 init
- `FISH_STM32F4_FLASH.s` — FLASH_SAVE / FLASH_FORGET
- `main.c` — CMSIS reset/IRQ helpers; `core_cm*.h`, `stm32f4xx.h` headers
- `generated/` — IAR-to-GNU translation intermediates (reference)
- `tools/run_renode.py` — Renode driver (see above)

## Notes

- Dictionary-header cells and headerless Forth tokens are `.balign 4`-
  aligned; the inner interpreter computes CFA cells by rounding tokens
  down (`BIC w, w, #3`). Do not remove the `.balign 4, 255` lines, and
  never insert padding between an LFA `.word` and its CFA cell.
- Config defines live in `FISH_RM_CONFIG_#DEFINES.h`.
