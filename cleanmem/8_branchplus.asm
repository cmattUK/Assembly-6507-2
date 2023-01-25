;EXCERCISE 8
   
    	processor 6502
	seg Code 	; Define a new segment named "Code"
	org $F000 	; Define the origin of the ROM code at memory address $F000

Start:
	ldy #10 	; Initialize the Y register with the decimal value 10

Loop:
	tya 		; Transfer Y to A
	sta $80,Y	; Add the value in Y to the memomry addres $90 (loop: 8a 89 87 86 85 84 83 82 81 80) Store the value in A inside memory position $80 +Y (indexed addressing mode)
	dey		    ; Decrement Y
	bpl Loop	; decrememnt while the number is positive - Branch back to "Loop" until we are done.
				; bnp means we will use memory address $00


    org $FFFC 	; End the ROM by adding required values to memory position $FFFC
	.word Start 	; Put 2 bytes with the reset address at memory position $FFFC
	.word Start 	; Put 2 bytes with the break address at memory position $FFFE