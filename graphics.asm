;===========================================================================
; graphics.asm
;===========================================================================


; -------------------------------------------------------------------
; Copia il set dei caratteri dalla ROM alla RAM
; -------------------------------------------------------------------
CopyChars:
    ld hl, $3D00  ; Indirizzo del set di caratteri originale in ROM
    ld de, $8000  ; Indirizzo nella RAM in cui copiare il set di caratteri
    ld bc, 768    ; Numero di byte da copiare (96 caratteri * 8 byte ciascuno)
    ldir          ; Copiare i dati
    ret

; -------------------------------------------------------------------
; Ridefinisci i caratteri (incluso quello per i bordi)
; -------------------------------------------------------------------
DefineChars:
    ld hl, TilesDef             ; Indirizzo dei dati del nuovo carattere
    ld de, $8000 + (65 * 8)     ; Indirizzo di 'B' nel nuovo set di caratteri
    ld bc, 72                   ; Numero di byte da copiare (9 caratteri * 8 byte)
    ldir                        ; Effettua la copia dei caratteri
    ld hl, $8000                ; Indirizzo del nuovo set di caratteri in RAM
    ld ($5C36), hl              ; Aggiornare la variabile di sistema CHARS
    ret

; -------------------------------------------------------------------
; Posiziona il cursore
; Input: B = Y, C = X
; -------------------------------------------------------------------
At:
    push bc
    exx
    pop bc
    call $0a23
    exx
    ret

; -------------------------------------------------------------------
; Cambia colore inchiostro
; Input: A = colore
; -------------------------------------------------------------------
Ink:
    exx
    ld   b, a
    ld   a, (ATTR_T)
    and  $f8
    or   b
    ld   (ATTR_T), a
    exx
    ret

; -------------------------------------------------------------------
; ===================================================================
; NUOVE ROUTINE DI RENDERING PIXEL-BY-PIXEL
; ===================================================================

; -------------------------------------------------------------------
; Calcola indirizzo schermo da coordinate pixel (X, Y)
; Input: H = Y (0..191), L = X (0..255)
; Output: HL = indirizzo schermo
; -------------------------------------------------------------------
GetScreenAddr:
    ld a, h
    and %00000111     ; A = y2 y1 y0 (scanline offset)
    or  %01000000     ; Base dello schermo ($40)
    ld  d, a          ; D = high byte parziale
    
    ld  a, h
    and %11000000     ; A = y7 y6 000000 (third select)
    rrca
    rrca
    rrca              ; Shift a destra di 3 -> 000 y7 y6 000
    or  d
    ld  d, a          ; D = high byte completo (010 y7 y6 y2 y1 y0)
    
    ld  a, h
    and %00111000     ; A = 00 y5 y4 y3 000 (character row)
    add a, a
    add a, a          ; Shift a sinistra di 2 -> y5 y4 y3 00000
    ld  e, a          ; E = low byte parziale
    
    ld  a, l
    srl a
    srl a
    srl a              ; A = X / 8 (colonna)
    or  e
    ld  e, a          ; E = low byte completo
    
    ld  h, d
    ld  l, e          ; HL = indirizzo finale
    ret

; -------------------------------------------------------------------
; Incrementa indirizzo schermo alla riga (scanline) successiva
; Input/Output: HL = indirizzo schermo
; -------------------------------------------------------------------
IncScreenLine:
    inc h             ; Vai alla riga successiva
    ld  a, h
    and 7             ; Controlla se la scanline è tornata a 0 (wrap)
    ret nz            ; Se non è 0, abbiamo finito!
    
    ld  a, l
    add a, 32         ; Altrimenti passa alla riga di caratteri successiva
    ld  l, a
    ret c             ; Se c'è carry, abbiamo cambiato terzo e H è già corretto!
    
    ; Se non c'è carry, rimaniamo nello stesso terzo. Ripristina il terzo corretto in H.
    ld  a, h
    sub 8
    ld  h, a
    ret

; -------------------------------------------------------------------
; Disegna uno sprite 8x8 a coordinate pixel (X, Y)
; Input: C = X, B = Y, IX = puntatore dati sprite (8 byte)
; -------------------------------------------------------------------
DrawPixelSprite8x8:
    push bc
    push de
    push hl
    push ix
    
    ; 1. Calcola indirizzo schermo
    ld   h, b
    ld   l, c
    call GetScreenAddr ; HL = indirizzo schermo
    
    ; 2. Calcola offset shift = X & 7
    ld   a, c
    and  7
    ld   b, a          ; B = shift offset (0..7)
    
    ld   c, 8          ; 8 linee
