function integral = integrate_interval(x, y, a, b);
% Do the numerical integral of y = f(x) given as arrays
% x and y on the interval x = [a, b] and return the result

% find the indices i, j where x(i) approimately
% is a and x(j) ~ b
[diffa i] = min(abs(x-a));
[diffb j] = min(abs(x-b));
width = abs(b-a);
integral = trapz(x(i:j), y(i:j))/width;
end