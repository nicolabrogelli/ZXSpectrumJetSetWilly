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
    call DrawFloorDirect
    call DrawPlatform

    xor  a
    out  ($fe), a
    ld   a, (BORDCR)
    and  $c7
    or   $07
    ld   (BORDCR), a

    ; Inizializza nemico
    xor  a
    ld   (enemy_body_state), a
    ld   a, 2              ; Inizia verso destra
    ld   (enemy_direction), a
    call PrintEnemy

    ; Inizializza Egg
    xor  a
    ld   (egg_body_state), a
    ld   a, 2              ; Inizia verso destra
    ld   (egg_direction), a
    call PrintEgg

    ; Inizializza Robot
    xor  a
    ld   (robot_body_state), a
    ld   a, 2              ; Inizia verso destra
    ld   (robot_direction), a
    call PrintRobot

    ;call DrawVerticalBorders
    call PrintPlayer

Main_loop:
    halt
    halt
    
    ; 1. Cancella i personaggi alle vecchie posizioni
    call DeleteCharAtOldPos
    call DeleteEnemyAtOldPos
    call DeleteEggAtOldPos
    call DeleteRobotAtOldPos
    
    call CheckCtrl
    
    ; 2. Aggiorna le posizioni dei personaggi
    call MovePlayer
    call ApplyGravity
    call MoveEnemy
    call MoveEgg
    call MoveRobot
    
    ; 3. Salva le nuove posizioni per la cancellazione al prossimo frame
    ld   bc, (PlayerPos)
    ld   (PlayerPosOld), bc
    ld   bc, (EnemyPos)
    ld   (EnemyPosOld), bc
    ld   bc, (EggPos)
    ld   (EggPosOld), bc
    ld   bc, (RobotPos)
    ld   (RobotPosOld), bc
    
    ; 4. Disegna i personaggi alle nuove posizioni
    call PrintPlayer
    call PrintEnemy
    call PrintEgg
    call PrintRobot
    call DrawPlatform
    
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

; Posizioni nemico
EnemyPos:       db 40, 128
EnemyPosOld:    db 40, 128

; Posizioni Egg
EggPos:         db 160, 80
EggPosOld:      db 160, 80

; Posizioni Robot
RobotPos:       db 64, 104
RobotPosOld:    db 64, 104

; Stato player
body_state:     db $00
direction:      db $00
flags:          db $00

; Stato nemico
enemy_body_state: db $00
enemy_direction:  db $00
collision_active: db $00
sprite_shift:     db $00

; Stato Egg
egg_body_state:   db $00
egg_direction:    db $00

; Stato Robot
robot_body_state: db $00
robot_direction:  db $00

; Fisica
velocity_y:     db $00
on_ground:      db $01
jump_pressed:   db $00
jump_prev:      db $00

; Buffer e contatori
counter:        dw 0
line_buffer:    .256 db 0

    SAVESNA "jet set willy.sna", start