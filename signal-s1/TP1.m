close all;
clear all;
clc;

a=-50;
b1=10;
b2=9;
fc1=200;
fa1=210;
fa2=260/1.0111;
fc2=270;%on corrige la valeur de fa2 pour satisfaire l'égalité
%fa1*fa2=fc1*fc2


eps=sqrt(10^((b1-b2)/10)-1);
k=(fa2-fa1)/(fc2-fc1); %selectivité
wa=1/k;
A=10^((b1-a)/20);
eta=eps/(sqrt((A^2)-1)); %constante d'atténuation
%transformation passe-bas normalisé vers coupe-bande
%p=> p'=(wo/B)*((p/w0)+(wo/p))
%H'(p)=>H(p)=H'(p=p')
%avec B=wc2-wc1
%w0=sqrt(wc1*wc2)

%tracé du gabarit normalisé
xgabarit=[0 1 1 nan wa wa 3 nan 0 1];
ygabarit=[9 9 -20 nan -20 -50 -50 nan 10 10];
%figure;   Deplacée ligne 50
%plot(xgabarit, ygabarit);
%axis([0 3 -80 20])

%filtre de butterworth
nb=ceil((log10(eta))/(log10(k)));
%filtre de Tchebycheff
nt=ceil((log((1/eta)+sqrt(((1/eta)^2)+1)))/(log((1/k)+sqrt(((1/k)^2)+1))));
%filtre de Cauer
nc=ceil((ellipke(k)*ellipke(sqrt(1-eta^2)))/(ellipke(eta)*ellipke(sqrt(1-k^2))));

%l'ordre minimum est celui du filtre de Cauer dans notre cas
Rp=1;
Rs=60;% |-50|+|10|
[Z,P,K] = ellipap(nc,Rp,Rs);
figure;
plot(real(P),imag(P),'x',real(Z),imag(Z),'o');

[NUM,DEN]=zp2tf(Z,P,K);
w=[0:0.003:3];
H=freqs(NUM,DEN,w);%fonction de transfert du filtre passe bas normalisé
figure;
plot(xgabarit, ygabarit, w , 20*log10(abs(H))+10 ); %on superpose cette fonction au gabarit
axis([0 3 -80 20]);

w0=sqrt(fc2*fc1);
Bw=fc2-fc1;
w1=[0:0.5:500];
[NUMT,DENT]=lp2bs(NUM,DEN,w0,Bw);%passage en filtre coupe bande
[Z1,P1,K1]=tf2zp(NUMT, DENT);%calcul des pôles et zéros
H1=freqs(NUMT,DENT,w1);

figure;
plot(real(P1),imag(P1),'x',real(Z1),imag(Z1),'o');

figure;
xgabarit2=[0 200 200 nan 210 210 260 260 nan 270 270 500 nan 0 200 nan 270 500];
ygabarit2=[9 9 -50   nan -20 -50 -50 -20 nan -50 9   9   nan 10 10 nan 10 10];
plot(xgabarit2, ygabarit2, w1, 20*log10(abs(H1))+10); % attention log =/= log10 !!!
axis([0 500 -80 20]);
 
%visualiser phase
%calculer module en DB
% => bode ?
