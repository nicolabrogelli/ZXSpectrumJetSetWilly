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

    IF ENABLE_ROOM_SKIP_KEYS != 0
    ; ── Sezione 1a: tasto Q (cambio stanza AVANTI) ─────────────────────
    ;
    ; Porta $FB → riga Q, W, E, R, T. Bit 0 = Q.
    ; Se bit 0 = 0, Q è premuto.

    ld   bc, $fbfe
    in   a, (c)
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
    ; è in cima allo stack. Vogliamo saltare a PerformRoomChangeNext senza
    ; tornare al chiamante, quindi POP HL scarta quell'indirizzo,
    ; poi JP salta direttamente.
    pop  hl                     ; rimuove indirizzo di ritorno di Input_CheckCtrl
    jp   PerformRoomChangeNext  ; salta al cambio stanza avanti (non torna qui)

.q_not_pressed:
    xor  a
    ld   (q_prev), a            ; Q rilasciato → azzera debounce

.q_handled:

    ; ── Sezione 1b: tasto A (cambio stanza INDIETRO) ────────────────────
    ;
    ; Porta $FD → riga A, S, D, F, G. Bit 0 = A.
    ; Se bit 0 = 0, A è premuto.

    ld   bc, $fdfe
    in   a, (c)
    bit  0, a
    jr   nz, .a_not_pressed     ; bit 0 = 1 → A non premuto, salta

    ; A è premuto: debounce tramite (a_prev).
    ld   a, (a_prev)
    or   a
    jr   nz, .a_handled         ; era già premuto, niente da fare

    ; ── Primo frame di pressione di A ──
    ld   a, 1
    ld   (a_prev), a            ; marca "A era premuto"

    pop  hl                     ; rimuove indirizzo di ritorno di Input_CheckCtrl
    jp   PerformRoomChangePrev  ; salta al cambio stanza indietro (non torna qui)

.a_not_pressed:
    xor  a
    ld   (a_prev), a            ; A rilasciato → azzera debounce

.a_handled:
    ENDIF

    ; ── Sezione 2: movimento (sinistra / destra) ────────────────────
    ;
    ; Porta $DF → riga P, O, I, U, Y.
    ; Bit 0 = P (destra), Bit 1 = O (sinistra).

    ld  d, $00                  ; azzera output
    ld  bc, $dffe
    in  a, (c)                  ; legge riga $FE

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

    ld  bc, $fefe
    in  a, (c)
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

    IF ENABLE_ROOM_SKIP_KEYS != 0
; -------------------------------------------------------------------
; Esegue il cambio di stanza ciclico alla stanza successiva o precedente
; -------------------------------------------------------------------
PerformRoomChange:
PerformRoomChangeNext:
    ld   d, 1                      ; 1 = avanti
    jr   PerformRoomChangeCommon

PerformRoomChangePrev:
    ld   d, 0                      ; 0 = indietro

PerformRoomChangeCommon:
    ; 1. Cerca il layout corrente in RoomsListTable per trovare l'indice (0..60)
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
    cp   61                        ; 61 stanze totali (indice 0..60)
    jr   c, .loop
    
    ld   e, 0                      ; Se non trovato, riparte da 0

.found:
    ; 2. Trova il prossimo / precedente indice non nullo (ciclando)
    ld   c, e                      ; C = indice di partenza
.index_loop:
    bit  0, d
    jr   z, .go_prev

.go_next:
    ld   a, c
    inc  a
    cp   61                        ; 61 stanze totali (0..60), fa il wrap a 0 dopo l'ultima stanza
    jr   c, .no_wrap_next
    xor  a
.no_wrap_next:
    ld   c, a                      ; C = nuovo indice candidato
    jr   .check_candidate

.go_prev:
    ld   a, c
    sub  1
    jr   nc, .no_wrap_prev
    ld   a, 60                     ; 60 è l'ultimo indice valido
.no_wrap_prev:
    ld   c, a                      ; C = nuovo indice candidato

.check_candidate:
    ; Leggi RoomsListTable[C] senza corrompere C (indice) né D (direzione)
    push hl
    push de
    ld   hl, RoomsListTable
    ld   e, c
    ld   d, 0
    add  hl, de
    add  hl, de                    ; HL = RoomsListTable + C * 2
    ld   e, (hl)
    inc  hl
    ld   d, (hl)                   ; DE = RoomsListTable[C] (puntatore al layout)
    ld   a, d
    or   e                         ; DE == 0?
    jr   nz, .found_candidate

    ; Candidate is NULL (dw 0)
    pop  de                        ; Ripristina D (direzione) e registro DE
    pop  hl                        ; Ripristina HL
    jr   .index_loop               ; Riprova con la stanza successiva/precedente (C e D intatti!)

.found_candidate:
    ; Trovato! DE = puntatore al layout della stanza
    pop  af                        ; Scarta lo stack frame temporaneo per DE
    pop  hl                        ; Ripristina HL
    ld   (room_ptr), de
    
    ; Azzera transition_active per far caricare a LoadRoomAndRestart
    ; le coordinate iniziali reali definite nella stanza (OFFSET_POS_WILLY)
    xor  a
    ld   (transition_active), a
    ld   (velocity_y), a
    
    ; Pulisci lo schermo e ricarica la stanza
    ld   hl, ATTR_P
    ld   (hl), $07
    call CLS
    
    jp   LoadRoomAndRestart
    ENDIF

