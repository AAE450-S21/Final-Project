%% EOL Initiallization
EOL_STAR = 783.6; % End of Life power requirement for STAR
EOL_CAP = 1000; % End of Life power requirement for CAP
EOL_SWAG = 1000; % End of Life power requirement for SWAG
EOL_BTB = 25620; % End of Life power requirement for BTB

%% BOL Calculation
BOL_STAR = EOL_STAR / ((1-0.005)^15); % Beginning of Life power requirement for STAR
BOL_CAP = EOL_CAP / ((1-0.005)^15); % Beginning of Life power requirment for CAP
BOL_SWAG = EOL_SWAG / ((1-0.005)^15); % Beginning of Life power requirement for SWAG
BOL_BTB = EOL_BTB / ((1-0.005)^15); % Beginning of Life power requirement for BTB

%% Length and Width Calculation
total_area_STAR = BOL_STAR/300; % Total solar array area for STAR
total_area_CAP = BOL_CAP/300; % Total solar array area for CAP
total_area_SWAG = BOL_SWAG/300; % Total solar array area for SWAG
total_area_BTB = BOL_BTB/300; % Total solar array area for collection rover

STAR_per_array = total_area_STAR / 2; % Area of each array for STAR
CAP_per_array = total_area_CAP / 2; % Area of each array for the CAP
SWAG_per_array = total_area_SWAG / 2; % Area of each array for SWAG
BTB_per_array = total_area_BTB / 2; % Area of each array for BTB

width_STAR = sqrt(STAR_per_array/3); % Width of each array for STAR
width_CAP = sqrt(CAP_per_array/3); % Width of each array for CAP
width_SWAG = sqrt(SWAG_per_array/3); % Width of each array for SWAG
width_BTB = sqrt(BTB_per_array/3); % Width of each array for BTB

length_STAR = width_STAR * 3; % Length of each array for STAR
length_CAP = width_CAP * 3; % Length of each array for CAP
length_SWAG = width_SWAG * 3; % Length of each array for SWAG
length_BTB = width_BTB * 3;             % Length of each array for the collection rover

%% Output
fprintf('\nSTAR will need a BOL power generation of %f W\n', BOL_STAR)
fprintf('CAP will need a BOL power generation of %f W\n', BOL_CAP)
fprintf('SWAG will need a BOL power generation of %f W\n', BOL_SWAG)
fprintf('BTB will need a BOL power generation of %f W\n', BOL_BTB)
fprintf('Assuming all solar arrays are the same size, STAR will need 3 solar arrays at %f x %f meters\n', width_STAR, length_STAR)
fprintf('Assuming all solar arrays are the same size, CAP will need 3 solar arrays at %f x %f meters\n', width_CAP, length_CAP)
fprintf('Assuming all solar arrays are the same size, SWAG will need 3 solar arrays at %f x %f meters\n', width_SWAG, length_SWAG)
fprintf('Assuming all solar arrays are the same size, BTB will need 3 solar arrays at %f x %f meters\n\n', width_BTB, length_BTB)