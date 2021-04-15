clear
clc

%% Initial Constants
g = 9.81; %m/s^2
dv_NASA = 2.500; %km/s
isp = 311; %s
mu = .04908*10^5; %km^3/s
r = 937.9; %km
z = 110; %km
th = -87; %degrees
m_lander = 10334; %kg
m_p = 8200; %kg
m_i = m_lander - m_p;

mpl_NASA = 2445 + 2376; %kg
mp_NASA = 8200; %kg


%% Landing Trajectory
vc = sqrt(mu/(r+z));
vsurf = (2*pi*r*cosd(th))/(24*60*60);
dv = vc - vsurf;

%% Mass Analysis
lam = m_p/(m_lander);

mpl = linspace(1000,8000,1000);

MR = (mpl + m_p + m_i)./(mpl + m_i);

MRr = exp(dv*1000/(g*isp));

m_pr = mpl.*(MRr-1)./(MRr-(MRr-1)/lam); %Required Prop Mass

m_tot_r = m_pr+m_i+mpl; %Total Mass
m_tot_NASA = mpl_NASA+mp_NASA+m_lander;

%% Constants For Graphs:
prop_tank = 8200; %kg, propellant capacity of the Apollo Lander
fh_moon = 15000; %kg, Falcon Heavy Payload to the moon

%% Graphs
figure()
plot(mpl, m_tot_r)
grid on
xlabel('Payload Mass, kg')
ylabel('Lander Mass, kg')
title('Total Lander Mass for Given Payload Mass')
yline(fh_moon,'r');
legend('Lander Mass', 'Falcon Heavy Lunar Payload')

figure()
plot(mpl, m_pr)
grid on
yline(prop_tank,'r');
xlabel('Payload Mass, kg')
ylabel('Propellant Mass, kg')
title('Required Propellant Mass for Given Payload Mass')
legend('Propellant Mass', 'Lunar Module Fuel Capacity')