.line_loop:
    ld   a, (ix+0)     ; A = byte dello sprite
    ld   d, a
    ld   e, 0
    
    ld   a, b          ; Shift se necessario
    or   a
    jr   z, .no_shift
    
.shift_loop:
    srl  d
    rr   e
    dec  a
    jr   nz, .shift_loop
    
.no_shift:
    ; Scrivi sullo schermo (OR trasparente)
    ld   a, d
    or   (hl)
    ld   (hl), a
    inc  hl
    ld   a, e
    or   (hl)
    ld   (hl), a
    dec  hl            ; Ritorna alla colonna iniziale
    
    call IncScreenLine ; Prossima scanline sullo schermo
    inc  ix            ; Prossimo byte dello sprite
    dec  c
    jr   nz, .line_loop
    
    pop  ix
    pop  hl
    pop  de
    pop  bc
    ret

; -------------------------------------------------------------------
; Ripristina un byte dello sfondo statico.
; Input: A = X del byte schermo in pixel (0, 8, 16...), D = Y pixel
; Output: A = byte di sfondo
; ---------------------------------------------------------------
GetBackgroundByte:
    push hl
    push de
    push bc

    ld   b, a              ; B = X (pixel)
    
    ; 1. Controlla se Y (in D) è fuori dalla griglia di layout (Y < 24 o Y >= 152)
    ld   a, d
    cp   24
    jr   c, .blank
    cp   152
    jr   nc, .blank
    
    ; 2. Calcola riga di layout: r = (Y - 24) / 8
    sub  24
    srl  a
    srl  a
    srl  a                 ; A = r (0..15)
    
    ; 3. HL = r * 8
    ld   l, a
    ld   h, 0
    add  hl, hl
    add  hl, hl
    add  hl, hl            ; HL = r * 8
    
    ; 4. Calcola colonna di layout: c = X / 8 (in B)
    ld   a, b
    srl  a
    srl  a
    srl  a                 ; A = c (0..31)
    ld   b, a              ; B = c
    
    ; HL = r * 8 + c / 4
    srl  a
    srl  a                 ; A = c / 4 (0..7)
    add  a, l
    ld   l, a              ; HL = r * 8 + (c / 4)
    
    push de
    ld   de, (room_ptr)
    add  hl, de            ; HL = layout byte address
    pop  de
    ld   a, (hl)           ; A = layout byte
    
    ; Estrai il bit-pair corrispondente a c % 4
    ld   c, a              ; C = layout byte
    ld   a, b
    and  3                 ; A = c % 4
    jr   z, .shift_0
    dec  a
    jr   z, .shift_1
    dec  a
    jr   z, .shift_2
    ; Case 3 (c % 4 = 3)
    ld   a, c
    jr   .got_type
.shift_2:
    ld   a, c
    rrca
    rrca
    jr   .got_type
.shift_1:
    ld   a, c
    rrca
    rrca
    rrca
    rrca
    jr   .got_type
.shift_0:
    ld   a, c
    rlca
    rlca
.got_type:
    and  3                 ; A = cell type (0..3)
    
    ; 5. Ottieni il puntatore al tile corrispondente
    or   a
    jr   nz, .not_bg
    ld   hl, OFFSET_BG
    jr   .load_tile
.not_bg:
    dec  a
    jr   nz, .not_floor
    ld   hl, OFFSET_FLOOR
    jr   .load_tile
.not_floor:
    dec  a
    jr   nz, .not_wall
    ld   hl, OFFSET_WALL
    jr   .load_tile
.not_wall:
    ld   hl, OFFSET_NASTY
.load_tile:
    push de
    ld   de, (room_ptr)
    add  hl, de            ; HL = tile pointer
    pop  de
    
    ; 6. Calcola offset scanline: s = Y % 8 (in D)
    ld   a, d
    and  7                 ; A = s (0..7)
    inc  a                 ; A = 1 + s
    add  a, l
    ld   l, a
    jr   nc, .no_carry
    inc  h
.no_carry:
    ld   a, (hl)           ; A = byte dello sfondo
    
    pop  bc
    pop  de
    pop  hl
    ret

.blank:
    xor  a
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Cancella uno sprite 8x8 a coordinate pixel (X, Y) ripristinando lo sfondo
; Input: C = X, B = Y
; -------------------------------------------------------------------
ErasePixelSprite8x8:
    push bc
    push de
    push hl
    
    ld   h, b
    ld   l, c
    call GetScreenAddr ; HL = indirizzo schermo (modifica D ed E)
    
    ld   d, b          ; D = Y corrente
    ld   a, c
    and  $f8
    ld   e, a          ; E = X del primo byte schermo in pixel
    
    ld   c, 8          ; 8 linee
