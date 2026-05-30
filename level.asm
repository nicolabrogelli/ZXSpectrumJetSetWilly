; -------------------------------------------------------------------
; Disegna i bordi verticali sinistro e destro
; Input: B = riga di partenza, C = numero di righe
; Modifica: A, B, C, D, E
; -------------------------------------------------------------------
DrawVerticalBorders:
    push bc
    push de
    
    ld d, b          ; D = riga di partenza
    ld e, c          ; E = contatore righe
    
.draw_loop:
    ; Bordo sinistro
    ld b, d          ; B = riga corrente
    ld c, COR_X - MIN_X  ; C = colonna 0 (sinistra)
    call At          ; Posiziona cursore
    ld a, VERTICAL_BORDER
    rst $10          ; Disegna carattere
    
    ; Bordo destro
    ld c, COR_X - MAX_X  ; C = colonna 31 (destra)
    call At          ; Posiziona cursore
    ld a, VERTICAL_BORDER
    rst $10          ; Disegna carattere
    
    ; Prossima riga
    inc d
    dec e
    jr nz, .draw_loop
    
    pop de
    pop bc
    ret


; -------------------------------------------------------------------
; Disegna bordi verticali in una zona specifica
; Per esempio: dalla riga 5 alla riga 20
; -------------------------------------------------------------------
DrawGameAreaBorders:
    ; Bordo sinistro
    ld b, 5           ; Riga di partenza
    ld c, 16          ; Numero di righe
    ld e, COR_X - MIN_X  ; Colonna sinistra
    
.left_border_loop:
    push bc
    ld c, e
    call At
    ld a, VERTICAL_BORDER
    rst $10
    pop bc
    inc b
    dec c
    jr nz, .left_border_loop
    
    ; Bordo destro
    ld b, 5           ; Riga di partenza
    ld c, 16          ; Numero di righe
    ld e, COR_X - MAX_X  ; Colonna destra
    
.right_border_loop:
    push bc
    ld c, e
    call At
    ld a, VERTICAL_BORDER
    rst $10
    pop bc
    inc b
    dec c
    jr nz, .right_border_loop
    
    ret