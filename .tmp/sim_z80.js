const fs = require('fs');
const path = require('path');

const snaPath = path.join(__dirname, '..', 'jet set willy.sna');
const snaData = fs.readFileSync(snaPath);
const ram = snaData.subarray(27); // ZX Spectrum RAM starts at offset 27 in SNA file

// room_ptr is at 0x6E48 (which is 0x6E48 - 0x4000 = 0x2E48 in ZX RAM)
const room_ptr_addr = 0x6E48 - 0x4000;
const room_ptr = ram[room_ptr_addr] | (ram[room_ptr_addr + 1] << 8);
console.log(`room_ptr = 0x${room_ptr.toString(16)} (in RAM: 0x${(room_ptr - 0x4000).toString(16)})`);

const layout_start_ram = room_ptr - 0x4000;

function simulateGetBackgroundByte(X, Y) {
    console.log(`\nSimulating GetBackgroundByte for X=${X}, Y=${Y}:`);
    
    // Input parameters
    let reg_A = X;
    let reg_D = Y;
    
    // 178: GetBackgroundByte pushes registers hl, de, bc, ix. We simulate their values.
    let reg_B = reg_A; // ld b, a -> B = X
    
    // check bounds
    reg_A = reg_D; // ld a, d
    if (reg_A < 24 || reg_A >= 152) {
        console.log("-> Out of bounds (blank)");
        return 0;
    }
    
    reg_A = (reg_A - 24) & 0xFF; // sub 24
    // srl a (3 times)
    reg_A = reg_A >> 3; // A = r (layout row)
    let reg_C = reg_A; // ld c, a -> C = r
    
    reg_A = reg_B; // ld a, b -> A = X
    // srl a (3 times)
    reg_A = reg_A >> 3; // A = c (layout col)
    reg_B = reg_A; // ld b, a -> B = c
    
    let reg_H = 0; // ld h, 0
    let reg_L = reg_C; // ld l, c -> HL = r
    let reg_HL = (reg_H << 8) | reg_L;
    reg_HL = (reg_HL * 8) & 0xFFFF; // add hl, hl (3 times) -> HL = r * 8
    
    reg_A = reg_B; // ld a, b -> A = c
    reg_A = reg_A >> 2; // srl a (2 times) -> A = c / 4
    
    // push bc; ld c, a; ld b, 0; add hl, bc; pop bc
    let temp_BC = (reg_B << 8) | reg_C;
    let reg_BC_add = reg_A; // BC = c / 4
    reg_HL = (reg_HL + reg_BC_add) & 0xFFFF;
    reg_B = (temp_BC >> 8) & 0xFF;
    reg_C = temp_BC & 0xFF;
    
    // push bc; ld b, 0; ld c, l; add ix, bc; pop bc
    temp_BC = (reg_B << 8) | reg_C;
    let offset = reg_HL & 0xFF; // offset = L
    let reg_IX = room_ptr;
    reg_IX = (reg_IX + offset) & 0xFFFF; // add ix, bc
    
    // ld a, (ix+0) -> read layout byte
    let layout_byte_addr = reg_IX - 0x4000;
    reg_A = ram[layout_byte_addr];
    console.log(`Layout Byte Address = 0x${reg_IX.toString(16)} (RAM offset 0x${layout_byte_addr.toString(16)}), Value = ${reg_A} (0x${reg_A.toString(16)})`);
    
    reg_B = (temp_BC >> 8) & 0xFF;
    reg_C = temp_BC & 0xFF;
    
    // rotation logic
    reg_C = reg_A; // ld c, a
    reg_A = reg_B; // ld a, b -> A = c (col)
    reg_A = reg_A & 3; // and 3 -> c % 4
    reg_A = (reg_A + 1) & 0xFF; // inc a
    reg_A = reg_A & 3; // and 3 -> (c % 4 + 1) % 4
    
    if (reg_A !== 0) {
        let count = reg_A;
        // rotate left C circular count times, each time 2 bits
        for (let i = 0; i < count; i++) {
            // 8-bit rotate left 2 bits circular
            reg_C = (((reg_C << 2) | (reg_C >> 6)) & 0xFF);
        }
    }
    
    reg_A = reg_C; // ld a, c
    reg_A = reg_A & 3; // and 3 -> cell type
    console.log(`Cell Type = ${reg_A}`);
    
    reg_IX = room_ptr; // ld ix, (room_ptr)
    
    let tile_offset;
    if (reg_A === 0) {
        tile_offset = 160; // OFFSET_BG
    } else if (reg_A === 1) {
        tile_offset = 169; // OFFSET_FLOOR
    } else if (reg_A === 2) {
        tile_offset = 178; // OFFSET_WALL
    } else {
        tile_offset = 187; // OFFSET_NASTY
    }
    
    reg_H = 0;
    reg_L = tile_offset;
    let reg_BC_tile = tile_offset; // ld c, l; ld b, 0
    reg_IX = (reg_IX + reg_BC_tile) & 0xFFFF;
    
    // scanline offset
    reg_A = reg_D; // ld a, d (original Y is restored via pop de? No, D was not modified, so it has original Y)
    reg_A = reg_A & 7; // and 7 -> s
    
    let reg_DE_s = (reg_A + 1) & 0xFFFF; // ld e, a; ld d, 0; inc de -> 1 + s
    reg_IX = (reg_IX + reg_DE_s) & 0xFFFF;
    
    let tile_byte_addr = reg_IX - 0x4000;
    let result = ram[tile_byte_addr];
    console.log(`Tile Byte Address = 0x${reg_IX.toString(16)} (RAM offset 0x${tile_byte_addr.toString(16)}), Value = ${result}`);
    return result;
}

simulateGetBackgroundByte(136, 120);
simulateGetBackgroundByte(136, 121);
simulateGetBackgroundByte(136, 122);
simulateGetBackgroundByte(136, 123);
simulateGetBackgroundByte(136, 124);
simulateGetBackgroundByte(136, 125);
simulateGetBackgroundByte(136, 126);
simulateGetBackgroundByte(136, 127);
