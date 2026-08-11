;===========================================================================
; graphics.asm
;===========================================================================

; -------------------------------------------------------------------
; Copia il set dei caratteri dalla ROM alla RAM
; -------------------------------------------------------------------
Gfx_CopyChars:
    ld hl, $3D00  ; Indirizzo del set di caratteri originale in ROM (ASCII 32)
    ld de, $8100  ; Indirizzo in RAM per ASCII 32..127 ($8000 + 32*8)
    ld bc, 768    ; Numero di byte da copiare (96 caratteri * 8 byte ciascuno)
    ldir          ; Copiare i dati
    ret

; -------------------------------------------------------------------
; Ridefinisci i caratteri (incluso quello per i bordi)
; -------------------------------------------------------------------
Gfx_DefineChars:
    ld hl, Willy             ; Indirizzo dei dati del nuovo carattere
    ld de, $8008             ; Indirizzo di ASCII 1 nel nuovo set di caratteri ($8000 + 1*8)
    ld bc, 72                ; Numero di byte da copiare (9 caratteri * 8 byte)
    ldir                        ; Effettua la copia dei caratteri
    ld hl, $8000                ; Indirizzo del nuovo set di caratteri in RAM (font base ASCII 0)
    ld ($5C36), hl              ; Aggiornare la variabile di sistema CHARS
    ret

; -------------------------------------------------------------------
; Posiziona il cursore
; Input: B = Y, C = X
; -------------------------------------------------------------------
Gfx_At:
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
Gfx_Ink:
    exx
    and  $07               ; Garantisci colore 0..7
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
Gfx_GetScreenAddr:
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
Gfx_IncScreenLine:
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
Gfx_DrawPixelSprite8x8:
    push bc
    push de
    push hl
    push ix
    
    ; 1. Calcola indirizzo schermo
    ld   h, b
    ld   l, c
    call Gfx_GetScreenAddr ; HL = indirizzo schermo
    
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
    
    call Gfx_IncScreenLine ; Prossima scanline sullo schermo
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
Gfx_GetBackgroundByte:
    push hl
    push de
    push bc

    ld   b, a              ; B = X (pixel)
    
    ; 1. Controlla se Y (in D) è fuori dalla griglia di layout (Y >= 128)
    ld   a, d
    cp   128
    jp   nc, .blank
    
    ; Converti Y (in D) e X (in B) a cella
    srl  a
    srl  a
    srl  a                 ; A = layout row r (0..15)
    ld   e, a              ; E = r (Row)
    
    ld   a, b
    srl  a
    srl  a
    srl  a                 ; A = column c (0..31)
    ld   c, a              ; C = c (Col)

    ; --- Controlla se c'è un Item Attivo in questa cella ---
    push de
    push bc
    ld   b, c              ; B = Col
    ld   c, e              ; C = Row
    call CheckActiveItemAtCell
    jr   nc, .no_item
    
    pop  bc
    pop  de
    
    ld   a, d
    and  7                 ; A = scanline (0..7)
    ld   e, a
    ld   d, 0              ; DE = scanline offset
    ld   hl, (room_ptr)
    push bc
    ld   bc, OFFSET_ITEM_GRAPHIC
    add  hl, bc
    pop  bc
    add  hl, de            ; HL = indirizzo del byte dello sprite
    ld   a, (hl)           ; A = byte dello sprite dell'item
    
    pop  bc
    pop  de
    pop  hl
    ret

.no_item:
    pop  bc
    pop  de

    ; --- Controlla Conveyor ---
    ld   a, (conveyor_len)
    or   a
    jp   z, .check_ramp
    
    ld   a, (conveyor_row)
    cp   e
    jp   nz, .check_ramp
    
    ld   a, (conveyor_col)
    cp   c
    jp   z, .is_conveyor
    jp   c, .c_greater
    jp   .check_ramp
.c_greater:
    ld   hl, conveyor_len
    add  a, (hl)
    cp   c
    jp   z, .check_ramp
    jp   c, .check_ramp
