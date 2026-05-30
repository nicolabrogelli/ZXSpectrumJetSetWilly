;=x==========================================================================
; enemy.asm
;===========================================================================

; -------------------------------------------------------------------
; Muove il nemico in orizzontale (pattugliamento 2 pixel/frame)
; -------------------------------------------------------------------
MoveEnemy:
    ld   bc, (EnemyPos)   ; C = EnemyX, B = EnemyY
    
    ld   a, (enemy_direction)
    cp   1                ; Sinistra?
    jr   nz, .move_right
    
.move_left:
    ld   a, c
    sub  2                ; Muovi a sinistra di 2 pixel
    cp   24               ; Limite sinistro (24)
    jr   z, .reverse_to_right
    jr   c, .reverse_to_right
    ld   c, a
    jr   .save_x
    
.reverse_to_right:
    ld   c, 24
    ld   a, 2
    ld   (enemy_direction), a
    jr   .save_x

.move_right:
    ld   a, c
    add  a, 2                ; Muovi a destra di 2 pixel
    cp   231                 ; Limite destro (231)
    jr   z, .reverse_to_left
    jr   nc, .reverse_to_left
    ld   c, a
    jr   .save_x
    
.reverse_to_left:
    ld   c, 231
    ld   a, 1
    ld   (enemy_direction), a

.save_x:
    ld   (EnemyPos), bc

.animate:
    ; Alterna lo stato delle gambe/rotazione ad ogni movimento (0, 1, 2, 3)
    ld   a, (enemy_body_state)
    inc  a
    cp   4
    jr   nz, .save_state
    ld   a, 0
.save_state:
    ld   (enemy_body_state), a
    ret

; -------------------------------------------------------------------
; Disegna il nemico (lametta) a coordinate pixel
; -------------------------------------------------------------------
PrintEnemy:
    push ix
    
    ; Determina quale sprite base usare
    ld   a, (enemy_direction)
    cp   1                 ; Sinistra?
    jr   nz, .right_enemy
    
.left_enemy:
    ld   ix, LamettaSpriteLeft
    jr   .calc_frame
    
.right_enemy:
    ld   ix, LamettaSpriteRight

.calc_frame:
    ; Calcola il puntatore al frame corrente (body_state * 32)
    ld   a, (enemy_body_state) ; A = 0, 1, 2, 3
    add  a, a                  ; *2
    add  a, a                  ; *4
    add  a, a                  ; *8
    add  a, a                  ; *16
    add  a, a                  ; *32
    ld   e, a
    ld   d, 0                  ; DE = offset del frame
    add  ix, de                ; IX = puntatore al frame corretto
    
    ld   bc, (EnemyPos)        ; C = EnemyX, B = EnemyY
    call DrawPixelSprite16x16  ; Disegna lametta 16x16
    
    pop  ix
    ret

; -------------------------------------------------------------------
; Cancella il nemico alle vecchie coordinate pixel
; -------------------------------------------------------------------
DeleteEnemyAtOldPos:
    ld   bc, (EnemyPosOld)     ; C = EnemyXOld, B = EnemyYOld
    call ErasePixelSprite16x16 ; Cancella lametta
    ret

; -------------------------------------------------------------------
; Muove l'Egg in orizzontale sulla seconda piattaforma (pixel 160-224)
; -------------------------------------------------------------------
MoveEgg:
    ld   bc, (EggPos)     ; C = EggX, B = EggY
    
    ld   a, (egg_direction)
    cp   1                ; Sinistra?
    jr   nz, .move_right
    
.move_left:
    ld   a, c
    sub  2                ; Muovi a sinistra di 2 pixel
    cp   160              ; Limite sinistro (160)
    jr   z, .reverse_to_right
    jr   c, .reverse_to_right
    ld   c, a
    jr   .save_x
    
.reverse_to_right:
    ld   c, 160
    ld   a, 2
    ld   (egg_direction), a
    jr   .save_x

.move_right:
    ld   a, c
    add  a, 2                ; Muovi a destra di 2 pixel
    cp   224                 ; Limite destro (224)
    jr   z, .reverse_to_left
    jr   nc, .reverse_to_left
    ld   c, a
    jr   .save_x
    
.reverse_to_left:
    ld   c, 224
    ld   a, 1
    ld   (egg_direction), a

.save_x:
    ld   (EggPos), bc

