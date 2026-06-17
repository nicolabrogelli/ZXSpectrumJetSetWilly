;===========================================================================
; TheBedroom.asm   
;
; Ho creato solo il template deve essere gestito con i dati corretti della stanza
;
; TheBedroomLayout       Size 128 Byte, Start Byte   0
; TheBedroomTile         Size  32 Byte, Start Byte 128
; TheBedroomBackground   Size   9 Byte, Start Byte 160
; TheBedroomFloor        Size   9 Byte, Start Byte 169
; TheBedroomWall         Size   9 Byte, Start Byte 178
; TheBedroomNasty        Size   9 Byte, Start Byte 187
; TheBedroomRamp         Size   9 Byte, Start Byte 196
; TheBedroomConveyor     Size   9 Byte, Start Byte 205
; TheBedroomConveyorData Size   4 Byte, Start Byte 214
; TheBedroomRampData     Size   4 Byte, Start Byte 218
; TheBedroomBorderColor  Size   1 Byte, Start Byte 222
; TheBedroomReserved     Size   4 Byte, Start Byte 223
; TheBedroomItem		    Size   8 Byte, Start Byte 227
; TheBedroomDirection    Size   4 Byte, Start Byte 235
; TheBedroomUnused       Size   1 Byte, Start Byte 239
; TheBedroomEnemy1		Size   4 Byte, Start Byte 240
; TheBedroomEnemy2		Size   4 Byte, Start Byte 244
; TheBedroomEnemy3		Size   4 Byte, Start Byte 248
; TheBedroomEnemy4		Size   4 Byte, Start Byte 252
; TheBedroomPosWilly     Size   2 Byte, Start Byte 256
;
;===========================================================================

; Room layout for Room  (The Bedroom)
TheBedRoomLayout:           
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

TheBedRoomTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         The Bedrooms           "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheBedRoomBackground:
    DEFB $07,0,0,0,0,0,0,0,0	                ;Background

TheBedRoomFloor:
    DEFB 68,255,255,253,187,214,114,96,64	;Floor Solid

TheBedRoomWall:
    DEFB 70,34,119,34,136,34,119,34,136	    ;Wall Solid

TheBedRoomNasty:
    DEFB 47,3,132,72,48,3,132,72,48	        ;Nasty

TheBedRoomRamp:
    DEFB 7,3,3,12,13,50,55,194,200	        ;Ramp Solid

TheBedRoomConveyor:
    DEFB 44,1,64,4,70,79,121,240,249	    ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheBedRoomConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24556	                            ;Location in the attribute buffer at 24064: (15,12)
    DEFB 5	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheBedRoomRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24519	                            ;Location in the attribute buffer at 24064: (14,7)
    DEFB 3	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheBedRoomBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheBedRoomReserved:
    DEFB 2, 3, 4, 7                         ; Enemy colors: all WHITE (7)

;The next eight bytes are copied to 32993 and define the item graphic.
TheBedRoomItem:
    DEFB 0,0,0,0,0,0,0,0	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheBedRoomDirection:
    DEFB 2	                                ;Room to the left (Under the MegaTree)
    DEFB 0	                                ;Room to the right (The Off Licence)
    DEFB 0	                                ;Room above (The Off Licence)
    DEFB 0	                                ;Room below (The Off Licence)

TheBedRoomUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheBedRoomEnemy1:
    DEFB $80, 8, 100, 200         ; Enemy 1 (Uccello), horizontal, Starts X=8, Y=120, Limit X=200
TheBedRoomEnemy2:
    DEFB $80, 80, 100, 180         ; Enemy 2 (Uccello), horizontal, Starts X=80, Y=80, Limit X=180
TheBedRoomEnemy3:
    DEFB $C1, 120, 40, 130        ; Enemy 3 (Ufo), vertical, Starts X=120, Y=40, Limit Y=130
TheBedRoomEnemy4:
    DEFB 0,0,0,0                  ; Empty slot

TheBedRoomPosWilly:
    db 136, 100                   ; Posizione di Willy