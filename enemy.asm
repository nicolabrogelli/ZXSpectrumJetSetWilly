;===========================================================================
; enemy.asm
;===========================================================================

; -------------------------------------------------------------------
; Struttura dati per i nemici attivi della stanza corrente (RAM)
; 8 slot, 11 byte ciascuno:
; Offset 0: Flags (Active, Vertical, Phase)
; Offset 1: Sprite Type (0..31)
; Offset 2: Current X
; Offset 3: Current Y
; Offset 4: Min Limit
; Offset 5: Max Limit
; Offset 6: Direction
; Offset 7: Anim State
; Offset 8: Old X
; Offset 9: Old Y
; Offset 10: Color
; -------------------------------------------------------------------
ActiveEnemies:
    .88 db 0

; -------------------------------------------------------------------
; Carica i nemici della stanza corrente in ActiveEnemies.
; Chiamato quando si entra in una stanza.
; -------------------------------------------------------------------
Enemy_LoadRoom:
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
    push de
    ld   hl, (room_ptr)
    ld   de, OFFSET_COLORS_5_8
    add  hl, de
    push hl
    pop  ix                ; Reset color pointer to ROM offset for enemies 5-8
    pop  de
    pop  hl
.no_color_reset:

    ; Leggi il colore per questo nemico dal puntatore IX e salvalo sullo stack
    ld   a, (ix+0)
    inc  ix
    push af                ; Salva colore sullo stack
    
    ; 1. Copia Flags (Byte 0), Type (Byte 1), StartX (Byte 2), StartY (Byte 3)
    ld   a, (hl)           ; A = Flags
    ld   (de), a           ; Offset 0
    inc  hl
    inc  de
    
    ld   a, (hl)           ; A = Type
    ld   (de), a           ; Offset 1
    inc  hl
    inc  de
    
    ld   a, (hl)           ; A = StartX
    ld   (de), a           ; Offset 2: Current X
    inc  hl
    inc  de
    
    ld   a, (hl)           ; A = StartY
    ld   (de), a           ; Offset 3: Current Y
    inc  hl
    inc  de
    
    ; 2. Determina se orizzontale o verticale per calcolare Min e Max Limit (ROM Byte 4: Limit)
    push hl
    push de
    pop  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl                ; HL points to RAM Offset 0 (Flags)
    ld   a, (hl)           ; A = Flags
    pop  hl                ; Restore HL (points to ROM Byte 4: Limit)
    and  $40               ; Vertical? (Bit 6)
    jr   nz, .is_vert
    
.is_horiz:
    push hl
    push de
    pop  hl
    dec  hl
    dec  hl                ; HL points to RAM Offset 2 (Current X / StartX)
    ld   a, (hl)           ; A = StartX
    pop  hl                ; HL points to ROM Byte 4 (Limit)
    ld   c, (hl)           ; C = Limit (from ROM)
    
    ; Confronta StartX (A) con Limit (C)
    cp   c
    jr   c, .h_start_smaller
    ; StartX >= Limit
    push af                ; Save StartX
    ld   a, c              ; A = Limit
    ld   (de), a           ; Offset 4: Min Limit = Limit
    inc  de
    pop  af                ; Restore StartX
    ld   (de), a           ; Offset 5: Max Limit = StartX
    inc  de
    jr   .done_min_max
    
.h_start_smaller:
    ld   (de), a           ; Offset 4: Min Limit = StartX
    inc  de
    ld   a, c
    ld   (de), a           ; Offset 5: Max Limit = Limit
    inc  de
    jr   .done_min_max
    
.is_vert:
    push hl
    push de
    pop  hl
    dec  hl                ; HL points to RAM Offset 3 (Current Y / StartY)
    ld   a, (hl)           ; A = StartY
    pop  hl                ; HL points to ROM Byte 4 (Limit)
    ld   c, (hl)           ; C = Limit
    
    ; Confronta StartY (A) con Limit (C)
    cp   c
    jr   c, .v_start_smaller
    ; StartY >= Limit
    push af                ; Save StartY
    ld   a, c              ; A = Limit
    ld   (de), a           ; Offset 4: Min Limit = Limit
    inc  de
    pop  af                ; Restore StartY
    ld   (de), a           ; Offset 5: Max Limit = StartY
    inc  de
    jr   .done_min_max
    
