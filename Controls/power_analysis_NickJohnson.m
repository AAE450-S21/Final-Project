%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @Author Nick Johnson
% AAE450 Clearing Rover speed and power sizing
% Plots generated are analyzed in the final report
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rot = 50:10:200;    v = 0:0.005:0.06;    m = 585; V = 0.1; Rot = 120;
speed = zeros(length(v),length(rot));   A = 90; L = 1.5;

for i = 1:length(rot)
    speed(:,i) = rover_speed_NickJohnson(v,rot(i)); %columns = varying v, rows = varying rot
end
unrestricted_speed = rover_speed_NickJohnson(0.05,rot);
time = ((A/L)./unrestricted_speed).*1.2;       %1.2 for turning losses

[power,auger_pwr] = clearing_power_NickJohnson(m,rot);

varying_rot_P = power./1000;

figure(1)
for i = 1:length(rot)
    plot(v,speed(:,i),'DisplayName',num2str(rot(i)))
    hold on
end
title('Rover Clearing Travel Speed vs. Top Speed');
xlabel('Top Speed (m/s)'); ylabel('Clearing Travel Speed (m/s)')
grid on; legend;    
%Lines of varying auger rotation.  

figure(2) 
plot(rot,varying_rot_P,'DisplayName','Total Rover Power'); hold on;
plot(rot,auger_pwr./1000,'DisplayName','Auger Power');
grid on; legend; xlabel('Auger Rotation (RPM)');
ylabel('Total Rover Power (kW)'); title('Power vs. Auger Speed');
% using speed allowed by auger, power requirements are already high.
% Thus, more evidence to limit top speed below what auger
% allows.  

figure(3)
for i = 1:length(rot)
    plot(rot,time,'DisplayName',num2str(rot(i)))
    hold on
end
grid on; title('Clearing Time vs. Auger Rotation'); xlabel('Auger Rotation (RPM)');
ylabel('Clearing Time (s)');
% This shows that auger speed has diminishing returns thus, limiting auger
% speed will not significantly impact clearing efficiency but will help
% more with power.

figure(4)
plot(rot,auger_pwr./1000); grid on; title('Auger Power vs. Auger Rotation')
xlabel('Auger Rotation (RPM)'); ylabel('Auger Power');
