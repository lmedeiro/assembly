*-----------------------------------------------------------
* Title      : SORTING ARRAY WITH INSERTION SORT    
* Written by :  LUIZ MEDEIROS
* Date       :  
* Description:
*-----------------------------------------------------------

*--------------      DRIVER ------------------
			ORG 		$0900			;start program at this address
LAB3		
            MOVEA.L #COUNTER,A5     ;THIS COUNTER IS SET UP SO WE ARE COUNTING AT WHICH SORT WE ARE IN
            MOVE.B  #0,D4
            MOVE.B  (A5),D5
            CMP.B   D4,D5
            BEQ     SORT1
            MOVE.B  #1,D4			    	;
			CMP.B   D4,D5
			BEQ     SORT2
            SIMHALT

*-----------    SETTING UP THE ARRAYS ---------------------------------------
ARY1		DC.B		8		    		;define number of elements in array1
			DC.B	 65,-9,37,-15,5,8,14,60 ;define the elements of array1
ARY1S		DS.B		8			    	;reserve location for sorted array1

ARY2		DC.B		10			    ;define number of elements in array2
			DC.B		$DC,$84,$F4,$A5,$E3,$E3,$BB,$15,$21,$A4
										;define the elements of array2
ARY2S		DS.B		10				;reserve location for sorted array2



*----------- DEFINING INSERTION-SORT ROUTINE-----------
    * SUB ROUTINES TO DO ARRAY TRAVERSAL 
SORT
            MOVE.B  #0,D1
            MOVE.B  (A0,D1),D0      ;MOVING THE SIZE OF THE ARRAY TO D0
            MOVE.B  #2,D7        ;MOVING CURRENT INDEX (j) TO D7
            MOVE.B  #1,D6        ;MOVING RESULTING INDEX (i) INTO D6 FOR ALLOCATION
            MOVEA.L A0,A1       ;DEFINING THE ARRAY OF MANIPULATION AS A1.
            BSR     SORTMAINLOOP
            RTS            
            
            
SORTMAINLOOP
    CMP.B  D0,D7            ; IS j<=A.length ? 
    BLE     MANIP
     
    BSR     LAB3     
*    MOVE.B  #14,D0
*    MOVE.B  #0,D4
*    MOVE.B  D4,(A1,D7)      ; FOR OUTPUT PURPOSES ONLY
*    TRAP    #15
    
*    SIMHALT                 ; SORTING COMPLETE 
MANIP
    
    MOVE.B  (A1,D7),D3      ; D3 WILL BE USED AS KEY 
    MOVE.B  D7,D6           ;   j=i
    SUBI.B  #1,D6           ; i=j-1
    BSR     WHILELOOP
    
WHILELOOP
    MOVE.B  #0,D4       ; DUMMY DATA REGISTER FOR COMPARING DATA
    CMP.B   D6,D4       ;   i>0
    BGE     FALSE
    MOVE.B  (A1,D6),D4  ; USING D4 AS DUMMY DATA R.        
    CMP.B   D3,D4  ; A[i]>KEY
    BLE     FALSE       ; IF SO, THEN IT IS FALSE AND WE SHOULD HEAD FORWARD. 
    MOVE.B  #1,D4
    ADD.B   D6,D4       ;D4=i+1
    MOVE.B  (A1,D6),(A1,D4) ;A[i+1]=A[i]
    SUBI.B  #1,D6   ;i=i-1
    BRA     WHILELOOP
    
FALSE
    ADDI.B  #1,D6   ;i=i+1
    MOVE.B  D3,(A1,D6)  ;   A[i+1]=Key
    ADDI.B  #1,D7       ;j++
    BRA     SORTMAINLOOP


*---------------- END OF INSERTION SORT ROUTINE ------------------


*---------- MAKING OPERATION -------------------
SORT1   
        MOVEA.L #ARY1,A0    ;MOVING ADDRESS OF ARY1 TO A0
        MOVEA.L #ARY1S,A1   ;MOVING THE SORTED ARRAY TO THE A1
        ADDI.B  #1,COUNTER
        BSR     SORT
        RTS

SORT2   MOVEA.L #ARY2,A0
        MOVEA.L #ARY2S,A1
        ADDI.B  #1,COUNTER
        BSR     SORT
        RTS
*SORT1		...		...			;set parameter (D0,A0,A1) to sort array1
* 			...		...			;then call subroutine SORT
*
*SORT2		...		...			;set parameter (D0,A0,A1) to sort array2
* 			...		...			;then call subroutine SORT
*
*SORT		...		...			;subroutine SORT reads the address of				...		...			;the array from A0 and stores the sorted
*			...		...			;array at A1. The length of the array
*			...		...			;is passed via D0


*			MOVE.B 	#228,D7
*			MOVE.B  #9,D0
*			TRAP 		#14     ; HALTIN THE SIM;
        
*        MOVE.B  #14,D0
*        TRAP    #15
COUNTER     DC.B    0
ENDPROGRAM
    SIMHALT
			END LAB3    