.erase_loop:
    ld   a, e
    call GetBackgroundByte
    ld   (hl), a
    inc  hl
    ld   a, e
    add  a, 8
    call GetBackgroundByte
    ld   (hl), a
    dec  hl
    
    call IncScreenLine
    inc  d
    dec  c
    jr   nz, .erase_loop
    
    pop  hl
    pop  de
    pop  bc
    ret

; -------------------------------------------------------------------
; Disegna uno sprite 16x16 a coordinate pixel (X, Y)
; Input: C = X, B = Y, IX = puntatore dati sprite (32 byte)
; -------------------------------------------------------------------
DrawPixelSprite16x16:
    push bc
    push de
    push hl
    push ix
    
    ; 1. Salva la coordinata X per calcolare lo shift
    ld   a, c
    and  7
    ld   (sprite_shift), a
    
    ; 2. Calcola indirizzo schermo
    ld   h, b
    ld   l, c
    call GetScreenAddr ; HL = indirizzo schermo
    
    ld   c, 16          ; 16 linee/scanline
.line_loop:
    ld   d, (ix+0)     ; D = primo byte dello sprite
    ld   e, (ix+1)     ; E = secondo byte dello sprite
    
    ; Esegui lo shift a destra se necessario
    ld   a, (sprite_shift)
    or   a
    jr   z, .no_shift
    
    push bc            ; Salva il contatore delle linee (C) e lo shift (B)
    ld   b, a          ; B = contatore shift
    xor  a             ; A = terzo byte (inizializzato a 0)
    
.shift_loop:
    srl  d
    rr   e
    rr   a
    djnz .shift_loop
    
    pop  bc            ; Ripristina C (contatore linee)
    
    ; Scrive i 3 byte sullo schermo (OR trasparente)
    ld   b, a          ; Salva il 3° byte dello sprite in B
    ld   a, d
    or   (hl)
    ld   (hl), a
    inc  hl
    ld   a, e
    or   (hl)
    ld   (hl), a
    inc  hl
    ld   a, b          ; Recupera il 3° byte dello sprite
    or   (hl)
    ld   (hl), a
    dec  hl
    dec  hl            ; Ripristina HL alla colonna iniziale
    jr   .next_line
    
.no_shift:
    ; Nessuno shift: scrivi i 2 byte direttamente (OR trasparente)
    ld   a, d
    or   (hl)
    ld   (hl), a
    inc  hl
    ld   a, e
    or   (hl)
    ld   (hl), a
    dec  hl            ; Ripristina HL alla colonna iniziale
    
.next_line:
    call IncScreenLine ; Vai alla prossima riga dello schermo
    inc  ix
    inc  ix            ; Avanza di 2 byte nei dati dello sprite
    dec  c
    jr   nz, .line_loop
    
    pop  ix
    pop  hl
    pop  de
    pop  bc
    ret

; -------------------------------------------------------------------
; Cancella uno sprite 16x16 ripristinando lo sfondo statico su 3 colonne
; Input: C = X, B = Y
; -------------------------------------------------------------------
ErasePixelSprite16x16:
    push bc
    push de
    push hl
    
    ld   h, b
    ld   l, c
    call GetScreenAddr ; HL = indirizzo schermo (modifica D ed E)
    
    ld   d, b          ; D = Y corrente
    ld   a, c
    and  $f8
    ld   e, a          ; E = X del primo byte schermo in pixel
    
    ld   c, 16          ; 16 linee
.erase_loop:
    ld   a, e
    call GetBackgroundByte
    ld   (hl), a
    inc  hl
    ld   a, e
    add  a, 8
    call GetBackgroundByte
    ld   (hl), a
    inc  hl
    ld   a, e
    add  a, 16
    call GetBackgroundByte
    ld   (hl), a
    dec  hl
    dec  hl
    
    call IncScreenLine
    inc  d
    dec  c
    jr   nz, .erase_loop
    
    pop  hl
    pop  de
    pop  bc
    ret

; -------------------------------------------------------------------
; Disegna il player (testa e corpo) a coordinate pixel
; -------------------------------------------------------------------
PrintPlayer:
    push ix
    
    ; 1. Determina sprite per la testa (sinistra o destra)
    ld   a, (direction)
    cp   1                 ; Sinistra?
    jr   nz, .right_head
    
    ld   ix, TilesDef + (4 * 8) ; 5° tile (HEAD_GRAPH_LEFT)
    jr   .draw_head
    
