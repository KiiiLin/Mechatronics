ORG 0000H
	LJMP START
	
ORG 0060H
	START:
	MOV SP,#60H
	MOV 30H,#00H
		
	MAIN:
	LCALL DISPLAY1
	LCALL DELAY
	LCALL READ1
	LCALL DISPLAY2
	LCALL DELAY
	LCALL READ2
	LJMP MAIN
	
	DISPLAY1:
	CLR P1.7
	MOV A,30H
	ANL A,#0FH
	MOV DPTR,#DSEG1
	MOVC A,@A+DPTR
	MOV DPTR,#7FFAH
	MOVX @DPTR,A
	
	MOV A,30H
	SWAP A
	ANL A,#0FH
	MOV DPTR,#DSEG1
	MOVC A,@A+DPTR
	MOV DPTR,#7FFBH
	MOVX @DPTR,A
	RET
	
	READ1:
	MOV DPTR,#0BFFFH
	MOVX A,@DPTR
	CPL A
	MOV 30H,A
	RET
	
	DISPLAY2:
	SETB P1.7
	MOV A,30H
	ANL A,#0FH
	MOV DPTR,#DSEG1
	MOVC A,@A+DPTR
	MOV DPTR,#7FF8H
	MOVX @DPTR,A
	
	MOV A,30H
	SWAP A
	ANL A,#0FH
	MOV DPTR,#DSEG1
	MOVC A,@A+DPTR
	MOV DPTR,#7FF9H
	MOVX @DPTR,A
	RET
	
	READ2:
	MOV DPTR,#0BFFFH
	MOVX A,@DPTR
	CPL A
	MOV 30H,A
	RET
	
	DELAY:
	MOV R7,#0FFH
	LOOP1:
	MOV R6,#0FFH
	LOOP2:
	NOP
	NOP
	NOP
	NOP
	NOP
	DJNZ R6,LOOP2
	DJNZ R7,LOOP1
	RET
	
	DSEG1:
	DB 0C0H,0F9H,0A4H,0B0H
	DB 99H,92H,82H,0F8H
	DB 80H,90H,88H,83H
	DB 0C6H,0A1H,86H,8EH
		
	END
