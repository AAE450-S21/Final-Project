%%
% Cardano, Roberto               
% AAE450 Attitude Dynamics Program Description: This program is utilized to determine the precession and nutation angles of an axis-symmetric body that is modeled after a cuboid satellite. Assuming this rigid body is fixed about an axis, a cuboid is utilized to determine the inertia dyadic of the rotations. This will take under consideration the perturbation forces the cuboid experiences according to the input total disturbance torque of the program. This disturbance torque is comprised of the maximum gravity gradient due to the earth and moon, alongside the solar radiation pressure torque as well. The model itself is based on the Body-Two 1-3-1 angle sequence so that the dynamics may be analyzed and calculated. Next, in order to understand the perturbations, example numbers are input at a "certain instant" for the initial conditions. These initial conditions include arbitrary angular velocities, initial Euler parameters, constraint K to check the feasibility of the Euler parameter computations, and the total disturbance torque. To make the body perturbed the "certain instant" will be analyzed with respect to a Space 2-3-1 angles and Body 1-3-1, this allows the script to depict how the torque is affecting a satellite in motion. Using DCM construction and Euler parameters the orientations and perturbations of the satellite can be better understood applying their equations of motions to determine nutation and precession angle reactions to torque. This model can be implemented to suggest control models/parameters to offset unwanted perturbations while in orbit.
%%
clear
clc

%Observations Satellite Inputs
%The numbers provided below were calculated by other observation satellites
%team members within AAE450, these numbers were inputted to make this
%analysis possible.

%m = 287.1; %kg, dry mass % mdrycont = 344.6; %kg, dry mass with 20% overshoot contingency % mwet = 371.0; %kg, wet mass % mwetcont = 445.2; %kg, wet mass with 20% overshoot contingency
%h = 1.1; %meters, height of cuboid model
%w = 1.7; %meters, width of cuboid model
%d = 1.5; %meters, depth/length of cuboid model

%At first, contingency weights were going to be inputted for multiple simulations, but the overall scope
%project changed, so the model only took into account the dry mass estimate
%for the observations satellite (other masses can be input)

%Calculations for inertia matrix and mass considerations
%Il = (m * (h^2*w^2 + w^2*d^2 + d^2*h^2))/(6 * (h^2 + w^2 + d^2)); %moment of inertia of a solid cuboid (axis of rotation at longest diagonal)
%Id = 1/12 * m * (h^2 + w^2); %moment of inertia of a solid cuboid (axis of rotation at the depth)
%Iw = 1/12 * m * (h^2 + d^2); %moment of inertia of a solid cuboid (axis of rotation at the width)

%Moment of inertia matrix for given mass, includes [inertia longest
%diagonal, inertia depth, and inertia width]
%Idry =  [95.87 0 0; 0 98.1 0; 0 0 82.78]; %kgm^2
%Idrycon = [115.06 0 0; 0 117.74 0; 0 0 99.36]; %kgm^2
%Iwet =    [123.88 0 0; 0 126.76 0; 0 0 106.97]; %kgm^2
%Iwetcon = [148.66 0 0; 0 152.1 0; 0 0 128.37]; %kgm^2

