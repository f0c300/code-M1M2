close all;
clear all;
clc;

%1 : signal BLU : signal modulé en double bande sans (ou avec) porteuse filtré 
%par un passe bas/haut inf/sup

%2
T=0.002;            %période en secondes
t=-0.4:T:0.4;       %on veut 400 points
x = sin(2*pi*5*t);% signal temporel

figure;
plot(t,x);
%3 

spectre = fftshift(fft(x));
figure;
plot(abs(spectre));

%bonne fréquences ? ~centré autour de 200


%4 transmission BLU supérieure

f0 = 100; %fréquence porteuse en Hz
fp=cos(f0*2*pi*t);
A=1;
%modulation d'amplitude : modulant * porteuse
madbap=fp.*x;
figure;
plot(t,madbap);

%en spectre :
spectre2 = fftshift(fft(madbap));
figure;
plot(abs(spectre2)); %préciser l'abscisse?

%5 gabarit numérique

%couper entre les deux pics : 280Hz
%on choisit : 

fa=280;
fc=285;
hold on;
xgabarit=[0 fa nan fa fa nan fc fc nan fc 320 nan fc 400];
ygabarit=[-30 -30 nan -30 0 nan -20 -6 nan -6 -6 nan 0 0];
plot(xgabarit, ygabarit);

%6

%choix de l'ordre du filtre selon le gabarit :
n=35;
wn=0.48;
B = fir1(n,wn, 'high',chebwin(35,30));
freqz(B,1,512);
