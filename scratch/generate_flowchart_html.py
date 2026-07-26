import json
import html

# Load room data
with open(r"C:\Users\87003101\Documents\Progetti\asm\ZXSPECTRUM-JETSETWILLY\scratch\rooms_data.json", "r", encoding="utf-8") as f:
    rooms_data = json.load(f)

room_dict = {r["id"]: r for r in rooms_data}

# Assign hierarchical levels for flowchart visual layout
def get_level(rid):
    # Level 0: Roof & Tower & Sky
    if rid in [60, 59, 58, 51, 48, 18, 17, 50, 16, 43, 42, 41, 40, 39, 38, 44]:
        return 0
    # Level 1: Upper Floor & Attic & Bathroom
    elif rid in [57, 56, 37, 36, 35, 34, 33, 32]:
        return 1
    # Level 2: Middle Landing & Chapel & Bridge
    elif rid in [55, 54, 31, 30, 29, 28, 27, 26, 1, 0, 13, 12]:
        return 2
    # Level 3: Ground Floor & Kitchen & Ballroom & Tree Branch
    elif rid in [53, 25, 24, 23, 22, 21, 20, 11, 10, 9, 8, 7]:
        return 3
    # Level 4: Drive & Security Guard & Abbey
    elif rid in [52, 49, 19, 5, 4, 3, 2]:
        return 4
    # Level 5: Underground & Hades & Roots
    else:
        return 5

# Build Vis.js nodes and edges
nodes = []
edges = []

edge_id_counter = 1

for r in rooms_data:
    rid = r["id"]
    rname = r["name"]
    level = get_level(rid)
    
    nodes.append({
        "id": rid,
        "label": f"#{rid:02d}\n{rname}",
        "title": f"Stanza #{rid:02d}: {rname}",
        "level": level,
        "shape": "box",
        "margin": 10,
        "font": {"color": "#ffffff", "face": "Outfit", "size": 13, "bold": "true"},
        "color": {
            "background": "#1e2436",
            "border": "#38bdf8",
            "highlight": {"background": "#f59e0b", "border": "#fbbf24"},
            "hover": {"background": "#3b82f6", "border": "#60a5fa"}
        }
    })
    
    # Edges
    # Left
    if r["left"] is not None:
        edges.append({
            "from": rid,
            "to": r["left"],
            "label": "← Sinistra",
            "arrows": "to",
            "color": {"color": "#10b981", "highlight": "#34d399", "hover": "#34d399"},
            "font": {"color": "#10b981", "size": 10, "align": "top", "face": "Outfit"},
            "physics": True,
            "smooth": {"type": "curvedCW", "roundness": 0.15}
        })
    # Right
    if r["right"] is not None:
        edges.append({
            "from": rid,
            "to": r["right"],
            "label": "Destra →",
            "arrows": "to",
            "color": {"color": "#059669", "highlight": "#10b981", "hover": "#10b981"},
            "font": {"color": "#059669", "size": 10, "align": "bottom", "face": "Outfit"},
            "physics": True,
            "smooth": {"type": "curvedCCW", "roundness": 0.15}
        })
    # Up
    if r["up"] is not None:
        edges.append({
            "from": rid,
            "to": r["up"],
            "label": "↑ Sopra",
            "arrows": "to",
            "color": {"color": "#3b82f6", "highlight": "#60a5fa", "hover": "#60a5fa"},
            "font": {"color": "#3b82f6", "size": 10, "align": "horizontal", "face": "Outfit"},
            "physics": True,
            "smooth": {"type": "curvedCW", "roundness": 0.2}
        })
    # Down
    if r["down"] is not None:
        edges.append({
            "from": rid,
            "to": r["down"],
            "label": "↓ Sotto",
            "arrows": "to",
            "color": {"color": "#6366f1", "highlight": "#818cf8", "hover": "#818cf8"},
            "font": {"color": "#6366f1", "size": 10, "align": "horizontal", "face": "Outfit"},
            "physics": True,
            "smooth": {"type": "curvedCCW", "roundness": 0.2}
        })

nodes_json = json.dumps(nodes, ensure_ascii=False)
edges_json = json.dumps(edges, ensure_ascii=False)

