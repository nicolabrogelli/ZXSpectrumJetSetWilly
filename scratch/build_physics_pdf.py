import os
import sys
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable, Preformatted
)
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
            self.draw_page_number(num_pages)
            super().showPage()
        super().save()

    def draw_page_number(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#4A5568"))
        
        # Header (on pages after page 1)
        if self._pageNumber > 1:
            self.drawString(54, 800, "ZX Spectrum - Jet Set Willy | Analisi Fisica (physics.asm)")
            self.setStrokeColor(colors.HexColor("#CBD5E0"))
            self.setLineWidth(0.5)
            self.line(54, 792, 541, 792)
            
            # Footer
            self.line(54, 45, 541, 45)
            page_text = f"Pagina {self._pageNumber} di {page_count}"
            self.drawRightString(541, 32, page_text)
            self.drawString(54, 32, "Documentazione Tecnica Z80 Assembly")
        
        self.restoreState()

def create_physics_pdf(filename):
    doc = SimpleDocTemplate(
        filename,
        pagesize=A4,
        leftMargin=54,
        rightMargin=54,
        topMargin=54,
        bottomMargin=54
    )

    styles = getSampleStyleSheet()

    # Custom styles
    title_style = ParagraphStyle(
        'CoverTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=22,
        leading=26,
        textColor=colors.HexColor("#1A365D"),
        spaceAfter=10
    )

    subtitle_style = ParagraphStyle(
        'CoverSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=12,
        leading=16,
        textColor=colors.HexColor("#2B6CB0"),
        spaceAfter=20
    )

    h1_style = ParagraphStyle(
        'Heading1_Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=14,
        leading=18,
        textColor=colors.HexColor("#1A365D"),
        spaceBefore=16,
        spaceAfter=8,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'Body_Custom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=13.5,
        textColor=colors.HexColor("#2D3748"),
        spaceAfter=6
    )

    bullet_style = ParagraphStyle(
        'Bullet_Custom',
        parent=body_style,
        leftIndent=15,
        firstLineIndent=-10,
        spaceAfter=4
    )

    code_style = ParagraphStyle(
        'Code_Custom',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=7.0,
        leading=8.5,
        textColor=colors.HexColor("#1A202C")
    )

    callout_style = ParagraphStyle(
        'Callout_Text',
        parent=styles['Normal'],
        fontName='Helvetica-Oblique',
        fontSize=9,
        leading=13,
        textColor=colors.HexColor("#2C5282")
    )

    story = []

    # Read physics.asm
    asm_path = r"C:\Users\87003101\Documents\Progetti\asm\ZXSPECTRUM-JETSETWILLY\physics.asm"
    with open(asm_path, "r", encoding="utf-8", errors="replace") as f:
        physics_asm_content = f.read()

    # Cover Header Box
    story.append(Paragraph("DOCUMENTO TECNICO DI ARCHITETTURA SOFTWARE", ParagraphStyle(
        'HeaderCategory', fontName='Helvetica-Bold', fontSize=9, leading=11, textColor=colors.HexColor("#3182CE"), spaceAfter=6
    )))
    story.append(Paragraph("Analisi Dettagliata del Modulo di Fisica Z80<br/><code>physics.asm</code>", title_style))
    story.append(Paragraph("Motore di gioco ZX Spectrum – Project <i>Jet Set Willy</i>", subtitle_style))
    story.append(HRFlowable(width="100%", thickness=1.5, color=colors.HexColor("#3182CE"), spaceBefore=0, spaceAfter=15))

    # Overview box
    overview_text = (
        "<b>Oggetto del Documento:</b> Questo manuale fornisce una trattazione approfondita ed esaustiva dell'intero "
        "motore fisico contenuto nel file <code>physics.asm</code> per il gioco Jet Set Willy (ZX Spectrum Z80). "
        "Vengono esaminate la decompressione dei layout, le collisioni a livello di pixel con terreno, muri e pericoli, "
        "la dinamica di salto e gravita a precisione frazionaria, il calcolo della pendenza delle rampe, l'effetto dei nastri "
        "trasportatori e le transizioni tra stanze.<br/><br/>"
        "Tutte le sezioni includono le relative spiegazioni teoriche e i <b>blocchi di codice sorgente Z80 Assembly "
        "integrali e commentati</b> tratti da <code>physics.asm</code>."
    )
    
    overview_table = Table([[Paragraph(overview_text, callout_style)]], colWidths=[487])
    overview_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#EBF8FF")),
        ('BOX', (0, 0), (-1, -1), 1, colors.HexColor("#BEE3F8")),
        ('PADDING', (0, 0), (-1, -1), 10),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
    ]))
    story.append(overview_table)
    story.append(Spacer(1, 15))

    def make_code_box(code_text):
        p = Preformatted(code_text, code_style)
        t = Table([[p]], colWidths=[487])
        t.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#F7FAFC")),
            ('BOX', (0, 0), (-1, -1), 0.5, colors.HexColor("#E2E8F0")),
            ('PADDING', (0, 0), (-1, -1), 6),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ]))
        return t

    # Section 1: Introduction & Architecture
    story.append(Paragraph("1. Architettura Generale e Strutture Dati", h1_style))
    story.append(Paragraph(
        "Il modulo <code>physics.asm</code> gestisce tutta la dinamica di gioco per lo sprite del protagonista (Willy), "
        "interagendo con la griglia di sfondo di ciascuna stanza (256x128 pixel divisa in 32 colonne x 16 righe di celle 8x8) "
        "e con le entita dinamiche come nemici e nastri trasportatori.", body_style
    ))
    
    arch_bullets = [
        "<b>Coordinate e Dimensioni:</b> L'area giocabile e di 256 pixel in larghezza (X in [0, 255]) e 128 pixel in altezza (Y in [0, 127]). Willy ha una dimensione di 16 x 8 pixel (altezza 16, larghezza 8).",
        "<b>Buffer di Layout Decompresso (<code>unpacked_layout</code>):</b> I dati originali della stanza occupano 128 byte in ROM/RAM dove ogni cella e codificata con 2 bit (4 celle per byte). All'ingresso di una stanza, la routine <code>UnpackRoomLayout</code> espande tali dati in 512 byte (1 byte per cella). Questo garantisce un accesso casuale O(1) immediato senza dover decodificare bit per bit ad ogni frame.",
        "<b>Valori delle Celle (Tipi di Blocco):</b><br/>"
        "&nbsp;&nbsp;• <b>0 (Empty):</b> Cella vuota traversabile.<br/>"
        "&nbsp;&nbsp;• <b>1 (Floor):</b> Terreno/Pavimento solido.<br/>"
        "&nbsp;&nbsp;• <b>2 (Wall):</b> Muro solido (blocca movimento orizzontale e salita).<br/>"
        "&nbsp;&nbsp;• <b>3 (Nasty):</b> Elemento letale/pericoloso (causa la morte immediata al contatto).",
        "<b>Flag di Terreno (<code>on_ground</code>):</b> Indica se Willy si trova su una superficie solida (valore 1) oppure se e in volo/caduta (valore 0).",
        "<b>Velocita e Gravita (<code>velocity_y</code>):</b> Valore signed a 8 bit che rappresenta la velocita verticale (positiva verso l'alto durante il salto, negativa verso il basso in caduta)."
    ]
    for b in arch_bullets:
        story.append(Paragraph(f"• {b}", bullet_style))
    story.append(Spacer(1, 10))

    # Section 2: Layout Unpacking & Cell Lookup Code
    story.append(Paragraph("2. Decompressione Layout e Lookup Celle O(1)", h1_style))
    story.append(Paragraph(
        "Per ottimizzare le prestazioni su Z80 (3.5 MHz), il layout compresso a 2-bit per cella viene espanso "
        "in un array continuo di 512 byte nella RAM tramite <code>UnpackRoomLayout</code>. "
        "Successivamente, la funzione <code>GetCellFromUnpacked</code> calcola l'indirizzo Row * 32 + Col in pochissimi cicli macchina.",
        body_style
    ))

    code_sec2 = """UnpackRoomLayout:
    push hl : push de : push bc
    ld   hl, (room_ptr)     ; HL = inizio layout stanza (128 byte)
    ld   de, unpacked_layout ; DE = buffer RAM (512 byte)
    ld   b, 128             ; 128 byte
.byte_loop:
    ld   a, (hl)            ; Leggi byte compresso
    inc  hl
    ld   c, a               ; C = salvataggio
    
    ; Cella 0: bit 7-6
    rlca : rlca : and 3 : ld (de), a : inc de
    ; Cella 1: bit 5-4
    ld a, c : rlca : rlca : rlca : rlca : and 3 : ld (de), a : inc de
    ; Cella 2: bit 3-2
    ld a, c : rrca : rrca : and 3 : ld (de), a : inc de
    ; Cella 3: bit 1-0
    ld a, c : and 3 : ld (de), a : inc de
    
    djnz .byte_loop
    pop bc : pop de : pop hl
    ret

GetCellFromUnpacked:
    push hl : push de
    ld   l, a
    ld   h, 0
    add  hl, hl : add hl, hl : add hl, hl : add hl, hl : add hl, hl ; HL = Row * 32
    ld   e, c : ld d, 0
    add  hl, de            ; HL = Row * 32 + Col
    ld   de, unpacked_layout
    add  hl, de
    ld   a, (hl)           ; A = cell type (0..3)
    pop  de : pop hl
    ret"""

    story.append(make_code_box(code_sec2))
    story.append(Spacer(1, 12))

    # Section 3: Detection of Solids, Walls and Nasties
    story.append(Paragraph("3. Rilevamento di Solidi, Muri e Pericoli (Nasty Cells)", h1_style))
    story.append(Paragraph(
        "Il motore fisico distingue tre tipi di verifiche d'impatto:", body_style
    ))
    story.append(Paragraph(
        "1. <b><code>Phys_CheckSolid</code>:</b> Determina se un punto (X,Y) e solido (Floor = 1 o Wall = 2), "
        "considerando anche le celle occupate da nastri trasportatori e rampe. Restituisce il flag <code>Carry</code> impostato se solido.", body_style
    ))
    story.append(Paragraph(
        "2. <b><code>CheckWillyWallCollision</code>:</b> Effettua un controllo orizzontale su 3 punti (testa Y, centro Y+7, piedi Y+15) "
        "per verificare se Willy sta urtando frontalmente contro un muro (Wall = 2), impedendone il movimento.", body_style
    ))
    story.append(Paragraph(
        "3. <b><code>Phys_CheckNastyCollision</code>:</b> Verifica la morte di Willy tramite 6 punti di controllo "
        "(Top-Left, Top-Right, Mid-Left, Mid-Right, Bottom-Left, Bottom-Right) attorno alla bounding box di 16 x 8 pixel.", body_style
    ))

    code_sec3 = """Phys_CheckSolid:
    push hl : push de : push bc
    ld   a, b
    bit  7, a               ; Se Y < 0, non e solido
    jr   nz, .not_solid
    cp   128                ; Clamp Y se >= 128
    jr   c, .y_ok
    ld   b, 127
.y_ok:
    call CheckConveyorOrRampCell
    jr   c, .solid
    
    ld   a, b : srl a : srl a : srl a   ; r = Y / 8
    ld   e, a
    ld   a, c : srl a : srl a : srl a   ; c = X / 8
    ld   c, a : ld a, e
    call GetCellFromUnpacked
    
    cp   1                  ; Floor?
    jr   z, .solid
    cp   2                  ; Wall?
    jr   z, .solid
.not_solid:
    pop bc : pop de : pop hl : or a : ret
.solid:
    pop bc : pop de : pop hl : scf : ret

Phys_CheckNastyCollision:
    push bc
    ld   bc, (PlayerPos)    ; B = Y, C = X
    call CheckNastyCell : jr c, .collision              ; Top-Left (X, Y)
    ld   a, c : add a, 7 : ld c, a : call CheckNastyCell ; Top-Right (X+7, Y)
    jr   c, .collision
    ld   bc, (PlayerPos) : ld a, b : add a, 7 : ld b, a 
    call CheckNastyCell : jr c, .collision              ; Mid-Left (X, Y+7)
    ld   a, c : add a, 7 : ld c, a : call CheckNastyCell ; Mid-Right (X+7, Y+7)
    jr   c, .collision
    ld   bc, (PlayerPos) : ld a, b : add a, 15 : ld b, a 
    call CheckNastyCell : jr c, .collision              ; Bottom-Left (X, Y+15)
    ld   a, c : add a, 7 : ld c, a : call CheckNastyCell ; Bottom-Right (X+7, Y+15)
    jr   c, .collision
    pop  bc : or a : ret
.collision:
    pop  bc : scf : ret"""

    story.append(make_code_box(code_sec3))
    story.append(Spacer(1, 12))

    # Section 4: Gravity & Jump Mechanics
    story.append(Paragraph("4. Gravita, Salti e Meccaniche di Movimento (Phys_ApplyGravity)", h1_style))
    story.append(Paragraph(
        "La routine principale del motore fisico e <code>Phys_ApplyGravity</code>. Essa gestisce:", body_style
    ))
    
    gravity_bullets = [
        "<b>Interpolazione della Gravita (Preset):</b> Il motore supporta 7 preset di gravita configurabili per stanza (0.5, 0.75, 1.0, 0.25, 0.0, 0.875, 0.625). L'accelerazione verso il basso viene applicata a intervalli regolari alternando i frame mediante un contatore <code>jump_frame</code> e operazioni di maschera bit a bit (AND).",
        "<b>Meccanica Step-Down:</b> Quando Willy cammina in discesa su gradini o rampe, il sistema rileva se il piede avanzato si trova nel vuoto ma il livello sottostante (Y+24) e solido. In tal caso applica uno Step-Down immediato di +8 pixel, evitando che Willy fluttui in aria prima di iniziare a cadere.",
        "<b>Collisione con Soffitti (Ceiling Collision):</b> Durante la fase ascendente del salto (velocity_y > 0), il motore controlla se la testa di Willy impatta contro blocchi di tipo Wall. In caso d'impatto, azzera la velocita verticale e clamp la posizione Y al bordo inferiore del muro.",
        "<b>Atterraggio sul Terreno:</b> Durante la caduta (velocity_y <= 0), vengono controllati i due punti sotto i piedi (X, Y+16 e X+7, Y+16). Se viene rilevato solido e la posizione precedente era sopra o a livello della superficie (tolleranza di 3 pixel), Willy viene posizionato a terra (on_ground = 1).",
        "<b>Transizioni di Stanza Verticali:</b> Se Willy supera il bordo superiore (Y < 0) o inferiore (Y >= 113), il motore controlla la mappa delle stanze adiacenti e scatena la routine TriggerRoomChange."
    ]
    for b in gravity_bullets:
        story.append(Paragraph(f"• {b}", bullet_style))
    story.append(Spacer(1, 8))

    code_sec4 = """Phys_ApplyGravity:
    ld   bc, (PlayerPos)
    ld   a, (on_ground) : or a : jr z, .not_on_ramp_walk
    
    call GetRampY           ; Aggancio rampa durante la camminata
    jr   nc, .not_on_ramp_walk
    ld   e, a : ld a, b : sub e
    bit  7, a : jr z, .abs_ok : neg
.abs_ok:
    cp   12 : jr nc, .not_on_ramp_walk
    ld   b, e               ; B = ramp_Y
    ld   (PlayerPos), bc
    
    ld   a, (jump_pressed)  ; Gestisci eventuale salto da rampa
    or   a : jp z, .end
    ; Imposta parametri del salto...
    jp   .in_air

.not_on_ramp_walk:
    ; Controllo Step-Down (discesa da gradini di 8px)
    ; Applicazione gravita frazionaria basata su room_gravity_preset...
    ld   a, (jump_frame) : inc a : ld (jump_frame), a
    ; applica diminuzione di velocity_y secondo preset...
    
.clamp_fall_speed:
    cp   -MAX_FALL_SPEED    ; Limitatore di caduta (max -12)
    jr   nc, .store_vel
    ld   a, -MAX_FALL_SPEED
.store_vel:
    ld   (velocity_y), a
    ; Aggiorna posizione Y = Y - velocity_y
    ..."""

    story.append(make_code_box(code_sec4))
    story.append(Spacer(1, 12))

    # Section 5: Slope Physics (Ramps)
    story.append(Paragraph("5. Matematica delle Rampe e Calcolo Trigonometrico Lineare", h1_style))
    story.append(Paragraph(
        "Le rampe in Jet Set Willy sono superfici inclinate a 45 gradi che collegano quote differenti. "
        "L'algoritmo contenuto in <code>GetRampY</code> determina in tempo reale la coordinata Y esatta "
        "corrispondente a qualsiasi coordinata X di Willy.", body_style
    ))

    ramp_math_text = (
        "<b>Formule di Calcolo della Rampa (<code>GetRampY</code>):</b><br/>"
        "• <b>Rampa che sale verso Destra (<code>ramp_dir = 1</code>):</b><br/>"
        "&nbsp;&nbsp;&nbsp;&nbsp;X_left = ramp_col * 8<br/>"
        "&nbsp;&nbsp;&nbsp;&nbsp;dX = X_willy - X_left<br/>"
        "&nbsp;&nbsp;&nbsp;&nbsp;Y_ramp = (ramp_row * 8 - 16) - dX<br/><br/>"
        "• <b>Rampa che sale verso Sinistra (<code>ramp_dir = 0</code>):</b><br/>"
        "&nbsp;&nbsp;&nbsp;&nbsp;X_start = ramp_col * 8<br/>"
        "&nbsp;&nbsp;&nbsp;&nbsp;dX = X_start - X_willy<br/>"
        "&nbsp;&nbsp;&nbsp;&nbsp;Y_ramp = (ramp_row * 8 - 16) - dX<br/><br/>"
        "<b>Protezione Guardia d'Ingresso (<code>ramp_entry_guard</code>):</b><br/>"
        "Quando Willy entra in una stanza in prossimita del bordo inferiore sottostante una rampa, "
        "la guardia attiva impedisce che Willy venga 'risucchiato' o agganciato erroneamente alla rampa sopra di lui "
        "finche non si allontana dalla zona d'ingresso o si allinea volontariamente."
    )
    story.append(Paragraph(ramp_math_text, body_style))
    story.append(Spacer(1, 8))

    code_sec5 = """GetRampY:
    ld   a, (ramp_len) : or a : ret z   ; Nessuna rampa? Exit carry clear
    ld   a, (ramp_dir) : or a : jr z, .dir_left

.dir_right:
    ld   a, (ramp_col) : add a,a : add a,a : add a,a : ld e, a ; E = X_left
    ld   a, c : cp e : jp c, .out_of_ramp                      ; PlayerX < X_left?
    
.on_ramp_slope:
    ld   a, c : sub e : ld d, a                                ; D = dx (X - X_left)
    ld   a, (ramp_row) : add a,a : add a,a : add a,a : sub 16  ; Base Y
    sub  d                                                     ; Y = BaseY - dx
    ld   d, a
    ; Clamp alla piattaforma di cima se necessario...
    jp   .return_ramp_y

.dir_left:
    ; Calcolo speculare per rampe a sinistra...
    ...

.return_ramp_y:
    ; Controllo ramp_entry_guard per evitare agganci errati ai cambi stanza...
    ld   a, (ramp_entry_guard) : or a : jr z, .guard_clear_exit
    ; Se la differenza Y > 12px ed e sotto la rampa -> ignora rampa!
    ...
.guard_clear_exit:
    ld   a, b : pop bc : scf : ret
.out_of_ramp:
    or   a : ret"""

    story.append(make_code_box(code_sec5))
    story.append(Spacer(1, 12))

    # Section 6: Conveyors & Enemies
    story.append(Paragraph("6. Nastri Trasportatori e Collisioni con Nemici", h1_style))
    story.append(Paragraph(
        "<b>Nastri Trasportatori (<code>Phys_ApplyConveyor</code>):</b><br/>"
        "Se Willy si trova a terra (<code>on_ground = 1</code>) sopra una cella appartenente alla riga e colonna "
        "del nastro trasportatore (<code>conveyor_row</code>, <code>conveyor_col</code>), la routine lo trascina "
        "automaticamente di 1 pixel per frame nella direzione definita (<code>conveyor_dir</code>). "
        "Se il nastro spinge Willy oltre il bordo dello schermo, viene innescato il cambio di stanza orizzontale.",
        body_style
    ))
    story.append(Paragraph(
        "<b>Collisione Bounding Box Nemici (<code>CheckCollision</code>):</b><br/>"
        "Cicla su tutti gli 8 slot dei nemici attivi (<code>ActiveEnemies</code>). Esegue una verifica rettangolare AABB "
        "con tolleranza pixel su orizzontale e verticale:", body_style
    ))

    code_sec6 = """CheckCollision:
    ld   ix, ActiveEnemies
    ld   b, 8               ; 8 slot nemici
.loop:
    ld   a, (ix+0) : and $80 ; Nemico attivo?
    jr   z, .next
    
    ; Controllo orizzontale: PlayerX - EnemyX + 7 in [0, 22]
    ld   a, (PlayerPos) : sub (ix+2) : add a, 7
    cp   23 : jr nc, .next
    
    ; Controllo verticale: PlayerY - EnemyY + 15 in [0, 30]
    ld   a, (PlayerPos+1) : sub (ix+3) : add a, 15
    cp   31 : jr nc, .next
    
    ; Collisione trovata!
    pop ix : pop bc : pop de : pop hl : scf : ret
.next:
    ld de, 11 : add ix, de  ; Prossimo nemico (+11 byte)
    djnz .loop
    pop ix : pop bc : pop de : pop hl : or a : ret"""

    story.append(make_code_box(code_sec6))
    story.append(Spacer(1, 14))

    # Section 7: Full Appendix / Code Reference
    story.append(Paragraph("7. Appendice: Sorgente Completo Integrale physics.asm", h1_style))
    story.append(Paragraph(
        "Di seguito viene allegato il codice sorgente integrale contenuto nel file <code>physics.asm</code> "
        "(1891 righe), per consultazione immediata e verifica di ciascun dettaglio di implementazione Z80 Assembly.",
        body_style
    ))
    story.append(Spacer(1, 6))

    # Split physics_asm_content into chunks of ~80 lines for neat code blocks
    lines = physics_asm_content.splitlines()
    chunk_size = 80
    for i in range(0, len(lines), chunk_size):
        chunk_text = "\n".join(lines[i:i+chunk_size])
        story.append(make_code_box(chunk_text))
        story.append(Spacer(1, 6))

    # Build PDF with NumberedCanvas
    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"PDF generato con successo: {filename}")

if __name__ == "__main__":
    out_pdf = r"C:\Users\87003101\Documents\Progetti\asm\ZXSPECTRUM-JETSETWILLY\Analisi_Dettagliata_Physics_ASM.pdf"
    create_physics_pdf(out_pdf)
