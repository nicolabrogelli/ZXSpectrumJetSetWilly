;===========================================================================
; resources.asm
;
; Gestione delle risorse statiche non modificabili del gioco.
; Contiene le stanze (livelli) e le sprite dei personaggi.
;===========================================================================

    org $8400
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
    include "rooms/TheChapel.asm"                   ; ID 27
    include "rooms/FirstLanding.asm"                ; ID 28
    include "rooms/TheNightmareRoom.asm"            ; ID 29
    include "rooms/TheBanyanTree.asm"               ; ID 30
    include "rooms/SwimmingPool.asm"                ; ID 31
    include "rooms/HalfwayUpTheEastWall.asm"        ; ID 32
    include "rooms/TheBathroom.asm"                 ; ID 33
    include "rooms/TopLanding.asm"                  ; ID 34
    include "rooms/MasterBedRoom.asm"               ; ID 35
    include "rooms/ABitOfTree.asm"                  ; ID 36
    include "rooms/Orangery.asm"                    ; ID 37
    include "rooms/PriestsHole.asm"                 ; ID 38
    include "rooms/EmergencyGenerator.asm"          ; ID 39
    include "rooms/DrJonesWillNeverBelieveThis.asm" ; ID 40
    include "rooms/TheAttic.asm"                    ; ID 41
    include "rooms/UnderTheRoof.asm"                ; ID 42
    include "rooms/ConservatoryRoof.asm"            ; ID 43
    include "rooms/OnTopOfTheHouse.asm"             ; ID 44
    include "rooms/UnderTheDrive.asm"               ; ID 45
    include "rooms/TreeRoot.asm"                    ; ID 46
    include "rooms/NotUsed.asm"                     ; ID 47
    include "rooms/NomenLuni.asm"                   ; ID 48
    include "rooms/TheWineCellar.asm"               ; ID 49
    include "rooms/WatchTower.asm"                  ; ID 50
    include "rooms/ToolShed.asm"                    ; ID 51
    include "rooms/BackStairway.asm"                ; ID 52
    include "rooms/BackDoor.asm"                    ; ID 53
    include "rooms/WestWing.asm"                    ; ID 54
    include "rooms/WestBedroom.asm"                 ; ID 55
    include "rooms/WestWingRoof.asm"                ; ID 56
    include "rooms/AbovetheWestBedroom.asm"         ; ID 57
    include "rooms/TheBeach.asm"                    ; ID 58
    include "rooms/TheYacht.asm"                    ; ID 59
    include "rooms/TheBow.asm"                      ; ID 60

    include "data/datasprite.asm"

items_grid:
    .512 db 0