.right_head:
    ld   ix, TilesDef + (0 * 8) ; 1° tile (HEAD_GRAPH_RIGHT)
    
.draw_head:
    ld   bc, (PlayerPos)   ; C = PlayerX, B = PlayerY
    call DrawPixelSprite8x8 ; Disegna testa
    
    ; 2. Determina sprite per il corpo (sinistra o destra con frame animazione)
    ld   a, (direction)
    cp   1                 ; Sinistra?
    jr   nz, .right_body
    
    ; Corpo a sinistra
    ld   a, (body_state)   ; 0, 1, 2
    add  a, 5              ; offset del tile per il corpo sinistro (5, 6, 7)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   e, a
    ld   d, 0
    ld   ix, TilesDef
    add  ix, de
    jr   .draw_body

.right_body:
    ; Corpo a destra
    ld   a, (body_state)   ; 0, 1, 2
    add  a, 1              ; offset del tile per il corpo destro (1, 2, 3)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   e, a
    ld   d, 0
    ld   ix, TilesDef
    add  ix, de

.draw_body:
    ld   bc, (PlayerPos)   ; C = PlayerX, B = PlayerY
    ld   a, b
    add  a, 8
    ld   b, a              ; B = PlayerY + 8
    call DrawPixelSprite8x8 ; Disegna corpo
    
    pop  ix
    ret

; -------------------------------------------------------------------
; Cancella il player alle vecchie coordinate pixel
; -------------------------------------------------------------------
DeleteCharAtOldPos:
    ld   bc, (PlayerPosOld) ; C = PlayerXOld, B = PlayerYOld
    call ErasePixelSprite8x8 ; Cancella testa
    
    ld   bc, (PlayerPosOld)
    ld   a, b
    add  a, 8
    ld   b, a
    call ErasePixelSprite8x8 ; Cancella corpo
    ret

; -------------------------------------------------------------------
; Disegna stringa
; Input: HL = stringa, B = lunghezza
; -------------------------------------------------------------------
PrintString:
    ld   a, (hl)
    rst  $10
    inc  hl
    djnz PrintString
    ret

; -------------------------------------------------------------------
; NUOVA ROUTINE: Disegna bordi verticali
; Input: B = riga di partenza, C = numero di righe
; -------------------------------------------------------------------
DrawVerticalBorders:
    push bc
    push de
    push hl
    push ix
    
    ld   b, 8            ; B = coordinata Y pixel (inizia a Y=8, riga 1)
    ld   c, 16           ; C = numero di righe di caratteri (16)
    
.row_loop:
    push bc              ; Salva contatore riga e Y
    
    ; 1. Disegna bordo sinistro (X = 0)
    ld   h, b            ; H = Y
    ld   l, 0            ; L = X (0)
    call GetScreenAddr   ; HL = indirizzo schermo
    ld   ix, TilesDef + 64 ; IX = grafica del bordo (9° carattere)
    ld   d, 8            ; 8 scanline
.left_loop:
    ld   a, (ix+0)
    ld   (hl), a         ; Scrivi direttamente in memoria schermo
    call IncScreenLine   ; Prossima scanline
    inc  ix
    dec  d
    jr   nz, .left_loop
    
    ; 2. Disegna bordo destro (X = 248, colonna 31)
    pop  bc              ; Ripristina Y
    push bc
    ld   h, b            ; H = Y
    ld   l, 248          ; L = X (248, colonna 31)
    call GetScreenAddr   ; HL = indirizzo schermo
    ld   ix, TilesDef + 64
    ld   d, 8
.right_loop:
    ld   a, (ix+0)
    ld   (hl), a
    call IncScreenLine
    inc  ix
    dec  d
    jr   nz, .right_loop
    
    pop  bc              ; Ripristina Y e contatore righe
    ld   a, b
    add  a, 8
    ld   b, a            ; Y = Y + 8
    dec  c
    jr   nz, .row_loop
    
    ; Imposta gli attributi a ROSSO per le colonne 0 e 31 (righe 1..16)
    ld   hl, $5800 + (1 * 32)      ; Riga 1, Colonna 0
    ld   de, $5800 + (1 * 32) + 31 ; Riga 1, Colonna 31
    ld   b, 16                     ; 16 righe
