;===========================================================================z
; player.asm
;===========================================================================


; -------------------------------------------------------------------
; Muove il player
; Input: D = stato controlli
; -------------------------------------------------------------------
MovePlayer:
    ; Verifica se un tasto di movimento è premuto
    ld   ix, flags
    bit  $00, (ix)
    ret  z
    res  $00, (ix)

    ld   bc, (PlayerPos)   ; C = PlayerX (pixel), B = PlayerY (pixel)
    
    bit  $01, d            ; Tasto Destra premuto?
    jr   nz, movePlayer_right

    bit  $00, d            ; Tasto Sinistra premuto?
    ret  z

movePlayer_left:
    ld   a, (player_speed)
    ld   e, a
    ld   a, c
    sub  e                 ; Prova a muoverti a sinistra
    cp   PLAYER_MIN_X      ; Confronta con il limite sinistro
    jr   c, .clamp_left    ; Se < PLAYER_MIN_X, clampa
    
    ; Controlla collisione con Wall a sinistra
    push bc
    ld   c, a              ; C = nuova coordinata X da testare
    call CheckWillyWallCollision
    pop  bc
    jr   c, save_x         ; Se collide, mantieni la posizione precedente
    
    ld   a, (player_speed)
    ld   e, a
    ld   a, c
    sub  e
    ld   c, a              ; Altrimenti memorizza la nuova posizione
    jr   save_x

.clamp_left:
    push bc
    ld   c, PLAYER_MIN_X
    call CheckWillyWallCollision
    pop  bc
    jr   c, save_x         ; Se collide al limite, mantieni la posizione precedente
    
    ld   c, PLAYER_MIN_X
    jr   save_x

movePlayer_right:
    ld   a, (player_speed)
    ld   e, a
    ld   a, c
    add  a, e              ; Prova a muoverti a destra
    cp   PLAYER_MAX_X      ; Confronta con il limite destro
    jr   z, .ok_right      ; Se == PLAYER_MAX_X, va bene
    jr   nc, .clamp_right  ; Se > PLAYER_MAX_X, clampa
.ok_right:
    ; Controlla collisione con Wall a destra (coordinata X destra = X + 15)
    push bc
    add  a, 15
    ld   c, a              ; C = coordinata X destra da testare
    call CheckWillyWallCollision
    pop  bc
    jr   c, save_x         ; Se collide, mantieni la posizione precedente
    
    ld   a, (player_speed)
    ld   e, a
    ld   a, c
    add  a, e
    ld   c, a              ; Altrimenti memorizza la nuova posizione
    jr   save_x

.clamp_right:
    push bc
    ld   a, PLAYER_MAX_X
    add  a, 15
    ld   c, a
    call CheckWillyWallCollision
    pop  bc
    jr   c, save_x         ; Se collide al limite, mantieni la posizione precedente
    
    ld   c, PLAYER_MAX_X

save_x:
    ld   (PlayerPos), bc

movePlayer_print:
    ; Alterna lo stato delle gambe ad ogni movimento (0, 1, 2, 0, 1, 2...)
    ld   a, (body_state)
    inc  a
    cp   3
    jr   nz, .save_state
    ld   a, 0
.save_state:
    ld   (body_state), a
    ret


; -------------------------------------------------------------------
; Carica la posiziona il Player nella stanza
; -------------------------------------------------------------------
LoadPositionPlayeinRoom:
    ; Carica la posizione iniziale di Willy definita nei dati della stanza
    ld   hl, (room_ptr)
    ld   de, OFFSET_POS_WILLY
    add  hl, de
    ld   a, (hl)           ; A = Willy X
    inc  hl
    ld   h, (hl)           ; H = Willy Y
    ld   l, a              ; HL = Willy position (Y, X)
    ld   (PlayerPos), hl
    ld   (PlayerPosOld), hl
    ret