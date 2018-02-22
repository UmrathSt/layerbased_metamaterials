function [CSX, params] = CreateAsyRing(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R1 = object.R1;
  w1 = object.w1;
  L = object.L;
  N = object.N;
  w2 = object.w2;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  ringmaterial = object.material.name;
  bmaterial = object.bmaterial.name;
  bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
  bstop  = -bstart;
  CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  if object.complemential;
    try;
    CSX = AddMaterial(CSX, 'air');
    CSX = SetMaterialProperty(CSX, 'air', 'Epsilon', 1);
    catch lasterror;
    end;
    ringmaterial = 'air';
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, ...
        ring_start, ring_stop, R1-w1/2, w1,...
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  angles = (1:N)*2*pi/N+object.phi0;


  if strcmp(object.io, 'in');
    barR = R1-w1;
    sgn = -1;
    offset = 0;
    Lshort = 2/3*L;
  elseif strcmp(object.io, 'Isymmetric');
    barR = R1-w1;
    sgn = -1;
    offset = 0;
    Lshort = L;
  elseif strcmp(object.io, 'out');
    barR = R1;
    sgn = 1;
    offset = 0;
    Lshort = 2/3*L;
  elseif strcmp(object.io, 'Osymmetric');
    barR = R1-w1;
    sgn = 1;
    offset = 0;
    Lshort = L;
  elseif strcmp(object.io, 'through');
    barR = R1-w1-L;
    sgn = 1;
    offset = L/2;
    Lshort = w1+L*1.5;
    L = 2*L+w1;

    
  else;
    error (['Error! Radial position of the asymmetry not understood. Expected >in< or >out< but got: ' object.io]);
  end;

  bar1start = [barR, w2, -object.lz/2];
  bar1stop  = [barR+sgn*L, 0, object.lz/2];
  bar2start = [barR+offset, 0, -object.lz/2];
  bar2stop  = [barR+sgn*Lshort, -w2, object.lz/2];
  barmaterial = object.barmaterial.name;
  for angle = angles;
    CSX = AddBox(CSX, barmaterial, object.prio+2, bar1start, bar1stop,...
      'Transform', {'Rotate_Z', rotate+angle, 'Translate', translate});
    CSX = AddBox(CSX, barmaterial, object.prio+2, bar2start, bar2stop,...
      'Transform', {'Rotate_Z', rotate+angle, 'Translate', translate});
  end;
  
  
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# asymmetric circular ring made of ',  ringmaterial, ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n' ...
            '# radius R1=', num2str(R1,'%.10f') ', ringwidth w1=', num2str(w1,'%.10f'), ', background material ', bmaterial, '\n'...
            '# Asymmetry is located ' object.io 'side of the ring, ' num2str(N) ' rectangular double bars of length and width L and 2/3 L with L, w=' num2str(L) ', ' num2str(w2) '\n'];
  return;
end