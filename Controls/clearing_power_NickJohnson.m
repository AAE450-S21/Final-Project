function [power,aug_P] = clearing_power_NickJohnson(m,rot)
hp2W = 746; % horsepower to watts
L = 3;      % 3m auger
%opt_rot  =120;              %rev per min, optimal via src
rho = 1500;     % kg/m^3 lunar regolith density
bay_vol = (1.5*1.75*2)/2;     % m^3 half rover bay volume
g = 9.81/6; % Lunar Gravity
c = 0.4;        % rolling resistance coeff from engineering toolbox

v = rover_speed_NickJohnson(1000,rot);
%v = 0.1;  uncomment this line and comment line above to compute power for
% the maximum loading condition of the rover.  As is, this computes power
% required only for the clearing process.
aug_P = 0.45*(L/3.048)*(rot/100)*hp2W;
plow_P = bay_vol*rho*g*v;
roll_P = m*g*c*v;

power = aug_P+plow_P+roll_P;
end