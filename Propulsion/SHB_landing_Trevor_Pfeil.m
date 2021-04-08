function[mp] = SHB_landing(lambda,SHB_mass, isp_landing)
%% Inputs
%lambda = inert mass fraction of the super heavy booster
%SHB_mass = mass of only super heavy booster at liftoff in kg
%isp_landing = isp of engines at sea level in seconds
%NOTE: the initial value of mp_guess may need to be increased if SHB
%is landing with any significant extra propellant
%% Outputs
% mp = mass of propellant needed to land the super heavy booster in kg
% Author: Trevor Pfeil

%% Definitions
CDA = 64.8+52.17; %summed frontal areas * local drag coefficients
a_dens = 1.225; %air density in kg/m^3
g = 9.81; %m/s^2
isp = isp_landing; %sec
raptor_thrust = 2200000; %N
engine_count = 3; %number of engines used in descent
dv_safety_factor = 0.1; % extra percent delta v desired for safety margins
inert_mass = SHB_mass*lambda;%kg

%% Propellant needed to land propulsively
m_dot_raptor = raptor_thrust/isp/g; %kg/s
m_dot_engines = m_dot_raptor * engine_count; %kg/s
thrust = raptor_thrust * engine_count; %N
mp_guess = 80000;%kg
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
mp = mp_guess * (1+dv_safety_factor);
