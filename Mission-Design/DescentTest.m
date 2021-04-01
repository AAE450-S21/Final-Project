close all; clear all; clc;

global h g_accel Vc hscale thrust m0 A cD rho mdot
% Velocity
rM = 1738.2;
mMu = 4902.8005821478;

rp = rM + 15.24;
ra = rM + 100;

a = (rp + ra) / 2;
e = (ra-rp)/(ra+rp);
p = rp*(1+e);
Vc = sqrt(2*mMu/rp - mMu / a) * 1000;

% Everything else

h = (rp - rM)*1000;
hscale = 8440;
g_accel = 1.625;
thrust = 45000;
m0 = 10334 + 4700;
A = 7.069;
cD = 0;
rho = 1.225;
mdot = 15.422;

global x0 y0 Vx0 Vy0 yf Vxf Vyf Hf

%% Boundary Consitions
x0 = 0;
y0 = 1;
Vx0 = 1;
Vy0 = 0;

yf = 0;
Vxf = 0;
Vyf = 0;
Hf = -1;

%% Initial Guesses
t0 = 0;
lambda20 = 0;
lambda30 = 1;
lambda40 = 0;

yinit = [x0 y0 Vx0 Vy0 lambda20 lambda30 lambda40];

tf_guess = 400;

Nt = 100;
tau = linspace(0,1,Nt)';

solinit = bvpinit(tau,yinit,tf_guess);

%% Solution
sol = bvp4c(@ascent_odes_tf, @ascent_bcs_tf, solinit);
tf = sol.parameters(1);
Z = deval(sol,tau);

solinit_mass = solinit;
solinit_mass.y = Z;

delta_tf = 105;
tf = sol.parameters(1);
solinit_mass.parameters(1) = tf - delta_tf;

m0 = 10334 + 4700;
mdot = 15.422;

sol_mass = bvp4c(@ascent_odes_tf, @ascent_bcs_tf, solinit_mass);
tf = sol_mass.parameters(1);
Z = deval(sol_mass,tau);
time = t0 + tau.*(tf-t0);

xbar_sol = Z(1,:);
ybar_sol = Z(2,:);
vxbar_sol = Z(3,:);
vybar_sol = Z(4,:);
lambda2_sol = Z(5,:);
lambda3_sol = Z(6,:);
lambda4_sol = Z(7,:);

x_sol = xbar_sol * h / 1000;
y_sol = ybar_sol * h / 1000;
vx_sol = vxbar_sol * Vc / 1000;
vy_sol = vybar_sol * Vc / 1000;

theta = 180/pi.*atan(lambda4_sol./lambda3_sol); % steering angle, deg
%% Plots
mf = m0 - abs(mdot)*tf;
deltaV = 9.81*311*log(m0/mf);

close all;

figure(1)
axis equal
plot(x_sol,y_sol)
xlabel('x position (km)')
ylabel('y position (km)')
title('Flat Lunar Descent Cody Martin')

figure(2)
plot(time,theta)
xlabel('time (s)')
ylabel('Steering Angle (deg)')
%title('Steering angle vs time Cody Martin')

figure(3)
subplot(2,2,1)
plot(time,x_sol)
xlabel('time (s)')
ylabel('x position (km)')
%title('x sol vs time Cody Martin')

subplot(2,2,2)
plot(time,y_sol)
xlabel('time (s)')
ylabel('y position (km)')
%title('y sol vs time Cody Martin')

subplot(2,2,3)
plot(time,vx_sol)
xlabel('time (s)')
ylabel('x velocity (km/s)')
%title('x velocity vs time Cody Martin')

subplot(2,2,4)
plot(time,vy_sol)
xlabel('time (s)')
ylabel('y velocity (km/s)')
%title('y velocity vs time Cody Martin')

%% Lunar Descent Hohmann Transfer
rM = 1738.2;
mMu = 4902.8005821478;

%fix trajectory for plotting
xfix = x_sol;
yfix = zeros(1,100);
for i = 1:length(y_sol)
    ang = asind(x_sol(i)/(rM+y_sol(i)));
    yfix(i) = y_sol(i) + rM*cosd(ang);
end   

%Hohman transfer and Parking orbit
rp = rM + 15.24;
ra = rM + 100;

a = (rp + ra) / 2;
e = (ra-rp)/(ra+rp);
p = rp*(1+e);
v = sqrt(2*mMu/rp - mMu / a);

%delta v
deltaVho = (sqrt(mMu / ra) - sqrt(2*mMu/ra - mMu / a)) * 1000;
period = 2*pi*sqrt(a^3/mMu);

