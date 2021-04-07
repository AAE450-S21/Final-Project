%% EOL Initiallization
EOL_LEO = 4800; % End of Life power requirement for LEO depot
EOL_LLO = 2400; % End of Life power requirement for LLO depot

%% BOL Calculation
BOL_LEO = EOL_LEO/((1-0.005)^14); % Beginning of Life power requirement for LEO depot
BOL_LLO = EOL_LLO/((1-0.005)^14); % Beginning of Life power requirement for LLO depot

%% Length and Width Calculation
total_area_LEO = BOL_LEO/300; % Total solar array area for LEO depot
total_area_LLO = BOL_LLO/300; % Total solar array area for LLO depot

per_array_LEO = total_area_LEO/2; % Area of each solar array on LEO depot
per_array_LLO = total_area_LLO/2; % Area of each solar array on LLO depot

width_LEO = sqrt(per_array_LEO/3); % Width of each solar array on LEO depot
width_LLO = sqrt(per_array_LLO/3); % Width of each solar array on LLO depot

length_LEO = width_LEO*3; % Length of each solar array on LEO depot
length_LLO = width_LLO*3; % Length of each solar array on LLO depot

%% Output
fprintf('\nThe BOL power requirement for the LEO propellant depot is %f W', BOL_LEO)
fprintf('\nThe BOL power requirement for the LLO propellant depot is %f W', BOL_LLO)
fprintf('\nThe solar arrays for the LEO propellant depot are %f x %f meters each', width_LEO, length_LEO)
fprintf('\nThe solar arrays for the LLO propellant depot are %f x %f meters each\n\n', width_LLO, length_LLO)