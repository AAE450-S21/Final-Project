function[mp] = Starship_landing(lambda, starship_mass, isp_landing, isp_vacuum)
%%Inputs
%lambda = inert mass fraction of the super heavy booster
%starship_mass = mass of only starship at liftoff in kg
%isp_landing = isp of engines at sea level in seconds
%isp_vacuum = isp of engines in vacuum in seconds
%NOTE: the initial value of mp_guess may need to be increased if starship
%is landing with a significant payload.

%% Outputs
% mp = mass of propellant needed to land starship in kg
% Author: Trevor Pfeil

%% Definitions
CDA = 334.9044; %summed frontal areas * local drag coefficients
a_dens = 1.225; %air density in kg/m^3
g = 9.81; %m/s^2
isp = isp_landing; %sec
isp_vac = isp_vacuum; %sec
raptor_thrust = 2200000; %N
engine_count = 3; %number of engines used in descent
dv_safety_factor = 1; % extra percent delta v desired for safety margins
inert_mass = lambda * starship_mass;%kg

%%Propellant to land propulsively
m_dot_raptor = raptor_thrust/isp/g; %kg/s
m_dot_engines = m_dot_raptor * engine_count; %kg/s
thrust = raptor_thrust * engine_count; %N
mp_guess = 10000;%kg
err = 999;

while(abs(err)>0.1)
mt = mp_guess + inert_mass; %kg
v_term1 = sqrt((2*g*(mt))/(a_dens*CDA)); %delta v needed based on mp_guess
v_term2 = g*isp*log((mt)/inert_mass) - g*(mt-mt*exp(-m_dot_engines*v_term1 / thrust))/m_dot_engines; %delta v available based on mp_guess

err = v_term1-v_term2;
    if v_term2>v_term1
       mp_guess = mp_guess - 10; %decrease propellant mass
    else
       mp_guess = mp_guess + 1; %increase propellant mass
    end
end
mp1 = mp_guess * (1+dv_safety_factor);

%%Propellant to deorbit starship
target = 100; %km target altitude for effective aerobraking
current = 600; %km current orbital altitude

dv = sqrt(398600.4415/(6378.136+current)) * (1-sqrt(2*(target+6378.136)/(2*6378.136+target+current))) *1000; %m/s delta v needed to reach target periapsis
mp2 = (exp(dv / 9.81 /isp_vac) * (inert_mass + mp1)) - inert_mass - mp1;%mass of propellant to de-orbit starship
mp = mp1 + mp2;
