close all;
clear all;
clc;
%Etude du VCO

%1
%on lance simulink avec l'invite de commande
fc=100;
kc=1000;
% cr�ation avec les blocs dans simulink
% on veut yvc0(t) ???

%2
%on r�gle les param�tres demand�s et on observe le bon fonctionnement

%3
kr=500;
fr=10000;
fp=100;
%pour le d�phasage on modifie la fonction dans la pll et on le lui ajoute
%directement.
% avec un d�phasage de -pi/2 on peut observer un artefact au d�but du
% signal, il met un peu de temps avant de suivre la boucle correctement.
%idem avec 0

%avec pi/2 on a la meilleure phase.

%4
%on observe bien la phase d'accrochage, capture, verrouillage