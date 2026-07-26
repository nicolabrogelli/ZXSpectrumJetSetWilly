import z80, struct

# Load SNA
with open("jet set willy.sna", "rb") as f:
    sna_data = f.read()

m = z80.Z80Machine()

# Load 48K RAM
m.memory[0x4000:0x10000] = sna_data[27:27+49152]

# Load dummy ROM (0xC9 = RET, 0x00 = NOP)
m.memory[0x0000:0x4000] = bytes([0xC9] * 0x4000)

# Set registers from SNA
m.sp = struct.unpack("<H", sna_data[23:25])[0]
sp_off = 27 + (m.sp - 0x4000)
pushed_pc = struct.unpack("<H", sna_data[sp_off:sp_off+2])[0]
m.pc = pushed_pc
m.sp += 2

# Load SLD symbols
symbols = {}
with open("jet set willy.sld", "r") as f:
    for line in f:
        parts = line.strip().split("|")
        if len(parts) >= 8 and parts[6] == "F":
            symbols[int(parts[5])] = parts[7]

print(f"Start PC: {m.pc:#06x}, SP: {m.sp:#06x}")

# Track execution
visited_pcs = []
bad_access = False

for step in range(500000):
    pc = m.pc
    sp = m.sp
    
    # Check if PC jumped to illegal RAM or ROM reset
    if pc < 0x4000:
        print(f"\nCRASH/RESET DETECTED at step {step}! PC = {pc:#06x}")
        print("Recent visited PCs:")
        for v_pc, v_sp in visited_pcs[-15:]:
            name = symbols.get(v_pc, "")
            print(f"  PC: {v_pc:#06x} (SP: {v_sp:#06x}) {name}")
        bad_access = True
        break
        
    visited_pcs.append((pc, sp))
    if len(visited_pcs) > 50:
        visited_pcs.pop(0)

    # Execute 1 step
    m.ticks_to_stop = 1
    m.run()
    
    # Simulate IM2 interrupt every 500 steps
    if step % 500 == 0 and step > 0:
        # Push PC onto stack and jump to IM2_VECTOR (0xFDFD)
        m.sp -= 2
        m.memory[m.sp] = m.pc & 0xFF
        m.memory[m.sp+1] = (m.pc >> 8) & 0xFF
        m.pc = 0xFDFD

if not bad_access:
    print(f"Executed {step} steps WITHOUT crash! Final PC: {m.pc:#06x} ({symbols.get(m.pc, '')})")
