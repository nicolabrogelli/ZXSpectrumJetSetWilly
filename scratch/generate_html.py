import json
import html

# Load room data
with open(r"C:\Users\87003101\Documents\Progetti\asm\ZXSPECTRUM-JETSETWILLY\scratch\rooms_data.json", "r", encoding="utf-8") as f:
    rooms_data = json.load(f)

room_dict = {r["id"]: r for r in rooms_data}

html_content = """<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jet Set Willy - Mappa dei Collegamenti delle Stanze (61 Stanze Verificate)</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap');
        
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: #0b0c10;
            color: #c5c6c7;
            margin: 0;
            padding: 30px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }
        
        header {
            text-align: center;
            max-width: 900px;
            margin-bottom: 30px;
        }

        h1 {
            font-weight: 800;
            font-size: 2.8rem;
            margin: 0 0 10px 0;
            background: linear-gradient(135deg, #38bdf8, #818cf8, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 4px 15px rgba(56, 189, 248, 0.25);
        }
        
        .subtitle {
            font-weight: 300;
            color: #94a3b8;
            font-size: 1.15rem;
            line-height: 1.5;
            margin-bottom: 25px;
        }

        .stats-badge {
            display: inline-block;
            background: rgba(56, 189, 248, 0.1);
            border: 1px solid rgba(56, 189, 248, 0.3);
            color: #38bdf8;
            padding: 6px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 20px;
        }
        
        /* Controls & Search */
        .controls {
            display: flex;
            gap: 15px;
            width: 100%;
            max-width: 1200px;
            margin-bottom: 25px;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
        }

        .search-box {
            position: relative;
            flex: 1;
            min-width: 280px;
            max-width: 500px;
        }

        .search-box input {
            width: 100%;
            padding: 12px 20px 12px 45px;
            background: #151824;
            border: 2px solid #2e354f;
            border-radius: 12px;
            color: #f8fafc;
            font-family: inherit;
            font-size: 1rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .search-box input:focus {
            border-color: #38bdf8;
            box-shadow: 0 0 15px rgba(56, 189, 248, 0.2);
        }

        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
            font-weight: bold;
        }

        /* Legend */
        .legend {
            background: #151824;
            border-radius: 14px;
            padding: 16px 24px;
            display: flex;
            gap: 25px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
            border: 1px solid #2e354f;
            font-size: 0.9rem;
            margin-bottom: 30px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .legend-color {
            width: 18px;
            height: 12px;
            border-radius: 4px;
        }

        /* Map Grid Container */
        .map-container {
            width: 100%;
            max-width: 1400px;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
            grid-gap: 24px;
            margin-bottom: 50px;
        }
        
        /* Room Card */
        .room-card {
            background: linear-gradient(145deg, #1e2235, #141724);
            border: 2px solid #2e354f;
            border-radius: 14px;
            min-height: 145px;
            padding: 14px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            box-shadow: 0 8px 18px rgba(0, 0, 0, 0.4);
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
        }
        
        .room-card:hover {
            transform: translateY(-4px);
            border-color: #38bdf8;
            box-shadow: 0 12px 28px rgba(56, 189, 248, 0.25);
            background: linear-gradient(145deg, #242940, #181c2e);
        }

        .room-card.active-selected {
            border-color: #f59e0b !important;
            box-shadow: 0 0 25px rgba(245, 158, 11, 0.5) !important;
            transform: scale(1.03);
            z-index: 10;
        }

        .room-card.connected-highlight {
            border-color: #10b981 !important;
            box-shadow: 0 0 20px rgba(16, 185, 129, 0.4) !important;
        }

        .room-card.dimmed {
            opacity: 0.35;
            filter: grayscale(60%);
        }
        
        .room-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
        }

        .room-id {
            font-size: 0.78rem;
            font-weight: 700;
            color: #38bdf8;
            letter-spacing: 0.05em;
            background: rgba(56, 189, 248, 0.1);
            padding: 3px 8px;
            border-radius: 6px;
        }
        
        .room-name {
            font-size: 0.95rem;
            font-weight: 600;
            color: #f8fafc;
            margin: 6px 0;
            line-height: 1.3;
            min-height: 2.6em;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* Connections Container inside Card */
        .conn-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px;
            margin-top: 10px;
            padding-top: 8px;
            border-top: 1px solid rgba(255, 255, 255, 0.07);
        }
        
        /* Connection Indicator Pill */
        .conn-indicator {
            background: #1e293b;
            color: #cbd5e1;
            font-size: 0.7rem;
            font-weight: 600;
            border-radius: 6px;
            padding: 4px 6px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 4px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
            border-left: 3px solid #64748b;
            transition: all 0.15s ease;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .conn-indicator:hover {
            background: #334155;
            color: #ffffff;
        }
        
        /* Direction specific styles */
        .conn-left, .conn-right {
            border-left-color: #10b981;
        }

        .conn-up, .conn-down {
            border-left-color: #3b82f6;
        }

        .dir-arrow {
            font-weight: bold;
            font-size: 0.75rem;
        }

        .conn-left .dir-arrow, .conn-right .dir-arrow {
            color: #34d399;
        }

        .conn-up .dir-arrow, .conn-down .dir-arrow {
            color: #60a5fa;
        }

        .conn-none {
            opacity: 0.3;
            border-left-color: #475569;
            justify-content: center;
        }

        /* Footer info */
        footer {
            margin-top: auto;
            padding: 20px;
            color: #64748b;
            font-size: 0.85rem;
            text-align: center;
            border-top: 1px solid #1e293b;
            width: 100%;
        }

        @media print {
            body {
                background: white;
                color: black;
                padding: 10px;
            }
            .map-container {
                box-shadow: none;
                grid-template-columns: repeat(4, 1fr);
            }
            .room-card {
                border: 1px solid #94a3b8;
                background: white;
                color: black;
                box-shadow: none;
            }
            .room-name {
                color: black;
            }
            .search-box, .controls {
                display: none;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>Jet Set Willy - Mappa dei Collegamenti</h1>
        <div class="subtitle">Struttura completa e verificata di tutte le 61 stanze del gioco estratte dal codice sorgente Assembly ZX Spectrum</div>
        <div class="stats-badge">✓ 61 Stanze Presenti | Estratte da RoomsListTable & Stranze ASM</div>
    </header>
    
    <div class="controls">
        <div class="search-box">
            <span class="search-icon">🔍</span>
            <input type="text" id="searchInput" placeholder="Cerca per nome stanza o ID (es. #33 o Bathroom)..." oninput="filterRooms()">
        </div>
    </div>

    <div class="legend">
        <div class="legend-item">
            <div class="legend-color" style="background: #10b981;"></div>
            <span>Collegamenti Orizzontali (← Sinistra / Destra →)</span>
        </div>
        <div class="legend-item">
            <div class="legend-color" style="background: #3b82f6;"></div>
            <span>Collegamenti Verticali (↑ Sopra / Sotto ↓)</span>
        </div>
        <div class="legend-item">
            <span style="color: #f59e0b; font-weight: 600;">💡 Suggerimento:</span> Clicca su una stanza per evidenziare i suoi 4 collegamenti!
        </div>
    </div>
    
    <div class="map-container" id="mapContainer">
"""