%Initialization
% Given (Simplified Cuboid Model Inertias)
I = 95.87; %kgm^2, inertia along the longest diagonal (dry mass inertia)
J = 98.1;  %kgm^2, inertia along depth of cuboid (dry mass inertia)
W1_0 = 2;     %rad/s, initial arbitrary angular velocity the cuboid satellite in n1-direction 
W2_0 = -1;    %rad/s, initial arbitrary angular velocity the cuboid satellite in n2-direction
W3_0 = 1;     %rad/s, initial arbitrary angular velocity the cuboid satellite in n3-direction
E1_0 = 0;     %quaternion initial conditions (Euler parameters)
E2_0 = 0;     %quaternion initial conditions (Euler parameters)
E3_0 = 0;     %quaternion initial conditions (Euler parameters)
E4_0 = 1;     %quaternion initial conditions (Euler parameters)
K0 = 1;       %constant constraint checking value for Euler parameters
M = 0.318445; %Nm, calculated total torque acting on the observations satellite (includes maximum gravity gradient torque due to the earth/moon, and solar radiation pressure torque all tabulated within the reaction wheel environment analysis.

%Calculations of precession, nutation, and spin angle
%Assuming an ideal cuboid, axis-symmetric satellite, next the program takes tabulated inertia dyadic to perform DCM Construction, EOMs derived according to Body and Space angles, Euler Parameters solutions for given problem
%EOM
time = 0:0.2:30;
options = odeset('RelTol',1e-3,'AbsTol',1e-3);
initial = [W1_0 W2_0 W3_0 E1_0 E2_0 E3_0 E4_0]';
[~, output] = ode45(@EOM, time, initial, options);
W1 = output(:,1);
W2 = output(:,2);
W3 = output(:,3);
E1 = output(:,4);
E2 = output(:,5);
E3 = output(:,6);
E4 = output(:,7);
K = sqrt(E1.^2 + E2.^2 + E3.^2 + E4.^2);

% DCM Construction, Using quaternion method the program calculates the
% appropriate Euler Parameters for the rotation according to angular
% velocity parameters
E = [E1 E2 E3];
C11 = 1-2*E(:,2).^2- 2*E(:,3).^2;
C12 = 2*(E(:,1).*E(:,2) - E(:,3).*E4);
C13 = 2*(E(:,3).*E(:,1) + E(:,2).*E4);
C21 = 2*(E(:,1).*E(:,2) + E(:,3).*E4);
C22 = 1 - 2*E(:,3).^2 - 2*E(:,1).^2;
C23 = 2*(E(:,2).*E(:,3) - E(:,1).*E4);
C31 = 2*(E(:,3).*E(:,1) - E(:,2).*E4);
C32 = 2.*(E(:,2).*E(:,3) + E(:,1).*E4);
C33 = 1 - 2*E(:,1).^2 - 2*E(:,2).^2;

%Implementing the rotation matrix found and Euler parameters, now the
%precession, nutation, and spin angle can be calculated
% Angle Calculations
%Nutation
Nutation = acosd(C11);

%Precession (two formulas are used to provide correct quadrant for angles)
Precesion = acosd((C21 ./ sind(Nutation)));
C31test = sind(Precesion).*sind(Nutation);
%while loop is implemented to perform quadrant checks for precession angle
%calculations
k = 1;
while k < 151
    if sign(C31test(k)) ~= sign(C31(k))
        Precesion(k) = -1* Precesion(k);
    else
    end
    k = k+1;
end

%Spin (two formulas are used to provide correct quadrant for angles)
Spin = asind(C13 ./ sind(Nutation));
C13test = sind(Nutation).*sind(Spin);
k = 1;
%while loop is implemented to perform quadrant checks for spin angle
%calculations
while k < 151
    if sign(C13test(k)) ~= sign(C13(k))
        Spin(k) = 180 - Spin(k);
    else
    end
    k = k+1;
end

%Check whether outputted numbers are feasible
%angle1 = atand(C31(mark1)./ C21(mark1));
%(Precesion(mark1)); numbers match, reason for commenting

%C31^2 + C21^2 : Calculations to yield nutation angle from precession
%analysis, important way to check whether analysis makes physical sense and
%numbers match
%h_1 = sqrt(C21(mark1).^2 + C31(mark1).^2);
%Check whether outputted numbers are feasible
%gamma1 = asind(h_1);
%Nutation(mark1);

%Plots of precession, nutation, and spin angle
%Plots
figure(1)
plot(time, Precesion)
title('Precesion \phi vs. Time')
xlabel('Time (Seconds)')
ylabel('Precesion \phi (Degrees)')

figure(2)
plot(time, Nutation)
title('Nutation \kappa vs. Time')
xlabel('Time (Seconds)')
ylabel('Nutation \kappa (Degrees)')

figure(3)
plot(time, Nutation)
hold on
plot(time, Precesion)
xlabel('time (seconds)')
ylabel('Angle (degrees)')
title('Precession(\phi) & Nutation(\kappa) vs Time')
grid on
legend('Nutation \kappa', 'Precession \phi')

%In order to check how feasible the solution is the Euler parameters are
%graphed and do not exceed 1 or -1 which follows the mathematical
%constraint the quarternions have to meet in order to not have any
%singularities occur (E1^2 + E2^2 + E3^2 + E4^2)^.5
figure(4)
plot(time, E1, time, E2, time, E3, time, E4)
title('Euler Parameters VS Time')
xlabel('Time (seconds)')
ylabel('Euler Parameters (unitless)')
legend('\epsilon_1', '\epsilon_2', '\epsilon_3', '\epsilon_4')

%Plots 21-31 matrix coordinates to determine spin orientation, and depicts
%how the satellite is rotating according to its direction cosine matrix.
%This allows for understanding how the body moves along the axes being
%taken into account.
figure(5)
plot(C21, C31)
hold on
title('C31 vs C21')
xlabel('C21')
ylabel('C31')
mark1 = find(time == 10);
plot(C21(mark1), C31(mark1),  '.', 'MarkerSize', 30)

%Plots the angular velocities tabulated throughout the analysis to depict
% at what velocities the perturbations are happening to the cuboid model
% satellite
figure(6)
plot(time, rad2deg(W1), time, rad2deg(W2), time, rad2deg(W3))
title("Angular Velocity vs time")
xlabel('Time (seconds)')
ylabel('Angular Velocity \omega (rad/s)')
legend('W1', 'W2', 'W3')
axis([0 20 -90 150])

%Next, the script is testing different torques to comprehend how the
%attitude shifts according to the nutation angle being altered, when
%nutation angle is utilized for this analysis ADD

% Zero-Torque simulation of nutation and precession angle analysis 
[~, output] = ode45(@EOM2, time, initial, options);
E1 = output(:,4);
E2 = output(:,5);
E3 = output(:,6);
E = [E1 E2 E3];
C11 = 1-2*E(:,2).^2- 2*E(:,3).^2;
C21 = 2*(E(:,1).*E(:,2) + E(:,3).*E4);
C31 = 2*(E(:,3).*E(:,1) - E(:,2).*E4);
Nutation = acosd(C11);
Precesion = acosd((C21 ./ sind(Nutation)));
C31test = sind(Precesion).*sind(Nutation);
%while loop is implemented to perform quadrant checks for precession angle
%calculations
k = 1;
while k < 151
    if sign(C31test(k)) ~= sign(C31(k))
        Precesion(k) = -1* Precesion(k);
    else
    end
    k = k+1;
end

%Plotting Zero Torque Nutation/Precession Angle
figure
plot(time, Nutation)
title('Nutation \kappa vs Time @ T = 0mN-m') 
xlabel('Time (seconds)')
ylabel('Nutation \kappa (degrees)')

figure
plot(time, Precesion)
title('Precession \phi vs Time @ T = 0mN-m') 
xlabel('Time (seconds)')
ylabel('Precession \phi (degrees)')
axis([0 30 -200 250])

% Observations Satellite Torque simulation of nutation and precession angle analysis
[~, output] = ode45(@EOM3, time, initial, options);
E1 = output(:,4);
E2 = output(:,5);
E3 = output(:,6);
E = [E1 E2 E3];
C11 = 1-2*E(:,2).^2- 2*E(:,3).^2;
Nutation = acosd(C11);
Precesion = acosd((C21 ./ sind(Nutation)));
C31test = sind(Precesion).*sind(Nutation);
%while loop is implemented to perform quadrant checks for precession angle
%calculations
k = 1;
while k < 151
    if sign(C31test(k)) ~= sign(C31(k))
        Precesion(k) = -1* Precesion(k);
    else
    end
    k = k+1;
end

%Plotting tabulated Torque on observations satellite nutation and precession Angle. This
%graph is taking into account the calculated solar radiation pressure
%torque, the maximum gravity gradient torque due to the moon and earth
figure
plot(time, Nutation)
title('Nutation \kappa vs Time @ T = 318.445mN-m')
xlabel('Time (seconds)')
ylabel('Nutation \kappa (degrees)')

figure
plot(time, Precesion)
title('Precession \phi vs Time @ T = 318.445mN-m') 
xlabel('Time (seconds)')
ylabel('Precession \phi(degrees)')
axis([0 30 -200 250])

% Torque exceeding momentum storage simulation of nutation & precession angle
% analysis. This plot is implemented as an upper limit to depict how the
% attitude of the cuboid can go out of control when the torque exceeds the
% limits of the spacecraft
[~, output] = ode45(@EOM4, time, initial, options);
E1 = output(:,4);
E2 = output(:,5);
E3 = output(:,6);
E = [E1 E2 E3];
C11 = 1-2*E(:,2).^2- 2*E(:,3).^2;
Nutation = acosd(C11);
Precesion = acosd((C21 ./ sind(Nutation)));
C31test = sind(Precesion).*sind(Nutation);
%while loop is implemented to perform quadrant checks for precession angle
%calculations
k = 1;
while k < 151
    if sign(C31test(k)) ~= sign(C31(k))
        Precesion(k) = -1* Precesion(k);
    else
    end
    k = k+1;
end

figure
plot(time, Nutation)
title('Nutation \kappa vs Time @ T = 500mN-m')
xlabel('Time (seconds)')
ylabel('Nutation \kappa (degrees)')

figure
plot(time, Precesion)
title('Precesion \phi vs Time @ T = 500mN-m') 
xlabel('Time (seconds)')
ylabel('Precession \phi (degrees)')
axis([0 30 -200 250])

% Functions of EOMs according to Body-Two 1-3-1 & Space-Two 2-3-1, with
% inputted torque values in order to graph effects of torque on the
% nutation and precession angles.
function xdot = EOM(~, x)
M = 0.318445;
xdot(1) = 0;
xdot(2) = 0.6*x(1)*x(3);
xdot(3) = (45/400) - 0.6*x(1)*x(2);
xdot(4) = 1/2*(x(1)*x(7) - x(2)*x(6) + x(3)*x(5));
xdot(5) = 1/2*(x(1)*x(6) + x(2)*x(7) - x(3)*x(4));
xdot(6) = 1/2*(-x(1)*x(5) + x(2)*x(4) + x(3)*x(7));
xdot(7) = -1/2*(x(1)*x(4) + x(2)*x(5) + x(3)*x(6));
xdot = xdot';
end

function xdot = EOM2(~, x)
M = 0;
xdot(1) = 0;
xdot(2) = 0.6*x(1)*x(3);
xdot(3) = (M/400) - 0.6*x(1)*x(2);
xdot(4) = 1/2*(x(1)*x(7) - x(2)*x(6) + x(3)*x(5));
xdot(5) = 1/2*(x(1)*x(6) + x(2)*x(7) - x(3)*x(4));
xdot(6) = 1/2*(-x(1)*x(5) + x(2)*x(4) + x(3)*x(7));
xdot(7) = -1/2*(x(1)*x(4) + x(2)*x(5) + x(3)*x(6));
xdot = xdot';
end

function xdot = EOM3(~, x)
M = 318.445;
xdot(1) = 0;
xdot(2) = 0.6*x(1)*x(3);
xdot(3) = (M/400) - 0.6*x(1)*x(2);
xdot(4) = 1/2*(x(1)*x(7) - x(2)*x(6) + x(3)*x(5));
xdot(5) = 1/2*(x(1)*x(6) + x(2)*x(7) - x(3)*x(4));
xdot(6) = 1/2*(-x(1)*x(5) + x(2)*x(4) + x(3)*x(7));
xdot(7) = -1/2*(x(1)*x(4) + x(2)*x(5) + x(3)*x(6));
xdot = xdot';
end

function xdot = EOM4(~, x)
M = 500;
xdot(1) = 0;
xdot(2) = 0.6*x(1)*x(3);
xdot(3) = (M/400) - 0.6*x(1)*x(2);
xdot(4) = 1/2*(x(1)*x(7) - x(2)*x(6) + x(3)*x(5));
xdot(5) = 1/2*(x(1)*x(6) + x(2)*x(7) - x(3)*x(4));
xdot(6) = 1/2*(-x(1)*x(5) + x(2)*x(4) + x(3)*x(7));
xdot(7) = -1/2*(x(1)*x(4) + x(2)*x(5) + x(3)*x(6));
xdot = xdot';
end