.is_conveyor:
    ld   hl, OFFSET_CONVEYOR
    jp   .load_tile

.check_ramp:
    ld   a, (ramp_len)
    or   a
    jp   z, .normal_grid
    
    ld   a, (ramp_row)     ; A = RampRowStart
    cp   e                 ; compare with player row E
    jp   c, .normal_grid   ; if RampRowStart < E, skip!
    
    sub  e                 ; A = RampRowStart - E
    ld   b, a              ; B = distance from start row (0..ramp_len-1)
    ld   a, (ramp_len)
    cp   b
    jp   z, .normal_grid   ; if B == ramp_len, too high!
    jp   c, .normal_grid   ; if B > ramp_len, too high!
    
    ; Calcola ExpectedCol:
    ld   a, (ramp_dir)
    or   a
    jr   z, .r_left
.r_right:
    ld   a, (ramp_col)
    add  a, b              ; A = ramp_col + B
    jr   .compare_col
.r_left:
    ld   a, (ramp_col)
    sub  b                 ; A = ramp_col - B
.compare_col:
    cp   c                 ; Compare with player col C
    jp   nz, .normal_grid  ; If not equal, not on ramp!
    
    ld   hl, OFFSET_RAMP
    jp   .load_tile

.normal_grid:
    ld   a, e              ; A = r (Row, calculated at the start of Gfx_GetBackgroundByte)
    ; C already contains c (Col, calculated at the start of Gfx_GetBackgroundByte)
    call GetCellFromUnpacked ; A = cell type (0..3)

    
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
Gfx_ErasePixelSprite8x8:
    push bc
    push de
    push hl
    
    ld   h, b
    ld   l, c
    call Gfx_GetScreenAddr ; HL = indirizzo schermo (modifica D ed E)
    
    ld   d, b          ; D = Y corrente
    ld   a, c
    and  $f8
    ld   e, a          ; E = X del primo byte schermo in pixel
    
    ld   c, 8          ; 8 linee
.erase_loop:
    ld   a, e
    call Gfx_GetBackgroundByte
    ld   (hl), a
    inc  hl
    ld   a, e
    add  a, 8
    call Gfx_GetBackgroundByte
    ld   (hl), a
    dec  hl
    
    call Gfx_IncScreenLine
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
Gfx_DrawPixelSprite16x16:
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
    call Gfx_GetScreenAddr ; HL = indirizzo schermo
    
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
    call Gfx_IncScreenLine ; Vai alla prossima riga dello schermo
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
Gfx_ErasePixelSprite16x16:
    push bc
    push de
    push hl
    
    ld   h, b
    ld   l, c
    call Gfx_GetScreenAddr ; HL = indirizzo schermo (modifica D ed E)
    
    ld   d, b          ; D = Y corrente
    ld   a, c
    and  $f8
    ld   e, a          ; E = X del primo byte schermo in pixel
    
    ld   c, 16          ; 16 linee
.erase_loop:
    ld   a, e
    call Gfx_GetBackgroundByte
    ld   (hl), a
    inc  hl
    ld   a, e
    add  a, 8
    call Gfx_GetBackgroundByte
    ld   (hl), a
    inc  hl
    ld   a, e
    add  a, 16
    call Gfx_GetBackgroundByte
    ld   (hl), a
    dec  hl
    dec  hl
    
    call Gfx_IncScreenLine
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
Gfx_PrintPlayer:
    push ix
    
    ; 1. Determina sprite per la testa (sinistra o destra)
    ld   a, (direction)
    cp   1                 ; Sinistra?
    jr   nz, .right_head
    
    ld   ix, Willy + (4 * 8) ; 5° tile (HEAD_GRAPH_LEFT)
    jr   .draw_head
    
.right_head:
    ld   ix, Willy + (0 * 8) ; 1° tile (HEAD_GRAPH_RIGHT)
    
.draw_head:
    ld   bc, (PlayerPos)   ; C = PlayerX, B = PlayerY
    call Gfx_DrawPixelSprite8x8 ; Disegna testa
    
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
    ld   ix, Willy
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
    ld   ix, Willy
    add  ix, de