.v_start_smaller:
    ld   (de), a           ; Offset 4: Min Limit = StartY
    inc  de
    ld   a, c
    ld   (de), a           ; Offset 5: Max Limit = Limit
    inc  de
    
.done_min_max:
    inc  hl                ; HL = inizio del prossimo slot in ROM
    
    push hl                ; Salva HL
    push iy                ; Salva IY
    
    push de
    pop  iy                ; IY = puntatore a Offset 6 (Direction) in RAM
    
    ; Leggi Flags (Offset 0) per determinare la Fase (Bit 5 e 4)
    ld   a, (iy-6)         ; A = Flags (Offset 0)
    
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
    ld   a, (iy-6)         ; A = Flags
    and  $40
    jr   nz, .p3_vert
.p3_horiz:
    ld   a, (iy-1)         ; Max Limit
    ld   (iy-4), a         ; Current X = Max Limit
    jr   .set_dir_1
.p3_vert:
    ld   a, (iy-1)         ; Max Limit
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
    
    ld   a, (iy-6)         ; A = Flags
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
    
    ld   a, (iy-6)         ; A = Flags
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
    ld   (de), a           ; Offset 6: Direction
    inc  de
    
    pop  iy                ; Ripristina IY
    pop  hl                ; Ripristina HL
    
    ; Imposta Anim State = 0
    xor  a
    ld   (de), a           ; Offset 7: Anim State
    inc  de
    
    ; Imposta Old X = Current X
    push hl
    push de
    pop  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl                ; HL points to RAM Offset 2 (Current X)
    ld   a, (hl)
    pop  hl
    ld   (de), a           ; Offset 8: Old X
    inc  de
    
    ; Imposta Old Y = Current Y
    push hl
    push de
    pop  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl                ; HL points to RAM Offset 3 (Current Y)
    ld   a, (hl)
    pop  hl
    ld   (de), a           ; Offset 9: Old Y
    inc  de

    
    ; Offset 10: Color
    pop  af                ; Ripristina colore dallo stack
    ld   (de), a           ; Offset 10: Color
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
Enemy_EraseRoom:
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
    ld   c, (ix+8)         ; C = Old X (Offset 8)
    ld   b, (ix+9)         ; B = Old Y (Offset 9)
    call Gfx_ErasePixelSprite16x16
    ld   c, (ix+8)         ; C = Old X
    ld   b, (ix+9)         ; B = Old Y
    call Gfx_RestoreEnemyColorAttributes
    pop  bc
    
.next:
    ld   de, 11
    add  ix, de            ; Prossimo slot (11 byte)
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
Enemy_DrawRoom:
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
    
    ; Determina quale sprite usare basato sul tipo (Offset 1, Bit 5-0)
    ld   a, (ix+1)         ; Tipo
    and  $3F               ; Tipo (0=Lametta, 1=Sega, 2=Uccello, 3=Radar, 4=Uovo, 5=Ufo, 6=Faccia, 7=Scimmia, 8=Robot, 9=Palla, 10=DoubleBall, 11=Soldato, 12=Maiale, 13=Canguro, 14=Fiore, 15=FacciaPalla, 16=Candelabro, 17=Freccia, 18=Tronchese, 19=Periscopio, 20=Nonnino, 21=Parrucca, 22=Frate, 23..26=FaceHell, 27=PinzaGiaccio, 28=Ruota, 29=Saliera, 30=Gelato, 31=Pinguino, 32=Muro, 33=Diavoletto, 34=Vecchia, 35=Piede)
    
    cp   0
    jp   z, .got_lametta
    cp   1
    jp   z, .got_sega
    cp   2
    jp   z, .got_uccello
    cp   3
    jp   z, .got_radar
    cp   4
    jp   z, .got_uovo
    cp   5
    jp   z, .got_ufo
    cp   6
    jp   z, .got_faccia
    cp   7
    jp   z, .got_scimmia
    cp   8
    jp   z, .got_robot
    cp   9
    jp   z, .got_palla
    cp   10
    jp   z, .got_doubleball
    cp   11
    jp   z, .got_soldato
    cp   12
    jp   z, .got_maiale
    cp   13
    jp   z, .got_canguro
    cp   14
    jp   z, .got_fiore
    cp   15
    jp   z, .got_facciapalla
    cp   16
    jp   z, .got_candelabro
    cp   17
    jp   z, .got_freccia
    cp   18
    jp   z, .got_tronchese
    cp   19
    jp   z, .got_periscopio
    cp   20
    jp   z, .got_nonnino
    cp   21
    jp   z, .got_parrucca
    cp   22
    jp   z, .got_frate
    cp   23
    jp   z, .got_facehell_hl
    cp   24
    jp   z, .got_facehell_hr
    cp   25
    jp   z, .got_facehell_ll
    cp   26
    jp   z, .got_facehell_lr
    cp   27
    jp   z, .got_pinzagiaccio
    cp   28
    jp   z, .got_ruota
    cp   29
    jp   z, .got_saliera
    cp   30
    jp   z, .got_gelato
    cp   31
    jp   z, .got_pinguino
    cp   32
    jp   z, .got_muro
    cp   33
    jp   z, .got_diavoletto
    cp   34
    jp   z, .got_vecchia
    cp   35
    jp   z, .got_piede

    ; Fallback in caso di tipo sconosciuto
    ld   hl, LamettaSpriteLeft
    jp   .got_sprite

