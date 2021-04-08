function[outputs] = Starship_delta_v(lambda, payload, starship_mass, isp_landing, isp_starship_ascent, isp_vacuum)
%% Inputs
% lambda = inert mass fraction of starship only: calculated
%   without considering payload as inert mass
% payload_mass = the payload that the second stage is carrying in metric
%   tons
% starship_mass = mass of only the starship vehicle after 1st stage
%   separation in metric tons
% isp_landing = isp of engines at sea level in seconds
% isp_starship_ascent = average isp of starship during its 
%   ascent phase in seconds
% isp_vacuum = starship engine isp in vacuum in seconds
% Author: Trevor Pfeil

%% Converting to kg
payload = payload * 1000;
starship_mass = starship_mass * 1000;
%%Determining the delta_v available for each configuration
starship_final = (starship_mass * lambda) + Starship_landing(lambda, starship_mass, isp_landing, isp_vacuum) + payload; %kg

delta_v_starship_reuse = 9.81 * isp_starship_ascent * log(starship_mass / starship_final); %m/s
delta_v_starship_expend = 9.81 * isp_starship_ascent * log(starship_mass / (payload + starship_mass*lambda)); %m/s
outputs = [delta_v_starship_reuse, delta_v_starship_expend];