.draw_body:
    ld   bc, (PlayerPos)   ; C = PlayerX, B = PlayerY
    ld   a, b
    add  a, 8
    ld   b, a              ; B = PlayerY + 8
    call Gfx_DrawPixelSprite8x8 ; Disegna corpo
    
    pop  ix
    ret

; -------------------------------------------------------------------
; Cancella il player alle vecchie coordinate pixel
; -------------------------------------------------------------------
Gfx_DeleteCharAtOldPos:
    ld   bc, (PlayerPosOld) ; C = PlayerXOld, B = PlayerYOld
    call Gfx_ErasePixelSprite8x8 ; Cancella testa
    
    ld   bc, (PlayerPosOld)
    ld   a, b
    add  a, 8
    ld   b, a
    call Gfx_ErasePixelSprite8x8 ; Cancella corpo
    ret

; -------------------------------------------------------------------
; Disegna stringa
; Input: HL = stringa, B = lunghezza
; -------------------------------------------------------------------
Gfx_PrintString:
    ld   a, (hl)
    rst  $10
    inc  hl
    djnz Gfx_PrintString
    ret

; -------------------------------------------------------------------
; Disegna il nome della stanza sotto la piattaforma di base (Riga 16)
; -------------------------------------------------------------------
Gfx_PrintRoomName:
    ; Posiziona il cursore a Y = 16, X = 0 usando i codici di controllo rst $10
    ld   a, 22             ; Codice di controllo AT (22)
    rst  $10
    ld   a, 16             ; Riga 16
    rst  $10
    ld   a, 0              ; Colonna 0
    rst  $10
    
    ld   a, YELLOW         ; Inchiostro Giallo
    call Gfx_Ink
    
    ld   hl, (room_ptr)    ; HL = indirizzo stanza
    ld   de, 128           ; Offset del nome stanza (32 byte)
    add  hl, de            ; HL = indirizzo nome stanza
    ld   b, 32             ; B = 32 caratteri
    call Gfx_PrintString

    ; Posiziona il cursore a Y = 18, X = 0 usando i codici di controllo rst $10
    ld   a, 22             ; Codice di controllo AT (22)
    rst  $10
    ld   a, 18             ; Riga 18
    rst  $10
    ld   a, 0              ; Colonna 0
    rst  $10
    
    ld   hl, status_line   ; HL = indirizzo stringa di stato
    ld   b, 32             ; B = 32 caratteri
    call Gfx_PrintString

    ; Applica i colori agli attributi di Riga 18 ($5A40)
    ld   hl, status_line_attrs
    ld   de, $5a40         ; Indirizzo attributi Riga 18
    ld   bc, 32            ; 32 byte
    ldir

    ; Disegna i 7 Willy in basso a sinistra (Row 19, 20)
    call Gfx_PrintWillyLives
    ret

Gfx_PrintWillyLives:
    push hl
    push bc
    push de
    push af
    
    ; Primo Willy (Colonna 0, giallo)
    ld   hl, willy_lives
    ld   a, (hl)
    cp   1
    ld   c, 0
    jr   c, .erase_1
    ld   a, $40 | YELLOW
    call Gfx_DrawWillyLifeIcon
    jr   .check_2
.erase_1:
    call Gfx_EraseWillyLifeIcon
    
.check_2:
    ld   a, (willy_lives)
    cp   2
    ld   c, 2
    jr   c, .erase_2
    ld   a, $40 | CYAN
    call Gfx_DrawWillyLifeIcon
    jr   .check_3
.erase_2:
    call Gfx_EraseWillyLifeIcon

.check_3:
    ld   a, (willy_lives)
    cp   3
    ld   c, 4
    jr   c, .erase_3
    ld   a, $40 | GREEN
    call Gfx_DrawWillyLifeIcon
    jr   .check_4
.erase_3:
    call Gfx_EraseWillyLifeIcon

