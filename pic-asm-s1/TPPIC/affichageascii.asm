	list p=16f877
	; Include du fichier de description des définitions du 16f877
	include "p16f877.inc"

;commence à l'adresse 0000
	org 0x0000
	nop

;vitesse de transmission
	banksel SPBRG
	movlw .25 ;on veut un baud rate =9,6k  (p98)
	movwf SPBRG

;on suit la documentation p95/96
	banksel  RCSTA
	movlw B'10000000'
	movwf RCSTA

	banksel TXSTA
	movlw B'00100100'
	movwf TXSTA

;on veut afficher un caractère ascii avec TXREG

	banksel TXREG
boucle	movlw 'a'
	movwf TXREG

	banksel TXSTA

att	btfss TXSTA, TRMT ;test, skip if set (si registre vide) (p95)
	goto att	

	banksel TXREG
	movlw 'A'
	movwf TXREG
	goto boucle
	end

