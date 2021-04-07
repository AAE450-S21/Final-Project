%% EOL Initiallization 
EOL_comms = 2044.14;                    % End of Life power requirement for communications sat
EOL_obs = 5881;                         % End of Life power requirement for observation sat

%% BOL Calculation
BOL_comms = EOL_comms/((1-0.005)^15);   % Beginning of Life power requirment for comms sat
BOL_obs = EOL_obs/((1-0.005)^15);       % Beginning of Life power requirement for obs sat

%% Length and Width Calculation
total_area_comms = BOL_comms/300;       % Total solar array area for comms sat
total_area_obs = BOL_obs/300;           % Total solar array area for obs sat

per_array_comms = total_area_comms/2;   % Area of each solar array on comms sat
per_array_obs = total_area_obs/2;       % Area of each solar array on each obs sat

width_comms = sqrt(per_array_comms/3);  % Width of each solar array on comms sat
width_obs = sqrt(per_array_obs/3);      % Width of each solar array on obs sat

length_comms = width_comms*3;           % Length of each solar array on comms sat
length_obs = width_obs*3;               % Width of each solar array on obs sat

%% Output
fprintf('The BOL power requirement for the communications satellite is %f W', BOL_comms)
fprintf('\nThe BOL power requirement for the observation satellite is %f W', BOL_obs)
fprintf('\nThe solar arrays for the communications satellite are %f x %f meters each', width_comms, length_comms)
fprintf('\nThe solar arrays for the observation satellite are %f x %f meters each\n\n', width_obs, length_obs)