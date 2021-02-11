function interp_map = framesInterp(data, factors)

% original size
H = size(data, 1);
W = size(data, 2);

% interpolated size
H_i = H * factors(1);
W_i = W * factors(2);

U_img = data;

% Scale the coordinates so that they range from 0 to 1 each.
[X1, Y1] = meshgrid( linspace(0, 1, W_i), linspace(0, 1, H_i));
[X2, Y2] = meshgrid( linspace(0, 1, size(U_img, 2)), linspace(0, 1, size(U_img, 1)));

% interpolate each color plane separately
interp_map = interp2(X2, Y2, double(U_img), X1, Y1);

end