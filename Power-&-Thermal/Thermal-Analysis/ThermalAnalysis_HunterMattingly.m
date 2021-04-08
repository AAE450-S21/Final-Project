%% Inputs
% Tubing
diam = .0125;           % Tube diameter in m
area = pi*(diam/2)^2;   % Inner tube cross section area in m^2
thick = .00125;         % Tube thickness in m
tub_k = 385;            % Copper tubing thermal conductivity in W/m*K
rr = .0015/1000;        % Copper roughness coefficient
tub_rho = 8900;         % Copper tubing density in kg/m^3

len_hxhx = 5;   % Tube length from IFHX to CHX in m
len_hxcp = 10;  % Tube length from CHX to cold plates in m
len_cppa = 10;  % Tube length from cold plates to pump assembly in m
len_pahx = 2;   % Tube length from pump assembly to IFHX in m
len_hxrd = 2;   % Tube length from IFHX to radiators in m
len_rdpa = 2;   % Tube length from radiators to pump assembly in m

% Cold Plate
len_cp = 4;     % Tube length per cold plate in m
area_cp = .5;   % Average cold plate area in m^2
thick_cp = .01; % Average cold plate thickness in m
rho_cp = 2700;  % Density of aluminum cold plates in kg/m^3
k=4;            % Number of cold plates

% Radiators
len_rad = 8;            % Tube length per radiator in m
rad_rho = 50;           % Aluminum radiator density in kg/m^3
rad_em = .94;           % Radiator white paint (Z-93) coating emmissivity
rad_al = .15;           % Radiator white paint (Z-93) coating absorptivity
Gs = 1418;              % Solar flux in W/m^2
theta = linspace(0,180,360); % Angle of incidence
SBc = 5.67e-8;          % Stefan-Bolzmann's Constant in W/(m^2-K^4)

% IFHX 
Te_in = 273+15;                  % IFHX Inlet temperature in K
len_ifhx = .5*17;                 % IFHX internal tube length in m
IFHX_a = (len_ifhx)*(2*pi*((diam/2)+thick)); % IFHX heat transfer surface area in m^2

% CHX  
len_chx = 2;    % CHX internal tube length in m

% Fluid Specifications
%{
cp_i = 3722;                % Specific heat of 40/60 PGW at 25C in J/(kgK)
bp_i = (5/9)*(219-32)+273;  % Boiling point of 40/60 PGW in K
fp_i = 251;                 % Freezing point of 40/60 PGW in K
rho_i = 1030;               % Density of 40/60 PGW at 25C in kg/m^3
dvis_i = 3.77/1000;         % Dynamic viscosity of 40/60 PGW at 25C in Pa*s
kvis_i = dvis_i/rho_i;      % Kinematic viscosity of 40/60 PGW at 25C in m^2/s
k_i = .403;                 % Thermal conductivity of 40/60 PGW at 25C in W/(m*K)
alp_i = k_i/(rho_i*cp_i);   % Thermal diffusivity of 40/60 PGW at 25C
%}

% Water
cp_i = 4179;                % Specific heat of water at 25C in J/(kgK)
bp_i = 373;                 % Boiling point of water in K
fp_i = 273;                 % Freezing point of water in K
rho_i = 997;                % Density of water at 25C in kg/m^3
dvis_i = .847/1000;         % Dynamic viscosity of water at 25C in Pa*s
kvis_i = dvis_i/rho_i;      % Kinematic viscosity of water at 25C in m^2/s
k_i = .598;                 % Thermal conductivity of water at 25C in W/(m*K)
alp_i = k_i/(rho_i*cp_i);   % Thermal diffusivity of water at 25C

% ammonia
cp_e = 4740;                % Specific heat of ammonia at 25C in J/(kgK)
bp_e = -33.3+273;           % Boiling point of ammonia in K
fp_e = -77.7+273;           % Freezing point of ammonia in K
rho_e = 609;                % Density of ammonia at 25C in kg/m^3
dvis_e = .138/1000;         % Dynamic viscosity of ammonia at 25C in Pa*s
kvis_e = dvis_e/rho_e;      % Kinematic viscosity of ammonia at 25C in m^2/s
k_e = .521;                 % Thermal conductivity of ammonia at 25C in W/(m*K)
alp_e = k_e/(rho_e*cp_e);   % Thermal diffusivity of ammonia at 25C

%{
% hfe
cp_e = 1220;                % Specific heat of HFE-7200 at 25C in J/(kgK)
bp_e = 349;                 % Boiling point of HFE-7200 in K
fp_e = 135;                 % Freezing point of HFE-7200 in K
rho_e = 1420;               % Density of HFE-7200 at 25C in kg/m^3
dvis_e = .58/1000;          % Dynamic viscosity of HFE-7200 at 25C in Pa*s
kvis_e = dvis_e/rho_e;      % Kinematic viscosity of HFE-7200 at 25C in m^2/s
k_e = .068;                 % Thermal conductivity of HFE-7200 at 25C in W/(m*K)
alp_e = k_e/(rho_e*cp_e);   % Thermal diffusivity of HFE-7200 at 25C
%}

