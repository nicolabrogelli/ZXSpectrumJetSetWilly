;===========================================================================
; input.asm
;===========================================================================


; -------------------------------------------------------------------
; Controlla input tastiera
; Output: D = tasti premuti
; -------------------------------------------------------------------
CheckCtrl:
    ; --- Controlla tasto Q per cambio stanza ciclico ---
    ld   a, $fb
    in   a, ($fe)
    bit  0, a
    jr   nz, .q_not_pressed
    
    ; Q è premuto! Controlla se era già premuto nel frame precedente
    ld   a, (q_prev)
    or   a
    jr   nz, .q_handled    ; Se era già premuto, ignora
    
    ; Primo frame di pressione! Imposta q_prev = 1
    ld   a, 1
    ld   (q_prev), a
    
    ; Esegui il cambio stanza! Poiché siamo dentro una call (CheckCtrl),
    ; dobbiamo fare pop di hl per ripulire lo stack prima di saltare.
    pop  hl                ; Rimuove l'indirizzo di ritorno di CheckCtrl
    jp   PerformRoomChange

.q_not_pressed:
    xor  a
    ld   (q_prev), a

.q_handled:
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

; -------------------------------------------------------------------
; Esegue il cambio di stanza ciclico alla stanza successiva
; -------------------------------------------------------------------
PerformRoomChange:
    ; 1. Cerca il layout corrente in RoomsListTable per trovare l'indice (0..11)
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
    cp   12                        ; 12 stanze in totale
    jr   c, .loop
    
    ld   e, 0                      ; Se non trovato, riparte da 0

.found:
    ; 2. Incrementa e calcola il prossimo indice (E = (E + 1) % 12)
    ld   a, e
    inc  a
    cp   12
    jr   c, .no_wrap
    xor  a
.no_wrap:
    ; A = nuovo indice in RoomsListTable (0..11)
    
    ; 3. Trova l'indirizzo del layout corrispondente da RoomsListTable
    ld   hl, RoomsListTable
    ld   c, a
    ld   b, 0
    add  hl, bc
    add  hl, bc                    ; HL = RoomsListTable + A * 2
    
    ld   e, (hl)
    inc  hl
    ld   d, (hl)                   ; DE = puntatore al layout della nuova stanza
    
    ld   (room_ptr), de            ; Aggiorna room_ptr
    
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
    dw TheOffLicenceLayout          ; 0
    dw TheBridgeLayout              ; 1
    dw UnderTheMegaTreeLayout       ; 2
    dw AtTheFootTheMegaTreeLayout   ; 3
    dw TheDriveLayout               ; 4
    dw TheSecurityGuardLayout       ; 5
    dw EntranceToHadesLayout        ; 6
    dw CuckoosNestLayout            ; 7
    dw InsideTheMegaTrunkLayout     ; 8
    dw OnABranchOverTheDriveLayout  ; 9
    dw TheFrontDoorLayout           ; 10
    dw TheBathroomLayout            ; 33
    dw MastreBedRoomLayout          ; 35