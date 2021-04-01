%{ 
This program is a preliminary sizing algorithm for lunar structures and 
scientific exploration areas.  

Justification for omitting 'for' loops within program: For loops are
unnecessary since each structure will be individually defined prior to
being assembled.  Each pathway will also retain different dimensions,
depending on its respective connecting structures.

Lunar regolith approximate density = 1.6 g/cm^3
%}

reg_density = 1600 %density in kg/m^3
iron_density = 7870 %density in kg/m^3
glassfoam_density = 128 %density in kg/m^3


%template for cylindrical hard-shell prebuilt structure.

inner_rad = 2 %radius in Meters
insulation_thickness = 0.25 %Thickness in meters
regolith_thickness = 0.6 %Thickness in meters
outer_thickness = 0.05 %Thickness in meters
inner_layer_thickness = 0.05 %Thickness in meters
leng = 10 %Length in meters.

Inner_Volume = (inner_rad)^2 .*pi;

Insulation_volume = ((inner_rad + inner_layer_thickness + insulation_thickness)^2 - (inner_rad + inner_layer_thickness)^2) .*pi .*leng

Regolith_volume = ((inner_rad + inner_layer_thickness + insulation_thickness + regolith_thickness)^2 - (inner_rad + inner_layer_thickness + insulation_thickness)^2) .*pi .* leng

Inner_shell_volume = ((inner_rad + inner_layer_thickness)^2 - (inner_rad)^2) .* pi .* leng

Outer_shell_volume = ((inner_rad + inner_layer_thickness + insulation_thickness + regolith_thickness + outer_thickness)^2 - (inner_rad + inner_layer_thickness + insulation_thickness + regolith_thickness)^2) .*pi .* leng

%Mass Calculations in kg

Insulation_mass = Insulation_volume .* glassfoam_density

Regolith_mass = Regolith_volume .* reg_density

Shell_mass = (Inner_shell_volume + Outer_shell_volume) .* iron_density



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
