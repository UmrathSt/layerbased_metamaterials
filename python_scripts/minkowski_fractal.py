import numpy as np
from math import sqrt
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("--no_iter", dest="no_iter", type=int)
args = parser.parse_args()


class point:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __repr__(self):
        return "(%f, %f)" %(self.x, self.y)

    def get(self):
        return (self.x, self.y)

class line:
    def __init__(self, point1, point2):
        self.dir =  ((point2.x - point1.x),
                     (point2.y - point1.y))    
        self.length = sqrt(self.dir[0]**2 + self.dir[1]**2)
        self.dir = (self.dir[0]/self.length, self.dir[1]/self.length)
        self.start = point1
        self.stop = point2

class MinkowskiFractal:
    def __init__(self, points, scale, number):
        assert type(points) == list
        assert isinstance(points[0], point) 
        self.points = points
        self.scale = scale
        self.number = number

    def get_points(self):
        return self.points

    def split_points(self, pt1, pt2):
        """ Split the line connecting pt1 and pt2 into 
            self.number equal parts and return the outermost
            points which should be inserted
            Parameters:
            -----------
            pt1, pt2 : points
            Returns:
            ----------
            list of two points, which should be inserted
            Example:
            ----------
            pt1 = [0, 0], pt2 = [1, 0]
            pt3 = [0.25. 0], pt3 = [0.5, 0]
            -> Return is [pt3, pt4]
        """
        dx = pt2.x - pt1.x
        dy = pt2.y - pt1.y
        number = self.number
        fact = number + 1
        pt3 = point(pt1.x + dx/fact, pt1.y + dy/fact)
        pt4 = point(pt2.x - dx/fact, pt2.y - dy/fact)
        return [pt3, pt4]

    def shift_line(self, l):
        scale = self.scale
        trans_x = -(-scale*l.dir[1]*l.length)
        trans_y = -(+scale*l.dir[0]*l.length)
        new_p1 = point(l.start.x - trans_x, l.start.y - trans_y)
        new_p2 = point(l.stop.x - trans_x, l.stop.y - trans_y)
        new_line = line(new_p1, new_p2)
        return new_line 

    def iterate(self):
        """ Insert four points between neighbouring points
        """
        updated_points = []
        for i in range(len(self.points) - 1):
            new_pts = self.split_points(self.points[i], self.points[i+1])
            updated_points.append(self.points[i])
            updated_points.append(new_pts[0])
            l = line(new_pts[0], new_pts[1])
            shift_line = self.shift_line(l)
            updated_points.extend([shift_line.start, shift_line.stop])
            updated_points.append(new_pts[1])
        updated_points.append(self.points[i+1])
        self.points = updated_points            

if __name__ == "__main__":
    from matplotlib import pyplot as plt
    import numpy as np
    points = [point(-2, 2), point(2, 2), 
              point(2, -2), point(-2, -2), point(-2, 2)]
    mkf = MinkowskiFractal(points, -0.85, 2)
    i = 0
    no_iterations = args.no_iter 
    while i < no_iterations+1:
        kurve = np.array([[p.x, p.y] for p in mkf.get_points()])
        mkf.iterate()
        i += 1
    plt.plot(kurve[:, 0], kurve[:, 1], linestyle = "-", linewidth = 4, color="k")
    plt.axis("equal")
    plt.xlim([-2.5, 2.5])
    plt.ylim([-2.5, 2.5])
    plt.show()
