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
    bit  7, a              ; Il nemico è attivo?
    jr   z, .store_enemy_flags ; Se non è attivo, memorizza 0

    ; Controlla se siamo nella stanza Master Bedroom
    push hl
    push bc
    ld   hl, (room_ptr)
    ld   bc, MastreBedRoomLayout
    or   a
    sbc  hl, bc
    pop  bc
    pop  hl
    jr   nz, .store_enemy_flags ; Non è Master Bedroom

    ; Siamo nella Master Bedroom: controlla se il tipo di nemico (Byte 1) è VECCHIA
    inc  hl
    ld   a, (hl)           ; A = Type
    dec  hl
    cp   VECCHIA
    jr   nz, .store_enemy_flags ; Non è VECCHIA

    ; È la Vecchia nella Master Bedroom! Controlla se tutti gli item sono stati raccolti
    ld   a, (game_objective_completed)
    or   a
    jr   nz, .disable_master_bedroom_vecchia
    ld   a, (items_collected)
    cp   TOTAL_ITEMS
    jr   c, .store_enemy_flags ; Meno di TOTAL_ITEMS -> mantieni attiva

.disable_master_bedroom_vecchia:
    xor  a                 ; Flags = 0 (disattiva il guardiano)
    jr   .store_enemy_flags_val

.store_enemy_flags:
    ld   a, (hl)           ; Ricarica Flags originali da ROM
.store_enemy_flags_val:
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
    
    ; Imposta Old X = $FF, Old Y = $FF per forzare il rendering iniziale
    ld   a, $FF
    ld   (de), a           ; Offset 8: Old X
    inc  de
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
; Controlla se la posizione (C = X, B = Y) del nemico si sovrappone a Willy
; -------------------------------------------------------------------
CheckEnemyWillyOverlap:
    ld   a, (player_drawn_pos+1)
    cp   $FF
    ret  z                  ; Se Willy non è disegnato, esci
    
    ; 1. Controllo X: (EnemyX & $F8) - (WillyX & $F8) + 16 <= 24
    ld   a, (player_drawn_pos)
    and  $F8
    ld   e, a               ; E = WillyX & $F8
    ld   a, c
    and  $F8                ; A = EnemyX & $F8
    sub  e                  ; A = (EnemyX & $F8) - (WillyX & $F8)
    add  a, 16
    cp   25
    ret  nc                 ; Fuori portata X
    
    ; 2. Controllo Y: WillyY - EnemyY + 15 <= 30
    ld   a, (player_drawn_pos+1) ; A = WillyY
    sub  b                  ; A = WillyY - EnemyY
    add  a, 15
    cp   31
    ret  nc                 ; Fuori portata Y
    
    ; Sovrapposizione confermata! Segnala che Willy deve essere ridisegnato
    ld   a, 1
    ld   (willy_needs_redraw), a
    ret

; -------------------------------------------------------------------
; Aggiorna e disegna i nemici in due passate (prima cancella tutti i vecchi, poi disegna tutti i nuovi)
; -------------------------------------------------------------------
Enemy_EraseRoom:
Enemy_DrawRoom:
Enemy_RenderRoom:
    push hl
    push de
    push bc
    push ix
    
    ; ---------------------------------------------------------------
    ; PASSATA 1: Cancella la vecchia posizione di tutti i nemici che si sono mossi o aggiornati
    ; ---------------------------------------------------------------
    ld   ix, ActiveEnemies
    ld   b, 8              ; 8 slot
.erase_loop:
    ld   a, (ix+0)         ; Flags
    and  $80               ; Active?
    jr   z, .next_erase
    
    ; Se Old X == $FF (nuova stanza o non ancora disegnato), non c'è nulla da cancellare
    ld   a, (ix+8)         ; Old X
    cp   $FF
    jr   z, .next_erase
    
    ; Controlla se la posizione è cambiata o se l'animazione/stato si è aggiornato
    ld   a, (ix+8)         ; Old X
    cp   (ix+2)            ; Current X
    jr   nz, .do_erase_slot
    ld   a, (ix+9)         ; Old Y
    cp   (ix+3)            ; Current Y
    jr   nz, .do_erase_slot
    
    ld   a, (enemy_was_updated)
    or   a
    jr   z, .next_erase    ; Nessuna modifica in questo frame, non cancellare!

.do_erase_slot:
    push bc                ; Salva contatore ciclo
    
    ; Controlla se la VECCHIA posizione del guardiano sovrascrive Willy
    ld   c, (ix+8)         ; C = Old X
    ld   b, (ix+9)         ; B = Old Y
    call CheckEnemyWillyOverlap

    ; Cancella il nemico nella VECCHIA posizione
    ld   c, (ix+8)         ; C = Old X
    ld   b, (ix+9)         ; B = Old Y
    call Gfx_ErasePixelSprite16x16
    ld   c, (ix+8)         ; C = Old X
    ld   b, (ix+9)         ; B = Old Y
    call Gfx_RestoreEnemyColorAttributes

    pop  bc

.next_erase:
    ld   de, 11
    add  ix, de            ; Prossimo slot (11 byte)
    dec  b
    jr   nz, .erase_loop

    ; ---------------------------------------------------------------
    ; PASSATA 2: Disegna la nuova posizione di tutti i nemici
    ; ---------------------------------------------------------------
    ld   ix, ActiveEnemies
    ld   b, 8              ; 8 slot