.got_lametta:
    ld   a, (ix+6)         ; Direction (1=Left, 2=Right) (Offset 6)
    cp   1
    ld   hl, LamettaSpriteLeft
    jp   z, .got_sprite
    ld   hl, LamettaSpriteRight
    jp   .got_sprite

.got_sega:
    ld   a, (ix+6)         ; Direction
    cp   1
    ld   hl, SegaSprite
    jp   z, .got_sprite
    ld   hl, SegaSprite + 128
    jp   .got_sprite

.got_uccello:
    ld   a, (ix+6)         ; Direction
    cp   1
    ld   hl, UccelloSpriteLeft
    jp   z, .got_sprite
    ld   hl, UccelloSpriteRight
    jp   .got_sprite

.got_radar:
    ld   hl, RadarSprite
    jp   .got_sprite

.got_uovo:
    ld   a, (ix+6)         ; Direction
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
    ld   a, (ix+6)         ; Direction
    cp   1
    ld   hl, DoubleBallSpriteLeft
    jp   z, .got_sprite
    ld   hl, DoubleBallSpriteRight
    jp   .got_sprite

.got_soldato:
    ld   hl, SoldatoSprite
    jp   .got_sprite

.got_maiale:
    ld   a, (ix+6)         ; Direction
    cp   1
    ld   hl, MaialeSpriteLeft
    jp   z, .got_sprite
    ld   hl, MaialeSpriteRight
    jp   .got_sprite

.got_canguro:
    ld   a, (ix+6)         ; Direction
    cp   1
    ld   hl, CanguroSpriteLeft
    jp   z, .got_sprite
    ld   hl, CanguroSpriteRight
    jp   .got_sprite

.got_fiore:
    ld   hl, FioreSprite
    jp   .got_sprite

.got_facciapalla:
    ld   hl, FacciaPallaSprite
    jp   .got_sprite

.got_candelabro:
    ld   hl, CandelabroSprite
    jp   .got_sprite

.got_freccia:
    ld   a, (ix+6)         ; Direction (1=Left, 2=Right)
    cp   1
    ld   hl, FrecciaSpriteLeft
    jp   z, .got_sprite
    ld   hl, FrecciaSpriteRight
    jp   .got_sprite

.got_tronchese:
    ld   hl, TroncheseSprite
    jp   .got_sprite

.got_periscopio:
    ld   a, (ix+6)         ; Direction (1=Left, 2=Right)
    cp   1
    ld   hl, PeriscopioSprite
    jp   z, .got_sprite
    ld   hl, PeriscopioSprite + 128
    jp   .got_sprite

.got_nonnino:
    ld   hl, NonninoSprite
    jp   .got_sprite

