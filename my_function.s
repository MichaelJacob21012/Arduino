; Michael Jacob
;
; my_function.s : reads an input value from PORTC and copies to the register r16, if that value is less than 6 subtracts it from 8 and if it is not then subtract it from 17. Output the answer for display using PORTB.  

; specify equivalent symbols
.equ SREG, 0x3f			; Status register. See data sheet, p.11
.equ DDRB, 0x04			; Data Direction Register for PORTB
.equ PORTB, 0x05		; Address of PORTB
.equ PINC, 0x06			; Address of input register for PORTC
.equ DDRC, 0x07			; Data Direction Register for PORTC

; specify the start address
.org 0
; reset system status
main:		ldi r16,0	; set register r16 to zero
		out SREG,r16	; copy contents of r16 to SREG, i.e. , clear SREG

		; configure PORTB for output
		ldi r16,0x0F	; copies hexadecimal 0x0F to r16
		out DDRB,r16	; writes r16 to DDRB, setting up bits 0 to 3 in output mode

		;configure PORTC for input
		ldi r16,0xF0	; copies hexadecimal 0xF0 to r16
		out DDRC,r16	; writes r16 to DDRC, setting up bits 4 to 7 in input mode

		;reads from external pins of PORTC to r16
		in r16,PINC	; copy contents of PINC to r16
		
		cpi r16,6	; compare contents of r16 with the value 6
		brlo lessthan	; if r16 is less than 6 jump to lessthan

		ldi r17,17	; copies the value 17 to r17
		sub r17,r16	; subtracts the contents of r16 from r17 and stores it in r17 					   i.e , subtract r16 from 17
		out PORTB,r17	; writes contents of r17 to PORTB

		rjmp mainloop	; jump to mainloop		
		
lessthan:	ldi r17,8	; copies the value 8 to r17
		sub r17,r16	; subtracts the contents of r16 from r17 and stores it in r17 					   i.e , subtract r16 from 8

		out PORTB,r17	; writes contents of r17 to PORTB

mainloop: rjmp mainloop		; jump back to mainloop address
