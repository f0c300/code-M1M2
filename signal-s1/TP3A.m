close all;
clear all;
clc;


%A signaux, bruits et filtrage %
T=96;
T0=32;
fe=1;
t=0:(1/fe):T;
%signal x 
xt=square(2*pi*(1/T0)*t);
% figure;
% plot(t,a);
% title('signal x');
xf=fftshift(fft(xt));
% figure;
% plot(t,abs(x));
% title('signal x en fréquence');

%rapport signal/bruit?

%signal y
v=0.5; %variance
bt=v.*randn(size(t));
bf=fftshift(fft(bt));
yt=xt+bt;
yf=fftshift(fft(yt));
% figure;
% plot(t,abs(xf),t,bf)
% title('signaux x et bruit');
figure;
plot(t,abs(yf));
title('signal y');

%pourquoi un filtre passe bas?

%filtre moyenneur
P=2;
h=(ones(1,P))/P;
z=filter(h,1,yt);
%fyc=conv(bt,h, 'same');
figure
plot(t,z,t,xt);
title('signal y avec filtre moyenneur, et signal x')
%Si on augmente trop P, on a un signal triangle

%erreur
err=(1/(fe*T))*sum(abs((z-xt).^2))
%pour bien filtrer, il faut que "err" soit minimale, on a en moyenne 0.18
%avec P=2

%filtre récursif ???

