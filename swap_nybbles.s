; Michael Jacob
;
; swap_nybbles.s : Load a value into r16 and swap its two nybbles into r18 send the two for output alternately using PORTB and PORTD

; specify equivalent symbols
.equ SREG, 0x3f			; Status register. See data sheet, p.11
.equ DDRB, 0x04			; Data Direction Register for PORTB
.equ PORTB, 0x05		; Address of PORTB
.equ PORTD, 0x0B		; Address of PORTD
.equ DDRD, 0x0A			; Data Direction Register for PORTD

; specify the start address
.org 0
; reset system status
main:		ldi r16,0	; set register r16 to zero
		out SREG,r16	; copy contents of r16 to SREG, i.e. , clear SREG

		; configure PORTB for output
		ldi r16,0x0F	; copies hexadecimal 0F to r16
		out DDRB,r16	; writes r16 to DDRB, setting up bits 0 to 3 in output mode

		;configure PORTD for output
		ldi r16,0xF0	; copies hexadecimal F0 to r16
		out DDRD,r16	; writes r16 to DDRD, setting up bits 4 to 7 in output mode

		ldi r16,0x81	; copies hexadecimal DB to r16

		ldi r17,0x0F	; copies hexadecimal 0F to r17
		and r17,r16	; bit mask the lower 4 bits of r16 and store the result in r17
		; shift the bits in r17 one space to the left four times, which shifts the lower four bits to the upper four
		lsl r17	
		lsl r17
		lsl r17
		lsl r17

		ldi r18,0xF0	; copies hexadecimal F0 to r18
		and r18,r16	; bit mask the upper 4 bits of r16 and store the result in r18
		; shift the bits in r18 one space to the right four times, which shifts the upper four bits to the lower four
		lsr r18
		lsr r18
		lsr r18
		lsr r18
		
		or r18,r17	; combine the values in r17 and r18
	loop:	out PORTD,r18	; writes contents of r18 to PORTD
		out PORTB,r18	; writes contents of r18 to PORTB
		call delay	; call the delay routine
		out PORTD,r16	; writes contents of r16 to PORTD
		out PORTB,r16	; writes contents of r16 to PORTB
		call delay	; call the delay routine

		rjmp loop		; jump back to loop address

delay:		;delay the next action, for approx 0.5s
		ldi r19, 25	; load value 1 to r19 to set the number of iterations of loop1 to 25
	loop1:  nop		; take no action to extend the delay
		ldi r20, 250	; load the value 250 to r20 to control the number of iterations of loop2 
				
	loop2:	nop		; take no action to extend the delay
		ldi r21, 255	; load the value 255 to r21 to control the number of iterations of loop3, 
				
	loop3: 	nop		; take no action to extend the delay
		dec r21		; decrease the value in r21 by one to ensure the value in r21 counts how many iterations 
				; have been processed
		cpi r21,0	; compare the value in r21 to zero
		brne loop3	; if r21 is not yet zero run loop3 again, the original value in r21 is equal to the number 
				; of iterations
		dec r20		; decrease the value in r20 by one to ensure the value in r20 counts how many iterations 	
				; have been processed
		cpi r20,0	; compare the value in r20 to zero
		brne loop2	; if r20 is not yet zero run loop2 again, the original value in r20 is equal to the number 	
				; of iterations
		dec r19		; decrease the value in r19 by one to ensure the value in r19 counts how many iterations 	
				; have been processed
		cpi r19, 0	; compare the value in r19 to zero
		brne  loop1	; if r19 is not yet zero run loop1 again, the original value in r19 is equal to the number 		
				; of iterations
		ret		; return from routine