html_content = f"""<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jet Set Willy - Diagramma di Flusso Collegamenti Stanze</title>
    <!-- Vis.js Network Library -->
    <script type="text/javascript" src="https://unpkg.com/vis-network/standalone/umd/vis-network.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap');
        
        * {{
            box-sizing: border-box;
        }}

        body {{
            font-family: 'Outfit', sans-serif;
            background-color: #0b0c10;
            color: #c5c6c7;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }}
        
        header {{
            text-align: center;
            max-width: 1000px;
            margin-bottom: 20px;
        }}

        h1 {{
            font-weight: 800;
            font-size: 2.6rem;
            margin: 0 0 8px 0;
            background: linear-gradient(135deg, #38bdf8, #818cf8, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 4px 15px rgba(56, 189, 248, 0.25);
        }}
        
        .subtitle {{
            font-weight: 300;
            color: #94a3b8;
            font-size: 1.1rem;
            line-height: 1.5;
            margin-bottom: 15px;
        }}

        /* View Mode Switcher */
        .tab-switcher {{
            display: flex;
            background: #151824;
            padding: 5px;
            border-radius: 12px;
            border: 1px solid #2e354f;
            margin-bottom: 20px;
            gap: 5px;
        }}

        .tab-btn {{
            background: transparent;
            border: none;
            color: #94a3b8;
            padding: 10px 24px;
            font-family: inherit;
            font-weight: 600;
            font-size: 0.95rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
        }}

        .tab-btn.active {{
            background: linear-gradient(135deg, #38bdf8, #6366f1);
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(56, 189, 248, 0.3);
        }}

        /* Controls & Search */
        .controls {{
            display: flex;
            gap: 15px;
            width: 100%;
            max-width: 1200px;
            margin-bottom: 15px;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
        }}

        .search-box {{
            position: relative;
            flex: 1;
            min-width: 280px;
            max-width: 450px;
        }}

        .search-box input {{
            width: 100%;
            padding: 10px 18px 10px 42px;
            background: #151824;
            border: 2px solid #2e354f;
            border-radius: 10px;
            color: #f8fafc;
            font-family: inherit;
            font-size: 0.95rem;
            outline: none;
            transition: all 0.2s ease;
        }}

        .search-box input:focus {{
            border-color: #38bdf8;
            box-shadow: 0 0 15px rgba(56, 189, 248, 0.2);
        }}

        .search-icon {{
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
            font-weight: bold;
        }}

        .btn-action {{
            background: #1e293b;
            border: 1px solid #334155;
            color: #e2e8f0;
            padding: 10px 16px;
            border-radius: 10px;
            font-family: inherit;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.2s;
        }}

        .btn-action:hover {{
            background: #334155;
            color: #38bdf8;
            border-color: #38bdf8;
        }}

        /* Flowchart View Container */
        #flowchart-view {{
            width: 100%;
            max-width: 1400px;
            height: 750px;
            background: #111420;
            border: 2px solid #2e354f;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.6);
            position: relative;
            overflow: hidden;
            margin-bottom: 30px;
        }}

        #network-canvas {{
            width: 100%;
            height: 100%;
        }}

        /* Legend */
        .legend {{
            background: #151824;
            border-radius: 12px;
            padding: 12px 20px;
            display: flex;
            gap: 20px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
            border: 1px solid #2e354f;
            font-size: 0.85rem;
            margin-bottom: 25px;
            flex-wrap: wrap;
            justify-content: center;
        }}

        .legend-item {{
            display: flex;
            align-items: center;
            gap: 8px;
        }}

        .legend-color {{
            width: 16px;
            height: 10px;
            border-radius: 3px;
        }}

        /* Grid Cards Container (Alternative View) */
        #grid-view {{
            width: 100%;
            max-width: 1400px;
            display: none; /* hidden by default, toggled via tab */
            grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
            grid-gap: 20px;
            margin-bottom: 40px;
        }}

        .room-card {{
            background: linear-gradient(145deg, #1e2235, #141724);
            border: 2px solid #2e354f;
            border-radius: 12px;
            min-height: 140px;
            padding: 12px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.4);
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
        }}
        
        .room-card:hover {{
            transform: translateY(-3px);
            border-color: #38bdf8;
            box-shadow: 0 10px 24px rgba(56, 189, 248, 0.25);
        }}

        .room-card.active-selected {{
            border-color: #f59e0b !important;
            box-shadow: 0 0 25px rgba(245, 158, 11, 0.5) !important;
            transform: scale(1.03);
            z-index: 10;
        }}

        .room-card.connected-highlight {{
            border-color: #10b981 !important;
            box-shadow: 0 0 20px rgba(16, 185, 129, 0.4) !important;
        }}

        .room-card.dimmed {{
            opacity: 0.3;
            filter: grayscale(70%);
        }}

        .room-id {{
            font-size: 0.75rem;
            font-weight: 700;
            color: #38bdf8;
            background: rgba(56, 189, 248, 0.1);
            padding: 3px 8px;
            border-radius: 6px;
            display: inline-block;
        }}
        
        .room-name {{
            font-size: 0.92rem;
            font-weight: 600;
            color: #f8fafc;
            margin: 6px 0;
            line-height: 1.3;
            min-height: 2.5em;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }}

        .conn-grid {{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 5px;
            margin-top: 8px;
            padding-top: 6px;
            border-top: 1px solid rgba(255, 255, 255, 0.07);
        }}

        .conn-indicator {{
            background: #1e293b;
            color: #cbd5e1;
            font-size: 0.68rem;
            font-weight: 600;
            border-radius: 5px;
            padding: 3px 5px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 3px;
            border-left: 3px solid #64748b;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }}

        .conn-left, .conn-right {{ border-left-color: #10b981; }}
        .conn-up, .conn-down {{ border-left-color: #3b82f6; }}
        .conn-none {{ opacity: 0.3; border-left-color: #475569; justify-content: center; }}

        footer {{
            margin-top: auto;
            padding: 20px;
            color: #64748b;
            font-size: 0.85rem;
            text-align: center;
            border-top: 1px solid #1e293b;
            width: 100%;
        }}
    </style>
</head>
<body>
    <header>
        <h1>Jet Set Willy - Diagramma di Flusso Stanze</h1>
        <div class="subtitle">Rappresentazione interattiva a diagramma di flusso dei passaggi e collegamenti tra le 61 stanze del gioco</div>
    </header>

    <div class="tab-switcher">
        <button class="tab-btn active" onclick="switchView('flowchart')">🔀 Diagramma di Flusso Interattivo</button>
        <button class="tab-btn" onclick="switchView('grid')">📑 Vista Schede Stanze</button>
    </div>
    
    <div class="controls">
        <div class="search-box">
            <span class="search-icon">🔍</span>
            <input type="text" id="searchInput" placeholder="Cerca stanza per nome o #ID (es. #33 o Bathroom)..." oninput="handleSearch()">
        </div>
        <button class="btn-action" onclick="resetGraphView()">🔄 Resetta Zoom & Posizione</button>
        <button class="btn-action" onclick="togglePhysics()">⚡ Attiva/Disattiva Fisica</button>
    </div>

    <div class="legend">
        <div class="legend-item">
            <div class="legend-color" style="background: #10b981;"></div>
            <span>Frecce Verdi: Uscita Sinistra / Destra</span>
        </div>
        <div class="legend-item">
            <div class="legend-color" style="background: #3b82f6;"></div>
            <span>Frecce Blu: Uscita Sopra / Sotto</span>
        </div>
        <div class="legend-item">
            <span style="color: #f59e0b; font-weight: 600;">💡 Istruzioni:</span> Trascina le stanze per organizzarle o clicca su un nodo per isolare tutti i suoi collegamenti!
        </div>
    </div>
    
    <!-- Flowchart Container -->
    <div id="flowchart-view">
        <div id="network-canvas"></div>
    </div>

    <!-- Cards Grid Container -->
    <div id="grid-view">
"""