% Pumps
m_doti = .15;   % Mass flow rate of internal fluid in kg/s
m_dote = .15;   % Mass flow rate of external fluid in kg/s
np = .75;       % Pump efficiency

% Totals
len_i = len_hxhx+len_hxcp+len_cppa+len_pahx+len_chx+len_ifhx+(k*len_cp);
len_e = len_hxrd+len_rdpa+len_pahx+(len_rad*4);
Q = linspace(0,12500);

%% Analysis
vel_i = m_doti/(rho_i*area);        % Average internal flow velocity in m/s
Re_i = (rho_i*vel_i*diam)/dvis_i;   % Reynolds number of internal fluid,  <~3000 for laminar flow
Pr_i = kvis_i/alp_i;                % Prandtl Number of internal fluid

vel_e = m_dote/(rho_e*area);        % Average external flow velocity in m/s
Re_e = (rho_e*vel_e*diam)/dvis_i;   % Reynolds number of external fluid, <~3000 for laminar flow
Pr_e = kvis_e/alp_e;                % Prandtl Number of external fluid

if Re_i <= 4000 
    f_i = 64/Re_i;  % Friction factor 
    Nu_i = 4.364;   % Nusselt number for uniform heat flux at tube wall for circular CS
elseif (4000 < Re_i) && (Re_i <= 20000)
    f_i = .079/(Re_i^.25);
    Nu_i = Re_i*(f_i/8)* Pr_i^(1/3);
else
    f_i = .184/(Re_i^.2);
    Nu_i = Re_i*(f_i/8)* Pr_i^(1/3);
end

if Re_e <= 4000 
    f_e = 64/Re_e;  % Friction factor 
    Nu_e = 4.364;   % Nusselt number for uniform heat flux at tube wall for circular CS
elseif (4000 < Re_e) && (Re_e <= 20000)
    f_e = .079/(Re_e^.25);
    Nu_e = Re_e*(f_e/8)* Pr_e^(1/3);
else
    f_e = .184/(Re_e^.2);
    Nu_e = Re_e*(f_e/8)* Pr_e^(1/3);
end

% Pump Power
hl_maji = f_i*(len_i/diam)*(.5*vel_i.^2); % Major head loss in m^2/s^2
hl_mini = 100*f_i*30*(.5*vel_i.^2);       % Minor head loss in m^2/s^2
hl_ti = hl_maji + hl_mini;                % Total head loss in m^2/s^2
hl_maje = f_e*(len_e/diam)*(.5*vel_e^2);  % Major external head loss in m^2/s^2
hl_mine = 100*f_e*30*(.5*vel_e^2);        % Minor external head loss in m^2/s^2
hl_te = hl_maje + hl_mine;                % Total external head loss in m^2/s^2

del_Pi = rho_i*hl_ti;                 % Internal pressure drop in Pa
del_Pe = rho_e*hl_te;                 % External pressure drop in Pa
pow_pi = (del_Pi*m_doti)/(rho_i*np)  % Internal pump power in W
pow_pe = (del_Pe*m_dote)/(rho_e*np)  % External pump power in W

% Heater Power
pow_sh = 45*2*8;   % Total shell heater power in W assuming 8 modules
pow_rh = 25*7*8;    % Total radiator heater power in W assuming 7 panels and 8 modules
pow_fh = 5*4*8;     % Total fluid line heater power in W assuming 8 modules

% Heat Load 
htc_i = (Nu_i*k_i)/diam;    % Heat transfer constant for internal fluid
htc_e = (Nu_e*k_e)/diam;    % Heat transfer constant for external fluid
U = 1/((1/htc_e)+(thick/tub_k)+(1/htc_i)) % Overall heat transfer coefficient in IFHX, needs refining
%ri=(diam/2);
%ro=(diam/2)+thick;
%U1 = (1/IFHX_a);
%U2 = 1/(htc_i*pi*diam*len_ifhx)+log((diam+2*thick)/diam)/(2*pi*tub_k*.5)+(1/(htc_e*IFHX_a));
%Uo=U1/U2;
C_i = m_doti*cp_i;       % Internal fluid heat capacitance
C_e = m_dote*cp_e;       % External fluid heat capacitance
Cmax = max(C_i,C_e);     % Max C
Cmin = min(C_i,C_e);     % Min C
C = Cmin/Cmax;           % Ratio of min to max C
NTU = (U*IFHX_a)/(Cmin); % Heat exchanger size factor
eff = 2*(1+C+((1+exp(-NTU*(1+C^2)^(1/2)))/(1-exp(-NTU*(1+C^2)^(1/2))))*(1+C^2)^(1/2))^(-1); % Effectiveness for shell-and-tube (one shell pass; 1 tube passe) heat exchanger
%eff = (1-exp(-NTU*(1-C)))/(1-C*exp(-NTU*(1-C))); % Effectiveness of counterflow heat exhanger

