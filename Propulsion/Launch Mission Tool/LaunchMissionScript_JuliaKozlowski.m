% Launch Mission Tool Script

%INPUTS - change these values
% can be single values/strings or 1xi vectors
missiontitle = "stuff"; %title of your mission
timeofmission = "post 2023"; %time of mission you are launching e.g. "pre 2023"
destination = "lunar surface" ; %destination of your payload e.g. "LEO", "lunar surface"
payloadmassMg = 0.852+0.09; %payload mass in Mg
payloadvolm3 = 0; %payload volume in m^3

%DO NOT TOUCH REST OF CODE
LaunchMissionV4(missiontitle,timeofmission,destination,payloadmassMg,payloadvolm3)

i = 1;
while (i)
    prompt = "Would you like to add payloads to any launch? Say ""yes"" or ""no"".\n";
    x = input(prompt);
    if strcmp("yes",x) || strcmp("Yes",x)
        ques = "Which launch would you like to add to? Give a single array element integer, e.g. 1 or 5\n";
        launchnum = input(ques);
        addpaymass = input("Payload mass to add in Mg as scalar\n");
        volq = input("Is the payload volume known? Say ""yes"" or ""no"".\n");
        if strcmp("yes",volq) || strcmp("Yes",volq)
            addpayvol = input("Payload volume to add in m^3 as scalar\n");
        else
            addpayvol = 0;
        end
        newmisstitle = input("New mission title for this launch, e.g. ""New Mission""\n");
        missiontitle(launchnum) = newmisstitle;
        payloadmassMg(launchnum) = payloadmassMg(launchnum)+addpaymass;
        payloadvolm3(launchnum) = payloadvolm3(launchnum)+addpayvol;
        deleteq = input("Do you want to delete a mission?\n");
        if strcmp("yes",deleteq) || strcmp("Yes",deleteq)
            deletenum = input("Which launch? Give a single array element integer, e.g. 1 or 5\n");
            missiontitle(deletenum) = [];
            timeofmission(deletenum) = [];
            destination(deletenum) = [];
            payloadmassMg(deletenum) = [];
            payloadvolm3(deletenum) = [];
        end  
        LaunchMissionV4(missiontitle,timeofmission,destination,payloadmassMg,payloadvolm3);
    else
        i = 0;
    end 
end 