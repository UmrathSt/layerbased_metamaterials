function [CSX, params] = CreateTubes(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R = object.R;
  number = object.number;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  ringmaterial = object.material.name;
  angle_step = 2*pi/number;
  printf("creating %i tubes \n", object.number);
  for rotate = (0:(number-1)).*angle_step;
    CSX = AddCylinder(CSX, ringmaterial, object.prio+1, 
          ring_start, ring_stop, R,
          'Transform', {'Translate', translate, 'Rotate_Z', rotate});

    ocenter = [object.xycenter(1:2), 0] + translate;
    params = ["# circular rings made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
              "# radius R =" num2str(R) "\n"];
  endfor;
  return;
endfunction