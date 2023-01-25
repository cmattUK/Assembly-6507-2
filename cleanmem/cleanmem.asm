    processor 6502     ; what is the processor we're using

    seg code     ; we are starting a segment of code
    org $F000    ; Define the code origin at $F000 (start of ROM)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;   RESET THE CARTRIDGE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Start:      ; label called 'Start'- this is an alias to the memory address we just defined
    sei     ; Disable interrupts all cratridges start with this
    cld     ; Disabled the BCD decimal math mode
    ldx #$FF    ; loads the X register with #$FF value
    txs     ; transfer the X register to the (s)tack pointer register

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Clear the Page Zero region ($00 to $FF)
;   Meaning the entire RAM (starting at $80) will be cleaned and also the entire TIA (starting at $00)register
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;set registers

    lda #0 ; A = 0
    ldx #$FF ; x = #$FF
    sta $FF ; make sure $FF is zeroed before the loop starts (store the value of the A register at the memory position $FF)

;Loop through
MemLoop:
    dex     ; Decrement whatever is insid ethe X register (x--)
    sta $0,X ; Store the value of A inside memory address $0 + whatever is in the X register
    bne MemLoop ; loop through each register until it 'flags' as zero (until Z flag is set)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Fill the ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    org $FFFC ; jump to origin position $FFFC
    .word Start ; Reset vector at $SFFC (where the program starts) 
    .word Start ; interupt vector at $FFFE (unused in the VCS)