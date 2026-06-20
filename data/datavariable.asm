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
room_ptr:       dw TheBridgeLayout; TheBathroomLayout; MastreBedRoomLayout; TheSecurityGuardLayout; TheOffLicenceLayout; TheDriveLayout; AtTheFootTheMegaTreeLayout; UnderTheMegaTreeLayout ; T TheTestRoomLayout;    