.attr_loop:
    ld   (hl), RED                 ; Colonna 0 = ROSSO
    ld   a, RED
    ld   (de), a                   ; Colonna 31 = ROSSO
    
    ; Prossima riga di attributi (HL = HL + 32, DE = DE + 32)
    ld   a, l
    add  a, 32
    ld   l, a
    ld   a, h
    adc  a, 0
    ld   h, a
    
    ld   a, e
    add  a, 32
    ld   e, a
    ld   a, d
    adc  a, 0
    ld   d, a
    
    dec  b
    jr   nz, .attr_loop
    
    pop  ix
    pop  hl
    pop  de
    pop  bc
    ret

; -------------------------------------------------------------------
; Cancella i bordi verticali (colonne 1 e 32)
; -------------------------------------------------------------------
EraseVerticalBorders:
    push bc
    push de
    push hl
    push ix
    
    ld   b, 8            ; B = Y (inizia a Y=8, riga 1)
    ld   c, 16           ; C = 16 righe
    
.row_loop:
    push bc
    
    ; 1. Cancella bordo sinistro (X = 0)
    ld   h, b
    ld   l, 0
    call GetScreenAddr   ; HL = indirizzo schermo
    ld   d, 8            ; 8 scanline
.left_loop:
    xor  a
    ld   (hl), a         ; Scrivi 0 (spazio nero)
    call IncScreenLine
    dec  d
    jr   nz, .left_loop
    
    ; 2. Cancella bordo destro (X = 248, colonna 31)
    pop  bc
    push bc
    ld   h, b
    ld   l, 248
    call GetScreenAddr
    ld   d, 8
.right_loop:
    xor  a
    ld   (hl), a
    call IncScreenLine
    dec  d
    jr   nz, .right_loop
    
    pop  bc
    ld   a, b
    add  a, 8
    ld   b, a            ; Y = Y + 8
    dec  c
    jr   nz, .row_loop
    
    ; Ripristina gli attributi a BIANCO per le colonne 0 e 31 (righe 1..16)
    ld   hl, $5800 + (1 * 32)
    ld   de, $5800 + (1 * 32) + 31
    ld   b, 16
.attr_loop:
    ld   (hl), WHITE               ; Colonna 0 = BIANCO
    ld   a, WHITE
    ld   (de), a                   ; Colonna 31 = BIANCO
    
    ld   a, l
    add  a, 32
    ld   l, a
    ld   a, h
    adc  a, 0
    ld   h, a
    
    ld   a, e
    add  a, 32
    ld   e, a
    ld   a, d
    adc  a, 0
    ld   d, a
    
    dec  b
    jr   nz, .attr_loop
    
    pop  ix
    pop  hl
    pop  de
    pop  bc
    ret

; -------------------------------------------------------------------
; Disegna la riga/pavimento sotto i piedi degli sprite (Riga 18, Y = 144)
; -------------------------------------------------------------------
; -------------------------------------------------------------------
; Disegna un tile 8x8 sullo schermo
; Input: B = Row (0..23), C = Col (0..31), IX = Puntatore al Tile (9 byte: 1 attr + 8 bitmap)
; -------------------------------------------------------------------
DrawTile:
    push bc
    push de
    push hl
    
    ; 1. Calcola indirizzo dello schermo (bitmap) per Row B, Col C, scanline 0
    ; HighByte = $40 + (B & $18)
    ld   a, b
    and  $18
    add  a, $40
    ld   h, a              ; H = High byte
    
    ; LowByte = ((B & 7) * 32) + C
    ld   a, b
    and  7
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, a              ; *16
    add  a, a              ; *32
    add  a, c              ; + Col C
    ld   l, a              ; L = Low byte
    
    ; 2. Copia gli 8 byte del bitmap
    ld   d, 8              ; 8 scanline
    push ix
    inc  ix                ; Salta l'attributo, vai al bitmap
.line_loop:
    ld   a, (ix+0)
    ld   (hl), a
    inc  h                 ; Prossima scanline (stessa riga di caratteri)
    inc  ix
    dec  d
    jr   nz, .line_loop
    pop  ix
    
    ; 3. Scrivi l'attributo
    ; AttrAddr = $5800 + B * 32 + C
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
    
    ld   a, (ix+0)         ; A = attribute byte
    ld   (hl), a           ; Scrivi in memoria attributi
    
    pop  hl
    pop  de
    pop  bc
    ret

; -------------------------------------------------------------------
; Disegna la stanza corrente leggendola dalla struttura dati
; -------------------------------------------------------------------
DrawRoom:
    push bc
    push de
    push hl
    push ix
    
    ld   b, 0              ; B = layout row (0..15)
