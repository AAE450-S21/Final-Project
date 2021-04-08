%% Introduction
% Author             Elijah Weinstein
% Team               Power and Thermal
% Date Completed     4/1/2021
% Purpose            Complete a thermal analysis of the 3 thermal
% systems that were considered through the span of this project.

% How it works       This code takes values from hand calculations
% performed outside of the code using equations X, X, and X from 
% the habitats section of the report and apendix then rescales the
% computed values for the final structure.

%% Initilize

modxD = 4.5                 ; % m
modxL = 13.3                ; % m
Ax    = modxD*pi*modxL      ; % m^2
Vint  = 540.2               ; % m^3
Dint  = 3.8*2               ; % m
L     = Vint/pi*4/Dint^2    ; % m
Dext  = Dint+.3             ; % m
Aext  = L*pi*Dext           ; % m^2
Ti    = 294                 ; % K
Td    = 393                 ; % K
Tn    = 120                 ; % K
Q1d   = 2.2*1000            ; % W
Q1n   = -1.7*1000           ; % W
Q2d   = .05*1000            ; % W
Q2n   = -.11*1000           ; % W
Q3d   = .08*1000            ; % W
Q3n   = -.17*1000           ; % W
Vair  = 16.2                ; % m^3
Lair  = 2.5                 ; % m
Rair  = (Vair/Lair/pi)^.5   ; % m
Aair  = 2*pi*Rair*Lair      ; % m^2

%% Case 1: No Regolith Layer

dtxd  = 294-358                 ; % K
dtxn  = 294-98                  ; % K
phid  = Q1d/Ax/(dtxd)*(Ti-Td)   ; % W/m^2
phin  = Q1n/Ax/(dtxn)*(Ti-Tn)   ; % W/m^2
Q1dr  = phid*Aext               ; % W
Q1nr  = phin*Aext               ; % W
Q1da  = phid*Aair               ; % W
Q1na  = phin*Aair               ; % W

fprintf('\nFor no regolith daytime Q is %.*f kW nighttime Q is %.*f kW', 3,Q1dr/1000, 3,Q1nr/1000)

%% Case 2: Regolith Layer Directly on Habitat

dtxd  = 294-374                         ; % K
dtxn  = 294-120                         ; % K
Dreg  = linspace(Dext+.2,Dext+8,2^8)    ; % m
rreg  = Dreg/2                          ; % m
rmod  = Dext/2                          ; % m
m1    = log(rreg/rmod)                  ; %
m2    = log((modxD/2+2)/(modxD/2))      ; %
phid  = Q2d/Ax/(dtxd)*(Ti-Td)./m1*m2    ; % W/m^2
phin  = Q2n/Ax/(dtxn)*(Ti-Tn)./m1*m2    ; % W/m^2
Q2dr  = phid*Aext                       ; % W
Q2nr  = phin*Aext                       ; % W
Q2da  = phid*Aair                       ; % W
Q2na  = phin*Aair                       ; % W
reg_thickness = rreg-rmod               ; % m

figure(1)
plot(reg_thickness,Q2dr/1000)
hold on
plot(reg_thickness,Q2da/1000,'-.b')
title('Regolith on Habitat')
xlabel('Regolith Thickness (m)')
ylabel('Daytime Heat Transfer (kW)')
grid on
yyaxis right
plot(reg_thickness,Q2nr/1000)
plot(reg_thickness,Q2na/1000)
ylabel('Nighttime Heat Transfer (kW)')
legend('Habitat Daytime','Airlock Daytime','Habitat Nighttime','Airlock Nighttime')

i = 1                            ;
while reg_thickness(i) < 1.165
    i = i+1                      ;
end

fprintf('\nFor regolith on habitat day time Q is %.*f kW night time Q is %.*f kW',3,Q2dr(i)/1000,3,Q2nr(i)/1000)
%% Case 3: Regolith Layer Seperated from Habitat

dtxd  = 294-374                         ; % K
dtxn  = 294-120                         ; % K
Dreg  = linspace(Dext+.5,Dext+8.3,2^8)  ; % m
rreg  = Dreg/2                          ; % m
rmod  = Dext/2                          ; % m
m1    = log(rreg/(rreg(1)-.03))         ; %
m2    = log((modxD/2+4)/(modxD/2+2-.03)); %
phid  = Q3d/Ax/(dtxd)*(Ti-Td)./m1*m2    ; % W/m^2
phin  = Q3n/Ax/(dtxn)*(Ti-Tn)./m1*m2    ; % W/m^2
Q3dr  = phid*Aext                       ; % W
Q3nr  = phin*Aext                       ; % W
Q3da  = phid*Aair                       ; % W
Q3na  = phin*Aair                       ; % W
reg_thickness = rreg-rmod               ; % m

figure(2)
hold on
plot(reg_thickness,Q3dr/1000)
plot(reg_thickness,Q3da/1000,'-.b')
title('Regolith Seperated from Habitat')
xlabel('Regolith Thickness (m)')
ylabel('Daytime Heat Transfer (kW)')
grid on
yyaxis right
plot(reg_thickness,Q3nr/1000)
plot(reg_thickness,Q3na/1000)
ylabel('Nighttime Heat Transfer (kW)')
legend('Habitat Daytime','Airlock Daytime','Habitat Nighttime','Airlock Nighttime')

j = 1                            ;
while reg_thickness(j) < 1.165
    j = j+1                      ;
end

fprintf('\nFor regolith seperated from habbitat day time Q is %.*f kW Night time Q is %.*f kW\n', 3,Q3dr(i)/1000, 3,Q3nr(i)/1000)
