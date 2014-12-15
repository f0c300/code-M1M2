clc;
close all;
clear all;


m=3;
n=2^m-1;
k=2^m-m-1;

msg = randi([0,1],100,k) %0 ou 1, 100 lignes, k colonnes

codeh=encode(msg,n,k,'hamming')

%noisycode=rem(codeh+randerr(100,n,[0,1;0,7;0,2],2); 
%biterr, symerr, 
noisycode=xor(codeh,randerr(100,n,[0,1;0,7 ,  0,3]))

%msg1=decode(noisycode, " " );

