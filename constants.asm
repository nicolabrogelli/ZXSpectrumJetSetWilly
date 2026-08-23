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

INITIAL_LIVES: EQU 7

; Colori
NONE:   EQU $00
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

; Note: La fisica (MAX_FALL_SPEED, JUMP_STRENGTH, GRAVITY, DEFAULT_GRAVITY_PRESET)
; è ora configurata in physics_config.asm

; Limiti schermo del Player
PLAYER_MIN_X:    EQU 5
PLAYER_MAX_X:    EQU 245

; items_grid è definito dinamicamente in resources.asm dopo le sprite

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
OFFSET_PHYSICS_SETTINGS: EQU 239
OFFSET_POS_WILLY:    EQU 280
OFFSET_COLORS_5_8:   EQU 282

BLOCK:          EQU $FF

ROOM_MASTER_BEDROOM: EQU 35


LAMETTA:  		EQU 0   ;(Lametta)
SEGA: 			EQU 1   ;(Sega)
UCCELLO: 		EQU 2   ;(Uccello)
RADAR: 			EQU 3   ;(Radar)
UOVO: 			EQU 4   ;(Uovo)
UFO: 			EQU 5   ;(Ufo)
FACCIA:			EQU 6   ;(Faccia)
SCIMMIA:		EQU 7   ;(Scimmia)
ROBOT:			EQU 8   ;(Robot)
PALLA:			EQU 9   ;(Palla)
DOUBLE_BALL:	EQU 10  ;(Double Ball)
SOLDATO:		EQU 11  ;(Soldato)
MAIALE:			EQU 12  ;(Maiale)
CANGURO:		EQU 13  ;(Canguro)
FIORE:			EQU 14  ;(Fiore)
FACCIA_PALLA: 	EQU 15  ;(Faccia Palla)
CANDELABRO:		EQU 16  ;(Candelabro)
FRECCIA:		EQU 17  ;(Freccia)
TRONCHESE:		EQU 18  ;(Tronchese)
PERISCOPIO:		EQU 19  ;(Periscopio)
NONNINO:		EQU 20  ;(Nonnino)
PARRUCCA:		EQU 21  ;(Parrucca)
FRATE:			EQU 22  ;(Frate)
FACE_HL:		EQU 23  ;(FaceHellHL - Top-Left)
FACE_HR:		EQU 24  ;(FaceHellHR - Top-Right)
FACE_LL:		EQU 25  ;(FaceHellLL - Bottom-Left)
FACE_LR:		EQU 26  ;(FaceHellLR - Bottom-Right)
PINZA_GHIACCIO:	EQU 27  ;(PinzaGiaccioSprite)
RUOTA:			EQU 28  ;(RuotaSprite)
SALIERA:		EQU 29  ;(SalieraSprite)
GELATO:			EQU 30  ;(GelatoSprite)
PINGUINO:		EQU 31  ;(PinguinoSprite)
MURO:			EQU 32  ;(MuroSprite)
DIAVOLETTO:		EQU 33  ;(DiavolettoSprite)
VECCHIA:		EQU 34  ;(VecchiaSprite)
PIEDE:			EQU 35  ;(PiedeSprite)
CHIP:			EQU 36  ;(ChipSprite)
IPNOSI:			EQU 37  ;(IpnosiSprite)
SWISSARMKIFE:	EQU 38  ;(SwissArmyKife)
BOTTE:			EQU 39  ;(BotteSprite)
ONDA:			EQU 40  ;(OndaSprite)
PALAZZO:		EQU 41  ;(PalazzoSprite)