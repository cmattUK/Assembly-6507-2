;EXCERCISE 4
    processor 6502
	seg Code 	; Define a new segment named "Code"
	org $F000 	; Define the origin of the ROM code at memory address $F000
Start:

	lda #100	;  Load the A register with the literal decimal value 100#

	clc			; We always clear the carry flag before claling ADC (Add with Carry)
	adc #5		; Add the decimal value 5 to the accumulator

	sec			; We always set the carry flag to 1 before subtraction
	sbc #10		; Subtract the decimal value 10 from the accumulator
				; Register A should now contain the decimal 95 (or $5F in hexadecimal)
	
	jmp Start	; Jump back to Start label

    org $FFFC 	; End the ROM by adding required values to memory position $FFFC
	.word Start ; Put 2 bytes with the reset address at memory position $FFFC
	.word Start ; Put 2 bytes with the break address at memory position $FFFE