.got_parrucca:
    ld   hl, ParruccaSprite
    jp   .got_sprite

.got_frate:
    ld   a, (ix+6)         ; Direction (1=Left, 2=Right)
    cp   1
    ld   hl, FrateSprite
    jp   z, .got_sprite
    ld   hl, FrateSprite + 128
    jp   .got_sprite

.got_pinzagiaccio:
    ld   hl, PinzaGiaccioSprite
    jp   .got_sprite

.got_ruota:
    ld   hl, RuotaSprite
    jp   .got_sprite

.got_saliera:
    ld   hl, SalieraSprite
    jp   .got_sprite

.got_gelato:
    ld   hl, GelatoSprite
    jp   .got_sprite

.got_pinguino:
    ld   a, (ix+6)         ; Direction (1=Left, 2=Right)
    cp   1                 ; Left?
    ld   hl, PinguinoSprite       ; If Left, use the first 4 frames
    jp   z, .got_sprite
    ld   hl, PinguinoSprite + 128 ; If Right, use the other 4 frames
    jp   .got_sprite

.got_muro:
    ld   hl, MuroSprite
    jp   .got_sprite

.got_diavoletto:
    ld   hl, DiavolettoSprite
    jp   .got_sprite

.got_vecchia:
    ld   hl, VecchiaSprite
    jp   .got_sprite

.got_piede:
    ld   hl, PiedeSprite
    jp   .got_sprite


.got_sprite:
    ; Calcola il frame dell'animazione: Anim State * 32
    ld   a, (ix+7)         ; Anim State (0..3) (Offset 7)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, a              ; *16
    add  a, a              ; *32
    ld   e, a
    ld   d, 0              ; DE = offset del frame
    add  hl, de            ; HL = indirizzo del frame corretto
    
    ; Disegna alla coordinata corrente
    ld   c, (ix+2)         ; C = Current X (Offset 2)
    ld   b, (ix+3)         ; B = Current Y (Offset 3)
    
    push ix                ; Salva slot pointer
    push hl
    pop  ix                ; IX = sprite data pointer
    call Gfx_DrawPixelSprite16x16
    pop  ix                ; Ripristina slot pointer
    
    ; Applica gli attributi colore per la posizione corrente
    ld   c, (ix+2)         ; C = Current X
    ld   b, (ix+3)         ; B = Current Y
    ld   a, (ix+10)        ; A = Color (Offset 10)
    call Gfx_SetEnemyColorAttributes
    
    pop  bc                ; Ripristina contatore ciclo
    
.next:
    ld   de, 11
    add  ix, de            ; Prossimo slot (11 byte)
    dec  b
    jp   nz, .loop
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret

.got_facehell_hl:
    ld   hl, FaceHellHL
    jr   .got_static_sprite

.got_facehell_hr:
    ld   hl, FaceHellHR
    jr   .got_static_sprite

.got_facehell_ll:
    ld   hl, FaceHellLL
    jr   .got_static_sprite

.got_facehell_lr:
    ld   hl, FaceHellLR
    jr   .got_static_sprite

.got_static_sprite:
    ; Disegna alla coordinata corrente senza aggiungere l'animazione
    ld   c, (ix+2)         ; C = Current X (Offset 2)
    ld   b, (ix+3)         ; B = Current Y (Offset 3)
    
    push ix                ; Salva slot pointer
    push hl
    pop  ix                ; IX = sprite data pointer
    call Gfx_DrawPixelSprite16x16
    pop  ix                ; Ripristina slot pointer
    
    ; Applica gli attributi colore per la posizione corrente
    ld   c, (ix+2)         ; C = Current X
    ld   b, (ix+3)         ; B = Current Y
    ld   a, (ix+10)        ; A = Color (Offset 10)
    call Gfx_SetEnemyColorAttributes
    
    pop  bc                ; Ripristina contatore ciclo
    jp   .next

