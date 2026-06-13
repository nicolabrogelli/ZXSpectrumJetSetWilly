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

; Coordinate schermo
COR_X:      EQU $21
COR_Y:      EQU $18
MIN_X:      EQU $00
MIN_Y:      EQU $00
MAX_X:      EQU $1f
MAX_Y:      EQU $15

; Codici caratteri
HEAD_GRAPH_RIGHT:   EQU $41
BODY_GRAPH_RIGHT_1: EQU $42
BODY_GRAPH_RIGHT_2: EQU $43
BODY_GRAPH_RIGHT_3: EQU $44
HEAD_GRAPH_LEFT:    EQU $45
BODY_GRAPH_LEFT_1:  EQU $46
BODY_GRAPH_LEFT_2:  EQU $47
BODY_GRAPH_LEFT_3:  EQU $48

; Limiti movimento
PLAYER_TOP_L:   EQU $1e
PLAYER_TOP_R:   EQU $01
WHITE_GRAPH:    EQU $7F

; Colori
BLUE:   EQU $01
RED:    EQU $02
MAGENTA: EQU $03
GREEN:  EQU $04
CYAN:   EQU $05
YELLOW: EQU $06
WHITE:  EQU $07

; Parametri Geometrici e Visivi (Piattaforme e Pavimento)
FLOOR_Y:             EQU 144
FLOOR_CHAR_ROW:      EQU 18

PLATFORM_Y:          EQU 120
PLATFORM_COL:        EQU 8
PLATFORM_WIDTH_COLS: EQU 16

PLATFORM2_Y:          EQU 96
PLATFORM2_COL:        EQU 20
PLATFORM2_WIDTH_COLS: EQU 10

PLATFORM3_Y:          EQU 96
PLATFORM3_COL:        EQU 3
PLATFORM3_WIDTH_COLS: EQU 10

; Interrupt
IM2_TABLE   = $FE00
IM2_VECTOR  = $FDFD
SCREEN_LINE = $4860

; Fisica (Derivata dai parametri geometrici)
MAX_FALL_SPEED: EQU 12
JUMP_STRENGTH:  EQU 12
GRAVITY:        EQU 2

GROUND_LEVEL:    EQU (FLOOR_Y - 16)

PLATFORM_LEVEL:  EQU (PLATFORM_Y - 16)
PLATFORM_MIN_X:  EQU (PLATFORM_COL * 8 - 7)
PLATFORM_MAX_X:  EQU ((PLATFORM_COL + PLATFORM_WIDTH_COLS) * 8)

PLATFORM2_LEVEL: EQU (PLATFORM2_Y - 16)
PLATFORM2_MIN_X: EQU (PLATFORM2_COL * 8 - 7)
PLATFORM2_MAX_X: EQU ((PLATFORM2_COL + PLATFORM2_WIDTH_COLS) * 8)

PLATFORM3_LEVEL: EQU (PLATFORM3_Y - 16)
PLATFORM3_MIN_X: EQU (PLATFORM3_COL * 8 - 7)
PLATFORM3_MAX_X: EQU ((PLATFORM3_COL + PLATFORM3_WIDTH_COLS) * 8)

; Limiti schermo del Player
PLAYER_MIN_X:    EQU 8
PLAYER_MAX_X:    EQU 240

; Aggiungi nelle costanti
VERTICAL_BORDER: EQU $49  ; Codice del carattere per i bordi verticali ($49 = 73, lettera 'I')


