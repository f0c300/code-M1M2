close all;
clear all;
clc;

%1 technique de démodulation : détection d'enveloppe

%2
T=0.2;                      %durée des échantillons
Te=0.002;
Fe=1/Te;
t=-T/2:Te:T/2;
f=1./t;
x=sinc(50*t);
figure;
%plot(t,x);
X=fft(x);
spectre = fftshift(abs(X));
%figure;
%plot(spectre);
%fréquences en abscisse ?
%3

%beta=0,5 = max(x)*mu
F0 = 100;
beta=0.5;
p = cos(2*pi*F0*t);
xc = (1+beta*x).*p;
%plot(t,xc);
Xc=fft(xc);
%spectre2 = fftshit(abs(Xc));
%figure;
%plot(spectre2);


%4 simuler une diode : garder la partie positive
N=101;
r = zeros(1,N);
for i = 1:N
        if xc(i)>0
                r(i)=xc(i);
        else
            r(i)=0;
    end;
end;
%plot(t,xc);


spectre3 = fftshift(abs(fft(r)));
%plot(spectre3);
%zoom on;

plot(t,1+0.5*x);
hold on;
plot(t,r);


%spectre4 = fftshit(abs(fft(1+0.5*x)));
figure;
plot(spectre)
%hold on;
%plot(spectre4);


%on veut garder x
%on choisit : 

Wc= 80;
Wa= 120;
Wcn=Wc*Te;
Wan=Wa*Te

%tracé du gabarit : 
xgab=[0 Wc nan 0 Wc nan Wc Wc nan Wa Wa nan Wa 200];
ygab=[0 0  nan -3 -3 nan -3 -35 nan -15 -40 nan -40 -40];
hold on;
plot(xgab, ygab);

bogoss = fir1(34,Wcn,'low');
bg2 = freqz(bogoss,1,101);

%dénormaliser le filtre ?

ultrabogoss = bg2 * Xc;
plot(ultrabogoss);
