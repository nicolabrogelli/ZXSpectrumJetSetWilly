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
items_collected:  db $00
sprite_shift:     db $00
room_border_color: db $00
willy_lives:                   db 7   ; Numero iniziale di vite di Willy (7)

; Fisica
velocity_y:     db $00
on_ground:      db $01
jump_pressed:   db $00
jump_prev:      db $00
jump_start_y:   db $00
jump_dir:       db $00
jump_frame:     db $00
current_input_dir: db $00
q_prev:         db $01
a_prev:         db $01
room_jump_strength:  db 6
room_gravity_preset: db 1

; Buffer e contatori
counter:        dw 0
last_music_counter_low: db 0
last_frame_counter: dw 0
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
current_room_items: .80 db 0
num_room_items:     db 0
room_ptr:           dw TheOffLicenceLayout;
enemy_update_rate:  db 1
enemy_update_timer: db 0
player_speed:       db 3
transition_active:  db 0
Audio_jump_sound_note:    db 18   ; 18 = inactive (0..17 are active notes)
Audio_jump_sound_timer:   db 0
    IF ENABLE_MUSIC != 0
Audio_music_note_idx:      db 0
Audio_music_frame_counter: db 1
    ENDIF

