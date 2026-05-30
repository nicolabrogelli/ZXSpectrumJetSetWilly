;===========================================================================
; screen.asm
;===========================================================================

    
; -------------------------------------------------------------------
; Disegna cornice
; -------------------------------------------------------------------
;PrintFrame:
;    ld   hl, frameTopGraph
;    ld   b, frameEnd - frameTopGraph
;    call PrintString;
;
;    ld   b, COR_Y - $01
;printFrame_loop:
;    ld   c, COR_X - MIN_X
;    call At
;    ld   a, $99
;    rst  $10

;    ld   c, COR_X - MAX_X
;    call At
;    ld   a, $9a
;   rst  $10

;    dec  b
;    ld   a, COR_Y - MAX_Y + $01
;    sub  b
;    jr   nz, printFrame_loop
;    ret


PrintFrame:
    ; Disegna il bordo superiore
    ld   hl, frameTopGraph
    ld   b, frameEnd - frameTopGraph
    call PrintString
    
    ; Disegna i bordi verticali per 16 righe
    ld   b, COR_Y - $01        ; B = riga di partenza (line 1)
    ld   c, 16                 ; C = 16 righe
    call DrawVerticalBorders
    
    ; Disegna il bordo inferiore
    ld   hl, frameBottomGraph
    ld   b, frameEnd - frameBottomGraph
    call PrintString
    
    ret

; -------------------------------------------------------------------
; Disegna info gioco
; -------------------------------------------------------------------
PrintInfoGame:
    ld   a, $01
    call OPENCHAN
    ld   hl, infoGame
    ld   b, infoGame_end - infoGame
    call PrintString
    ld   a, $02
    call OPENCHAN
    ret

; -------------------------------------------------------------------
; Dati cornice
; -------------------------------------------------------------------
frameTopGraph:
    db $16, $00, $00, $10, $01
    db $96, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97
    db $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97, $97
    db $97, $97, $97, $97, $97, $98

frameBottomGraph:
    db $16, $14, $00
    db $9b, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c
    db $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c
    db $9c, $9c, $9c, $9c, $9c, $9d
frameEnd:

infoGame:
    db $10, $03, $16, $00, $00
    db 'Lives   Points   Level   Enemies'
infoGame_end: