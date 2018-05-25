function [CSX, params] = CreateRectBroadbandChipres2(CSX, object, translate, rotate);
% Broadband absorber geometry of
% : Appl. Phys. Lett.112, 021605 (2018); doi: 10.1063/1.5004211 
% modified for rectangle instead of circle and another resistor quadruple in the center
% of the unit-cell

  UClx = object.UClx;
  UCly = object.UCly;

  L2 = object.L2;
  L1 = object.L1;
  rho = object.rho;
  Resistor1 = object.Resistor1.name;
  Resistor2 = object.Resistor2.name;
  RL = object.RL;
  gap1 = object.gapwidth;
  gap2 = object.gapwidth2;
  reswidth = object.reswidth;
  L3 = sqrt(2)*(L1-L2) + gap1/2 - gap2;
  length = 2*L1+gap1;

  dphi = pi/4;
  try;
    dphi = object.dphi;
  catch lasterror;
  end;
  
  lz = object.lz;
  material = object.material.name;
  bmaterial = object.bmaterial.name;
  resistormaterial1 = object.Resistor1.name;
  resistormaterial2 = object.Resistor2.name;
  
  Oresistor1 = [rho, -gap1/2, -lz/2];
  Oresistor2 = [rho+reswidth, gap1/2, lz/2];

  %Ires_length = (L1-L2)/sqrt(2);
  Ires_length = gap1;
  Iresistor1 = [L3/2, reswidth/2, -lz/2];
  Iresistor2 = [L3/2+gap2, -reswidth/2, lz/2];


  bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
  bstop  = -bstart;
  CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Translate', translate});
  % add the center copper rectangle
  irect1 = [-L3/2, -L3/2, -lz/2];
  irect2 = [L3/2, L3/2, lz/2];
  CSX = AddBox(CSX, material, object.prio, irect1, irect2,...
  'Transform', {'Rotate_Z', rotate+pi/4, 'Translate', translate});
  if object.complemential;
    try;
    CSX = AddMaterial(CSX, 'air');
    CSX = SetMaterialProperty(CSX, 'air', 'Epsilon', 1);
    catch lasterror;
    end;
    material = 'air';
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio+1, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;

  % add the four wings of the structure
    p(1,1) = length/2-L2 ;  p(2,1) = gap1/2;
    p(1,2) = length/2 ;     p(2,2) = gap1/2;
    p(1,3) = length/2 ;     p(2,3) = length/2;
    p(1,4) = gap1/2 ;       p(2,4) = length/2;
    p(1,5) = gap1/2 ;  p(2,5) = length/2-L2;
    p(1,6) = p(1,1) ;  p(2,6) = p(2,1);
 

  for rot = (0:3)*pi/2+dphi;
    CSX = AddLinPoly( CSX, material, object.prio+1, 2, -object.lz/2, p , object.lz, 'CoordSystem',0,...
        'Transform', {'Rotate_Z', rotate+rot, 'Translate', translate});
    CSX = AddBox(CSX, resistormaterial1, object.prio+2, Oresistor1, Oresistor2,'Transform', {'Rotate_Z', rotate+rot, 'Translate', translate});
    CSX = AddBox(CSX, resistormaterial2, object.prio+2, Iresistor1, Iresistor2,'Transform', {'Rotate_Z', rotate+rot-pi/4, 'Translate', translate});


  end;

    
 
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# broadband chipresonator absorber made of ',  material, ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n'];
  return;
end