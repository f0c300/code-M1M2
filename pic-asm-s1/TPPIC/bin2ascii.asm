	 list p=16f877
	; Include du fichier de description des définitions du 16f877
	include "p16f877.inc"

;on initialise "valeur" la valeur reçue par le PIC
	valeur EQU 0x71
	unite  EQU 0x72
	decim  EQU 0x73
	
;commence à l'adresse 0000
	org 0x0000
	nop

;valeur est entre 0-255, on la veut entre 0-5
; test avec valeur=60
	banksel STATUS
	clrf unite
	movlw .101
	movwf valeur


 divu MOVLW .51
	SUBWF valeur, f ; F-W
	btfsc STATUS, C ;s'il n'y a pas de reste (nombre<0) on saute l'instruction suivante
	incf unite ; unite est incrémentée
	btfsc STATUS, C ;s'il n'y a pas de reste, on saute l'instruction suivante
	goto divu

	movlw .51
	ADDWF valeur, valeur ; on ajoute à nouveau 51 pour retrouver la valeur voulue

; on passe maintenant à la partie décimale
; si valeur = 50, on va arrondir la partie décimale à 9 
	movlw .9
	ADDWF decim, decim ; on initialise la valeur à 9
	MOVLW .50
	SUBWF valeur, f; 
	btfsc STATUS, Z ; voir p18 
	goto result     ; si valeur = 50 on saute directement au résultat

;si ce n'est pas le cas, on calcule la partie decimale

	movlw .50
	ADDWF valeur, valeur	; on remet valeur à sa valeur
	clrf decim
divd MOVLW .5


	SUBWF valeur, f ; F-W
	banksel STATUS	
 	btfsc STATUS, C ;s'il n'y a pas de reste (nombre<0) on saute l'instruction suivante
	incf decim ; partie decimale est incrémentée
	btfsc STATUS, C ;s'il n'y a pas de reste, on saute l'instruction suivante
	goto divd

; on a maintenant une partie entière 'unite' et une partie decimale 'decim'
	
result	nop
		end
