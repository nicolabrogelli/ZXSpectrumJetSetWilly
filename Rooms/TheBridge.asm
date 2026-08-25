;===========================================================================
; TheBridge.asm
;
; TheBridgeLayout           Size 128 Byte, Start Byte   0
; TheBridgeTile             Size  32 Byte, Start Byte 128
; TheBridgeBackground       Size   9 Byte, Start Byte 160
; TheBridgeFloor            Size   9 Byte, Start Byte 169
; TheBridgeWall             Size   9 Byte, Start Byte 178
; TheBridgeNasty            Size   9 Byte, Start Byte 187
; TheBridgeRamp             Size   9 Byte, Start Byte 196
; TheBridgeConveyor         Size   9 Byte, Start Byte 205
; TheBridgeConveyorData     Size   4 Byte, Start Byte 214
; TheBridgeRampData         Size   4 Byte, Start Byte 218
; TheBridgeBorderColor      Size   1 Byte, Start Byte 222
; TheBridgeReserved         Size   4 Byte, Start Byte 223
; TheBridgeItem		        Size   8 Byte, Start Byte 227
; TheBridgeDirection        Size   4 Byte, Start Byte 235
; TheBridgeUnused           Size   1 Byte, Start Byte 239
; TheBridgeEnemy1		    Size   5 Byte, Start Byte 240
; TheBridgeEnemy2		    Size   5 Byte, Start Byte 245
; TheBridgeEnemy3		    Size   5 Byte, Start Byte 250
; TheBridgeEnemy4		    Size   5 Byte, Start Byte 255
; TheBridgeEnemy5		    Size   5 Byte, Start Byte 260
; TheBridgeEnemy6		    Size   5 Byte, Start Byte 265
; TheBridgeEnemy7		    Size   5 Byte, Start Byte 270
; TheBridgeEnemy8		    Size   5 Byte, Start Byte 275
; TheBridgePosWilly         Size   2 Byte, Start Byte 280
; TheBridgeEnemyColors5_8   Size   4 Byte, Start Byte 282
;===========================================================================

; Room layout for Room  (The Bridge)
TheBridgeLayout:           
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,10,0,42,0,0,0
    DEFB 0,0,42,0,42,128,0,0
    DEFB 0,0,170,255,234,160,0,0
    DEFB 85,85,170,255,234,165,85,85

TheBridgeTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         The Bridge             "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheBridgeBackground:                    ; Background
    DEFB $07,0,0,0,0,0,0,0,0	                ;Background

TheBridgeFloor:
    DEFB 68,255,255,253,187,214,114,96,64       ; Floor Solid

TheBridgeWall:
    DEFB 70,34,119,34,136,34,119,34,136   ; Wall Solid

TheBridgeNasty:
    DEFB 47,3,132,72,48,3,132,72,48  ; Nastry

TheBridgeRamp:
    DEFB 7,3,3,12,13,50,55,194,200              ; Ramp Solid

TheBridgeConveyor:
    DEFB 44,1,64,4,70,79,121,240,249                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheBridgeConveyorData:
    DEFB 1	                                    ;Direction (right)
    DEFW 24556	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 5	                                    ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheBridgeRampData:
    DEFB 1	                                    ;Direction (up to the right)
    DEFW 24519	                                ;Location in the attribute buffer at 24064: (14,7)
    DEFB 3	                                    ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheBridgeBorderColor:
    DEFB 4	                                    ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheBridgeReserved:
    DEFB RED, MAGENTA, GREEN, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheBridgeItem:
    DEFB 0,0,0,0,0,0,0,0	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheBridgeDirection:
    ROOM RoomsListTable.UnderTheMegaTreeLayout	                            ; Room to the left (Under the MegaTree)
    ROOM RoomsListTable.TheOffLicenceLayout	                                ; Room to the right (The Off Licence)
    DEFB BLOCK                                                              ; Room above (None)
    DEFB BLOCK                                                              ; Room below (None)

TheBridgeUnused:
    DEFB $00;$15                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheBridgeEnemy1:
    DEFB $90, UCCELLO, 0, 80, 80            
TheBridgeEnemy2:
    DEFB $80, UCCELLO, 112, 80, 232       
TheBridgeEnemy3:
    DEFB $C0, UFO, 96, 0, 96     
TheBridgeEnemy4:
    DEFB 0, 0, 0, 0, 0         
TheBridgeEnemy5:
    DEFB 0, 0, 0, 0, 0
TheBridgeEnemy6:
    DEFB 0, 0, 0, 0, 0
TheBridgeEnemy7:
    DEFB 0, 0, 0, 0, 0
TheBridgeEnemy8:
    DEFB 0, 0, 0, 0, 0

TheBridgePosWilly:
    db 200, 104                     ; Posizione di Willy

TheBridgeEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8
