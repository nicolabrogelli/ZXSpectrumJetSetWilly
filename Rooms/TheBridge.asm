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
TheBridgeBackground:
    DEFB $07,0,0,0,0,0,0,0,0	                ;Background

TheBridgeFloor:
    DEFB 68,255,255,253,187,214,114,96,64	;Floor Solid

TheBridgeWall:
    DEFB 70,34,119,34,136,34,119,34,136	    ;Wall Solid

TheBridgeNasty:
    DEFB 47,3,132,72,48,3,132,72,48	        ;Nasty

TheBridgeRamp:
    DEFB 7,3,3,12,13,50,55,194,200	        ;Ramp Solid

TheBridgeConveyor:
    DEFB 44,1,64,4,70,79,121,240,249	    ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheBridgeConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24556	                            ;Location in the attribute buffer at 24064: (15,12)
    DEFB 5	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheBridgeRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24519	                            ;Location in the attribute buffer at 24064: (14,7)
    DEFB 3	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheBridgeBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheBridgeReserved:
    DEFB 64,160	                            ;Unused

;The next eight bytes are copied to 32993 and define the item graphic.
TheBridgeItem:
    DEFB 0,0,0,0,0,0,0,0	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheBridgeDirection:
    DEFB 2	                                ;Room to the left (Under the MegaTree)
    DEFB 0	                                ;Room to the right (The Off Licence)
    DEFB 0	                                ;Room above (The Off Licence)
    DEFB 0	                                ;Room below (The Off Licence)

;The next three bytes are copied to 33005, but are not used.
TheBridgeUnused:
    DEFB 0,0,0	                            ;Unused

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheBridgeEnemy1:
    DEFB $80, 8, 120, 200         ; Enemy 1 (Lametta), horizontal, Starts X=8, Y=120, Limit X=200
TheBridgeEnemy2:
    DEFB $80, 80, 80, 180         ; Enemy 2 (Lametta), horizontal, Starts X=80, Y=80, Limit X=180
TheBridgeEnemy3:
    DEFB $C1, 120, 40, 130        ; Enemy 3 (Egg), vertical, Starts X=120, Y=40, Limit Y=130
TheBridgeEnemy4:
    DEFB 0,0,0,0                  ; Empty slot
