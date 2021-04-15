clear
clc

%% Initialization
m_pump = 182351.03; %kg
m_LEO = 1132882.753; %kg
m_LEO_empty = 38777; %kg
m_LLO = 577588.903; %kg
m_LLO_empty = 102301.88; %kg

g = 9.81; %ms^-2
p_rate = 1200/60; %kg/s,
p_time_depot = m_pump / p_rate; %s, from starship to depot
p_time_ship = 1088622 / p_rate; %s, from depot to starship

%% Engine Charecteristics, taken from 'Rocket Propulsion'
isp_methalox = 379; %s
isp_hydrazine = 234; %s

%% Required Accelerations
a_sc = .0001*g; %Short Coast <20 mins
a_ic = 8*10^(-5)*g; %Intermediate Coast 20mins to 2 hrs
a_lc = 2*10^(-5)*g; %Long Coast up to 17 hrs

%% Thrust, Mass calcs for full tanker and depots comparing coast missions
% Thrusts
F_sc_LEO = m_LEO*a_sc; %N
F_ic_LEO = m_LEO*a_ic; %N
F_lc_LEO = m_LEO*a_lc; %N

F_sc_LLO = m_LLO*a_sc; %N
F_ic_LLO = m_LLO*a_ic; %N
F_lc_LLO = m_LLO*a_lc; %N

% Mass Flow, kg/s
m_sc_LEO_m = F_sc_LEO / (isp_methalox * g);
m_sc_LEO_h = F_sc_LEO / (isp_hydrazine * g);

m_ic_LEO_m = F_ic_LEO / (isp_methalox * g);
m_ic_LEO_h = F_ic_LEO / (isp_hydrazine * g);

m_lc_LEO_m = F_lc_LEO / (isp_methalox * g);
m_lc_LEO_h = F_lc_LEO / (isp_hydrazine * g);

m_sc_LLO_m = F_sc_LLO / (isp_methalox * g);
m_sc_LLO_h = F_sc_LLO / (isp_hydrazine * g);

m_ic_LLO_m = F_ic_LLO / (isp_methalox * g);
m_ic_LLO_h = F_ic_LLO / (isp_hydrazine * g);

m_lc_LLO_m = F_lc_LLO / (isp_methalox * g);
m_lc_LLO_h = F_lc_LLO / (isp_hydrazine * g);

% Mass Calculations
mass_LEO_depot_m = p_time_depot * m_ic_LEO_m; %kg, methalox
mass_LEO_depot_h = p_time_depot * m_ic_LEO_h; %kg, hydrazine

mass_LLO_depot_m = p_time_depot * m_ic_LLO_m; %kg, methalox
mass_LLO_depot_h = p_time_depot * m_ic_LLO_h; %kg, hydrazine

mass_LEO_ship_m = p_time_ship * m_lc_LEO_m; %kg, methalox
mass_LEO_ship_h = p_time_ship * m_lc_LEO_h; %kg, hydrazine

mass_LLO_ship_m = p_time_ship * m_lc_LLO_m; %kg, methalox
mass_LLO_ship_h = p_time_ship * m_lc_LLO_h; %kg, hydrazine

%% Depot Masses (Found in "depot min mass requirements by mission")
% Case 1, Earth to Lunar Surface, Uncrewed, No Return
% This is just a LEO refill
m_refuel_1 = 984.493136 * 1000; %kg, LEO
p_time_1 = m_refuel_1 / p_rate;

% Case 2, Earth to Lunar Surface, Crewed, No Return
% This is just a LEO refill
m_refuel_2 = 1065.121136 * 1000; %kg, LEO
p_time_2 = m_refuel_2 / p_rate;

% Case 3, Earth to Lunar surface and back to earth, crewed both ways							
% stopping at both lunar and leo depots, 100 tons payload (to moon), 19 crew return	
m_refuel_LEO_3 = 378.983 * 1000; %kg
m_refuel_LLO_in = 411.834 * 1000; %kg
m_refuel_LLO_out = 51.44 * 1000; %kg
p_time_LEO_3 = m_refuel_LEO_3 / p_rate;
p_time_LLO_in = m_refuel_LLO_in / p_rate;
p_time_LLO_out = m_refuel_LLO_out / p_rate;

%% Mass Calcs for mission requirements from Prop Depot
p_times = [p_time_1 p_time_2 p_time_LEO_3 p_time_LLO_in p_time_LLO_out];
a = zeros(1,length(p_times));

%mass, kg
m_LEO_arr= [m_refuel_1 m_refuel_2 m_refuel_LEO_3];
m_LLO_arr = [m_refuel_LLO_in m_refuel_LLO_out];
m = [(m_LEO_arr + m_LEO_empty) (m_LLO_arr + m_LLO_empty)];

%Find Required Acceleration
t_sc = 20 * 60;
t_ic = 2 * 60 * 60;
t_lc = 17 * 60 * 60;

for i = 1:length(p_times)
    if p_times(i) < t_sc
        a(i) = a_sc;
    elseif p_times(i) < t_ic
        a(i) = a_ic;
    else 
        a(i) = a_lc;
    end 
end 

%Thrust, N
F_req = m .* a;

%Mass Flow, kg/s
m_dot = F_req / (isp_hydrazine * g);

%Mass, kg
mass = m_dot .* p_times;
m_case_1 = mass(1);
m_case_2 = mass(2);
m_case_3_LEO = mass(3);
m_case_3_LLO = mass(4)+mass(5);
m_case_3 = m_case_3_LEO+m_case_3_LLO;

%% Mass per trip (refuels)
m_LEO_ref = linspace(m_LEO_empty,m_LEO,6);
m_LLO_ref = linspace(m_LLO_empty,m_LLO,3);

%Required Thrusts, N
% These will all be intermediate coast missions
F_LEO_ref = m_LEO_ref * a_ic;
F_LLO_ref = m_LLO_ref * a_ic;

mdot_LEO_ref = F_LEO_ref / (isp_hydrazine * g);
mdot_LLO_ref = F_LLO_ref / (isp_hydrazine * g);

%Times to fill depots, s
t_LEO_ref = mdot_LEO_ref * p_time_depot;
t_LLO_ref = mdot_LLO_ref * p_time_depot;

%Masses for refuel missions, kg
m_LEO_ref = mdot_LEO_ref .* t_LEO_ref;
m_LLO_ref = mdot_LLO_ref .* t_LLO_ref;

%Sum of masses for a full depot refuel
m_LEO_ref_total = sum(m_LEO_ref);
m_LLO_ref_total = sum(m_LLO_ref);

%Sum of masses for Case 3 (LEO wont be fully fueled)
m_LEO_ref_total_3 = m_LEO_ref_total - (m_LEO_ref(5) + m_LEO_ref(6));

%% Full mission masses:
%Case 1
m_tot_LEO_1 = m_LEO_ref_total + m_case_1;
%Case 2
m_tot_LEO_2 = m_LEO_ref_total + m_case_2;
%Case 3
m_tot_3 = 4*m_LEO_ref_total_3 + m_LLO_ref_total + m_case_3;
LLO_mass = m_LLO_ref_total + m_case_3_LLO;
LEO_mass_3 = m_tot_3 - LLO_mass;
