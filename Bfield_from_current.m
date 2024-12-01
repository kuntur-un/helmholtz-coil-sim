function [Bx, By, Bz, X, Y, Z] = Bfield_from_current(Idis, I, X, Y, Z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Calculo por BiotSavart 

load("fundamental_constants.mat", "mu_0"); 

N = length(Idis); 
magV = @(v) sqrt(v(1)^2 + v(2)^2 + v(3)^2); 
% Ntensor = 21; 

Bx = zeros(size(X)); By = zeros(size(X)); Bz = zeros(size(X)); 

for idx = 1:(N-1)
    dl = Idis(:, idx+1) - Idis(:, idx); 
    for ix = 1:size(X,1)
        for iy = 1:size(Y,2)
            for iz = 1:size(Z,3)
                % mu I / 4pi * int (dl x r)/r^3 dx^3
                % Vectores posicion 
                % OP: Posicion de medicion 
                % OI: Posicion de corriente 
                
                x = X(ix, iy, iz); y = Y(ix, iy, iz); z = Z(ix, iy, iz) ; 
                OP = [x, y, z]';  % 3x1
                OI = Idis(:, idx); % 3x1
                
                r = OP - OI; % PI
                
                dB = mu_0 * I /(4*pi) * cross(dl, r)/magV(r)^3; % Campo diferencial 
                    
                Bx(ix, iy, iz) = Bx(ix, iy, iz) + dB(1); % Superposición 
                By(ix, iy, iz) = By(ix, iy, iz) + dB(2); % Superposición 
                Bz(ix, iy, iz) = Bz(ix, iy, iz) + dB(3); % Superposición 
            end 
        end
    end 
end 

end

