%% Bobina de Helmholtz 
% ----
% Simulación del a intensidad de campo 
% Andrés Morales 
% 27-nov-2024

% Este script tiene como objetivo 
clc; clear; close all; 

addpath("utilities/")

load("fundamental_constants.mat")
N = 500; 
I = 10; % [mA]

% Parámetros de la bobina 
L = 30e-2; % [m] 
z = 0.5 * 0.54 * L; % [m] 

% Construccion de cuadrado 
M = L/2 * [1 1 0;-1 1 0; -1 -1 0; 1 -1 0]'; 
M = [M, M(:, 1)]; 
n = 100; % Por combinacion convexa 

square_points = zeros(3, (size(M, 2)-1) * n);

for i = 1:4
   j0 = M(:, i); j1 = M(:, (i + 1)); % Eleccion de vectores 
   [X, Y, Z] = create_rect(j0, j1, n); 

   idx_0 = (1 + (i-1)*n); 
   idx_1 = ((i)*n); 

   square_points(:, idx_0:idx_1) = [X; Y; Z];
end 

square_points  = square_points * 1e2; % Conversion a cm 
Rx = @(t) [1 0 0; 0 cos(t) -sin(t); 0 sin(t) cos(t)]; 
square_points = Rx(pi/2) * square_points; 

% Coils 
H = z * 1e2; % [cm]
Hc1 =  [0 H, 0]' + square_points; 
Hc2 = -[0 H, 0]' + square_points;

%% Simulacion por BiotSavart 
L = 18; 
ds = 0.1; % Separacion entre elementos. 

dr = @(L) -L:ds:L; 
[X,Y,Z] = meshgrid(dr(L), dr(L), dr(L)); 

% Campos por distribucion de corriente 
[Bx1, By1, Bz1] = Bfield_from_current(Hc1, I, X, Y, Z); 
[Bx2, By2, Bz2] = Bfield_from_current(Hc2, I, X, Y, Z); 

% Superposicion 
Bx = Bx1 + Bx2; 
By = By1 + By2; 
Bz = Bz1 + Bz2; 

%% Corte de intensidad 
Bxsurf = Bx(:, :, floor(L/2) + 1); 
Bysurf = By(:, :, floor(L/2) + 1); 
Bzsurf = Bz(:, :, floor(L/2) + 1);

Bsurf = sqrt(Bxsurf.^2 + Bysurf.^2 + Bzsurf.^2 );


%% Visualización
close all; 
hfig = figure; hfig.Name = "helmholtz-coil-viz"; 

% Gráficar las bobinas de Helmholtz 
plot3(Hc1(1, :), Hc1(2, :), Hc1(3, :), LineWidth=3, Color='blue'); hold on; 
plot3(Hc2(1, :), Hc2(2, :), Hc2(3, :), LineWidth=3, Color='blue'); 
axis([-30, 30, -30, 30, -30, 30]);
axis square;  hold on; 

% Grafica el campo vectorial 
quiver3(X, Y, Z, Bx, By, Bz, 2, Color="red");
% Graficar el contorno de intensidad en z = 0
contourf(X(:, :, floor(L/2) + 1), Y(:, :, floor(L/2) + 1), Bsurf); 
hold off; 

legend("coil", "", "field", "Intensity", "Location","best")
title("Helmholtz Coil" + " with I = " + num2str(I) + " [mA] and L = " + num2str(L) + " [cm]"); 
xlabel("x [cm]"); ylabel("y [cm]"); zlabel("z [cm]");
hfig.Position = [20, 200, 400, 400]; 

hfig = figure; hfig.Name = "helmholtz-coil-intensity"; 

subplot(1, 2, 1); 
contourf(X(:, :, floor(L/2) + 1), Y(:, :, floor(L/2) + 1), Bsurf); 
axis square; 
title("Intensidad de campo magnético en interior")
xlabel("x [cm]"); ylabel("y [cm]"); 

subplot(1, 2, 2); 
% hfig = figure; hfig.Name = "helmholtz-coil-intensity-surf"; 
surf(X(:, :, floor(L/2) + 1), Y(:, :, floor(L/2) + 1), Bsurf); 
axis square; 
title("Intensidad de campo magnético en interior")
xlabel("x [cm]"); ylabel("y [cm]"); 
hfig.Position = [484 197 909 431]



%% Guardar datos 
save("magnetic_field_result", "Bx", "By", "Bz", "X", "Y", "Z"); 