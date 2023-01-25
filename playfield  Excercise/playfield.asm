        processor 6502
        include "vcs.h"
        include "macro.h"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code segment
	seg
        org $F000
        
Reset:
	    CLEAN_START
        ldx #$80 ; Blue bacKgorund color
        stx COLUBK ; store the 'x' clor value in the COLUBK = TIA regoister
        
        lda #$1C ; Yellow playfield colour
        sta COLUPF ; store that yellow in the TIA register responsible for the playfield = macro script


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start a new frame by configuring VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartFrame:
	    lda #02
        sta VBLANK ; turn VBLANK on
        sta VSYNC ; turn VSYNCE on
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate the three lines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        REPEAT 3
        	sta WSYNC ; wiat for the WSYNC to send a signal that the last scanline is done
        REPEND
        lda #0
        sta VSYNC	; turn off VSYNC
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate 37 scanlines for VBLANC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 	
    REPEAT 37
        sta WSYNC
        REPEND
        lda #0
        sta VBLANK ;Turno off VBLANK
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set the CTRLPF to allow playfield reflection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 	ldx #%00000001 ; CTRPLF register (D0 means reflect the PF)
        stx CTRLPF
        
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw the 192 visible scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; skip 7 scanlines with no PF set
        ldx #0
        stx PF0	; disable the whole playfield
        stx PF1
        stx PF2
        ; reapeate the diable 7 times
        REPEAT 7
        	sta WSYNC	;wait for scanlines to finish
        REPEND
        
        ; set thge PF0 to 1110 (Lsb = Least Signinifcant Bit first) and PF1 - PF2 as 1111 1111
        ldx #%11100000 ;TF0 ignore the last 4 bits
        stx PF0
        ldx #%11111111
        stx PF1 
        stx PF2
        Repeat 7
        	sta WSYNC
        REPEND
        
        ; set the next 164 line sonly with the PF0 enabled and a single line down the center

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; makes this (excorcise):
        ;       ||------------||----------||
        ;       ||------------||----------||
        ;       ||------------||----------||
        ;       ||------------||----------||
        ;       ||------------||----------||
        ;       ||------------||----------||
        ;       ||------------||----------||

        ldx #%00100000
        stx PF0
        ldx #0
        stx PF1
        ldx #%10000000
        stx PF2
        REPEAT 164
        	sta WSYNC
        REPEND
        
        
        ;; Bottom playfield
        ; set thge PF0 to 1110 (Lsb = Least Signinifcant Bit first) and PF1 - PF2 as 1111 1111
        ldx #%11100000 ;TF0 ignore the last 4 bits
        stx PF0
        ldx #%11111111
        stx PF1 
        stx PF2
        Repeat 7
        	sta WSYNC
        REPEND
        
     
        ; under the bottom 7 playfield lines
	; skip 7 scanlines with no PF set
        ldx #0
        stx PF0	; disable the whole playfield
        stx PF1
        stx PF2
        ; reapeate the diable 7 times
        REPEAT 7
        	sta WSYNC	;wait for scanlines to finish
        REPEND
        
        

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Output 30 more sc-lines for VBLANK overscan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	REPEAT 30
        	sta WSYNC
        REPEND
        lda #0
        sta VBLANK
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Loop to next frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp StartFrame
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Epilogue

	org $fffc
        .word Reset	; reset vector
        .word Reset	; BRK vector
