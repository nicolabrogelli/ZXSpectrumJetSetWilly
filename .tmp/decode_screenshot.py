import os
from PIL import Image

img_path = r"C:\Users\nicol\Documents\Progetti\asm\ZXSPECTRUM-JET SET WILLY\documentation\errori\errore1.bmp"
if not os.path.exists(img_path):
    print("Screenshot not found!")
    exit()

img = Image.open(img_path).convert("RGB")
w, h = img.size
print(f"Image dimensions: {w}x{h}")

# Let's downsample the image to a grid of 64x48 or similar, or find the active game screen.
# A ZX Spectrum screen is 4:3. Let's find the bounding box of the active game area.
# In JSW, the background is black, but there is a border.
# Let's print the RGB values at some grid points to understand the layout.

# Downscale to 32x24 grid of characters to print
small_img = img.resize((32, 24), Image.Resampling.NEAREST)

def get_char(rgb):
    r, g, b = rgb
    # Map to simple color names
    # Black: (0,0,0)
    # Red: high R, low G/B
    # Green: high G, low R/B
    # Blue: high B, low R/G
    # Yellow: high R/G, low B
    # Cyan: high G/B, low R
    # Magenta: high R/B, low G
    # White: high R/G/B
    # Grey: medium R/G/B
    if r < 40 and g < 40 and b < 40:
        return " " # Black
    
    # Check if grayscale
    if abs(r - g) < 20 and abs(g - b) < 20 and abs(r - b) < 20:
        if r > 180:
            return "w" # White
        else:
            return "." # Grey
            
    # Color
    max_val = max(r, g, b)
    if max_val == r:
        if g > 150:
            return "Y" # Yellow
        elif b > 150:
            return "m" # Magenta
        else:
            return "R" # Red
    elif max_val == g:
        if r > 150:
            return "Y"
        elif b > 150:
            return "C" # Cyan
        else:
            return "G" # Green
    else:
        if r > 150:
            return "m"
        elif g > 150:
            return "C"
        else:
            return "b" # Blue

grid = []
for y in range(24):
    row = ""
    for x in range(32):
        pixel = small_img.getpixel((x, y))
        row += get_char(pixel)
    grid.append(row)

print("Screenshot Visual Grid (32x24):")
print("-" * 34)
for idx, row in enumerate(grid):
    print(f"{idx:02d}|{row}|")
print("-" * 34)
