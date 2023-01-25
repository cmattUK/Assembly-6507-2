    ;declare processor type
    processor 6502

    ;include files
    include "vcs.h"
    include "macro.h"

    ;start our code segment
    seg code
    org $f000 ; Defines the original of our ROM at £F000

START:
    CLEAN_START ;Macro to clean memory safely (all registers)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set background colour to yellow                                  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #$1E ;load accumulator(register A) with colour value (yellow in NTSC)
    sta COLUBK   ;store A vlaue to backgorund colour memory address $09

    jmp START       ;repeat from START:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fill ROM size to exactly 4 KB                               
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC ; set our origin to $FFFC
    .word START ; reset vector at $FFFC (where the program starts)
    .word START ; Intterupt vector at $FFFE (unused in the VCS but still needs setting)

