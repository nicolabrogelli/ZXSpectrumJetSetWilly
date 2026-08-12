"""Descend the Conservatory Roof ramp into Orangery, trace the transition."""
from z80 import Z80Machine

SNA = r"C:\Users\fausto.pracek\Desktop\Jet-Set-Willy-evolutiva\jet set willy.sna"
ROM = r"C:\Program Files (x86)\Fuse\roms\48.rom"
FRAME_TICKS = 69888

TRIGGER_ROOM_CHANGE = 0x695C
BEFORE_RAMP_CALL    = 0x69A4
AFTER_RAMP_CALL     = 0x69A7
LOAD_ROOM           = 0x8059

PLAYER_POS = 0xE626; ON_GROUND = 0xE635; VELOCITY_Y = 0xE634
ROOM_PTR = 0xE9A5; TRANSITION = 0xE9AB

CR = 0xB40A   # ConservatoryRoof (43)
OR = 0xAD56  # Orangery (37)

m = Z80Machine()
m.set_memory_block(0, open(ROM,'rb').read()[:0x4000])
sna = open(SNA,'rb').read()
ram = bytearray(sna[27:27+49152])
def poke(addr,*vals):
    for i,v in enumerate(vals): ram[addr-0x4000+i]=v
poke(ROOM_PTR, CR & 0xFF, CR >> 8)
poke(TRANSITION, 1)
poke(PLAYER_POS, 152, 48, 152, 48)   # on the CR ramp (ramp_Y(152)=48)
poke(ON_GROUND, 1)
m.set_memory_block(0x4000, ram)

def w16(b,i): return b[i] | (b[i+1]<<8)
hdr = sna[:27]
m._Z80State__ir[1] = hdr[0]
m.hl=w16(hdr,9); m.de=w16(hdr,11); m.bc=w16(hdr,13)
m.iy=w16(hdr,15); m.ix=w16(hdr,17); m.af=w16(hdr,21); m.sp=w16(hdr,23)
m._Z80State__int_mode[0]=hdr[25]
iff = 1 if (hdr[19]&4) else 0
m._Z80State__iff1[0]=iff; m._Z80State__iff2[0]=iff
mem = m.memory
m.pc = mem[m.sp] | (mem[m.sp+1]<<8); m.sp=(m.sp+2)&0xFFFF

left_held = [False]
def inp(port):
    if (port & 0xFF) != 0xFE: return 0xFF
    if ((port>>8)&0xFF) == 0xDF and left_held[0]: return 0xFD  # O = left (bit 1)
    return 0xFF
m.set_input_callback(inp)
m.set_output_callback(lambda *a: None)
m.set_get_int_vector_callback(lambda *a: 0xFF)

frame_no=[0]; events=[]
def dump(tag):
    x,y = mem[PLAYER_POS], mem[PLAYER_POS+1]
    events.append(f"f{frame_no[0]:4d} {tag}: pos=({x},{y}) B={m.b} C={m.c} A={m.a} ong={mem[ON_GROUND]}")

BP = {TRIGGER_ROOM_CHANGE:"TriggerRoomChange", BEFORE_RAMP_CALL:"beforeCheckRamp ",
      AFTER_RAMP_CALL:"afterCheckRamp  ", LOAD_ROOM:"LoadRoom        "}
for a in BP: m.set_breakpoint(a)

def run_frame():
    m.ticks_to_stop = FRAME_TICKS
    while True:
        ev = m.run()
        if ev & 2:
            dump(BP.get(m.pc, f"@{m.pc:04X}"))
            continue
        break
    m.on_handle_active_int()
    frame_no[0]+=1

for _ in range(8): run_frame()
x,y = mem[PLAYER_POS], mem[PLAYER_POS+1]
print(f"start in CR: pos=({x},{y}) ong={mem[ON_GROUND]}")
events.clear()

left_held[0]=True
pos_log=[]; changed=0
for i in range(700):
    run_frame()
    x,y = mem[PLAYER_POS], mem[PLAYER_POS+1]
    rp = mem[ROOM_PTR]|(mem[ROOM_PTR+1]<<8)
    pos_log.append((frame_no[0],x,y,mem[ON_GROUND],rp))
    if rp != CR: changed += 1
    if changed > 120: break

print("\n--- breakpoint trace ---")
for e in events: print(e)

print("\n--- positions around transition ---")
tr = next((j for j,p in enumerate(pos_log) if p[4] != CR), None)
if tr is None:
    print("(no transition)"); [print(p) for p in pos_log[::20]]
else:
    for p in pos_log[max(0,tr-10):tr+50]:
        print(f"f{p[0]:4d} X={p[1]:3d} Y={p[2]:3d} ong={p[3]} room={p[4]:04X}")
