function [CSX, params] = CreateSplitRing(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R = object.R;
  w = object.w;
  phi0 = object.phi0;
  DeltaPhi = object.DeltaPhi;
  lz = object.lz;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  ringmaterial = object.material.name;
  bmaterial = 'air';
  if object.complemential;
    CSX = AddMaterial(CSX, 'air');
    CSX = SetMaterialProperty(CSX, 'air', 'Epsilon', 1);
    ringmaterial = 'air';
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  endif;
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R-w/2, w,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  %      z              x 
  p(1,1) = -lz/2; p(2,1) = -R; 
  p(1,2) = +lz/2; p(2,2) = -R;
  p(1,3) = +lz/2; p(2,3) = -R+w; 
  p(1,4) = -lz/2; p(2,4) = -R+w;
  p(1,5) = -lz/2; p(2,5) = -R;
  if ~(DeltaPhi==0);
    CSX = AddRotPoly(CSX, bmaterial, object.prio+3, 1, p, 2, [phi0-DeltaPhi, phi0+DeltaPhi/2], 'CoordSystem',0,...
      'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# circular split-ring made of '  ringmaterial ' at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n' ...
            '# radius R =' num2str(R) ', ringwidths w =' num2str(w) ', background material ' bmaterial '\n' ...
            '# air gap at angle Phi0 = ' num2str(phi0) ', opening angle = ' num2str(DeltaPhi) '\n'];
  return;
endfunction