.draw_loop:
    ld   a, (ix+0)         ; Flags
    and  $80               ; Active?
    jr   z, .next_draw
    
    ; Se Old X == $FF, deve essere disegnato (prima volta)
    ld   a, (ix+8)         ; Old X
    cp   $FF
    jr   z, .do_draw_slot
    
    ; Controlla se si è mosso o se l'animazione/stato si è aggiornato
    ld   a, (ix+8)         ; Old X
    cp   (ix+2)            ; Current X
    jr   nz, .do_draw_slot
    ld   a, (ix+9)         ; Old Y
    cp   (ix+3)            ; Current Y
    jr   nz, .do_draw_slot
    
    ld   a, (enemy_was_updated)
    or   a
    jr   z, .next_draw     ; Nessuna modifica in questo frame, non ridisegnare!

.do_draw_slot:
    push bc                ; Salva contatore ciclo
    
    ; Disegna il nemico nella NUOVA posizione (applica anche gli attributi colore)
    call Enemy_DrawSingleSlot
    
    ; Controlla se la NUOVA posizione del guardiano si sovrappone a Willy
    ld   c, (ix+2)         ; C = Current X
    ld   b, (ix+3)         ; B = Current Y
    call CheckEnemyWillyOverlap

    ; Salva le coordinate effettivamente disegnate
    ld   a, (ix+2)
    ld   (ix+8), a
    ld   a, (ix+3)
    ld   (ix+9), a

    pop  bc

.next_draw:
    ld   de, 11
    add  ix, de            ; Prossimo slot (11 byte)
    dec  b
    jr   nz, .draw_loop

    xor  a
    ld   (enemy_was_updated), a
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Disegna un singolo nemico specificato da IX
; -------------------------------------------------------------------
Enemy_DrawSingleSlot:
    push bc
    push de
    push hl
    
    ; Determina quale sprite usare basato sul tipo (Offset 1, Bit 5-0)
    ld   a, (ix+1)         ; Tipo
    and  $3F               
    
    cp   LAMETTA
    jp   z, .got_lametta
    cp   SEGA
    jp   z, .got_sega
    cp   UCCELLO
    jp   z, .got_uccello
    cp   RADAR
    jp   z, .got_radar
    cp   UOVO
    jp   z, .got_uovo
    cp   UFO
    jp   z, .got_ufo
    cp   FACCIA
    jp   z, .got_faccia
    cp   SCIMMIA
    jp   z, .got_scimmia
    cp   ROBOT
    jp   z, .got_robot
    cp   PALLA
    jp   z, .got_palla
    cp   DOUBLE_BALL
    jp   z, .got_doubleball
    cp   SOLDATO
    jp   z, .got_soldato
    cp   MAIALE
    jp   z, .got_maiale
    cp   CANGURO
    jp   z, .got_canguro
    cp   FIORE
    jp   z, .got_fiore
    cp   FACCIA_PALLA
    jp   z, .got_facciapalla
    cp   CANDELABRO
    jp   z, .got_candelabro
    cp   FRECCIA
    jp   z, .got_freccia
    cp   TRONCHESE
    jp   z, .got_tronchese
    cp   PERISCOPIO
    jp   z, .got_periscopio
    cp   NONNINO
    jp   z, .got_nonnino
    cp   PARRUCCA
    jp   z, .got_parrucca
    cp   FRATE
    jp   z, .got_frate
    cp   FACE_HL
    jp   z, .got_facehell_hl
    cp   FACE_HR
    jp   z, .got_facehell_hr
    cp   FACE_LL
    jp   z, .got_facehell_ll
    cp   FACE_LR
    jp   z, .got_facehell_lr
    cp   PINZA_GHIACCIO
    jp   z, .got_pinzagiaccio
    cp   RUOTA
    jp   z, .got_ruota
    cp   SALIERA
    jp   z, .got_saliera
    cp   GELATO
    jp   z, .got_gelato
    cp   PINGUINO
    jp   z, .got_pinguino
    cp   MURO
    jp   z, .got_muro
    cp   DIAVOLETTO
    jp   z, .got_diavoletto
    cp   VECCHIA
    jp   z, .got_vecchia
    cp   PIEDE
    jp   z, .got_piede
    cp   CHIP
    jp   z, .got_chip
    cp   IPNOSI
    jp   z, .got_ipnosi
    cp   SWISSARMKIFE
    jp   z, .got_swissarmyknife
    cp   BOTTE
    jp   z, .got_botte
    cp   ONDA
    jp   z, .got_onda
    cp   PALAZZO
    jp   z, .got_palazzo

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

.got_chip:
    ld   hl, ChipSprite
    jp   .got_sprite

.got_ipnosi:
    ld   hl, IpnosiSprite
    jp   .got_sprite

.got_swissarmyknife:
    ld   hl, SwissArmyKife
    jp   .got_sprite

.got_botte:
    ld   hl, BotteSprite
    jp   .got_sprite

.got_onda:
    ld   hl, OndaSprite
    jp   .got_sprite

.got_palazzo:
    ld   hl, PalazzoSprite
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
    
    pop  hl
    pop  de
    pop  bc
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
    
    pop  hl
    pop  de
    pop  bc
    ret

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
    ld   a, 1
    ld   (enemy_was_updated), a
    
    ld   ix, ActiveEnemies
    ld   b, 8              ; 8 slot
.loop:
    ld   a, (ix+0)         ; Flags
    and  $80               ; Active?
    jp   z, .next
    
    ; 1. Aggiorna Anim State
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