.check_4:
    ld   a, (willy_lives)
    cp   4
    ld   c, 6
    jr   c, .erase_4
    ld   a, $40 | MAGENTA
    call Gfx_DrawWillyLifeIcon
    jr   .check_5
.erase_4:
    call Gfx_EraseWillyLifeIcon

.check_5:
    ld   a, (willy_lives)
    cp   5
    ld   c, 8
    jr   c, .erase_5
    ld   a, $40 | RED
    call Gfx_DrawWillyLifeIcon
    jr   .check_6
.erase_5:
    call Gfx_EraseWillyLifeIcon

.check_6:
    ld   a, (willy_lives)
    cp   6
    ld   c, 10
    jr   c, .erase_6
    ld   a, $40 | BLUE
    call Gfx_DrawWillyLifeIcon
    jr   .check_7
.erase_6:
    call Gfx_EraseWillyLifeIcon

.check_7:
    ld   a, (willy_lives)
    cp   7
    ld   c, 12
    jr   c, .erase_7
    ld   a, $40 | WHITE
    call Gfx_DrawWillyLifeIcon
    jr   .done
.erase_7:
    call Gfx_EraseWillyLifeIcon

.done:
    pop  af
    pop  de
    pop  bc
    pop  hl
    ret

Gfx_EraseWillyLifeIcon:
    ; Input: C = Colonna (0..31)
    ld   e, c              ; E = Colonna
    
    ; 1. Cancella la testa a Row 20, Colonna E
    ld   a, e
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   c, a              ; C = X pixel
    ld   b, 160            ; B = Y pixel (Row 20)
    call Gfx_ClearPixelSprite8x8
    
    ; 2. Cancella il corpo a Row 21, Colonna E
    ld   b, 168            ; B = Y pixel (Row 21)
    call Gfx_ClearPixelSprite8x8
    
    ; 3. Resetta gli attributi a Row 20 e Row 21 per Colonna E a nero (0)
    ; AttrAddr = $5A80 + E
    ld   h, $5a
    ld   a, $80
    add  a, e
    ld   l, a
    jr   nc, .no_carry1
    inc  h
.no_carry1:
    ld   (hl), 0           ; Scrivi colore testa a 0 (nero)
    
    ; AttrAddr = $5AA0 + E
    ld   h, $5a
    ld   a, $a0
    add  a, e
    ld   l, a
    jr   nc, .no_carry2
    inc  h
.no_carry2:
    ld   (hl), 0           ; Scrivi colore corpo a 0 (nero)
    ret

Gfx_ClearPixelSprite8x8:
    push bc
    push de
    push hl
    
    ; 1. Calcola indirizzo schermo
    ld   h, b
    ld   l, c
    call Gfx_GetScreenAddr ; HL = indirizzo schermo
    
    ld   c, 8          ; 8 linee
.line_loop:
    ld   (hl), 0       ; Pulisci la cella dello schermo (imposta a zero)
    call Gfx_IncScreenLine ; Prossima scanline sullo schermo
    dec  c
    jr   nz, .line_loop
    
    pop  hl
    pop  de
    pop  bc
    ret

Gfx_UpdateItemsCollectedDisplay:
    push af
    push bc
    push de
    push hl

    ld   a, (items_collected)
    ld   c, 0              ; C = centinaia
.loop100:
    cp   100
    jr   c, .done100
    sub  100
    inc  c
    jr   .loop100
.done100:
    ld   e, a              ; Salva il resto in E
    ld   a, c
    add  a, '0'
    ld   (status_line + 16), a ; Centinaia
    
    ld   a, e              ; Ripristina il resto
    ld   c, 0              ; C = decine
.loop10:
    cp   10
    jr   c, .done10
    sub  10
    inc  c
    jr   .loop10
