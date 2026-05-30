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

; Interrupt
IM2_TABLE   = $FE00
IM2_VECTOR  = $FDFD
SCREEN_LINE = $4860

; Fisica
MAX_FALL_SPEED: EQU 12
JUMP_STRENGTH:  EQU 12
GRAVITY:        EQU 2
GROUND_LEVEL:   EQU 128
PLATFORM_LEVEL: EQU 104
PLATFORM_MIN_X: EQU 57
PLATFORM_MAX_X: EQU 192
PLATFORM2_LEVEL: EQU 80
PLATFORM2_MIN_X: EQU 153
PLATFORM2_MAX_X: EQU 232


; Aggiungi nelle costanti
VERTICAL_BORDER: EQU $49  ; Codice del carattere per i bordi verticali ($49 = 73, lettera 'I')