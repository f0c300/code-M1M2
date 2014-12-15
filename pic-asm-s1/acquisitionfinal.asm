 list p=16f877
	; Include du fichier de description des définitions du 16f877
	include "p16f877.inc"

;on initialise "valeur" la valeur reçue par le PIC
valeur			EQU 0x71		; stockage de la valeur mesurée 
unite 			EQU 0x72		; partie entière après conversion
decim 			EQU 0x73		; partie décimale après conversion
count			EQU 0x74		; compteur pour le timer	
;w_tmp			EQU 0x75 		; tampon pour le sauvegarde du contexte 
;status_tmp 		EQU 0x76		; Sauvegarde de status
command			EQU 0x77		; stocke la valeur a,r,d
;commence à l'adresse 0000
		org 	0x000
		nop
		goto 	initialisation		;initialisation du programme (ligne 78)

;******** INTERRUPTION : TIMER ET SEELECTION DU MODE********* 
;************************************************************
; par défaut, on se placer en mode automatique

irq		org 0x004			; début interruption
; test de la valeur reçue
		banksel	PIR1
		btfss	PIR1,RCIF		; interruption dûe au clavier?
		goto 	auto

		banksel RCREG
		movfw 	RCREG
		movwf 	command			; "command" = valeur tapée 

		movlw 	"r" 			;si c'est r : changement de mode
		SUBWF 	command,w
		btfsc 	STATUS,Z		
		bcf 	INTCON,T0IE		;T0IE à 0 : pas d'interruption timer

		movlw 	"a" 			;si c'est a on change de mode
		SUBWF 	command,w
		btfsc 	STATUS,Z	
		goto	auto

		movlw 	"d" 			;si c'est d : acquisition
		SUBWF 	command,w
		btfsc 	STATUS,Z 			
		goto acqmanu				
		goto sortie

acqmanu		btfss	INTCON,TOIE		;acquisition ssi mode manuel
		call 	programme
		goto 	sortie

;timer (auto)
auto
		bsf 	INTCON,T0IE		; interruptions timer autorisées
		bcf 	INTCON,T0IF 		; flag interruption à 0
		incf 	count
		movlw	.15
		subwf	count,w
		btfsc 	STATUS,Z 		;  on afiche la valeur
		goto 	auto2
		goto 	sortie			; sinon, on quitte l'interruption
auto2
		call 	programme		; on appelle le programme complet
		clrf	count			; on réinitialise le compteur
		goto 	sortie
;sortie de l'interuption
sortie
;		movfw   status_tmp 			;
;		movwf 	STATUS				;	
;		movfw 	w_tmp 				; restauration du contexte
		retfie				; return from interrupt
		
;*****************************************************
		; FIN D'INTERRUPTION

initialisation
; config de l'ADC
		banksel ADCON1
		movlw	B'00001110'		;Left justify,1 analog channel
		movwf	ADCON1			;VDD and VSS references
		banksel ADCON0	
		movlw	B'01000001'		;Fosc/8, A/D enabled
 		movwf	ADCON0
;vitesse de transmission, config de l'USART
		banksel SPBRG
		movlw 	.25			 ; baud rate =9,6k 
		movwf	SPBRG
		banksel RCSTA
		movlw	B'10010000'
		movwf 	RCSTA
		banksel TXSTA
		movlw 	B'00100100' 
		movwf 	TXSTA
; INITIALISATION DU TIMER
		banksel OPTION_REG
		movlw 	B'00000111'		; initialisation du timer0 /256
		movwf 	OPTION_REG
		bsf 	INTCON,T0IE		; autorisation inter timer (mode a)
;clavier
		banksel PIE1
		bsf		PIE1,RCIE	; autorisation des inter usart
		banksel INTCON
		bsf		INTCON,PEIE	; autorisation des inter périphériques
		bsf		INTCON,GIE	; autorisation IRQ (interruption globale)

main 	nop 					; boucle en attendant une inter
		goto 	main

;ici commence le programme complet
programme

		; RECEPTION ;

		banksel ADCON0
		bsf 	ADCON0,GO		; demarrage de la conversion
non		BTFSC	ADCON0,GO		; attendre la fin de conversion
		goto	non
oui		movfw 	ADRESH
		movwf	valeur
	
	
		; CONVERSION ;
	
;valeur est entre 0-255, on la veut entre 0-5
		clrf	 unite
divu	 MOVLW	 .51
		SUBWF 	valeur,f 		; F-W
		btfsc 	STATUS,C 		;skip si pas de reste
		incf 	unite 			; unite est incrémentée
		btfsc 	STATUS,C		;skip si pas de reste
		goto 	divu

		movlw 	.51
		ADDWF 	valeur,f 		; on retrouve le "vrai" reste

; on passe maintenant à la partie décimale
; si valeur = 50, on va arrondir la partie décimale à 9 
		movlw	 .9
		MOVWF 	decim 			; on initialise la valeur à 9
		MOVLW 	.50
		SUBWF 	valeur,f; 
		btfsc 	STATUS,Z 		; voir p18 
		goto 	result     		; si valeur = 50 goto résultat

;si ce n'est pas le cas, on calcule la partie decimale

		movlw 	.50
		ADDWF	 valeur,f		; on remet valeur à sa valeur
		clrf	 decim
divd 	MOVLW 	.5


		SUBWF 	valeur,f 		; F-W
		banksel	STATUS	
 		btfsc	STATUS,C 		;skip si reste =0
		incf 	decim 			; partie decimale est incrémentée
		btfsc 	STATUS,C 		;skip si reste=0
		goto 	divd

result	nop

; on a maintenant une partie entière 'unite' et une partie decimale 'decim'
;pour les afficher en ascii il faut ajouter 30

		movlw 	0x30
		ADDWF 	unite,f 
		MOVLW	 0x30
		ADDWF	 decim,f
;On va contrôler l'affichage avec un timer, pour avoir une valeur par seconde

		; AFFICHAGE ; ; ; 




		banksel TXREG
		movfw 	unite
		movwf 	TXREG
		banksel TXSTA
att0	btfss 	TXSTA, TRMT 
		goto 	att0	
		banksel TXREG
		movlw 	","
		movwf	 TXREG
		banksel TXSTA
att1	btfss 	TXSTA, TRMT
		goto 	att1
		BANKSEL	TXREG
		movfw 	decim
		movwf 	TXREG	
		banksel TXSTA
att2	btfss 	TXSTA, TRMT
		goto 	att2
		BANKSEL TXREG
		movlw 	"V"
		movwf 	TXREG	
		banksel TXSTA
att3	btfss 	TXSTA, TRMT 
		goto 	att3
		BANKSEL TXREG
		movlw 	0x0D 			; retour chariot
		movwf 	TXREG
		banksel TXSTA
att4	btfss 	TXSTA, TRMT 
		goto 	att4
		BANKSEL TXREG
		movlw 	0x0A 			; debut de ligne
		movwf 	TXREG
		return



		end