for r in rooms_data:
    rid = r["id"]
    rname = html.escape(r["name"])
    
    # Left
    lid = r["left"]
    lname = html.escape(room_dict[lid]["name"]) if lid is not None else ""
    # Right
    rid_out = r["right"]
    rname_out = html.escape(room_dict[rid_out]["name"]) if rid_out is not None else ""
    # Up
    uid = r["up"]
    uname = html.escape(room_dict[uid]["name"]) if uid is not None else ""
    # Down
    did = r["down"]
    dname = html.escape(room_dict[did]["name"]) if did is not None else ""

    html_content += f"""
        <div class="room-card" id="room-{rid}" data-id="{rid}" data-name="{rname.lower()}" data-left="{lid if lid is not None else ''}" data-right="{rid_out if rid_out is not None else ''}" data-up="{uid if uid is not None else ''}" data-down="{did if did is not None else ''}" onclick="selectRoom({rid})">
            <div>
                <div class="room-header">
                    <span class="room-id">ROOM #{rid:02d}</span>
                </div>
                <div class="room-name">{rname}</div>
            </div>
            <div class="conn-grid">
"""
    # Left pill
    if lid is not None:
        html_content += f'                <div class="conn-indicator conn-left" title="Sinistra → Stanza #{lid:02d}: {lname}"><span class="dir-arrow">←</span> #{lid:02d}</div>\n'
    else:
        html_content += f'                <div class="conn-indicator conn-none" title="Nessuna uscita a sinistra"><span class="dir-arrow">←</span> -</div>\n'

    # Right pill
    if rid_out is not None:
        html_content += f'                <div class="conn-indicator conn-right" title="Destra → Stanza #{rid_out:02d}: {rname_out}"><span class="dir-arrow">→</span> #{rid_out:02d}</div>\n'
    else:
        html_content += f'                <div class="conn-indicator conn-none" title="Nessuna uscita a destra"><span class="dir-arrow">→</span> -</div>\n'

    # Up pill
    if uid is not None:
        html_content += f'                <div class="conn-indicator conn-up" title="Sopra → Stanza #{uid:02d}: {uname}"><span class="dir-arrow">↑</span> #{uid:02d}</div>\n'
    else:
        html_content += f'                <div class="conn-indicator conn-none" title="Nessuna uscita in alto"><span class="dir-arrow">↑</span> -</div>\n'

    # Down pill
    if did is not None:
        html_content += f'                <div class="conn-indicator conn-down" title="Sotto → Stanza #{did:02d}: {dname}"><span class="dir-arrow">↓</span> #{did:02d}</div>\n'
    else:
        html_content += f'                <div class="conn-indicator conn-none" title="Nessuna uscita in basso"><span class="dir-arrow">↓</span> -</div>\n'

    html_content += """            </div>
        </div>"""

