;===========================================================================
; enemy.asm
;===========================================================================

; -------------------------------------------------------------------
; Struttura dati per i nemici attivi della stanza corrente (RAM)
; 4 slot, 10 byte ciascuno:
; Offset 0: Flags (Active, Vertical, Sprite)
; Offset 1: Current X
; Offset 2: Current Y
; Offset 3: Min Limit
; Offset 4: Max Limit
; Offset 5: Direction
; Offset 6: Anim State
; Offset 7: Old X
; Offset 8: Old Y
; Offset 9: Reserved
; -------------------------------------------------------------------
ActiveEnemies:
    .40 db 0

; -------------------------------------------------------------------
; Carica i nemici della stanza corrente in ActiveEnemies.
; Chiamato quando si entra in una stanza.
; -------------------------------------------------------------------
LoadRoomEnemies:
    push hl
    push de
    push bc
    push ix
    
    ; 1. Imposta IX all'indirizzo dell'array dei colori in ROM (room_ptr + 223)
    ld   hl, (room_ptr)
    ld   de, 223
    add  hl, de
    push hl
    pop  ix                ; IX = color pointer
    
    ; 2. Imposta HL all'indirizzo dei dati dei nemici (room_ptr + 240)
    ld   hl, (room_ptr)
    ld   de, 240           ; Offset degli enemy nella stanza
    add  hl, de            ; HL = indirizzo di RoomXEnemy1
    
    ld   de, ActiveEnemies
    ld   b, 4              ; 4 slot per stanza
.loop:
    ; Leggi il colore per questo nemico dal puntatore IX e salvalo sullo stack
    ld   a, (ix+0)
    inc  ix
    push af                ; Salva colore sullo stack
    
    ; 1. Copia Flags, StartX, StartY
    ld   a, (hl)           ; A = Flags
    ld   (de), a           ; Offset 0
    inc  hl
    inc  de
    
    ld   a, (hl)           ; A = StartX
    ld   (de), a           ; Offset 1
    inc  hl
    inc  de
    
    ld   a, (hl)           ; A = StartY
    ld   (de), a           ; Offset 2
    inc  hl
    inc  de
    
    ; 2. Determina se orizzontale o verticale per calcolare Min e Max Limit
    push hl
    dec  hl
    dec  hl
    dec  hl                ; HL = Flags address
    ld   a, (hl)           ; A = Flags
    and  $40               ; Vertical? (Bit 6)
    jr   nz, .is_vert
    
.is_horiz:
    inc  hl                ; HL = StartX address
    ld   a, (hl)           ; A = StartX
    inc  hl
    inc  hl                ; HL = Limit address
    ld   c, (hl)           ; C = Limit
    
    ; Confronta StartX (A) con Limit (C)
    cp   c
    jr   c, .h_start_smaller
    ; StartX >= Limit
    push af
    ld   a, c
    ld   (de), a           ; Offset 3: Min Limit = Limit
    inc  de
    pop  af
    ld   (de), a           ; Offset 4: Max Limit = StartX
    inc  de
    jr   .done_min_max
    
.h_start_smaller:
    ld   (de), a           ; Offset 3: Min Limit = StartX
    inc  de
    ld   a, c
    ld   (de), a           ; Offset 4: Max Limit = Limit
    inc  de
    jr   .done_min_max
    
.is_vert:
    inc  hl
    inc  hl                ; HL = StartY address
    ld   a, (hl)           ; A = StartY
    inc  hl                ; HL = Limit address
    ld   c, (hl)           ; C = Limit
    
    ; Confronta StartY (A) con Limit (C)
    cp   c
    jr   c, .v_start_smaller
    ; StartY >= Limit
    push af
    ld   a, c
    ld   (de), a           ; Offset 3: Min Limit = Limit
    inc  de
    pop  af
    ld   (de), a           ; Offset 4: Max Limit = StartY
    inc  de
    jr   .done_min_max
    
.v_start_smaller:
    ld   (de), a           ; Offset 3: Min Limit = StartY
    inc  de
    ld   a, c
    ld   (de), a           ; Offset 4: Max Limit = Limit
    inc  de
    
