close all;
clear all;
clc; %raz invite de commande
A = [1 2 356 2 4];%ligne
B = [1; 2; 356; 2; 4];%colonne
%A' : transpos�e de la matrice ligne en matrice colonne
C = [1 2; 3 5;2 3.5];
A.*A; %terme � terme
%puissance 2^5
%racine sqrt()
%log = ln
%log10 = Log
Az = zeros(1,10);
Bz = zeros(15,20);
NL=45;
NC=56;
D=ones(NL,NC);
t = 0:1:10;
x =-pi:2*pi/10:+pi;
y=sin(x);
x(1); %attention, on re�oit la premi�re valeur du vecteur
t=-2*pi:4*pi/150:2*pi;
y=sin(t);
figure %cr�er une nouvelle figure, pour ne pas �craser les anciennes
plot(t,y);
axis([-2*pi 2*pi -1.5 +1.5]);%pr�cise les dimensions � afficher
y=t.*t;
figure;
plot(t,y);
axis([-2*pi 2*pi 0 +40]);
x1=[1 2 3 4 5 6 7 8];
y1=[4 5 2 7 10 3 2 5];
figure;
plot(x1,y1);
y2=[1 2 5 8 6 2 3 0];
figure;
plot(x1,y1,x1,y2);