for r in rooms_data:
    rid = r["id"]
    rname = html.escape(r["name"])
    lid = r["left"]
    lname = html.escape(room_dict[lid]["name"]) if lid is not None else ""
    rid_out = r["right"]
    rname_out = html.escape(room_dict[rid_out]["name"]) if rid_out is not None else ""
    uid = r["up"]
    uname = html.escape(room_dict[uid]["name"]) if uid is not None else ""
    did = r["down"]
    dname = html.escape(room_dict[did]["name"]) if did is not None else ""

    html_content += f"""
        <div class="room-card" id="room-{rid}" data-id="{rid}" data-name="{rname.lower()}" data-left="{lid if lid is not None else ''}" data-right="{rid_out if rid_out is not None else ''}" data-up="{uid if uid is not None else ''}" data-down="{did if did is not None else ''}" onclick="selectRoomCard({rid})">
            <div>
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <span class="room-id">ROOM #{rid:02d}</span>
                </div>
                <div class="room-name">{rname}</div>
            </div>
            <div class="conn-grid">
"""
    if lid is not None:
        html_content += f'                <div class="conn-indicator conn-left" title="Sinistra → #{lid:02d}: {lname}">← #{lid:02d}</div>\n'
    else:
        html_content += f'                <div class="conn-indicator conn-none">← -</div>\n'

    if rid_out is not None:
        html_content += f'                <div class="conn-indicator conn-right" title="Destra → #{rid_out:02d}: {rname_out}">→ #{rid_out:02d}</div>\n'
    else:
        html_content += f'                <div class="conn-indicator conn-none">→ -</div>\n'

    if uid is not None:
        html_content += f'                <div class="conn-indicator conn-up" title="Sopra → #{uid:02d}: {uname}">↑ #{uid:02d}</div>\n'
    else:
        html_content += f'                <div class="conn-indicator conn-none">↑ -</div>\n'

    if did is not None:
        html_content += f'                <div class="conn-indicator conn-down" title="Sotto → #{did:02d}: {dname}">↓ #{did:02d}</div>\n'
    else:
        html_content += f'                <div class="conn-indicator conn-none">↓ -</div>\n'

    html_content += """            </div>
        </div>"""

