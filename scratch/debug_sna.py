import struct, re

sna_path = "jet set willy.sna"
with open(sna_path, "rb") as f:
    sna_data = f.read()

def ram_offset(addr):
    return 27 + (addr - 0x4000)

def get_bytes(addr, count):
    off = ram_offset(addr)
    return sna_data[off:off+count]

# Parse SLD file for symbol locations
symbols = {}
with open("jet set willy.sld", "r") as f:
    for line in f:
        parts = line.strip().split("|")
        # Format: file|line|col|is_def|is_used|addr|type|name
        if len(parts) >= 8 and parts[6] == "F":
            name = parts[7]
            addr = int(parts[5])
            symbols[name] = addr

print("--- Symbol Addresses ---")
for name in ["start", "Main", "LoadRoomAndRestart", "SetupIM2", "Clock_Init", "Clock_Update", "Gfx_DrawClockDirect", "Gfx_PrintRoomName", "status_line", "clock_hours", "clock_minutes", "clock_frame_timer", "counter", "last_clock_counter"]:
    if name in symbols:
        print(f"{name:25s}: {symbols[name]:#06x}")

# Print bytes at start and Main
if "start" in symbols:
    st_bytes = get_bytes(symbols["start"], 16)
    print(f"Bytes at start ({symbols['start']:#06x}): {' '.join(f'{b:02X}' for b in st_bytes)}")

if "Main" in symbols:
    m_bytes = get_bytes(symbols["Main"], 32)
    print(f"Bytes at Main ({symbols['Main']:#06x}): {' '.join(f'{b:02X}' for b in m_bytes)}")

if "Clock_Init" in symbols:
    ci_bytes = get_bytes(symbols["Clock_Init"], 32)
    print(f"Bytes at Clock_Init ({symbols['Clock_Init']:#06x}): {' '.join(f'{b:02X}' for b in ci_bytes)}")

if "Clock_Update" in symbols:
    cu_bytes = get_bytes(symbols["Clock_Update"], 32)
    print(f"Bytes at Clock_Update ({symbols['Clock_Update']:#06x}): {' '.join(f'{b:02X}' for b in cu_bytes)}")
