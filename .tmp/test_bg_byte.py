import os

sna_path = r"C:\Users\nicol\Documents\Progetti\asm\ZXSPECTRUM-JET SET WILLY\jet set willy.sna"
if not os.path.exists(sna_path):
    print("SNA file not found!")
    exit()

with open(sna_path, "rb") as f:
    sna_data = f.read()

ram = sna_data[27:]

# Room0Layout starts at 0x6F00 (which is 0x6F00 - 0x4000 = 0x2F00 in RAM dump)
ROOM0_LAYOUT = 0x6F00
RAM_OFFSET = ROOM0_LAYOUT - 0x4000

# Tile offsets relative to room_ptr
OFFSET_BG = 160
OFFSET_FLOOR = 169
OFFSET_WALL = 178
OFFSET_NASTY = 187

def get_layout_byte(r, c_group):
    offset = r * 8 + c_group
    addr = RAM_OFFSET + offset
    return ram[addr]

def get_tile_byte(cell_type, s):
    if cell_type == 0:
        offset = OFFSET_BG
    elif cell_type == 1:
        offset = OFFSET_FLOOR
    elif cell_type == 2:
        offset = OFFSET_WALL
    else:
        offset = OFFSET_NASTY
    
    # 1 byte attribute + 8 bytes bitmap
    addr = RAM_OFFSET + offset + 1 + s
    return ram[addr]

def get_background_byte(x, y):
    if y < 24 or y >= 152:
        return 0
    
    r = (y - 24) // 8
    c = x // 8
    
    layout_byte = get_layout_byte(r, c // 4)
    
    # Rotate logic
    bit_offset = c % 4
    rot = (bit_offset + 1) % 4
    
    # Rotate left by rot * 2 bits
    val = layout_byte
    for _ in range(rot):
        # 8-bit rotate left by 2
        val = ((val << 2) | (val >> 6)) & 0xFF
    
    cell_type = val & 3
    s = y % 8
    return cell_type, get_tile_byte(cell_type, s)

# Let's test for X = 136 (col 17) and Y from 24 to 151
print("Testing X = 136 (col 17):")
print(f"col % 4 = {17 % 4}, col // 4 = {17 // 4}")
for y in range(24, 152):
    cell_type, val = get_background_byte(136, y)
    # Print only if it's not background
    if cell_type != 0:
        print(f"Y={y:3d} (Row {(y-24)//8:2d}, scanline {y%8}): CellType={cell_type}, ByteVal={val}")

# Let's test for X = 40 (col 5)
print("\nTesting X = 40 (col 5):")
for y in range(24, 152):
    cell_type, val = get_background_byte(40, y)
    if cell_type != 0:
        print(f"Y={y:3d} (Row {(y-24)//8:2d}, scanline {y%8}): CellType={cell_type}, ByteVal={val}")