TriggerRoomChange:
    ; Input: A = nuovo room ID, C = Willy X, B = Willy Y
    cp   61                        ; Max stanze in RoomsListTable (0..60)
    ret  nc                        ; Se A >= 61, ignora transizione!
    
    push bc
    ld   hl, RoomsListTable
    ld   c, a
    ld   b, 0
    add  hl, bc
    add  hl, bc                    ; HL = RoomsListTable + A * 2
    
    ld   e, (hl)
    inc  hl
    ld   d, (hl)                   ; DE = puntatore al layout della nuova stanza
    
    ld   a, d
    or   e                         ; DE == 0?
    pop  bc
    ret  z                         ; Se layout è NULL (stanza non creata), ignora transizione!
    
    ld   (PlayerPos), bc
    ld   (PlayerPosOld), bc
    
    ; Reset velocity_y
    ld   hl, velocity_y
    ld   (hl), 0
    
    ld   (room_ptr), de            ; Aggiorna room_ptr
    
    ; Imposta il flag di transizione per non caricare la posizione di default
    ld   a, 1
    ld   (transition_active), a
    
    ; Pulisci lo schermo
    ld   hl, ATTR_P
    ld   (hl), $07
    call CLS
    
    ; Reset dello stack pointer prima di riavviare la stanza
    ld   sp, $fdf0
    jp   LoadRoomAndRestart

RoomsListTable:
.TheOffLicenceLayout:              dw TheOffLicenceLayout              ; 00
.TheBridgeLayout:                  dw TheBridgeLayout                  ; 01
.UnderTheMegaTreeLayout:           dw UnderTheMegaTreeLayout           ; 02
.AtTheFootTheMegaTreeLayout:       dw AtTheFootTheMegaTreeLayout       ; 03
.TheDriveLayout:                   dw TheDriveLayout                   ; 04
.TheSecurityGuardLayout:           dw TheSecurityGuardLayout           ; 05
.EntranceToHadesLayout:            dw EntranceToHadesLayout            ; 06
.CuckoosNestLayout:                dw CuckoosNestLayout                ; 07
.InsideTheMegaTrunkLayout:         dw InsideTheMegaTrunkLayout         ; 08
.OnABranchOverTheDriveLayout:      dw OnABranchOverTheDriveLayout      ; 09
.TheFrontDoorLayout:               dw TheFrontDoorLayout               ; 10
.TheHallLayout:                    dw TheHallLayout                    ; 11
.TreeTopLayout:                    dw TreeTopLayout                    ; 12
.OutALimbLayout:                   dw OutALimbLayout                   ; 13
.RescueEsmereldaLayout:            dw RescueEsmereldaLayout            ; 14
.IAmSureIHaveSeenThiBeforeLayout:  dw IAmSureIHaveSeenThiBeforeLayout  ; 15
.WeMustPerformQuirkafleegLayout:   dw WeMustPerformQuirkafleegLayout   ; 16
.UpOnTheBattlementsLayout:         dw UpOnTheBattlementsLayout         ; 17
.OntheRoofLayout:                  dw OntheRoofLayout                  ; 18
.TheForgottenAbbeyLayout:          dw TheForgottenAbbeyLayout          ; 19
.BallRoomEastLayout:               dw BallRoomEastLayout               ; 20
.BallRoomWestLayout:               dw BallRoomWestLayout               ; 21
.TotheKitchensMainStairwayLayout:  dw TotheKitchensMainStairwayLayout  ; 22 
.TheKitchenLayout:                 dw TheKitchenLayout                 ; 23
.WestOfKitchenLayout:              dw WestOfKitchenLayout              ; 24
.ColdStoreLayout:                  dw ColdStoreLayout                  ; 25
.EastWallBaseLayout:               dw EastWallBaseLayout               ; 26
.TheChapelLayout:                  dw TheChapelLayout                  ; 27
.FirstLandingLayout:               dw FirstLandingLayout               ; 28
.TheNightmareRoomLayout:           dw TheNightmareRoomLayout           ; 29
.TheBanyanTreeLayout               dw TheBanyanTreeLayout              ; 30
.SwimmingPoolLayout:               dw SwimmingPoolLayout               ; 31
.HalfwayUpTheEastWallLayout:       dw HalfwayUpTheEastWallLayout       ; 32
.TheBathroomLayout:                dw TheBathroomLayout                ; 33
.TopLandingLayout:                 dw TopLandingLayout                 ; 34
.MastreBedRoomLayout:              dw MastreBedRoomLayout              ; 35
.ABitOfTreeLayout:                 dw ABitOfTreeLayout                 ; 36
.OrangeryLayout:                   dw OrangeryLayout                   ; 37
.PriestsHoleLayout:                dw PriestsHoleLayout                ; 38
.EmergencyGeneratorLayout:         dw EmergencyGeneratorLayout         ; 39
.DrJonesWillNeverBelieveThisLayout: dw DrJonesWillNeverBelieveThisLayout ; 40
.TheAtticLayout:                   dw TheAtticLayout                   ; 41
.UnderTheRoofLayout:               dw UnderTheRoofLayout               ; 42
.ConservatoryRoofLayout:           dw ConservatoryRoofLayout           ; 43
.OnTopOfTheHouseLayout:            dw OnTopOfTheHouseLayout            ; 44
.UnderTheDriveLayout:              dw UnderTheDriveLayout              ; 45
.TreeRootLayout:                   dw TreeRootLayout                   ; 46
.NotUsedLayout                     dw NotUsedLayout                    ; 47
.NomenLuniLayout                   dw NomenLuniLayout                  ; 48
.TheWineCellarLayout               dw TheWineCellarLayout              ; 49
                                   dw 0,0,0,0,0,0,0,0,0,0,0            ; 50-60

