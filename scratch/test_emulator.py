import z80, struct

with open("jet set willy.sna", "rb") as f:
    sna_data = f.read()

m = z80.Z80Machine()
m.memory[0x4000:0x10000] = sna_data[27:27+49152]
m.memory[0x0000:0x4000] = bytes([0xC9] * 0x4000)

m.sp = struct.unpack("<H", sna_data[23:25])[0]
sp_off = 27 + (m.sp - 0x4000)
pushed_pc = struct.unpack("<H", sna_data[sp_off:sp_off+2])[0]
m.pc = pushed_pc
m.sp += 2

symbols_by_addr = {}
with open("jet set willy.sld", "r") as f:
    for line in f:
        parts = line.strip().split("|")
        if len(parts) >= 8 and parts[6] == "F":
            symbols_by_addr[int(parts[5])] = parts[7]

step = 0
trace_history = []

print("Starting simulation...")
while step < 500000:
    pc_before = m.pc
    
    # Check if reset
    if m.pc == 0x0000:
        print(f"\nRESET DETECTED at step {step}! Previous PC: {pc_before:#06x} ({symbols_by_addr.get(pc_before, 'unknown')})")
        print("Last 20 instructions visited before reset:")
        for t_pc, t_sp in trace_history[-20:]:
            name = symbols_by_addr.get(t_pc, '')
            print(f"  PC: {t_pc:#06x} (SP: {t_sp:#06x}) {name}")
        break

    # Handle RETI (0xED 0x4D) in RAM
    if m.memory[m.pc] == 0xED and m.memory[m.pc+1] == 0x4D:
        sp = m.sp
        ret_addr = m.memory[sp] | (m.memory[sp+1] << 8)
        m.sp += 2
        m.pc = ret_addr
        step += 1
        continue

    m.ticks_to_stop = 1
    m.run()
    step += 1
    
    trace_history.append((pc_before, m.sp))
    if len(trace_history) > 100:
        trace_history.pop(0)

    # Simulate IM2 interrupt every 1000 steps
    if step % 1000 == 0:
        sp = m.sp - 2
        m.memory[sp] = m.pc & 0xFF
        m.memory[sp+1] = (m.pc >> 8) & 0xFF
        m.sp = sp
        m.pc = 0xFDFD

print(f"Simulation finished after {step} steps. Current PC: {m.pc:#06x}")
