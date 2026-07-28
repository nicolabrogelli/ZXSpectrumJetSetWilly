;===========================================================================
; physics.asm
;===========================================================================

    
; -------------------------------------------------------------------
; Verifica se c'è una cella solida (Floor o Wall) alle coordinate pixel (X, Y)
; Input: C = X, B = Y
; Output: Carry flag impostato se solida, altrimenti resettato
; -------------------------------------------------------------------
Phys_CheckSolid:
    push hl
    push de
    push bc
    
    ; Se Y < 0 (sopra lo schermo), non è solida
    ld   a, b
    bit  7, a
    jr   nz, .not_solid
    
    ; Se Y >= 128, clampiamo a 127 per poter controllare il pavimento (riga 15)
    cp   128
    jr   c, .y_ok
    ld   b, 127
.y_ok:
    
    call CheckConveyorOrRampCell
    jr   c, .solid
    
    ; 2. Calcola riga di layout: r = Y / 8
    ld   a, b
    srl  a
    srl  a
    srl  a                 ; A = r (0..15)
    
    ; 3. Calcola colonna di layout: c = X / 8 (in C)
    ld   e, a              ; E = r
    ld   a, c
    srl  a
    srl  a
    srl  a                 ; A = c (0..31)
    ld   c, a              ; C = c
    ld   a, e              ; A = r
    
    call GetCellFromUnpacked ; A = cell type
    
    ; 5. Controlla se è solida: Floor (1) o Wall (2)
    cp   1
    jr   z, .solid
    cp   2
    jr   z, .solid
    
.not_solid:
    pop  bc
    pop  de
    pop  hl
    or   a                 ; Clear carry
    ret
    
.solid:
    pop  bc
    pop  de
    pop  hl
    scf                    ; Set carry
    ret


; -------------------------------------------------------------------
; Applica gravità e gestisce salto
; -------------------------------------------------------------------
Phys_ApplyGravity:
    ld  bc, (PlayerPos)
    ld  a, b              ; B = PlayerY (pixel)
    
    ; --- CONTROLLO RAMPA PER IL MOVIMENTO ---
    ld   a, (on_ground)
    or   a
    jr   z, .not_on_ramp_walk ; Se siamo in volo, non fare il snap della camminata sulla rampa
    
    call GetRampY           ; C = PlayerX, A = ramp_Y (se carry set)
    jr   nc, .not_on_ramp_walk
    
    ; Siamo nel range della rampa!
    ; Controlliamo se siamo abbastanza vicini verticalmente
    ld   e, a               ; E = ramp_Y
    ld   a, b               ; A = PlayerY
    sub  e                  ; A = PlayerY - ramp_Y
    bit  7, a
    jr   z, .abs_ok
    neg
.abs_ok:
    cp   12                 ; Soglia di vicinanza di 11 pixel
    jr   nc, .not_on_ramp_walk ; Se troppo lontano, non agganciare la rampa
    
    ; Aggancia sulla rampa!
    ld   b, e               ; B = ramp_Y
    bit  7, b
    jp   nz, .ramp_top_exit ; Se B è negativo (bit 7 = 1), Willy è in cima alla rampa al bordo superiore!
    ld   (PlayerPos), bc    ; Salva la posizione Y allineata alla rampa
    
    ; Gestisci il salto mentre siamo sulla rampa
    ld   a, (jump_pressed)
    or   a
    jp   z, .end            ; Se non salta, abbiamo finito per questo frame
    
    xor  a
    ld   (Audio_jump_sound_note), a
    ld   (Audio_jump_sound_timer), a
    
    ld   a, (room_jump_strength)
    ld   (velocity_y), a
    xor  a
    ld   (on_ground), a
    ld   (jump_pressed), a
    ld   (jump_frame), a
    ld   a, b              ; B = PlayerY (ramp_Y)
    ld   (jump_start_y), a
    ld   a, (current_input_dir)
    ld   (jump_dir), a
    jp   .in_air
    
.not_on_ramp_walk:
    ld  bc, (PlayerPos)
    ld  a, b              ; B = PlayerY (pixel)

    ; Controlla se siamo a mezz'aria (on_ground == 0)
    ld  a, (on_ground)
    or  a
    jp  z, .in_air        ; Se siamo in volo, continua a volare

    ; --- CONTROLLO STEP DOWN DI 1 TILE (8 pixel) ---
    ; Se stiamo scendendo da una rampa o gradino di 1 tile,
    ; facciamo scendere Willy immediatamente per evitare che fluttui in aria.
    ld   a, (direction)
    cp   1
    jr   z, .stepping_left
    
.stepping_right:
    ; Muovendo a destra: piede sinistro (dietro) a Y + 16 deve essere solido
    ld   a, b
    add  a, 16
    push bc
    ld   b, a              ; B = Y + 16
    call Phys_CheckSolid    ; C = X
    pop  bc
    jr   nc, .no_step_down
    
    ; Piede destro (davanti) a Y + 16 deve essere vuoto
    ld   a, b
    add  a, 16
    push bc
    ld   b, a              ; B = Y + 16
    ld   a, c
    add  a, 7
    ld   c, a              ; C = X + 7
    call Phys_CheckSolid
    pop  bc
    jr   c, .no_step_down
    
    ; Piede destro (davanti) a Y + 24 deve essere solido
    ld   a, b
    add  a, 24
    cp   128
    jr   nc, .no_step_down
    push bc
    ld   b, a              ; B = Y + 24
    ld   a, c
    add  a, 7
    ld   c, a              ; C = X + 7
    call Phys_CheckSolid
    pop  bc
    jr   nc, .no_step_down
    
    jr   .do_step_down
    
