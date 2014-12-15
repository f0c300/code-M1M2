function [matrout] = dctbloc(matrin)

NL=size(matrin,1); %nbre lignes
NC=size(matrin,2); %nbre colonnes

matrout=zeros(NL,NC);

%matrout=abs(fftshift(dct2(matrin)));
matrout=dct2(matrin);
return ;
