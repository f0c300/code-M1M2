close all;
clear all;
clc;


N=200 ;		
M=200 ;	
%P=100;
I=zeros(N,M);
wx=0.1;
wy=0.1;
%wz=10;

%for k=1:P
for i=1:N;
	for j=1:M;

		I(i,j) = cos(wx*i+wy*j);
%		I(i,j,k)=cos(wx*i+wy*j+wz*k);
	end;
end;
%end;
figure;
imshow(I)
%plot3D?

figure;

imshow(abs(fftshift(dct2(I))));
figure;
fft=abs(fftshift(fft2(I)));
imshow(mat2gray(fft));