.stepping_left:
    ; Muovendo a sinistra: piede destro (dietro) a Y + 16 deve essere solido
    ld   a, b
    add  a, 16
    push bc
    ld   b, a              ; B = Y + 16
    ld   a, c
    add  a, 7
    ld   c, a              ; C = X + 7
    call Phys_CheckSolid
    pop  bc
    jr   nc, .no_step_down
    
    ; Piede sinistro (davanti) a Y + 16 deve essere vuoto
    ld   a, b
    add  a, 16
    push bc
    ld   b, a              ; B = Y + 16
    call Phys_CheckSolid    ; C = X
    pop  bc
    jr   c, .no_step_down
    
    ; Piede sinistro (davanti) a Y + 24 deve essere solido
    ld   a, b
    add  a, 24
    cp   128
    jr   nc, .no_step_down
    push bc
    ld   b, a              ; B = Y + 24
    call Phys_CheckSolid    ; C = X
    pop  bc
    jr   nc, .no_step_down
    
.do_step_down:
    ; Controlla se il nuovo Y (B + 8) causerebbe collisioni con muri a sinistra o a destra.
    ; Se sì, annulla lo step down per evitare che Willy sprofondi/entri nei blocchi Wall.
    ld   a, b
    add  a, 8
    push bc
    ld   b, a              ; B = Y + 8
    ; C = X (bordo sinistro)
    call CheckWillyWallCollision
    pop  bc
    jr   c, .no_step_down  ; Se collide, non effettuare lo step down
    
    ld   a, b
    add  a, 8
    push bc
    ld   b, a              ; B = Y + 8
    ld   a, c
    add  a, 7
    ld   c, a              ; C = X + 7 (bordo destro)
    call CheckWillyWallCollision
    pop  bc
    jr   c, .no_step_down  ; Se collide, non effettuare lo step down

    ; Applica lo step down
    ld   a, b
    add  a, 8
    ld   b, a              ; B = Y + 8
    ld   (PlayerPos+1), a  ; Aggiorna Y
    
.no_step_down:
    
    ; Se on_ground == 1, controlliamo se siamo ancora su terreno solido
    ; Dobbiamo controllare i pixel direttamente sotto i piedi del player:
    ; (PlayerX, PlayerY + 16) e (PlayerX + 7, PlayerY + 16)
    ld  a, b
    add  a, 16
    ld  b, a              ; B = PlayerY + 16
    
    ; Controlla se la cella sotto il piede sinistro (PlayerX, PlayerY + 16) è solida
    call Phys_CheckSolid
    jr   c, .still_on_ground
    
    ; Controlla se la cella sotto il piede destro (PlayerX + 7, PlayerY + 16) è solida
    ld   a, c
    add  a, 7
    ld   c, a              ; C = PlayerX + 7
    call Phys_CheckSolid
    jr   c, .still_on_ground
    
    ; Se nessuna delle due è solida, iniziamo a cadere!
    xor  a
    ld   (on_ground), a
    ld   (velocity_y), a   ; Inizia la caduta con velocità 0
    jp   .in_air
    
.still_on_ground:
    ; Siamo ancora sulla piattaforma o sul pavimento
    ; Ripristina bc originale (PlayerPos)
    ld   bc, (PlayerPos)
    
    ; Gestisci il salto
    ld   a, (jump_pressed)
    or   a
    jp   z, .end
    
    xor  a
    ld   (Audio_jump_sound_note), a
    ld   (Audio_jump_sound_timer), a
    
    ld   a, (room_jump_strength)
    ld   (velocity_y), a
    xor  a
    ld   (on_ground), a
    ld   (jump_pressed), a
    ld   (jump_frame), a
    ld   a, b              ; B = PlayerY
    ld   (jump_start_y), a
    ld   a, (current_input_dir)
    ld   (jump_dir), a
    jp   .in_air

.in_air:
    ; Incrementa jump_frame per mantenere coerente la gravità frazionaria del salto
    ld   a, (jump_frame)
    inc  a
    ld   (jump_frame), a
    
    ; Leggi il preset della gravità
    ld   b, a                  ; Salva jump_frame in B
    ld   a, (room_gravity_preset)
    
    ; Controlla il preset
    or   a                     ; cp 0 (Gravità 0.5)
    jr   z, .grav_0_5
    dec  a                     ; cp 1 (Gravità 0.75 - Standard)
    jr   z, .grav_0_75
    dec  a                     ; cp 2 (Gravità 1.0)
    jr   z, .grav_1_0
    dec  a                     ; cp 3 (Gravità 0.25)
    jr   z, .grav_0_25
    dec  a                     ; cp 4 (Gravità 0.0)
    jr   z, .skip_gravity
    
    ; Default a 0.75 se valore sconosciuto
    jr   .grav_0_75

.grav_0_5:
    ld   a, b                  ; Ripristina jump_frame
    and  1
    jr   nz, .skip_gravity     ; Salta se bit 0 è impostato (media 0.5)
    jr   .apply_gravity

.grav_0_75:
    ld   a, b                  ; Ripristina jump_frame
    and  3
    cp   3
    jr   z, .skip_gravity      ; Salta se frame è 3 (media 0.75)
    jr   .apply_gravity

.grav_0_25:
    ld   a, b                  ; Ripristina jump_frame
    and  3
    cp   3
    jr   nz, .skip_gravity     ; Salta se frame non è 3 (media 0.25)
    jr   .apply_gravity

.grav_1_0:
    ; Non saltare mai la gravità
    jr   .apply_gravity

.apply_gravity:
    ld   a, (velocity_y)
    sub  1
    jr   .clamp_fall_speed
    
.skip_gravity:
    ld   a, (velocity_y)
    
.clamp_fall_speed:
    ; Controlla se positivo per evitare bug con cp signed
    bit 7, a
    jr  z, .store_vel
    
    cp  -MAX_FALL_SPEED   ; -12
    jr  nc, .store_vel
    ld  a, -MAX_FALL_SPEED

