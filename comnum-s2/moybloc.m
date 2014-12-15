function [matrout] = moybloc(matrin)

NL=size(matrin,1); %nbre lignes
NC=size(matrin,2); %nbre colonnes
somme=0;
moy=0;
matrout=zeros(NL,NC);

for i=1:NL
	for j=1:NC
	somme = somme + matrin(i,j);
	end
end
moy=somme/(NL*NC);

for i=1:NL
	for j=1:NC
	matrout(i,j)=moy;
 	end
end
return ;
