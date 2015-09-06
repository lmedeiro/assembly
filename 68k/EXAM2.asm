*-----------------------------------------------------------
* Title      :	Exam 2, 68k 
* Written by : Luiz Medeiros
* Date       :
* Description:
*-----------------------------------------------------------
        ORG    $8000
DATA1   DS.W    1
DATA2   DS.W    1
DATA3   DS.L    5


        
START:                  ; first instruction of program
        
;MOVE.B  DATA1,D0

;DATA1   DC.W    $8100
;DATA2   DC.W    2
;DATA3   DC.L    0,1,2,3,$1234   

;LOADING DATA1
    LEA     DATA1,A0
    CLR.L   D0
    CLR.L   D1
    CLR.L   D2
    MOVE.W  #0,D0   ;WILL USE AS INDEX
    MOVE.W  #$8100,D1   ;WILL USE D1 AS CONTENT TO WRITE STORAGE
    MOVE.W  D1,(A0,D0)
    MOVE.W  (A0,D0),D2  ;D2 WILL BE USED TO CHECK THE CURRENT VALUE OF A0
;LOADING DATA2   
    LEA     DATA2,A1
    CLR.L   D0
    CLR.L   D1
    CLR.L   D2
    MOVE.W  #0,D0   ;WILL USE AS INDEX
    MOVE.W  #2,D1   ;WILL USE D1 AS CONTENT TO WRITE STORAGE
    MOVE.W  D1,(A1,D0)
    MOVE.W  (A1,D0),D2  ;D2 WILL BE USED TO CHECK THE CURRENT VALUE OF A0
;LOADING DATA3
; I THOUGHT OF MAKING IT INTO ANOTHER ARRAY, WHICH MAY BE 
; SOME PORTION OF MEMORY POPULATED BY ANY MEANS, AND PROVIDED TO BE 
; LOADED. 
; OR IT MAY ALSO BE DATA REGISTERS BEING FED DIGITAL MEMORY FROM AN ADC. 

DUMMYARRAY     ;ARRAY TO LOAD
    DC.L    5,0,1,2,3,$1234   ;HERE IS THE ARRAY. INDEX 0 IS SIZE. ASSUME THIS CONVENTION   
                              ; FOR ALL ARRAYS OF INFO FED INTO THE PROCESSOR. 
    
    LEA     DATA3,A1        ; WHERE DATA WILL BE LOADED TO 
    LEA     DUMMYARRAY,A0   ; DUMMY ARRAY 
    MOVE.L  #0,D0           ;INDEX TRAVERSAL
    MOVE.L  (A0,D0),D1      ; SIZE HOLDER
    ADDA.L  #4,A0
    ADDI.L  #1,D0
WHILE
        CMP.L   D1,D0
        BHI     ENDPROGRAM  ; IF INDEX>SIZE, BRANCH END THE PROGRAM. OTHERWISE, COPY CONTENTS
        MOVE.L  (A0),(A1)   ;COPYING THE CURRENT CONTENTS OF DUMMY ARRAY TO STORAGE
        ADDA.L  #4,A0       ;INCREMENT ADDRESS
        ADDA.L  #4,A1
        ADDI.L  #1,D0
        BRA     WHILE
    


        



ENDPROGRAM
    SIMHALT    
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