.store_vel:
    ld  (velocity_y), a

    ; Applica movimento verticale: PlayerY = PlayerY - velocity_y
    ld  bc, (PlayerPos)
    ld  d, a              ; D = velocity_y (signed)
    ld  a, b              ; A = PlayerY
    sub d                 ; A = PlayerY - velocity_y
    ld  b, a              ; B = new PlayerY

    ld  a, (velocity_y)
    bit 7, a              ; Se negativo, bit 7 = 1
    jr  nz, .falling_checks
    or  a                 ; Se zero
    jr  z, .falling_checks
    
    ; Se stiamo salendo, controlla la collisione della testa con il soffitto (muri Wall)
    ; In questo punto, bc contiene: C = PlayerX, B = new PlayerY
    push bc
    
    ; Controlla se la testa a sinistra (PlayerX, new_Y) colpisce un Wall
    call CheckWallCell
    jr   c, .ceiling_collision
    
    ; Controlla se la testa a destra (PlayerX + 7, new_Y) colpisce un Wall
    ld   a, c
    add  a, 7
    ld   c, a              ; C = PlayerX + 7
    call CheckWallCell
    jr   c, .ceiling_collision
    
    pop  bc
    jp   .no_collision_checks
    
.ceiling_collision:
    pop  bc                 ; Ripristina bc originale (C = PlayerX, B = new PlayerY)
    
    ; Calcola la coordinata Y clampata appena sotto il soffitto.
    ; Il muro colpito è a riga r = new_Y / 8.
    ; Il limite Y consentito è riga r + 1, cioè Y = (r + 1) * 8.
    ld   a, b              ; A = new_Y
    srl  a
    srl  a
    srl  a                 ; A = r (0..15)
    inc  a                 ; r + 1
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8 (Y clampato)
    
    ld   b, a              ; B = Y clampato
    
    ; Ferma la velocità verso l'alto (inizia la caduta)
    xor  a
    ld   (velocity_y), a
    jp   .save_pos
    
.falling_checks:
    ; --- CONTROLLO ATTERRAGGIO SU RAMPA ---
    push bc
    ; BC ha C = PlayerX, B = new_Y
    ld   a, (PlayerPos+1)   ; A = old_Y
    ld   d, a               ; D = old_Y
    
    call GetRampY           ; Calcola ramp_Y per PlayerX (in C)
    jp   nc, .no_ramp_landing
    
    ld   h, a               ; H = ramp_Y
    
    ; Controlla se il salto è iniziato da sotto la rampa
    ld   a, (jump_start_y)
    or   a
    jr   z, .jump_start_ok  ; Se 0, non siamo in salto (è una caduta normale), permetti atterraggio
    
    cp   h
    jr   z, .jump_start_ok
    jp   nc, .no_ramp_landing ; Se jump_start_y > ramp_Y (numerico Y > H), eravamo sotto la rampa -> passa oltre
    
.jump_start_ok:
    ld   a, d               ; A = old_Y
    cp   h
    jr   z, .check_new_y
    jp   nc, .no_ramp_landing ; Se old_Y > ramp_Y (era sotto la rampa), non atterra
    
.check_new_y:
    ld   a, b               ; A = new_Y (in B)
    cp   h
    jp   c, .no_ramp_landing ; Se new_Y < ramp_Y (non ha ancora toccato la rampa), non atterra
    
    ; Atterrato sulla rampa!
    pop  bc                 ; BC ha C = PlayerX, B = new_Y
    ld   b, h               ; B = ramp_Y
    
    ; Controlla se ramp_Y è negativo (bordo superiore dello schermo)
    bit  7, b
    jr   nz, .ramp_top_exit ; Se B è negativo (bit 7 = 1), Willy è in cima alla rampa al bordo superiore!
    
    ld   (PlayerPos), bc
    ld   a, 1
    ld   (on_ground), a
    xor  a
    ld   (velocity_y), a
    ld   (jump_start_y), a  ; Reset jump Y
    ld   (jump_dir), a
    ld   (jump_frame), a
    jp   .end

.ramp_top_exit:
    xor  a
    ld   (velocity_y), a
    ld   (jump_start_y), a
    ld   (jump_dir), a
    ld   (jump_frame), a
    jr   .save_pos          ; Esegui controllo transizione di stanza verso l'alto!
    
.no_ramp_landing:
    pop  bc
    ; --- CONTROLLO COLLISIONE CON IL TERRENO DURANTE LA CADUTA ---
    ; Controlliamo solo al piede effettivo (Y + 16) per evitare che Willy atterri su blocchi orizzontali di lato
    ld   a, b
    add  a, 16
    cp   128
    jr   c, .y_ok_fall
    ld   a, 127
.y_ok_fall:
    ld   b, a              ; B = Nuovo Y + 16 (clampato)
    
    ; Controlla se il piede sinistro tocca solido a Y + 16
    call Phys_CheckSolid
    jr   c, .check_landing
    
    ; Controlla se il piede destro tocca solido a Y + 16
    ld   a, c
    add  a, 7
    ld   c, a              ; C = PlayerX + 7
    call Phys_CheckSolid
    jr   c, .check_landing
    
    ; Nessun atterraggio
    jr   .no_collision_checks

