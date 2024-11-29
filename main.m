%% Bobina de Helmholtz 
% ----
% Simulación del a intensidad de campo 
% Andrés Morales 
% 27-nov-2024

% Este script tiene como objetivo 
clc; clear; close all; 

load("fundamental_constants.mat")
N = 500; 
I = 200; % [mA]

% Parámetros de la bobina 
L = 34e-2; % [m] 
z = 20e-2; % [m] 

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


hfig = figure; 
hfig.Name = "helmholtz-coil-viz"; 


plot3( ...
    Hc1(1, :), ...
    Hc1(2, :), ...
    Hc1(3, :), ...
    Hc2(1, :), ...
    Hc2(2, :), ...
    Hc2(3, :) ...
    , LineWidth=2); 
grid on; 
axis([-40, 40, -40, 40, -40, 40])
axis square; 



title("Helmholtz Coil"); 
xlabel("x [cm]");
ylabel("y [cm]");
zlabel("z [cm]");