.row_loop:
    ld   c, 0              ; C = layout column group (0..7 bytes)
.col_byte_loop:
    ld   h, 0
    ld   l, b
    add  hl, hl
    add  hl, hl
    add  hl, hl            ; HL = B * 8
    ld   d, 0
    ld   e, c              ; DE = C
    add  hl, de            ; HL = B * 8 + C
    ld   de, (room_ptr)
    add  hl, de            ; HL = layout byte address
    ld   a, (hl)           ; A = layout byte
    ld   d, a              ; D = salva il byte di layout
    
    ld   e, 4              ; 4 celle per byte
.cell_loop:
    ld   a, d
    rlca
    rlca
    ld   d, a              ; D ruotato di 2
    and  3                 ; A = cell type (0..3)
    
    push de
    push bc
    
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
    
    pop  bc                ; BC = original BC
    pop  de                ; DE = original DE
    push de                ; Save for next iteration
    push bc                ; Save for next iteration
    
    ld   a, b
    add  a, 3              ; A = screen Row (R = r + 3)
    ld   h, a
    
    ld   a, c
    add  a, a              ; *2
    add  a, a              ; *4 (Col group * 4)
    ld   l, a              ; L = Col group * 4
    
    ld   a, 4
    sub  e                 ; A = 4 - E (0..3)
    add  a, l              ; A = Col group * 4 + (4 - E)
    ld   l, a              ; L = Col
    
    ld   b, h
    ld   c, l
    call DrawTile
    
    pop  bc
    pop  de
    dec  e
    jp   nz, .cell_loop
    
    inc  c
    ld   a, c
    cp   8
    jp   nz, .col_byte_loop
    
    inc  b
    ld   a, b
    cp   16
    jp   nz, .row_loop
    
    pop  ix
    pop  hl
    pop  de
    pop  bc
    ret

; -------------------------------------------------------------------
; Dati grafici (9 caratteri)
; -------------------------------------------------------------------
TilesDef:
    ; 8 caratteri per il player
    db %00000110, %00111110, %01111110, %00110100, %00111110, %00111100, %00011000, %00111100
    db %01111110, %01111110, %11110111, %11111011, %00111100, %01110110, %01101110, %01110111
    db %01101110, %01101110, %01101110, %01110110, %00111100, %00011000, %00011000, %00011100
    db %01111110, %01111110, %11110111, %11111011, %00111100, %11101101, %11000111, %11100110
    db %01100000, %01111100, %01111110, %00101100, %01111100, %00111100, %00011000, %00111100
    db %01111110, %01111110, %11101111, %11011111, %00111100, %01101110, %01110110, %11101110
    db %01110110, %01110110, %01110110, %01101110, %00111100, %00011000, %00011000, %00111000
    db %01111110, %01111110, %11101111, %11011111, %00111100, %10110111, %11100011, %01100111
    
    ; 9° carattere per i bordi verticali
    db %11111111, %10001000, %11111111, %00100010, %11111111, %10001000, %11111111, %00100100

LamettaSpriteRight: ; appears in Top Landing, Tree Root and West Bedroom.
    db 0,0,0,0,0,0,127,254,64,2,255,255,222,123,192,3	
	db 192,3,222,123,255,255,64,2,127,254,0,0,0,0,0,0	
	db 10,0,29,0,54,128,103,64,195,160,113,208,184,104,92,52	
	db 44,58,22,29,11,142,5,195,2,230,1,108,0,184,0,80	
	db 7,224,31,248,20,40,22,104,22,104,22,104,22,104,20,40	
	db 20,40,22,104,22,104,22,104,22,104,20,40,31,248,7,224	
	db 0,80,0,184,1,108,2,230,5,195,11,142,22,29,44,58	
	db 92,52,184,104,113,208,195,160,103,64,54,128,29,0,10,0

LamettaSpriteLeft:
    db 0,0,0,0,0,0,127,254,64,2,255,255,222,123,192,3	
	db 192,3,222,123,255,255,64,2,127,254,0,0,0,0,0,0	
	db 0,80,0,184,1,108,2,230,5,195,11,142,22,29,44,58	
	db 92,52,184,104,113,208,195,160,103,64,54,128,29,0,10,0
	db 7,224,31,248,20,40,22,104,22,104,22,104,22,104,20,40	
	db 20,40,22,104,22,104,22,104,22,104,20,40,31,248,7,224	
	db 10,0,29,0,54,128,103,64,195,160,113,208,184,104,92,52	
	db 44,58,22,29,11,142,5,195,2,230,1,108,0,184,0,80	

