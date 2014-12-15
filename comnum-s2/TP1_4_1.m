close all;
clear all;
clc;

% Compression d'images
%1 : moyennage de blocs

%division en mxm blocs : taux de compression : 1/m²


%x=randint(3,3,10)
%y=moybloc(x)
I=imread('barques','jpg');
I=double(I)/255;
%x=
%NL=size(x,1);
%NC=size(x,2);

%Iout=zeros(NL,NC,3);

%I=rgb2gray(I);
figure;
imshow(I)
for i=1:3

Iout(:,:,i)=blkproc(I(:,:,i),[8 8], 'moybloc');

end

figure
imshow(Iout)

%IdiffL=abs(I-Iout);
%figure;
%imshow(mat2gray(Idiff))
