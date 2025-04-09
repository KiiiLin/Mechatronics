; 将时钟改为0.01毫秒
ORG 0000H
	LJMP START
	
ORG 000BH
	LJMP INTT0
	
ORG 0060H
; 初始化部分
	START:
	MOV TMOD,#01H
	MOV TH0,#4CH ; 将TH0初始值修改，使每次中断变为10ms
	MOV TL0,#00H
	MOV 31H,#0H
	MOV 32H,#0H
	MOV 33H,#0H
	MOV 34H,#0H
	
	SETB EA
	SETB ET0
	SETB TR0
	
; 主循环
	MAIN_LOOP:
	CALL KEY
	CALL DISPLAY
	SJMP MAIN_LOOP
	
; 计时器T0
	INTT0:
	PUSH ACC
	PUSH PSW
	CLR TR0
	MOV TH0,#0DCH
	MOV TL0,#00H
	
	INC 31H
	MOV A,31H
	CJNE A,#0AH,EXIT ; 删除了30H的循环部分
	
	MOV TH0,#0DCH
	MOV 31H,#0H
	INC 32H
	MOV A,32H
	CJNE A,#6H,EXIT
	
	MOV TH0,#0DCH
	MOV 32H,#0H
	INC 33H
	MOV A,33H
	CJNE A,#0AH,EXIT
	
	MOV TH0,#0DCH
	MOV 33H,#0H
	INC 34H
	MOV A,34H
	CJNE A,#6H,EXIT
	
	EXIT:
	SETB TR0
	POP PSW
	POP ACC
	RETI
	
; 以下代码相同
	DISPLAY:
	MOV A,31H
	MOV DPTR,#DSEG1
	MOVC A,@A+DPTR
	MOV DPTR,#7FF8H
	MOVX @DPTR,A
	
	MOV A,32H
	MOV DPTR,#DSEG1
	MOVC A,@A+DPTR
	MOV DPTR,#7FF9H
	MOVX @DPTR,A
	
	MOV A,33H
	MOV DPTR,#DSEG1
	MOVC A,@A+DPTR
	MOV DPTR,#7FFAH
	MOVX @DPTR,A
	
	MOV A,34H
	MOV DPTR,#DSEG1
	MOVC A,@A+DPTR
	MOV DPTR,#7FFBH
	MOVX @DPTR,A
	
	RET
	
	KEY:
	JNB P1.0,PAUSE
	JNB P1.1,CONTINUE
	JNB P1.2,RESET
	RET
	
	PAUSE:
	CALL DELAY
	JB P1.0,EXIT_PAUSE
	CLR TR0
	EXIT_PAUSE:
	RET
	
	CONTINUE:
	CALL DELAY
	JB P1.1,EXIT_CONTINUE
	SETB TR0
	EXIT_CONTINUE:
	RET
	
	RESET:
	CALL DELAY
	JB P1.2,EXIT_RESET
	MOV 31H,#0H
	MOV 32H,#0H
	MOV 33H,#0H
	MOV 34H,#0H
	EXIT_RESET:
	RET
	
	DELAY:
	MOV R7,#0FFH
	DELAY_LOOP:
	NOP
	NOP
	NOP
	DJNZ R7,DELAY_LOOP
	RET
	
	DSEG1:
	DB 0C0H,0F9H,0A4H,0B0H
	DB 99H,92H,82H,0F8H
	DB 80H,90H,88H,83H
	DB 0C6H,0A1H,86H,8EH
		
	END
