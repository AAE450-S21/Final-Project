%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADCS_sizing.m
% 
% Environmental Disturbances and Attitude Determination and Control System
% sizing - this program calculates the maximum disturbance torques (gra
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPPUTS
% satellite - observation, communication, or prop_depotvity
% gradient torque and solar radiation pressure torque are the only ones
% calculated here due an assumption of no magnetic field torque and
% aerodynamic torque around the moon). The program uses this max torque to
% determine RWA sizing.
% Also determines the force and chemical propellent mass needed from
% thrusters for momentum dumping
%
% AAE450: Project Next Step
%%%%%%%%%%%%% PROGRAMMERS %%%%%%%%%%%%
% Jaxon Connolly -- Controls
% r_a - spacecraft apoapsis
% r_p - spacecraft periapsis
% I_xx, I_yy, I_zz - spacecraft moments of inertia
% theta - maximum angle of deviation from z-axis
% q - reflectance factor
% i - angle of incidence from sun
% A_s - spacecraft surface area
% P - orbital period
% theta_slew - slew angle
% t_slew - time in which slew maneuvers must be performed
% L - distance from center of gravity to thrusters
% t_burn - burn time of thruster
% N_wheels - number of reaction wheels being used
% days - mission duration
% Isp - specific impulse from desired chemical propellant
%
% OUTPUTS
% T_gEarth - gravity gradient from the Earth
% T_gMoon - gravity gradient from the moon
% T_sp - torque from solar pressure radiation
% T_max - maximum projected environmental torque
% T_slew - required slew torque
% T_req - required torque for reaction wheel disturbance mediation
% h_RW - momentum storage in reaction wheel
% P_RW - reaction wheel power
% F_MD - force required by thrusters for momentum dumping
% M_p - propellant mass required by thrusters
%
% PLOTS
% none
%
% FLAGS
% none
%
% ADDITIONAL DEVELOPMENT NOTES:
% ---Equations for environmental distrubances and reaction wheel sizing
% come from ValiSpace How To's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc;

% Environmental Constants
mu_earth = 398600.4418; %[km^3/s^2] Earth's gravitational parameter
mu_moon = 4902.8695;    %[km^3/s^2] Moon's gravitational parameter
r_earth_moon = 384400;  %[km] distance between Earth and Moon
J_s = 1367;             %[W/m^2] solar constant
c = 3e8;                %[m/s] speed of light
g_earth = 9.81;         %[m/s] acceleration due to earth's gravity

% Inputs
%satellite = "observation";
%satellite = "communication";
satellite = "prop_depot";

if satellite == "observation"
    r_a = 216;       %[km] imaging satellite apoapsis
    r_p = 50;       %[km] imaging satellite periapsis
    I_xx = 100;       %[kg*m^2] imaging satellite moment of inertia x-axis
    I_yy = 360;       %[kg*m^2] imaging satellite moment of inertia y-axis
    I_zz = 370;       %[kg*m^2] imaging satellite moment of inertia z-axis
    A_s = 32.4;        %[m^2] imaging satellite surface area
    P = 2*60*60;       %[s] imaging satellite orbital period
    theta_slew = 0;    %[rad] imaging satellite slew angle
    t_slew = 1;      %[s] imaging satellite time for slew maneuver
    L = 0.8;          %[m] distance from center of gravity to thrusters
    Isp = 225;        %[s] propellant specific impulse
    theta = 0.01;    %[rad] maximum angle of deviation from z-axis
elseif satellite == "communication"
    r_a = 1500;    %[km] communication satellite apoapsis
    r_p = 1500;    %[km] communication satellite periapsis
    I_xx = 653.50;      %[kg*m^2] communication satellite moment of inertia x-axis
    I_yy = 905.56;      %[kg*m^2] communication satellite moment of inertia y-axis
    I_zz = 1253.90;      %[kg*m^2] communication satellite moment of inertia z-axis
    A_s = 27.96;       %[m^2] communication satellite surface area
    P = 4.5*60*60;         %[s] communication satellite orbital period
    theta_slew = 0; %[rad] communication satellite slew angle
    t_slew = 1;     %[s] communication satellite time for slew maneuver
    L = 1.5;        %[m] distance from center of gravity to thrusters
    Isp = 225;      %[s] propellant specific impulse
    theta = 0.5;    %[rad] maximum angle of deviation from z-axis
