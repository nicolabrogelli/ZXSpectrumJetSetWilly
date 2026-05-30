;===========================================================================
; input.asm
;===========================================================================


; -------------------------------------------------------------------
; Controlla input tastiera
; Output: D = tasti premuti
; -------------------------------------------------------------------
CheckCtrl:
    ld  d, $00
    ld  a, $fe
    in  a, ($fe)
    ld  ix,flags

checkCtrl_left:
    bit $01, a
    jr  nz, checkCtrl_right
    set $00, d
    set 0,(ix)
    ld  e, a
    ld  a, 1
    ld  (direction), a
    ld  a, e
    
checkCtrl_right:
    bit $02, a
    jr  nz, checkCtrl_jump
    set $01, d
    set 0,(ix)
    ld  e, a
    ld  a, 2
    ld  (direction), a
    ld  a, e

checkCtrl_jump:
    ; Controlla tasto P (Porta $DF, Bit 0)
    ld  a, $df
    in  a, ($fe)
    bit 0, a
    jr  z, .pressed   ; Se P è premuto (bit 0 = 0)

    ; Controlla tasto M (Porta $7F, Bit 2)
    ld  a, $7f
    in  a, ($fe)
    bit 2, a
    jr  z, .pressed   ; Se M è premuto (bit 2 = 0)

.released:
    xor a
    ld  (jump_prev), a
    jr  .end

.pressed:
    ld  a, (jump_prev)
    or  a
    jr  nz, .end
    ld  a, 1
    ld  (jump_pressed), a
    ld  (jump_prev), a
    set 2, d

.end:
    ld   a, d
    and  $03
    sub  $03
    ret  nz
    ld   a, d
    and  $04
    ld   d, a
    ret