.animate:
    ; Alterna lo stato di animazione (0, 1, 2, 3)
    ld   a, (egg_body_state)
    inc  a
    cp   4
    jr   nz, .save_state
    ld   a, 0
.save_state:
    ld   (egg_body_state), a
    ret

; -------------------------------------------------------------------
; Disegna l'Egg a coordinate pixel
; -------------------------------------------------------------------
PrintEgg:
    push ix
    
    ; Determina quale sprite base usare
    ld   a, (egg_direction)
    cp   1                 ; Sinistra?
    jr   nz, .right_egg
    
.left_egg:
    ld   ix, EggSpriteLeft
    jr   .calc_frame
    
.right_egg:
    ld   ix, EggSpriteRight

.calc_frame:
    ; Calcola il puntatore al frame corrente (egg_body_state * 32)
    ld   a, (egg_body_state)   ; A = 0, 1, 2, 3
    add  a, a                  ; *2
    add  a, a                  ; *4
    add  a, a                  ; *8
    add  a, a                  ; *16
    add  a, a                  ; *32
    ld   e, a
    ld   d, 0                  ; DE = offset del frame
    add  ix, de                ; IX = puntatore al frame di EggSprite
    
    ld   bc, (EggPos)          ; C = EggX, B = EggY
    call DrawPixelSprite16x16  ; Disegna Egg 16x16
    
    pop  ix
    ret

; -------------------------------------------------------------------
; Cancella l'Egg alle vecchie coordinate pixel
; -------------------------------------------------------------------
DeleteEggAtOldPos:
    ld   bc, (EggPosOld)       ; C = EggXOld, B = EggYOld
    call ErasePixelSprite16x16 ; Cancella Egg
    ret

; -------------------------------------------------------------------
; Muove il Robot in orizzontale sulla piattaforma centrale (pixel 64-176)
; -------------------------------------------------------------------
MoveRobot:
    ld   bc, (RobotPos)   ; C = RobotX, B = RobotY
    
    ld   a, (robot_direction)
    cp   1                ; Sinistra?
    jr   nz, .move_right
    
.move_left:
    ld   a, c
    sub  2                ; Muovi a sinistra di 2 pixel
    cp   64               ; Limite sinistro (64)
    jr   z, .reverse_to_right
    jr   c, .reverse_to_right
    ld   c, a
    jr   .save_x
    
.reverse_to_right:
    ld   c, 64
    ld   a, 2
    ld   (robot_direction), a
    jr   .save_x

.move_right:
    ld   a, c
    add  a, 2                ; Muovi a destra di 2 pixel
    cp   176                 ; Limite destro (176)
    jr   z, .reverse_to_left
    jr   nc, .reverse_to_left
    ld   c, a
    jr   .save_x
    
.reverse_to_left:
    ld   c, 176
    ld   a, 1
    ld   (robot_direction), a

.save_x:
    ld   (RobotPos), bc

.animate:
    ; Alterna lo stato di animazione (0, 1, 2, 3)
    ld   a, (robot_body_state)
    inc  a
    cp   4
    jr   nz, .save_state
    ld   a, 0
.save_state:
    ld   (robot_body_state), a
    ret

; -------------------------------------------------------------------
; Disegna il Robot a coordinate pixel
; -------------------------------------------------------------------
PrintRobot:
    push ix
    
    ; Calcola il puntatore al frame corrente (robot_body_state * 32)
    ld   a, (robot_body_state) ; A = 0, 1, 2, 3
    add  a, a                  ; *2
    add  a, a                  ; *4
    add  a, a                  ; *8
    add  a, a                  ; *16
    add  a, a                  ; *32
    ld   e, a
    ld   d, 0                  ; DE = offset del frame
    
    ld   ix, RobotSprite
    add  ix, de                ; IX = puntatore al frame di RobotSprite
    
    ld   bc, (RobotPos)        ; C = RobotX, B = RobotY
    call DrawPixelSprite16x16  ; Disegna Robot 16x16
    
    pop  ix
    ret

; -------------------------------------------------------------------
; Cancella il Robot alle vecchie coordinate pixel
; -------------------------------------------------------------------
DeleteRobotAtOldPos:
    ld   bc, (RobotPosOld)     ; C = RobotXOld, B = RobotYOld
    call ErasePixelSprite16x16 ; Cancella Robot
    ret