; -------------------------------------------------------------------
; Aggiorna le posizioni dei nemici attivi per il prossimo frame
; -------------------------------------------------------------------
Enemy_Update:
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
    ld   a, (ix+2)         ; Current X (Offset 2)
    ld   (ix+8), a         ; Old X = Current X (Offset 8)
    ld   a, (ix+3)         ; Current Y (Offset 3)
    ld   (ix+9), a         ; Old Y = Current Y (Offset 9)
    
    ; 2. Aggiorna Anim State
    ld   a, (ix+1)         ; Sprite Type (Offset 1)
    and  $3F               ; Tipo
    cp   13                ; Tipo 13 = Canguro?
    jr   z, .canguro_anim
    cp   11                ; Tipo 11 = Soldato?
    jr   z, .soldato_anim
    cp   16                ; Tipo 16 = Candelabro?
    jr   z, .soldato_anim
    cp   20                ; Tipo 20 = Nonnino?
    jr   z, .soldato_anim
    cp   21                ; Tipo 21 = Parrucca?
    jr   z, .soldato_anim
    cp   29                ; Tipo 29 = Saliera?
    jr   z, .soldato_anim
    
    ld   a, (ix+7)         ; Anim State (Offset 7)
    inc  a
    and  3                 ; Alterna 0..3
    ld   (ix+7), a
    jr   .anim_done

.soldato_anim:
    ld   a, (ix+7)         ; Anim State
    inc  a
    and  1                 ; Alterna 0..1
    ld   (ix+7), a
    jr   .anim_done

.canguro_anim:
    ld   a, (ix+7)         ; Anim State
    inc  a
    and  7                 ; Alterna 0..7
    ld   (ix+7), a

.anim_done:
    
    ; 3. Determina se orizzontale o verticale
    ld   a, (ix+0)         ; Flags
    and  $40               ; Vertical? (Bit 6)
    jp   nz, .vertical
    
.horizontal:
    ld   a, (ix+6)         ; Direction (1=Left, 2=Right) (Offset 6)
    cp   1
    jr   nz, .horiz_right
    
.horiz_left:
    ld   a, (ix+2)         ; Current X
    sub  2                 ; Muovi a sinistra di 2 pixel
    cp   (ix+4)            ; Min Limit (Offset 4)
    jr   z, .h_rev_right
    jr   c, .h_rev_right
    ld   (ix+2), a
    jp   .next
    
.h_rev_right:
    ld   a, (ix+4)         ; Min Limit
    ld   (ix+2), a
    ld   a, 2
    ld   (ix+6), a         ; Cambia direzione a Destra (Offset 6)
    jp   .next
    
.horiz_right:
    ld   a, (ix+2)         ; Current X
    add  a, 2              ; Muovi a destra di 2 pixel
    cp   (ix+5)            ; Max Limit (Offset 5)
    jr   z, .h_rev_left
    jr   nc, .h_rev_left
    ld   (ix+2), a
    jp   .next
    
.h_rev_left:
    ld   a, (ix+5)         ; Max Limit
    ld   (ix+2), a
    ld   a, 1
    ld   (ix+6), a         ; Cambia direzione a Sinistra
    jp   .next

.vertical:
    ld   a, (ix+6)         ; Direction (1=Up, 2=Down)
    cp   1
    jr   nz, .vert_down
    
.vert_up:
    ld   a, (ix+3)         ; Current Y
    sub  2                 ; Muovi in alto di 2 pixel
    cp   (ix+4)            ; Min Limit (Top)
    jr   z, .v_rev_down
    jr   c, .v_rev_down
    ld   (ix+3), a
    jp   .next
    
.v_rev_down:
    ld   a, (ix+4)         ; Min Limit
    ld   (ix+3), a
    ld   a, 2
    ld   (ix+6), a         ; Cambia direzione in Basso
    jp   .next
    
.vert_down:
    ld   a, (ix+3)         ; Current Y
    add  a, 2              ; Muovi in basso di 2 pixel
    cp   (ix+5)            ; Max Limit (Bottom)
    jr   z, .v_rev_up
    jr   nc, .v_rev_up
    ld   (ix+3), a
    jp   .next
    
.v_rev_up:
    ld   a, (ix+5)         ; Max Limit
    ld   (ix+3), a
    ld   a, 1
    ld   (ix+6), a         ; Cambia direzione in Alto
    
.next:
    ld   de, 11
    add  ix, de            ; Prossimo slot (11 byte)
    dec  b
    jp   nz, .loop
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret

