;===========================================================================
; TheBathroom.asm  
;
; TheBathroomLayout       Size 128 Byte, Start Byte   0
; TheBathroomTile         Size  32 Byte, Start Byte 128
; TheBathroomBackground   Size   9 Byte, Start Byte 160
; TheBathroomFloor        Size   9 Byte, Start Byte 169
; TheBathroomWall         Size   9 Byte, Start Byte 178
; TheBathroomNasty        Size   9 Byte, Start Byte 187
; TheBathroomRamp         Size   9 Byte, Start Byte 196
; TheBathroomConveyor     Size   9 Byte, Start Byte 205
; TheBathroomConveyorData Size   4 Byte, Start Byte 214
; TheBathroomRampData     Size   4 Byte, Start Byte 218
; TheBathroomBorderColor  Size   1 Byte, Start Byte 222
; TheBathroomReserved     Size   4 Byte, Start Byte 223
; TheBathroomItem		   Size   8 Byte, Start Byte 227
; TheBathroomDirection    Size   4 Byte, Start Byte 235
; TheBathroomUnused       Size   1 Byte, Start Byte 239
; TheBathroomEnemy1		Size   5 Byte, Start Byte 240
; TheBathroomEnemy2		Size   5 Byte, Start Byte 245
; TheBathroomEnemy3		Size   5 Byte, Start Byte 250
; TheBathroomEnemy4		Size   5 Byte, Start Byte 255
; TheBathroomPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (Master Bedroom)
TheBathroomLayout:           
    DEFB 160,0,0,0,0,0,0,10	
    DEFB 160,0,0,0,0,0,0,10
    DEFB 160,0,0,0,0,0,0,10
    DEFB 0,0,0,0,0,0,0,10
    DEFB 0,0,0,0,0,0,0,10
    DEFB 85,85,85,80,37,85,85,90
    DEFB 128,0,0,0,32,0,0,10
    DEFB 128,0,0,0,32,0,0,10
    DEFB 128,0,0,0,32,0,0,10
    DEFB 128,0,0,0,32,0,0,10
    DEFB 128,0,0,0,32,0,0,10
    DEFB 128,0,0,0,32,0,0,10
    DEFB 128,0,0,0,32,0,0,10
    DEFB 0,5,64,0,0,0,0,10
    DEFB 0,0,0,0,0,0,0,10
    DEFB 85,85,85,85,85,85,85,90

TheBathroomTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "          The Bathroom          "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheBathroomBackground:                    ; Background
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

TheBathroomFloor:
    DEFB 22,0,64,9,100,146,45,150,255       ; Floor Solid

TheBathroomWall:
    DEFB 14,31,170,0,85,248,85,0,170   ; Wall Solid

TheBathroomNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

TheBathroomRamp:
    DEFB 7,3,0,12,0,48,0,192,0              ; Ramp Solid

TheBathroomConveyor:
    DEFB 61,165,0,0,0,0,0,0,255                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheBathroomConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24532	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 4	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheBathroomRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24457                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 8	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheBathroomBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheBathroomReserved:
    DEFB 4, WHITE, 0, 0     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheBathroomItem:
    DEFB 31,4,10,119,135,177,170,10	                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheBathroomDirection:
    ROOM RoomsListTable.TopLandingLayout	                                ;Room to the left (Top Landing)
    ROOM RoomsListTable.HalfwayUpTheEastWallLayout	                                ;Room to the right (Halfway up the East Wall)
    ROOM RoomsListTable.EmergencyGeneratorLayout	                                ;Room above (Emergency Generator)
    ROOM RoomsListTable.TheChapelLayout                                 ;Room below (The Chapel)

TheBathroomUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheBathroomEnemy1:
    DEFB $80, UCCELLO, 8, 23, 200         
TheBathroomEnemy2:
    DEFB $80, VATER, 210, 104, 225       
TheBathroomEnemy3:
    DEFB 0, 0, 0, 0, 0         
TheBathroomEnemy4:
    DEFB 0, 0, 0, 0, 0       
TheBathroomEnemy5:
    DEFB 0, 0, 0, 0, 0
TheBathroomEnemy6:
    DEFB 0, 0, 0, 0, 0
TheBathroomEnemy7:
    DEFB 0, 0, 0, 0, 0
TheBathroomEnemy8:
    DEFB 0, 0, 0, 0, 0

TheBathroomPosWilly:
    db 200, 104                     ; Posizione di Willy
TheBathroomEnemyColors5_8:
    DEFB 2, 3, 4, 7     ; Colori per nemici 5-8