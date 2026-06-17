;===========================================================================
; items.asm
;===========================================================================

; -------------------------------------------------------------------
; Tabella Globale degli Oggetti (Items)
; Ciascun item occupa 5 byte:
;   Byte 0: ID della stanza (0 = Test Room, 1 = The Bridge, 2 = The Off Licence, 3 = Master Bedroom, 4 = Under the MegaTree)
;   Byte 1: X colonna dello schermo (0..31)
;   Byte 2: Y riga dello schermo (3..18)
;   Byte 3: Attributo colore (es. $C6 per Giallo Flashing, $C5 per Cyan Flashing)
;   Byte 4: Stato (0 = Attivo/Non raccolto, 1 = Raccolto)
; La tabella termina con $FF
; -------------------------------------------------------------------
ItemsTable:
    ; Stanza 2 (The Off Licence)
    db 2, 30, 7, 6, 0               ; Oggetto 1 alla colonna X=30, riga Y=7 (Stato: 0=attivo)    
    db 2, 29, 7, 5, 0               ; Oggetto 2 alla colonna X=10, riga Y=7     
    db 2, 28, 7, 4, 0               ; Oggetto 12 alla colonna X=10, riga Y=7     
    db 2, 27, 7, 3, 0               ; Oggetto 3 alla colonna X=20, riga Y=7 (Stato: 0=attivo)   
    db 2, 26, 7, 6, 0               ; Oggetto 4 alla colonna X=10, riga Y=7     
    db 2, 25, 7, 5, 0               ; Oggetto 5 alla colonna X=20, riga Y=7 (Stato: 0=attivo)   
    db 2, 24, 7, 4, 0               ; Oggetto 6 alla colonna X=10, riga Y=7     
    db 2, 23, 7, 3, 0               ; Oggetto 7 alla colonna X=20, riga Y=7 (Stato: 0=attivo)   
    db 2, 22, 7, 6, 0               ; Oggetto 8 alla colonna X=10, riga Y=7     
    db 2, 21, 7, 5, 0               ; Oggetto 9 alla colonna X=20, riga Y=7 (Stato: 0=attivo)   
    db 2, 20, 7, 4, 0               ; Oggetto 10 alla colonna X=10, riga Y=7     
    db 2, 19, 7, 3, 0               ; Oggetto 11 alla colonna X=20, riga Y=7 (Stato: 0=attivo)  
    
    ; Stanza 0 (The Test Room)
    db 0, 15, 17, $C2, 0           ; Oggetto 3: Rosso Flashing ($C2) al centro
    
    ; Stanza 4 (Under the MegaTree)
    db 4, 22, 3, 3, 0            ; Oggetto in UnderTheMegaTree: Y=3 (Layout Row 0), X=22 (Cyan Flashing)

    ; Stanza 4 (Under the MegaTree)
    db 5, 1, 14, 3, 0            ; Oggetto in UnderTheMegaTree: Y=3 (Layout Row 0), X=22 (Cyan Flashing)
    db 5, 4, 13, 4, 0            ; Oggetto in UnderTheMegaTree: Y=3 (Layout Row 0), X=22 (Cyan Flashing)
    db 5, 7, 14, 5, 0            ; Oggetto in UnderTheMegaTree: Y=3 (Layout Row 0), X=22 (Cyan Flashing)

    
    db $FF                        ; Fine tabella

; -------------------------------------------------------------------
; Determina e imposta il current_room ID in base a room_ptr
; -------------------------------------------------------------------
DetermineCurrentRoomID:
    push hl
    push de
    
    ld   hl, (room_ptr)
    
    ; Test Room?
    ld   de, TheTestRoomLayout
    or   a
    sbc  hl, de
    jr   nz, .not_test
    ld   a, 0
    jr   .set_room
    
.not_test:
    ld   hl, (room_ptr)
    ld   de, TheBridgeLayout
    or   a
    sbc  hl, de
    jr   nz, .not_bridge
    ld   a, 1
    jr   .set_room
    
.not_bridge:
    ld   hl, (room_ptr)
    ld   de, TheOffLicenceLayout
    or   a
    sbc  hl, de
    jr   nz, .not_office
    ld   a, 2
    jr   .set_room
    
.not_office:
    ld   hl, (room_ptr)
    ld   de, MastreBedRoomLayout
    or   a
    sbc  hl, de
    jr   nz, .not_masterbed
    ld   a, 3
    jr   .set_room

.not_masterbed:
    ld   hl, (room_ptr)
    ld   de, UnderTheMegaTreeLayout
    or   a
    sbc  hl, de
    jr   nz, .not_undertree
    ld   a, 4
    jr   .set_room

.not_undertree:
    ld   hl, (room_ptr)
    ld   de, AtTheFootTheMegaTreeLayout
    or   a
    sbc  hl, de
    jr   nz, .unknown
    ld   a, 5
    jr   .set_room


.unknown:
    ld   a, 0                    ; Default fallback
    
