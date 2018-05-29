function [CSX, params] = CreateSMDResistor(CSX, object, translate, rotate);
% Create a 0402 SMD Resistor given its DC Resistance Value, position and orientation 
% geometric data from rsonline: https://docs-emea.rs-online.com/webdocs/157c/0900766b8157caac.pdf
% Thick Film Chip Resistor 1% - RS Series
    D1 = 0.2;
    D2 = 0.2;
    L = 1.0;
    W = 0.5;
    T = 0.35;
    unit = 1e-3;
    try;
        unit = object.unit;
    catch lasterror;
    end;
    Res = object.Resistance;
    SheetThickness = 0.1e-6;
    prio = object.prio;
    EpsilonAlO2 = 10;
    subsName = 'AlO2Substrate';
    elecName = 'Electrode';
    CSX = AddMaterial(CSX, subsName, 'Epsilon', EpsilonAlO2);
    CSX = AddMetal(CSX, elecName);
    % add the two electrodes
    % left electrode in yz-plane
    p(1,1) = -L/2+D1; p(2,1) = T/2; 
    p(1,2) = -L/2;    p(2,2) = T/2;
    p(1,3) = -L/2;  p(2,3) = -T/2;
    p(1,4) = -L/2+D1;   p(2,4) = -T/2;
    CSX = AddLinPoly( CSX, elecName, prio+1, 0, -W/2, p , W, 'CoordSystem',0);
    % right electrode in yz-plane
    p(1,1) = L/2-D1; p(2,1) = T/2; 
    p(1,2) = L/2;    p(2,2) = T/2;
    p(1,3) = L/2;  p(2,3) = -T/2;
    p(1,4) = L/2-D1;   p(2,4) = -T/2;
    CSX = AddLinPoly( CSX, elecName, prio+1, 0, -W/2, p , W, 'CoordSystem',0);
    % add the dielectric layer
    start = [-W/2, -L/2, -T/2];
    stop  = [W/2, L/2, T/2];
    CSX = AddBox(CSX, subsName, prio, start, stop, 'Transform', {'Rotate_Z', rotate, 'Translate', translate});
    % now add the resistive film
    start = [-W/2, -L/2, T/2];
    stop  = [W/2,  L/2, T/2];
    SheetKappa = L/(Res*W*SheetThickness*unit);
    CSX = AddConductingSheet(CSX, resistive_sheet, SheetKappa, SheetThickness);
    ocenter = [object.xycenter(1:2), 0] + translate;

    params = ["# SMD-Resistor at coordinate " num2str(ocenter(1)) ',' num2str(ocenter(2)) ',' num2str(ocenter(2)) '. ' " \n" ];
    return;
endfunction