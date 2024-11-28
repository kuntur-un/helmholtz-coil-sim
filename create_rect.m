function [X, Y, Z] = create_rect(v_init,v_end, N)

alpha = linspace(0, 1, N); 
convex_comb = v_init + alpha .* (v_end - v_init); 

X = convex_comb(1, :); 
Y = convex_comb(2, :); 
Z = convex_comb(3, :); 

% plot3(X, Y, Z); 
end

