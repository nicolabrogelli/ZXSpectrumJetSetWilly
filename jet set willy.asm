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
    call DetermineCurrentRoomID
    call DrawRoom
    call DrawConveyorsAndRamps
    call PrintRoomName
    call DrawRoomItems
    call LoadRoomEnemies
    call LoadPositionPlayeinRoom

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
    call ApplyConveyorForce
    call UpdateRoomEnemies
    call CheckRoomItemsCollision
    
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
; Variabili
; -------------------------------------------------------------------
; Posizioni
PlayerPos:      db 136, 128 ;136, 100
PlayerPosOld:   db 136, 128 ;136, 100
bodyPos:        dw $1111

; Stato player
body_state:     db $00
direction:      db $00
flags:          db $00

collision_active: db $00
sprite_shift:     db $00
room_border_color: db $00

; Fisica
velocity_y:     db $00
on_ground:      db $01
jump_pressed:   db $00
jump_prev:      db $00

; Buffer e contatori
counter:        dw 0
line_buffer:    .256 db 0
unpacked_layout: .512 db 0

; Gestione Stanze
current_room:   db 0
conveyor_dir:   db 0
conveyor_len:   db 0
conveyor_row:   db 0
conveyor_col:   db 0
ramp_dir:       db 0
ramp_len:       db 0
ramp_row:       db 0
ramp_col:       db 0
room_ptr:       dw TheDriveLayout; AtTheFootTheMegaTreeLayout; UnderTheMegaTreeLayout ;MastreBedRoomLayout; TheOffLicenceLayout; TheBridgeLayout; TheTestRoomLayout;      

    ALIGN 256
RoomsStart:
    include "Rooms/TheOffLicence.asm"
    include "Rooms/TheBridge.asm"
    include "Rooms/UnderTheMegaTree.asm"
    include "Rooms/AtTheFootTheMegaTree.asm"
    include "Rooms/TheDrive.asm"

    include "Rooms/MasterBedRoom.asm"
    include "Rooms/TheTestRoom.asm"

    SAVESNA "jet set willy.sna", start