
NormFm	mov R1, #12H; // программа нормировки, переносит знак в нулевой (Х0) байт, экспоненту в Х1 байт, мантиссу в Х2..Х4
	mov 41h, #2d;
	mov 42H, #0H;
	clr C;
	SJMP Format;
NxtSym	Mov R1, #22H;
Format	mov A, @R1; // сдвигаем старший бит дробной части 
	RLC A;
	RR A;
	mov @R1, A;
	Dec R1;  // сдвигаем степено мантисы в байт 12Н и 22Н соответсвенно для А и В 
	mov A, @R1;
	RLC A;
	mov @R1, A;
	clr A;  // записываем знак в первый бит ячейки 10Н и 20Н соответсвенно
	RLC A;
	dec R1;
	mov @R1, A;
	
	mov A, 42H; // проверяем на 0ль
	Add A, #10H;
	mov 42H, A;
	mov R0, A;
	mov R2, #4d;
nxt	DJNZ R2, nxt1;
	LJMP lstmet;
nxt1	inc R0;
	mov A, @R0;
	JZ nxt;
	
	inc R1;
	inc R1;
	mov A, @R1;
	Add A, #128d;
	mov @R1, A;
	DJNZ 41H, NxtSym;





	clr A; // сложение знаков чисел
	Add A, 10H;
	Add A, 20H;
	mov 30H, A;

	
	mov R1, #31H;
	clr A; // сложение  экпонент с тестом
	Add A, 11H;
	Addc A, 21H;
	JC testp;
	clr C;
	Subb A, #127d;
	JC lstmet;
	mov @R1, A;
	SJMP Sum;	
testp	Add A, #129d;
	JC lstmet;
	mov @R1, A;
	mov A, 31H;
	CJNE A, #11111111b, Sum; 
	SJMP lstmet;
	

		

	
Sum:	mov R0, #22H;
	mov R1, #35H;
	mov R3,#3d;
per:	mov A, @R0;
	mov @R1, A;
	inc R0;
	inc R1;
	DJNZ R3, per;

	mov 32h,#0;
	mov 33h,#0;
	mov 34h,#0;
	mov R2, #25d;
	clr C;
m1:	djnz R2, m2;
	JC dop;
	sjmp m6;
m2:	mov R1, #32H;
	mov R3, #2d;
m3: 	mov R4, #3d;
m4:	mov A, @R1;
	RRC A;
	mov @R1, A;
	inc R1;
	DJNZ R4, m4;
	DJNZ R3, m3;
	jnc m1;
	clr C;
	mov R0, #14H;
	mov R1, #34H;
	mov R4, #3d;
m5:	mov A, @R1;
	ADDC A, @R0;
	mov @R1, A;
	DEC R0;
	DEC R1;
	DJNZ R4, m5;
	SJMP	m1;
dop:	mov R0, #32H; // доп сдвиг
	mov R3, #3d;
dop1:	mov A, @R0;
	RRC A;
	mov @R0, A;
	INC R0;
	DJNZ R3, dop1;
	inc 31H;	
	SJMP m6;	
m6:	


	clr C;   // приведение результата к формату ИЕЕЕ
	mov R1, #32H;
	mov 41H, #3d;
	mov A, @R1;
	RLC A;
	clr C;
	mov @R1, A; //убираем единицу
	
	mov R1, #30H;
sb1	mov A, @R1;
	RRC A;
	Mov @R1, A;
	inc R1;
	DJNZ 41H, sb1;
	




lstmet

