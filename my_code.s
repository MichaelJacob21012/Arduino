; Michael Jacob
;
;my_code.s : this program outputs the letters 'j', 'a', 'c', in morse code, in an endless loop using bit 1 of PORTB

; specify equivalent symbols
.equ SREG, 0x3f			; Status register. See data sheet, p.11
.equ DDRB, 0x04			; Data Direction Register for PORTB
.equ PORTB, 0x05		; Address of PORTB

; specify the start address
.org 0
; reset system status
main:		ldi r16,0	; set register r16 to zero
		out SREG,r16	; copy contents of r16 to SREG, i.e. , clear SREG

		; configure PORTB for output
		ldi r16,0x0F	; copies hexadecimal 0x0F to r16
		out DDRB,r16	; writes r16 to DDRB, setting up bits 0 to 3 in output mode


start:		; output 'j'
		call dot	; calls the 'dot' subroutine
		call partspace	; calls the 'partspace' subroutine
		call dash	; calls the 'dash' subroutine
		call partspace	; calls the 'partspace' subroutine
		call dash	; calls the 'dash' subroutine
		call partspace	; calls the 'partspace' subroutine
		call dash	; calls the 'dash' subroutine

		call letterspace ; calls the 'letterspace' subroutine

		; output 'a'
		call dot	; calls the 'dot' subroutine
		call partspace	; calls the 'partspace' subroutine
		call dash	; calls the 'dash' subroutine

		call letterspace ; calls the 'letterspace' subroutine

		; output 'c'
		call dash	; calls the 'dash' subroutine
		call partspace	; calls the 'partspace' subroutine
		call dot	; calls the 'dot' subroutine
		call partspace	; calls the 'partspace' subroutine
		call dash	; calls the 'dash' subroutine
		call partspace	; calls the 'partspace' subroutine
		call dot	; calls the 'dot' subroutine
		
		call letterspace ; calls the 'letterspace' subroutine

		jmp start 	; jump back to start


dot:		;output a dot of unit length one
		ldi r16, 0x01	; load the value one to r16 	
		ldi r20, 20	; load the value 20 to r20, this determines the iterations of loop1
		out PORTB , r16	; write the value one from r16 to PORTB to set bit 1 to one
		call delay	; calls the 'delay' subroutine
		ret		; return from routine
		
dash:		;output a dash of unit length three
		ldi r16, 0x01	; load the value one to r16 
		ldi r20, 60	; load the value 60 to r20, this determines the iterations of loop1
		out PORTB , r16	; write the value one from r16 to PORTB to set bit 1 to one
		call delay	; calls the 'delay' subroutine
		ret		; return from routine

partspace:	;output a space of unit length one
		ldi r16, 0x00	; load the value one to r16 
		ldi r20, 20	; load the value 20 to r20, this determines the iterations of loop1
		out PORTB , r16	; write the value one from r16 to PORTB to set bit 1 to one
		call delay	; calls the 'delay' subroutine
		ret		; return from routine


letterspace:	;output a space of unit length three
		ldi r16, 0x00	; load the value one to r16 
		ldi r20, 60	; load the value 60 to r20, this determines the iterations of loop1
		out PORTB , r16	; write the value one from r16 to PORTB to set bit 1 to one
		call delay	; calls the 'delay' subroutine
		ret		; return from routine


delay:		;delay the next action, each iteration of loop1 is approx 10ms
		mov r17, r20	; copy register r20 to r17 to set the number of iterations of loop1 based on the value in r20
	loop1:  nop		; take no action to extend the delay
		ldi r18, 125	; load the value 125 to r18 to control the number of iterations of loop2 
				; these numbers set loop1 duration to 10ms
	loop2:	nop		; take no action to extend the delay
		ldi r19, 255	; load the value 2555 to r19 to control the number of iterations of loop3, 
				; these numbers set loop1 duration to 10ms
	loop3: 	nop		; take no action to extend the delay
		dec r19		; decrease the value in r19 by one to ensure the value in r19 counts how many iterations 
				; have been processed
		cpi r19,0	; compare the value in r19 to zero
		brne loop3	; if r19 is not yet zero run loop3 again, the original value in r19 is equal to the number 
				; of iterations
		dec r18		; decrease the value in r18 by one to ensure the value in r18 counts how many iterations 	
				; have been processed
		cpi r18,0	; compare the value in r18 to zero
		brne loop2	; if r18 is not yet zero run loop2 again, the original value in r18 is equal to the number 	
				; of iterations
		dec r17		; decrease the value in r17 by one to ensure the value in r17 counts how many iterations 	
				; have been processed
		cpi r17, 0	; compare the value in r17 to zero
		brne  loop1	; if r17 is not yet zero run loop1 again, the original value in r17 is equal to the number 		
				; of iterations
		ret		; return from routine
