function [CSX, params] = CreateSlittedRect(CSX, object, translate, rotate);
  diag = [object.lx/2, object.ly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  bmaterial = 'air';
  do_it_randomly = 0;
  try;
      do_it_randomly = object.do_it_randomly;
  catch lasterror;
  end;
  slitL = object.slitL;
  slitW = object.slitW;
  slitNo = object.slitN;
  % the length of the strip on which the slits have to be distributed
  % is lx- 2* slitL
  lgth = object.lx-2*slitL;
  gap = lgth/slitNo-slitW;
  lgth_elem = gap+slitW; % length of one element
  % To add N gaps of length L to the edges of the rectangle

  if ~(slitL==0);
  for nxy = 0:slitNo;
      W = slitW;
      if do_it_randomly;
          W = rand(1)*slitW;
      end;
        %startx = [-lgth/2+gap/2, -object.ly/2, -object.lz/2];
        startx = [-lgth/2,     -object.ly/2,    -object.lz/2];
        stopx  = [startx(1)+W, startx(2)+slitL, -startx(3)];
        %starty = [-object.lx/2, -lgth/2+gap/2, -object.lz/2];
        starty = [-object.lx/2,    -lgth/2,     -object.lz/2];
        stopy  = [starty(1)+slitL, starty(2)+W, -starty(3)];
      % add the slits at negative y for all x
      CSX = AddBox(CSX, bmaterial, object.prio+2, startx, stopx,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate+[lgth_elem*nxy,0,0]});
      % add the slits at positive y for all x
      CSX = AddBox(CSX, bmaterial, object.prio+2, startx, stopx,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate+[lgth_elem*nxy,object.ly-slitL,0]});
      % add the slits at negative x for all y
      CSX = AddBox(CSX, bmaterial, object.prio+2, starty, stopy,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate+[0, lgth_elem*nxy,0]});
      % add the slits at positive x for all y
      CSX = AddBox(CSX, bmaterial, object.prio+2, starty, stopy,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate+[object.lx-slitL,lgth_elem*nxy, 0]});  
  end;
  end; % of the if-case
  try;
    bmaterial = object.bmaterial.name;
    bstart = [object.UClx/2, object.UCly/2, -object.lz/2];
    bstop  = [-object.UClx/2, -object.UCly/2, object.lz/2];
    CSX = AddBox(CSX, bmaterial, object.prio+1, bstart, bstop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  catch lasterror;
  end;
  
  CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# rect patch made of '  object.material.name '. lx, ly, lz = ' num2str(object.lx) ', ' num2str(object.ly) ', ' num2str(object.lz) ' at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n'...
            '# background material (if any) is ' bmaterial '\n'...
            '# ' num2str(slitNo) ' slits of length L and width w = ' num2str(slitL) ', ' num2str(slitW) '\n'];
  return;
end