import os, copy
import reportlab
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super().showPage()
        super().save()

    def draw_page_decorations(self, page_count):
        self.saveState()
        self.setFont("Helvetica-Bold", 8)
        self.setFillColor(colors.HexColor("#334155"))
        
        # Running Header (top)
        self.drawString(36, 812, "Documentazione Tecnica — Gestione del Salto e della Fisica")
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.5)
        self.line(36, 804, 559, 804)
        
        # Running Footer (bottom)
        self.line(36, 42, 559, 42)
        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#64748B"))
        self.drawString(36, 30, "ZX Spectrum Jet Set Willy — Guida alla Fisica del Salto e della Gravità")
        page_text = f"Pagina {self._pageNumber} di {page_count}"
        self.drawRightString(559, 30, page_text)
        self.restoreState()

def build_pdf(filename):
    styles = getSampleStyleSheet()
    
    # Custom Styles
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=18,
        leading=22,
        textColor=colors.HexColor("#0F172A"),
        spaceAfter=3
    )
    
    subtitle_style = ParagraphStyle(
        'DocSubTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Oblique',
        fontSize=9.5,
        leading=13,
        textColor=colors.HexColor("#475569"),
        spaceAfter=10
    )
    
    h1_style = ParagraphStyle(
        'Heading1_Custom',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=11,
        leading=13.5,
        textColor=colors.HexColor("#1E293B"),
        spaceBefore=8,
        spaceAfter=3,
        keepWithNext=True
    )
    
    h2_style = ParagraphStyle(
        'Heading2_Custom',
        parent=styles['Heading2'],
        fontName='Helvetica-Bold',
        fontSize=9,
        leading=11.5,
        textColor=colors.HexColor("#334155"),
        spaceBefore=6,
        spaceAfter=2,
        keepWithNext=True
    )
    
    body_style = ParagraphStyle(
        'Body_Custom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8,
        leading=11,
        textColor=colors.HexColor("#334155"),
        spaceAfter=3
    )

    bullet_style = ParagraphStyle(
        'Bullet_Custom',
        parent=body_style,
        leftIndent=8,
        spaceAfter=2
    )
    
    code_style = ParagraphStyle(
        'Code_Custom',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=7,
        leading=9.5,
        textColor=colors.HexColor("#0F172A")
    )
    
    table_header_style = ParagraphStyle(
        'TableHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=7.5,
        leading=9.5,
        textColor=colors.white,
        alignment=0
    )
    
    table_cell_style = ParagraphStyle(
        'TableCell',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=7,
        leading=9.5,
        textColor=colors.HexColor("#1E293B")
    )
    
    table_cell_bold = ParagraphStyle(
        'TableCellBold',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=7,
        leading=9.5,
        textColor=colors.HexColor("#0F172A")
    )
    
    table_cell_code = ParagraphStyle(
        'TableCellCode',
        parent=styles['Normal'],
        fontName='Courier-Bold',
        fontSize=7,
        leading=9.5,
        textColor=colors.HexColor("#0284C7")
    )

    def generate_story():
        story = []
        # Title Header
        story.append(Paragraph("Gestione del Salto e della Fisica di Gioco", title_style))
        story.append(Paragraph("Guida completa alla configurazione della gravità e dell'impulso del salto a livello globale e di singola stanza in <i>Jet Set Willy</i>", subtitle_style))
        story.append(HRFlowable(width="100%", thickness=1.5, color=colors.HexColor("#0284C7"), spaceAfter=6))
        
        # Intro text
        intro_p = ("In <i>Jet Set Willy</i> per ZX Spectrum, la fisica del movimento, del salto e della gravità è un elemento "
                   "centrale per il bilanciamento del gameplay. Il motore di gioco consente una personalizzazione flessibile a due livelli: "
                   "<b>globale</b> (tramite costanti centralizzate e parametri di compilazione) e <b>per-stanza</b> "
                   "(tramite il byte di configurazione ad offset 239 nel file della stanza). "
                   "Questa guida documenta la struttura binaria del byte di fisica, la codifica dei 4 bit del salto (0..15), i preset di gravità ed i dettagli del motore <code>physics.asm</code>.")
        story.append(Paragraph(intro_p, body_style))
        story.append(Spacer(1, 3))
        
        # Section 1
        story.append(Paragraph("1. Configurazione della Fisica a Livello di Stanza (Offset 239 — Byte %GGGGJJJJ)", h1_style))
        story.append(Paragraph("All'interno della struttura binaria da 286 byte di ciascuna stanza (es. <code>FirstLandingLayout</code>, <code>TheBowLayout</code>), il byte all'<b>offset 239</b> (<code>OFFSET_PHYSICS_SETTINGS</code>) definisce la fisica specifica della stanza nel formato a bit <code>%GGGGJJJJ</code> (valore esadecimale <code>$GJ</code>):", body_style))
        
        table_byte_struct = [
            [Paragraph("Campo Bit", table_header_style),
             Paragraph("Posizione", table_header_style),
             Paragraph("Simbolo RAM", table_header_style),
             Paragraph("Funzione Logica e Intervallo Valori Supported", table_header_style)],
            [Paragraph("JJJJ", table_cell_code), Paragraph("Bit 3 - 0", table_cell_bold), Paragraph("room_jump_strength", table_cell_code), Paragraph("<b>Forza / Impulso iniziale del salto</b> (supporta tutti i valori da 0 a 15). Imposta la velocità iniziale verso l'alto $V_y$ espressa in pixel/frame al momento dello stacco.", table_cell_style)],
            [Paragraph("GGGG", table_cell_code), Paragraph("Bit 7 - 4", table_cell_bold), Paragraph("room_gravity_preset", table_cell_code), Paragraph("<b>Preset della Gravità</b> (0..15). Seleziona il modello ed la frequenza di accelerazione verso il basso (-1px) applicata nei frame di volo per plasmare la parabola del salto.", table_cell_style)],
        ]
        t_byte = Table(table_byte_struct, colWidths=[55, 60, 115, 293])
        t_byte.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#1E293B")),
            ('ALIGN', (0,0), (-1,-1), 'LEFT'),
            ('VALIGN', (0,0), (-1,-1), 'TOP'),
            ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F8FAFC"), colors.white]),
            ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
            ('TOPPADDING', (0,0), (-1,-1), 2.5),
            ('BOTTOMPADDING', (0,0), (-1,-1), 2.5),
        ]))
        story.append(t_byte)
        story.append(Spacer(1, 3))
        
        story.append(Paragraph("<b>Valore Speciale 0 ($00):</b> Se l'offset 239 è <code>0</code> (es. <code>DEFB 0</code>), <code>Phys_LoadRoomSettings</code> eredita automaticamente i default globali (<code>DEFAULT_JUMP_STRENGTH</code> e <code>DEFAULT_GRAVITY_PRESET</code>).", body_style))
        story.append(Spacer(1, 4))

        # Section 2: Tabella Completa dei Valori di Salto JJJJ (0..15)
        story.append(Paragraph("2. Mappa Completa dei Valori dell'Impulso del Salto (JJJJ — Bit 3..0)", h1_style))
        story.append(Paragraph("I 4 bit inferiori <code>JJJJ</code> possono memorizzare <b>qualsiasi valore binario da 0 a 15</b> (%0000 fino a %1111). Di seguito è riportata la mappa completa con il significato pratico di ciascun valore:", body_style))

        table_jjjj_data = [
            [Paragraph("Valore (Dec)", table_header_style),
             Paragraph("Bit JJJJ (4-bit)", table_header_style),
             Paragraph("Impulso V_y Iniziale", table_header_style),
             Paragraph("Altezza Salto Risultante (con Gravità 0.75)", table_header_style),
             Paragraph("Note di Giocabilità e Descrizione", table_header_style)],
            [Paragraph("0", table_cell_code), Paragraph("%0000", table_cell_code), Paragraph("0 px/frame", table_cell_bold), Paragraph("0 pixel (Nessun salto)", table_cell_style), Paragraph("Salto disabilitato (Willy si stacca ma non sale).", table_cell_style)],
            [Paragraph("1", table_cell_code), Paragraph("%0001", table_cell_code), Paragraph("1 px/frame", table_cell_bold), Paragraph("~1 pixel (Micro-balzo)", table_cell_style), Paragraph("Impulso impercettibile per ostacoli microscopici.", table_cell_style)],
            [Paragraph("2", table_cell_code), Paragraph("%0010", table_cell_code), Paragraph("2 px/frame", table_cell_bold), Paragraph("~3 pixel (Balzetto)", table_cell_style), Paragraph("Piccolissima elevazione inferiore ad 1 tile.", table_cell_style)],
            [Paragraph("3", table_cell_code), Paragraph("%0011", table_cell_code), Paragraph("3 px/frame", table_cell_bold), Paragraph("~7 pixel (< 1 Tile)", table_cell_style), Paragraph("Salto ultra-corto, non supera neanche 1 blocco.", table_cell_style)],
            [Paragraph("4", table_cell_code), Paragraph("%0100", table_cell_code), Paragraph("4 px/frame", table_cell_bold), Paragraph("<b>~12 pixel (~1.5 Tile)</b>", table_cell_bold), Paragraph("<b>Salto Corto</b>. Ideale per passaggi stretti e soffitti bassi.", table_cell_style)],
            [Paragraph("5", table_cell_code), Paragraph("%0101", table_cell_code), Paragraph("5 px/frame", table_cell_bold), Paragraph("<b>~18 pixel (~2.2 Tile)</b>", table_cell_bold), Paragraph("<b>Salto Medio-Corto</b>. Ottimo per stanze compatte (es. $15).", table_cell_style)],
            [Paragraph("6", table_cell_code), Paragraph("%0110", table_cell_code), Paragraph("6 px/frame", table_cell_bold), Paragraph("<b>~27 pixel (~3.4 Tile)</b>", table_cell_bold), Paragraph("<b>Salto Standard Jet Set Willy</b> (Valore originale di default).", table_cell_style)],
            [Paragraph("7", table_cell_code), Paragraph("%0111", table_cell_code), Paragraph("7 px/frame", table_cell_bold), Paragraph("<b>~36 pixel (~4.5 Tile)</b>", table_cell_bold), Paragraph("<b>Salto Alto/Lungo</b>. Supera ostacoli alti fino a 4 blocchi.", table_cell_style)],
            [Paragraph("8", table_cell_code), Paragraph("%1000", table_cell_code), Paragraph("8 px/frame", table_cell_bold), Paragraph("~48 pixel (~6.0 Tile)", table_cell_style), Paragraph("Super Salto. Molto potente per grandi dislivelli.", table_cell_style)],
            [Paragraph("9 .. 15", table_cell_code), Paragraph("%1001..%1111", table_cell_code), Paragraph("9 .. 15 px/frame", table_cell_bold), Paragraph("50 .. 120+ pixel", table_cell_style), Paragraph("Mega Salti/Estremi. Willy balza attraverso mezza schermata.", table_cell_style)],
        ]
        t_jjjj = Table(table_jjjj_data, colWidths=[50, 65, 75, 135, 198])
        t_jjjj.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#0F172A")),
            ('ALIGN', (0,0), (-1,-1), 'LEFT'),
            ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
            ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F8FAFC"), colors.white]),
            ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
            ('TOPPADDING', (0,0), (-1,-1), 2),
            ('BOTTOMPADDING', (0,0), (-1,-1), 2),
        ]))
        story.append(t_jjjj)
        story.append(Spacer(1, 4))
        story.append(Paragraph("<b>Perché nel manuale sono evidenziati 4, 5, 6, 7?</b> Il motore di gioco accetta qualsiasi valore da 0 a 15. Tuttavia, 4, 5, 6 e 7 rappresentano gli unici valori <i>pratici e bilanciati</i> per il level design delle 60 stanze di Jet Set Willy. I valori da 0 a 3 risultano troppo bassi per superare anche 1 singolo blocco solido, mentre i valori da 8 a 15 causano salti sproporzionati verso il soffitto.", body_style))
        story.append(Spacer(1, 4))

        # Section 3: Come Scrivere in Binario ed Esadecimale (Risposta diretta alla domanda)
        story.append(Paragraph("3. Guida alla Scrittura del Salto Corto (Valore 4) nei Bit da 0 a 3", h1_style))
        story.append(Paragraph("Per configurare il <b>Salto Corto (valore 4)</b> nei bit inferiori <code>JJJJ</code>, la conversione in binario per i 4 bit da 0 a 3 è esattamente <b>%0100</b>.", body_style))
        story.append(Paragraph("Ecco la procedura passo-passo per comporre il byte completo <code>%GGGGJJJJ</code> nel codice sorgente Assembly:", body_style))
        story.append(Paragraph("• <b>Passo 1 — Imposta i 4 bit del Salto JJJJ (Bit 3..0):</b> Per il valore 4 &rarr; <code>%0100</code>.", bullet_style))
        story.append(Paragraph("• <b>Passo 2 — Scegli i 4 bit della Gravità GGGG (Bit 7..4):</b> Esempio Gravità Standard 0.75 (Preset 1) &rarr; <code>%0001</code>.", bullet_style))
        story.append(Paragraph("• <b>Passo 3 — Unisci le due metà:</b> <code>GGGG</code> (%0001) + <code>JJJJ</code> (%0100) = <b>%00010100</b>.", bullet_style))
        story.append(Paragraph("• <b>Passo 4 — Scrivi la direttiva DEFB:</b> In esadecimale `%0001` è `$1` e `%0100` è `$4`, quindi il byte è <b>$14</b> (oppure decimale <b>20</b>).", bullet_style))

        code_example_step = (
            "; --- Esempio 1: Salto Corto (4) con Gravità Standard 0.75 (1) ---\n"
            "MyRoomUnused:\n"
            "    DEFB %00010100                     ; Binario: GGGG=0001 (1), JJJJ=0100 (4)\n"
            "    ; Oppure equivalente in Esadecimale:\n"
            "    DEFB $14                           ; $1=Gravità 1, $4=Salto 4\n\n"
            "; --- Esempio 2: Salto Medio-Corto (5) con Gravità Standard 0.75 (1) ---\n"
            "MyRoomUnused:\n"
            "    DEFB $15                           ; $1=Gravità 1 (%0001), $5=Salto 5 (%0101)"
        )
        code_step_table = Table([[Paragraph(code_example_step.replace('\n', '<br/>').replace(' ', '&nbsp;'), code_style)]], colWidths=[523])
        code_step_table.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F1F5F9")),
            ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
            ('TOPPADDING', (0,0), (-1,-1), 4),
            ('BOTTOMPADDING', (0,0), (-1,-1), 4),
            ('LEFTPADDING', (0,0), (-1,-1), 6),
            ('RIGHTPADDING', (0,0), (-1,-1), 6),
        ]))
        story.append(code_step_table)
        story.append(Spacer(1, 4))

        # Section 4: Preset di Gravità
        story.append(Paragraph("4. Tabella dei Preset di Gravità Disponibili (GGGG — Bit 7..4)", h1_style))
        story.append(Paragraph("I 4 bit superiori <code>GGGG</code> selezionano l'accelerazione gravitazionale gestita da <code>Phys_ApplyGravity</code>:", body_style))

        table_presets_data = [
            [Paragraph("ID Preset", table_header_style),
             Paragraph("GGGG (Bin / Hex)", table_header_style),
             Paragraph("Valore Gravità", table_header_style),
             Paragraph("Frequenza di Applicazione nei Frame", table_header_style),
             Paragraph("Comportamento & Parabole Salto", table_header_style)],
            [Paragraph("0", table_cell_code), Paragraph("%0000 ($0_)", table_cell_code), Paragraph("0.50 px/frame", table_cell_bold), Paragraph("Applica gravità 1 frame su 2 (<code>frame % 2 == 0</code>)", table_cell_style), Paragraph("Gravità Leggera. Traiettoria fluttuante a mezz'aria.", table_cell_style)],
            [Paragraph("1", table_cell_code), Paragraph("%0001 ($1_)", table_cell_code), Paragraph("0.75 px/frame", table_cell_bold), Paragraph("Applica gravità 3 frame su 4 (<code>frame % 4 != 3</code>)", table_cell_style), Paragraph("<b>Standard Jet Set Willy</b> (Default di gioco).", table_cell_style)],
            [Paragraph("2", table_cell_code), Paragraph("%0010 ($2_)", table_cell_code), Paragraph("1.00 px/frame", table_cell_bold), Paragraph("Applica gravità ad ogni frame (nessun salto)", table_cell_style), Paragraph("Gravità Pesante. Discesa rapida e controllata.", table_cell_style)],
            [Paragraph("3", table_cell_code), Paragraph("%0011 ($3_)", table_cell_code), Paragraph("0.25 px/frame", table_cell_bold), Paragraph("Applica gravità 1 frame su 4 (<code>frame % 4 == 3</code>)", table_cell_style), Paragraph("Gravità Molto Leggera (Effetto 'Luna').", table_cell_style)],
            [Paragraph("4", table_cell_code), Paragraph("%0100 ($4_)", table_cell_code), Paragraph("0.00 px/frame", table_cell_bold), Paragraph("Non applica mai gravità durante il volo", table_cell_style), Paragraph("Assenza di Gravità. Salto a velocità costante.", table_cell_style)],
            [Paragraph("5", table_cell_code), Paragraph("%0101 ($5_)", table_cell_code), Paragraph("0.875 px/frame", table_cell_bold), Paragraph("Salta gravità 1 frame su 8 (<code>frame % 8 == 5</code>)", table_cell_style), Paragraph("Gravità Intermedia A (Ottima per salti al limite ~23.5px).", table_cell_style)],
            [Paragraph("6", table_cell_code), Paragraph("%0110 ($6_)", table_cell_code), Paragraph("0.625 px/frame", table_cell_bold), Paragraph("Salta gravità 2 frame su 8 (<code>frame % 8 == 3, 7</code>)", table_cell_style), Paragraph("Gravità Intermedia B (Più morbida della 0.75).", table_cell_style)],
        ]
        t_presets = Table(table_presets_data, colWidths=[40, 75, 70, 145, 193])
        t_presets.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#0284C7")),
            ('ALIGN', (0,0), (-1,-1), 'LEFT'),
            ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
            ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F0F9FF"), colors.white]),
            ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#BAE6FD")),
            ('TOPPADDING', (0,0), (-1,-1), 2),
            ('BOTTOMPADDING', (0,0), (-1,-1), 2),
        ]))
        story.append(t_presets)
        story.append(Spacer(1, 4))

        # Section 5: Esempi Combinati
        story.append(Paragraph("5. Esempi Pratici di Combinazione per le Stanze", h1_style))
        story.append(Paragraph("Di seguito una sintesi delle combinazioni esadecimali/binarie usate nei file delle stanze:", body_style))
        
        table_examples_data = [
            [Paragraph("Valore Hex", table_header_style), Paragraph("Binario %GGGGJJJJ", table_header_style), Paragraph("Salto (J)", table_header_style), Paragraph("Gravità (G)", table_header_style), Paragraph("Altezza Raggiunta", table_header_style), Paragraph("Utilizzo Consigliato", table_header_style)],
            [Paragraph("$00", table_cell_code), Paragraph("%00000000", table_cell_code), Paragraph("6 (Default)", table_cell_style), Paragraph("0.75 (Default)", table_cell_style), Paragraph("~27 pixel", table_cell_bold), Paragraph("Default ereditato da <code>physics_config.asm</code>.", table_cell_style)],
            [Paragraph("$14", table_cell_code), Paragraph("%00010100", table_cell_code), Paragraph("4 (Corto)", table_cell_style), Paragraph("0.75 (Standard)", table_cell_style), Paragraph("~12 pixel", table_cell_bold), Paragraph("Salto ultracompatto per passaggi con soffitto basso.", table_cell_style)],
            [Paragraph("$15", table_cell_code), Paragraph("%00010101", table_cell_code), Paragraph("5 (Medio/Corto)", table_cell_style), Paragraph("0.75 (Standard)", table_cell_style), Paragraph("~18 pixel", table_cell_bold), Paragraph("Salto compatto per stanze ristrette.", table_cell_style)],
            [Paragraph("$05", table_cell_code), Paragraph("%00000101", table_cell_code), Paragraph("5 (Medio/Corto)", table_cell_style), Paragraph("0.50 (Leggera)", table_cell_style), Paragraph("~24 pixel", table_cell_bold), Paragraph("Parabola estesa per coperire distanze orizzontali.", table_cell_style)],
            [Paragraph("$26", table_cell_code), Paragraph("%00100110", table_cell_code), Paragraph("6 (Standard)", table_cell_style), Paragraph("1.00 (Pesante)", table_cell_style), Paragraph("~21 pixel", table_cell_bold), Paragraph("<b>Consigliato per The Bow</b>: spinta decisa e discesa rapida.", table_cell_style)],
            [Paragraph("$56", table_cell_code), Paragraph("%01010110", table_cell_code), Paragraph("6 (Standard)", table_cell_style), Paragraph("0.875 (Intermedia)", table_cell_style), Paragraph("~23.5 pixel", table_cell_bold), Paragraph("Bilanciamento ideale tra 0.75 e 1.0 per salti tecnici.", table_cell_style)],
        ]
        t_examples = Table(table_examples_data, colWidths=[45, 75, 55, 65, 95, 188])
        t_examples.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#1E293B")),
            ('ALIGN', (0,0), (-1,-1), 'LEFT'),
            ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
            ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F8FAFC"), colors.white]),
            ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
            ('TOPPADDING', (0,0), (-1,-1), 2),
            ('BOTTOMPADDING', (0,0), (-1,-1), 2),
        ]))
        story.append(t_examples)
        story.append(Spacer(1, 4))

        # Section 6: Codice Sorgente Decodifica
        story.append(Paragraph("6. Logica di Decodifica nel Sorgente Assembly (physics.asm)", h1_style))
        story.append(Paragraph("Come la routine <code>Phys_LoadRoomSettings</code> estrae <code>JJJJ</code> e <code>GGGG</code> dal byte dell'offset 239:", body_style))

        code_asm_text = (
            "Phys_LoadRoomSettings:\n"
            "    ld   hl, (room_ptr)\n"
            "    ld   de, OFFSET_PHYSICS_SETTINGS   ; Offset 239\n"
            "    add  hl, de\n"
            "    ld   a, (hl)                       ; A = %GGGGJJJJ\n"
            "    or   a : jr nz, .custom_settings\n"
            "    ld   a, DEFAULT_JUMP_STRENGTH : ld (room_jump_strength), a\n"
            "    ld   a, DEFAULT_GRAVITY_PRESET : ld (room_gravity_preset), a\n"
            "    ret\n"
            ".custom_settings:\n"
            "    push af\n"
            "    and  $0f                          ; AND %00001111 -> Estrae solo JJJJ (Bit 3..0)\n"
            "    ld   (room_jump_strength), a      ; Salva in room_jump_strength (0..15)\n"
            "    pop  af\n"
            "    srl  a : srl  a : srl  a : srl  a  ; Shift 4 bit a destra -> Isola GGGG (Bit 7..4)\n"
            "    ld   (room_gravity_preset), a     ; Salva in room_gravity_preset (0..15)\n"
            "    ret"
        )
        code_asm_table = Table([[Paragraph(code_asm_text.replace('\n', '<br/>').replace(' ', '&nbsp;'), code_style)]], colWidths=[523])
        code_asm_table.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F1F5F9")),
            ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
            ('TOPPADDING', (0,0), (-1,-1), 4),
            ('BOTTOMPADDING', (0,0), (-1,-1), 4),
            ('LEFTPADDING', (0,0), (-1,-1), 6),
            ('RIGHTPADDING', (0,0), (-1,-1), 6),
        ]))
        story.append(code_asm_table)
        return story

    # Try primary file first, fall back to _v2.pdf if primary is locked
    try:
        doc = SimpleDocTemplate(
            filename,
            pagesize=A4,
            leftMargin=36,
            rightMargin=36,
            topMargin=48,
            bottomMargin=48
        )
        doc.build(generate_story(), canvasmaker=NumberedCanvas)
        print("PDF build successful:", filename)
    except PermissionError:
        alt_path = filename.replace('.pdf', '_v2.pdf')
        doc = SimpleDocTemplate(
            alt_path,
            pagesize=A4,
            leftMargin=36,
            rightMargin=36,
            topMargin=48,
            bottomMargin=48
        )
        doc.build(generate_story(), canvasmaker=NumberedCanvas)
        print(f"Primary file locked. Built alternate PDF successfully: {alt_path}")

if __name__ == '__main__':
    pdf_path = os.path.join('documentation', 'manual', 'Gestione_Salto_Fisica_JetSetWilly.pdf')
    build_pdf(pdf_path)
