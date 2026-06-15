;===========================================================================
; items.asm
;===========================================================================

; -------------------------------------------------------------------
; Tabella Globale degli Oggetti (Items)
; Ciascun item occupa 4 byte:
;   Byte 0: ID della stanza (0 = Test Room, 1 = The Bridge, 2 = The Off Licence)
;   Byte 1: X colonna dello schermo (0..31)
;   Byte 2: Y riga dello schermo (3..18)
;   Byte 3: Stato (0 = Attivo/Non raccolto, 1 = Raccolto)
; La tabella termina con $FF
; -------------------------------------------------------------------
ItemsTable:
    ; Stanza 2 (The Off Licence)
    db 2, 30, 7, 0               ; Oggetto 1 alla colonna X=30, riga Y=7 (Stato: 0=attivo)   
    db 2, 29, 7, 0               ; Oggetto 2 alla colonna X=10, riga Y=7     
    db 2, 28, 7, 0               ; Oggetto 12 alla colonna X=10, riga Y=7     
    db 2, 27, 7, 0               ; Oggetto 3 alla colonna X=20, riga Y=7 (Stato: 0=attivo)   
    db 2, 26, 7, 0               ; Oggetto 4 alla colonna X=10, riga Y=7     
    db 2, 25, 7, 0               ; Oggetto 5 alla colonna X=20, riga Y=7 (Stato: 0=attivo)   
    db 2, 24, 7, 0               ; Oggetto 6 alla colonna X=10, riga Y=7     
    db 2, 23, 7, 0               ; Oggetto 7 alla colonna X=20, riga Y=7 (Stato: 0=attivo)   
    db 2, 22, 7, 0               ; Oggetto 8 alla colonna X=10, riga Y=7     
    db 2, 21, 7, 0               ; Oggetto 9 alla colonna X=20, riga Y=7 (Stato: 0=attivo)   
    db 2, 20, 7, 0               ; Oggetto 10 alla colonna X=10, riga Y=7     
    db 2, 19, 7, 0               ; Oggetto 11 alla colonna X=20, riga Y=7 (Stato: 0=attivo)   
    
    
    ; Stanza 0 (The Test Room)
    db 0, 15, 17, 0               ; Oggetto 3: Diamante al centro
    
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
    jr   nz, .unknown
    ld   a, 2
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
    
    ; Leggi coordinate e stato
    inc  hl                ; HL punta a X
    ld   c, (hl)           ; C = X colonna
    inc  hl                ; HL punta a Y
    ld   b, (hl)           ; B = Y riga
    inc  hl                ; HL punta a collected flag
    ld   a, (hl)           ; A = collected flag
    or   a
    jr   nz, .next_no_inc  ; Già raccolto, salta
    
    ; Disegna l'item!
    ; B = Row, C = Col, IX = bitmap graphic (8 byte)
    push hl
    push ix
    pop  hl                ; HL = bitmap pointer
    call DrawItemGraphic
    pop  hl
    
    jr   .next_no_inc

.next_item:
    inc  hl                ; salta X
    inc  hl                ; salta Y
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
; Disegna un singolo item (8x8 pixel) a schermo con colore giallo lampeggiante
; Input: B = Row (3..18), C = Col (0..31), HL = Puntatore al bitmap (8 byte)
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
    ld   b, 8              ; 8 scanline
.line_loop:
    ld   a, (hl)
    ld   (de), a
    inc  d                 ; Prossima scanline
    inc  hl
    dec  b
    jr   nz, .line_loop
    
    pop  hl
    pop  de
    pop  bc
    
    ; 3. Scrivi l'attributo colore
    push hl
    push de
    push bc
    
    ld   h, 0
    ld   l, b              ; HL = B (Row)
    add  hl, hl            ; *2
    add  hl, hl            ; *4
    add  hl, hl            ; *8
    add  hl, hl            ; *16
    add  hl, hl            ; *32
    ld   d, 0
    ld   e, c              ; DE = C (Col)
    add  hl, de            ; HL = B * 32 + C
    ld   de, $5800
    add  hl, de            ; HL = AttrAddr
    
    ld   a, $C6            ; Attributo: Flashing (bit 7), Bright (bit 6), Paper Black, Ink Yellow
    ld   (hl), a           ; Scrivi in memoria attributi
    
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Ripristina la cella dello sfondo originale per cancellare l'item
; Input: B = Row (3..18), C = Col (0..31)
; -------------------------------------------------------------------
RestoreBackgroundCell:
    push bc
    push de
    push hl
    push ix
    
    push bc
    pop  iy                ; IY = original BC (IYH = Row, IYL = Col)
    
    ; Riga di layout: r = B - 3
    ld   a, b
    sub  3
    ld   b, a              ; B = r (0..15)
    
    ; HL = r * 8
    ld   l, b
    ld   h, 0
    add  hl, hl
    add  hl, hl
    add  hl, hl            ; HL = r * 8
    
    ; HL = r * 8 + c / 4
    ld   a, c
    srl  a
    srl  a                 ; A = c / 4
    add  a, l
    ld   l, a              ; HL = r * 8 + c / 4
    
    ld   de, (room_ptr)
    add  hl, de            ; HL = layout byte address
    ld   a, (hl)           ; A = layout byte
    
    ; Estrai il bit-pair corrispondente a c % 4
    ld   d, a              ; D = layout byte
    ld   a, c
    and  3                 ; A = c % 4
    jr   z, .shift_0
    dec  a
    jr   z, .shift_1
    dec  a
    jr   z, .shift_2
    ld   a, d
    jr   .got_type
.shift_2:
    ld   a, d
    rrca
    rrca
    jr   .got_type
.shift_1:
    ld   a, d
    rrca
    rrca
    rrca
    rrca
    jr   .got_type
.shift_0:
    ld   a, d
    rlca
    rlca
.got_type:
    and  3                 ; A = cell type (0..3)
    
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
