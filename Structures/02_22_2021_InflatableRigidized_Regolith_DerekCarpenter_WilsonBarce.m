%Wilson's code (and research) makes use of diffusion which lowers the
%energy of impacting micrometeoroids.  Derek has added a layer of
%aluminum to the top of the habitat to further reduce velocity and improve
%the longevity of materials and habitat operations.

%%Update 02/21/2021 Removed two top layers of the inflatable structure,
%%still left shield.

%All habitats are approximated as closed systems and the material gained
%back from the connector modules is considered extra.  This is not removed
%from the formula in case of material irregularities or shipping damage.
%Therefore, an inherent safety factor is included.
num_modules = 2;
num_airlocks = 2;

rad_inner = 3 %inner radius in meters
Reg_Thickness = 1 %regolith thickness in meters
Webbing_thickness = 0.0254 %Thickness in meters

%Wilson's Code from Week 4 - directly reused
length = 21; %length of a module in meters

d_liner = 960;
d_bladder_packed = 940;
d_restraint = 1400;
d_thermal = 1390;
d_alum = 2700; %density of aluminum in kg/m^3
d_reg = 1600; %density of regolith in kg/m^3

t_liner = 1e-3;
t_bladder_packed = 6*13*1e-6;
t_bladder = 6*25*1e-3;
t_restraint = 10*1e-3;
t_thermal = 5.34*1e-3;

t_total = t_liner + t_bladder + t_restraint + t_thermal;
t_packed = t_liner + t_bladder_packed + t_restraint + t_thermal;

rad_outer = rad_inner + t_total;

h_packed = pi*rad_inner + 2*t_packed;
w_packed = 2*t_packed;
v_packed = length * h_packed * w_packed * 2;

v_inner = rad_inner^2 * pi * length;
v_1 = (rad_inner + t_liner)^2 * pi * length;
v_2 = (rad_inner + t_liner + t_bladder)^2 * pi * length;
v_3 = (rad_inner + t_liner + t_bladder + t_restraint)^2 * pi * length;
v_4 = (rad_inner + t_liner + t_bladder + t_restraint + t_thermal)^2 * pi * length;
v_outer = (rad_inner + t_liner + t_bladder + t_restraint + t_thermal)^2 * pi * length;

v_liner = v_1 - v_inner;
v_bladder = v_2 - v_1;
v_restraint = v_3 - v_2;
v_thermal = v_4 - v_3;

d_bladder = d_bladder_packed*t_bladder_packed/t_bladder;

m_liner = d_liner * v_liner;
m_bladder = d_bladder * v_bladder;
m_restraint = d_restraint * v_restraint;
m_thermal = d_thermal * v_thermal; 

tf_liner = t_liner / t_total;
tf_bladder = t_bladder / t_total;
tf_restraint = t_restraint / t_total;
tf_thermal = t_thermal / t_total;

%End of Wilson's code

t_shield = 0.0025 %Thickness of aluminum shielding
v_shield = (rad_outer + 0.5*t_shield)*2*pi*length*t_shield;
m_shield = v_shield * d_alum;

m_hab_mod = m_liner + m_bladder + m_restraint + m_thermal + m_shield;

a_cap = (rad_outer + t_shield)^2 .*pi;
v_cap_liner = t_liner * a_cap;
v_cap_bladder = t_bladder * a_cap;
v_cap_restraint = t_restraint * a_cap;
v_cap_thermal = t_thermal * a_cap;
v_cap_shield = t_shield * a_cap;

m_cap_liner = d_liner * v_cap_liner;
m_cap_bladder = d_bladder * v_cap_bladder
m_cap_restraint = d_restraint * v_cap_restraint;
m_cap_thermal = d_thermal * v_cap_thermal;
m_cap_shield = d_alum * v_cap_shield;

m_cap_total = m_cap_liner + m_cap_bladder + m_cap_restraint + m_cap_thermal + m_cap_shield;

m_module = m_hab_mod + (2*m_cap_total);

%Interface between modules
mod_in_rad = 1.5; %inner diameter in meters
mod_in_length = 2; %module interface length in meters
mod_in_vol = (mod_in_rad)^2 * pi * mod_in_length; %inner volume of interface

%airlock
airlock_in_length = 2.3; %airlock height in meters
airlock_in_rad = 1.4; %Airlock inner radius
airlock_in_vol = (airlock_in_rad)^2 * pi* airlock_in_length; %inner volume of airlock

airlock_liner_vol = (airlock_in_rad + 0.5*t_liner)*2*pi*t_liner*airlock_in_length;
airlock_bladder_vol = (airlock_in_rad + t_liner + 0.5*t_bladder)*2*pi*t_bladder*airlock_in_length;
airlock_restraint_vol = (airlock_in_rad + t_liner + t_bladder + 0.5*t_restraint)*2*pi*t_restraint*airlock_in_length;
airlock_thermal_vol = (airlock_in_rad + t_liner + t_bladder + t_restraint + 0.5*t_thermal)*2*pi*t_thermal*airlock_in_length;
airlock_shield_vol = (airlock_in_rad + t_liner + t_bladder + t_restraint + t_thermal + 0.5*t_shield)*2*pi*t_shield*airlock_in_length;

airlock_cap_area = (mod_in_rad + t_liner + t_bladder + t_restraint + t_thermal + t_shield)^2 * pi;

airlock_liner_cap_vol = airlock_cap_area * t_liner;
airlock_bladder_cap_vol = airlock_cap_area * t_bladder;
airlock_restraint_cap_vol = airlock_cap_area * t_restraint;
airlock_thermal_cap_vol = airlock_cap_area * t_thermal;
airlock_shield_cap_vol = airlock_cap_area * t_shield;

airlock_liner_mass = airlock_liner_vol * d_liner;
airlock_bladder_mass = airlock_bladder_vol * d_bladder;
airlock_restraint_mass = airlock_restraint_vol * d_restraint;
airlock_thermal_mass = airlock_thermal_vol * d_thermal;
airlock_shield_mass = airlock_shield_vol * d_alum;

airlock_cylinder_mass = airlock_liner_mass + airlock_bladder_mass + airlock_restraint_mass + airlock_thermal_mass + airlock_shield_mass;

airlock_liner_cap_mass = airlock_liner_cap_vol * d_liner;
airlock_bladder_cap_mass = airlock_bladder_cap_vol * d_bladder;
airlock_restraint_cap_mass = airlock_restraint_cap_vol * d_restraint;
airlock_thermal_cap_mass = airlock_thermal_cap_vol * d_thermal;
airlock_shield_cap_mass = airlock_shield_cap_vol * d_alum;

airlock_cap_mass = airlock_liner_cap_mass + airlock_bladder_cap_mass + airlock_restraint_cap_mass + airlock_thermal_cap_mass + airlock_shield_cap_mass;

airlock_total_mass = airlock_cylinder_mass + 2*airlock_cap_mass;

transport_mass = num_modules*m_module + num_airlocks*airlock_total_mass;
total_interior_volume = mod_in_vol*4*num_airlocks + airlock_in_vol*num_airlocks + v_inner*num_modules;

%Regolith on main habitats

rad_minus_reg = rad_outer + t_shield;
rad_w_reg = rad_minus_reg + Reg_Thickness;

vol_reg_module = ((pi*(rad_w_reg)^2) - (pi*(rad_minus_reg)^2)) * length;
vol_reg_cap = a_cap * Reg_Thickness * 2;

vol_reg_airlock = ((airlock_in_rad + t_liner + t_bladder + t_restraint + t_thermal + t_shield + Reg_Thickness)^2 - (airlock_in_rad + t_liner + t_bladder + t_restraint + t_thermal + t_shield)^2)*pi*airlock_in_length;
vol_reg_airlock_cap = (airlock_cap_area * Reg_Thickness) *2;

Total_reg_volume = vol_reg_module + vol_reg_cap + vol_reg_airlock + vol_reg_airlock_cap;
Total_reg_mass = Total_reg_volume * d_reg;


