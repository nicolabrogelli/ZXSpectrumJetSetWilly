import os
import re

rooms_dir = r"C:\Users\87003101\Documents\Progetti\asm\ZXSPECTRUM-JETSETWILLY\rooms"
input_asm = r"C:\Users\87003101\Documents\Progetti\asm\ZXSPECTRUM-JETSETWILLY\input.asm"

with open(input_asm, "r", encoding="utf-8") as f:
    text = f.read()

# Find entries in RoomsListTable
table_entries = re.findall(r"\.([A-Za-z0-9_]+Layout)[\s:]+dw\s+([A-Za-z0-9_]+Layout)", text)

room_id_by_layout = {}
layout_by_id = {}
room_name_by_id = {}

for idx, (label1, label2) in enumerate(table_entries):
    room_id_by_layout[label1] = idx
    room_id_by_layout[label2] = idx
    layout_by_id[idx] = label1

print(f"Total rooms in RoomsListTable: {len(table_entries)}")

rooms = {}

for fname in os.listdir(rooms_dir):
    if not fname.endswith(".asm"):
        continue
    fpath = os.path.join(rooms_dir, fname)
    with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    
    # Extract room name from Tile string DEFM "..."
    tile_match = re.search(r'DEFM\s*"([^"]+)"', content)
    room_name = tile_match.group(1).strip() if tile_match else fname.replace(".asm", "")
    
    # Extract layout label
    layout_match = re.search(r'([A-Za-z0-9_]+Layout):', content)
    layout_label = layout_match.group(1) if layout_match else None
    
    # Find Direction section specifically
    dir_sec_match = re.search(r'[A-Za-z0-9_]+Direction:\s*(.*?)(?=[A-Za-z0-9_]+Unused:|[A-Za-z0-9_]+Enemy|\Z)', content, re.DOTALL)
    dir_ids = [None, None, None, None] # Left, Right, Up, Down
    
    if dir_sec_match:
        lines = [line.strip() for line in dir_sec_match.group(1).splitlines() if line.strip() and not line.strip().startswith(";")]
        # We expect 4 lines for Left, Right, Up, Down
        for idx in range(min(4, len(lines))):
            line = lines[idx]
            m = re.search(r'RoomsListTable\.([A-Za-z0-9_]+Layout)', line)
            if m:
                target_layout = m.group(1)
                dir_ids[idx] = target_layout
            elif "BLOCK" in line or "255" in line or "$FF" in line:
                dir_ids[idx] = None
    
    rooms[fname] = {
        "file": fname,
        "name": room_name,
        "layout": layout_label,
        "dirs": dir_ids # [Left, Right, Up, Down]
    }

room_data_by_id = {}
for fname, data in rooms.items():
    layout = data["layout"]
    if layout in room_id_by_layout:
        rid = room_id_by_layout[layout]
        room_data_by_id[rid] = data
        room_name_by_id[rid] = data["name"]

all_rooms_list = []

for rid in range(len(table_entries)):
    rdata = room_data_by_id.get(rid)
    if not rdata:
        print(f"Missing data for Room ID #{rid}")
        continue
    
    dirs = rdata["dirs"]
    left_id = room_id_by_layout.get(dirs[0]) if dirs[0] else None
    right_id = room_id_by_layout.get(dirs[1]) if dirs[1] else None
    up_id = room_id_by_layout.get(dirs[2]) if dirs[2] else None
    down_id = room_id_by_layout.get(dirs[3]) if dirs[3] else None
    
    rinfo = {
        "id": rid,
        "name": rdata["name"],
        "left": left_id,
        "right": right_id,
        "up": up_id,
        "down": down_id
    }
    all_rooms_list.append(rinfo)

print("\n--- ALL ROOM CONNECTIONS ---")
for r in all_rooms_list:
    rid = r["id"]
    rname = r["name"]
    l_str = f"#{r['left']:02d} ({room_name_by_id.get(r['left'])})" if r['left'] is not None else "-"
    r_str = f"#{r['right']:02d} ({room_name_by_id.get(r['right'])})" if r['right'] is not None else "-"
    u_str = f"#{r['up']:02d} ({room_name_by_id.get(r['up'])})" if r['up'] is not None else "-"
    d_str = f"#{r['down']:02d} ({room_name_by_id.get(r['down'])})" if r['down'] is not None else "-"
    
    print(f"Room #{rid:02d}: {rname}")
    print(f"  Left : {l_str}")
    print(f"  Right: {r_str}")
    print(f"  Up   : {u_str}")
    print(f"  Down : {d_str}")

import json
with open(r"C:\Users\87003101\Documents\Progetti\asm\ZXSPECTRUM-JETSETWILLY\scratch\rooms_data.json", "w", encoding="utf-8") as f:
    json.dump(all_rooms_list, f, indent=2, ensure_ascii=False)
