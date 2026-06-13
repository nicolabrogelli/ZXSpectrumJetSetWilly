;===========================================================================
; physics.asm
;===========================================================================

    
; -------------------------------------------------------------------
; Verifica se c'è una cella solida (Floor o Wall) alle coordinate pixel (X, Y)
; Input: C = X, B = Y
; Output: Carry flag impostato se solida, altrimenti resettato
; -------------------------------------------------------------------
CheckSolidCell:
    push hl
    push de
    push bc
    
    ; 1. Controlla se Y (in B) è fuori dalla griglia di layout (Y < 24 o Y >= 152)
    ld   a, b
    cp   24
    jr   c, .not_solid
    cp   152
    jr   nc, .not_solid
    
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
    
    ; 4. Calcola colonna di layout: c = X / 8 (in C)
    ld   a, c
    srl  a
    srl  a
    srl  a                 ; A = c (0..31)
    ld   c, a              ; C = c (salva colonna)
    
    ; HL = r * 8 + c / 4
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
    ; Case 3 (c % 4 = 3)
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
ApplyGravity:
    ld  bc, (PlayerPos)
    ld  a, b              ; B = PlayerY (pixel)
    
    ; Controlla se siamo a mezz'aria (on_ground == 0)
    ld  a, (on_ground)
    or  a
    jp  z, .in_air        ; Se siamo in volo, continua a volare
    
    ; Se on_ground == 1, controlliamo se siamo ancora su terreno solido
    ; Dobbiamo controllare i pixel direttamente sotto i piedi del player:
    ; (PlayerX, PlayerY + 16) e (PlayerX + 7, PlayerY + 16)
    ld  a, b
    add  a, 16
    ld  b, a              ; B = PlayerY + 16
    
    ; Controlla se la cella sotto il piede sinistro (PlayerX, PlayerY + 16) è solida
    call CheckSolidCell
    jr   c, .still_on_ground
    
    ; Controlla se la cella sotto il piede destro (PlayerX + 7, PlayerY + 16) è solida
    ld   a, c
    add  a, 7
    ld   c, a              ; C = PlayerX + 7
    call CheckSolidCell
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
    
    ld   a, JUMP_STRENGTH
    ld   (velocity_y), a
    xor  a
    ld   (on_ground), a
    ld   (jump_pressed), a
    jp   .in_air

.in_air:
    ; Applica gravità
    ld  a, (velocity_y)
    sub GRAVITY           ; gravity = 2
    
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

    ; Controlla se stiamo cadendo (velocity_y <= 0)
    ld  a, (velocity_y)
    bit 7, a              ; Se negativo, bit 7 = 1
    jr  nz, .falling_checks
    or  a                 ; Se zero
    jr  z, .falling_checks
    jr  .no_collision_checks ; Se stiamo salendo, non controlliamo collisioni
    
.falling_checks:
    ; --- CONTROLLO COLLISIONE CON IL TERRENO DURANTE LA CADUTA ---
    ld   a, b
    add  a, 16
    ld   b, a              ; B = Nuovo Y + 16
    
    ; Controlla se il piede sinistro tocca solido
    call CheckSolidCell
    jr   c, .check_landing
    
    ; Controlla se il piede destro tocca solido
    ld   a, c
    add  a, 7
    ld   c, a              ; C = PlayerX + 7
    call CheckSolidCell
    jr   c, .check_landing
    
    ; Nessun atterraggio
    jr   .no_collision_checks

.check_landing:
    ; Abbiamo toccato una cella solida!
    ld   a, b
    sub  24
    srl  a
    srl  a
    srl  a                 ; A = r (0..15)
    
    ; Controlliamo se Vecchio Y + 16 <= r * 8 + 24
    ld   e, a              ; E = r
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, 24             ; A = r * 8 + 24 (limite superiore della riga)
    ld   d, a              ; D = limite superiore
    
    ; Vecchio Y + 16
    ld   a, (PlayerPos+1)  ; A = Vecchio Y
    add  a, 16             ; A = Vecchio Y + 16
    
    cp   d                 ; Confronta Vecchio Y + 16 con il limite
    jr   z, .do_landing    ; Se ==, atterra
    jr   c, .do_landing    ; Se <, atterra (eravamo sopra)
    
    jr   .no_collision_checks

.do_landing:
    ; Atterra sulla riga di layout E!
    ld   a, e
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, 8              ; A = PlayerY di atterraggio
    
    ld   bc, (PlayerPos)   ; Ripristina C = PlayerX
    ld   b, a              ; B = Nuovo PlayerY
    
    ld   (PlayerPos), bc
    ld   a, 1
    ld   (on_ground), a
    xor  a
    ld   (velocity_y), a
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
    cp   8
    jr   nc, .save_ok
    ld   b, 8
    xor  a
    ld   (velocity_y), a

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
    ld   b, 4              ; 4 slot
.loop:
    ld   a, (ix+0)         ; Flags
    and  $80               ; Active?
    jr   z, .next
    
    ; 1. Controllo orizzontale: PlayerX - EnemyX + 7 in [0, 22]
    ld   a, (PlayerPos)    ; A = PlayerX
    sub  (ix+1)            ; A = PlayerX - EnemyX
    add  a, 7              ; A = PlayerX - EnemyX + 7
    cp   23                ; Se >= 23, nessuna collisione con questo
    jr   nc, .next
    
    ; 2. Controllo verticale: PlayerY - EnemyY + 15 in [0, 30]
    ld   a, (PlayerPos+1)  ; A = PlayerY
    sub  (ix+2)            ; A = PlayerY - EnemyY
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
    ld   de, 8
    add  ix, de            ; Prossimo slot
    dec  b
    jr   nz, .loop
    
    pop  ix
    pop  bc
    pop  de
    pop  hl
    or   a                 ; Reset carry flag
    ret