Te_out = Te_in+(Q/C_e);                % Temperature of the external fluid leaving the IFHX
Ti_in = Te_in+(Q/(eff*Cmin));          % Temperature of the internal fluid entering the IFHX
Ti_out = Te_in+(Q/(eff*Cmin))-(Q/C_i); % Temperature of the internal fluid leaving the IFHX

%% External Loop Analysis
Temax = 300;    % Temperature of the outer loop at max heat load in K
Qmax = 16000;  % Max heat load in W
rad_area = -Qmax./(Gs*rad_al*cosd(theta)-SBc*rad_em*Temax^4); % Radiator area needed to support max heat load with varying incidence angles

%% Volume, Mass, and Cost Calculations
% Radiators
rad_num = max(rad_area)/(17.44);    % Number of radiators per module based on ISS radiator sizing, not important
rad_v = max(rad_area)*(1.7/100);    % Total radiator panel volume in m^3
rad_m = rad_v*rad_rho;              % Total radiator mass in kg

% Piping
tub_vi = len_i*((pi*((diam/2)+thick)^2)-(pi*(diam/2)^2));    % Internal tubing total volume in m^3
tub_ve = len_e*((pi*((diam/2)+thick)^2)-(pi*(diam/2)^2));    % External tubing total volume in m^3
tub_m = (tub_vi+tub_ve)*tub_rho;    % Total tubing mass in kg

% Fluid
tub_vie = len_i*(pi*(diam/2)^2);    % Empty internal tubing total volume in m^3
tub_vee = len_e*(pi*(diam/2)^2);    % Empty external tubing total volume in m^3
ifl_m = tub_vie*rho_i;              % Total internal fluid mass in kg
efl_m = tub_vee*rho_e;              % Total external fluid mass in kg
fl_m = ifl_m+efl_m;                 % Total internal fluid mass in kg

% Cold Plates
vol_cp = area_cp*thick_cp;  % Volume of individual cold plate in m^3
vol_cp = vol_cp*k;          % Total volume of cold plates in m^3
cp_m = vol_cp*rho_cp;       % Total mass of cold plates in kg

% Heat Exchangers
ifhx_m = 5;         % IFHX mass estimation in kg
chx_m = 4;          % CHX mass estimation in kg
ifhx_v = .5*.5*1;   % IFHX volume estimation in m^3
chx_v = .5*.5*.5;   % CHX volume estimation in m^3

% Pump Assembly
pai_m = 3;          % Internal pump assembly mass estimation in kg
pae_m = 3;          % External pump assembly mass estimation in kg
pa_m = pae_m+pai_m; % Total pump assembly mass estimation in kg

% Total Mass
atcs_m = 2*(tub_m+fl_m+ifhx_m+chx_m+pa_m)+cp_m+rad_m;   % Total mass in kg including redundant system per module
atcs_total_m = 8*atcs_m                                 % Total mass of ATCS in kg assuming 8 modules

% Total Volume
atcs_v = 2*(tub_ve+tub_vie+tub_vee+ifhx_v+chx_v)+vol_cp+rad_v;  % Total volume in m^3 including redundant system per module
atcs_total_v = 8*atcs_v                                        % Total volume of ATCS in m^3 assuming 8 modules

% Total Power
pow_sc = (pow_pi*2*8)+(pow_pe*2*8)+pow_fh  % Safety critical power of ATCS in W assuming 8 modules
pow_con = pow_sh+pow_rh                    % Contingency power of ATCS in W assuming 8 modules

% Total Cost
atcs_launchcost = atcs_total_m*8750;        % Launch cost assuming the use of Starship and 8 modules
atcs_prodcost =  2*(atcs_total_m*8750);     % Approximated production cost of assuming 8 modules
atcs_cost = atcs_launchcost+atcs_prodcost   % Total cost of ATCS in $

%% Plots
figure(1)
plot(Q*2,Ti_in,'k-','LineWidth', 2)
hold on
plot(Q,Ti_in,'b-','LineWidth', 2)
yline(bp_i,'--','Water Boiling Point');
yline(bp_i-10,'--', 'Max Water Op Temp');
title('Comparing Heat Load and Internal Fluid Temp')
xlabel('Heat Load [W]')
ylabel('Internal Inlet Temp [K]')
grid on
legend('Nominal Loop Rejection','Faulted Loop Rejection')

%{
figure(2)
plot(Q,Ti_out)
yline(bp_i,'--','Water Boiling Point');
yline(bp_i-10,'--', 'Max Water Op Temp');
title('Comparing Heat Load and Internal Fluid Temp')
xlabel('Heat Load [W]')
ylabel('Internal Exit Temp [K]')
grid on

figure(3)
plot(Q,Te_out)
yline(bp_i-10,'--', 'Max Water Op Temp');
grid on
%}
figure(4)
plot(theta, rad_area,'LineWidth',2)
title('Radiator Sizing')
xlabel('Solar Incidence Angle [deg]')
ylabel('Radiator Area Needed for Max Heat Load [m^2]')
grid on