.done_min_max:
    pop  hl                ; HL = Limit address in Room data
    inc  hl                ; HL = inizio del prossimo slot
    
    ; Imposta Direction = 2 (Destra/Giù)
    ld   a, 2
    ld   (de), a           ; Offset 5: Direction
    inc  de
    
    ; Imposta Anim State = 0
    xor  a
    ld   (de), a           ; Offset 6: Anim State
    inc  de
    
    ; Imposta Old X = Start X
    push hl
    dec  hl
    dec  hl
    dec  hl                ; HL = Start X
    ld   a, (hl)
    ld   (de), a           ; Offset 7: Old X
    inc  de
    
    ; Imposta Old Y = Start Y
    inc  hl                ; HL = Start Y
    ld   a, (hl)
    ld   (de), a           ; Offset 8: Old Y
    inc  de
    
    pop  hl
    
    ; Offset 9: Color
    pop  af                ; Ripristina colore dallo stack
    ld   (de), a           ; Offset 9: Color
    inc  de
    
    dec  b
    jp   nz, .loop
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Cancella tutti i nemici attivi ripristinando lo sfondo statico
; -------------------------------------------------------------------
EraseRoomEnemies:
    push hl
    push de
    push bc
    push ix
    
    ld   ix, ActiveEnemies
    ld   b, 4              ; 4 slot
.loop:
    ld   a, (ix+0)         ; Flags
    and  $80               ; Active?
    jr   z, .next
    
    push bc                ; Salva contatore ciclo
    ld   c, (ix+7)         ; C = Old X
    ld   b, (ix+8)         ; B = Old Y
    call ErasePixelSprite16x16
    ld   c, (ix+7)         ; C = Old X
    ld   b, (ix+8)         ; B = Old Y
    call RestoreEnemyColorAttributes
    pop  bc
    
.next:
    ld   de, 10
    add  ix, de            ; Prossimo slot
    dec  b
    jr   nz, .loop
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Disegna tutti i nemici attivi
; -------------------------------------------------------------------
DrawRoomEnemies:
    push hl
    push de
    push bc
    push ix
    
    ld   ix, ActiveEnemies
    ld   b, 4              ; 4 slot
.loop:
    ld   a, (ix+0)         ; Flags
    and  $80               ; Active?
    jp   z, .next
    
    push bc                ; Salva contatore ciclo
    
    ; Determina quale sprite usare basato sul tipo (Bit 1-0)
    ld   a, (ix+0)         ; Flags
    and  3                 ; Tipo (0=Lametta, 1=Uovo, 2=Robot)
    jp   nz, .not_lametta
    
    ; Lametta (Tipo 0)
    ld   hl, (room_ptr)
    ld   de, TheBridgeLayout
    or   a
    sbc  hl, de
    jr   z, .bridge_lametta
    
    ld   hl, (room_ptr)
    ld   de, TheOffLicenceLayout
    or   a
    sbc  hl, de
    jr   z, .offlicence_radar

    ld   hl, (room_ptr)
    ld   de, TheBathroomLayout
    or   a
    sbc  hl, de
    jr   z, .bathroom_doubleball

    ld   a, (ix+5)         ; Direction
    cp   1                 ; Sinistra?
    ld   hl, LamettaSpriteLeft
    jr   z, .got_sprite
    ld   hl, LamettaSpriteRight
    jr   .got_sprite

.bathroom_doubleball:
    ld   a, (ix+5)         ; Direction
    cp   1                 ; Sinistra?
    ld   hl, DoubleBallSpriteLeft
    jr   z, .got_sprite
    ld   hl, DoubleBallSpriteRight
    jr   .got_sprite

.bridge_lametta:
    ld   a, (ix+5)         ; Direction
    cp   1                 ; Sinistra?
    ld   hl, UccelloSpriteLeft
    jr   z, .got_sprite
    ld   hl, UccelloSpriteRight
    jr   .got_sprite

.offlicence_radar:
    ld   hl, RadarSprite
    jr   .got_sprite
    
.not_lametta:
    dec  a
    jp   nz, .not_egg
    
    ; Uovo (Tipo 1)
    ld   hl, (room_ptr)
    ld   de, TheBridgeLayout
    or   a
    sbc  hl, de
    jr   z, .bridge_egg
    
    ld   hl, (room_ptr)
    ld   de, TheOffLicenceLayout
    or   a
    sbc  hl, de
    jr   z, .offlicence_face

    ld   a, (ix+5)         ; Direction
    cp   1                 ; Sinistra?
    ld   hl, EggSpriteLeft
    jr   z, .got_sprite
    ld   hl, EggSpriteRight
    jr   .got_sprite

.bridge_egg:
    ld   hl, UfoSprite
    jr   .got_sprite

.offlicence_face:
    ld   hl, FaceSprite
    jr   .got_sprite
    
.not_egg:
    ; Robot (Tipo 2)
    ld   hl, (room_ptr)
    ld   de, TheOffLicenceLayout
    or   a
    sbc  hl, de
    jr   z, .offlicence_ball

    ld   hl, RobotSprite
    jr   .got_sprite

.offlicence_ball:
    ld   hl, BallSprite
    
