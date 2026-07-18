;===========================================================================
; resources.asm
;
; Gestione delle risorse statiche non modificabili del gioco.
; Contiene le stanze (livelli) e le sprite dei personaggi.
;===========================================================================

    org $8300
RoomsStart:
    include "rooms/TheOffLicence.asm"               ; ID 00
    include "rooms/TheBridge.asm"                   ; ID 01
    include "rooms/UnderTheMegaTree.asm"            ; ID 02
    include "rooms/AtTheFootTheMegaTree.asm"        ; ID 03
    include "rooms/TheDrive.asm"                    ; ID 04
    include "rooms/TheSecurityGuard.asm"            ; ID 05
    include "rooms/EntranceToHades.asm"             ; ID 06
    include "rooms/CuckoosNest.asm"                 ; ID 07
    include "rooms/InsideTheMegaTrunk.asm"          ; ID 08
    include "rooms/OnABranchOverTheDrive.asm"       ; ID 09
    include "rooms/TheFrontDoor.asm"                ; ID 10
    include "rooms/TheHall.asm"                     ; ID 11
    include "rooms/TreeTop.asm"                     ; ID 12
    include "rooms/OutALimb.asm"                    ; ID 13
    include "rooms/RescueEsmerelda.asm"             ; ID 14
    include "rooms/IAmSureIHaveSeenThiBefore.asm"   ; ID 15
    include "rooms/WeMustPerformQuirkafleeg.asm"    ; ID 16
    include "rooms/UpOnTheBattlements.asm"          ; ID 17
    include "rooms/OntheRoof.asm"                   ; ID 18
    include "rooms/TheForgottenAbbey.asm"           ; ID 19
    include "rooms/BallRoomEast.asm"                ; ID 20
    include "rooms/BallRoomWest.asm"                ; ID 21
    include "rooms/TotheKitchensMainStairway.asm"   ; ID 22
    include "rooms/TheKitchen.asm"                  ; ID 23
    include "rooms/WestofKitchen.asm"               ; ID 24
    include "rooms/ColdStore.asm"                   ; ID 25
    include "rooms/EastWallBase.asm"                ; ID 26
    include "rooms/TheChapel.asm"                    ; ID 27
    

    include "rooms/TheBathroom.asm"                 ; ID 33
    include "rooms/MasterBedRoom.asm"               ; ID 35
    include "rooms/UnderTheDrive.asm"               ; ID 45

    org 40968
    DEFB %00000011    ; Rope (bits 0-2), initially swinging right to left (bit 7)
    DEFB 34           ; Initial animation frame index
    DEFB 128          ; X-coordinate of the top of the rope (128)

    org $B200
    include "data/datasprite.asm"

