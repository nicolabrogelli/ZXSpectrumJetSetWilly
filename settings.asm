;===========================================================================
; settings.asm
;
; Impostazioni e flag di configurazione a tempo di compilazione per Jet Set Willy.
; Ogni flag può essere abilitato (1) o disabilitato (0).
; Possono anche essere sovrascritti via riga di comando con sjasmplus 
; (es. -DENABLE_MUSIC=0 -DENABLE_GUARDIAN_COLLISION_DEATH=0).
;===========================================================================

; --- Musica di sottofondo ---
; 1 = Musica abilitata
; 0 = Musica disabilitata
    IFNDEF ENABLE_MUSIC
ENABLE_MUSIC EQU 0
    ENDIF

; --- Morte per collisione con i guardiani (nemici) ---
; 1 = Abilita la morte e il decremento delle vite alla collisione con i guardiani
; 0 = Disabilita la morte (disegna le raster bar di debug sul bordo)
    IFNDEF ENABLE_GUARDIAN_COLLISION_DEATH
ENABLE_GUARDIAN_COLLISION_DEATH EQU 0
    ENDIF

; --- Morte per collisione con gli elementi Nasty (tiles pericolose) ---
; 1 = Abilita la morte e il decremento delle vite al tocco delle Nasty tiles
; 0 = Disabilita il controllo di morte sulle Nasty tiles
    IFNDEF ENABLE_NASTY_COLLISION_DEATH
ENABLE_NASTY_COLLISION_DEATH EQU 0
    ENDIF

; --- Animazione delle icone delle vite ---
; 1 = Abilita l'animazione camminante per le icone delle vite in basso a schermo
; 0 = Icone delle vite statiche
    IFNDEF ENABLE_ANIMATE_LIVES
ENABLE_ANIMATE_LIVES EQU 1
    ENDIF
