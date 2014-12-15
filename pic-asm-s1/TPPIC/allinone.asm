 list p=16f877
	; Include du fichier de description des définitions du 16f877
	include "p16f877.inc"

;on initialise les variables dont on a besoin
	valeur EQU 0x71
	unite  EQU 0x72
	decim  EQU 0x73
	count EQU 0x74
	command EQU 0x75

;commence à l'adresse 0000
	org 0x0000
	nop
;initialisation pour la réception
	banksel ADCON1
	movlw	B'00001110'		;Left justify,1 analog channel, car 10 bits et on fait une conversion sur 8bits
	movwf	ADCON1			;VDD and VSS references

	banksel ADCON0	
	movlw	B'01000001'		;Fosc/8, A/D enabled
	movwf	ADCON0

;vitesse de transmission et paramétrage reception/transmission
	banksel SPBRG
	movlw .25 ;on veut un baud rate =9,6k  (p98)
	movwf 	SPBRG

	banksel RCSTA
	movlw B'10010000'
	movwf 	RCSTA

	banksel TXSTA
	movlw B'00100100' 
	movwf TXSTA


	; MODE DE FONCTIONNEMENT ;
;auto : 1 valeur par seconde avec le timer, mode par défaut
auto	nop
	banksel RCREG
	movfw RCREG
	movwf command
	movlw "r" 				; changement de mode
	SUBWF command,f
	btfss STATUS,Z	
	goto timer

; manuel, on attend de recevoir une valeur ascii du clavier
manuel	nop
	banksel PIR1
att btfss PIR1, RCIF 		; RCIF est à 1 s'il a reçu une valeur
	goto att 				; tant qu'on a pas reçu de commande du clavier, on ne fait rien
	banksel RCREG
	movfw RCREG
	movwf command

; test de la valeur reçue
	movlw "a" 				; changement de mode
	SUBWF command,f
	btfsc STATUS,Z	
	goto auto
	ADDWF command,f

	movlw "d" ;acquisition
	SUBWF command,f
	btfss STATUS,Z 			; Z=1 si le résultat d'une opération =0
	goto manuel
	ADDWF command,f
	goto start
;	banksel INTCON
;	bcf INTCON,TOIE ; on met TOIE à 0 pour masquer le flag d'interruption


; ; ; TIMER ; ; ;
;On va contrôler l'affichage avec un timer, pour avoir une valeur par seconde
timer	nop
	banksel OPTION_REG
	MOVLW .15
	MOVWF count
	movlw B'10000111'
	movwf OPTION_REG
	banksel INTCON
compt	btfss INTCON,T0IF 	; si t0if à 1 : on compte, sinon on retourne au début
	goto compt	
	bcf INTCON,T0IF
	decf count
	BTFSS STATUS, Z			; si on a décrémenté jusqu'à 0
	goto compt


	; RECEPTION ;
	
	banksel ADCON0
start	bsf 	ADCON0,GO	; demarrage de la conversion
non		BTFSC	ADCON0,GO	; attendre la fin de conversion
		goto	non
oui		movfw ADRESH
		movwf	valeur
	
	
	; CONVERSION ;
	
;valeur est entre 0-255, on la veut entre 0-5
	clrf unite
divu MOVLW .51
	SUBWF valeur,f 			; F-W
	btfsc STATUS,C 			;s'il n'y a pas de reste (nombre<0) on saute l'instruction suivante
	incf unite 				; unite est incrémentée
	btfsc STATUS,C 			;s'il n'y a pas de reste, on saute l'instruction suivante
	goto divu

	movlw .51
	ADDWF valeur,f 			; on ajoute à nouveau 51 pour retrouver la valeur voulue

; on passe maintenant à la partie décimale
; si valeur = 50, on va arrondir la partie décimale à 9 
	movlw .9
	MOVWF decim 			; on initialise la valeur à 9
	MOVLW .50
	SUBWF valeur,f; 
	btfsc STATUS,Z 			; voir p18 
	goto result     		; si valeur = 50 on saute directement au résultat

;si ce n'est pas le cas, on calcule la partie decimale

	movlw .50
	ADDWF valeur,f			; on remet valeur à sa valeur
	clrf decim
divd MOVLW .5


	SUBWF valeur,f 			; F-W
	banksel STATUS	
 	btfsc STATUS,C 			;s'il n'y a pas de reste (nombre<0) on saute l'instruction suivante
	incf decim 				; partie decimale est incrémentée
	btfsc STATUS,C 			;s'il n'y a pas de reste, on saute l'instruction suivante
	goto divd

result	nop

; on a maintenant une partie entière 'unite' et une partie decimale 'decim'
;pour les afficher en ascii il faut ajouter 30

	movlw 0x30
	ADDWF unite,f 
	MOVLW 0x30
	ADDWF decim,f



; ; ; AFFICHAGE ; ; ; 



;On va contrôler l'affichage avec un timer, pour avoir une valeur par seconde
	banksel TXREG
	movfw unite
	movwf TXREG
	banksel TXSTA
att0	btfss TXSTA, TRMT 
	goto att0	
	banksel TXREG
	movlw ","
	movwf TXREG
	banksel TXSTA
att1	btfss TXSTA, TRMT
	goto att1
	BANKSEL TXREG
	movfw decim
	movwf TXREG	
	banksel TXSTA
att2	btfss TXSTA, TRMT
	goto att2
	BANKSEL TXREG
	movlw "V"
	movwf TXREG	
	banksel TXSTA
att3	btfss TXSTA, TRMT 
	goto att3
	BANKSEL TXREG
	movlw 0x0D 				; retour chariot
	movwf TXREG
	banksel TXSTA
att4	btfss TXSTA, TRMT 
	goto att4
	BANKSEL TXREG
	movlw 0x0A 				; debut de ligne
	movwf TXREG

	movlw "d" ;si on a obtenu cette valeur avec une acquisition, cest donc mode manuel
	SUBWF command,f
	btfss STATUS,Z 			; Z=1 si le résultat d'une opération =0
	goto auto
	goto manuel


	end