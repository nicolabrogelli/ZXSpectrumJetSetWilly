const fs = require('fs');
const path = require('path');

const snaPath = path.join(__dirname, '..', 'jet set willy.sna');
if (!fs.existsSync(snaPath)) {
    console.error("SNA file not found!");
    process.exit(1);
}

const snaData = fs.readFileSync(snaPath);
const ram = snaData.subarray(27);

// Room0Layout starts at 0x6F00 (which is 0x6F00 - 0x4000 = 0x2F00 in RAM dump)
const ROOM0_LAYOUT = 0x6F00;
const RAM_OFFSET = ROOM0_LAYOUT - 0x4000;

// Tile offsets relative to room_ptr
const OFFSET_BG = 160;
const OFFSET_FLOOR = 169;
const OFFSET_WALL = 178;
const OFFSET_NASTY = 187;

function getLayoutByte(r, c_group) {
    const offset = r * 8 + c_group;
    const addr = RAM_OFFSET + offset;
    return ram[addr];
}

function getTileByte(cell_type, s) {
    let offset;
    if (cell_type === 0) {
        offset = OFFSET_BG;
    } else if (cell_type === 1) {
        offset = OFFSET_FLOOR;
    } else if (cell_type === 2) {
        offset = OFFSET_WALL;
    } else {
        offset = OFFSET_NASTY;
    }
    
    const addr = RAM_OFFSET + offset + 1 + s;
    return ram[addr];
}

function getBackgroundByte(x, y) {
    if (y < 24 || y >= 152) {
        return [0, 0];
    }
    
    const r = Math.floor((y - 24) / 8);
    const c = Math.floor(x / 8);
    
    const layoutByte = getLayoutByte(r, Math.floor(c / 4));
    
    // Rotate logic
    const bitOffset = c % 4;
    const rot = (bitOffset + 1) % 4;
    
    // Rotate left by rot * 2 bits
    let val = layoutByte;
    for (let i = 0; i < rot; i++) {
        val = (((val << 2) | (val >> 6)) & 0xFF);
    }
    
    const cellType = val & 3;
    const s = y % 8;
    return [cellType, getTileByte(cellType, s)];
}

// Let's test for X = 136 (col 17) and Y from 24 to 151
console.log("Testing X = 136 (col 17):");
console.log(`col % 4 = ${17 % 4}, col // 4 = ${Math.floor(17 / 4)}`);
for (let y = 24; y < 152; y++) {
    const [cellType, val] = getBackgroundByte(136, y);
    if (cellType !== 0) {
        console.log(`Y=${String(y).padStart(3, ' ')} (Row ${String(Math.floor((y-24)/8)).padStart(2, ' ')}, scanline ${y%8}): CellType=${cellType}, ByteVal=${val}`);
    }
}

// Let's test for X = 40 (col 5)
console.log("\nTesting X = 40 (col 5):");
for (let y = 24; y < 152; y++) {
    const [cellType, val] = getBackgroundByte(40, y);
    if (cellType !== 0) {
        console.log(`Y=${String(y).padStart(3, ' ')} (Row ${String(Math.floor((y-24)/8)).padStart(2, ' ')}, scanline ${y%8}): CellType=${cellType}, ByteVal=${val}`);
    }
}
