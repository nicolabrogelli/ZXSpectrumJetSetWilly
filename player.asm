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
    ld   a, c
    sub  2                 ; Prova a muoverti di 2 pixel a sinistra
    cp   PLAYER_MIN_X      ; Confronta con il limite sinistro
    jr   c, .clamp_left    ; Se < PLAYER_MIN_X, clampa
    ld   c, a              ; Altrimenti memorizza la nuova posizione
    jr   save_x

.clamp_left:
    ld   c, PLAYER_MIN_X
    jr   save_x

movePlayer_right:
    ld   a, c
    add  a, 2              ; Prova a muoverti di 2 pixel a destra
    cp   PLAYER_MAX_X      ; Confronta con il limite destro
    jr   z, .ok_right      ; Se == PLAYER_MAX_X, va bene
    jr   nc, .clamp_right  ; Se > PLAYER_MAX_X (senza carry, cioè maggiore), clampa
.ok_right:
    ld   c, a              ; Altrimenti memorizza la nuova posizione
    jr   save_x

.clamp_right:
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