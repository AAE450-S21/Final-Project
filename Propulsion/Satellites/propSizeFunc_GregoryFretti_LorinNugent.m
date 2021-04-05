function totalMass = propSizeFunc(propWattage, payloadWattage, Isp, dryMass, dV)

%The first round of dry mass estimates produced an approximate mass
%as well as dry mass for the ACS system.


dry_estimate_total = dryMass; %kg



%Solar panel size estimate to drive EP
n_years = 15; %lifespan


extraFactor = 2.1; %2.1 allows the panels to drive the propulsion system while charging the batteries in half an orbit

wattage_required = (propWattage*extraFactor + payloadWattage) / (1-(0.5/100))^n_years; %0.5% per year decay
%The addition of the payload wattage was from Lorin Nugent

powerDensity_panels = 150; %W/kg, http://www.dept.aoe.vt.edu/~cdhall/courses/aoe4065/power.pdf

panel_mass = wattage_required/powerDensity_panels;

%Battery size estimate for EP

GM=0.00490*10^6; %km^3/s^2, https://nssdc.gsfc.nasa.gov/planetary/factsheet/moonfact.html
orb_alt = 50; %km
SMA = (1738.1+orb_alt);
orbit_period = 2*pi*sqrt(SMA^3/GM);


%Worst case: roughly 50% of the time is
%eclipse
eclipse_time = orbit_period * 0.5;
eclipse_energy = propWattage * eclipse_time; %Joules


%https://www.sciencedirect.com/science/article/pii/S0378775303002222
%14 year lifespan from 80% depth of discharge, so we'll use 70%
%Thus, 70% of the battery's energy capacity is spent in the time spent
%running in eclipse


batt_cap = (eclipse_energy * 1.2)/0.7; %J

batt_energy_density = 180; %Wh/kg %https://www.fluxpower.com/blog/what-is-the-energy-density-of-a-lithium-ion-battery

batt_mass = (batt_cap*(1/3600))/(batt_energy_density);

dead_mass = dry_estimate_total+batt_mass+panel_mass;

%Propulsion mass
%https://www.colorado.edu/faculty/kantha/sites/default/files/attached-files/arnold_electricprop.pdf

g0 = 9.81;

propmass = dead_mass*exp(dV./(Isp.*g0))-dead_mass;

totalMass = (propmass+dead_mass)*1.1; %Extra factor for extra ACS systems, etc.)




end

