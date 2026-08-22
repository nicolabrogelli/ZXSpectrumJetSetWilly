;===========================================================================
; RescueEsmerelda.asm
;
; RescueEsmereldaLayout             Size 128 Byte, Start Byte   0
; RescueEsmereldaTile               Size  32 Byte, Start Byte 128
; RescueEsmereldaBackground         Size   9 Byte, Start Byte 160
; RescueEsmereldaFloor              Size   9 Byte, Start Byte 169
; RescueEsmereldaWall               Size   9 Byte, Start Byte 178
; RescueEsmereldaNasty              Size   9 Byte, Start Byte 187
; RescueEsmereldaRamp               Size   9 Byte, Start Byte 196
; RescueEsmereldaConveyor           Size   9 Byte, Start Byte 205
; RescueEsmereldaConveyorData       Size   4 Byte, Start Byte 214
; RescueEsmereldaRampData           Size   4 Byte, Start Byte 218
; RescueEsmereldaBorderColor        Size   1 Byte, Start Byte 222
; RescueEsmereldaReserved           Size   4 Byte, Start Byte 223
; RescueEsmereldaItem               Size   8 Byte, Start Byte 227
; RescueEsmereldaDirection          Size   4 Byte, Start Byte 235
; RescueEsmereldaUnused             Size   1 Byte, Start Byte 239
; RescueEsmereldaEnemy1             Size   5 Byte, Start Byte 240
; RescueEsmereldaEnemy2             Size   5 Byte, Start Byte 245
; RescueEsmereldaEnemy3             Size   5 Byte, Start Byte 250
; RescueEsmereldaEnemy4             Size   5 Byte, Start Byte 255
; RescueEsmereldaEnemy5             Size   5 Byte, Start Byte 260
; RescueEsmereldaEnemy6             Size   5 Byte, Start Byte 265
; RescueEsmereldaEnemy7             Size   5 Byte, Start Byte 270
; RescueEsmereldaEnemy8             Size   5 Byte, Start Byte 275
; RescueEsmereldaPosWilly           Size   2 Byte, Start Byte 280
; RescueEsmereldaEnemyColors5_8     Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room 2 (Rescue Esmerelda )
RescueEsmereldaLayout:
	DEFB 0,0,0,0,0,0,8,2	;Room layout
	DEFB 0,0,0,0,0,0,8,2
	DEFB 0,0,0,0,0,0,0,2
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,170,0
	DEFB 0,0,0,0,0,0,8,6
	DEFB 0,0,0,0,0,0,0,2
	DEFB 0,0,0,0,0,0,0,66
	DEFB 0,0,0,0,0,0,0,2
	DEFB 170,6,170,6,170,10,170,6
	DEFB 170,14,170,14,170,0,0,2
	DEFB 170,14,170,14,170,0,0,6
	DEFB 170,14,170,14,170,0,0,2
	DEFB 170,14,170,14,170,0,0,64
	DEFB 170,14,170,14,170,0,0,0
	DEFB 170,170,170,170,170,170,0,170

RescueEsmereldaTile:
    DEFM "        Rescue Esmerelda        "

RescueEsmereldaBackground:                    ; Background
    DEFB 23,0,0,0,0,0,0,0,0

RescueEsmereldaFloor:
    DEFB 23,3,3,12,12,49,50,196,200       ; Floor Solid

RescueEsmereldaWall:
    DEFB 4,238,0,187,0,238,0,187,0   ; Wall Solid

RescueEsmereldaNasty:
    DEFB 85,209,226,196,200,209,226,196,200  ; Nastry

RescueEsmereldaRamp:                            ; Ramp Solid
    DEFB 23,0,0,0,0,0,0,0,0                     ; Ramp Solid

RescueEsmereldaConveyor:                        ; Conveyor Solid
    DEFB 22,241,170,248,170,0,238,0,187         ; Conveyor Solid

RescueEsmereldaConveyorData:
    DEFB 0
    DEFW 24216
    DEFB 0

RescueEsmereldaRampData:
    DEFB 1
    DEFW 0
    DEFB 0

RescueEsmereldaBorderColor:
    DEFB 1

RescueEsmereldaReserved:
    DEFB YELLOW, GREEN, WHITE, 7     ; Enemy colors

RescueEsmereldaItem:
    DEFB 255,73,73,73,73,73,73,255

RescueEsmereldaDirection:
	ROOM RoomsListTable.IAmSureIHaveSeenThiBeforeLayout						    ; Room to the left (I'm sure I've seen this before..)
	ROOM RoomsListTable.OnTopOfTheHouseLayout						    ; Room to the right (On top of the house)
	ROOM RoomsListTable.BallRoomEastLayout						    ; Room above (Ballroom East)
	ROOM RoomsListTable.EmergencyGeneratorLayout						    ; Room below (Emergency Generator)

RescueEsmereldaUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

RescueEsmereldaEnemy1:
    DEFB $C0, NONNINO, 32, 48, 96     
RescueEsmereldaEnemy2:
    DEFB $C0, NONNINO, 96, 40, 104   
RescueEsmereldaEnemy3:
    DEFB $C0, PARRUCCA, 192, 0, 16 
RescueEsmereldaEnemy4:
    DEFB $80, UCCELLO, 40, 32, 72  
RescueEsmereldaEnemy5:
    DEFB 0, 0, 0, 0, 0
RescueEsmereldaEnemy6:
    DEFB 0, 0, 0, 0, 0
RescueEsmereldaEnemy7:
    DEFB 0, 0, 0, 0, 0
RescueEsmereldaEnemy8:
    DEFB 0, 0, 0, 0, 0

RescueEsmereldaPosWilly:
    db 200, 56                     ; Posizione di Willy
RescueEsmereldaEnemyColors5_8:
    DEFB 2, 3, 4, 7     ; Colori per nemici 5-8