.set_room:
    ld   (current_room), a
    
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Disegna tutti gli oggetti attivi della stanza corrente
; -------------------------------------------------------------------
DrawRoomItems:
    push hl
    push de
    push bc
    push ix
    
    ; Ottieni il puntatore alla grafica dell'item della stanza corrente:
    ; room_ptr + OFFSET_ITEM_GRAPHIC
    ld   hl, (room_ptr)
    ld   de, OFFSET_ITEM_GRAPHIC
    add  hl, de
    push hl
    pop  ix                ; IX = puntatore alla grafica dell'item della stanza
    
    ld   hl, ItemsTable
.loop:
    ld   a, (hl)           ; A = Room ID
    cp   $FF               ; Fine tabella?
    jr   z, .done
    
    ; Confronta con la stanza corrente
    ld   d, a              ; D = Room ID dell'item
    ld   a, (current_room)
    cp   d
    jr   nz, .next_item    ; Stanza diversa, salta
    
    ; Leggi coordinate, colore e stato
    inc  hl                ; HL punta a X
    ld   c, (hl)           ; C = X colonna
    inc  hl                ; HL punta a Y
    ld   b, (hl)           ; B = Y riga
    inc  hl                ; HL punta al Colore
    ld   e, (hl)           ; E = Colore
    inc  hl                ; HL punta a collected flag
    ld   a, (hl)           ; A = collected flag
    or   a
    jr   nz, .next_no_inc  ; Già raccolto, salta
    
    ; Disegna l'item!
    ; B = Row, C = Col, IX = bitmap graphic (8 byte), E = Colore
    push hl
    push ix
    pop  hl                ; HL = bitmap pointer
    call DrawItemGraphic
    pop  hl
    
    jr   .next_no_inc

.next_item:
    inc  hl                ; salta X
    inc  hl                ; salta Y
    inc  hl                ; salta colore
    inc  hl                ; salta collected
.next_no_inc:
    inc  hl                ; vai al prossimo record (prossimo Room ID)
    jr   .loop

.done:
    pop  ix
    pop  de
    pop  bc
    pop  hl
    ret

; -------------------------------------------------------------------
; Disegna un singolo item (8x8 pixel) a schermo con colore personalizzato
; Input: B = Row (3..18), C = Col (0..31), HL = Puntatore al bitmap (8 byte), E = Colore
; -------------------------------------------------------------------
DrawItemGraphic:
    push bc
    push de
    push hl
    
    ; 1. Calcola l'indirizzo dello schermo (bitmap) per Row B, Col C, scanline 0
    ld   a, b
    and  $18
    add  a, $40
    ld   d, a              ; D = High byte dell'indirizzo dello schermo
    
    ld   a, b
    and  7
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, a              ; *16
    add  a, a              ; *32
    add  a, c              ; + Col C
    ld   e, a              ; E = Low byte dell'indirizzo dello schermo
    
    ; 2. Copia gli 8 byte del bitmap dello sprite
    push bc                ; Salva BC (contiene Row e Col)
    ld   b, 8              ; 8 scanline
.line_loop:
    ld   a, (hl)
    ld   (de), a
    inc  d                 ; Prossima scanline
    inc  hl
    dec  b
    jr   nz, .line_loop
    pop  bc                ; Ripristina BC
    
    ; 3. Calcola l'indirizzo degli attributi dello schermo
    ; HL = $5800 + B * 32 + C
    ld   h, 0
    ld   l, b              ; HL = B (Row)
    add  hl, hl            ; *2
    add  hl, hl            ; *4
    add  hl, hl            ; *8
    add  hl, hl            ; *16
    add  hl, hl            ; *32
    
    ld   a, c              ; A = Col
    add  a, l
    ld   l, a
    jr   nc, .no_carry
    inc  h
.no_carry:
    ; HL = B * 32 + C
    ld   de, $5800
    add  hl, de            ; HL = AttrAddr
    
    ; Ripristina i registri dallo stack per estrarre il colore in E
    ; Lo stack ha: HL (originale), DE (originale con colore in E), BC (originale)
    pop  bc                ; BC = HL originale
    pop  de                ; DE = DE originale (colore in E)
    
    ld   a, e              ; A = Colore
    ld   (hl), a           ; Scrivi in memoria attributi (HL)
    
    ; Ripristina lo stack e i registri originari
    push bc                ; Rimetti HL originale sulla pila
    pop  hl                ; HL = HL originale
    pop  bc                ; BC = BC originale
    ret

; -------------------------------------------------------------------
; Ripristina la cella dello sfondo originale per cancellare l'item
; Input: B = Row (3..18), C = Col (0..31)
; -------------------------------------------------------------------
RestoreBackgroundCell:
    push iy                ; Preserva IY
    push bc
    push de
    push hl
    push ix
    
    push bc
    pop  iy                ; IY = original BC (IYH = Row, IYL = Col)
    
    ; Riga di layout: r = B - 3
    ld   a, b
    sub  3                 ; A = r (0..15)
    
    ; Colonna: c = C (Col)
    call GetCellFromUnpacked ; A = cell type (0..3)
    
    ld   de, (room_ptr)
    or   a
    jr   nz, .not_bg
    ld   hl, OFFSET_BG
    add  hl, de
    jr   .draw_cell
