.include "m328pdef.inc" 
.include "delayMacros.inc" 
.include "lcd_Macros.inc" 
.include "UART_Macros.inc" 

.equ input=14
.cseg

.org 0x00 

jmp reset

.org 0x0024
Rjmp InterpetOnReceiver

InterpetOnReceiver:
	Serial_read
	mov r25,r16
	LCD_send_a_command 0x01
	LCD_send_a_register r25
	l1:
		rjmp l1

reti

reset:
    ; Initialize stack pointer
    LDI r16, high(RAMEND)
    OUT SPH, r16
    LDI r16, low(RAMEND)
    OUT SPL, r16
	Serial_writeChar 'R'
    SEI

 LCD_init
 LCD_backlight_ON
 Serial_begin

 LDI r22,0
 LDI r25,'1'

loop: 
	LCD_send_a_command 0x01  ; clear the LCD 

	 cpi r25,'1'
	 breq function1  ; Branch to the label "function1" if the Zero Flag (Z) is set

	 cpi r25,'2'
	 breq function2
	 
	 cpi r25,'3'
	 breq function3
	 
	 cpi r25,'4'
	 breq function4

	 cpi r25,'5'
	 breq function5

	rjmp loop

	 function1: 
		call button1_functionality
		rjmp loop

	function2: 
		call button2_functionality
		rjmp loop

	function3: 
		call button3_functionality
		rjmp loop

	function4: 
		call button4_functionality_off
		rjmp loop

	function5: 
		call button5_functionality
		inc r22
		cpi r22,17
		breq reset_r22
		rjmp skip
		reset_r22:
			ldi r22,0
		skip:

		
		nop

		rjmp loop

rjmp loop 

light_off:

	 delay 1000 
	 lds r24,input
	 cpi r24,2
	 breq light_off
	 ldi r21,2
	 sts input,r21


	 cbi PORTB,PB5
	 delay 2000
	 sbi PORTB,5
	 rjmp loop


 button1_functionality:

	LCD_send_a_command 0x01  ; clear the LCD

	LDI             ZL, LOW (2 * button1_message1)
	LDI             ZH, HIGH (2 * button1_message1)
	LDI             R20, button1_message1_len

	LCD_send_a_string button1_message1

	LCD_send_a_command 0xC0  ; Set Cursor to second line

	LDI             ZL, LOW (2 * button1_message1_2)
	LDI             ZH, HIGH (2 * button1_message1_2)
	LDI             R20, button1_message1_2_len

	LCD_send_a_string button1_message1_2

	delay 2500
	delay 2500

	LCD_send_a_command 0x01  ; clear the LCD

	LDI             ZL, LOW (2 * button1_message2)
	LDI             ZH, HIGH (2 * button1_message2)
	LDI             R20, button1_message2_len

	LCD_send_a_string button1_message2

	LCD_send_a_command 0xC0  ; Set Cursor to second line

	LDI             ZL, LOW (2 * button1_message2_2)
	LDI             ZH, HIGH (2 * button1_message2_2)
	LDI             R20, button1_message2_2_len

	LCD_send_a_string button1_message2_2

	delay 2500
	delay 2500

	LCD_send_a_command 0x01  ; clear the LCD

	LDI             ZL, LOW (2 * button1_message3)
	LDI             ZH, HIGH (2 * button1_message3)
	LDI             R20, button1_message3_len

	LCD_send_a_string button1_message3

	LCD_send_a_command 0xC0  ; Set Cursor to second line

	LDI             ZL, LOW (2 * button1_message3_2)
	LDI             ZH, HIGH (2 * button1_message3_2)
	LDI             R20, button1_message3_2_len

	LCD_send_a_string button1_message3_2

	delay 2500
	delay 2500

	LCD_send_a_command 0x01  ; clear the LCD

	LDI             ZL, LOW (2 * button1_message4)
	LDI             ZH, HIGH (2 * button1_message4)
	LDI             R20, button1_message4_len

	LCD_send_a_string button1_message4

	LCD_send_a_command 0xC0  ; Set Cursor to second line

	LDI             ZL, LOW (2 * button1_message4_2)
	LDI             ZH, HIGH (2 * button1_message4_2)
	LDI             R20, button1_message4_2_len

	LCD_send_a_string button1_message4_2

	delay 2500
	delay 2500

	ret

 button2_functionality:
	LCD_send_a_command 0x01  ; clear the LCD
	ldi r25,'0'
	ret

 button3_functionality:
	LDI             ZL, LOW (2 * button3_message1)
	LDI             ZH, HIGH (2 * button3_message1)
	LDI             R20, button3_message1_len

	LCD_send_a_string button3_message1
	
	LCD_send_a_command 0xC0  ; move cursor to the second line 

	LDI             ZL, LOW (2 * button3_message2)
	LDI             ZH, HIGH (2 * button3_message2)
	LDI             R20, button3_message2_len

	LCD_send_a_string button3_message2

	delay 150

	ret

button4_functionality_on:
	sbi PORTB,PB5  ; on the LCD
	ldi r25,'0'
	ret

button4_functionality_off:
	cbi PORTB,PB5  ; off the LCD
	ldi r25,'0'
	ret

button5_functionality:
	LCD_send_a_command 0x01  ; clear the LCD
	LCD_send_a_command 0x80    ;set the cursor to the begining of the new line 

	ldi r21,0
	myloop:
		cp r21,r22
		brne newmesg
		rjmp exit_loop
		newmesg:
		LCD_send_a_command 0x14  ; Increment cursor to right on the LCD
		inc r21
	rjmp myloop

	exit_loop :

	LDI             ZL, LOW (2 * name)
	LDI             ZH, HIGH (2 * name)
	LDI             R20, name_len

	LCD_send_a_string name

	delay 300

	ret

	
button1_message1 :	.db	"  GREETING TO",0
len1: .equ	button1_message1_len = (2 * (len1 - button1_message1))-1

button1_message1_2 :	.db	"   EVERYONE !",0
len7: .equ	button1_message1_2_len = (2 * (len7 - button1_message1_2))-1

button1_message2 :	.db	"COAL LAB PROJECT",0
len2 : .equ	button1_message2_len = (2 * (len2 - button1_message2))-1

button1_message2_2 :	.db	"   SESSION 2022",0
len8 : .equ	button1_message2_2_len = (2 * (len8 - button1_message2_2))-1

button1_message3 :	.db	"PREPARED BY",0
len3 : .equ	button1_message3_len = (2 * (len3 - button1_message3))-1

button1_message3_2 :	.db	"133 147 137 156"
len9 : .equ	button1_message3_2_len = (2 * (len9 - button1_message3_2))-1

button1_message4 :	.db	"TAYYAB  UMAIMA",0
len4 : .equ	button1_message4_len = (2 * (len4 - button1_message4))-1

button1_message4_2 :	.db	"MOMINA  GHANIA",0
len10 : .equ	button1_message4_2_len = (2 * (len10 - button1_message4_2))-1

button3_message1 :	.db	"  AVR ASSEMBLY  ",0
len5 : .equ	button3_message1_len = (2 * (len5 - button3_message1))-1

button3_message2 :	.db	" BY SIR. TEHSEEN",0
len6 : .equ	button3_message2_len = (2 * (len6 - button3_message2))-1

name :	.db	"Developer",0
len11 : .equ	name_len = (2 * (len11 - name))-1

; Interrupt PCINT0 ISR function
