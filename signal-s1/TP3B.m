close all;
clear all;
clc;


%A signaux, bruits et filtrage %
T=5;
T0=1;
fe=100;
t=0:(1/fe):T;
f=0:(1/T):fe;
%signal x 
xt=square(2*pi*(1/T0)*t);
xf=fftshift(fft(xt));
%bruit
v=0.1; %variance
bt=v.*randn(size(t));
%somme
yt=xt+bt;
yf=fftshift(fft(yt));
figure
plot(f,abs(xf));
hold on
plot(f,abs(yf),'red'); zoom on;
title('signal x et signal y bruité');

%il faut utiliser un filtre passe-bas pour filtrer y
%trouver la fréquence pour le gabarit du filtre normalisé
wc=70; % estimation, à partir du graph où l'on compare xt et y
wa=90; % estimation, à partir du graph où l'on compare xt et y
BP=6 ;
A=10; % gain en BP
B=-30 ;%gain en BA

xgabarit=[0 wc wc nan wa wa (wa+20) nan 0 wc ];
ygabarit=[(A-BP) (A-BP) -20 nan -20 B B nan A A ];
figure;
plot(xgabarit, ygabarit);
axis([0 (wa+20) -50 20])
title('gabarit');

%calcul de l'ordre du filtre