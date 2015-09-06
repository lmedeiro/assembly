*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $900
START:                  ; first instruction of program

					;start program at address #0900
PIT	EQU 		$FE8000			;initial the starting address of PIT
		LEA 		PIT,A0			;load PIT address to A0
		MOVE.B 	#$00,1(A0)		;set PIT mode0       
		MOVE.B 	#$00,5(A0)		;set port A to all outputs
		MOVE.B 	#$00,7(A0)		;set port B to all inputs
		; as noted, the LED array is at $FE8005, which is to be set in the harware screen,
		; once you set it to view. 
		; the switch array is on $FE8007, also to be set once the hardware screen comes on. 
		CLR.L	D0
		CLR.L	D1
		CLR.L	D2
		CLR.L	D3
		CLR.L	D4
		CLR.L	D5
		CLR.L	D6
		
LOOP	        ;MOVE.B 	19(A0),D1 		;read switches for port B 
		    ;MOVE.B 	D1,17(A0) 		;and light LEDs on port A
		MOVE.B      7(A0),D1        ; READING IN SWITCHES.
		MOVE.B      7(A0),D2        ; COPY FOR FURTHER USE IN CASE OF USING D1 (TIMING)
        ;MOVE.B      D1,5(A0)
        ;MOVE.B      5(A0),D3
        
		 	
TESTB7
    BTST    #7,D1        ; TESTING THE BIT 
    MOVE.W  SR,D5
    CLR.L   D4
    MOVE.B  D5,D4           ;COPYING THE LOWER BYTE OF THE STATUS REGISTER TO ANALYSE
    ANDI.B  #4,D4           ;AND %0100 WITH D4
    CMPI.B  #4,D4           ; IS %0100==D4? 
    BEQ     READ            ; IF SO, READING MODE.
    ; THIS IS WHERE ROTATION FUNCTION BEGINS. 
TESTB4
    BTST    #4,D2        ; TESTING THE BIT 
    MOVE.W  SR,D5
    CLR.L   D4
    MOVE.B  D5,D4           ;COPYING THE LOWER BYTE OF THE STATUS REGISTER TO ANALYSE
    ANDI.B  #4,D4           ;AND %0100 WITH D4
    CMPI.B  #4,D4           ; IS %0100==D4?  
    BEQ     ROTATE          ; IF IT IS 0 JUST JUMP TO ROTATE, OTHERWISE: 
    BCHG    #1,D3           ; WE CHANGE THE BITS MENTIONED, AND THEN KEEP GOING.
    BCHG    #3,D3           ; IT'S A FORM OF RANDOMIZING THE DISPLAY. 
    BCHG    #4,D3
    
    

ROTATE      
    MOVE.B  #8,D0           ; MOVING THE TASK NUMBER FOR TIME TO D0
    TRAP    #15
    MOVE.L  D1,CTIME
    MOVE.B  #0,DIF
    LEA     DIF,A2
TESTB5
    BTST    #5,D2        ; TESTING THE BIT 
    MOVE.W  SR,D5
    CLR.L   D4
    MOVE.B  D5,D4           ;COPYING THE LOWER BYTE OF THE STATUS REGISTER TO ANALYSE
    ANDI.B  #4,D4           ;AND %0100 WITH D4
    CMPI.B  #4,D4           ; IS %0100==D4?  
    BEQ     SLOW            ; GO TO THE SLOW MOVING CHECK IF EQUAL TO 0
FAST
    MOVE.B  #8,D0           ; AGAIN MOVING TASK NUMBER TO READ TIME.
    TRAP    #15
    SUB.L   CTIME,D1
    MOVE.L  D1,DIF
    CMPI.L  #10,DIF         ; OUR FAST TIMING 
    BLE     FAST
    BSR     TESTB6          
    

SLOW
    MOVE.B  #8,D0           ; AGAIN MOVING TASK NUMBER TO READ TIME.
    TRAP    #15
    SUB.L   CTIME,D1
    MOVE.L  D1,DIF
    CMPI.L  #60,DIF         ; OUR SLOW TIMING. 
    BLE     SLOW
TESTB6
    BTST    #6,D2        ; TESTING THE BIT 
    MOVE.W  SR,D5
    CLR.L   D4
    MOVE.B  D5,D4           ;COPYING THE LOWER BYTE OF THE STATUS REGISTER TO ANALYSE
    ANDI.B  #4,D4           ;AND %0100 WITH D4
    CMPI.B  #4,D4           ; IS %0100==D4?  
    BEQ     ROTATERIGHT        
ROTATELEFT
    ROL.B   #1,D3   ; ELSE, ROTATE OUR CONTENTS
    MOVE.B  D3,5(A0)    ;WRITING THE NEW OUTPUT TO THE LEDS
    BRA     LOOP
    
ROTATERIGHT
    ROR.B   #1,D3   ; ELSE, ROTATE OUR CONTENTS
    MOVE.B  D3,5(A0)    ;WRITING THE NEW OUTPUT TO THE LEDS
    BRA     LOOP


READ    
    MOVE.B  D1,D6
    ROR.B   #4,D6       ; ROTATING TO PUT THE BITS IN THE FRONT. 
    LSR.B   #4,D6       ; MAKING THE NECESSARY LOGICAL BIT MANIPULATION
    MOVE.B  D6,5(A0)    ; FINALLY MOVING B0-B3 TO A0-A3, WHILE ALL OTHERS
                        ; OFF.                      
    MOVE.B      5(A0),D3    
    BRA     LOOP

STOP	        MOVE.B 	#228,D7
		        TRAP 		#14
		
CTIME   DS.L    1
DIF     DS.L    1


    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
