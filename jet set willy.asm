;===========================================================================
; main.asm
;===========================================================================

    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM48

    org  0x5dad

    ; Include files
    include "settings.asm"
    include "physics_config.asm"
    include "constants.asm"
    include "macro.asm"
    include "interrupts.asm"
    include "graphics.asm"
    include "player.asm"
    include "input.asm"
    include "physics.asm"
    include "enemy.asm"
    include "items.asm"
    include "audio.asm"
    
start:
    ld   sp, $fdf0
    jp   Main
 
;    org $7F50
Main:
    call Gfx_CopyChars
    call Gfx_DefineChars
    
    ld   a, $02
    call OPENCHAN
    ld   hl, $8400 
    ld   (UDG), hl

    ld   hl, ATTR_P
    ld   (hl), $07
    call CLS

    call SetupIM2
    call ResetFullGameState

LoadRoomAndRestart:
    ld   sp, $fdf0             ; Ripristina lo stack pointer per evitare stack drift/reset
    call DetermineCurrentRoomID
    call Phys_LoadRoomSettings
    call Gfx_DrawRoom
    call Gfx_DrawConveyorsAndRamps
    call Gfx_PrintRoomName
    call Items_DrawRoom
    call Enemy_LoadRoom
    
    ld   a, (transition_active)
    or   a
    jr   nz, .skip_player_pos
    call LoadPositionPlayeinRoom
    jr   .after_player_pos
.skip_player_pos:
    xor  a
    ld   (transition_active), a
.after_player_pos:

    ; Leggi il colore del bordo dalla stanza corrente e impostalo
    ld   hl, (room_ptr)
    ld   de, OFFSET_BORDER_COLOR
    add  hl, de
    ld   a, (hl)
    and  $07               ; Garantisci un valore valido 0..7
    ld   (room_border_color), a
    out  ($fe), a          ; Imposta colore bordo hardware
    
    ; Aggiorna BORDCR per la ROM in modo sicuro (Paper = border, Ink = white)
    rlca
    rlca
    rlca                   ; Sposta nei bit 3-5
    or   $07               ; Ink bianco nei bit 0-2
    ld   (BORDCR), a

    ld   a, $ff
    ld   (player_drawn_pos+1), a
    call Gfx_PrintPlayer

Main_loop:
.sync_loop:
    halt
    ld   hl, (counter)
    ld   de, (last_frame_counter)
    or   a
    sbc  hl, de
    ld   a, l
    cp   2
    jr   c, .sync_loop
    
    ld   hl, (counter)
    ld   (last_frame_counter), hl
    
    ; Aggiorna il timer di sicurezza (invulnerabilità post-morte)
    ld   a, (willy_safety_timer)
    or   a
    jr   z, .no_safety_dec
    dec  a
    ld   (willy_safety_timer), a
.no_safety_dec:

    ; 1. Rendering atomico nemici ed estrazione sovrapposizioni
    call Enemy_RenderRoom
    
    ; 2. Rendering del giocatore (ridisegna Willy in primo piano se mosso o se coperto da un guardiano)
    call Gfx_UpdatePlayer
    
    ; 2. Aggiornamento audio
    IF ENABLE_EFFECTS != 0
    call Audio_UpdateJumpSound    ; Aggiorna l'effetto sonoro del salto
    ENDIF
    
    IF ENABLE_MUSIC != 0
    call Audio_UpdateMusic        ; Aggiorna la musica
    ENDIF
    
    ; Se l'animazione delle vite è abilitata, aggiorna la visualizzazione delle icone camminanti
    IF ENABLE_ANIMATE_LIVES != 0
    call Gfx_PrintWillyLives
    ENDIF


    ; 3. Salva le posizioni correnti del player per il prossimo frame
    ld   bc, (PlayerPos)
    ld   (PlayerPosOld), bc
    
    ; 4. Aggiorna le posizioni dei personaggi per il prossimo frame
    call Input_CheckCtrl
    call MovePlayer
    call Phys_ApplyGravity
    call Phys_ApplyConveyor
    call Enemy_Update
    call Items_CheckCollision
    
    ; Controlla collisione con Nasties (morte di Willy)
    IF ENABLE_NASTY_COLLISION_DEATH != 0
    call Phys_CheckNastyCollision
    jr   c, .willy_dies
    ENDIF
    
    ; Controlla collisione con guardiani
    call CheckCollision
    jr   c, .guardian_collision_found
    
    ; Nessuna collisione con guardiani. Controlla se Willy è su rampa per debug raster bar
    IF ENABLE_RAMP_DEBUG_BARS != 0
    ld   a, (willy_on_ramp)
    or   a
    jp   nz, .draw_raster_bars
    ENDIF
    
    jp   .no_collision

.guardian_collision_found:
    ; C'è collisione con un guardiano!
    ; Controlla se la morte per collisione con i guardiani è abilitata
    IF ENABLE_GUARDIAN_COLLISION_DEATH != 0
    jp   .willy_dies
    ELSE
        IF ENABLE_GUARDIAN_DEBUG_BARS != 0
        jp   .draw_raster_bars ; disegna le raster bar per debug se abilitate
        ELSE
        jp   .no_collision
        ENDIF
    ENDIF
    
