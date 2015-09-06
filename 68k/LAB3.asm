*-----------------------------------------------------------
* Title      : LAB 3 Assignment
* Written by : Luiz Medeiros
* Date       :
* Description: Working with subroutines for the 68k; This program is made to 
* Manipulate a binary hex image; There are two tests in this file. 
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
*   LAB 3 WORK
*    MOVEA.L #COUNTER,A5
*    ADDI.B  #1,COUNTER
*    ADDI.B  #1,COUNTER
*    MOVE.L  #$0000100A,D0
*    MOVE.L  D0,-(A7)
*    ADDI.L  #8,D0
*    MOVE.L  D0,-(SP)
*    JSR     SUBROUTINE
*    MOVE.B  #3,D3
    MOVEA.L #SUBROUTINE,A0
    LINK    A0,#-32
    MOVE.B  #1,D0
    MOVE.L  NUM,-(A7)

    SIMHALT
NUM
    DC.L    $f23439
COUNTER DC.B    0

SUBROUTINE
    MOVE.B  #1,D1
    MOVE.B  #2,D2
    RTS

    END    START        ; last line of source

			ORG 		$0900			;start program at this address
LAB31		
                           ; INDEX i;
            BSR 		NEG			;call subroutine negative
			BSR 		USD			;call subroutine upside down
			;BSR 		LSR			;call subroutine left side right
			;BSR        FRAME       ; CALL THE FRAME SUBROUTINE. 
			BRA		STOP			;stop the program

NEG		;create the negative subroutine
    MOVE.B  #0,D1
    LEA     IMAGE,A0
    LEA     IMNEG,A1
    MOVE.L  #$C0C0C0C0,D0       ;THE COMPARING REGISTER
NEGLOOP    
    CMP.L   (A0,D1),D0
    BEQ     RETURN
    MOVE.W  (A0,D1),(A1,D1)     ;COPYING THE CONTENTS TO THE NEW IMAGE STORAGE
    NOT.W   (A1,D1)             ; 2'S COMPLEMENT   
    ;SUBI.W  #1,(A1,D1)          ;SINCE THE NEG. OPERATION PERFORMED A 2'S COMPLEMENT,HERE WE ARE SUBTRACTING THE ADDED 1.
    ADDI.B  #2,D1
    BRA     NEGLOOP
    
    

USD		        ;create the upside down subroutine
    MOVE.B  #0,D1      ;THIS IS j=n=16;
    MOVE.B  #0,D0       ; THIS IS i;
    LEA     IMAGE,A0
    LEA     IMUSD,A1
TRAVERSING
    MOVE.W  (A0,D1),D2
    CMPI.W  #$COCO,D2
    BEQ     EQUALUSD    
    ADDI.B  #1,D1
    BRA     TRAVERSING
  
EQUALUSD
    
WHILEUSD
    CMP.B   D1,D0
    BGE     RETURN    
    CMP.B   D0,D1
    BLT     RETURN      ; THE ABOVE LOGIC STATES: WHILE i<n AND j>=0 ... DO SOMETHING... OTHERWISE, RETURN;
    MOVE.W  (A0,D1),(A1,D0)     ;A1[i]=A0[j];
    SUBI.B  #2,D1       ;j=j-2;
    ADDI.B  #2,D0       ;i=i+2;
    BRA     WHILEUSD
    
 
    
LSR	
    LEA     IMAGE,A0
    LEA     IMLSR,A1
    LEA     BARRAY,A5
    MOVE.B  #1,D0       ;INDEX i
    MOVE.B  #8,D1       ;INDEX j

FRAME
    ;THIS IS WHERE THE FRAME SUBROUTINE WILL BE AT . 
    ; USING BSET AND BCHG INSTRUCTIONS SHOULD FACILITATE THIS PART OF THE IMAGE MANIPULATON . 
    
BARRAY  
    DS.B    8       ; BINARY ARRAY WHICH WILL HOLD THE OUTPUT ARRAYS . 	
    
			ORG     $0C00			;at this address, create an image
IMAGE		DC.W		$0000			;................
			DC.W		$0000			;................ 
			DC.W		$3FE0			;..111111111.....
			DC.W		$3FF0			;..1111111111....
			DC.W		$3878			;..111....1111...
			DC.W		$3838			;..111.....111...
			DC.W		$3838			;..111.....111...
			DC.W		$3870			;..111....111....
			DC.W		$3FE0			;..111111111.....
			DC.W		$3FE0			;..111111111.....
			DC.W		$3870			;..111....111....
			DC.W		$3870			;..111....111....
			DC.W		$3838			;..111.....111...
			DC.W		$3838			;..111.....111...
			DC.W		$0000			;................
			DC.W		$0000			;................
			DC.L		$C0C0C0C0	    ;a marker at the end of original image 

			ORG		$0C40			;at this address
IMNEG	    DS.W		16				;allocate space for negative image
			DC.L		$C4C4C4C4	;a marker at the end of negative image

			ORG		$0C80			;at this address
IMUSD	    DS.W		16				;allocate space for upside down image
			DC.L		$C8C8C8C8	;a marker at the end of flipped image

			ORG		$0CC0			;at this address
IMLSR	    DS.W		16				;allocate space for left side right
			DC.L		$CCCCCCCC	;a marker at the end of rotated image

RETURN
    ;ADDA.L  #4,SP       ;POPPING THE ADDRESS SO WE CAN RETURN TO THE PREVIOUS LOOP
    CLR.L   D0
    CLR.L   D1
    CLR.L   D2
    CLR.L   D3
    CLR.L   D4
    CLR.L   D5
    CLR.L   D6
    CLR.L   D7
    RTS


STOP		MOVE.B 	#228,D7
			;TRAP 		#14


			END     LAB3




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