elseif satellite == "prop_depot"
    r_a = 100;    %[km] lunar propellant depot apoapsis
    r_p = 100;    %[km] lunar propellant depot periapsis
    I_xx = 2.265e7;      %[kg*m^2] lunar propellant depot moment of inertia x-axis
    I_yy = 2.931e7;      %[kg*m^2] lunar propellant depot moment of inertia y-axis
    I_zz = 3.389e7;      %[kg*m^2] lunar propellant depot moment of inertia z-axis
    A_s = 143.314;       %[m^2] lunar propellant depot surface area
    P = 89.715;         %[s] lunar propellant depot orbital period
    theta_slew = 0; %[rad] lunar propellant depot slew angle
    t_slew = 1;     %[s] lunar propellant depot time for slew maneuver
    L = 1.5;        %[m] distance from center of gravity to thrusters
    Isp = 225;      %[s] propellant specific impulse
    theta = 0.01;    %[rad] maximum angle of deviation from z-axis
end

q = 0.6;        % reflectance factor
inc = 0;          %[rad] angle of incidence from sun
t_burn = 1;     %[s] time of burn for thrusters
N_wheels = 4;   % number of reaction wheels
days = 15*365;  %[day] mission duration

% Initializing
orbital_rad_earth = [r_earth_moon - r_a, r_earth_moon - r_p, r_earth_moon + r_a, r_earth_moon + r_p];
orbital_rad_moon = [r_a, r_p];

% Gravity Gradient Torque
for i = 1 : length(orbital_rad_earth)
    T_gEarth_vec(i) = 3 * mu_earth * abs(I_zz - I_yy) * sin(2 * theta) / (2 * orbital_rad_earth(i) ^ 3); %[Nm]
end
T_gEarth_zy = max(T_gEarth_vec);
for i = 1 : length(orbital_rad_earth)
    T_gEarth_vec(i) = 3 * mu_earth * abs(I_zz - I_xx) * sin(2 * theta) / (2 * orbital_rad_earth(i) ^ 3); %[Nm]
end
T_gEarth_zx = max(T_gEarth_vec);
T_gEarth = max(T_gEarth_zy, T_gEarth_zx); % max gravity gradient due to Earth
for i = 1 : length(orbital_rad_moon)
    T_gMoon_vec(i) = 3 * mu_moon * abs(I_zz - I_yy) * sin(2 * theta) / (2 * orbital_rad_moon(i) ^ 3); %[Nm]
end
T_gMoon_zy = max(T_gMoon_vec);
for i = 1 : length(orbital_rad_moon)
    T_gMoon_vec(i) = 3 * mu_moon * abs(I_zz - I_xx) * sin(2 * theta) / (2 * orbital_rad_moon(i) ^ 3); %[Nm]
end
T_gMoon_zx = max(T_gMoon_vec);
T_gMoon = max(T_gMoon_zy, T_gMoon_zx); % max gravity gradient due to Moon

% Solar Radiation Pressure Torque
solar_force = J_s * A_s * cos(inc) * (1 + q) / c; %[N]
diff_cps_cg = 0.1 * A_s; % difference of center of solar pressure and center of gravity
T_sp = abs(solar_force) * diff_cps_cg; %[Nm]

% Slew Torque
T_slew = 4 * theta_slew * (I_xx + I_yy + I_zz) / t_slew ^2; %[Nm]

% Required Torque
T_g_max = max(T_gEarth, T_gMoon);
T_max = T_sp + T_g_max;
T_req = max((1.25 * T_max), T_slew); %[Nm]

% Required Momentum Storage
h_RW = T_req * P * 0.707 / 4; %[Nm/s]

% Required Power
P_RW = 1000 * T_req + 4.51 * h_RW ^ 0.47; %[W]

% Momentum Dump with Thrusters
% Required Force
F_MD = h_RW / L / t_burn; %[N]

% Total Impulse
I_t = t_burn * N_wheels * days;

% Propellant Mass
M_p = I_t * F_MD / Isp / g_earth; %[kg]