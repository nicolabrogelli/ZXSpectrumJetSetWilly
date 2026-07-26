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

symbols = {}
with open("jet set willy.sld", "r") as f:
    for line in f:
        parts = line.strip().split("|")
        if len(parts) >= 8 and parts[6] == "F":
            symbols[int(parts[5])] = parts[7]

print(f"Start PC: {m.pc:#06x}")

main_addr = [k for k,v in symbols.items() if v == "Main"][0]
willy_dies_addr = [k for k,v in symbols.items() if v == "Main_loop.willy_dies"][0]
game_over_addr = [k for k,v in symbols.items() if v == "Main_loop.game_over"][0]

main_visits = 0

for step in range(50000):
    pc = m.pc
    
    if pc == main_addr:
        main_visits += 1
        print(f"[{step}] Hit Main (visit #{main_visits})!")
    elif pc == willy_dies_addr:
        print(f"[{step}] Hit willy_dies! willy_lives = {m.memory[0x7cda]}")
    elif pc == game_over_addr:
        print(f"[{step}] Hit game_over!")
        
    m.ticks_to_stop = 1
    m.run()
    
    # IM2 interrupt every 1000 ticks
    if step % 1000 == 0 and step > 0:
        m.sp -= 2
        m.memory[m.sp] = m.pc & 0xFF
        m.memory[m.sp+1] = (m.pc >> 8) & 0xFF
        m.pc = 0xFDFD

print(f"Finished 50000 steps. Main visits: {main_visits}")