.done10:
    ld   e, a              ; E = unità
    ld   a, c
    add  a, '0'
    ld   (status_line + 17), a ; Decine
    
    ld   a, e
    add  a, '0'
    ld   (status_line + 18), a ; Unità

    ; Ora ristampa la riga di stato a riga 18
    ld   a, 22             ; Codice di controllo AT (22)
    rst  $10
    ld   a, 18             ; Riga 18
    rst  $10
    ld   a, 0              ; Colonna 0
    rst  $10
    
    ld   hl, status_line   ; HL = indirizzo stringa di stato
    ld   b, 32             ; B = 32 caratteri
    call Gfx_PrintString

    ; Ripristina i colori degli attributi di Riga 18 ($5A40)
    ld   hl, status_line_attrs
    ld   de, $5a40         ; Indirizzo attributi Riga 18
    ld   bc, 32            ; 32 byte
    ldir

    pop  hl
    pop  de
    pop  bc
    pop  af
    ret

status_line:
    db "Items collected 000 "

status_line_time:
    db "Time  7:30am"

status_line_attrs:
    db 65, 66, 67, 68, 69, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 70, 69, 68, 67, 66, 65

; -------------------------------------------------------------------
; Disegna riga/pavimento sotto i piedi degli sprite (Riga 18, Y = 144)
; -------------------------------------------------------------------
Gfx_DrawWillyLifeIcon:
    ; Input: C = Colonna (0..31), A = Colore Gfx_Ink (1..7 / bright color)
    ; D = Colore, E = Colonna
    ld   d, a              ; D = Colore
    ld   e, c              ; E = Colonna
    
    ; 0. Cancella la testa e il corpo per evitare artefatti da OR
    push bc
    push de
    ld   a, e
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   c, a              ; C = X pixel
    ld   b, 160            ; B = Y pixel (Row 20 / head)
    call Gfx_ClearPixelSprite8x8
    ld   b, 168            ; B = Y pixel (Row 21 / body)
    call Gfx_ClearPixelSprite8x8
    pop  de
    pop  bc
    
    ; 1. Disegna la testa a Row 20, Colonna E
    ; X pixel = E * 8
    ld   a, e
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   c, a              ; C = X pixel
    ld   b, 160            ; B = Y pixel (Row 20)
    ld   ix, Willy + 0*8   ; IX = head facing right
    call Gfx_DrawPixelSprite8x8
    
    ; 2. Disegna il corpo a Row 21, Colonna E
    ld   b, 168            ; B = Y pixel (Row 21)
    
    push de                ; SALVA D = Colore, E = Colonna
    
    ; Determina il frame del corpo per le icone delle vite
    IF ENABLE_ANIMATE_LIVES != 0
    ; Calcola il frame animato dal contatore
    ld   a, (counter)
    rrca
    rrca
    rrca
    and  %00000011         ; A = 0..3
    cp   3
    jr   nz, .not_3
    ld   a, 1              ; map 3 to 1 -> cycle is 0, 1, 2, 1
.not_3:
    inc  a
    jr   .calc_ix
    ELSE
    ld   a, 1              ; frame statico 1
    ENDIF
    
.calc_ix:
    ; calcola IX = Willy + A * 8
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   e, a
    ld   d, 0
    ld   ix, Willy
    add  ix, de
    call Gfx_DrawPixelSprite8x8
    
    pop  de                ; RIPRISTINA D = Colore, E = Colonna
    
    ; 3. Imposta l'attributo colore per la testa (Row 20, Colonna E)
    ; AttrAddr = $5A80 + E
    ld   h, $5a
    ld   a, $80
    add  a, e
    ld   l, a
    jr   nc, .no_carry1
    inc  h
.no_carry1:
    ld   (hl), d           ; Scrivi colore testa
    
    ; 4. Imposta l'attributo colore per il corpo (Row 21, Colonna E)
    ; AttrAddr = $5AA0 + E
    ld   h, $5a
    ld   a, $A0
    add  a, e
    ld   l, a
    jr   nc, .no_carry2
    inc  h
.no_carry2:
    ld   (hl), d           ; Scrivi colore corpo
    ret

