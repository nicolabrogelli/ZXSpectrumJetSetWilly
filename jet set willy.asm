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
    include "screen.asm"
    include "enemy.asm"
    ;include "level.asm"

start:
    call SetupIM2

    

Main:
    ; Inizializza
    xor  a
    ld  (body_state), a

    call CopyChars
    call DefineChars
    
    ld   a, $02
    call OPENCHAN
    ld   hl, $8000 
    ld   (UDG), hl

    ld   hl, ATTR_P
    ld   (hl), $07
    call CLS
    call DrawRoom
    call LoadRoomEnemies

    xor  a
    out  ($fe), a
    ld   a, (BORDCR)
    and  $c7
    or   $07
    ld   (BORDCR), a

    ;call DrawVerticalBorders
    call PrintPlayer

Main_loop:
    halt
    
    ; 1. Cancella e disegna i personaggi (back-to-back per minimizzare il flickering)
    call DeleteCharAtOldPos
    call PrintPlayer

    call EraseRoomEnemies
    call DrawRoomEnemies
    
    ; 3. Salva le posizioni correnti del player per il prossimo frame
    ld   bc, (PlayerPos)
    ld   (PlayerPosOld), bc
    
    ; 4. Aggiorna le posizioni dei personaggi per il prossimo frame
    call CheckCtrl
    call MovePlayer
    call ApplyGravity
    call UpdateRoomEnemies
    
    ; 5. Gestisci la collisione (disegna le raster bar se collide)
    call CheckCollision
    jr   nc, .no_collision
    
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
    
    ; Ripristina il bordo a nero dopo il disegno delle barre
    xor  a
    out  ($fe), a
    jr   .no_collision_change
    
.no_collision:
    ; Nessuna collisione: mantieni il bordo nero
    xor  a
    out  ($fe), a
    
.no_collision_change:
    jp   Main_loop

; -------------------------------------------------------------------
; Variabili
; -------------------------------------------------------------------
; Posizioni
PlayerPos:      db 136, 128
PlayerPosOld:   db 136, 128
bodyPos:        dw $1111

; Stato player
body_state:     db $00
direction:      db $00
flags:          db $00

collision_active: db $00
sprite_shift:     db $00

; Fisica
velocity_y:     db $00
on_ground:      db $01
jump_pressed:   db $00
jump_prev:      db $00

; Buffer e contatori
counter:        dw 0
line_buffer:    .256 db 0

; Gestione Stanze
current_room:   db 0
room_ptr:       dw TheTestRoomLayout

    ALIGN 256
RoomsStart:
    include "Rooms/TheBridge.asm"
    include "Rooms/TheOffLicence.asm"
    include "Rooms/TheTestRoom.asm"

    SAVESNA "jet set willy.sna", start