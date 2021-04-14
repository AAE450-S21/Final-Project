%Bradley Bulczak
%Depot fueling flight logistics
%This MATLAB script determines the number of launches are required in order
%To provide both of the propellant depots with the necessary amount of fuel

clc
clear

%% Initialization
%Valus derived from other group member calculations

dV_esurf_to_600km = 9.5;
dV_vous_depot = 10/1000;        % rendezvous with depot
dV_tli = 3.1809;
dV_loi = 0.8928;            % lunar orbit insertion
dV_100km_to_lsurf = 2.5;
dV_lsurf_to_100km = 2.2;
dV_llo_to_leo = 4.2124;
m_inert = 120*1000;
mpl = 0;
mp_max = 1200000;
isp_vacuum = 380;
isp_landing = 335;

m_fuel_required_leo = 1065.121 * 1000; %kg
max_leo_capacity = 1128.9*1000; %kg

m_fuel_required_lunar = 463.274*1000; %kg

two_way_min = 378.983*1000; %kg

current_fuel_lunar = 0;
current_fuel_leo = 0;

%% Calculations

%Calculates the amount of fuel leftover at the leo and lunar depots
[dV_shb, dV_star_reuse, dV_star_expend, dVtotal_reuse, dVtotal_expend, mpLanding] = delta_v_payload(mpl);
[mp_used1, mp_leftover1] = esurf_to_depot(mpl, dV_esurf_to_600km, dV_shb, dV_vous_depot);

mp_leftover1 = mp_leftover1 - mpLanding;

dV_leo_to_llo = dV_tli + dV_loi;
[mp_used2, mp_leftover2] = calc_prop_mass_func(dV_leo_to_llo, mpl, mp_max);

%Adjusts for starship returning to earth returning to earth
[mp_used, mp_leftover2] = calc_prop_mass_func(1.1, mpl, mp_leftover2);
mp_leftover2 = mp_leftover2 - mpLanding;


leo_flight = 0;
lunar_flight = 0;
i = 1;
j = 1;

%Refueling both depots
while current_fuel_leo < max_leo_capacity && current_fuel_lunar < m_fuel_required_leo %Ensures both depots are fully refueled
      current_fuel_leo = current_fuel_leo + mp_leftover1; %Adds leftover fuel from launch to leo
    if current_fuel_leo > max_leo_capacity %Checks to make sure fuel at leo isn't over capacity
        current_fuel_leo = max_leo_capacity;
    end
    leo_flight = leo_flight + 1; %Adds a flight to the number of flights to leo depot
    leo_flights(i) = leo_flight;  %Puts flight number in a vector
    fuel_leo(i) = current_fuel_leo; %Puts current fuel at leo in a vector
    i = i + 1; %
    if current_fuel_leo > mp_used1
        if current_fuel_lunar < m_fuel_required_lunar
            current_fuel_lunar = current_fuel_lunar + mp_leftover2;
            lunar_flight = lunar_flight + 1; %counts the lunar flights
            lunar_flights(j) = lunar_flight; %Puts lunar flights in a vector
            fuel_lunar(j) = current_fuel_lunar; %creates a vector of the lunar fuel
            current_fuel_leo = current_fuel_leo - mp_used1; %Adjusts the new fuel at leo
            j = j + 1;
            leo_flight = leo_flight - 1; %makes sure lunar launch isn't counted as leo launch
        end
    end
  
end

%% Plotting
minimum_leo = ones(1,length(fuel_leo))*m_fuel_required_leo/1000;
max_leo = ones(1,length(fuel_leo))*max_leo_capacity/1000;
two_way = ones(1,length(fuel_leo))*two_way_min/1000;

%Plots the fuel at the leo depot against the number of launches to the leo
%depot
figure(1)
plot(leo_flights,fuel_leo/1000)
hold on
grid on
plot(leo_flights,max_leo)
plot(leo_flights, minimum_leo)
plot(leo_flights,two_way)
xticks(0:length(fuel_leo))
title('Fuel at LEO')
xlabel('Launches to leo depot')
ylabel('Fuel at lunar depot (Mg)')
legend('Fuel at leo','Max leo capacity','Minimum for one way trip','Minimum for two way trip') 
legend('Location','southeast')
hold off

minimum_lunar = ones(1,length(fuel_lunar))*m_fuel_required_lunar/1000;

%Plots the fuel at the lunar station against the number of flights
figure(2)
plot(lunar_flights,fuel_lunar/1000)
hold on
grid on
plot(lunar_flights,minimum_lunar)
xticks(0:length(fuel_lunar))
title('Fuel at lunar depot')
xlabel('Flight to lunar depot #')
ylabel('Fuel at leo depot (Mg)')
legend('Fuel at llo','Minimum fuel required') 
legend('Location','southeast')
hold off

final_fuel_leo = fuel_leo(end)/1000;
final_fuel_lunar = fuel_lunar(end)/1000;