; ===================================================================
; GESTIONE DELLA CORDA OSCILLANTE (Stanza 16 - WeMustPerformQuirkafleeg)
; ===================================================================

Rope_Update:
    ; 1. Leggi direzione (bit 7 di rope_dir_flags)
    ld   a, (rope_dir_flags)
    and  $80
    jr   nz, .swing_left   ; Se bit 7 è 1, decrementa frame
    
.swing_right:
    ld   a, (rope_frame_idx)        ; F (0..33)
    inc  a
    cp   34
    jr   nz, .save_right
    ; Se F raggiunge 34, inverti direzione (imposta bit 7 a 1) e imposta F = 32
    ld   a, (rope_dir_flags)
    or   $80
    ld   (rope_dir_flags), a
    ld   a, 32
.save_right:
    ld   (rope_frame_idx), a
    ret
    
.swing_left:
    ld   a, (rope_frame_idx)
    dec  a
    cp   $FF
    jr   nz, .save_left
    ; Se F raggiunge -1, inverti direzione (imposta bit 7 a 0) e imposta F = 1
    ld   a, (rope_dir_flags)
    and  $7F
    ld   (rope_dir_flags), a
    ld   a, 1
.save_left:
    ld   (rope_frame_idx), a
    ret

Rope_Draw:
    push hl
    push de
    push bc
    
    ld   b, 8              ; 8 segmenti
    ld   d, 0              ; D = S (segment index, 0..7)
.loop:
    ld   a, (rope_frame_idx)        ; A = F (frame index)
    ld   h, d              ; H = S
    call CalculateRopeX    ; A = X
    ld   c, a              ; C = X (pixel)
    
    ; Imposta l'attributo giallo della cella a schermo
    push de
    push bc
    ld   a, c
    srl  a
    srl  a
    srl  a             ; A = Col (X / 8)
    ld   c, a
    ld   b, d              ; B = Row (S)
    call SetCellAttrYellow
    pop  bc
    pop  de
    
    ld   a, d
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   e, a              ; E = Y (pixel)
    
    push de
    push bc
    call DrawRopeSegment   ; Disegna tramite XOR
    pop  bc
    pop  de
    
    inc  d
    djnz .loop
    
    ; Salva il frame corrente come vecchio per il prossimo ciclo di erase
    ld   a, (40969)
    ld   (rope_old_frame), a
    
    pop  bc
    pop  de
    pop  hl
    ret

Rope_Erase:
    push hl
    push de
    push bc
    
    ld   a, (rope_old_frame)
    cp   34
    jr   z, .done
    
    ld   b, 8              ; 8 segmenti
    ld   d, 0              ; D = S (segment index, 0..7)
.loop:
    ld   a, (rope_old_frame)
    ld   h, d              ; H = S
    call CalculateRopeX    ; A = X
    ld   c, a              ; C = X
    
    ; Ripristina l'attributo originale della cella dello sfondo
    push de
    push bc
    ld   a, c
    srl  a
    srl  a
    srl  a             ; A = Col_old (X_old / 8)
    ld   c, a
    ld   b, d              ; B = Row (S)
    call RestoreCellAttribute
    pop  bc
    pop  de
    
    ld   a, d
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   e, a              ; E = Y
    
    push de
    push bc
    call DrawRopeSegment   ; Cancella tramite XOR
    pop  bc
    pop  de
    
    inc  d
    djnz .loop
    
.done:
    pop  bc
    pop  de
    pop  hl
    ret

CalculateRopeX:
    push bc
    push hl
    sub  17                ; A = F - 17
    jr   nc, .positive
    
.negative:
    neg                    ; A = 17 - F
    ld   l, h              ; L = S
    call MultiplyAbyL      ; HL = A * L
    ld   c, 5
    call DivideHLbyC       ; L = HL / 5
    ld   a, (rope_top_x)        ; A = X_top
    sub  l                 ; A = X_top - L
    pop  hl
    pop  bc
    ret
    