ChipSprite: ; appears in The Banyan Tree and A bit of tree.
    db 0,0,0,0,42,170,127,255,127,255,124,63,124,63,127,255	
    db 127,255,127,255,0,0,42,170,0,0,42,170,0,0,0,0	
    db 0,72,1,44,4,188,18,254,75,254,46,127,188,63,254,124	
    db 255,242,127,201,127,37,60,148,50,80,9,64,5,0,4,0	
    db 0,0,7,224,15,240,23,232,15,240,22,104,14,112,22,104	
    db 15,240,23,232,15,240,23,232,8,16,23,232,16,8,0,0	
    db 18,0,52,128,61,32,127,72,127,210,254,116,252,61,62,127	
    db 79,255,147,254,164,254,41,60,10,76,2,144,0,160,0,32

TheChapelSprite: ;appears in The Chapel and The Banyan Tree.
    db  0,0,0,0,0,0,2,2,34,2,169,84,168,216,113,116	
    db 34,218,59,174,46,171,36,249,32,219,32,216,1,84,2,138	
    db 0,0,2,2,2,2,1,116,0,216,81,84,82,250,35,222	
    db 231,171,30,249,24,217,8,217,9,84,6,138,4,0,0,0	
    db 2,2,3,142,0,248,1,84,2,218,3,254,17,139,75,169	
    db 43,251,150,248,108,216,5,84,2,138,1,0,0,128,0,64	
    db 0,0,2,2,2,2,1,116,0,216,81,84,82,250,35,222	
    db 231,171,30,249,24,217,8,217,9,84,6,138,4,0,0,0

WallBaseSprite: ; appears in East Wall Base, The Chapel and West  Wing.
    db 32,4,174,236,187,125,224,7,189,181,160,4,59,124,0,0	
    db 29,176,32,4,59,124,162,68,253,183,160,4,59,220,32,4	
    db 32,4,55,180,160,4,251,127,160,4,61,180,32,4,27,120	
    db 0,0,61,180,162,68,187,125,224,7,189,181,183,236,32,4	
    db 32,4,58,220,61,189,224,7,59,117,32,4,61,188,0,0	
    db 27,112,32,4,61,189,162,69,251,119,160,5,61,237,32,4	
    db 32,4,59,117,160,5,253,191,160,5,59,117,32,4,29,184	
    db 0,0,59,116,36,132,61,189,224,7,59,117,46,236,32,4

SpirlaSprite: ;  appears in The Banyan Tree and Orangery.
    db 15,240,23,232,24,24,55,204,40,36,83,146,100,74,169,43	
    db 170,43,106,74,105,146,36,36,51,204,24,24,23,232,15,240	
    db 0,224,7,240,56,24,115,204,100,38,73,147,82,75,212,43	
    db 213,42,212,202,210,18,73,228,36,12,19,244,8,120,7,128	
    db 1,128,7,224,24,24,115,206,164,37,201,149,210,85,212,85	
    db 212,149,210,37,201,201,228,19,115,230,24,24,7,224,1,128	
    db 7,0,8,224,31,220,48,38,103,146,200,74,211,42,212,171	
    db 84,43,82,75,73,147,36,38,51,204,40,24,31,240,1,224

CutSprite: ; appears in On a Branch Over the Drive, Conservatory Roof and Tool  Shed.
    db 12,0,12,0,12,0,12,0,12,0,30,0,18,0,51,0	
    db 63,0,115,128,97,128,97,128,192,192,192,192,128,64,128,64	
    db 8,64,8,64,12,192,4,128,7,128,7,128,12,192,28,224	
    db 59,112,48,48,96,24,96,24,64,8,192,12,128,4,128,4	
    db 2,16,2,16,3,48,1,32,1,224,1,224,3,48,7,56	
    db 14,220,12,12,24,6,24,6,16,2,48,3,32,1,32,1	
    db 0,48,0,48,0,48,0,48,0,48,0,120,0,72,0,204	
    db 0,252,1,206,1,134,1,134,3,3,3,3,2,1,2,1

