import numpy as np
from minkowski_fractal import point, line, MinkowskiFractal

pts = [point(-1, 1), point(1,1),
       point(1, -1), point(-1, -1),
       point(-1, 1)]

M = MinkowskiFractal(pts, -0.25, 3)
M.iterate()
print(M.points)
