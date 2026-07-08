;===========================================================================
; TheDrive.asm  
;
; TheDriveLayout            Size 128 Byte, Start Byte   0
; TheDriveTile              Size  32 Byte, Start Byte 128
; TheDriveBackground        Size   9 Byte, Start Byte 160
; TheDriveFloor             Size   9 Byte, Start Byte 169
; TheDriveWall              Size   9 Byte, Start Byte 178
; TheDriveNasty             Size   9 Byte, Start Byte 187
; TheDriveRamp              Size   9 Byte, Start Byte 196
; TheDriveConveyor          Size   9 Byte, Start Byte 205
; TheDriveConveyorData      Size   4 Byte, Start Byte 214
; TheDriveRampData          Size   4 Byte, Start Byte 218
; TheDriveBorderColor       Size   1 Byte, Start Byte 222
; TheDriveReserved          Size   4 Byte, Start Byte 223
; TheDriveItem		        Size   8 Byte, Start Byte 227
; TheDriveDirection         Size   4 Byte, Start Byte 235
; TheDriveUnused            Size   1 Byte, Start Byte 239
; TheDriveEnemy1		    Size   5 Byte, Start Byte 240
; TheDriveEnemy2		    Size   5 Byte, Start Byte 245
; TheDriveEnemy3		    Size   5 Byte, Start Byte 250
; TheDriveEnemy4		    Size   5 Byte, Start Byte 255
; TheDriveEnemy5		    Size   5 Byte, Start Byte 260
; TheDriveEnemy6		    Size   5 Byte, Start Byte 265
; TheDriveEnemy7		    Size   5 Byte, Start Byte 270
; TheDriveEnemy8		    Size   5 Byte, Start Byte 275
; TheDrivePosWilly          Size   2 Byte, Start Byte 280
; TheDriveEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (The Drive)
TheDriveLayout:           
    DEFB 0,0,0,0,0,0,0,0	
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 84,0,0,0,0,0,0,0
    DEFB 170,0,0,0,0,0,0,0
    DEFB 170,128,0,0,0,0,0,0
    DEFB 0,160,0,0,0,0,0,0
    DEFB 0,168,0,0,0,0,0,0
    DEFB 0,170,0,0,0,0,0,0
    DEFB 160,170,128,0,0,0,0,0
    DEFB 160,170,165,85,85,90,85,85

TheDriveTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "            The Drive           "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheDriveBackground:
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

TheDriveFloor:
    DEFB 6,170,85,170,255,255,85,170,85	    ;Floor Solid

TheDriveWall:
    DEFB 13,112,7,119,119,0,59,11,125	    ;Wall Solid

TheDriveNasty:
    DEFB 68,20,42,20,9,106,156,8,8	        ;Nasty

TheDriveRamp:
    DEFB 5,192,64,112,112,12,116,119,5	            ;Ramp Solid

TheDriveConveyor:
    DEFB 66,123,0,237,0,170,85,170,85	            ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheDriveConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24480	                            ;Location in the attribute buffer at 24064: (15,12)
    DEFB 2	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheDriveRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24521                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 7	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheDriveBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheDriveReserved:
    DEFB MAGENTA, GREEN, YELLOW, CYAN                         ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheDriveItem:
    DEFB 64,160,92,34,33,34,20,8	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheDriveDirection:
    DEFB 5	                                ;Room to the left (The Security Guard)
    DEFB 3	                                ;Room to the right  (Gfx_At the Foot of the MegaTree)
    DEFB 6	                                ;Room above (Entrance to Hades)
    DEFB 45                                 ;Room below (Under the Drive)

TheDriveUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheDriveEnemy1:
    DEFB $80, 2, 112, 80, 232         ; [Uccello (41136) - horizontal], Guardian = 22, Starts X=128, Y=88, Limit X=232
TheDriveEnemy2:
    DEFB $80, 2, 128, 88, 232         ; [Uccello (41136) - horizontal], Guardian = 22, Starts X=128, Y=88, Limit X=232
TheDriveEnemy3:
    DEFB $80, 2, 40, 64, 232          ; [Uccello (41144) - horizontal], Guardian = 23, Starts X=40, Y=64, Limit X=232
TheDriveEnemy4:
    DEFB $80, 2, 0, 40, 80            ; [Uccello (41152) - horizontal], Guardian = 24, Starts X=0, Y=40, Limit X=80
TheDriveEnemy5:
    DEFB $80, 4, 80, 104, 240         ; [Uovo (41248) - horizontal], Guardian = 36, Starts X=80, Y=104, Limit X=240
TheDriveEnemy6:
    DEFB 0, 0, 0, 0, 0
TheDriveEnemy7:
    DEFB 0, 0, 0, 0, 0
TheDriveEnemy8:
    DEFB 0, 0, 0, 0, 0

TheDrivePosWilly:
    db 200, 101                      ; Posizione di Willy

TheDriveEnemyColors5_8:
    DEFB CYAN, 3, 4, 7               ; Colori per nemici 5-8