fprintf('The delta v calculated for landing is %.3f m/s.\n',deltaV);
fprintf('The delta v calculated for the hohmann transfer is %.3f m/s.\n',deltaVho);

% Big plotting
theta = [linspace(90,270,361)];
r = p ./ (1+e.*cosd(theta - 90));
ehat = r.*cosd(theta);
phat = r.*sind(theta);

theta = [linspace(0,360,361)];
moonE = rM.*cosd(theta);
moonP = rM.*sind(theta);

r2 = ra;
ehat2 = r2.*cosd(theta);
phat2 = r2.*sind(theta);


figure(4)
hold on
grid on
axis equal
title('Lunar Descent Cody Martin')
xlim([-50,450])
ylim([1600,1850])
xlabel('X position (km)')
ylabel('Y position (km)')
fill(moonE,moonP,[.8 .8 .8])
plot(ehat2,phat2,'g')
plot(ehat,phat,'b')
plot(xfix, yfix)
legend({'Lunar Surface','100km Parking Orbit', '100x15.24km Elliptical Orbit', 'Final Powered Descent'}, 'Location', 'SouthWest')

figure(5)
hold on
grid on
axis equal
title('Lunar Descent Cody Martin')
%xlim([-50,450])
%ylim([1600,1850])
xlabel('X position (km)')
ylabel('Y position (km)')
fill(moonE,moonP,[.8 .8 .8])
plot(ehat2,phat2,'g')
plot(ehat,phat,'b')
plot(xfix, yfix)
legend({'Lunar Surface','100km Parking Orbit', '100x15.24km Elliptical Orbit', 'Final Powered Descent'}, 'Location', 'Best')
%}
%% Functions
function dX_dtau = ascent_odes_tf(tau,X,tf)
global h Vc thrust mass rho cD A hscale g_accel m0 mdot
mass = m0 - abs(mdot)*tau*tf;
k1 = rho*A*cD / (2*mass);

xdot = X(3,:)*Vc/h;
ydot = X(4,:)*Vc/h;
Vxdot = (thrust / (mass*Vc)) * (-X(6,:) / sqrt(X(6,:)^2 + X(7,:)^2)) - k1 * exp(-X(2,:) * h/hscale) * X(3,:)*sqrt(X(3,:)^2 + X(4,:)^2) * Vc;
Vydot = (thrust / (mass*Vc)) * (-X(7,:) / sqrt(X(6,:)^2 + X(7,:)^2)) - k1 * exp(-X(2,:) * h/hscale) * X(4,:)*sqrt(X(3,:)^2 + X(4,:)^2) * Vc - g_accel/Vc;

if (sqrt(X(3,:)^2 + X(4,:)^2) == 0)
    lambda_2_dot = 0;
    lambda_3_dot = 0;
    lambda_4_dot = -X(5,:) * Vc/h;
else 
    lambda_2_dot = (X(6,:)*X(3,:) + X(7,:)*X(4,:)) * (-h/hscale) * exp(-X(2,:) * h/hscale) * k1 * sqrt(X(3,:)^2 + X(4,:)^2)*Vc;
    lambda_3_dot = k1*Vc*exp(-X(2,:) * h/hscale) * (X(6,:) * ((2*X(3,:)^2 + X(4,:)^2)/sqrt(X(3,:)^2 + X(4,:)^2)) + X(7,:) * ((X(3,:)*X(4,:))/sqrt(X(3,:)^2 + X(4,:)^2)));
    lambda_4_dot = -X(5,:) * Vc / h + k1*Vc*exp(-X(2,:) * h/hscale) * (X(7,:) * ((2*X(4,:)^2 + X(3,:)^2)/sqrt(X(3,:)^2 + X(4,:)^2)) + X(6,:) * ((X(3,:)*X(4,:))/sqrt(X(3,:)^2 + X(4,:)^2)));
end

dX_dtau = tf*[xdot; ydot; Vxdot; Vydot; lambda_2_dot; lambda_3_dot; lambda_4_dot];
return
end

function PSI = ascent_bcs_tf(Y0,Yf,tf)
global x0 y0 Vx0 Vy0 yf Vxf Vyf Hf m0 mdot

Ydotf = ascent_odes_tf(1,Yf,tf);

PSI = [Y0(1) - x0          % Initial Condition
       Y0(2) - y0          % Initial Condition
       Y0(3) - Vx0         % Initial Condition
       Y0(4) - Vy0         % Initial Condition
       Yf(2) - yf          % Final Condition
       Yf(3) - Vxf         % Final Condition
       Yf(4) - Vyf         % Final Condition
       Yf(5)*Ydotf(2)+Yf(6)*Ydotf(3)+Yf(7)*Ydotf(4) - Hf];% Final Condition

return
end