html_content += f"""
    </div>

    <footer>
        Jet Set Willy Spectrum Disassembly • Diagramma di Flusso Interattivo dei Collegamenti delle Stanze.
    </footer>

    <script>
        // Nodes and Edges Data
        const nodesData = {nodes_json};
        const edgesData = {edges_json};

        let network = null;
        let physicsEnabled = true;

        // Initialize Vis.js Network Flowchart
        function initNetwork() {{
            const container = document.getElementById('network-canvas');
            const data = {{
                nodes: new vis.DataSet(nodesData),
                edges: new vis.DataSet(edgesData)
            }};

            const options = {{
                nodes: {{
                    borderWidth: 2,
                    shadow: true
                }},
                edges: {{
                    width: 2,
                    shadow: true,
                    font: {{
                        strokeWidth: 2,
                        strokeColor: '#0b0c10'
                    }}
                }},
                layout: {{
                    hierarchical: {{
                        enabled: true,
                        direction: 'UD',
                        sortMethod: 'directed',
                        nodeSpacing: 180,
                        levelSeparation: 140
                    }}
                }},
                physics: {{
                    enabled: true,
                    hierarchicalRepulsion: {{
                        centralGravity: 0.0,
                        springLength: 120,
                        nodeDistance: 160
                    }}
                }},
                interaction: {{
                    hover: true,
                    navigationButtons: true,
                    keyboard: true
                }}
            }};

            network = new vis.Network(container, data, options);

            network.on("selectNode", function (params) {{
                if (params.nodes.length > 0) {{
                    const nodeId = params.nodes[0];
                    highlightGraphConnections(nodeId);
                    selectRoomCard(nodeId);
                }}
            }});

            network.on("deselectNode", function () {{
                resetGraphConnections();
            }});
        }}

        function highlightGraphConnections(nodeId) {{
            const connectedNodes = network.getConnectedNodes(nodeId);
            const allNodes = nodesData.map(n => n.id);

            const updateArray = [];
            allNodes.forEach(id => {{
                if (id === nodeId) {{
                    updateArray.push({{ id: id, color: {{ background: '#f59e0b', border: '#fbbf24' }} }});
                }} else if (connectedNodes.includes(id)) {{
                    updateArray.push({{ id: id, color: {{ background: '#10b981', border: '#34d399' }} }});
                }} else {{
                    updateArray.push({{ id: id, color: {{ background: '#141724', border: '#2e354f' }} }});
                }}
            }});

            network.body.data.nodes.update(updateArray);
        }}

        function resetGraphConnections() {{
            const updateArray = nodesData.map(n => ({{
                id: n.id,
                color: {{ background: '#1e2436', border: '#38bdf8' }}
            }}));
            network.body.data.nodes.update(updateArray);
        }}

        function resetGraphView() {{
            if (network) {{
                network.fit({{ animation: true }});
                resetGraphConnections();
            }}
        }}

        function togglePhysics() {{
            if (network) {{
                physicsEnabled = !physicsEnabled;
                network.setOptions({{ physics: {{ enabled: physicsEnabled }} }});
            }}
        }}

        function switchView(viewName) {{
            const flowchartContainer = document.getElementById('flowchart-view');
            const gridContainer = document.getElementById('grid-view');
            const buttons = document.querySelectorAll('.tab-btn');

            if (viewName === 'flowchart') {{
                flowchartContainer.style.display = 'block';
                gridContainer.style.display = 'none';
                buttons[0].classList.add('active');
                buttons[1].classList.remove('active');
                if (network) network.redraw();
            }} else {{
                flowchartContainer.style.display = 'none';
                gridContainer.style.display = 'grid';
                buttons[0].classList.remove('active');
                buttons[1].classList.add('active');
            }}
        }}

        function handleSearch() {{
            const query = document.getElementById('searchInput').value.toLowerCase().trim();

            // Search in Network Graph
            if (query !== '') {{
                const foundNode = nodesData.find(n => 
                    n.label.toLowerCase().includes(query) || 
                    `#${{n.id}}`.includes(query) || 
                    (n.id < 10 && `#0${{n.id}}`.includes(query))
                );

                if (foundNode && network) {{
                    network.focus(foundNode.id, {{ scale: 1.2, animation: true }});
                    network.selectNodes([foundNode.id]);
                    highlightGraphConnections(foundNode.id);
                }}
            }}

            // Search in Grid View Cards
            const cards = document.querySelectorAll('.room-card');
            cards.forEach(card => {{
                const name = card.dataset.name;
                const id = card.dataset.id;
                const matches = name.includes(query) || id.includes(query) || `#${{id}}`.includes(query) || (id < 10 && `#0${{id}}`.includes(query));
                card.style.display = matches ? 'flex' : 'none';
            }});
        }}

        let selectedCardId = null;
        function selectRoomCard(id) {{
            const allCards = document.querySelectorAll('.room-card');
            
            if (selectedCardId === id) {{
                selectedCardId = null;
                allCards.forEach(c => c.classList.remove('active-selected', 'connected-highlight', 'dimmed'));
                return;
            }}

            selectedCardId = id;
            const targetCard = document.getElementById(`room-${{id}}`);
            if (!targetCard) return;

            const connected = [
                targetCard.dataset.left,
                targetCard.dataset.right,
                targetCard.dataset.up,
                targetCard.dataset.down
            ].filter(x => x !== '');

            allCards.forEach(c => {{
                const cid = c.dataset.id;
                c.classList.remove('active-selected', 'connected-highlight', 'dimmed');
                if (cid == id) c.classList.add('active-selected');
                else if (connected.includes(cid)) c.classList.add('connected-highlight');
                else c.classList.add('dimmed');
            }});
        }}

        // Window Load Event
        window.addEventListener('load', function() {{
            initNetwork();
        }});
    </script>
</body>
</html>
"""

target_file = r"C:\Users\87003101\Documents\Progetti\asm\ZXSPECTRUM-JETSETWILLY\scratch\room_connections.html"
with open(target_file, "w", encoding="utf-8") as f:
    f.write(html_content)

print("Flowchart HTML successfully generated in room_connections.html")