.willy_dies:
    ; 1. Decrementa le vite
    ld   hl, willy_lives
    ld   a, (hl)
    or   a
    jr   z, .trigger_game_over
    dec  (hl)
    jr   z, .trigger_game_over

    ; 2. Cancella lo schermo a nero (imposta bordo e schermo a nero)
    xor  a
    out  ($fe), a              ; Imposta colore bordo hardware a nero
    ld   hl, ATTR_P
    ld   (hl), a               ; Paper = Nero, Ink = Nero ($00)
    call CLS                   ; Pulisce il display RAM e imposta gli attributi a nero

    ; 3. Pausa a schermo nero (~0.5 secondi per respawn normale)
    ld   b, 25
.death_pause:
    halt
    djnz .death_pause

    ; 4. Reimposta la fisica di Willy e imposta il timer di sicurezza al respawn
    xor  a
    ld   (velocity_y), a
    ld   (jump_pressed), a
    ld   (coyote_timer), a
    ld   (jump_frame), a
    ld   (jump_dir), a
    ld   a, 1
    ld   (on_ground), a
    
    ld   a, RESPAWN_SAFETY_TIME
    ld   (willy_safety_timer), a

    ; 5. Riposiziona Willy nel punto di ingresso dell'ultima stanza raggiunta
    call DetermineCurrentRoomID    ; A = ID stanza corrente (0..60)
    ld   hl, room_entry_positions
    ld   e, a
    ld   d, 0
    add  hl, de
    add  hl, de                    ; HL = room_entry_positions + (current_room * 2)
    ld   c, (hl)                   ; C = X ingresso
    inc  hl
    ld   b, (hl)                   ; B = Y ingresso
    ld   (PlayerPos), bc           ; Imposta le coordinate di respawn al punto di ingresso
    ld   (PlayerPosOld), bc

    ld   a, 1
    ld   (transition_active), a    ; Evita sovrascrittura con OFFSET_POS_WILLY in LoadRoomAndRestart

    ; 6. Ridisegna completamente la stanza e riposiziona Willy nel punto di ingresso
    jp   LoadRoomAndRestart

.trigger_game_over:
    ; 1. Cancella bordo e schermo a nero
    xor  a
    out  ($fe), a
    ld   hl, ATTR_P
    ld   (hl), a
    call CLS

    ; 2. Pausa a schermo nero per circa 1 secondo (~50 frame a 50Hz)
    ld   b, 50
.game_over_pause:
    halt
    djnz .game_over_pause

    ; 3. Ripristina integralmente lo stato iniziale della partita (vite, item, stanze)
    call ResetFullGameState

    ; 4. Avvia la nuova partita dal primo livello (Stanza 0: The Off Licence)
    jp   LoadRoomAndRestart

.draw_raster_bars:
    ; Collisione attiva: disegna le raster bar nel bordo
    ld   a, (counter)
    and  7                 ; Colore iniziale basato sul contatore di frame
    ld   b, 30             ; Numero di righe della barra raster
.raster_loop:
    out  ($fe), a
    inc  a
    and  7
    ld   c, 150            ; Delay per regolare l'altezza delle bande
.delay:
    dec  c
    jr   nz, .delay
    djnz .raster_loop
    
    ; Ripristina il bordo al colore della stanza dopo il disegno delle barre
    ld   a, (room_border_color)
    out  ($fe), a
    jr   .no_collision_change
    
.no_collision:
    ; Nessuna collisione: mantieni il bordo al colore della stanza
    ld   a, (room_border_color)
    out  ($fe), a
    
.no_collision_change:
    jp   Main_loop

; -------------------------------------------------------------------
; ResetFullGameState
; Ripristina tutti i dati ed i parametri allo stato iniziale
; per l'avvio di una nuova partita dopo il Game Over.
; -------------------------------------------------------------------
ResetFullGameState:
    ; Ripristina il numero di vite iniziali
    ld   a, INITIAL_LIVES
    ld   (willy_lives), a

    ; Azzeramento conteggio item raccolti e dello stato fisica/input
    xor  a
    ld   (items_collected), a
    ld   (body_state), a
    ld   (w_warp_state), a
    ld   (w_key_prev), a
    ld   (enter_key_prev), a
    ld   (velocity_y), a
    ld   (jump_pressed), a
    ld   (coyote_timer), a
    ld   (jump_frame), a
    ld   (jump_dir), a
    ld   (transition_active), a
    ld   (willy_safety_timer), a
    ld   a, $ff
    ld   (digit_key_prev), a
    ld   a, 1
    ld   (q_prev), a
    ld   (a_prev), a
    ld   (on_ground), a

    ; Ripristina tutti gli item in ItemsTable al valore 0 (non raccolti)
    call ResetItemsTable

    ; Inizializza la tabella dei punti di ingresso per tutte le stanze (0..60)
    call InitRoomEntryPositions

    ; Ripristina la stanza iniziale (Stanza 0: The Off Licence)
    ld   hl, TheOffLicenceLayout
    ld   (room_ptr), hl

    ret

  

    include "resources.asm"
    include "data/datavariable.asm"
    
    SAVESNA "jet set willy.sna", start