;===========================================================================
; main.asm
;===========================================================================

    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM48

    org  0x5dad

    ; Include files
    include "constants.asm"
    include "interrupts.asm"
    include "graphics.asm"
    include "player.asm"
    include "input.asm"
    include "physics.asm"
    include "enemy.asm"
    include "items.asm"
    include "audio.asm"
    include "data/datavariable.asm"
    
start:
    ld   sp, $ffff
    call SetupIM2
    jp   Main

    

;    org $7F50
Main:
    ; Inizializza
    xor  a
    ld  (body_state), a
    ld  (items_collected), a

    call Gfx_CopyChars
    call Gfx_DefineChars
    
    ld   a, $02
    call OPENCHAN
    ld   hl, $8000 
    ld   (UDG), hl

    ld   hl, ATTR_P
    ld   (hl), $07
    call CLS
LoadRoomAndRestart:
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
    ld   (room_border_color), a
    out  ($fe), a          ; Imposta colore bordo hardware
    
    ; Aggiorna BORDCR per far sì che la ROM usi lo stesso colore
    add  a, a
    add  a, a
    add  a, a              ; Sposta nei bit 3-5
    ld   b, a
    ld   a, (BORDCR)
    and  $c7               ; Pulisce vecchi bit del bordo
    or   b                 ; Imposta nuovo colore bordo
    or   $07               ; Imposta ink a bianco
    ld   (BORDCR), a

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
    
    call Audio_UpdateJumpSound    ; Aggiorna l'effetto sonoro del salto
    call Audio_UpdateMusic        ; Aggiorna la musica
    
    ; 1. Cancella e disegna i personaggi (back-to-back per minimizzare il flickering)
    call Gfx_DeleteCharAtOldPos
    call Gfx_PrintPlayer

    call Enemy_EraseRoom
    call Enemy_DrawRoom


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
    ld   a, (flag_nasty_collision_death)
    or   a
    jr   z, .no_nasty_collision_check
    
    call Phys_CheckNastyCollision
    jr   c, .willy_dies
    
.no_nasty_collision_check:
    
    ; Controlla collisione con guardiani
    call CheckCollision
    jr   nc, .no_collision
    
    ; C'è collisione con un guardiano!
    ; Controlla se la morte per collisione con i guardiani è abilitata
    ld   a, (flag_guardian_collision_death)
    or   a
    jr   z, .draw_raster_bars ; se disabilitato, disegna le raster bar per debug
    
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
    
    SAVESNA "jet set willy.sna", start