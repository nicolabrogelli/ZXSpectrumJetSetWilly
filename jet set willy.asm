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
    ; Inizializza
    xor  a
    ld  (body_state), a
    ld  (items_collected), a
    ld  (w_warp_state), a
    ld  (w_key_prev), a
    ld  (enter_key_prev), a
    ld  a, $ff
    ld  (digit_key_prev), a
    ld  a, 1
    ld  (q_prev), a
    ld  (a_prev), a

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
    
    ; 1. Rendering atomico dei personaggi subito dopo HALT (mentre il raggio è nel bordo superiore)
    call Gfx_UpdatePlayer
    call Enemy_RenderRoom
    
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
    jr   nz, .draw_raster_bars
    ENDIF
    
    jr   .no_collision

.guardian_collision_found:
    ; C'è collisione con un guardiano!
    ; Controlla se la morte per collisione con i guardiani è abilitata
    IF ENABLE_GUARDIAN_COLLISION_DEATH != 0
    jr   .willy_dies
    ELSE
        IF ENABLE_GUARDIAN_DEBUG_BARS != 0
        jr   .draw_raster_bars ; disegna le raster bar per debug se abilitate
        ELSE
        jr   .no_collision
        ENDIF
    ENDIF
    
.willy_dies:
    ; Decrementa le vite e aggiorna la visualizzazione
    ld   hl, willy_lives
    ld   a, (hl)
    or   a
    jr   z, .no_lives_dec
    dec  (hl)
.no_lives_dec:
    call Gfx_PrintWillyLives

    ; Gestisci la morte di Willy:
    ; 1. Cancella la sprite del player dalla sua posizione attuale a schermo
    call Gfx_DeleteCharAtOldPos
    
    ; 2. Ripristina la posizione iniziale nella stanza
    call LoadPositionPlayeinRoom
    
    ; 3. Reimposta la fisica di Willy
    xor  a
    ld   (velocity_y), a
    ld   (jump_pressed), a
    ld   (jump_frame), a
    ld   (jump_dir), a
    ld   a, 1
    ld   (on_ground), a
    jr   .no_collision ; Salta il disegno delle raster bar poiché Willy è morto
    
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

  

    include "resources.asm"
    include "data/datavariable.asm"
    
    SAVESNA "jet set willy.sna", start