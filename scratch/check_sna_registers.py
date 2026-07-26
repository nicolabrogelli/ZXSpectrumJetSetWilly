import struct

with open("jet set willy.sna", "rb") as f:
    header = f.read(27)

i_reg = header[0]
hl_prime = struct.unpack("<H", header[1:3])[0]
de_prime = struct.unpack("<H", header[3:5])[0]
bc_prime = struct.unpack("<H", header[5:7])[0]
af_prime = struct.unpack("<H", header[7:9])[0]
hl_reg = struct.unpack("<H", header[9:11])[0]
de_reg = struct.unpack("<H", header[11:13])[0]
bc_reg = struct.unpack("<H", header[13:15])[0]
iy_reg = struct.unpack("<H", header[15:17])[0]
ix_reg = struct.unpack("<H", header[17:19])[0]
iff2 = header[19]
r_reg = header[20]
af_reg = struct.unpack("<H", header[21:23])[0]
sp_reg = struct.unpack("<H", header[23:25])[0]
im_mode = header[25]
border = header[26]

print("=== SNA HEADER DUMP ===")
print(f"I  : {i_reg:#04x}")
print(f"HL': {hl_prime:#06x}, DE': {de_prime:#06x}, BC': {bc_prime:#06x}, AF': {af_prime:#06x}")
print(f"HL : {hl_reg:#06x}, DE : {de_reg:#06x}, BC : {bc_reg:#06x}")
print(f"IY : {iy_reg:#06x}, IX : {ix_reg:#06x}")
print(f"IFF2: {iff2}, R: {r_reg:#04x}, AF: {af_reg:#06x}")
print(f"SP : {sp_reg:#06x}")
print(f"IM : {im_mode}, Border: {border}")

# Pushed PC on stack
sp_off = 27 + (sp_reg - 0x4000)
with open("jet set willy.sna", "rb") as f:
    full_sna = f.read()
pushed_pc = struct.unpack("<H", full_sna[sp_off:sp_off+2])[0]
print(f"Pushed PC at SP ({sp_reg:#06x}): {pushed_pc:#06x}")