.check_landing:
    ; Abbiamo toccato una cella solida durante la caduta!
    ld   a, b
    srl  a
    srl  a
    srl  a                 ; A = r (0..15), riga di layout della tile
    
    ld   e, a              ; E = r
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, 3              ; Tolleranza di 3 pixel sulla superficie superiore della tile
    ld   d, a              ; D = r * 8 + 3 (limite per l'aggancio della superficie)
    
    ; Posizione precedente dei piedi: Vecchio Y + 16
    ld   a, (PlayerPos+1)  ; A = Vecchio Y
    add  a, 16             ; A = Vecchio Y + 16
    
    cp   d                 ; Confronta Vecchio Y + 16 con (r * 8 + 3)
    jr   z, .do_landing    ; Se == (entro i primi 3px dalla superficie), atterra
    jr   c, .do_landing    ; Se < (era sopra la superficie prima di cadere), atterra
    
    jr   .no_collision_checks ; Se era nella metà inferiore della tile (proveniva da sotto), NON atterrare! ; Se era sotto la superficie (proveniva da sotto), NON atterrare!

.do_landing:
    ; Atterra sulla riga di layout E!
    ld   a, e
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    sub  16             ; A = PlayerY di atterraggio
    
    ld   bc, (PlayerPos)   ; Ripristina C = PlayerX
    ld   b, a              ; B = Nuovo PlayerY
    
    ld   (PlayerPos), bc
    ld   a, 1
    ld   (on_ground), a
    xor  a
    ld   (velocity_y), a
    ld   (jump_start_y), a  ; Reset jump Y
    ld   (jump_dir), a
    ld   (jump_frame), a
    jp   .end
    
.no_collision_checks:
    ld   a, (velocity_y)
    ld   d, a                  ; Ripristina D = velocity_y (evita corruzione se proveniamo da .check_landing)
    ld   bc, (PlayerPos)
    ld   a, b
    sub  d                 ; A = Nuovo Y (calcolato in .store_vel)
    ld   b, a              ; B = Nuovo Y
    
.save_pos:
    ld   a, b
    bit  7, a              ; Se Y è negativo (sotto 0)
    jr   z, .check_max
    
    ; Willy sta andando sopra il bordo superiore (Y < 0)
    ; Controlla se c'è una stanza sopra
    ld   hl, (room_ptr)
    ld   de, 237           ; Offset per stanza sopra
    add  hl, de
    ld   a, (hl)           ; A = ID stanza sopra
    cp   $FF
    jr   z, .no_up_transition
    
    ; C'è una stanza sopra!
    ld   b, 96             ; Posiziona Willy a Y=96 (sopra il pavimento a riga 14 della nuova stanza)
    jp   TriggerRoomChange
    
.no_up_transition:
    ld   b, 0
    xor  a
    ld   (velocity_y), a
    ld   (jump_start_y), a
    ld   (jump_dir), a
    jr   .save_ok

.check_max:
    ld   a, b
    cp   113               ; Se Y >= 113, Willy sta cadendo sotto il bordo inferiore
    jr   c, .save_ok
    
    ; Willy sta andando sotto il bordo inferiore (Y >= 113)
    ; Controlla se c'è una stanza sotto
    ld   hl, (room_ptr)
    ld   de, 238           ; Offset per stanza sotto
    add  hl, de
    ld   a, (hl)           ; A = ID stanza sotto
    cp   $FF
    jr   z, .no_down_transition
    
    ; C'è una stanza sotto!
    ld   b, 4              ; Posiziona Willy a Y=4 (in cima alla nuova stanza, evita re-triggering di Y<=0)
    jp   TriggerRoomChange
    
.no_down_transition:
    ld   b, 112
    xor  a
    ld   (velocity_y), a
    ld   (jump_start_y), a
    ld   (jump_dir), a

.save_ok:
    ld   (PlayerPos), bc

.end:
    xor  a
    ld   (jump_pressed), a
    ret

; -------------------------------------------------------------------
; Verifica la collisione tra player e nemico (bounding box a livello di pixel)
; Output: Carry flag impostato se collisione, altrimenti resettato
; -------------------------------------------------------------------
CheckCollision:
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
    
    ; 1. Controllo orizzontale: PlayerX - EnemyX + 7 in [0, 22]
    ld   a, (PlayerPos)    ; A = PlayerX
    sub  (ix+2)            ; A = PlayerX - EnemyX (Offset 2: Current X)
    add  a, 7              ; A = PlayerX - EnemyX + 7
    cp   23                ; Se >= 23, nessuna collisione con questo
    jr   nc, .next
    
    ; 2. Controllo verticale: PlayerY - EnemyY + 15 in [0, 30]
    ld   a, (PlayerPos+1)  ; A = PlayerY
    sub  (ix+3)            ; A = PlayerY - EnemyY (Offset 3: Current Y)
    add  a, 15             ; A = PlayerY - EnemyY + 15
    cp   31                ; Se >= 31, nessuna collisione con questo
    jr   nc, .next
    
    ; Collisione avvenuta!
    pop  ix
    pop  bc
    pop  de
    pop  hl
    scf                    ; Imposta carry flag
    ret
    
.next:
    ld   de, 11
    add  ix, de            ; Prossimo slot (11 byte)
    dec  b
    jr   nz, .loop
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    or   a                 ; Reset carry flag
    ret

; -------------------------------------------------------------------
CheckConveyorOrRampCell:
    push hl
    push de
    push bc
    
    ; 1. Converti Y pixel in B a layout row: r = Y / 8
    ld   a, b
    cp   128
    jr   nc, .not_solid
    srl  a
    srl  a
    srl  a                 ; A = r (0..15)
    ld   d, a              ; D = r (layout row)
    
    ; 2. Converti X pixel in C a column: c = X / 8
    ld   a, c
    srl  a
    srl  a
    srl  a                 ; A = c (0..31)
    ld   e, a              ; E = c (column)
    
    ; --- CONTROLLO CONVEYOR ---
    ld   a, (conveyor_len)
    or   a
    jr   z, .not_solid     ; Se non c'è conveyor, fine
    
    ; Controlla se Row corrisponde
    ld   a, (conveyor_row)
    cp   d
    jr   nz, .not_solid    ; Row diversa
    
    ; Controlla se Col è compresa: c >= conveyor_col e c < conveyor_col + conveyor_len
    ld   a, (conveyor_col)
    cp   e
    jr   z, .is_conveyor   ; c == conveyor_col -> solido!
    jr   c, .c_greater     ; c > conveyor_col -> controlla limite superiore
    jr   .not_solid        ; c < conveyor_col
.c_greater:
    ld   b, a              ; B = conveyor_col
    ld   a, (conveyor_len)
    add  a, b              ; A = conveyor_col + conveyor_len
    cp   e
    jr   z, .not_solid     ; c == len (fuori)
    jr   c, .not_solid     ; c > len (fuori)
.is_conveyor:
    pop  bc
    pop  de
    pop  hl
    scf                    ; Set carry (solido)
    ret
    
.not_solid:
    pop  bc
    pop  de
    pop  hl
    or   a                 ; Clear carry
    ret

; -------------------------------------------------------------------
; Applica la forza di trascinamento del conveyor se Willy vi è sopra
; -------------------------------------------------------------------
Phys_ApplyConveyor:
    ld   a, (on_ground)
    or   a
    ret  z                 ; Se non è a terra, nessuna forza
    
    ld   a, (conveyor_len)
    or   a
    ret  z                 ; Se non c'è conveyor in questa stanza, fine
    
    ld   bc, (PlayerPos)   ; C = WillyX, B = WillyY
    
    ; Calcola screenRow dei piedi del player: RowPiedi = Y / 8
    ld   a, b
    add  a, 16
    srl  a
    srl  a
    srl  a                 ; A = (Y + 16) / 8
    
    ; Confronta con conveyor_row
    ld   d, a              ; D = RowPiedi
    ld   a, (conveyor_row)
    cp   d
    ret  nz                ; Se non siamo sulla riga del conveyor, fine
    
    ; ColStart = WillyX / 8
    ld   a, c
    srl  a
    srl  a
    srl  a                 ; A = ColStart
    ld   e, a              ; E = ColStart
    
    ; ColEnd = (WillyX + 7) / 8
    ld   a, c
    add  a, 7
    srl  a
    srl  a
    srl  a                 ; A = ColEnd
    ld   d, a              ; D = ColEnd
    
    ; conveyor_col_end = conveyor_col + conveyor_len - 1
    ld   a, (conveyor_col)
    ld   hl, conveyor_len
    add  a, (hl)
    dec  a                 ; A = conveyor_col_end
    
    ; E <= conveyor_col_end (conveyor_col_end >= E)
    cp   e
    ret  c                 ; Se conveyor_col_end < E, fine
    
    ; D >= conveyor_col
    ld   a, (conveyor_col)
    ld   e, a
    ld   a, d
    cp   e
    ret  c                 ; Se D < conveyor_col, fine
    
    ; Willy è sul conveyor! Muovilo nella direzione del conveyor!
    ld   a, (conveyor_dir)
    or   a
    jr   z, .move_left
    
.move_right:
    ld   a, c
    add  a, 1              ; trascina di 1 pixel a destra per frame
    cp   PLAYER_MAX_X
    jr   c, .store_x
    ld   a, PLAYER_MAX_X
    jr   .store_x
    
.move_left:
    ld   a, c
    sub  1                 ; trascina di 1 pixel a sinistra per frame
    cp   PLAYER_MIN_X
    jr   nc, .store_x
    ld   a, PLAYER_MIN_X
    
.store_x:
    ld   c, a
    ld   (PlayerPos), bc   ; salva la nuova posizione
    ret

; -------------------------------------------------------------------
; Verifica se Willy si trova sopra un blocco Conveyor attivo
; Output: Carry flag impostato se Willy è sul conveyor, altrimenti resettato
; -------------------------------------------------------------------
CheckWillyOnConveyor:
    push bc
    push de
    push hl

    ld   a, (on_ground)
    or   a
    jr   z, .not_on_conveyor

    ld   a, (conveyor_len)
    or   a
    jr   z, .not_on_conveyor

    ld   bc, (PlayerPos)   ; C = WillyX, B = WillyY
    
    ; Calcola screenRow dei piedi del player: RowPiedi = (Y + 16) / 8
    ld   a, b
    add  a, 16
    srl  a
    srl  a
    srl  a                 ; A = (Y + 16) / 8
    
    ; Confronta con conveyor_row
    ld   d, a              ; D = RowPiedi
    ld   a, (conveyor_row)
    cp   d
    jr   nz, .not_on_conveyor
    
    ; ColStart = WillyX / 8
    ld   a, c
    srl  a
    srl  a
    srl  a                 ; A = ColStart
    ld   e, a              ; E = ColStart
    
    ; ColEnd = (WillyX + 7) / 8
    ld   a, c
    add  a, 7
    srl  a
    srl  a
    srl  a                 ; A = ColEnd
    ld   d, a              ; D = ColEnd
    
    ; conveyor_col_end = conveyor_col + conveyor_len - 1
    ld   a, (conveyor_col)
    ld   hl, conveyor_len
    add  a, (hl)
    dec  a                 ; A = conveyor_col_end
    
    ; E <= conveyor_col_end (conveyor_col_end >= E)
    cp   e
    jr   c, .not_on_conveyor
    
    ; D >= conveyor_col
    ld   a, (conveyor_col)
    ld   e, a
    ld   a, d
    cp   e
    jr   c, .not_on_conveyor

    ; Willy è sul conveyor! Imposta carry
    pop  hl
    pop  de
    pop  bc
    scf
    ret

.not_on_conveyor:
    pop  hl
    pop  de
    pop  bc
    or   a                 ; Clear carry
    ret

; -------------------------------------------------------------------
; Verifica se la cella (Col in E, Row in D) è sulla rampa, immediatamente sotto di essa,
; o sulla piattaforma adiacente in cima.
; Output: Carry flag impostato se è sulla rampa, altrimenti resettato
; -------------------------------------------------------------------
IsCellOnRamp:
    push bc
    push hl
    
    ld   a, (ramp_len)
    or   a
    jr   z, .no
    
    ; 1. Verifica se Col (in E) è nel range orizzontale della rampa
    ld   a, (ramp_dir)
    or   a
    jr   z, .range_left
.range_right:
    ld   a, (ramp_col)
    ld   b, a              ; B = ramp_col
    ld   a, (ramp_len)
    add  a, b              ; A = ramp_col + ramp_len
    ld   c, a              ; C = limit_right (exclusive)
    
    ld   a, e              ; A = Col
    cp   b
    jr   c, .check_platform_case ; Col < ramp_col
    cp   c
    jr   nc, .check_platform_case ; Col >= limit_right
    
    ; Calcola B = Col - ramp_col
    ld   a, e
    sub  b
    ld   b, a              ; B = offset (0..ramp_len-1)
    
    ; SlopeRow = ramp_row - B
    ld   a, (ramp_row)
    sub  b
    ld   b, a              ; B = SlopeRow
    jr   .check_row_match
    
.range_left:
    ; Per rampa a sinistra, range è [ramp_col - ramp_len + 1, ramp_col]
    ld   hl, ramp_len
    ld   a, (ramp_col)
    sub  (hl)
    inc  a                 ; A = ramp_col - ramp_len + 1
    ld   b, a              ; B = limit_left
    
    ld   a, (ramp_col)
    inc  a
    ld   c, a              ; C = limit_right (exclusive)
    
    ld   a, e              ; A = Col
    cp   b
    jr   c, .check_platform_case
    cp   c
    jr   nc, .check_platform_case
    
    ; Calcola B = ramp_col - Col
    ld   a, (ramp_col)
    sub  e
    ld   b, a              ; B = offset
    
    ; SlopeRow = ramp_row - B
    ld   a, (ramp_row)
    sub  b
    ld   b, a              ; B = SlopeRow

.check_row_match:
    ; D (Row) deve essere uguale a SlopeRow (in B) o SlopeRow + 1 (immediatamente sotto)
    ld   a, d              ; A = Row
    cp   b
    jr   z, .yes           ; Row == SlopeRow
    inc  b                 ; B = SlopeRow + 1
    cp   b
    jr   z, .yes           ; Row == SlopeRow + 1
    
.check_platform_case:
    ; 2. Controlla se è sulla piattaforma adiacente in cima
    ld   a, (ramp_dir)
    or   a
    jr   z, .plat_left
.plat_right:
    ld   a, (ramp_col)
    ld   hl, ramp_len
    add  a, (hl)           ; A = ramp_col + ramp_len
    jr   .compare_plat
.plat_left:
    ld   a, (ramp_col)
    ld   hl, ramp_len
    sub  (hl)              ; A = ramp_col - ramp_len
.compare_plat:
    cp   e                 ; Compare with Col
    jr   nz, .no
    
    ld   a, (ramp_row)
    ld   hl, ramp_len
    sub  (hl)
    inc  a                 ; A = ramp_row - ramp_len + 1
    cp   d                 ; Compare with Row
    jr   z, .yes

.no:
    pop  hl
    pop  bc
    or   a
    ret
    
.yes:
    pop  hl
    pop  bc
    scf
    ret

; -------------------------------------------------------------------
; Verifica se c'è un blocco Wall (tipo 2) alle coordinate pixel (X, Y)
; Input: C = X, B = Y
; Output: Carry flag impostato se è un Wall, altrimenti resettato
; -------------------------------------------------------------------
CheckWallCell:
    push hl
    push de
    push bc
    
    ; 1. Controlla se Y (in B) è fuori dalla griglia di layout
    ld   a, b
    cp   128
    jr   nc, .not_wall
    
    ; 2. Calcola riga di layout: r = Y / 8
    srl  a
    srl  a
    srl  a                 ; A = r (0..15)
    
    ; 3. Calcola colonna di layout: c = X / 8 (in C)
    ld   e, a              ; E = r (Row)
    ld   a, c
    srl  a
    srl  a
    srl  a                 ; A = c (0..31)
    ld   c, a              ; C = c (Col)
    
    ; Se la cella è sulla rampa, non considerarla un muro!
    ld   d, e              ; D = Row
    ld   e, c              ; E = Col
    call IsCellOnRamp
    jr   c, .not_wall
    
    ld   a, d              ; A = Row
    ld   c, e              ; C = Col
    call GetCellFromUnpacked ; A = cell type
    
    ; Controlla se è Wall (2)
    cp   2
    jr   z, .is_wall
    
.not_wall:
    pop  bc
    pop  de
    pop  hl
    or   a                 ; Clear carry
    ret
    
.is_wall:
    pop  bc
    pop  de
    pop  hl
    scf                    ; Set carry
    ret


; -------------------------------------------------------------------
; Controlla se Willy collide orizzontalmente con un Wall alle coordinate specificate
; Input: C = X pixel (da controllare), B = Y pixel (attuale)
; Output: Carry flag impostato se c'è collisione, altrimenti resettato
; -------------------------------------------------------------------
CheckWillyWallCollision:
    push bc
    
    ; 1. Punto superiore: (X, Y)
    call CheckWallCell
    jr   c, .collision
    
    ; 2. Punto medio: (X, Y + 7)
    ld   a, b
    add  a, 7
    ld   b, a
    call CheckWallCell
    jr   c, .collision
    
    ; 3. Punto inferiore: (X, Y + 15)
    pop  bc
    push bc
    ld   a, b
    add  a, 15
    ld   b, a
    call CheckWallCell
    jr   c, .collision
    
    pop  bc
    or   a                 ; Reset carry (nessuna collisione)
    ret
    
.collision:
    pop  bc
    scf                    ; Set carry (collisione avvenuta)
    ret

; -------------------------------------------------------------------
; Decomprime il layout della stanza (128 byte) in un buffer di 512 byte in RAM.
; Ciascuna cella occupa così 1 byte (valore 0..3), consentendo accessi O(1) velocissimi.
; -------------------------------------------------------------------
UnpackRoomLayout:
    push hl
    push de
    push bc
    
    ld   hl, (room_ptr)     ; HL = inizio layout stanza (128 byte)
    ld   de, unpacked_layout ; DE = buffer RAM
    ld   b, 128             ; 128 byte
.byte_loop:
    ld   a, (hl)            ; Leggi byte compresso
    inc  hl
    
    ld   c, a               ; C = salvataggio
    
    ; Cella 0: bit 7-6
    rlca
    rlca
    and  3
    ld   (de), a
    inc  de
    
    ; Cella 1: bit 5-4
    ld   a, c
    rlca
    rlca
    rlca
    rlca
    and  3
    ld   (de), a
    inc  de
    
    ; Cella 2: bit 3-2
    ld   a, c
    rrca
    rrca
    and  3
    ld   (de), a
    inc  de
    
    ; Cella 3: bit 1-0
    ld   a, c
    and  3
    ld   (de), a
    inc  de
    
    djnz .byte_loop
    
    pop  bc
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Legge il tipo di cella dal buffer decompresso in RAM
; Input: A = Row (0..15), C = Col (0..31)
; Output: A = tipo di cella (0..3)
; Preserva tutti gli altri registri.
; -------------------------------------------------------------------
GetCellFromUnpacked:
    push hl
    push de
    
    ld   l, a
    ld   h, 0
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl            ; HL = Row * 32
    ld   e, c
    ld   d, 0
    add  hl, de            ; HL = Row * 32 + Col
    ld   de, unpacked_layout
    add  hl, de
    ld   a, (hl)           ; A = cell type
    
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; GetRampY
; Calcola la coordinata Y teorica di Willy se si trova sulla rampa
; Input: C = PlayerX
; Output: Carry flag impostato se PlayerX è nel range della rampa,
;         in tal caso A = PlayerY (Y teorico del player sulla rampa)
; -------------------------------------------------------------------
GetRampY:
    ld   a, (ramp_len)
    or   a
    ret  z                 ; Se non c'è rampa (len=0), return carry clear
    
    ld   a, (ramp_dir)
    or   a
    jr   z, .dir_left
    
.dir_right:
    ; Rampa sale a destra (up-right)
    ld   a, (ramp_col)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8 (X start in pixel)
    ld   e, a              ; E = X_left
    
    ld   a, (ramp_len)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, e              ; A = (ramp_col + ramp_len) * 8 = X_right_boundary
    ld   h, a              ; H = X_right_boundary
    jr   c, .no_right_bound_check_right
    
    ld   a, c              ; A = PlayerX
    cp   e
    jp   c, .out_of_ramp   ; Se PlayerX < X_left, fuori
    
    cp   h
    jr   c, .on_ramp_slope ; Se PlayerX < X_right_boundary, pendenza rampa
    
    ; Controlla se è sulla cella della piattaforma adiacente in cima: [X_right_boundary, X_right_boundary + 7]
    sub  h                 ; A = PlayerX - X_right_boundary
    cp   8
    jp   nc, .out_of_ramp  ; Se PlayerX >= X_right_boundary + 8, fuori
    jr   .on_platform_right
    
.no_right_bound_check_right:
    ld   a, c              ; A = PlayerX
    cp   e
    jp   c, .out_of_ramp   ; Se PlayerX < X_left, fuori
    jr   .on_ramp_slope    ; Se >= X_left, è sicuramente sulla pendenza rampa (non può superare 256)
    
.on_platform_right:
    ; Piattaforma adiacente! Restituisci PlayerY = (ramp_row - ramp_len + 1) * 8 - 16
    ld   a, (ramp_row)
    ld   hl, ramp_len
    sub  (hl)
    inc  a                 ; A = Row
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    sub  16                ; A = Row * 8 - 16
    scf                    ; Set carry (dentro rampa/piattaforma)
    ret
    
.on_ramp_slope:
    ld   a, (ramp_row)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    sub  16                ; A = ramp_row * 8 - 16
    add  a, e              ; A = ramp_row * 8 - 16 + X_left
    sub  c                 ; A = A - PlayerX
    ld   d, a              ; D = calculated Y
    
    ; H = platform_Y + 16 (confronto sicuro con offset +16)
    ld   a, (ramp_row)
    ld   hl, ramp_len
    sub  (hl)
    inc  a                 ; A = Row
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   h, a              ; H = platform_Y + 16
    
    ld   a, d              ; A = calculated Y
    add  a, 16             ; A = calculated Y + 16
    cp   h                 ; Compare (calculated Y + 16) con (platform_Y + 16)
    jr   nc, .no_clamp     ; Se calculated Y >= platform_Y, non limitare
    
    ; Altrimenti, limita a platform_Y
    ld   a, h
    sub  16                ; A = platform_Y
    scf
    ret
    
.no_clamp:
    ld   a, d              ; Ripristina A = calculated Y
    scf                    ; Set carry
    ret
    
.dir_left:
    ; Rampa sale a sinistra (up-left)
    ld   a, (ramp_col)
    inc  a                 ; A = ramp_col + 1
    ld   hl, ramp_len
    cp   (hl)              ; Compare (ramp_col + 1) con ramp_len
    jp   c, .out_of_ramp   ; Se ramp_len > ramp_col + 1, evita underflow!
    sub  (hl)              ; A = ramp_col - ramp_len + 1
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   e, a              ; E = X_left
    
    ld   a, (ramp_col)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, 8              ; A = (ramp_col + 1) * 8 (X_right_boundary)
    ld   h, a              ; H = X_right_boundary
    jr   c, .no_right_bound_check_left
    
    ld   a, c              ; A = PlayerX
    cp   h
    jp   nc, .out_of_ramp  ; Se PlayerX >= X_right_boundary, fuori
    
.no_right_bound_check_left:
    ld   a, c              ; A = PlayerX
    cp   e
    jr   nc, .on_ramp_slope_left ; Se PlayerX >= X_left, pendenza rampa
    
    ; Controlla se è sulla cella della piattaforma adiacente in cima a sinistra: [X_left - 8, X_left - 1]
    ld   a, e              ; A = X_left
    sub  c                 ; A = X_left - PlayerX
    cp   9
    jp   nc, .out_of_ramp  ; Se PlayerX <= X_left - 9, fuori
    
    ; Piattaforma adiacente a sinistra! Restituisci PlayerY = (ramp_row - ramp_len + 1) * 8 - 16
    ld   a, (ramp_row)
    ld   hl, ramp_len
    sub  (hl)
    inc  a                 ; A = Row
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    sub  16                ; A = Row * 8 - 16
    scf                    ; Set carry
    ret
    
.on_ramp_slope_left:
    ld   a, (ramp_col)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   d, a              ; D = X_start
    
    ld   a, (ramp_row)
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    sub  16                ; A = ramp_row * 8 - 16
    sub  d                 ; A = ramp_row * 8 - 16 - X_start
    add  a, c              ; A = A + PlayerX
    ld   d, a              ; D = calculated Y
    
    ; H = platform_Y + 16 (confronto sicuro con offset +16)
    ld   a, (ramp_row)
    ld   hl, ramp_len
    sub  (hl)
    inc  a                 ; A = Row
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    ld   h, a              ; H = platform_Y + 16
    
    ld   a, d              ; A = calculated Y
    add  a, 16             ; A = calculated Y + 16
    cp   h                 ; Compare (calculated Y + 16) con (platform_Y + 16)
    jr   nc, .no_clamp_left ; Se calculated Y >= platform_Y, non limitare
    
    ; Altrimenti, limita a platform_Y
    ld   a, h
    sub  16                ; A = platform_Y
    scf
    ret
    
.no_clamp_left:
    ld   a, d
    scf
    ret

.out_of_ramp:
    or   a                 ; Clear carry
    ret

; -------------------------------------------------------------------
; Carica le impostazioni di salto e gravità specifiche per la stanza corrente
; Legge il byte di configurazione ad offset OFFSET_PHYSICS_SETTINGS (239).
; Se è 0, applica le impostazioni di default (Jump = 6, Gravity = 1).
; Altrimenti, decodifica il formato %GGGGJJJJ (Jump = JJJJ, Gravity Preset = GGGG).
; -------------------------------------------------------------------
Phys_LoadRoomSettings:
    push hl
    push de
    push af

    ld   hl, (room_ptr)
    ld   de, OFFSET_PHYSICS_SETTINGS
    add  hl, de
    ld   a, (hl)
    or   a
    jr   nz, .custom_settings
    
    ld   a, DEFAULT_JUMP_STRENGTH
    ld   (room_jump_strength), a
    ld   a, DEFAULT_GRAVITY_PRESET
    ld   (room_gravity_preset), a
    jr   .done
    
.custom_settings:
    push af
    and  $0f                  ; Maschera i 4 bit inferiori (JJJJ)
    ld   (room_jump_strength), a
    pop  af
    srl  a
    srl  a
    srl  a
    srl  a                  ; Sposta i 4 bit superiori in quelli inferiori (GGGG)
    ld   (room_gravity_preset), a

.done:
    pop  af
    pop  de
    pop  hl
    ret

; -------------------------------------------------------------------
; Verifica se c'è una cella Nasty (tipo 3) alle coordinate pixel (X, Y)
; Input: C = X, B = Y
; Output: Carry flag impostato se è Nasty, altrimenti resettato
; -------------------------------------------------------------------
CheckNastyCell:
    push hl
    push de
    push bc
    
    ; 1. Controlla se Y (in B) è fuori dalla griglia di layout
    ld   a, b
    cp   128
    jr   nc, .not_nasty
    
    ; 2. Calcola riga di layout: r = Y / 8
    srl  a
    srl  a
    srl  a                 ; A = r (0..15)
    
    ; 3. Calcola colonna di layout: c = X / 8 (in C)
    ld   e, a              ; E = r
    ld   a, c
    srl  a
    srl  a
    srl  a                 ; A = c (0..31)
    ld   c, a              ; C = c
    ld   a, e              ; A = r
    
    call GetCellFromUnpacked ; A = cell type
    
    ; Controlla se è Nasty (3)
    cp   3
    jr   z, .is_nasty
    
.not_nasty:
    pop  bc
    pop  de
    pop  hl
    or   a                 ; Clear carry
    ret
    
.is_nasty:
    pop  bc
    pop  de
    pop  hl
    scf                    ; Set carry
    ret

; -------------------------------------------------------------------
; Controlla la collisione di Willy con le celle Nasty (tipo 3)
; Controlla 6 punti strategici della bounding box di Willy (16x8 pixel)
; Output: Carry flag impostato se c'è collisione, altrimenti resettato
; -------------------------------------------------------------------
Phys_CheckNastyCollision:
    push bc
    
    ld   bc, (PlayerPos)   ; B = Y, C = X
    
    ; Punto 1: Top-Left (X, Y)
    call CheckNastyCell
    jr   c, .collision
    
    ; Punto 2: Top-Right (X + 7, Y)
    ld   a, c
    add  a, 7
    ld   c, a
    call CheckNastyCell
    jr   c, .collision
    
    ; Punto 3: Mid-Left (X, Y + 7)
    ld   bc, (PlayerPos)
    ld   a, b
    add  a, 7
    ld   b, a
    call CheckNastyCell
    jr   c, .collision
    
    ; Punto 4: Mid-Right (X + 7, Y + 7)
    ld   a, c
    add  a, 7
    ld   c, a
    call CheckNastyCell
    jr   c, .collision
    
    ; Punto 5: Bottom-Left (X, Y + 15)
    ld   bc, (PlayerPos)
    ld   a, b
    add  a, 15
    ld   b, a
    call CheckNastyCell
    jr   c, .collision
    
    ; Punto 6: Bottom-Right (X + 7, Y + 15)
    ld   a, c
    add  a, 7
    ld   c, a
    call CheckNastyCell
    jr   c, .collision
    
    pop  bc
    or   a                 ; Clear carry
    ret
    
.collision:
    pop  bc
    scf                    ; Set carry
    ret