; -------------------------------------------------------------------
; Disegna un tile 8x8 sullo schermo
; Input: B = Row (0..23), C = Col (0..31), IX = Puntatore al Tile (9 byte: 1 attr + 8 bitmap)
; -------------------------------------------------------------------
Gfx_DrawTile:
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
Gfx_DrawRoom:
    push bc
    push de
    push hl
    push ix
    
    call UnpackRoomLayout
    
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
    call Gfx_DrawTile
    
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
; Ottiene l'attributo colore originale dello sfondo per una cella
; Input: H = Row (0..23), B = Col (0..31)
; Output: A = Attributo colore
; -------------------------------------------------------------------
Gfx_GetCellAttribute:
    push hl
    push de
    push bc

    push de
    push bc
    ld   c, h              ; C = Row
    call CheckActiveItemAtCell
    jr   nc, .no_item_attr
    
    pop  bc
    pop  de
    pop  bc
    pop  de
    pop  hl
    ret

.no_item_attr:
    pop  bc
    pop  de

    ; 1. Controlla se Row (H) è fuori dal layout (H < 0 o H >= 16)
    ld   a, h
    cp   0
    jr   c, .blank
    cp   16
    jr   nc, .blank

    ; 2. Calcola riga di layout: r = H
    ; 3. HL = r * 8
    ld   l, a
    ld   h, 0
    add  hl, hl
    add  hl, hl
    add  hl, hl            ; HL = r * 8

    ; 4. HL = r * 8 + c / 4
    ld   a, b              ; A = Col
    srl  a
    srl  a                 ; A = c / 4
    add  a, l
    ld   l, a              ; HL = r * 8 + c / 4

    ld   de, (room_ptr)
    add  hl, de            ; HL = layout byte address
    ld   a, (hl)           ; A = layout byte

    ; Estrai il bit-pair corrispondente a c % 4
    ld   c, a              ; C = layout byte
    ld   a, b              ; A = Col
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

    ; Ottieni l'offset del tile corrispondente e leggi l'attributo (il primo byte del tile)
    or   a
    jr   nz, .not_bg
    ld   hl, OFFSET_BG
    jr   .load_attr
.not_bg:
    dec  a
    jr   nz, .not_floor
    ld   hl, OFFSET_FLOOR
    jr   .load_attr
.not_floor:
    dec  a
    jr   nz, .not_wall
    ld   hl, OFFSET_WALL
    jr   .load_attr
.not_wall:
    ld   hl, OFFSET_NASTY