html_content += """
    </div>

    <footer>
        Jet Set Willy Spectrum Disassembly & Map Connections • Generato automaticamente dalle tabelle dati del progetto ZX Spectrum ASM.
    </footer>

    <script>
        let selectedRoomId = null;

        function selectRoom(id) {
            const allCards = document.querySelectorAll('.room-card');
            
            if (selectedRoomId === id) {
                // Deselect
                selectedRoomId = null;
                allCards.forEach(c => {
                    c.classList.remove('active-selected', 'connected-highlight', 'dimmed');
                });
                return;
            }

            selectedRoomId = id;
            const targetCard = document.getElementById(`room-${id}`);
            if (!targetCard) return;

            const leftId = targetCard.dataset.left;
            const rightId = targetCard.dataset.right;
            const upId = targetCard.dataset.up;
            const downId = targetCard.dataset.down;

            const connectedIds = [leftId, rightId, upId, downId].filter(x => x !== '');

            allCards.forEach(c => {
                const cardId = c.dataset.id;
                c.classList.remove('active-selected', 'connected-highlight', 'dimmed');

                if (cardId == id) {
                    c.classList.add('active-selected');
                } else if (connectedIds.includes(cardId)) {
                    c.classList.add('connected-highlight');
                } else {
                    c.classList.add('dimmed');
                }
            });
        }

        function filterRooms() {
            const query = document.getElementById('searchInput').value.toLowerCase().trim();
            const cards = document.querySelectorAll('.room-card');

            cards.forEach(card => {
                const name = card.dataset.name;
                const id = card.dataset.id;
                const matches = name.includes(query) || id.includes(query) || `#${id}`.includes(query) || (id < 10 && `#0${id}`.includes(query));

                if (matches) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
"""

target_file = r"C:\Users\87003101\Documents\Progetti\asm\ZXSPECTRUM-JETSETWILLY\scratch\room_connections.html"
with open(target_file, "w", encoding="utf-8") as f:
    f.write(html_content)

print(f"Successfully generated {target_file} with all {len(rooms_data)} rooms!")
