ORIGIN 4x0000
SEGMENT  CodeSegment:
    ;; R0 is assumed to contain zero, because of the construction
    ;; of the register file.  (After reset, all registers contain
    ;; zero.)

    ;; we don't have immediate yet, so use data label to get numbers
    ;; R1 is 1 for +1 operation, R3 is -1 for decrement
    ;; R2 would be the iteration counter and also oprand for each
    ;; round of multiplication(initialized to 4)
    ;; R0 would store the result(initialized to 5)
    LDR  R1, R0, ONE
    LDR  R2, R0, FOUR   
    NOT  R3, R1		
    ADD  R3, R3, R1
	LDR  R0, R0, FIVE
	;; Change the initilization of R2, R0 to n-1, n for n!	
	;; Keep R7 and R6 as 0 for easy value change between registers

LOOP1:
	;; use r4, r5 to store two oprand for each iteration
	ADD R4, R2, R7       
    ADD R5, R0, R7
	ADD R0, R7, R7		;clear R0 to zero
LOOP2:
	;; add R5 to R0 for R4 times R0 <= R5*R4
	ADD R0, R0, R5
	ADD R4, R4, R3
	BRp LOOP2
	
	ADD R2, R2, R3		; Decrement R2
    BRp LOOP1         

HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.
                        
ONE:    DATA2 4x0001
TWO:    DATA2 4x0002
FOUR:   DATA2 4x0004
FIVE:	DATA2 4x0005
EIGHT:  DATA2 4x0008
RESULT: DATA2 4x0000
GOOD:   DATA2 4x600D
