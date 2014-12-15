 list p=16f877
	; Include du fichier de description des d�finitions du 16f877
	include "p16f877.inc"

;on initialise "valeur" la valeur re�ue par le PIC
valeur			EQU 0x71			; stockage de la valeur mesur�e sur le PIC
unite 			EQU 0x72			; partie enti�re apr�s conversion
decim 			EQU 0x73			; partie d�cimale apr�s conversion
count			EQU 0x74			; compteur pour le timer	
;w_tmp			EQU 0x75 			; tampon pour le sauvegarde du contexte, timer 
;status_tmp 		EQU 0x76			; ???
command			EQU 0x77			; stocke la valeur a,r,d
;commence � l'adresse 0000
		org 	0x000
		nop
		goto 	initialisation				;initialisation du programme

		; INTERRUPTION : TIMER ET SEELECTION DU MODE ;
; par d�faut, on se placer en mode automatique

irq		org 0x004				; lorsque le flag TOIF se l�ve, le programme va � 0x04 et execute les instructions suivantes, idem si on appuie sur une touche du clavier

; test de la valeur re�ue
		banksel	PIR1
		btfss	PIR1,RCIF			; on teste si l'interruption est d�e au clavier ou non
		goto 	auto

		banksel RCREG
		movfw 	RCREG
		movwf 	command				; la valeur tap�e au clavier est stock�e dans 'command'

		movlw 	"r" 				;si c'est r : changement de mode
		SUBWF 	command,w
		btfsc 	STATUS,Z		
		bcf 	INTCON,T0IE			;si T0IE � 0 : T0IF est masqu�, pas d'interruption timer

		movlw 	"a" 				;si c'est a on change de mode
		SUBWF 	command,w
		btfsc 	STATUS,Z	
		goto	auto

		movlw 	"d" 				;si c'est d : acquisition
		SUBWF 	command,w
		btfsc 	STATUS,Z 			
		goto acqmanu				
		goto sortie

acqmanu		btfss	INTCON,T0IE			;mais seulement si on est en mode manuel, donc que TOIE est d�sactiv�
		call 	programme
		goto 	sortie
		

;timer (auto)
auto
		bsf 	INTCON,T0IE			; on s'assure que les interruptions timer sont autoris�es
		bcf 	INTCON,T0IF 			; on s'assure que T0IF � 0 pour autoriser les interruptions suivantes
		incf 	count
		movlw	.15
		subwf	count,w
		btfsc 	STATUS,Z 			;  on afiche la valeur
		goto 	auto2
		goto 	sortie				; sinon, on quitte l'interruption
auto2
		call 	programme			; on appelle le programme complet
		clrf	count				; on r�initialise le compteur
		goto 	sortie
;sortie de l'interuption
sortie
;		movfw   status_tmp 			;
;		movwf 	STATUS				;	
;		movfw 	w_tmp 				; restauration du contexte
		retfie						; return from interrupt
		
		; FIN D'INTERRUPTION

initialisation
; config de l'ADC
		banksel ADCON1
		movlw	B'00001110'			;Left justify,1 analog channel, car 10 bits et on fait une conversion sur 8bits
		movwf	ADCON1				;VDD and VSS references
		banksel ADCON0	
		movlw	B'01000001'			;Fosc/8, A/D enabled
 		movwf	ADCON0
;vitesse de transmission, config de l'USART
		banksel SPBRG
		movlw 	.25					 ;on veut un baud rate =9,6k  (p98)
		movwf	SPBRG
		banksel RCSTA
		movlw	B'10010000'
		movwf 	RCSTA
		banksel TXSTA
		movlw 	B'00100100' 
		movwf 	TXSTA
; INITIALISATION DU TIMER
		banksel OPTION_REG
		movlw 	B'00000111'			; initialisation du timer0 /256
		movwf 	OPTION_REG
		bsf 	INTCON,T0IE			; autorisation des interruptions timer (seulement en mode auto)
;clavier
		banksel PIE1
		bsf		PIE1,RCIE			; autorisation des interruptions usart
		banksel INTCON
		bsf		INTCON,PEIE			; autorisation des interruptions p�riph�riques
		bsf		INTCON,GIE			; autorisation IRQ (interruption globale)

main 	nop 						; le programme reste dans cette boucle et ne fait rien en attendant une interruption
		goto 	main

;ici commence le programme complet
programme

		; RECEPTION ;

		banksel ADCON0
		bsf 	ADCON0,GO			; demarrage de la conversion
non		BTFSC	ADCON0,GO			; attendre la fin de conversion
		goto	non
oui		movfw 	ADRESH
		movwf	valeur
	
	
		; CONVERSION ;
	
;valeur est entre 0-255, on la veut entre 0-5
		clrf	 unite
divu	 MOVLW	 .51
		SUBWF 	valeur,f 			; F-W
		btfsc 	STATUS,C 			;s'il n'y a pas de reste (nombre<0) on saute l'instruction suivante
		incf 	unite 				; unite est incr�ment�e
		btfsc 	STATUS,C			;s'il n'y a pas de reste, on saute l'instruction suivante
		goto 	divu

		movlw 	.51
		ADDWF 	valeur,f 			; on ajoute � nouveau 51 pour retrouver la valeur voulue

; on passe maintenant � la partie d�cimale
; si valeur = 50, on va arrondir la partie d�cimale � 9 
		movlw	 .9
		MOVWF 	decim 				; on initialise la valeur � 9
		MOVLW 	.50
		SUBWF 	valeur,f; 
		btfsc 	STATUS,Z 			; voir p18 
		goto 	result     			; si valeur = 50 on saute directement au r�sultat

;si ce n'est pas le cas, on calcule la partie decimale

		movlw 	.50
		ADDWF	 valeur,f			; on remet valeur � sa valeur
		clrf	 decim
divd 	MOVLW 	.5


		SUBWF 	valeur,f 			; F-W
		banksel	STATUS	
 		btfsc	STATUS,C 			;s'il n'y a pas de reste (nombre<0) on saute l'instruction suivante
		incf 	decim 				; partie decimale est incr�ment�e
		btfsc 	STATUS,C 			;s'il n'y a pas de reste, on saute l'instruction suivante
		goto 	divd

result	nop

; on a maintenant une partie enti�re 'unite' et une partie decimale 'decim'
;pour les afficher en ascii il faut ajouter 30

		movlw 	0x30
		ADDWF 	unite,f 
		MOVLW	 0x30
		ADDWF	 decim,f
;On va contr�ler l'affichage avec un timer, pour avoir une valeur par seconde

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
		movlw 	0x0D 					; retour chariot
		movwf 	TXREG
		banksel TXSTA
att4	btfss 	TXSTA, TRMT 
		goto 	att4
		BANKSEL TXREG
		movlw 	0x0A 					; debut de ligne
		movwf 	TXREG
		return



		end
