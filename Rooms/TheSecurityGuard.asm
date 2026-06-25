;===========================================================================
; TheSecurityGuard.asm  
;
; TheSecurityGuardLayout       Size 128 Byte, Start Byte   0
; TheSecurityGuardTile         Size  32 Byte, Start Byte 128
; TheSecurityGuardBackground   Size   9 Byte, Start Byte 160
; TheSecurityGuardFloor        Size   9 Byte, Start Byte 169
; TheSecurityGuardWall         Size   9 Byte, Start Byte 178
; TheSecurityGuardNasty        Size   9 Byte, Start Byte 187
; TheSecurityGuardRamp         Size   9 Byte, Start Byte 196
; TheSecurityGuardConveyor     Size   9 Byte, Start Byte 205
; TheSecurityGuardConveyorData Size   4 Byte, Start Byte 214
; TheSecurityGuardRampData     Size   4 Byte, Start Byte 218
; TheSecurityGuardBorderColor  Size   1 Byte, Start Byte 222
; TheSecurityGuardReserved     Size   4 Byte, Start Byte 223
; TheSecurityGuardItem		   Size   8 Byte, Start Byte 227
; TheSecurityGuardDirection    Size   4 Byte, Start Byte 235
; TheSecurityGuardUnused       Size   1 Byte, Start Byte 239
; TheSecurityGuardEnemy1		Size   4 Byte, Start Byte 240
; TheSecurityGuardEnemy2		Size   4 Byte, Start Byte 244
; TheSecurityGuardEnemy3		Size   4 Byte, Start Byte 248
; TheSecurityGuardEnemy4		Size   4 Byte, Start Byte 252
; TheSecurityGuardPosWilly     Size   2 Byte, Start Byte 256
;
;===========================================================================

; Room layout for Room  (Master Bedroom)
TheSecurityGuardLayout:           
    DEFB 128,0,0,0,0,0,0,0
    DEFB 160,0,0,0,0,0,0,0
    DEFB 168,0,0,0,0,0,0,0
    DEFB 170,0,0,0,0,0,0,0
    DEFB 170,128,0,0,0,0,0,0
    DEFB 170,160,0,0,0,0,0,0
    DEFB 168,0,0,0,0,0,0,0
    DEFB 168,0,0,0,0,0,0,0
    DEFB 168,21,84,16,65,84,21,85
    DEFB 168,42,168,32,130,168,42,170
    DEFB 0,0,168,32,130,168,42,170
    DEFB 0,0,168,32,130,168,40,0
    DEFB 0,0,168,32,130,168,40,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,42
    DEFB 160,10,170,170,170,170,170,170

TheSecurityGuardTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "       The Security Guard       "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheSecurityGuardBackground:
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

TheSecurityGuardFloor:
    DEFB 4,255,255,170,85,170,85,170,85	    ;Floor Solid

TheSecurityGuardWall:
    DEFB 13,14,198,149,176,54,134,192,237	;Wall Solid

TheSecurityGuardNasty:
    DEFB 255,0,0,0,0,0,0,0,0	            ;Nasty

TheSecurityGuardRamp:
    DEFB 7,224,64,32,16,14,4,2,1	        ;Ramp Solid

TheSecurityGuardConveyor:
    DEFB 66,111,0,183,0,170,85,170,85	    ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheSecurityGuardConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24509	                            ;Location in the attribute buffer at 24064: (15,12)
    DEFB 3	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheSecurityGuardRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24296                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 8	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheSecurityGuardBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheSecurityGuardReserved:
    DEFB 2, 3, 4, 7                         ; Enemy colors: all WHITE (7)

;The next eight bytes are copied to 32993 and define the item graphic.
TheSecurityGuardItem:
    DEFB 64,160,92,34,33,34,20,8	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheSecurityGuardDirection:
    DEFB 2	                                ;Room to the left (Under the MegaTree)
    DEFB 0	                                ;Room to the right (The Off Licence)
    DEFB 33	                                ;Room above (The Bathroom)
    DEFB $FF                                ;Room below (None)

TheSecurityGuardUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheSecurityGuardEnemy1:
    DEFB 0,0,0,0        ; Enemy 1 (Uccello), horizontal, Starts X=8, Y=120, Limit X=200
TheSecurityGuardEnemy2:
    DEFB 0,0,0,0         ; Enemy 2 (Uccello), horizontal, Starts X=80, Y=80, Limit X=180
TheSecurityGuardEnemy3:
    DEFB $C1, 120, 16, 76        ; Enemy 3 (Ufo), vertical, Starts X=120, Y=40, Limit Y=130
TheSecurityGuardEnemy4:
    DEFB 0,0,0,0                  ; Empty slot

TheSecurityGuardPosWilly:
    db 200, 101                   ; Posizione di Willy