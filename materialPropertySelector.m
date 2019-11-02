function [outE,outG,outSut,outMaxSutKw,outMaxSutKs,outCost,outError] = materialPropertySelector(inMaterial, ind)
%This function replicates tables found in Shigley
%Rows are the following materials, in this order:
%Music wire, OQ&T wire, Hard-drawn wire, chrome-vanadium wire,
%chrome-silicon wire, 302 Stainless wire, phosphor-bronze wire
%columns are the following properties:
%m, A, mdiameter, maxDiameter, cost

%all units are in SI

%determine which part of the table we need to read from. This combines
%tables 10-4 and 10-5 from Shigley into one set of materials.

d = 1000*ind; %convert from m to mm
outError = 0; %use this variable to detect if an error has occured
if inMaterial == 1 %is it music wire
    if d < 0.1
        disp('Error, diameter too small for this material');
        outError = 1;
    elseif d < 0.8
        material = 1;
    elseif d < 1.6
        material = 2;
    elseif d < 3
        material = 3;
    elseif d <= 6.5
        material = 4;
    else
        disp('Error, diameter too large for this material');
        outError = 1;
    end
elseif inMaterial == 2 %is it oil quentched and tempered steel
    if d < 0.5
        disp('Error, diameter too small for this material');
        outError = 1;
    elseif d <= 12.7
        material = 5;
    else
        disp('Error, diameter too large for this material');
        outError = 1;
    end
elseif inMaterial == 3 %is it hard-drawn wire
    if d < 0.7
        disp('Error, diameter too small for this material');
        outError = 1;
    elseif d < 0.8
        material = 6;
    elseif d < 1.6
        material = 7;
    elseif d < 3
        material = 8;
    elseif d <= 12.7
        material = 9;
    else
        disp('Error, diameter too large for this material');
        outError = 1;
    end
elseif inMaterial == 4 %is it chrome-valadium wire
    if d < 0.8
        disp('Error, diameter too small for this material');
        outError = 1;
    elseif d <= 11.1
        material = 10;
    else
        disp('Error, diameter too large for this material');
        outError = 1;
    end  
elseif inMaterial == 5 %is it chrome-silicon wire
    if d < 1.6
        disp('Error, diameter too small for this material');
        outError = 1;
    elseif d <= 9.5
        material = 11;
    else
        disp('Error, diameter too large for this material');
        outError = 1;
    end      
elseif inMaterial == 6
    if d < 0.3
        disp('Error, diameter too small for this material');
        outError = 1;
    elseif d < 2.5
        material = 12;
    elseif d < 5
        material = 13;
    elseif d < 10
        material = 14;
    else
        disp('Error, diameter too large for this material');
        outError = 1;
    end
elseif inMaterial == 7
    if d < 0.1
        disp('Error, diameter too small for this material');
        outError = 1;
    elseif d < 0.6
        material = 15;
    elseif d < 2.0
        material = 16;
    elseif d < 7.5
        material = 17;
    else
        disp('Error, diameter too large for this material');
        outError = 1;
    end
end

if outError ==0
    %columns are E, G, d_min, d_max, m, A, cost
    materialProperties = [203.4	82.7	0.1	0.8	0.145	2211	2.6 0.45 0.65;
                    200	81.7	0.8	1.6	0.145	2211	2.6 0.45 0.65;
                    196.5	81	1.6	3	0.145	2211	2.6 0.45 0.65;
                    193	80	3	6.5	0.145	2211	2.6 0.45 0.65;
                    196.5	77.2	0.5	12.7	0.187	1855	1.3 0.5 0.7;
                    198.6	80.7	0.7	0.8	0.19	1783	1 0.45 0.65;
                    197.9	80	0.8	1.6	0.19	1783	1 0.45 0.65;
                    197.2	79.3	1.6	3	0.19	1783	1 0.45 0.65;
                    196.5	78.6	3	12.7	0.19	1783	1 0.45 0.65;
                    203.4	77.2	0.8	11.1	0.168	2005	3.1 0.5 0.7;
                    203.4	77.2	1.6	9.5	0.108	1974	4 0.5 0.7;
                    193	69	0.3	2.5	0.146	1867	10 0.35 0.6;
                    193	69	2.5	5	0.263	2065	10 0.35 0.6;
                    193	69	5	10	0.478	2911	10 0.35 0.6;
                    103.4	41.4	0.1	0.6	0	1000	8 0.35 0.6;
                    103.4	41.4	0.6	2	0.028	913	8 0.35 0.6;
                    103.4	41.4	2	7.5	0.064	932	8 0.35 0.6];

    outE = materialProperties(material,1)*1000; %MPa
    outG = materialProperties(material,2)*1000; %MPa
    outCost = materialProperties(material,7);
    outMaxSutKw = materialProperties(material,8); % percentage Sut
    outMaxSutKs = materialProperties(material,9); % percentage Sut

    %calculate Sut      
    m = materialProperties(material,5);
    A = materialProperties(material,6); %MPa * mm^m
    outSut = A / d^m; %MPa
else
    outE = 0;
    outG = 0;
    outSut = 0;
    outMaxSutKw = 0;
    outMaxSutKs = 0;
    outCost = 0;
end

end