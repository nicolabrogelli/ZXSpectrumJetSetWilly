import os
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
        self.drawString(36, 812, "Documentazione Tecnica — Architettura e Configurazione dei Guardiani")
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.5)
        self.line(36, 804, 559, 804)
        
        # Running Footer (bottom)
        self.line(36, 42, 559, 42)
        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#64748B"))
        self.drawString(36, 30, "ZX Spectrum Jet Set Willy — Guida alla Configurazione dei Guardiani")
        page_text = f"Pagina {self._pageNumber} di {page_count}"
        self.drawRightString(559, 30, page_text)
        self.restoreState()

def build_pdf(filename):
    doc = SimpleDocTemplate(
        filename,
        pagesize=A4,
        leftMargin=36,
        rightMargin=36,
        topMargin=48,
        bottomMargin=48
    )
    
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
        fontSize=11.5,
        leading=14,
        textColor=colors.HexColor("#1E293B"),
        spaceBefore=10,
        spaceAfter=4,
        keepWithNext=True
    )
    
    h2_style = ParagraphStyle(
        'Heading2_Custom',
        parent=styles['Heading2'],
        fontName='Helvetica-Bold',
        fontSize=9.5,
        leading=12,
        textColor=colors.HexColor("#334155"),
        spaceBefore=7,
        spaceAfter=3,
        keepWithNext=True
    )
    
    body_style = ParagraphStyle(
        'Body_Custom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.5,
        leading=11.5,
        textColor=colors.HexColor("#334155"),
        spaceAfter=4
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
        fontSize=7.5,
        leading=10,
        textColor=colors.HexColor("#0F172A")
    )
    
    table_header_style = ParagraphStyle(
        'TableHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=8,
        leading=10,
        textColor=colors.white,
        alignment=0
    )
    
    table_cell_style = ParagraphStyle(
        'TableCell',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=7.5,
        leading=10,
        textColor=colors.HexColor("#1E293B")
    )
    
    table_cell_bold = ParagraphStyle(
        'TableCellBold',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=7.5,
        leading=10,
        textColor=colors.HexColor("#0F172A")
    )
    
    table_cell_code = ParagraphStyle(
        'TableCellCode',
        parent=styles['Normal'],
        fontName='Courier-Bold',
        fontSize=7.5,
        leading=10,
        textColor=colors.HexColor("#0284C7")
    )

    story = []
    
    # Title Header
    story.append(Paragraph("Architettura e Configurazione dei Guardiani", title_style))
    story.append(Paragraph("Analisi della struttura dati in ROM/RAM, codifica Bit/Flags, tipi di Nemici e gestione del Movimento in <i>Jet Set Willy</i>", subtitle_style))
    story.append(HRFlowable(width="100%", thickness=1.5, color=colors.HexColor("#0284C7"), spaceAfter=8))
    
    # Intro text
    intro_p = ("In <i>Jet Set Willy</i> per ZX Spectrum, la gestione dei nemici (comunemente denominati <b>Guardiani</b>) "
               "è integrata all'interno della struttura binaria da 286 byte di ogni stanza. "
               "Ogni stanza supporta fino a un massimo di <b>8 guardiani indipendenti</b> (slot da 5 byte ciascuno in ROM), "
               "oltre a due array dedicati alla definizione delle palette colore (4 byte per i nemici 1-4 e 4 byte per i nemici 5-8). "
               "Questa guida documenta la codifica binaria, la scelta degli sprite, il comportamento dinamico in RAM ed il flusso di esecuzione delle routine in <code>enemy.asm</code>.")
    story.append(Paragraph(intro_p, body_style))
    story.append(Spacer(1, 4))
    
    # Section 1
    story.append(Paragraph("1. Anatomia della Struttura Dati dei Guardiani nella Stanza (Offset Memoria)", h1_style))
    story.append(Paragraph("All'interno della struttura di 286 byte della stanza (es. <code>BallRoomEastLayout</code>), i guardiani occupano esattamente <b>48 byte</b> suddivisi in tre sezioni fisse:", body_style))
    
    table1_data = [
        [Paragraph("Offset (Byte)", table_header_style),
         Paragraph("Dimensione", table_header_style),
         Paragraph("Sezione Dati (Simbolo)", table_header_style),
         Paragraph("Descrizione e Ruolo nel Gioco", table_header_style)],
        [Paragraph("223 - 226", table_cell_code), Paragraph("4 Byte", table_cell_style), Paragraph("EnemyColors1_4", table_cell_bold), Paragraph("Palette colori per i guardiani da Slot 1 a Slot 4 (1 byte di attributo Spectrum per ciascuno).", table_cell_style)],
        [Paragraph("240 - 279", table_cell_code), Paragraph("40 Byte", table_cell_style), Paragraph("Enemies 1-8", table_cell_bold), Paragraph("8 definizioni di guardiani (5 byte per ciascuno): Flags/Fase, Tipo Sprite, Pos Iniziale, Coordinata Fissa e Limite di Movimento.", table_cell_style)],
        [Paragraph("282 - 285", table_cell_code), Paragraph("4 Byte", table_cell_style), Paragraph("EnemyColors5_8", table_cell_bold), Paragraph("Palette colori per i guardiani da Slot 5 a Slot 8 (1 byte di attributo Spectrum per ciascuno).", table_cell_style)],
    ]
    t1 = Table(table1_data, colWidths=[65, 55, 105, 298])
    t1.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#1E293B")),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F8FAFC"), colors.white]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
        ('TOPPADDING', (0,0), (-1,-1), 3),
        ('BOTTOMPADDING', (0,0), (-1,-1), 3),
    ]))
    story.append(t1)
    story.append(Spacer(1, 6))
    
    story.append(Paragraph("Struttura dei 5 Byte di Configurazione in ROM per Ciascun Guardiano:", h2_style))
    table2_data = [
        [Paragraph("Byte ROM", table_header_style),
         Paragraph("Nome Campo", table_header_style),
         Paragraph("Formato Bit / Valore", table_header_style),
         Paragraph("Funzione e Significato Logico", table_header_style)],
        [Paragraph("Byte 0", table_cell_code), Paragraph("Flags & Fase", table_cell_bold), Paragraph("%A V F1 F0 - - - -", table_cell_code), Paragraph("<b>Bit 7 (A)</b>: Active (1=Attivo, 0=Disattivato).<br/><b>Bit 6 (V)</b>: Asse (0=Orizzontale, 1=Verticale).<br/><b>Bit 5-4 (F)</b>: Fase di spawn iniziale (0..3).", table_cell_style)],
        [Paragraph("Byte 1", table_cell_code), Paragraph("Type (Sprite)", table_cell_bold), Paragraph("%- - T5..T0", table_cell_code), Paragraph("<b>Bit 5-0</b>: ID Tipo Sprite Nemico (0..41, es. 0=Lametta, 2=Uccello, 6=Faccia, 13=Canguro, ecc.).", table_cell_style)],
        [Paragraph("Byte 2", table_cell_code), Paragraph("Start Coordinate", table_cell_bold), Paragraph("0 .. 255 pixel", table_cell_code), Paragraph("Coordinata iniziale lungo l'asse dinamico (<b>StartX</b> se Orizzontale, <b>StartY</b> se Verticale).", table_cell_style)],
        [Paragraph("Byte 3", table_cell_code), Paragraph("Fixed Coordinate", table_cell_bold), Paragraph("0 .. 255 pixel", table_cell_code), Paragraph("Coordinata fissa lungo l'asse ortogonale (<b>StartY</b> se Orizzontale, <b>StartX</b> se Verticale).", table_cell_style)],
        [Paragraph("Byte 4", table_cell_code), Paragraph("Limit Coordinate", table_cell_bold), Paragraph("0 .. 255 pixel", table_cell_code), Paragraph("Coordinata di fine corsa lungo l'asse dinamico. Insieme a Start forma l'intervallo [MinLimit, MaxLimit].", table_cell_style)],
    ]
    t2 = Table(table2_data, colWidths=[55, 95, 105, 268])
    t2.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#0284C7")),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F0F9FF"), colors.white]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#BAE6FD")),
        ('TOPPADDING', (0,0), (-1,-1), 3),
        ('BOTTOMPADDING', (0,0), (-1,-1), 3),
    ]))
    story.append(t2)
    story.append(Spacer(1, 6))
    
    # Section 2
    story.append(Paragraph("2. Codifica del Byte 0 (Flags, Asse e Fase Iniziale)", h1_style))
    story.append(Paragraph("Il Byte 0 controlla l'attivazione del nemico, l'asse di movimento e la sua posizione/direzione iniziale di spawn:", body_style))
    
    story.append(Paragraph("• <b>Bit 7 — Stato Attivazione (Active Flag):</b> <b>1</b> (&ge; $80 / 128) = Attivo (aggiornato e renderizzato); <b>0</b> (&lt; $80) = Inattivo (slot disattivato).", bullet_style))
    story.append(Paragraph("• <b>Bit 6 — Asse di Movimento (Movement Axis):</b> <b>0</b> ($00) = Movimento <b>Orizzontale</b> (Y fissa); <b>1</b> ($40 / +64) = Movimento <b>Verticale</b> (X fissa).", bullet_style))
    story.append(Paragraph("• <b>Bit 5-4 — Fase Iniziale di Spawn e Direzione (Phase Bits):</b> permettono di sfasare più nemici sulla stessa traiettoria:", bullet_style))

    table_phase_data = [
        [Paragraph("Bit 5-4", table_header_style),
         Paragraph("Valore Hex Flag", table_header_style),
         Paragraph("Fase", table_header_style),
         Paragraph("Posizione Iniziale di Calcolo in RAM", table_header_style),
         Paragraph("Direzione Iniziale", table_header_style)],
        [Paragraph("%00", table_cell_code), Paragraph("$80 / $C0", table_cell_code), Paragraph("Fase 0", table_cell_bold), Paragraph("Parte dalla coordinata iniziale impostata nel Byte 2 (<code>Start</code>).", table_cell_style), Paragraph("Destra / Basso (Dir = 2)", table_cell_style)],
        [Paragraph("%01", table_cell_code), Paragraph("$90 / $D0", table_cell_code), Paragraph("Fase 1", table_cell_bold), Paragraph("Parte a 1/4 del percorso: <code>MinLimit + (Delta / 4)</code>.", table_cell_style), Paragraph("Destra / Basso (Dir = 2)", table_cell_style)],
        [Paragraph("%10", table_cell_code), Paragraph("$A0 / $E0", table_cell_code), Paragraph("Fase 2", table_cell_bold), Paragraph("Parte a metà percorso: <code>MinLimit + (Delta / 2)</code>.", table_cell_style), Paragraph("Sinistra / Alto (Dir = 1)", table_cell_style)],
        [Paragraph("%11", table_cell_code), Paragraph("$B0 / $F0", table_cell_code), Paragraph("Fase 3", table_cell_bold), Paragraph("Parte dal limite massimo: <code>MaxLimit</code>.", table_cell_style), Paragraph("Sinistra / Alto (Dir = 1)", table_cell_style)],
    ]
    t_phase = Table(table_phase_data, colWidths=[45, 80, 45, 223, 130])
    t_phase.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#334155")),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F8FAFC"), colors.white]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 2.5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 2.5),
    ]))
    story.append(t_phase)
    story.append(Spacer(1, 6))
    
    # Section 3
    story.append(Paragraph("3. Tabella dei Tipi di Guardiani (Byte 1 — Sprite ID 0..41)", h1_style))
    story.append(Paragraph("Il motore di gioco include <b>42 tipi di sprite differenti</b> definiti in <code>constants.asm</code> e renderizzati da <code>Enemy_DrawRoom</code>:", body_style))
    
    table_types_data = [
        [Paragraph("ID", table_header_style), Paragraph("Costante ASM", table_header_style), Paragraph("Nome / Descrizione", table_header_style), Paragraph("Animazione & Note Direzionali", table_header_style)],
        [Paragraph("0", table_cell_code), Paragraph("LAMETTA", table_cell_code), Paragraph("Lametta / Razor", table_cell_style), Paragraph("Sprite direzionale (Left / Right), 4 frame.", table_cell_style)],
        [Paragraph("1", table_cell_code), Paragraph("SEGA", table_cell_code), Paragraph("Sega da falegname", table_cell_style), Paragraph("Sprite direzionale (Left / Right), 4 frame.", table_cell_style)],
        [Paragraph("2", table_cell_code), Paragraph("UCCELLO", table_cell_code), Paragraph("Uccello volante", table_cell_style), Paragraph("Sprite direzionale (Left / Right), 4 frame.", table_cell_style)],
        [Paragraph("3", table_cell_code), Paragraph("RADAR", table_cell_code), Paragraph("Radar rotante", table_cell_style), Paragraph("Omnidirezionale, 4 frame animati.", table_cell_style)],
        [Paragraph("4", table_cell_code), Paragraph("UOVO", table_cell_code), Paragraph("Uovo camminante", table_cell_style), Paragraph("Sprite direzionale (Left / Right), 4 frame.", table_cell_style)],
        [Paragraph("5", table_cell_code), Paragraph("UFO", table_cell_code), Paragraph("Disco volante UFO", table_cell_style), Paragraph("Omnidirezionale, 4 frame animati.", table_cell_style)],
        [Paragraph("6", table_cell_code), Paragraph("FACCIA", table_cell_code), Paragraph("Faccia sorridente", table_cell_style), Paragraph("Omnidirezionale, 4 frame animati.", table_cell_style)],
        [Paragraph("7", table_cell_code), Paragraph("SCIMMIA", table_cell_code), Paragraph("Scimmia", table_cell_style), Paragraph("Omnidirezionale, 4 frame animati.", table_cell_style)],
        [Paragraph("8", table_cell_code), Paragraph("ROBOT", table_cell_code), Paragraph("Robot da cucina", table_cell_style), Paragraph("Omnidirezionale, 4 frame animati.", table_cell_style)],
        [Paragraph("9", table_cell_code), Paragraph("PALLA", table_cell_code), Paragraph("Palla che rimbalza", table_cell_style), Paragraph("Omnidirezionale, 4 frame animati.", table_cell_style)],
        [Paragraph("10", table_cell_code), Paragraph("DOUBLE_BALL", table_cell_code), Paragraph("Doppia palla", table_cell_style), Paragraph("Sprite direzionale (Left / Right), 4 frame.", table_cell_style)],
        [Paragraph("11", table_cell_code), Paragraph("SOLDATO", table_cell_code), Paragraph("Guardia / Soldato", table_cell_style), Paragraph("Animazione ridotta a 2 frame (0..1).", table_cell_style)],
        [Paragraph("12", table_cell_code), Paragraph("MAIALE", table_cell_code), Paragraph("Maiale volante", table_cell_style), Paragraph("Sprite direzionale (Left / Right), 4 frame.", table_cell_style)],
        [Paragraph("13", table_cell_code), Paragraph("CANGURO", table_cell_code), Paragraph("Canguro saltellante", table_cell_style), Paragraph("Sprite direzionale, animazione a 8 frame (0..7).", table_cell_style)],
        [Paragraph("14", table_cell_code), Paragraph("FIORE", table_cell_code), Paragraph("Fiore / Pianta", table_cell_style), Paragraph("Omnidirezionale, 4 frame animati.", table_cell_style)],
        [Paragraph("15", table_cell_code), Paragraph("FACCIA_PALLA", table_cell_code), Paragraph("Faccia Palla", table_cell_style), Paragraph("Omnidirezionale, 4 frame animati.", table_cell_style)],
        [Paragraph("16", table_cell_code), Paragraph("CANDELABRO", table_cell_code), Paragraph("Candelabro acceso", table_cell_style), Paragraph("Animazione ridotta a 2 frame (0..1).", table_cell_style)],
        [Paragraph("17", table_cell_code), Paragraph("FRECCIA", table_cell_code), Paragraph("Freccia indicatrice", table_cell_style), Paragraph("Sprite direzionale (Left / Right).", table_cell_style)],
        [Paragraph("18..22", table_cell_code), Paragraph("TRONCHESE..FRATE", table_cell_code), Paragraph("Utensili / Nonnino / Frate", table_cell_style), Paragraph("Varianti animate (es. Frate con 2 direzioni).", table_cell_style)],
        [Paragraph("23..26", table_cell_code), Paragraph("FACE_HL..FACE_LR", table_cell_code), Paragraph("Faccia Gigante 32x32", table_cell_style), Paragraph("Sprite statico in 4 quadranti 16x16 (HL, HR, LL, LR).", table_cell_style)],
        [Paragraph("27..31", table_cell_code), Paragraph("PINZA..PINGUINO", table_cell_code), Paragraph("Gelato / Pinguino / Ruota", table_cell_style), Paragraph("Ostacoli e guardiani tematici.", table_cell_style)],
        [Paragraph("32..41", table_cell_code), Paragraph("MURO..PALAZZO", table_cell_code), Paragraph("Piede / Diavolo / Botte ecc.", table_cell_style), Paragraph("Nemici speciali e boss ambientali.", table_cell_style)],
    ]
    t_types = Table(table_types_data, colWidths=[35, 110, 125, 253])
    t_types.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#1E293B")),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F8FAFC"), colors.white]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
        ('TOPPADDING', (0,0), (-1,-1), 2),
        ('BOTTOMPADDING', (0,0), (-1,-1), 2),
    ]))
    story.append(t_types)
    story.append(Spacer(1, 6))

    # Section 4
    story.append(Paragraph("4. Struttura Dati Dinamica in RAM (ActiveEnemies)", h1_style))
    story.append(Paragraph("All'ingresso in una stanza, <code>Enemy_LoadRoom</code> alloca l'array <code>ActiveEnemies</code> in RAM (8 slot &times; 11 byte = <b>88 byte totali</b>):", body_style))

    table_ram_data = [
        [Paragraph("Offset RAM", table_header_style), Paragraph("Campo", table_header_style), Paragraph("Tipo Dati", table_header_style), Paragraph("Descrizione Logica e Utilizzo nel Frame Loop", table_header_style)],
        [Paragraph("Offset 0", table_cell_code), Paragraph("Flags", table_cell_bold), Paragraph("Byte", table_cell_style), Paragraph("Copia del Byte 0 della ROM (Active, Vertical, Phase).", table_cell_style)],
        [Paragraph("Offset 1", table_cell_code), Paragraph("Sprite Type", table_cell_bold), Paragraph("Byte", table_cell_style), Paragraph("Copia del Byte 1 della ROM (Tipo nemico 0..41).", table_cell_style)],
        [Paragraph("Offset 2", table_cell_code), Paragraph("Current X", table_cell_bold), Paragraph("Byte (Pixel)", table_cell_style), Paragraph("Coordinata X corrente a schermo (aggiornata di &plusmn;2px per frame se orizzontale).", table_cell_style)],
        [Paragraph("Offset 3", table_cell_code), Paragraph("Current Y", table_cell_bold), Paragraph("Byte (Pixel)", table_cell_style), Paragraph("Coordinata Y corrente a schermo (aggiornata di &plusmn;2px per frame se verticale).", table_cell_style)],
        [Paragraph("Offset 4", table_cell_code), Paragraph("Min Limit", table_cell_bold), Paragraph("Byte (Pixel)", table_cell_style), Paragraph("Calcolato come <code>min(Start, Limit)</code>. Limite inferiore/sinistro del percorso.", table_cell_style)],
        [Paragraph("Offset 5", table_cell_code), Paragraph("Max Limit", table_cell_bold), Paragraph("Byte (Pixel)", table_cell_style), Paragraph("Calcolato come <code>max(Start, Limit)</code>. Limite superiore/destro del percorso.", table_cell_style)],
        [Paragraph("Offset 6", table_cell_code), Paragraph("Direction", table_cell_bold), Paragraph("Byte (1 o 2)", table_cell_style), Paragraph("<b>1</b> = Sinistra/Alto (decrementa coord), <b>2</b> = Destra/Basso (incrementa coord).", table_cell_style)],
        [Paragraph("Offset 7", table_cell_code), Paragraph("Anim State", table_cell_bold), Paragraph("Byte (0..3/7)", table_cell_style), Paragraph("Contatore del frame d'animazione corrente, incrementato ad ogni movimento.", table_cell_style)],
        [Paragraph("Offset 8", table_cell_code), Paragraph("Old X", table_cell_bold), Paragraph("Byte (Pixel)", table_cell_style), Paragraph("Coordinata X del frame precedente, usata da <code>Enemy_EraseRoom</code> per pulire lo schermo.", table_cell_style)],
        [Paragraph("Offset 9", table_cell_code), Paragraph("Old Y", table_cell_bold), Paragraph("Byte (Pixel)", table_cell_style), Paragraph("Coordinata Y del frame precedente, usata da <code>Enemy_EraseRoom</code> per pulire lo schermo.", table_cell_style)],
        [Paragraph("Offset 10", table_cell_code), Paragraph("Color", table_cell_bold), Paragraph("Byte (Attr)", table_cell_style), Paragraph("Byte attributo colore ZX Spectrum recuperato da <code>EnemyColors1_4</code> o <code>EnemyColors5_8</code>.", table_cell_style)],
    ]
    t_ram = Table(table_ram_data, colWidths=[55, 75, 65, 328])
    t_ram.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#0F172A")),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F8FAFC"), colors.white]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 2.5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 2.5),
    ]))
    story.append(t_ram)
    story.append(Spacer(1, 6))

    # Section 5
    story.append(Paragraph("5. Gestione dei Colori ed Attributi Spectrum", h1_style))
    story.append(Paragraph("I colori dei guardiani sono definiti in due array separati da 4 byte nella stanza:", body_style))
    story.append(Paragraph("• <b>Offset 223 - 226 (EnemyColors1_4):</b> Colori per Slot 1..4. &nbsp;&nbsp;• <b>Offset 282 - 285 (EnemyColors5_8):</b> Colori per Slot 5..8.", bullet_style))
    story.append(Paragraph("Formato attributo Spectrum: <code>FLASH(1b) | BRIGHT(1b) | PAPER(3b) | INK(3b)</code>. Costanti da <code>constants.asm</code>:", body_style))

    table_color_data = [
        [Paragraph("Costante Standard", table_header_style), Paragraph("Hex", table_header_style), Paragraph("Costante FLASH", table_header_style), Paragraph("Hex", table_header_style), Paragraph("Colore Risultante a Schermo", table_header_style)],
        [Paragraph("NONE", table_cell_code), Paragraph("$00", table_cell_code), Paragraph("—", table_cell_style), Paragraph("—", table_cell_style), Paragraph("Nero / Trasparente (PAPER 0, INK 0)", table_cell_style)],
        [Paragraph("BLUE", table_cell_code), Paragraph("$01", table_cell_code), Paragraph("BLUE_FLASH", table_cell_code), Paragraph("$C1", table_cell_code), Paragraph("Blu (Standard / Lampeggiante)", table_cell_style)],
        [Paragraph("RED", table_cell_code), Paragraph("$02", table_cell_code), Paragraph("RED_FLASH", table_cell_code), Paragraph("$C2", table_cell_code), Paragraph("Rosso (Standard / Lampeggiante)", table_cell_style)],
        [Paragraph("MAGENTA", table_cell_code), Paragraph("$03", table_cell_code), Paragraph("MAGENTA_FLASH", table_cell_code), Paragraph("$C3", table_cell_code), Paragraph("Magenta / Viola (Standard / Flash)", table_cell_style)],
        [Paragraph("GREEN", table_cell_code), Paragraph("$04", table_cell_code), Paragraph("GREEN_FLASH", table_cell_code), Paragraph("$C4", table_cell_code), Paragraph("Verde (Standard / Flash)", table_cell_style)],
        [Paragraph("CYAN", table_cell_code), Paragraph("$05", table_cell_code), Paragraph("CYAN_FLASH", table_cell_code), Paragraph("$C5", table_cell_code), Paragraph("Ciano / Azzurro (Standard / Flash)", table_cell_style)],
        [Paragraph("YELLOW", table_cell_code), Paragraph("$06", table_cell_code), Paragraph("YELLOW_FLASH", table_cell_code), Paragraph("$C6", table_cell_code), Paragraph("Giallo (Standard / Flash)", table_cell_style)],
        [Paragraph("WHITE", table_cell_code), Paragraph("$07", table_cell_code), Paragraph("WHITE_FLASH", table_cell_code), Paragraph("$C7", table_cell_code), Paragraph("Bianco (Standard / Flash)", table_cell_style)],
    ]
    t_color = Table(table_color_data, colWidths=[90, 45, 95, 45, 248])
    t_color.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#047857")),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#ECFDF5"), colors.white]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#A7F3D0")),
        ('TOPPADDING', (0,0), (-1,-1), 2),
        ('BOTTOMPADDING', (0,0), (-1,-1), 2),
    ]))
    story.append(t_color)
    story.append(Spacer(1, 6))

    # Section 6
    story.append(Paragraph("6. Esempio Pratico di Configurazione Assembly (BallRoomEast.asm)", h1_style))
    story.append(Paragraph("Estratto dal file <code>rooms/BallRoomEast.asm</code> che illustra la dichiarazione di colori e guardiani:", body_style))

    code_text = (
        "; --- Palette Colori Nemici 1-4 (Offset 223) ---\n"
        "BallRoomEastReserved:\n"
        "    DEFB NONE, MAGENTA, CYAN, YELLOW     ; Nemico 1 (Nero), Nemico 2 (Magenta), Nemico 3 (Ciano), Nemico 4 (Giallo)\n\n"
        "; --- Definizioni dei 8 Nemici (Offset 240, 5 byte ciascuno) ---\n"
        "BallRoomEastEnemy1: DEFB 0, 0, 0, 0, 0                   ; Slot 1: Disattivato (Byte 0 = 0)\n"
        "BallRoomEastEnemy2: DEFB $C0, FACCIA, 40, 48, 87         ; Slot 2: Vert, Phase 0, Faccia, Y=40, X=48, LimitY=87\n"
        "BallRoomEastEnemy3: DEFB $E0, FACCIA, 56, 48, 96         ; Slot 3: Vert, Phase 2, Faccia, Y=56, X=48, LimitY=96\n"
        "BallRoomEastEnemy4: DEFB $C0, FACCIA, 88, 72, 96         ; Slot 4: Vert, Phase 0, Faccia, Y=88, X=72, LimitY=96\n"
        "BallRoomEastEnemy5: DEFB $80, UCCELLO, 112, 80, 232       ; Slot 5: Horiz, Phase 0, Uccello, X=112, Y=80, LimitX=232\n"
        "BallRoomEastEnemy6: DEFB 0, 0, 0, 0, 0                   ; Slot 6: Disattivato\n"
        "BallRoomEastEnemy7: DEFB 0, 0, 0, 0, 0                   ; Slot 7: Disattivato\n"
        "BallRoomEastEnemy8: DEFB 0, 0, 0, 0, 0                   ; Slot 8: Disattivato\n\n"
        "; --- Palette Colori Nemici 5-8 (Offset 282) ---\n"
        "BallRoomEastEnemyColors5_8:\n"
        "    DEFB MAGENTA, NONE, NONE, NONE     ; Nemico 5 (Magenta), Nemico 6-8 (Nessuno)"
    )
    
    code_table = Table([[Paragraph(code_text.replace('\n', '<br/>').replace(' ', '&nbsp;'), code_style)]], colWidths=[523])
    code_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F1F5F9")),
        ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('LEFTPADDING', (0,0), (-1,-1), 6),
        ('RIGHTPADDING', (0,0), (-1,-1), 6),
    ]))
    story.append(code_table)
    story.append(Spacer(1, 4))

    story.append(Paragraph("• <b>Guardiano 2 (Faccia Vert):</b> Flag <code>$C0</code> (%11000000 -> Active=1, Vert=1, Phase=0). Parte da Y=40 con X=48 e oscilla in verticale fino a Y=87.", bullet_style))
    story.append(Paragraph("• <b>Guardiano 3 (Faccia Vert Sfasata):</b> Flag <code>$E0</code> (%11100000 -> Active=1, Vert=1, Phase=2). Parte a metà percorso (Y=56) verso l'alto (Dir=1), sfasando perfettamente il movimento dal Nemico 2.", bullet_style))
    story.append(Paragraph("• <b>Guardiano 5 (Uccello Horiz):</b> Flag <code>$80</code> (%10000000 -> Active=1, Horiz=0, Phase=0). Parte da X=112 a Y=80 e vola orizzontalmente fino a X=232.", bullet_style))
    story.append(Spacer(1, 6))

    # Section 7
    story.append(Paragraph("7. Ciclo di Vita del Motore di Gioco (enemy.asm)", h1_style))
    story.append(Paragraph("Il rendering ed aggiornamento dei guardiani avviene in quattro fasi ad ogni frame di gioco:", body_style))
    
    table_lifecycle_data = [
        [Paragraph("Passo", table_header_style), Paragraph("Routine / Funzione", table_header_style), Paragraph("Operazione Eseguita nel Motore di Gioco", table_header_style)],
        [Paragraph("1", table_cell_code), Paragraph("Enemy_LoadRoom", table_cell_bold), Paragraph("Inizializzazione all'ingresso della stanza. Legge i 5 byte ROM per ciascuno dei 8 nemici, imposta <code>ActiveEnemies</code> in RAM, calcola i limiti <code>MinLimit</code>/<code>MaxLimit</code>, imposta la fase/direzione iniziale e copia il colore corrispondente.", table_cell_style)],
        [Paragraph("2", table_cell_code), Paragraph("Enemy_EraseRoom", table_cell_bold), Paragraph("Prima di spostare i guardiani, cancella la grafica dallo schermo usando le coordinate memorizzate in <code>Old X</code> / <code>Old Y</code>, ripristinando le tile dello sfondo ed i relativi attributi di colore.", table_cell_style)],
        [Paragraph("3", table_cell_code), Paragraph("Enemy_Update", table_cell_bold), Paragraph("Verifica il divisore di velocità (<code>enemy_update_rate</code>). Salva <code>Current X/Y</code> in <code>Old X/Y</code>, avanza di 2 pixel lungo l'asse attivo, inverte la direzione ai limiti <code>MinLimit</code>/<code>MaxLimit</code> ed incrementa l'animazione (<code>Anim State</code>).", table_cell_style)],
        [Paragraph("4", table_cell_code), Paragraph("Enemy_DrawRoom", table_cell_bold), Paragraph("Scorre l'array <code>ActiveEnemies</code> in RAM. Recupera l'indirizzo della bitmap dello sprite 16&times;16 in base a Tipo, Direzione (Left/Right) ed <code>Anim State</code>. Disegna i pixel a schermo e applica l'attributo colore ZX Spectrum nella RAM attributi ($5800).", table_cell_style)],
    ]
    t_life = Table(table_lifecycle_data, colWidths=[35, 105, 383])
    t_life.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#1E293B")),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F8FAFC"), colors.white]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
        ('TOPPADDING', (0,0), (-1,-1), 2.5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 2.5),
    ]))
    story.append(t_life)
    
    doc.build(story, canvasmaker=NumberedCanvas)

if __name__ == '__main__':
    pdf_path = os.path.join('documentation', 'manual', 'Configurazione_Guardiani_JetSetWilly.pdf')
    build_pdf(pdf_path)
    print("PDF build completed:", pdf_path)
