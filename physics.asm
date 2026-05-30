;===========================================================================
; physics.asm
;===========================================================================

    
; -------------------------------------------------------------------
; Applica gravità e gestisce salto
; -------------------------------------------------------------------
ApplyGravity:
    ld  bc, (PlayerPos)
    ld  a, b              ; B = PlayerY (pixel)
    
    ; Controlla se siamo a mezz'aria (on_ground == 0)
    ld  a, (on_ground)
    or  a
    jp  z, .in_air        ; Se siamo in volo, continua a volare
    
    ; Se on_ground == 1, controlliamo se siamo al livello del floor o della piattaforma
    ld  a, b              ; B = PlayerY
    cp  GROUND_LEVEL      ; 128
    jp  z, .at_platform_or_ground ; Se siamo a 128, siamo a terra
    
    cp  PLATFORM_LEVEL    ; 104
    jr  z, .check_platform1
    
    cp  PLATFORM2_LEVEL   ; 80
    jp  nz, .in_air       ; Se non siamo su nessuna, siamo in volo (sicurezza)
    
    ; --- CONTROLLO PIATTAFORMA 2 (Riga 12) ---
    ld  a, c              ; C = PlayerX
    cp  PLATFORM2_MIN_X   ; 153
    jp  c, .in_air        ; Se X < 153, caduta
    cp  PLATFORM2_MAX_X   ; 232
    jp  nc, .in_air       ; Se X >= 232, caduta
    
    ld  b, PLATFORM2_LEVEL
    jp  .at_platform_or_ground

.check_platform1:
    ; --- CONTROLLO PIATTAFORMA 1 (Riga 15) ---
    ld  a, c              ; C = PlayerX
    cp  PLATFORM_MIN_X    ; 57
    jp  c, .in_air        ; Se X < 57, caduta
    cp  PLATFORM_MAX_X    ; 192
    jp  nc, .in_air       ; Se X >= 192, caduta
    
    ld  b, PLATFORM_LEVEL
    jp  .at_platform_or_ground

.at_platform_or_ground:
    ld  (PlayerPos), bc
    ld  a, 1
    ld  (on_ground), a
    xor a
    ld  (velocity_y), a

    ; Gestisci salto
    ld  a, (jump_pressed)
    or  a
    jp  z, .end
    
    ld  a, JUMP_STRENGTH
    ld  (velocity_y), a
    xor a
    ld  (on_ground), a
    ld  (jump_pressed), a
    jp  .in_air

.in_air:
    ; Applica gravità
    ld  a, (velocity_y)
    sub GRAVITY           ; gravity = 2
    
    ; Controlla se positivo per evitare bug con cp signed
    bit 7, a
    jr  z, .store_vel
    
    cp  -MAX_FALL_SPEED   ; -12
    jr  nc, .store_vel
    ld  a, -MAX_FALL_SPEED

.store_vel:
    ld  (velocity_y), a

    ; Applica movimento verticale: PlayerY = PlayerY - velocity_y
    ld  bc, (PlayerPos)
    ld  d, a              ; D = velocity_y (signed)
    ld  a, b              ; A = PlayerY
    sub d                 ; A = PlayerY - velocity_y
    ld  b, a              ; B = new PlayerY

    ; Controlla se stiamo cadendo (velocity_y <= 0)
    ld  a, (velocity_y)
    bit 7, a              ; Se negativo, bit 7 = 1
    jr  nz, .falling_checks
    or  a                 ; Se zero
    jr  z, .falling_checks
    jr  .no_collision_checks ; Se stiamo salendo, non controlliamo collisioni
    
.falling_checks:
    ; --- COLLISIONE CON IL FLOOR (ground_level = 128) ---
    ; Vecchio Y deve essere <= ground_level (128), e nuovo Y (in B) >= ground_level (128)
    ld  a, (PlayerPos+1)  ; Vecchio Y
    cp  GROUND_LEVEL+1    ; Se A <= 128, allora A < 129 (carry set)
    jr  nc, .check_platform1_collision ; Se vecchio Y > 128, eravamo sotto, passa a platform 1
    
    ld  a, b              ; Nuovo Y
    cp  GROUND_LEVEL      ; Se B >= 128 (no carry)
    jr  c, .check_platform1_collision ; Se non abbiamo ancora toccato il floor, controlla platform 1
    
    ; Collisione avvenuta! Atterriamo sul floor
    ld  b, GROUND_LEVEL
    jp  .at_platform_or_ground
    
.check_platform1_collision:
    ; --- COLLISIONE CON LA PIATTAFORMA 1 ---
    ; Siamo dentro l'intervallo X della piattaforma 1?
    ld  a, c              ; C = PlayerX
    cp  PLATFORM_MIN_X    ; 57
    jr  c, .check_platform2_collision
    cp  PLATFORM_MAX_X    ; 192
    jr  nc, .check_platform1_only_nc  ; If X >= 192, no platform 1 check
    
    ; Vecchio Y deve essere <= platform_level, e nuovo Y (in B) >= platform_level
    ld  a, (PlayerPos+1)  ; Vecchio Y
    cp  PLATFORM_LEVEL+1  ; Se A <= platform_level (104), allora A < 105 (carry set)
    jr  nc, .check_platform2_collision ; Se vecchio Y > platform_level, eravamo sotto, passa a platform 2
    
    ld  a, b              ; Nuovo Y
    cp  PLATFORM_LEVEL    ; Se B >= platform_level
    jr  c, .check_platform2_collision
    
    ; Collisione avvenuta! Atterriamo sulla piattaforma 1
    ld  b, PLATFORM_LEVEL
    jp  .at_platform_or_ground