.not_bg:
    dec  a
    jr   nz, .not_floor
    ld   hl, OFFSET_FLOOR
    add  hl, de
    jr   .draw_cell
.not_floor:
    dec  a
    jr   nz, .not_wall
    ld   hl, OFFSET_WALL
    add  hl, de
    jr   .draw_cell
.not_wall:
    ld   hl, OFFSET_NASTY
    add  hl, de

.draw_cell:
    push hl
    pop  ix                ; IX = tile pointer
    
    push iy
    pop  bc                ; B = Row, C = Col
    
    call DrawTile
    
    pop  ix
    pop  hl
    pop  de
    pop  bc
    pop  iy                ; Ripristina IY
    ret

; -------------------------------------------------------------------
; Controlla se Willy collide con un item (pixel-level check)
; Input: A = ItemX (0..31), H = ItemY (3..18)
; Output: Carry set se collide, altrimenti clear
; -------------------------------------------------------------------
CheckWillyItemCollision:
    push bc
    push de
    push hl
    
    ; Calcola ItemLeft = ItemX * 8, ItemRight = ItemLeft + 7
    ld   l, a
    ld   a, l
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   e, a              ; E = ItemLeft
    add  a, 7
    ld   d, a              ; D = ItemRight
    
    ; WillyLeft = WillyX (C), WillyRight = WillyX + 15
    ld   bc, (PlayerPos)   ; C = WillyX, B = WillyY
    
    ; Controlla X: WillyX <= ItemRight (D) e WillyX + 15 >= ItemLeft (E)
    ld   a, c
    cp   d
    jr   z, .x_ok
    jr   c, .x_ok
    jr   .no_collision
.x_ok:
    add  a, 15
    cp   e
    jr   z, .y_check
    jr   nc, .y_check
    jr   .no_collision
    
.y_check:
    pop  hl                ; Recupera HL originale (H = ItemY)
    push hl
    ld   a, h
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   e, a              ; E = ItemTop
    add  a, 7
    ld   d, a              ; D = ItemBottom
    
    ; WillyTop = WillyY (B), WillyBottom = WillyY + 15
    ld   a, b
    cp   d
    jr   z, .y_ok
    jr   c, .y_ok
    jr   .no_collision
.y_ok:
    add  a, 15
    cp   e
    jr   z, .collision
    jr   nc, .collision
    jr   .no_collision
    
.collision:
    pop  hl
    pop  de
    pop  bc
    scf                    ; Set carry (collisione!)
    ret
    
.no_collision:
    pop  hl
    pop  de
    pop  bc
    or   a                 ; Clear carry
    ret

; -------------------------------------------------------------------
; Controlla se Willy tocca un item attivo nella stanza corrente
; -------------------------------------------------------------------
CheckRoomItemsCollision:
    push hl
    push de
    push bc
    
    ld   hl, ItemsTable
.loop:
    ld   a, (hl)           ; A = Room ID
    cp   $FF               ; Fine tabella?
    jr   z, .done
    
    ; Stanza corrente?
    ld   d, a              ; D = Room ID
    ld   a, (current_room)
    cp   d
    jr   nz, .next_item
    
    inc  hl                ; HL punta a X
    ld   c, (hl)           ; C = X
    inc  hl                ; HL punta a Y
    ld   b, (hl)           ; B = Y
    inc  hl                ; HL punta al colore (lo saltiamo per il controllo collisione)
    inc  hl                ; HL punta a collected
    ld   a, (hl)           ; A = collected
    or   a
    jr   nz, .next_no_inc  ; Già raccolto, salta
    
    ; Controlla collisione
    ld   a, c
    ld   h, b
    call CheckWillyItemCollision
    jr   nc, .next_no_inc
    
    ; RACCOLTO!
    ld   (hl), 1           ; Imposta collected = 1
    
    push hl
    
    ; Cancella item dallo schermo
    call RestoreBackgroundCell
    
    ; Suono di raccolta
    call PlayCollectSound
    
    pop  hl
    
    jr   .next_no_inc

.next_item:
    inc  hl                ; salta X
    inc  hl                ; salta Y
    inc  hl                ; salta colore
    inc  hl                ; salta collected
.next_no_inc:
    inc  hl                ; vai al prossimo item
    jr   .loop

.done:
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Riproduce un breve segnale acustico all'altoparlante
; -------------------------------------------------------------------
PlayCollectSound:
    push bc
    push de
    
    ld   b, 120            ; Cicli della nota
.sound_loop:
    ld   a, (room_border_color)
    or   $10               ; Speaker ON (bit 4 = 1)
    out  ($fe), a
    ld   c, 60             ; Mezzo periodo delay
.d1: dec  c
    jr   nz, .d1
    
    ld   a, (room_border_color)
    and  $ef               ; Speaker OFF (bit 4 = 0)
    out  ($fe), a
    ld   c, 60             ; Mezzo periodo delay
.d2: dec  c
    jr   nz, .d2
    
    djnz .sound_loop
    
    pop  de
    pop  bc
    ret
