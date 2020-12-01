clc
clear
format long g

%DPI (Nevim, zadano 400)
p = 0.0254*1000;
DPI = 400;
pix= p / DPI;

%Nacteni rastru a zobrazeni
R=imread('15_Bohemia_Kaerius_Janssonius_1620.jpg');
imshow(R);
hold on 

%Nahraj identicke body
P=importdata('kaerius_cechy_test.txt');
Q=importdata('kaerius_cechy_reference.txt');

%Redukce souradnice y, kvuli vykresleni
[m,n]=size(R)
PR = P;       
PR(:,2)= m - P(:,2);

%Vykresli body
%plot(PR(:,1), PR(:,2),'ro','MarkerSize',5,'Linewidth',3);
title('Identicke body')
hold on

%Hledani nejblizsich bodu + vypocet mer. cisel
M = [];
k = 2;

%Prochazej body
for i = 1:length(P)

    %Hledani 2 nejblizsich sousedu
    [idxs, ds] = knnsearch(P, P(i,:),'K', k);
    
    %Vezmeme 2. nejblizsiho souseda: pn
    id=idxs(1, 2);
    d=ds(1, 2);
    
    %Spojnice bodu pi a nejblizsiho bodu pn
    %plot([PR(i,1), PR(id,1)], [PR(i,2), PR(id,2)],'LineWidth',3);
    
    %Vzdalenost v referencni mape: q[i], qn
    D = norm(Q(i,:)-Q(id,:));
    
    %Lokalni meritkove cislo
    Ml = D/(d*pix);
    
    %Stredovy bod
    m = (P(i,:) + P(id, :))/2;
    
    %Pridani ML k m jako 3. souradnice
    m = [m, Ml];
    
    %Pridej m do M
    M = [M; m];
end   

%Extremni souradnice
xmin = min(M(:, 1));
xmax = max(M(:, 1));   
ymin = min(M(:, 2));
ymax = max(M(:, 2));
Mmin = min(M(:, 3));
Mmax = max(M(:, 3));

%Vytvoreni gridu
xl = linspace(xmin, xmax, 500);
yl = linspace(ymin, ymax, 500);
[Xg,Yg]=meshgrid(xl,yl);

%Interpolace
Zg = griddata(M(:,1), M(:,2), M(:, 3), Xg, Yg, 'v4');
dM = 300;
M_min = floor(Mmin/dM)*dM;
M_max = ceil(Mmax/dM)*dM;
M_int = M_min:dM:M_max;

%Vytvoreni vrstevnic
[C, h] = contour(Xg,Yg,Zg, M_int, 'LineWidth', 3, 'LineColor', 'w');
   
%Popis vrstevnic
clabel(C, h, 'Color', 'w');

