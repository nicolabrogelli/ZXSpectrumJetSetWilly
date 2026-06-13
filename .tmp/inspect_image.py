from PIL import Image

bmp_path = r"C:\Users\nicol\Documents\Progetti\asm\ZXSPECTRUM-JET SET WILLY\documentation\errori\errore1.bmp"
img = Image.open(bmp_path)
img = img.convert("RGB")
w, h = img.size
print(f"Loaded image size: {w}x{h}")

# Find unique colors
colors = img.getcolors(maxcolors=1000)
print("Unique colors:")
for count, color in colors:
    print(f"Color {color}: {count} pixels")
