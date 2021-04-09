%% Starship launch platform delta v estimator
% Author: Trevor Pfeil

%%Definitions
payload = 100; %metric tons
isp_landing = 353; %isp used for sea level propulsive landing calculations in seconds
isp_starship_ascent = 365; %average isp of starship during its ascent phase in seconds
isp_SHB_ascent = 353; %average isp of super heavy booster during its ascent phase in seconds
isp_vacuum = 380; %isp of starship during its deorbiting phase in seconds
inert_mass_starship = 120; %not including payload as inert mass. In metric tons
propellant_mass_starship = 1200; %in metric tons
inert_mass_SHB = 280; %not including payload as inert mass. In metric tons
propellant_mass_SHB = 3300; %in metric tons

%% Vehicle variable calculations
inert_mass_fraction_SHB = inert_mass_SHB/(inert_mass_SHB + propellant_mass_SHB); %inert mass fraction for 1st stage
inert_mass_fraction_starship = inert_mass_starship/(inert_mass_starship + propellant_mass_starship); %inert mass fraction for 2nd stage
payload_stage_1 = payload + inert_mass_starship + propellant_mass_starship; %effective payload that the 1st stage must carry in metric tons
GLOW = payload + inert_mass_starship + propellant_mass_starship + inert_mass_SHB + propellant_mass_SHB; %Gross liftoff weight in metric tons

%% Available delta V for each configuration. 
dv_1 = SHB_delta_v(inert_mass_fraction_SHB, payload_stage_1, GLOW, isp_landing, isp_SHB_ascent); %delta v from 1st stage
dv_2 = Starship_delta_v(inert_mass_fraction_starship, payload, inert_mass_starship + propellant_mass_starship, isp_landing, isp_starship_ascent, isp_vacuum); %delta v from 2nd stage
dv_2_reuse = dv_2(1);
dv_2_expend = dv_2(2);
dv_total_reuse = dv_1 + dv_2_reuse; %delta V available if we land SHB and land the starship upper stage.
dv_total_expend = dv_1 + dv_2_expend; %delta V available if we land SHB but expend the starship upper stage.
