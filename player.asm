;===========================================================================
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
    sub  4                 ; Prova a muoverti di 4 pixel a sinistra
    cp   24                ; Confronta con il limite sinistro (24)
    jr   c, .clamp_left    ; Se < 24, clampa a 24
    ld   c, a              ; Altrimenti memorizza la nuova posizione
    jr   save_x

.clamp_left:
    ld   c, 24
    jr   save_x

movePlayer_right:
    ld   a, c
    add  a, 4              ; Prova a muoverti di 4 pixel a destra
    cp   231               ; Confronta con il limite destro (231)
    jr   z, .ok_right      ; Se == 231, va bene
    jr   nc, .clamp_right  ; Se > 231 (senza carry, cioè maggiore), clampa a 231
.ok_right:
    ld   c, a              ; Altrimenti memorizza la nuova posizione
    jr   save_x

.clamp_right:
    ld   c, 231

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