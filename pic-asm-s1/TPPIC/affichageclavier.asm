	list p=16f877
	; Include du fichier de description des définitions du 16f877
	include "p16f877.inc"

;on initialise "valeur" 
	valeur EQU 0x71

;commence à l'adresse 0000
	org 0x0000
	nop

;vitesse de transmission
	banksel SPBRG
	movlw .25 ;on veut un baud rate =9,6k  (p98)
	movwf SPBRG

;on suit la documentation p95/96 receive/transmit status and control
	banksel  RCSTA
	movlw B'10010000' ;attention à bien avoir le bit CREN=1
	movwf RCSTA

	banksel TXSTA
	movlw B'00100100' 
	movwf TXSTA

;on veut lire un caractère ascii avec RCREG
	banksel RCREG
tour	movfw RCREG
	movwf valeur


;on veut afficher un caractère ascii avec TXREG

	banksel PIR1
att	btfss PIR1, RCIF  ;si RCIF=1, il a reçu une valeur
	goto att	

	banksel TXREG
	movfw valeur
	movwf TXREG
	GOTO tour
	end
