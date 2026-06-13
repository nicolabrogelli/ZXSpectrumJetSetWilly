import os

sna_path = r"C:\Users\nicol\Documents\Progetti\asm\ZXSPECTRUM-JET SET WILLY\jet set willy.sna"
if not os.path.exists(sna_path):
    print("SNA file not found!")
    exit()

with open(sna_path, "rb") as f:
    sna_data = f.read()

# Header is 27 bytes
ram = sna_data[27:]
print(f"RAM size in snapshot: {len(ram)} bytes")

# Screen memory is at the start of RAM ($4000)
# Bitmap: 6144 bytes ($4000-$57FF)
# Attributes: 768 bytes ($5800-$5BFF)
bitmap = ram[0:6144]
attributes = ram[6144:6912]

# Decode attributes to character grid (24 rows x 32 cols)
grid = []
for r in range(24):
    row_str = ""
    for c in range(32):
        attr = attributes[r * 32 + c]
        # In ZX Spectrum:
        # bit 7: flash, bit 6: bright, bits 3-5: paper, bits 0-2: ink
        ink = attr & 7
        paper = (attr >> 3) & 7
        
        # Let's check if the bitmap has any pixels set in this cell
        has_pixels = False
        for s in range(8):
            # Compute address for row r, column c, scanline s
            third = r // 8
            char_row_in_third = r % 8
            addr = (third << 11) + (s << 8) + (char_row_in_third << 5) + c
            if bitmap[addr] != 0:
                has_pixels = True
                break
        
        if not has_pixels:
            row_str += " " # empty space
        else:
            # Map ink color to a character
            # 0: Black, 1: Blue, 2: Red, 3: Magenta, 4: Green, 5: Cyan, 6: Yellow, 7: White
            color_map = {0: "k", 1: "b", 2: "R", 3: "m", 4: "G", 5: "C", 6: "Y", 7: "w"}
            row_str += color_map.get(ink, "?")
    grid.append(row_str)

print("Screen Attribute / Pixel Grid (32x24):")
print("-" * 34)
for idx, row in enumerate(grid):
    print(f"{idx:02d}|{row}|")
print("-" * 34)
