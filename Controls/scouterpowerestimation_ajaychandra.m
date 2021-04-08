%% define constants
m = 467.995;%551.47; %kg, total scouting rover mass
g = 1.62; %m/sec2, gravitational acceleration on lunar surface
c = 0.2; % rolling resistance of tires on lunar dust
batt_capacity = 6; %kWh, battery capacity
r_wheel = 0.29; %m, radius of wheel

spd = [0.02:0.001:0.8]; %m/sec rover speed
resistive_pwr = 4.*((m .*g .*c ./r_wheel) .* spd)./(1000.*0.84); %rover s


%% Instrument Power Consumption Value in kW
p_spectrometer = 0.75; %spectrometer
p_LiDAR = 0.0179; %LiDAR imager
p_GPR = 0.01; %Ground Penetrating Radar
p_cam = 0.0179;
% Commented out since these will not be used while the rover is at higher
% speeds. Uncomment each line as required to view impact of each equipment
%p_drill = 0.01;
%p_arm = 1;
%p_batt_cool = 0.1;

t_p = resistive_pwr + p_spectrometer + p_LiDAR...
    + p_GPR + p_cam;% + p_drill + p_arm + p_batt_cool;

endurance = batt_capacity./(resistive_pwr + p_spectrometer + p_LiDAR...
    + p_GPR + p_cam);% + p_drill + p_arm + p_batt_cool); % hours, endurance
R = (endurance) .* (spd.*0.001.*3600) .*0.5; %km, range

figure(1);
plot(spd,resistive_pwr);
xlabel('Top speed (m/sec)')
ylabel('Power Required (kW)');
title('Power Consumption as a function of Rover Speed - Ajay Chandra');
xlim([spd(1) spd(end)])
grid on;

figure(2);
plot(spd,endurance);
xlabel('Top speed (m/sec)')
ylabel('Battery Life (h)');
title('Endurance as a function of Rover Speed - Ajay Chandra');
grid on;
xlim([spd(1) spd(end)])
figure(3);
plot(spd,R);
xlabel('Top Speed (m/sec)');
ylabel('Range (m)');
title('Maximum Distance Traversable from base as a function of top speed - Ajay Chandra');
grid on;
xlim([spd(1) spd(end)])
