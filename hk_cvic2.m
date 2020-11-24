clc
clear
format long g

%DPI + meritkove cislo
DPI = 400;
p = 25.4;
M = 75000;

%Dane rozmery map. listu
Dh = 36213.866; 
V = 27801.102;
Dd = 36398.005;
Dh = Dh/M;
Dd = Dd/M;
V = V/M;

%Velikost pixelu
pix = p/(DPI*1000);

%Rohove body
p_1 = [756, 735];
p_2 = [8422, 719];
p_3 = [8456, 6544];
p_4 = [770, 6576];

%Stredni pricka
p_5 = (p_1+p_2)/2;
p_6 = (p_3+p_4)/2;

%Skutecne rozmery mapoveho listu
Dhs = norm(p_2-p_1)*pix;
Dds = norm(p_4-p_3)*pix;
Vs = norm(p_5-p_6)*pix;

%Absolutni delkova srazka
dh = Dh-Dhs;
dd = Dd-Dds;
d = (dh+dd)/2;
v = V-Vs;

%Absolutni plosna srazka
P =(Dh+Dd)/2*V;
Ps=(Dhs+Dds)/2*Vs;
d_P = P - Ps;

%Relativni podelna/pricna srazka
D = (Dh+Dd)/2;
q = d/D*100;
r = v/V*100;

%Absolutni srazka v obecnem smeru
q1 = [153, 276];
q2 = [207, 305];
dx = q2(1)-q1(1);
dy = q2(2)-q1(2);
Ss = sqrt(dx^2+dy^2);
alpha = atan2(dy,dx);
s = (q*cos(alpha)*dx+r*sin(alpha)*dy)/100;

%Vypocet meritkoveho cisla z mapoveho ramu
Mh = Dh*M/Dhs;
Md = Dd*M/Dds;
Mx = (Mh+Md)/2;
My = V*M/Vs;
M = sqrt(Mx*My);

%Nacteni rastr
R = imread('Horazdovice2.jpg');
imshow(R);
hold on;

%Nacteni identicke body
P = importdata('horazd_source.txt');
Q = importdata('horazd_ref.txt');

%Rozmer rastru
[m, n]=size(R);

%Redukce souradnic: P -> PR
PR = P;
PR(:,2)= m - P(:,2);

%Vykresleni identickych bodu
plot(P(:,1), P(:,2),'ro', 'MarkerSize', 5, 'LineWidth', 3);

%Meritkove cislo mapy, podobnostni transformace
k = length(P);
A = [P(:,1) -P(:,2) ones(k,1) zeros(k,1); 
     P(:,2) P(:,1) zeros(k,1) ones(k,1)];
l = [Q(:,2); Q(:,1)];

%MNC
lambda = inv(A'*A)*A'*l;
M_podobnost = sqrt(lambda(1,1)^2 + lambda(2,1)^2);
omega_podobnost = atan2(lambda(2, 1),lambda(1, 1))*180/pi + 90;
M_podobnost = M_podobnost / pix; 

%Meritkove cislo mapy, afinni transformace
A2 = [P(:,1) -P(:,2) zeros(k,1) zeros(k,1) ones(k,1) zeros(k,1); 
     zeros(k,1) zeros(k,1) P(:,2) P(:,1) zeros(k,1) ones(k,1)];

%MNC
lambda2 = inv(A2'*A2)*A2'*l;

Mx = sqrt(lambda2(1,1)^2 + lambda2(2,1)^2)/pix;
My = sqrt(lambda2(3,1)^2 + lambda2(4,1)^2)/pix;
M_afinita = sqrt(Mx*My);

omegax = atan2(lambda2(2, 1),lambda2(1, 1))*180/pi + 90;
omegay = atan2(lambda2(4, 1),lambda2(3, 1))*180/pi + 90;








