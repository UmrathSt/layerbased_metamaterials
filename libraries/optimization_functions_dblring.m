# Prevent Octave from thinking that this
# is a function file:

1;

function fitness = calc_fitness(paralist);
  handler = paralist{1};
  UCDim = paralist{2}; 
  fr4_thickness = paralist{3};
  R1 = paralist{4};
  w1 = paralist{5};
  R2 = paralist{6};
  w2 = paralist{7};
  complemential = paralist{8};
  f1 = paralist{9};
  f2 = paralist{10};
  [s11, freq] = handler(UCDim, fr4_thickness, R1, w1, R2, w2, complemential);
  [delta, idx1] = min(abs(freq-f1));
  [delta, idx2] = min(abs(freq-f2));
  fitness = -sum(2 - abs(s11(idx1-2:idx1+2)) - abs(s11(idx2-2:idx2+2)));
  return;
endfunction;

function obj = dbl_ring_fitness(paralist);
  UCDim = paralist(1);
  R1 = paralist(2);
  w1 = paralist(3);
  display(["UCDim = " num2str(UCDim)]);
  liste = {@double_ring_s11, UCDim, 2.0, R1, w1, 5.6, 0.8, 0, 2.42e9, 5.2e9};
  obj = calc_fitness(liste);
  return;
endfunction;

function eq_const = g(x);
  eq_const = [];
  return;
endfunction;

function r = h(x);
  r = [x(1)-2*x(2)];
  return;
endfunction;