%{ 
This program is a preliminary sizing algorithm for lunar structures and 
scientific exploration areas.  

Justification for omitting 'for' loops within program: For loops are
unnecessary since each structure will be individually defined prior to
being assembled.  Each pathway will also retain different dimensions,
depending on its respective connecting structures.

Lunar regolith approximate density = 1.6 g/cm^3
%}
NumAstronaut = 19;
Rigid_Habs = 3.5
Rigid_Habs_per_Starship = 0.8

Inflat_Habs = 1;
Inflat_Habs_per_Starship = 1;

Hybrid_Habs = 1;
Hybrid_Habs_per_Starship = 1;

reg_density = 1600 %density in kg/m^3
iron_density = 7870 %density in kg/m^3
glassfoam_density = 128 %density in kg/m^3
alum_density = 2700 %density in kg/m^3

%template for cylindrical hard-shell prebuilt structure.

inner_rad = 3 %radius in Meters
insulation_thickness = 0.25 %Thickness in meters
regolith_thickness = 0.6 %Thickness in meters
outer_thickness = 0.025 %Thickness in meters
inner_layer_thickness = 0.025 %Thickness in meters
leng = 7 %rigid habitat length in meters.

Inner_Volume = (inner_rad)^2 .*pi*leng;

Outer_Volume = (inner_rad + inner_layer_thickness + insulation_thickness + regolith_thickness + outer_thickness)^2 *pi*leng

Insulation_volume = ((inner_rad + inner_layer_thickness + insulation_thickness)^2 - (inner_rad + inner_layer_thickness)^2) .*pi .*leng

Regolith_volume = ((inner_rad + inner_layer_thickness + insulation_thickness + regolith_thickness)^2 - (inner_rad + inner_layer_thickness + insulation_thickness)^2) .*pi .* leng

Inner_shell_volume = ((inner_rad + inner_layer_thickness)^2 - (inner_rad)^2) .* pi .* leng

Outer_shell_volume = ((inner_rad + inner_layer_thickness + insulation_thickness + regolith_thickness + outer_thickness)^2 - (inner_rad + inner_layer_thickness + insulation_thickness + regolith_thickness)^2) .*pi .* leng

Cap_area = (inner_rad + insulation_thickness + regolith_thickness + outer_thickness + inner_layer_thickness)^2 .* pi;
Cap_mass = (Cap_area .* insulation_thickness .* glassfoam_density) + (Cap_area .* outer_thickness .* alum_density) + (Cap_area.*inner_layer_thickness .*alum_density);
%Mass Calculations in kg

Insulation_mass = Insulation_volume .* glassfoam_density

Regolith_mass = Regolith_volume .* reg_density

Shell_mass = (Inner_shell_volume + Outer_shell_volume) .* alum_density

Rigid_Transport_Mass = Insulation_mass + Shell_mass + 2.*Cap_mass;

%Inflatable Structures (here through the next structure type indicator)
Inflate_inner_rad = 8; %radius in meters
Inflate_inner_volume = (4/3) .* pi .* (Inflate_inner_rad)^3;
Kevlar_dens = 1440 % kg/m^3
rib_thickness = 0.005 %meters
rib_density = 513.9 %kg/m^3
compression_ratio = 10
Area_above_ground = 0.65
Inflat_reg_thickness = 3 %meters

Kevlar_thickness = 0.000114 %thickness in meters

Kevlar_volume = ((Inflate_inner_rad + Kevlar_thickness + rib_thickness)^3 - (Inflate_inner_rad + rib_thickness)^3) .* pi* (4/3)
Kevlar_mass = Kevlar_dens .* Kevlar_volume %mass of kevlar in kg
Structuralrib_volume = ((Inflate_inner_rad + rib_thickness)^3 - (Inflate_inner_rad)^3) .* pi .* (4/3)
Structuralrib_mass = rib_density .* Structuralrib_volume;
%(Legacy Code to Reverse Engineer Rib Density - Not needed) Structuralrib_dens = (2200 - Kevlar_mass)/(Structuralrib_volume)

%volume of materials once expanded
Dome_Initial_Volume = Kevlar_volume + Structuralrib_volume;
%volume required in Starship to transport earth-made materials
Transport_Volume = compression_ratio .* Dome_Initial_Volume;
%amount of regolith around inflatable habitat
Inflat_reg_volume = ((Inflate_inner_rad + rib_thickness + Kevlar_thickness + Inflat_reg_thickness)^3 .*(4/3).*pi) - ((Inflate_inner_rad + rib_thickness + Kevlar_thickness)^3 .*(4/3) .*pi);
Inflat_reg_mass = Inflat_reg_volume .* reg_density; %regolith density in kg
Inflat_Transport_Mass = Kevlar_mass + Structuralrib_mass

%Combination Habitat (Change Rigid Habitat Length based on prefabricated 
%center requirements)

Center_mass = Rigid_Transport_Mass;
Arm_length = 12;
Arm_mass = Outer_shell_volume .* alum_density + (inner_rad + inner_layer_thickness + insulation_thickness + regolith_thickness + outer_thickness)^2 - (inner_rad + inner_layer_thickness + insulation_thickness + regolith_thickness)*2*pi*Arm_length*Kevlar_thickness*Kevlar_dens
Arm_vol = (inner_rad)^2 .*pi.*Arm_length;
Num_Arms = 4;
Total_Arm_Vol = Arm_vol * Num_Arms;
Total_Arm_Mass = Arm_mass * Num_Arms + Center_mass;
Storage_volume = Arm_vol*0.1*Num_Arms + Outer_Volume;
Hybrid_Living_Volume = Total_Arm_Vol + Inner_Volume;

%Starship Utilization Normalizing Function

Rigid_Hab_Starships = Rigid_Habs / Rigid_Habs_per_Starship;
Inflat_Hab_Starships = Inflat_Habs / Inflat_Habs_per_Starship;
Hybrid_Hab_Starships = Hybrid_Habs / Hybrid_Habs_per_Starship;

% Vehicle usage scores below scaled for decision matrix
Rigid_req_score = 1/Rigid_Hab_Starships
Inflat_req_score = 1/Inflat_Hab_Starships
Hybrid_req_score = 1/Hybrid_Hab_Starships

Rigid_VolPerPerson = 65; %Fixed to be the minimum required volume/person
Hybrid_VolPerPerson = Hybrid_Living_Volume / NumAstronaut
Inflate_VolPerPerson = Inflate_inner_volume / NumAstronaut

%Normalize against the highest volume per person habitat type
%Below are the Comfort category scores

Rigid_VolScore = Rigid_VolPerPerson / Inflate_VolPerPerson
Hybrid_VolScore = Hybrid_VolPerPerson / Inflate_VolPerPerson
Inflate_VolScore = Inflate_VolPerPerson / Inflate_VolPerPerson