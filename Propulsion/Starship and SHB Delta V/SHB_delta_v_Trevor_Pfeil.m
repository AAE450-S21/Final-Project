function[delta_v_ideal] = SHB_delta_v(lambda, payload_mass, GLOW, isp_landing, isp_SHB_ascent)
%%Inputs
% lambda = inert mass fraction of the Super Heavy booster only: calculated
%   without considering payload as inert mass
% payload_mass = the payload that the first stage is carrying in metric
%   tons
% GLOW = gross liftoff weight of entire vehicle (1st stage, 2nd stage, and
%   the payload of the entire vehicle) in metric tons
% isp_landing = isp of engines at sea level in seconds
% isp_SHB_ascent = average isp of super heavy booster during its 
%   ascent phase in seconds
% Author: Trevor Pfeil

%% Converting to kg
GLOW = GLOW * 1000;
payload_mass = payload_mass * 1000;
%%Determining the delta_v available for only reusable configurations
SHB_mass = (GLOW-payload_mass); %mass of SHB at liftoff in kg
SHB_final = SHB_mass * lambda + SHB_landing(lambda, SHB_mass, isp_landing); %mass of SHB at stage separation in kg
delta_v_ideal = 9.81*isp_SHB_ascent*log(GLOW/(SHB_final+payload_mass));