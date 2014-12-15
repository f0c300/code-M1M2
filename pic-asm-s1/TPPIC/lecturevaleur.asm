;	Programme du tutorial TP DESS
;	


	list p=16f877

	; Include du fichier de description des définitions du 16f877
	include "p16f877.inc"


	; Start at the reset vector
	org	0x000
	nop

	;configuration d'une case où stocker la valeur

valeur EQU 0x71
	
	; configuration de l'ADC	
	banksel ADCON1
	movlw	B'00001110'	;Left justify,1 analog channel, car 10 bits et on fait une conversion sur 8bits
	movwf	ADCON1		;VDD and VSS references

	banksel ADCON0	
	movlw	B'01000001'	;Fosc/8, A/D enabled
	movwf	ADCON0


start	bsf 	ADCON0,GO	; demarrage de la conversion
non		BTFSC	ADCON0,GO	; attendre la fin de conversion
		goto	non
oui		movfw ADRESH
		movwf	valeur
		goto start			; boucler sur la procedure de lecture

		end					; du programme (directive d'assemblage)