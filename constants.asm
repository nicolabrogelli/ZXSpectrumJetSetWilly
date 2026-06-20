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

; Codici caratteri
HEAD_GRAPH_RIGHT:   EQU $41
BODY_GRAPH_RIGHT_1: EQU $42
BODY_GRAPH_RIGHT_2: EQU $43
BODY_GRAPH_RIGHT_3: EQU $44
HEAD_GRAPH_LEFT:    EQU $45
BODY_GRAPH_LEFT_1:  EQU $46
BODY_GRAPH_LEFT_2:  EQU $47
BODY_GRAPH_LEFT_3:  EQU $48

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
JUMP_STRENGTH:  EQU 12
GRAVITY:        EQU 2

; Limiti schermo del Player
PLAYER_MIN_X:    EQU 5
PLAYER_MAX_X:    EQU 245

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
OFFSET_POS_WILLY:    EQU 256



