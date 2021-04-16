%Uncomment the mass you want to look at
m = 463.274*1000 *1.06; % for Lunar from tons to kg
%m = 1065.121 * 1000 * 1.06 ; %For Leo from tons to kg

%Pick amount of tanks you are going to use and Max radius
rOx = 2.7;
tankNumberOx = 1;
tankNumberM = 1;
%Spliting Up mass
mOx = 3.55* m / 4.55;
mM = m/4.55;
%Total volume needed
vOxt = mOx/1141
vMt = mM/465
%If you have to split into multiple tanks
vOx = vOxt/tankNumberOx;
vM = vMt/tankNumberM;

%Figure out the tank dimensions
%Height Max is 6.5 + 2.2 = 8.7 for Falcon Heavy and 18 for starship
%Find height of cylinder and then total height with capped ends
hOxC = (vOx - (4/3*pi()*rOx^3))/ (pi()*rOx^2);
hOx = hOxC + 2*rOx
rM = rOx;
hMC = (vM - (4/3*pi()*rM^3))/ (pi()*rM^2);
hM = hMC + 2*rM
%Surface Area for Each
AOx = (4*pi()*rOx^2) + (2*pi()*rOx*hOxC);
AM = (4*pi()*rM^2) + (2*pi()*rM*hMC);

%% Thickness sizing LLO
%[LOX,CH4]
% Pressure Ox
R= 8.3145; %J/mK
M_Gas = [0.05 * mOx .05*mM]; %kg, 16% of total fuel now gas
Mw = [16 16.04]; %g/mol
n = [M_Gas(1) * 100 / Mw(1) M_Gas(2) * 100 / Mw(2)]; % Moles of Ox
Tb = [54.36,111.55]; %Boiling point of LOX,CH4
Vgas = (4/3)*pi()*rOx^3; %m^3
Pgas = [n(1) * R * Tb(1) / Vgas n(2) * R * Tb(1) / Vgas]; %PA

%Material
Fy = 608E6; %PA, aluminum yield tensile strength
Ftu = 700E6; %PA, ultimate tensile strength
fs = 1.25; %Factor of safety
Stress_allowable = min([Fy/1.1 Ftu/fs]); %maximum allowed working stress level
tc = [Pgas(1) * rOx / Stress_allowable Pgas(2) * rOx / Stress_allowable]
% Eal = 88.5E9; % Pa, youngs modulus
% Crit_Stress = -Eal*(9*(tc/rOx)^1.6 + 0.16*(tc/hOx)^1.3);
% Ox Cylindrical Tank dimensions
rhoAL2195 = 2685; %kg/m^3
rin = rOx;
rout = tc(1) + rin;
Vol_AL_OXCyl = pi * hOxC*(rout^2-rin^2);
massAL_OXCyl = rhoAL2195*Vol_AL_OXCyl;
VolOxCaps = (4/3)*pi()*(rout^3 - rin^3);
massAL_OXcaps = rhoAL2195*VolOxCaps;
MassOXTank = massAL_OXCyl+massAL_OXcaps
ExternalAreaOx = (4*pi*rout^2) + (2*pi*rout*hOxC)
routOx = rout
% CH4 Cylindrical Tank dimensions
rhoAL2195 = 2685; %kg/m^3
rin = rOx;
rout = tc(2) + rin;
Vol_AL_CH4Cyl = pi * hMC*(rout^2-rin^2);
massAL_CH4Cyl = rhoAL2195*Vol_AL_CH4Cyl;
VolCH4Caps = (4/3)*pi()*(rout^3 - rin^3);
massAL_CH4caps = rhoAL2195*VolCH4Caps;
MassCH4Tank = massAL_CH4Cyl+massAL_CH4caps
ExternalAreaM = (4*pi*rout^2) + (2*pi*rout*hMC)
%MLI Calculations
thicknessLayer = 2.286*10^-5;
layers = 60;
MassPerArea = .08;
thicknessMLI = thicknessLayer * layers;
%Area of outside of MLI per Tank
rMLIOx = routOx + thicknessMLI;
rMLIM = rout + thicknessMLI;
AreaMLIM = (4*pi()*rMLIM^2) + (2*pi()*rMLIM*hMC)
AreaMLIOx = (4*pi()*rMLIOx^2) + (2*pi()*rMLIOx*hOxC)

%Total Areas used for cost estimate that adds for each layer
TotalSurfaceAreaMLIM = 0;
TotalSurfaceAreaMLIOx = 0;
for i = 1:60
rMLIOx = routOx + thicknessLayer * i;
rMLIM = rout + thicknessLayer *i ;
AreaMLIM = (4*pi()*rMLIM^2) + (2*pi()*rMLIM*hMC);
AreaMLIOx = (4*pi()*rMLIOx^2) + (2*pi()*rMLIOx*hOxC);
TotalSurfaceAreaMLIM = TotalSurfaceAreaMLIM + AreaMLIM;
TotalSurfaceAreaMLIOx = TotalSurfaceAreaMLIOx + AreaMLIOx;
end
TotalSurfaceAreaSystem = TotalSurfaceAreaMLIOx * tankNumberOx +TotalSurfaceAreaMLIM * tankNumberM
%Mass of the MLI per Each tank
MassMliOxPerTank = TotalSurfaceAreaMLIOx * MassPerArea
MassMliCH4PerTank = TotalSurfaceAreaMLIM* MassPerArea
%Total Mass of Tank and MLI
MassOfEachTankWithMliOx = MassMliOxPerTank+ MassOXTank
MassofEachTankWithMliCH4 = MassMliCH4PerTank + MassCH4Tank
%Total Mass of System
totalMass = MassOfEachTankWithMliOx * tankNumberOx + MassofEachTankWithMliCH4 * tankNumberM