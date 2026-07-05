;===========================================================================
; constants.asm
;===========================================================================

; Indirizzi ROM
CLS:        EQU $0daf
OPENCHAN:   EQU $1601
ATTR_P:     EQU $5c8d
ATTR_T:     EQU $5c8f
BORDCR:     EQU $5c48
UDG:        EQU $5c7b

; Colori
BLUE:   EQU $01
RED:    EQU $02
MAGENTA: EQU $03
GREEN:  EQU $04
CYAN:   EQU $05
YELLOW: EQU $06
WHITE:  EQU $07

; Colori
BLUE_FLASH:   EQU $C1
RED_FLASH:    EQU $C2
MAGENTA_FLASH: EQU $C3
GREEN_FLASH:  EQU $C4
CYAN_FLASH:   EQU $C5
YELLOW_FLASH: EQU $C6
WHITE_FLASH:  EQU $C7

; Interrupt
IM2_TABLE   = $FE00
IM2_VECTOR  = $FDFD
SCREEN_LINE = $4860

; Fisica (Derivata dai parametri geometrici)
MAX_FALL_SPEED: EQU 12
JUMP_STRENGTH:  EQU 8
GRAVITY:        EQU 1

; Limiti schermo del Player
PLAYER_MIN_X:    EQU 5
PLAYER_MAX_X:    EQU 245

items_grid:      EQU $B000

; Offsets all'interno della struttura dati della Stanza (256 byte)
OFFSET_BG:       EQU 160
OFFSET_FLOOR:    EQU 169
OFFSET_WALL:     EQU 178
OFFSET_NASTY:    EQU 187
OFFSET_BORDER_COLOR: EQU 222
OFFSET_ITEM_GRAPHIC: EQU 227
OFFSET_RAMP:         EQU 196
OFFSET_CONVEYOR:     EQU 205
OFFSET_CONVEYOR_DATA: EQU 214
OFFSET_RAMP_DATA:    EQU 218
OFFSET_POS_WILLY:    EQU 280
OFFSET_COLORS_5_8:   EQU 282



