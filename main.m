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

plot3( ...
    square_points(1, :), ...
    square_points(2, :), ...
    square_points(3, :) ...
    )
grid on; 

title(""); 
xlabel("x [cm]");
ylabel("y [cm]");
zlabel("z [cm]");