.positive:
    ld   l, h              ; L = S
    call MultiplyAbyL      ; HL = A * L
    ld   c, 5
    call DivideHLbyC       ; L = HL / 5
    ld   a, (rope_top_x)        ; A = X_top
    add  a, l              ; A = X_top + L
    pop  hl
    pop  bc
    ret

MultiplyAbyL:
    push de
    push bc
    ld   h, 0
    ld   d, h
    ld   e, a              ; DE = A
    ld   a, l              ; A = L
    ld   hl, 0
    ld   b, 8
.loop:
    add  hl, hl
    rla
    jr   nc, .no_add
    add  hl, de
.no_add:
    djnz .loop
    pop  bc
    pop  de
    ret

DivideHLbyC:
    push bc
    ld   b, 16
    xor  a
.loop:
    add  hl, hl
    rla
    cp   c
    jr   c, .no_sub
    sub  c
    inc  l
.no_sub:
    djnz .loop
    ld   h, a              ; H = resto
    pop  bc
    ret

DrawRopeSegment:
    ld   h, e              ; H = Y
    ld   l, c              ; L = X
    call Gfx_GetScreenAddr ; HL = screen address
    
    ld   a, c
    and  7
    jr   z, .done_shift
    ld   b, a
    ld   a, $80
.shift_loop:
    srl  a
    djnz .shift_loop
.done_shift:
    ld   d, a              ; D = mask
    
    ld   b, 8              ; 8 scanlines
.scanline_loop:
    ld   a, b
    and  3                 ; Disegna un pixel ogni 4 (linea tratteggiata come in rope.bmp)
    jr   nz, .skip_pixel
    ld   a, (hl)
    xor  d                 ; XOR draw/erase
    ld   (hl), a
.skip_pixel:
    inc  h
    djnz .scanline_loop
    ret

SetCellAttrYellow:
    push hl
    push de
    ; Calcola indirizzo: $5800 + Row (B) * 32 + Col (C)
    ld   h, 0
    ld   l, b
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl
    ld   d, 0
    ld   e, c
    add  hl, de
    ld   a, h
    add  a, $58
    ld   h, a
    ; Scrivi attributo giallo: INK = 6 (yellow), PAPER = 0 (black), BRIGHT = 1 ($46)
    ld   (hl), $46
    pop  de
    pop  hl
    ret

RestoreCellAttribute:
    push hl
    push de
    push bc
    
    ; 1. Calcola l'indice della cella: Row * 32 + Col
    ld   h, 0
    ld   l, b          ; HL = Row
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl        ; HL = Row * 32
    ld   d, 0
    ld   e, c          ; DE = Col
    add  hl, de        ; HL = Row * 32 + Col
    
    ; 2. Leggi il tipo di cella (0..3) da unpacked_layout + HL
    ld   de, unpacked_layout
    add  hl, de        ; HL = unpacked_layout + index
    ld   a, (hl)       ; A = cell type (0..3)
    
    ; 3. Calcola il tile pointer in base a type
    ld   hl, (room_ptr)
    or   a
    jr   nz, .not_bg
    ld   de, OFFSET_BG
    add  hl, de
    jr   .got_tile_ptr
.not_bg:
    dec  a
    jr   nz, .not_floor
    ld   de, OFFSET_FLOOR
    add  hl, de
    jr   .got_tile_ptr
.not_floor:
    dec  a
    jr   nz, .not_wall
    ld   de, OFFSET_WALL
    add  hl, de
    jr   .got_tile_ptr
.not_wall:
    ld   de, OFFSET_NASTY
    add  hl, de
    
.got_tile_ptr:
    ; HL = tile_ptr. Il primo byte è l'attributo!
    ld   a, (hl)       ; A = original attribute byte
    ld   d, a          ; D = original attribute byte
    
    ; 4. Calcola l'indirizzo dell'attributo a schermo: $5800 + Row * 32 + Col
    ld   h, 0
    ld   l, b          ; HL = Row
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl        ; Row * 32
    ld   e, c
    add  hl, de        ; Row * 32 + Col
    ld   a, h
    add  a, $58
    ld   h, a          ; HL = attribute address
    
    ; 5. Scrivi l'attributo originale dello schermo
    ld   (hl), d
    
    pop  bc
    pop  de
    pop  hl
    ret

