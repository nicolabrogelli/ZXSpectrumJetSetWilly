;===========================================================================
; input.asm
;===========================================================================


; -------------------------------------------------------------------
; Input_CheckCtrl
; Legge la tastiera e popola il registro D con i flag di input.
;
; Output:
;   D = bitmask tasti attivi:
;       bit 0 → sinistra (O)
;       bit 1 → destra   (P)
;       bit 2 → salto    (Z)
;
; Effetti collaterali in RAM:
;   (q_prev)        → debounce tasto Q (cambio stanza)
;   (direction)     → 1=sinistra, 2=destra (ultimo movimento)
;   (jump_prev)     → debounce tasto salto
;   (jump_pressed)  → flag "salto appena premuto" (edge detection)
;   (flags)         → bit 0 impostato se movimento rilevato
; -------------------------------------------------------------------

Input_CheckCtrl:
    xor  a
    ld   (current_input_dir), a

    ; ── Sezione 1: tasto Q (cambio stanza) ──────────────────────────
    ;
    ; Porta $FB → riga Q, W, E, R, T. Bit 0 = Q.
    ; Se bit 0 = 0, Q è premuto.

    ld   a, $fb
    in   a, ($fe)
    bit  0, a
    jr   nz, .q_not_pressed     ; bit 0 = 1 → Q non premuto, salta

    ; Q è premuto: debounce tramite (q_prev).
    ; Se (q_prev) ≠ 0 il tasto era già giù nel frame precedente → ignora.
    ld   a, (q_prev)
    or   a
    jr   nz, .q_handled         ; era già premuto, niente da fare

    ; ── Primo frame di pressione di Q ──
    ld   a, 1
    ld   (q_prev), a            ; marca "Q era premuto"

    ; NOTA sullo stack:
    ; Input_CheckCtrl è stata invocata con CALL, quindi l'indirizzo di ritorno
    ; è in cima allo stack. Vogliamo saltare a PerformRoomChange senza
    ; tornare al chiamante, quindi POP HL scarta quell'indirizzo,
    ; poi JP salta direttamente.
    pop  hl                     ; rimuove indirizzo di ritorno di Input_CheckCtrl
    jp   PerformRoomChange      ; salta al cambio stanza (non torna qui)

.q_not_pressed:
    xor  a
    ld   (q_prev), a            ; Q rilasciato → azzera debounce

.q_handled:

    ; ── Sezione 2: movimento (sinistra / destra) ────────────────────
    ;
    ; Porta $DF → riga P, O, I, U, Y.
    ; Bit 0 = P (destra), Bit 1 = O (sinistra).

    ld  d, $00                  ; azzera output
    ld  a, $df
    in  a, ($fe)                ; legge riga $FE

    ; Se Willy è sul conveyor nella stanza The Off Licence (room 0),
    ; impedisci lo spostamento da sinistra a destra (disabilita tasto destra P / bit 0).
    push af
    ld   a, (current_room)
    or   a                      ; Room 0 = The Off Licence
    jr   nz, .no_block_conveyor
    call CheckWillyOnConveyor
    jr   nc, .no_block_conveyor
    pop  af
    or   $01                    ; Forza bit 0 (destra) a 1 (non premuto)
    push af
.no_block_conveyor:
    pop  af

    ld  ix, flags               ; IX punta alla variabile flags

checkCtrl_left:
    bit $01, a                  ; bit 1 = O → sinistra?
    jr  nz, checkCtrl_right     ; bit = 1 → O non premuto, prova destra
    set $00, d                  ; imposta bit 0 di D = "sinistra attiva"
    set 0, (ix)                 ; flags bit 0 = "movimento in corso"
    ld  e, a                    ; salva A
    ld  a, 1
    ld  (current_input_dir), a
    ld  a, (on_ground)
    or  a
    jr  z, .skip_dir_left
    ld  a, 1
    ld  (direction), a          ; direction = 1 → sinistra
.skip_dir_left:
    ld  a, e                    ; ripristina A

checkCtrl_right:
    bit $00, a                  ; bit 0 = P → destra?
    jr  nz, checkCtrl_jump      ; bit = 1 → P non premuto, prova salto
    set $01, d                  ; imposta bit 1 di D = "destra attiva"
    set 0, (ix)                 ; flags bit 0 = "movimento in corso"
    ld  e, a
    ld  a, 2
    ld  (current_input_dir), a
    ld  a, (on_ground)
    or  a
    jr  z, .skip_dir_right
    ld  a, 2
    ld  (direction), a          ; direction = 2 → destra
.skip_dir_right:
    ld  a, e

checkCtrl_jump:

    ; ── Sezione 3: salto (Z) ────────────────────────────────────────
    ;
    ; Salto su Z.
    ;
    ; Z → porta $FE, bit 1  (riga CAPS, Z, X, C, V)

    ld  a, $fe
    in  a, ($fe)
    bit 1, a
    jr  z, .pressed             ; bit 1 = 0 → Z premuto

.released:
    ; Nessun tasto di salto premuto: azzera debounce.
    xor a
    ld  (jump_prev), a
    jr  .end

.pressed:
    ; Tasto salto premuto: edge detection.
    ; Se (jump_prev) ≠ 0 era già premuto nel frame precedente → ignora.
    ld  a, (jump_prev)
    or  a
    jr  nz, .end
    ; Primo frame di pressione:
    ld  a, 1
    ld  (jump_pressed), a       ; segnala "salto appena scattato"
    ld  (jump_prev), a          ; marca come già premuto (debounce)
    set 2, d                    ; imposta bit 2 di D = "salto attivo"

