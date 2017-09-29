ORIGIN 4x0000
    ;; Refer to the LC-3b manual for the operation of each
    ;; instruction.  (LDR, STR, ADD, AND, NOT, BR)
SEGMENT  CodeSegment:
    ;; R0 is assumed to contain zero, because of the construction
    ;; of the register file.  (After reset, all registers contain
    ;; zero.)

    ;; Note that the comments in this file should not be taken as
    ;; an example of good commenting style!!  They are merely provided
    ;; in an effort to help you understand the assembly style.

    JSR ADD5
	LEA R2, MIN3
	JSRR R2
	ADD R0, R0, 1
ADD5:
	ADD R0, R0, 5
	RET
MIN3:
	ADD R0, R0, -3
HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.
                        ; Your own programs should also make use
                        ; of an infinite loop at the end.
SEGMENT
DATA:
LVAL1: DATA2 4x0020

ONE:    DATA2 4x0001
TWO:    DATA2 4x0002
EIGHT:  DATA2 4x0008
RESULT: DATA2 4x0000
GOOD:   DATA2 4x600D
