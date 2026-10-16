#!/usr/bin/env python3
"""Boot FISH STM32F407vg Discovery under Renode and exercise the console.

Prerequisite: Renode running headless with a monitor socket:

    renode --disable-xwt -P 44001 &

Then:  python3 tools/run_renode.py

Creates the machine from Renode's stm32f4_discovery platform, adds the
CCM RAM region the platform file lacks, loads build/gcc/fish.elf, routes
USART3 to a TCP console, prints the signon, and issues WORDS.

Note: attach the console client BEFORE 'start' and keep sockets open for
the session - Renode's SocketServerProvider does not survive client
reconnects.
"""

import socket
import sys
import time
from pathlib import Path

MON = ("127.0.0.1", 44001)
UART = ("127.0.0.1", 44002)
ELF = Path(__file__).resolve().parent.parent / "build" / "gcc" / "fish.elf"

m = socket.socket()
m.settimeout(10)
m.connect(MON)
time.sleep(0.5)
try:
    m.recv(65536)
except socket.timeout:
    pass


def mon(cmd, wait=0.8):
    m.sendall((cmd + "\n").encode())
    time.sleep(wait)
    m.settimeout(0.7)
    out = b""
    try:
        while True:
            c = m.recv(65536)
            if not c:
                break
            out += c
    except socket.timeout:
        pass
    m.settimeout(10)
    return out.decode(errors="replace")


for cmd, w in [
    ('mach create "fish"', 1.0),
    ("machine LoadPlatformDescription"
     " @platforms/boards/stm32f4_discovery.repl", 2.5),
    ('machine LoadPlatformDescriptionFromString'
     ' "ccm: Memory.MappedMemory @ sysbus 0x10000000 { size: 0x10000 }"', 1.0),
    (f"sysbus LoadELF @{ELF}", 2.0),
    ('emulation CreateServerSocketTerminal 44002 "uart3" false', 1.0),
    ("connector Connect sysbus.usart3 uart3", 1.0),
]:
    r = mon(cmd, w)
    bad = [l for l in r.splitlines() if "rror" in l or "not" in l.lower()]
    print(f">>> {cmd[:60]}", "|", bad[0][:80] if bad else "ok")

u = socket.socket()
u.settimeout(6)
for _ in range(20):
    try:
        u.connect(UART)
        break
    except OSError:
        time.sleep(0.4)
else:
    print("console never came up")
    sys.exit(1)
print("console attached")

print(mon('mach set "fish"; start', 1.5)[-120:])
time.sleep(4)
data = b""
try:
    while True:
        c = u.recv(4096)
        if not c:
            break
        data += c
        if len(data) > 4000:
            break
except socket.timeout:
    pass
print("SIGNON:", repr(data[:400]))

if data:
    u.sendall(b"WORDS\r")
    time.sleep(6)
    data2 = b""
    try:
        while True:
            c = u.recv(8192)
            if not c:
                break
            data2 += c
            if len(data2) > 9000:
                break
    except socket.timeout:
        pass
    print("WORDS:", repr(data2[:2000]))

u.shutdown(socket.SHUT_WR)
mon("quit", 0.5)
m.close()
u.close()
