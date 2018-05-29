% sweep smd resistor
addpath('./libraries/');
physical_constants;

UCDim = 10;
fr4_thickness = 3.2;
Length = 20; 
width = 1.5;
Resistance = 100;
complemential = false;


SMD_Resistor(UCDim, fr4_thickness, Length, width, Resistance, complemential);