.got_sprite:
    ; Calcola il frame dell'animazione: Anim State * 32
    ld   a, (ix+6)         ; Anim State (0..3)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, a              ; *16
    add  a, a              ; *32
    ld   e, a
    ld   d, 0              ; DE = offset del frame
    add  hl, de            ; HL = indirizzo del frame corretto
    
    ; Disegna alla coordinata corrente
    ld   c, (ix+1)         ; C = Current X
    ld   b, (ix+2)         ; B = Current Y
    
    push ix                ; Salva slot pointer
    push hl
    pop  ix                ; IX = sprite data pointer
    call DrawPixelSprite16x16
    pop  ix                ; Ripristina slot pointer
    
    ; Applica gli attributi colore per la posizione corrente
    ld   c, (ix+1)         ; C = Current X
    ld   b, (ix+2)         ; B = Current Y
    ld   a, (ix+9)         ; A = Color
    call SetEnemyColorAttributes
    
    pop  bc                ; Ripristina contatore ciclo
    
.next:
    ld   de, 10
    add  ix, de            ; Prossimo slot
    dec  b
    jp   nz, .loop
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Aggiorna le posizioni dei nemici attivi per il prossimo frame
; -------------------------------------------------------------------
UpdateRoomEnemies:
    push hl
    push de
    push bc
    push ix
    
    ld   ix, ActiveEnemies
    ld   b, 4              ; 4 slot
.loop:
    ld   a, (ix+0)         ; Flags
    and  $80               ; Active?
    jp   z, .next
    
    ; 1. Salva la posizione corrente in Old X/Y per la cancellazione nel prossimo frame
    ld   a, (ix+1)
    ld   (ix+7), a         ; Old X = Current X
    ld   a, (ix+2)
    ld   (ix+8), a         ; Old Y = Current Y
    
    ; 2. Aggiorna Anim State
    ld   a, (ix+6)         ; Anim State (0..3)
    inc  a
    and  3                 ; Alterna 0..3
    ld   (ix+6), a
    
    ; 3. Determina se orizzontale o verticale
    ld   a, (ix+0)         ; Flags
    and  $40               ; Vertical? (Bit 6)
    jp   nz, .vertical
    
.horizontal:
    ld   a, (ix+5)         ; Direction (1=Left, 2=Right)
    cp   1
    jr   nz, .horiz_right
    
.horiz_left:
    ld   a, (ix+1)         ; Current X
    sub  2                 ; Muovi a sinistra di 2 pixel
    cp   (ix+3)            ; Min Limit
    jr   z, .h_rev_right
    jr   c, .h_rev_right
    ld   (ix+1), a
    jp   .next
    
.h_rev_right:
    ld   a, (ix+3)         ; Min Limit
    ld   (ix+1), a
    ld   a, 2
    ld   (ix+5), a         ; Cambia direzione a Destra
    jp   .next
    
.horiz_right:
    ld   a, (ix+1)         ; Current X
    add  a, 2              ; Muovi a destra di 2 pixel
    cp   (ix+4)            ; Max Limit
    jr   z, .h_rev_left
    jr   nc, .h_rev_left
    ld   (ix+1), a
    jp   .next
    
.h_rev_left:
    ld   a, (ix+4)         ; Max Limit
    ld   (ix+1), a
    ld   a, 1
    ld   (ix+5), a         ; Cambia direzione a Sinistra
    jp   .next

.vertical:
    ld   a, (ix+5)         ; Direction (1=Up, 2=Down)
    cp   1
    jr   nz, .vert_down
    
.vert_up:
    ld   a, (ix+2)         ; Current Y
    sub  2                 ; Muovi in alto di 2 pixel
    cp   (ix+3)            ; Min Limit (Top)
    jr   z, .v_rev_down
    jr   c, .v_rev_down
    ld   (ix+2), a
    jp   .next
    
.v_rev_down:
    ld   a, (ix+3)         ; Min Limit
    ld   (ix+2), a
    ld   a, 2
    ld   (ix+5), a         ; Cambia direzione in Basso
    jp   .next
    
.vert_down:
    ld   a, (ix+2)         ; Current Y
    add  a, 2              ; Muovi in basso di 2 pixel
    cp   (ix+4)            ; Max Limit (Bottom)
    jr   z, .v_rev_up
    jr   nc, .v_rev_up
    ld   (ix+2), a
    jp   .next
    
.v_rev_up:
    ld   a, (ix+4)         ; Max Limit
    ld   (ix+2), a
    ld   a, 1
    ld   (ix+5), a         ; Cambia direzione in Alto
    
.next:
    ld   de, 10
    add  ix, de            ; Prossimo slot (10 byte)
    dec  b
    jp   nz, .loop
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret
