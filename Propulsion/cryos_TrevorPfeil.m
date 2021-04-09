close all
clear 
%% setup
q_vap_lox = 214000; %Vaporization energy of oxygen J/kg
q_vap_ch4 = 136360; %Vaporization energy of methane J/kg
cp_lox = 920; %Heat capacity of liquid oxygen J/kgK
cp_ch4 = 2087; %Heat capacity of liquid methane J/kg
t_lox = 90.19; %lox boiling temp at 1 atm in K
t_ch4 = 111.6; %ch4 boiling temp at 1 atm in K
subcool_lox = 1;% temp below boiling lox in K
subcool_ch4 = 1;% temp below boiling ch4 in K
rho_ch4 = 438.9; %density of liquid ch4  kg/m3
rho_lox = 1141; %density of lox kg/m3
thermal_conductivity_lox = 0.026; %Thermal conductivity of liquid oxygen w/mK
thermal_conductivity_ch4 = 0.1197; %Thermal conductivity of liquid methane w/mK
prop_storage = 463.27; %total amount of propellant stored in Mg or the amount required for a leg of the trip
prop_storage_cap = 491.1; %total amount of propellant the depot can store
mix_lox = 0.78; %mixture ratio of lox
mix_ch4 = 1-mix_lox; %mixture ratio of ch4
ullage = 0.06; %size of ullage
heat_load = 0.4; %heat load in w/m^2 from solar radiation
heat_load_extra = 0.2;%heat load in w/m^2 from conduction in the depot
active_cooling = 150; %active cooling refrigeration capacity for methane in Watts
active_cooling_lox = 150; %active cooling refrigeration capacity for oxygen in Watts
launch_schedule = [1,6.28,11.56,16.84,22.12,27.4]; %days on which tankers will fly to the LEO depot
launch_schedule = [launch_schedule,0];%the launch schedule should always start on day 1.
propellant_payload_capacity = 193.593669; %in Mg
if(size(launch_schedule)<prop_storage/propellant_payload_capacity)
    fprintf('\n Insufficient launches given to fill LEO depot to required amount\n Add another day to the launch schedule\n')
end
propellant_payload_capacity = propellant_payload_capacity*1000; %converting propellant to kg

%% tank sizing
tank_count_lox = 2;
tank_count_ch4 = 2;
radius = 2.2;%meters
height_lox = 26;%meters
height_ch4 = 26;%meters
sa_cap_lox = 4*pi*radius^2; %m^2
sa_cap_ch4 = 4*pi*radius^2; %m^2
sa_wall_lox = (height_lox - 2*radius)*pi*2*radius; %m^2
sa_wall_ch4 = (height_ch4 - 2*radius)*pi*2*radius; %m^2
sa_lox = sa_cap_lox+sa_wall_lox; %surface area of 1 lox tank
sa_ch4 = sa_cap_ch4+sa_wall_ch4; %surface area of 1 ch4 tank
tank_sa_lox = sa_lox*tank_count_lox; %surface area of all lox tanks
tank_sa_ch4 = sa_ch4*tank_count_ch4; %surface area of all ch4 tanks
tank_sa_lox = 371.2;
tank_sa_ch4 = 262.83;
heat_flux_lox = tank_sa_lox*(heat_load); %w
heat_flux_ch4 = tank_sa_ch4*(heat_load); %w

%% no active cooling
evap_rate_lox = heat_flux_lox / q_vap_lox *60*60*24; %kg/day
evap_rate_ch4 = heat_flux_ch4 / q_vap_lox*60*60*24; %kg/day
point_evap_rate_lox = tank_sa_lox * heat_load_extra / (q_vap_lox+cp_lox*(subcool_lox)) *60*60*24; %kg/day
point_evap_rate_ch4 = tank_sa_ch4 * heat_load_extra / (q_vap_ch4+cp_ch4*(subcool_ch4)) *60*60*24; %kg/day
total_evap_rate_lox = evap_rate_lox + point_evap_rate_lox;
total_evap_rate_ch4 = evap_rate_ch4 + point_evap_rate_ch4;

%% active cooling
active_evap_rate_lox = (heat_flux_lox-active_cooling_lox) / q_vap_lox *60*60*24; %kg/day
active_evap_rate_ch4 = (heat_flux_ch4-active_cooling) / q_vap_lox*60*60*24; %kg/day

active_point_evap_rate_lox = tank_sa_lox * heat_load_extra / (q_vap_lox+cp_lox*(subcool_lox)) *60*60*24; %kg/day
active_point_evap_rate_ch4 = tank_sa_ch4 * heat_load_extra / (q_vap_ch4+cp_ch4*(subcool_ch4)) *60*60*24; %kg/day

active_total_evap_rate_lox = active_evap_rate_lox + active_point_evap_rate_lox;%kg/day
active_total_evap_rate_ch4 = active_evap_rate_ch4 + active_point_evap_rate_ch4;%kg/day

%% tracking propellant over time with flights to refuel
daily_heat_flux_lox_passive = tank_sa_lox*(heat_load+heat_load_extra)*60*60*24; %J/day
daily_heat_flux_ch4_passive = tank_sa_ch4*(heat_load+heat_load_extra)*60*60*24; %J/day
daily_heat_flux_lox_active = (tank_sa_lox*(heat_load+heat_load_extra)-active_cooling_lox)*60*60*24; %J/day
daily_heat_flux_ch4_active = (tank_sa_ch4*(heat_load+heat_load_extra)-active_cooling)*60*60*24; %J/day

temp_lox_in = t_lox-subcool_lox; %initial temp in kelvin when transferred
temp_ch4_in = t_ch4-subcool_lox; %initial temp in kelvin when transferred

stored_lox_mass_passive = 0;
stored_ch4_mass_passive = 0;
stored_lox_mass_active = 0;
stored_ch4_mass_active = 0;
temp_lox_passive = 0;
temp_ch4_passive = 0;
temp_lox_active = 0;
temp_ch4_active = 0;

for n = 1:length(launch_schedule)-1
    
    temp_lox_passive = (temp_lox_in*(propellant_payload_capacity*mix_lox) + temp_lox_passive*stored_lox_mass_passive)/((propellant_payload_capacity*mix_lox)+stored_lox_mass_passive);
    temp_ch4_passive = (temp_ch4_in*(propellant_payload_capacity*mix_ch4) + temp_ch4_passive*stored_ch4_mass_passive)/((propellant_payload_capacity*mix_ch4)+stored_ch4_mass_passive);
    temp_lox_active = (temp_lox_in*(propellant_payload_capacity*mix_lox) + temp_lox_active*stored_lox_mass_active)/((propellant_payload_capacity*mix_lox)+stored_lox_mass_active);
    temp_ch4_active = (temp_ch4_in*(propellant_payload_capacity*mix_ch4) + temp_ch4_active*stored_ch4_mass_active)/((propellant_payload_capacity*mix_ch4)+stored_ch4_mass_active);
    
    stored_lox_mass_passive = stored_lox_mass_passive+propellant_payload_capacity * mix_lox; %adding delivered propellant to total
    stored_ch4_mass_passive = stored_ch4_mass_passive+propellant_payload_capacity * mix_ch4;
    stored_lox_mass_active = stored_lox_mass_active+propellant_payload_capacity * mix_lox; %adding delivered propellant to total
    stored_ch4_mass_active = stored_ch4_mass_active+propellant_payload_capacity * mix_ch4;
    
    temp_lox_passive = daily_heat_flux_lox_passive*(launch_schedule(n+1)-launch_schedule(n)) /cp_lox / stored_lox_mass_passive +temp_lox_passive; %finding how much temp rise there is until the next delivery
    temp_ch4_passive = daily_heat_flux_ch4_passive*(launch_schedule(n+1)-launch_schedule(n)) /cp_ch4 / stored_ch4_mass_passive +temp_ch4_passive;
    temp_lox_active = daily_heat_flux_lox_active*(launch_schedule(n+1)-launch_schedule(n)) /cp_lox / stored_lox_mass_active +temp_lox_active; %finding how much temp rise there is until the next delivery
    temp_ch4_active = daily_heat_flux_ch4_active*(launch_schedule(n+1)-launch_schedule(n)) /cp_ch4 / stored_ch4_mass_active +temp_ch4_active;
    %check if temp is above boiling, if it is find out how much prop boiled
    %off
    if(temp_lox_passive>t_lox)
        q_excess = stored_lox_mass_passive*cp_lox*(temp_lox_passive-t_lox);
        lox_passive_boiloff = q_excess/q_vap_lox;
        stored_lox_mass_passive = stored_lox_mass_passive - lox_passive_boiloff;
        temp_lox_passive = t_lox; %boiloff keeps liquid at boiling point
    end
    if(temp_ch4_passive>t_ch4)
        q_excess = stored_ch4_mass_passive*cp_ch4*(temp_ch4_passive-t_ch4);
        ch4_passive_boiloff = q_excess/q_vap_ch4;
        stored_ch4_mass_passive = stored_ch4_mass_passive - ch4_passive_boiloff;
        temp_ch4_passive = t_ch4; %boiloff keeps liquid at boiling point
    end
    if(temp_lox_active>t_lox)
        q_excess = stored_lox_mass_active*cp_lox*(temp_lox_active-t_lox);
        lox_active_boiloff = q_excess/q_vap_lox;
        stored_lox_mass_active = stored_lox_mass_active - lox_active_boiloff;
        temp_lox_active = t_lox; %boiloff keeps liquid at boiling point
    end
    if(temp_ch4_active>t_ch4)
        q_excess = stored_ch4_mass_active*cp_ch4*(temp_ch4_active-t_ch4);
        ch4_active_boiloff = q_excess/q_vap_ch4;
        stored_ch4_mass_active = stored_ch4_mass_active - ch4_active_boiloff;
        temp_ch4_active = t_ch4; %boiloff keeps liquid at boiling point
    end
    
    lox_mass_passive(n) = stored_lox_mass_passive;
    ch4_mass_passive(n) = stored_ch4_mass_passive;
    lox_mass_active(n) = stored_lox_mass_active;
    ch4_mass_active(n) = stored_ch4_mass_active;
    launch_plot(n) = launch_schedule(n+1);
    mass_lox_passive = lox_mass_passive(n);
    mass_lox_active = lox_mass_active(n);
    mass_ch4_passive = ch4_mass_passive(n);
    mass_ch4_active = ch4_mass_active(n);
end

figure
hold on
plot(launch_schedule(1:n), lox_mass_passive,'o')
plot(launch_schedule(1:n), lox_mass_active,'x')
plot(launch_schedule(1:n), ch4_mass_passive,'+')
plot(launch_schedule(1:n), ch4_mass_active,'*')
xlabel('Mass of Propellant (Kg)')
ylabel('Days')
title('Propellant Mass During Loading')
legend('LOx No Cooling','LOx Active Cooling','CH4 No Cooling','CH4 Active Cooling','Location','best')

%% tracking propellant mass over time (no refuelling)
mass_lox_passive = mix_lox*prop_storage_cap*1000;
mass_lox_active = mix_lox*prop_storage_cap*1000;
mass_ch4_passive = mix_ch4*prop_storage_cap*1000;
mass_ch4_active = mix_ch4*prop_storage_cap*1000;
if(temp_lox_active < t_lox)
saturation_time_lox_active = rho_lox*thermal_conductivity_lox * cp_lox*(temp_lox_active-t_lox)^2 /heat_load^2/60/60/24; %days
else
    saturation_time_lox_active =0;
end
if(temp_lox_passive < t_lox)
saturation_time_lox_passive = rho_lox*thermal_conductivity_lox * cp_lox*(temp_lox_passive-t_lox)^2 /heat_load^2/60/60/24; %days
else
    saturation_time_lox_passive = 0;
end
if(temp_ch4_active<t_ch4)
saturation_time_ch4_active = rho_ch4*thermal_conductivity_ch4 * cp_ch4*(temp_ch4_active-t_ch4)^2 /heat_load^2/60/60/24; %days
else
    saturation_time_ch4_active = 0;
end
if(temp_ch4_passive<t_ch4)
saturation_time_ch4_passive = rho_ch4*thermal_conductivity_ch4 * cp_ch4*(temp_ch4_passive-t_ch4)^2 /heat_load^2/60/60/24; %days
else
    saturation_time_ch4_passive = 0;
end

time = [1:1:500];
for n = time
    if(n<saturation_time_lox_passive)
        mass_lox_tracked_passive(n) = mass_lox_passive;
        mass_lox_tracked_active(n) = mass_lox_active;
    else
        mass_lox_tracked_passive(n) = mass_lox_tracked_passive(n-1) - total_evap_rate_lox;
        mass_lox_tracked_active(n) = mass_lox_tracked_active(n-1) - active_total_evap_rate_lox;
    end
    if(n<saturation_time_ch4_passive)
        mass_ch4_tracked_passive(n) = mass_ch4_passive;
        mass_ch4_tracked_active(n) = mass_ch4_active;
    else
        mass_ch4_tracked_passive(n) = mass_ch4_tracked_passive(n-1) - total_evap_rate_ch4;
        mass_ch4_tracked_active(n) = mass_ch4_tracked_active(n-1) - active_total_evap_rate_ch4;
    end 
end
required_ch4 = prop_storage*1000*mix_ch4;
required_lox = prop_storage*1000*mix_lox;
n=1;
while(mass_ch4_tracked_active(n)>required_ch4 && n<length(mass_ch4_tracked_active))
    max_storage_length_ch4_active = n;
    n = n+1;
end
if(n==1)
    max_storage_length_ch4_active = 0;
end
n=1;
while(mass_ch4_tracked_passive(n)>required_ch4 && n<length(mass_ch4_tracked_passive))
    max_storage_length_ch4_passive = n;
    n = n+1;
end
if(n==1)
    max_storage_length_ch4_passive = 0;
end
n=1;
while(mass_lox_tracked_active(n)>required_lox && n<length(mass_lox_tracked_active))
    max_storage_length_lox_active = n;
    n = n+1;
end
if(n==1)
    max_storage_length_lox_active = 0;
end
n=1;
while(mass_lox_tracked_passive(n)>required_lox && n<length(mass_lox_tracked_passive))
    max_storage_length_lox_passive = n;
    n = n+1;
end
if(n==1)
    max_storage_length_lox_passive = 0;
end
max_storage_length_passive = min(max_storage_length_lox_passive, max_storage_length_ch4_passive);
max_storage_length_active = min(max_storage_length_lox_active, max_storage_length_ch4_active);
fprintf('\nMaximum storage length with no cooling = %f days',max_storage_length_passive)
fprintf('\nMaximum storage length with active cooling = %f days',max_storage_length_active)
figure
hold on
plot(time, mass_lox_tracked_passive/required_lox,'g-','LineWidth',2)
plot(time, mass_lox_tracked_active/required_lox,'g--','LineWidth',2)
plot(time, mass_ch4_tracked_passive/required_ch4,'r:','LineWidth',2)
plot(time, mass_ch4_tracked_active/required_ch4,'r-.','LineWidth',2)
plot(max_storage_length_passive, 1,'bx','LineWidth',2)
plot(max_storage_length_active, 1,'bx','LineWidth',2)
legend('LOx No Cooling','LOx Active Cooling','CH4 No Cooling','CH4 Active Cooling','Location','best')
title('LLO Depot Propellant Loss')
xlabel('Days')
ylabel('Percentage of Required Propellant Remaining')