.load_attr:
    ld   de, (room_ptr)
    add  hl, de            ; HL = tile pointer
    ld   a, (hl)           ; A = primo byte del tile (l'attributo colore)
    
    pop  bc
    pop  de
    pop  hl
    ret

.blank:
    ld   a, $07            ; Sfondo di default (bianco su nero)
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Imposta gli attributi colore per la cella occupata da un nemico 16x16
; Input: C = X pixel, B = Y pixel, A = Colore Gfx_Ink (0..7)
; -------------------------------------------------------------------
Gfx_SetEnemyColorAttributes:
    push hl
    push de
    push bc
    
    ld   d, a              ; D = Colore Gfx_Ink (salvato)
    
    ; Se Y è fuori dai limiti della griglia di gioco, non fare nulla
    ld   a, b
    cp   128
    jr   nc, .done
    
    ; Calcola ColStart: col = X / 8
    ld   a, c
    srl  a
    srl  a
    srl  a
    ld   e, a              ; E = ColStart
    
    ; Calcola ColEnd: col_end = (X + 15) / 8
    ld   a, c
    add  a, 15
    srl  a
    srl  a
    srl  a
    ld   c, a              ; C = ColEnd
    
    ; Calcola RowStart: row = Y / 8
    ld   a, b
    srl  a
    srl  a
    srl  a
    ld   h, a              ; H = RowStart
    
    ; Calcola RowEnd: row_end = (Y + 15) / 8
    ld   a, b
    add  a, 15
    srl  a
    srl  a
    srl  a
    ld   l, a              ; L = RowEnd
    
    ; Loop righe: Row corrente in H, fino a L
.row_loop:
    ld   a, h
    cp   l
    jr   z, .ok_row
    jr   nc, .done
.ok_row:
    push bc
    push de
    
    ; Col loop from E (ColStart) to C (ColEnd)
    ld   b, e              ; B = Col corrente
.col_loop:
    ld   a, b
    cp   c
    jr   z, .ok_col
    jr   nc, .col_done
.ok_col:
    ; Processa la cella a H (Row), B (Col)
    push hl
    ld   l, h
    ld   h, 0
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl            ; HL = Row * 32
    
    ld   a, b              ; A = Col corrente
    add  a, l
    ld   l, a
    jr   nc, .no_c_s
    inc  h
.no_c_s:
    ld   a, h
    add  a, $58
    ld   h, a              ; HL = Attribute screen address ($5800 + Row * 32 + Col)
    
    ld   a, (hl)
    and  $f8
    or   d                 ; D has the enemy color
    ld   (hl), a
    pop  hl
    
    inc  b                 ; Prossima colonna
    jr   .col_loop
    
.col_done:
    pop  de
    pop  bc
    inc  h                 ; Prossima riga
    jr   .row_loop
    
.done:
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Ripristina gli attributi colore originali dello sfondo per la cella occupata da un nemico
; Input: C = X pixel, B = Y pixel
; -------------------------------------------------------------------
Gfx_RestoreEnemyColorAttributes:
    push hl
    push de
    push bc
    
    ; Se Y è fuori dai limiti della griglia di gioco, non fare nulla
    ld   a, b
    cp   128
    jr   nc, .done
    
    ; Calcola ColStart: col = X / 8
    ld   a, c
    srl  a
    srl  a
    srl  a
    ld   e, a              ; E = ColStart
    
    ; Calcola ColEnd: col_end = (X + 15) / 8
    ld   a, c
    add  a, 15
    srl  a
    srl  a
    srl  a
    ld   c, a              ; C = ColEnd
    
    ; Calcola RowStart: row = Y / 8
    ld   a, b
    srl  a
    srl  a
    srl  a
    ld   h, a              ; H = RowStart
    
    ; Calcola RowEnd: row_end = (Y + 15) / 8
    ld   a, b
    add  a, 15
    srl  a
    srl  a
    srl  a
    ld   l, a              ; L = RowEnd
    
    ; Loop righe: Row corrente in H, fino a L
.row_loop:
    ld   a, h
    cp   l
    jr   z, .ok_row
    jr   nc, .done
.ok_row:
    push bc
    push de
    
    ; Col loop from E (ColStart) to C (ColEnd)
    ld   b, e              ; B = Col corrente
.col_loop:
    ld   a, b
    cp   c
    jr   z, .ok_col
    jr   nc, .col_done
.ok_col:
    ; Ottieni attributo originale dello sfondo per cella H (Row), B (Col)
    call Gfx_GetCellAttribute  ; A = attributo originale
    ld   d, a              ; D = attributo originale
    
    push hl                ; Salva Row pointer
    ld   l, h
    ld   h, 0
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl            ; HL = Row * 32
    
    ld   a, b              ; A = Col corrente
    add  a, l
    ld   l, a
    jr   nc, .no_c_r
    inc  h
.no_c_r:
    ld   a, h
    add  a, $58
    ld   h, a              ; HL = Attribute screen address ($5800 + Row * 32 + Col)
    
    ld   (hl), d           ; Ripristina l'attributo colore dello sfondo
    pop  hl                ; Ripristina Row pointer
    
    inc  b                 ; Prossima colonna
    jr   .col_loop
    
.col_done:
    pop  de
    pop  bc
    inc  h                 ; Prossima riga
    jr   .row_loop
    
.done:
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Disegna rampa e conveyor leggendo i dati della stanza corrente
; -------------------------------------------------------------------
Gfx_DrawConveyorsAndRamps:
    push hl
    push de
    push bc
    push ix
    
    ; --- 1. Disegna Conveyor ---
    ld   hl, (room_ptr)
    ld   de, OFFSET_CONVEYOR_DATA
    add  hl, de            ; HL = ConveyorData pointer
    
    ld   a, (hl)           ; A = Direction
    ld   (conveyor_dir), a
    inc  hl
    ld   e, (hl)
    inc  hl
    ld   d, (hl)           ; DE = Location
    inc  hl
    ld   a, (hl)           ; A = Length
    ld   (conveyor_len), a
    
    ; Controlla se DE (Location) è 0
    ld   a, d
    or   e
    jr   z, .draw_ramp     ; Se 0, salta conveyor
    
    ; Calcola Row e Col: Offset = DE - 24064
    push hl
    ld   hl, -24064
    add  hl, de            ; HL = Offset
    
    ld   d, h
    ld   e, l              ; DE = Offset
    
    ; Col = Offset & 31
    ld   a, e
    and  31
    ld   c, a              ; C = Col Start
    
    ; Row = Offset / 32
    srl  h
    rr   l
    srl  h
    rr   l
    srl  h
    rr   l
    srl  h
    rr   l
    srl  h
    rr   l
    ld   a, l
    ld   b, a              ; B = Row
    pop  hl                ; HL = original pointer (Length)
    
    ld   a, b
    ld   (conveyor_row), a
    ld   a, c
    ld   (conveyor_col), a
    
    ld   a, (conveyor_len) ; A = Length
    or   a
    jr   z, .draw_ramp
    ld   d, a              ; D = contatore lunghezza
    
    ; IX = room_ptr + OFFSET_CONVEYOR
    ld   hl, (room_ptr)
    push bc
    ld   bc, OFFSET_CONVEYOR
    add  hl, bc
    pop  bc
    push hl
    pop  ix                ; IX = conveyor tile pointer
    
.conveyor_loop:
    call Gfx_DrawTile
    inc  c                 ; Prossima colonna
    dec  d
    jr   nz, .conveyor_loop

.draw_ramp:
    ; --- 2. Disegna Ramp ---
    ld   hl, (room_ptr)
    ld   de, OFFSET_RAMP_DATA
    add  hl, de            ; HL = RampData pointer
    
    ld   a, (hl)           ; A = Direction (0 = up-left, 1 = up-right)
    ld   (ramp_dir), a
    inc  hl
    ld   e, (hl)
    inc  hl
    ld   d, (hl)           ; DE = Location
    inc  hl
    ld   a, (hl)           ; A = Length
    ld   (ramp_len), a
    
    ; Controlla se DE (Location) è 0
    ld   a, d
    or   e
    jr   z, .done_ramp     ; Se 0, fine
    
    push hl
    ld   hl, -24064
    add  hl, de            ; HL = Offset
    
    ld   d, h
    ld   e, l              ; DE = Offset
    
    ; Col = Offset & 31
    ld   a, e
    and  31
    ld   c, a              ; C = Col Start
    
    ; Row = Offset / 32
    srl  h
    rr   l
    srl  h
    rr   l
    srl  h
    rr   l
    srl  h
    rr   l
    srl  h
    rr   l
    ld   a, l
    ld   b, a              ; B = Row
    pop  hl                ; HL = original pointer (Length)
    
    ld   a, b
    ld   (ramp_row), a
    ld   a, c
    ld   (ramp_col), a
    
    ld   a, (ramp_len)     ; A = Length
    or   a
    jr   z, .done_ramp
    ld   d, a              ; D = contatore lunghezza
    
    ; IX = room_ptr + OFFSET_RAMP
    ld   hl, (room_ptr)
    push bc
    ld   bc, OFFSET_RAMP
    add  hl, bc
    pop  bc
    push hl
    pop  ix                ; IX = ramp tile pointer
    
.ramp_loop:
    call Gfx_DrawTile
    
    ld   a, (ramp_dir)
    or   a
    jr   z, .up_left
.up_right:
    inc  c                 ; Prossima colonna a destra
    jr   .next_step
.up_left:
    dec  c                 ; Prossima colonna a sinistra
.next_step:
    dec  b                 ; Riga sopra (sale)
    dec  d
    jr   nz, .ramp_loop

.done_ramp:
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret

