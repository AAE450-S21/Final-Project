function LaunchMissionV4(missiontitle,timeofmission,destination,payloadmassMg,payloadvolm3) 
%LAUNCHMISSION the Launch Mission function serves as a tool to allow an
%inputted payload mass, with given time of mission (pre-2023 or 2023),
%and given destination (LEO, lunar orbit, or lunar surface) as arrays or
%single values/strings. The tool outputs  
%INPUTS:
% 1. missiontitle*: string, titles of each payload/mission
% 2. timeofmission*: string, period of mission for launch, "pre 2023" or 
% "post 2023" assuming Starship is available in 2023
% 3. destination*: string, destination of payload "LEO", "lunar orbit", or 
% "lunar surface"
% 4. payloadmassMg*: scalar, mass of payload in [Mg]
% 5. (optional) payloadvolm3*: scalar, volume of payload in [m^3] if known 
% *all inputs must be in vector form (1xi array), all with i elements. Each 
% element in the i position of each of the 3 vectors should coorespond, and 
% represents one launch with a given time period, destination, and payload 
% mass.
%OUTPUTS Printed as Launch Report:
% 1. Launch Vehicle: string, ideal launch vehicle for given parameters
% 2. Cost: scalar, launch cost (approximate) for given parameters in
% [millions of $]
% 3. Volume Constraints: string, volume constraints for given launch vehicle
% 4. Thrust: scalar, launch thrust value in [kN]
% 5. Lander: string, lander vehicle to lunar surface (if "lunar surface"
% destination)
% 6. Remaining payload mass: remaining amount of effective payload mass
% [Mg]
% 7. Remaining payload mass: remaining amount of effective payload mass
% [Mg]
% 
% Launch Vehicles:
% Pre-2023
% 1. Falcon 9 Expendable
% 2. Falcon Heavy Reusable
% 3. Falcon Heavy Expendable
% 3. Starship (post-2023)
% 
% Landers (if "lunar surface"):
% 1. Modified Apollo Lunar Lander
% 2. Starship (post-2023)

% Assumptions: 
% -plan A (Starship available starting in 2023 (destination = "post 2023")
% -rough calculations of kg to LLO for Falcon 9 and FH (Hohmann after GTO)
% -Starship is $873.2 million per launch (returned) and is assumed to be
% refueled in LEO, able to send 90.7 Mg to LLO, $2.5 million per day 
% opportunity cost if not returned ASAP
       
if nargin == 3
    payloadvolm3 = zeros(1,length(payloadmassMg));
end
launchvehicle = strings(1,length(payloadmassMg));
LVcost = zeros(1,length(payloadmassMg));
totalcost = zeros(1,length(payloadmassMg));
volumeconstraints = strings(1,length(payloadmassMg));
thrust = strings(1,length(payloadmassMg)); %kN
lander = strings(1,length(payloadmassMg));
rempaymass = zeros(1,length(payloadmassMg));
rempayvol = zeros(1,length(payloadmassMg));

%max LV masses in Mg
maxF9payloadmass_LEO = 22.8;
maxFHRpayloadmass_LEO = 50;
maxFHpayloadmass_LEO = 63.8;
maxFHpayloadmass_land = 5.346;
maxF9payloadmass_LLO = 5;
maxFHRpayloadmass_LLO = 5;
maxFHpayloadmass_LLO = 15.3;
maxStarshipmass = 100;

%max LV volumes in Mg
maxF9payloadvol = 240.61;
maxFHpayloadvol = 295.2;
maxFHpayloadvol_land = 7;
maxStarshipvol = 1100;

for i=1:length(payloadmassMg)
    if strcmp("pre 2023",timeofmission(i)) %Starship not available
        if strcmp("LEO",destination(i))
            if (payloadmassMg(i) <= maxF9payloadmass_LEO) && (payloadvolm3(i) <= maxF9payloadvol)
                launchvehicle(i) = "Falcon 9 Expendable";
                LVcost(i) = 62; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "<= 240.61 m^3"; %in case payload volume not given
                thrust(i) = 7607; %kN
                rempaymass(i) = maxF9payloadmass_LEO - payloadmassMg(i);
                rempayvol(i) = maxF9payloadvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxFHRpayloadmass_LEO) && (payloadvolm3(i) <= maxFHpayloadvol)
                launchvehicle(i) = "Falcon Heavy Reusable";
                LVcost(i) = 90; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "<= 295.2 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHRpayloadmass_LEO - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxFHpayloadmass_LEO) && (payloadvolm3(i) <= maxFHpayloadvol)
                launchvehicle(i) = "Falcon Heavy Expendable";
                LVcost(i) = 150; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "<= 295.2 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHpayloadmass_LEO - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol - payloadvolm3(i);
            end 
        elseif strcmp("lunar surface",destination(i)) 
            if (payloadmassMg(i) <= maxFHpayloadmass_land) && (payloadvolm3(i) <= maxFHpayloadvol_land)
                launchvehicle(i) = "Falcon Heavy Expendable";
                LVcost(i) =  150; %millions of dollars
                lander(i) = "Apollo Cargo Variant, $210 million";
                totalcost(i) = 150+210; %millions of dollars
                volumeconstraints(i) = "< 7 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHpayloadmass_land - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol_land - payloadvolm3(i);
            end 
        elseif strcmp("lunar orbit", destination(i))
            if (payloadmassMg(i) <= maxF9payloadmass_LLO) && (payloadvolm3(i) <= maxF9payloadvol)
                launchvehicle(i) = "Falcon 9 Expendable";
                LVcost(i) = 62; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "< 240.61 m^3";
                thrust(i) = 7607; %kN
                rempaymass(i) = maxF9payloadmass_LLO - payloadmassMg(i);
                rempayvol(i) = maxF9payloadvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxFHRpayloadmass_LLO) && (payloadvolm3(i) <= maxFHpayloadvol)
                launchvehicle(i) = "Falcon Heavy Reusable";
                LVcost(i) = 90; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "< 295.2 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHRpayloadmass_LLO - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxFHpayloadmass_LLO) && (payloadvolm3(i) <= maxFHpayloadvol)
                launchvehicle(i) = "Falcon Heavy Expendable";
                LVcost(i) = 150; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "< 295.2 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHpayloadmass_LLO - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol - payloadvolm3(i);
            end
        end
    elseif strcmp("post 2023",timeofmission(i))
        if strcmp("LEO",destination(i))
            if (payloadmassMg(i) <= maxF9payloadmass_LEO) && (payloadvolm3(i) <= maxF9payloadvol)
                launchvehicle(i) = "Falcon 9 Expendable";
                LVcost(i) = 62; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "<= 240.61 m^3"; %in case payload volume not given
                thrust(i) = 7607; %kN
                rempaymass(i) = maxF9payloadmass_LEO - payloadmassMg(i);
                rempayvol(i) = maxF9payloadvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxFHRpayloadmass_LEO) && (payloadvolm3(i) <= maxFHpayloadvol)
                launchvehicle(i) = "Falcon Heavy Reusable";
                LVcost(i) = 90; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "<= 295.2 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHRpayloadmass_LEO - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxStarshipmass) && (payloadvolm3(i) <= maxStarshipvol)
                launchvehicle(i) = "Starship";
                LVcost(i) = 116.8; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "< 1100 m^3";
                thrust(i) = 65000; %kN
                rempaymass(i) = maxStarshipmass - payloadmassMg(i);
                rempayvol(i) = maxStarshipvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxFHpayloadmass_LEO) && (payloadvolm3(i) <= maxFHpayloadvol)
                launchvehicle(i) = "Falcon Heavy Expendable";
                LVcost(i) = 150; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "<= 295.2 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHpayloadmass_LEO - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol - payloadvolm3(i);
            end 
        elseif strcmp("lunar surface",destination(i))
            if (payloadmassMg(i) <= maxFHpayloadmass_land) && (payloadvolm3(i) <= maxFHpayloadvol_land)
                launchvehicle(i) = "Falcon Heavy Expendable";
                LVcost(i) = 150; %millions of dollars
                totalcost(i) = 150+210;
                lander(i) = "Apollo Cargo Variant, $210 million";
                volumeconstraints(i) = "<= 7 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHpayloadmass_land - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol_land - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxStarshipmass) && (payloadvolm3(i) <= maxStarshipvol)
                launchvehicle(i) = "Starship";
                LVcost(i) = 873.39; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "< 1100 m^3";
                lander(i) = "Starship Lunar Lander, with 6 LEO tanker launches";
                thrust(i) = 65000; %kN
                rempaymass(i) = maxStarshipmass - payloadmassMg(i);
                rempayvol(i) = maxStarshipvol - payloadvolm3(i);
            end
        elseif strcmp("lunar orbit",destination(i))
            if (payloadmassMg(i) <= maxF9payloadmass_LLO) && (payloadvolm3(i) <= maxF9payloadvol)
                launchvehicle(i) = "Falcon 9 Expendable";
                LVcost(i) = 62; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "< 240.61 m^3";
                thrust(i) = 7607; %kN
                rempaymass(i) = maxF9payloadmass_LLO - payloadmassMg(i);
                rempayvol(i) = maxF9payloadvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxFHRpayloadmass_LLO) && (payloadvolm3(i) <= maxFHpayloadvol)
                launchvehicle(i) = "Falcon Heavy Reusable";
                LVcost(i) = 90; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "< 295.2 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHRpayloadmass_LLO - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxFHpayloadmass_LLO) && (payloadvolm3(i) <= maxFHpayloadvol)
                launchvehicle(i) = "Falcon Heavy Expendable";
                LVcost(i) = 150; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "< 295.2 m^3";
                thrust(i) = 22800; %kN
                rempaymass(i) = maxFHpayloadmass_LLO - payloadmassMg(i);
                rempayvol(i) = maxFHpayloadvol - payloadvolm3(i);
            elseif (payloadmassMg(i) <= maxStarshipmass) && (payloadvolm3(i) <= maxStarshipvol)
                launchvehicle(i) = "Starship";
                LVcost(i) = 873.39; %millions of dollars
                totalcost(i) = LVcost(i);
                volumeconstraints(i) = "< 1100 m^3";
                thrust(i) = 65000; %kN
                rempaymass(i) = maxStarshipmass - payloadmassMg(i);
                rempayvol(i) = maxStarshipvol - payloadvolm3(i);
            end 
        end 
    end
end

for j = 1:length(launchvehicle)
    fprintf("\n<strong>%s</strong>\n", missiontitle(j));
    if (launchvehicle(j) == "" && destination(j)  == "lunar surface")
        fprintf("\nCannot land payload on surface before 2023\n")
    elseif (launchvehicle(j) == "")
        fprintf("\nLaunch of the specified parameters is not possible at this mission time\n\n");
    else
        fprintf("\nHere is your mission!");
        fprintf("\nLaunch Vehicle: %s", launchvehicle(j));
        if (launchvehicle(j) == "Starship" && destination(j) ~= "LEO")
            fprintf("\nStarship launch includes 6 prior LEO tanker launches.");
        end 
        if (launchvehicle(j) == "Starship" && destination(j) == "lunar surface")
            fprintf("\nStarship vehicle return requires additional fueling by lunar depot.")
            fprintf("\nStarship opportunity cost: $2.5 million/day if not returned ASAP.");
        end
        fprintf("\nThrust: %.2f kN", thrust(j));
        fprintf("\nCost: $%0.2f million", totalcost(j));
        fprintf("\nVolume Constraints: %s", volumeconstraints(j));
        if lander(j) == ""
            fprintf("\nNo lander specified\n");
        else
            fprintf("\nLander: %s\n", lander(j));
        end
        fprintf("\nRemaining Effective Payload Mass: %.2f Mg", rempaymass(j));
        fprintf("\nRemaining Effective Payload Volume: %.2f m^3\n", rempayvol(j))
    end
end

launchbudget = sum(totalcost);
fprintf("\n<strong>Total launch budget</strong> for your missions: $%.2f million\n\n", launchbudget);

end 