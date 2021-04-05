clear
clc
clf


dV = [0:1:2500];

wattage = 2300;
payloadWattage=680;
Isp = 3127;
dryMass = 268;

for n = 1:length(dV)

    ElectricProp(n) = propSizeFunc(wattage,payloadWattage,Isp,dryMass,dV(n));
    ConvProp(n) = propSizeFunc(0,payloadWattage,320,dryMass,dV(n));
    
end

hold on

plot (dV,ElectricProp,'LineWidth',2,'Color','blue');
plot (dV,ConvProp,'LineWidth',2,'Color','red');

xline(15*150,'--','LineWidth',1.5);

xline(15*100,'--','LineWidth',1.5) ;

xlabel('Delta-V, m/s','FontSize',24);
ylabel('Spacecraft Mass, kg','FontSize',24);
ax=gca;
ax.XAxis.FontSize=20;
ax.YAxis.FontSize=20;

title('Spacecraft Mass vs. \Deltav for Electric and Chemical Propulsion ','FontSize',24);
legend('Electric Propulsion I_s_p = 3127s','Chemical Propulsion I_s_p = 320s','Location','northwest','FontSize',24);

text(1400,200,'100 m/s per year, 15 years','FontSize',20,'HorizontalAlignment','center','Rotation',90);

text(2150,200,'150 m/s per year, 15 years','FontSize',20,'HorizontalAlignment','center','Rotation',90);

text(500,500,'Electric propulsion masses include' ,'FontSize',16,'HorizontalAlignment','center');
text(500,480,'solar panels and batteries necessary to' ,'FontSize',16,'HorizontalAlignment','center');
text(500,460,'power propulsion system continuously,' ,'FontSize',16,'HorizontalAlignment','center');
text(500,440,'including eclipse conditions.' ,'FontSize',16,'HorizontalAlignment','center');

ylim([0 inf]);