PliersSprite: ; appears in To the Kitchens    Main Stairway, Halfway up the East Wall, Conservatory Roof and The Bow.
    db 126,0,153,0,255,0,129,0,126,0,24,0,36,0,36,0	
    db 66,0,66,0,129,0,231,0,165,0,195,0,165,0,231,0	
    db 0,0,31,128,38,64,57,192,48,192,31,128,9,0,16,128	
    db 32,64,64,32,128,16,224,112,160,80,192,48,160,80,224,112	
    db 0,0,0,0,0,0,7,224,9,144,14,112,14,112,6,96	
    db 27,216,96,6,128,1,224,7,160,5,192,3,160,5,224,7	
    db 0,0,1,248,2,100,3,156,3,12,1,248,0,144,1,8	
    db 2,4,4,2,8,1,14,7,10,5,12,3,10,5,14,7

RobotSprite: ; appears in Under the Drive.
    db 12,0,18,0,33,16,18,32,140,64,82,128,47,0,47,0	
    db 95,128,95,128,95,128,0,0,255,192,93,128,93,128,255,192	
    db 0,1,0,2,131,4,76,200,35,16,20,160,11,192,11,192	
    db 23,224,23,224,23,224,0,0,63,240,27,176,27,176,63,240	
    db 128,0,64,0,32,1,17,226,8,196,5,40,2,240,2,240	
    db 5,248,5,248,5,248,0,0,15,252,11,116,11,116,15,252	
    db 0,0,0,0,8,48,4,204,2,49,1,74,0,188,0,188	
    db 1,126,1,126,1,126,0,0,3,255,2,237,2,237,3,255

SwissArmyKife: ; appears in Top Landing, Under the Roof and Tool  Shed.
    db 56,0,124,0,126,0,109,128,68,64,108,64,124,32,124,0	
    db 124,12,124,50,252,204,255,48,252,192,127,0,108,0,56,0	
    db 14,96,31,148,31,8,27,32,17,80,27,80,31,160,31,160	
    db 127,64,223,64,223,128,159,128,127,0,31,0,27,0,14,0	
    db 3,128,7,192,7,224,6,216,4,68,14,196,127,194,239,192	
    db 239,192,143,192,119,192,7,192,7,192,7,192,6,192,3,128	
    db 0,224,1,240,1,240,1,178,1,21,1,181,1,250,1,250	
    db 7,244,13,244,13,248,9,248,7,240,1,240,1,176,0,224

EggSpriteRight: ; appears in The Drive, Cuckoo's Nest, To the Kitchens    Main Stairway and Back Stairway.
    db 12,0,22,0,47,0,47,0,79,128,95,128,95,128,159,192	
    db 191,192,189,192,186,192,189,64,90,128,93,128,63,0,12,0	
    db 0,0,0,0,0,0,0,112,3,152,12,120,51,248,71,240	
    db 95,240,191,240,190,160,189,96,90,192,93,64,63,128,14,0	
    db 0,0,0,0,0,0,0,0,3,192,28,120,33,252,79,254	
    db 95,254,159,255,191,239,95,86,95,174,35,84,31,248,3,192	
    db 0,0,0,0,0,0,14,0,23,192,23,240,19,252,11,254	
    db 11,254,11,215,5,235,5,215,2,234,2,126,1,140,0,112

EggSpriteLeft:
    db 12,0,22,0,47,0,47,0,79,128,95,128,95,128,159,192	
    db 191,192,189,192,186,192,189,64,90,128,93,128,63,0,12,0	
    db 0,0,0,0,0,0,14,0,23,192,23,240,19,252,11,254	
    db 11,254,11,215,5,235,5,215,2,234,2,126,1,140,0,112
    db 0,0,0,0,0,0,0,0,3,192,28,120,33,252,79,254	
    db 95,254,159,255,191,239,95,86,95,174,35,84,31,248,3,192
    db 0,0,0,0,0,0,0,112,3,152,12,120,51,248,71,240	
    db 95,240,191,240,190,160,189,96,90,192,93,64,63,128,14,0	

PacManSprite: ; appears in The Attic.
    db 7,192,24,48,35,136,68,68,136,34,144,19,144,19,136,34	
    db 68,68,35,136,24,48,7,192,3,0,3,0,3,0,3,128	
    db 7,192,24,48,32,8,67,132,132,66,136,35,136,35,132,66	
    db 67,132,32,8,24,48,7,192,15,128,29,208,8,224,4,64	
    db 7,192,31,240,62,120,124,60,126,124,255,254,255,254,240,0	
    db 255,128,127,240,127,252,63,248,31,240,7,192,0,0,0,0	
    db 7,192,31,240,60,248,120,124,124,252,255,128,252,0,240,0	
    db 248,0,126,0,127,128,63,224,31,240,7,192,0,0,0,0