.end:

    ; ── Sezione 4: filtro "entrambe le direzioni" ───────────────────
    ;
    ; Se O e P sono premuti insieme i movimenti si annullano:
    ; azzera entrambi i bit di direzione, mantieni solo l'eventuale salto.
    ;
    ;   A = D AND $03   → isola bit 0 (sinistra) e bit 1 (destra)
    ;   A - $03         → zero solo se entrambi attivi
    ;   RET NZ          → non entrambi attivi → ritorna con D intatto
    ;
    ;   (cade qui solo se O e P premuti insieme)
    ;   A = D AND $04   → tieni solo bit 2 (salto)
    ;   D = A           → direzioni cancellate, salto conservato

    ld   a, d
    and  $03                    ; isola bit 0 e bit 1 (direzioni)
    sub  $03                    ; zero se e solo se entrambi attivi
    ret  nz                     ; non entrambi → ritorna con D com'è

    ld   a, d
    and  $04                    ; tieni solo il bit 2 (salto)
    ld   d, a                   ; D = solo salto, direzioni azzerate
    xor  a
    ld   (current_input_dir), a
    ret

; -------------------------------------------------------------------
; Esegue il cambio di stanza ciclico alla stanza successiva
; -------------------------------------------------------------------
PerformRoomChange:
    ; 1. Cerca il layout corrente in RoomsListTable per trovare l'indice (0..45)
    ld   hl, RoomsListTable
    ld   bc, (room_ptr)            ; BC = layout corrente
    ld   e, 0                      ; E = contatore indice
.loop:
    ld   a, (hl)
    inc  hl
    cp   c
    jr   nz, .no_match
    ld   a, (hl)
    cp   b
    jr   z, .found
.no_match:
    inc  hl
    inc  e
    ld   a, e
    cp   46                        ; 46 stanze totali (indice 0..45)
    jr   c, .loop
    
    ld   e, 0                      ; Se non trovato, riparte da 0

.found:
    ; 2. Trova il prossimo indice non nullo (ciclando)
    ld   c, e                      ; C = indice di partenza
.next_index_loop:
    ld   a, c
    inc  a
    cp   46
    jr   c, .no_wrap
    xor  a
.no_wrap:
    ld   c, a                      ; C = nuovo indice candidato
    
    ; Leggi RoomsListTable[C]
    push hl
    ld   hl, RoomsListTable
    ld   e, c
    ld   d, 0
    add  hl, de
    add  hl, de                    ; HL = RoomsListTable + C * 2
    ld   e, (hl)
    inc  hl
    ld   d, (hl)                   ; DE = RoomsListTable[C]
    ld   a, d
    or   e                         ; DE == 0?
    pop  hl
    jr   z, .next_index_loop       ; Se è zero, riprova col prossimo
    
    ; Trovato! DE = layout
    ld   (room_ptr), de
    
    ; 4. Pulisci lo schermo e ricarica la stanza
    ld   hl, ATTR_P
    ld   (hl), $07
    call CLS
    
    jp   LoadRoomAndRestart

TriggerRoomChange:
    ; Input: A = nuovo room ID, C = Willy X, B = Willy Y
    ld   (PlayerPos), bc
    ld   (PlayerPosOld), bc
    
    ; Reset velocity_y
    ld   hl, velocity_y
    ld   (hl), 0
    
    ; Trova l'indirizzo del layout corrispondente da RoomsListTable
    ld   hl, RoomsListTable
    ld   c, a
    ld   b, 0
    add  hl, bc
    add  hl, bc                    ; HL = RoomsListTable + A * 2
    
    ld   e, (hl)
    inc  hl
    ld   d, (hl)                   ; DE = puntatore al layout della nuova stanza
    
    ld   (room_ptr), de            ; Aggiorna room_ptr
    
    ; Imposta il flag di transizione per non caricare la posizione di default
    ld   a, 1
    ld   (transition_active), a
    
    ; Pulisci lo schermo
    ld   hl, ATTR_P
    ld   (hl), $07
    call CLS
    
    ; Pulisci lo stack (rimuove il ritorno alla routine chiamante dal Main_loop)
    pop  hl
    jp   LoadRoomAndRestart

RoomsListTable:
    dw TheOffLicenceLayout              ; 0
    dw TheBridgeLayout                  ; 1
    dw UnderTheMegaTreeLayout           ; 2
    dw AtTheFootTheMegaTreeLayout       ; 3
    dw TheDriveLayout                   ; 4
    dw TheSecurityGuardLayout           ; 5
    dw EntranceToHadesLayout            ; 6
    dw CuckoosNestLayout                ; 7
    dw InsideTheMegaTrunkLayout         ; 8
    dw OnABranchOverTheDriveLayout      ; 9
    dw TheFrontDoorLayout               ; 10
    dw TheHallLayout                    ; 11
    dw TreeTopLayout                    ; 12
    dw OutALimbLayout                   ; 13
    dw RescueEsmereldaLayout            ; 14
    dw IAmSureIHaveSeenThiBeforeLayout  ; 15
    dw WeMustPerformQuirkafleegLayout   ; 16
    dw UpOnTheBattlementsLayout         ; 17
    dw OntheRoofLayout                  ; 18
    dw TheForgottenAbbeyLayout          ; 19
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0    ; 20-32: padding
    dw TheBathroomLayout                ; 33
    dw 0                                ; 34
    dw MastreBedRoomLayout              ; 35
    dw 0,0,0,0,0,0,0,0,0                ; 36-44: padding
    dw UnderTheDriveLayout              ; 45
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0    ; 46 - 60