.check_platform1_only_nc:
    ; Just helper to jump to check_platform2_collision
    jr  .check_platform2_collision

.check_platform2_collision:
    ; --- COLLISIONE CON LA PIATTAFORMA 2 ---
    ; Siamo dentro l'intervallo X della piattaforma 2?
    ld  a, c              ; C = PlayerX
    cp  PLATFORM2_MIN_X   ; 153
    jr  c, .no_collision_checks
    cp  PLATFORM2_MAX_X   ; 232
    jr  nc, .no_collision_checks
    
    ; Vecchio Y deve essere <= platform2_level (80), e nuovo Y (in B) >= platform2_level (80)
    ld  a, (PlayerPos+1)  ; Vecchio Y
    cp  PLATFORM2_LEVEL+1 ; Se A <= 80, allora A < 81 (carry set)
    jr  nc, .no_collision_checks
    
    ld  a, b              ; Nuovo Y
    cp  PLATFORM2_LEVEL   ; Se B >= 80
    jr  c, .no_collision_checks
    
    ; Collisione avvenuta! Atterriamo sulla piattaforma 2
    ld  b, PLATFORM2_LEVEL
    jp  .at_platform_or_ground
    
.no_collision_checks:
.save_pos:
    ; Limite soffitto (Y >= 8 pixel per evitare di uscire dallo schermo)
    ld  a, b
    cp  8
    jr  nc, .save_ok
    ld  b, 8
    xor a
    ld  (velocity_y), a

.save_ok:
    ld  (PlayerPos), bc

.end:
    xor a
    ld  (jump_pressed), a
    ret

; -------------------------------------------------------------------
; Verifica la collisione tra player e nemico (bounding box a livello di pixel)
; Output: Carry flag impostato se collisione, altrimenti resettato
; -------------------------------------------------------------------
CheckCollision:
    ; --- CONTROLLO COLLISIONE CON PRIMO NEMICO (LAMETTA) ---
    ; 1. Controllo orizzontale: PlayerX - EnemyX + 7 in [0, 22] (Player width=8, Enemy width=16)
    ld   a, (PlayerPos)   ; A = PlayerX
    ld   hl, EnemyPos
    sub  (hl)             ; A = PlayerX - EnemyX
    add  a, 7             ; A = PlayerX - EnemyX + 7
    cp   23               ; Se >= 23, nessuna collisione con questo, prova con l'altro
    jr   nc, .check_egg
    
    ; 2. Controllo verticale: PlayerY - EnemyY + 15 in [0, 30] (Player height=16, Enemy height=16)
    ld   a, (PlayerPos+1) ; A = PlayerY
    ld   hl, EnemyPos+1
    sub  (hl)             ; A = PlayerY - EnemyY
    add  a, 15            ; A = PlayerY - EnemyY + 15
    cp   31               ; Se >= 31, nessuna collisione con questo, prova con l'altro
    jr   nc, .check_egg
    
    ; Collisione avvenuta con il primo nemico!
    scf                   ; Imposta carry flag
    ret
    
.check_egg:
    ; --- CONTROLLO COLLISIONE CON SECONDO NEMICO (EGG) ---
    ; 1. Controllo orizzontale: PlayerX - EggX + 7 in [0, 22] (Player width=8, Egg width=16)
    ld   a, (PlayerPos)   ; A = PlayerX
    ld   hl, EggPos
    sub  (hl)             ; A = PlayerX - EggX
    add  a, 7             ; A = PlayerX - EggX + 7
    cp   23               ; Se >= 23, prova con il robot
    jr   nc, .check_robot
    
    ; 2. Controllo verticale: PlayerY - EggY + 15 in [0, 30] (Player height=16, Egg height=16)
    ld   a, (PlayerPos+1) ; A = PlayerY
    ld   hl, EggPos+1
    sub  (hl)             ; A = PlayerY - EggY
    add  a, 15            ; A = PlayerY - EggY + 15
    cp   31               ; Se >= 31, prova con il robot
    jr   nc, .check_robot
    
    ; Collisione avvenuta con il secondo nemico!
    scf                   ; Imposta carry flag
    ret

.check_robot:
    ; --- CONTROLLO COLLISIONE CON TERZO NEMICO (ROBOT) ---
    ; 1. Controllo orizzontale: PlayerX - RobotX + 7 in [0, 22] (Player width=8, Robot width=16)
    ld   a, (PlayerPos)   ; A = PlayerX
    ld   hl, RobotPos
    sub  (hl)             ; A = PlayerX - RobotX
    add  a, 7             ; A = PlayerX - RobotX + 7
    cp   23               ; Se >= 23, nessuna collisione
    jr   nc, .no_collision
    
    ; 2. Controllo verticale: PlayerY - RobotY + 15 in [0, 30] (Player height=16, Robot height=16)
    ld   a, (PlayerPos+1) ; A = PlayerY
    ld   hl, RobotPos+1
    sub  (hl)             ; A = PlayerY - RobotY
    add  a, 15            ; A = PlayerY - RobotY + 15
    cp   31               ; Se >= 31, nessuna collisione
    jr   nc, .no_collision
    
    ; Collisione avvenuta con il terzo nemico!
    scf                   ; Imposta carry flag
    ret
    
.no_collision:
    or   a                 ; Reset carry flag
    ret