;EXCERCISE 6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   In the 6502 we can  directly inrement/decrement but we cannot do it to the (A) Accumulator  ;
;   Using X and Y regitsters great choices to create contorl loops                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    processor 6502
	seg Code 	; Define a new segment named "Code"
	org $F000 	; Define the origin of the ROM code at memory address $F000

Start:

	lda #1		; Load the A register with the decimal value 1
	ldx #2	    ; Load the X register with the decimal value 2
	ldy #3	    ; Load the Y register with the decimal value 3
        
        
	inx	        ; Increment X
	iny	        ; Increment Y
        
                ;;;;;;;;; Increment A ;;;;;;;;;;;;;;
    clc	        ; We ALWAYS CLEAR THE CARRY FLAG before adc
	adc #1	    ; Increment A by one
	
    dex	        ; Decrement X
	dey	        ; Decrement Y
        
                ;;;;;;;;; Decrement A ;;;;;;;;;;;;;
    sec	        ; WE ALWAYS SET the carry flag to one when using adc
	sbc #1	    ; Decrement A by one



	jmp Start	;Jump back to Start label

	
    org $FFFC 	; End the ROM by adding required values to memory position $FFFC
	.word Start ; Put 2 bytes with the reset address at memory position $FFFC
	.word Start ; Put 2 bytes with the break address at memory position $FFFE