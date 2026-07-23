;===========================================================================
; MasterBedroom.asm   
;
; Ho creato solo il template deve essere gestito con i dati corretti della stanza
;
; MasterBedroomLayout       Size 128 Byte, Start Byte   0
; MasterBedroomTile         Size  32 Byte, Start Byte 128
; MasterBedroomBackground   Size   9 Byte, Start Byte 160
; MasterBedroomFloor        Size   9 Byte, Start Byte 169
; MasterBedroomWall         Size   9 Byte, Start Byte 178
; MasterBedroomNasty        Size   9 Byte, Start Byte 187
; MasterBedroomRamp         Size   9 Byte, Start Byte 196
; MasterBedroomConveyor     Size   9 Byte, Start Byte 205
; MasterBedroomConveyorData Size   4 Byte, Start Byte 214
; MasterBedroomRampData     Size   4 Byte, Start Byte 218
; MasterBedroomBorderColor  Size   1 Byte, Start Byte 222
; MasterBedroomReserved     Size   4 Byte, Start Byte 223
; MasterBedroomItem		    Size   8 Byte, Start Byte 227
; MasterBedroomDirection    Size   4 Byte, Start Byte 235
; MasterBedroomUnused       Size   1 Byte, Start Byte 239
; MasterBedroomEnemy1		Size   5 Byte, Start Byte 240
; MasterBedroomEnemy2		Size   5 Byte, Start Byte 245
; MasterBedroomEnemy3		Size   5 Byte, Start Byte 250
; MasterBedroomEnemy4		Size   5 Byte, Start Byte 255
; MasterBedroomPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (Master Bedroom)
MastreBedRoomLayout:           
    DEFB 170,170,170,170,170,170,170,170	
    DEFB 160,0,0,10,0,0,0,0
    DEFB 160,0,0,10,0,0,0,0
    DEFB 160,0,0,10,0,0,0,0
    DEFB 160,0,0,10,0,0,0,0
    DEFB 160,0,0,10,0,0,0,0
    DEFB 160,0,0,10,0,0,0,0
    DEFB 160,0,0,10,0,0,0,0
    DEFB 160,0,0,10,0,0,0,0
    DEFB 160,0,0,10,0,0,0,0
    DEFB 160,0,0,10,0,0,0,0
    DEFB 172,0,0,0,0,0,0,0
    DEFB 160,0,0,0,0,0,0,0
    DEFB 149,85,85,85,64,0,0,0
    DEFB 170,170,170,170,160,0,0,0
    DEFB 170,170,170,170,169,85,85,85

MastreBedRoomTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         Master Bedroom         "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
MastreBedRoomBackground:
    DEFB $07,0,0,0,0,0,0,0,0	                ;Background

MastreBedRoomFloor:
    DEFB 6,255,107,181,0,173,0,74,0	        ;Floor Solid

MastreBedRoomWall:
    DEFB 51,0,81,251,81,0,170,191,170	    ;Wall Solid

MastreBedRoomNasty:
    DEFB 71,0,0,0,0,124,254,127,62	        ;Nasty

MastreBedRoomRamp:
    DEFB 7,192,64,176,0,172,0,83,0	        ;Ramp Solid

MastreBedRoomConveyor:
    DEFB 41,85,85,85,85,81,95,64,170	    ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
MastreBedRoomConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24450	                            ;Location in the attribute buffer at 24064: (15,12)
    DEFB 4	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
MastreBedRoomRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24530	                            ;Location in the attribute buffer at 24064: (14,7)
    DEFB 2	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
MastreBedRoomBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
MastreBedRoomReserved:
    DEFB 2, 3, 4, 7                         ; Enemy colors: all WHITE (7)

;The next eight bytes are copied to 32993 and define the item graphic.
MastreBedRoomItem:
    DEFB 0,0,0,0,0,0,0,0	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
MastreBedRoomDirection:
    DEFB 36	                               ;Room to the left (A bit of tree)
    DEFB 34                                ;Room to the right (Top Landing)
    DEFB 41                                ;Room above  (The Attic)
    DEFB 29                                ;Room below (The Nightmare Room)

MastreBedRoomUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
MastreBedRoomEnemy1:
    DEFB $80, 0, 8, 76, 200         ; Enemy 1 (Uccello), horizontal, Starts X=8, Y=120, Limit X=200
MastreBedRoomEnemy2:
    DEFB $80, 0, 80, 76, 180         ; Enemy 2 (Uccello), horizontal, Starts X=80, Y=80, Limit X=180
MastreBedRoomEnemy3:
    DEFB $C0, 4, 120, 16, 76         ; Enemy 3 (Ufo), vertical, Starts X=120, Y=40, Limit Y=130
MastreBedRoomEnemy4:
    DEFB 0, 0, 0, 0, 0         ; Empty slot
MastreBedRoomEnemy5:
    DEFB 0, 0, 0, 0, 0
MastreBedRoomEnemy6:
    DEFB 0, 0, 0, 0, 0
MastreBedRoomEnemy7:
    DEFB 0, 0, 0, 0, 0
MastreBedRoomEnemy8:
    DEFB 0, 0, 0, 0, 0

MastreBedRoomPosWilly:
    db 200, 104                   ; Posizione di Willy
MastreBedRoomEnemyColors5_8:
    DEFB 2, 3, 4, 7               ; Colori per nemici 5-8