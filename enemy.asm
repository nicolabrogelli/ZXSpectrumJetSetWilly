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
    .80 db 0

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
    ld   b, 8              ; 8 slot per stanza
.loop:
    ld   a, b
    cp   4
    jr   nz, .no_color_reset
    
    push hl
    ld   hl, (room_ptr)
    ld   de, 223
    add  hl, de
    push hl
    pop  ix                ; Reset color pointer to support mirroring for slots 5-8
    pop  hl
.no_color_reset:

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
    
    push hl                ; Salva HL
    push iy                ; Salva IY
    
    push de
    pop  iy                ; IY = puntatore a Offset 5 (Direction) in RAM
    
    ; Leggi Flags (Offset 0) per determinare la Fase (Bit 5 e 4)
    ld   a, (iy-5)         ; A = Flags
    
    ; Estrai Bit 5-4: (Flags >> 4) & 3
    rrca
    rrca
    rrca
    rrca
    and  3                 ; A = Phase (0..3)
    
    cp   0
    jr   z, .phase_0
    cp   1
    jr   z, .phase_1
    cp   2
    jr   z, .phase_2
    
.phase_3:
    ; Phase 3: Pos = Max Limit, Dir = 1
    ld   a, (iy-5)         ; A = Flags
    and  $40
    jr   nz, .p3_vert
.p3_horiz:
    ld   a, (iy-1)
    ld   (iy-4), a         ; Current X = Max Limit
    jr   .set_dir_1
.p3_vert:
    ld   a, (iy-1)
    ld   (iy-3), a         ; Current Y = Max Limit
    jr   .set_dir_1

.phase_0:
    ; Phase 0: Tieni la posizione iniziale impostata da ROM, Dir = 2
    jr   .set_dir_2

.phase_1:
    ; Phase 1: Pos = Min Limit + Delta / 4, Dir = 2
    ld   a, (iy-1)         ; A = Max Limit
    sub  (iy-2)            ; A = Delta
    srl  a
    srl  a                 ; A = Delta / 4
    add  a, (iy-2)         ; A = Min Limit + Delta / 4
    ld   c, a              ; C = target pos
    
    ld   a, (iy-5)         ; A = Flags
    and  $40
    jr   nz, .p1_vert
.p1_horiz:
    ld   (iy-4), c         ; Current X = target pos
    jr   .set_dir_2
.p1_vert:
    ld   (iy-3), c         ; Current Y = target pos
    jr   .set_dir_2

.phase_2:
    ; Phase 2: Pos = Min Limit + Delta / 2, Dir = 1
    ld   a, (iy-1)         ; A = Max Limit
    sub  (iy-2)            ; A = Delta
    srl  a                 ; A = Delta / 2
    add  a, (iy-2)         ; A = Min Limit + Delta / 2
    ld   c, a              ; C = target pos
    
    ld   a, (iy-5)         ; A = Flags
    and  $40
    jr   nz, .p2_vert
.p2_horiz:
    ld   (iy-4), c         ; Current X = target pos
    jr   .set_dir_1
.p2_vert:
    ld   (iy-3), c         ; Current Y = target pos
    jr   .set_dir_1

.set_dir_1:
    ld   a, 1
    jr   .store_dir
.set_dir_2:
    ld   a, 2
.store_dir:
    ld   (de), a           ; Offset 5: Direction
    inc  de
    
    pop  iy                ; Ripristina IY
    pop  hl                ; Ripristina HL
    
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
    ld   b, 8              ; 8 slot
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
    ld   b, 8              ; 8 slot
.loop:
    ld   a, (ix+0)         ; Flags
    and  $80               ; Active?
    jp   z, .next
    
    push bc                ; Salva contatore ciclo
    
    ; Determina quale sprite usare basato sul tipo (Bit 3-0)
    ld   a, (ix+0)         ; Flags
    and  $0F               ; Tipo (0=Lametta, 1=Sega, 2=Uccello, 3=Radar, 4=Uovo, 5=Ufo, 6=Faccia, 7=Scimmia, 8=Robot, 9=Palla, 10=DoubleBall)
    
    cp   0
    jr   z, .got_lametta
    cp   1
    jr   z, .got_sega
    cp   2
    jr   z, .got_uccello
    cp   3
    jr   z, .got_radar
    cp   4
    jr   z, .got_uovo
    cp   5
    jr   z, .got_ufo
    cp   6
    jr   z, .got_faccia
    cp   7
    jr   z, .got_scimmia
    cp   8
    jr   z, .got_robot
    cp   9
    jr   z, .got_palla
    cp   10
    jr   z, .got_doubleball
    cp   11
    jr   z, .got_soldato

    ; Fallback in caso di tipo sconosciuto
    ld   hl, LamettaSpriteLeft
    jp   .got_sprite

.got_lametta:
    ld   a, (ix+5)         ; Direction (1=Left, 2=Right)
    cp   1
    ld   hl, LamettaSpriteLeft
    jp   z, .got_sprite
    ld   hl, LamettaSpriteRight
    jp   .got_sprite

.got_sega:
    ld   a, (ix+5)         ; Direction
    cp   1
    ld   hl, SegaSprite
    jp   z, .got_sprite
    ld   hl, SegaSprite + 128
    jp   .got_sprite

.got_uccello:
    ld   a, (ix+5)         ; Direction
    cp   1
    ld   hl, UccelloSpriteLeft
    jp   z, .got_sprite
    ld   hl, UccelloSpriteRight
    jp   .got_sprite

.got_radar:
    ld   hl, RadarSprite
    jp   .got_sprite

.got_uovo:
    ld   a, (ix+5)         ; Direction
    cp   1
    ld   hl, EggSpriteLeft
    jp   z, .got_sprite
    ld   hl, EggSpriteRight
    jp   .got_sprite

.got_ufo:
    ld   hl, UfoSprite
    jp   .got_sprite

.got_faccia:
    ld   hl, FaceSprite
    jp   .got_sprite

.got_scimmia:
    ld   hl, ScimmiaSprite
    jp   .got_sprite

.got_robot:
    ld   hl, RobotSprite
    jp   .got_sprite

.got_palla:
    ld   hl, BallSprite
    jp   .got_sprite

.got_doubleball:
    ld   a, (ix+5)         ; Direction
    cp   1
    ld   hl, DoubleBallSpriteLeft
    jp   z, .got_sprite
    ld   hl, DoubleBallSpriteRight

.got_soldato
    ld   hl, SoldatoSprite
    jp   .got_sprite


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
    
    ; Controlla il tasso di aggiornamento dei nemici (speed divider)
    ld   a, (enemy_update_rate)
    cp   1
    jr   z, .do_update             ; Se 1, aggiorna ad ogni frame (velocità normale)
    
    ld   a, (enemy_update_timer)
    inc  a
    ld   b, a                      ; B = timer + 1
    ld   a, (enemy_update_rate)
    cp   b
    jr   z, .reset_timer
    jr   c, .reset_timer
    
    ; Salva contatore incrementato e salta l'aggiornamento
    ld   a, b
    ld   (enemy_update_timer), a
    
.skip_update:
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret

.reset_timer:
    xor  a
    ld   (enemy_update_timer), a
    jr   .do_update
    
.do_update:
    ld   ix, ActiveEnemies
    ld   b, 8              ; 8 slot
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
