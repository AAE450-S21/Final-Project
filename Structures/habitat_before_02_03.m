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

