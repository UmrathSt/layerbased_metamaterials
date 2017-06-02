import numpy as np
from math import sqrt

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
        dx = pt2.x - pt1.x
        dy = pt2.y - pt1.y
        number = self.number
        fact = number + 1
        pt3 = point(pt1.x + dx/fact, pt1.y + dy/fact)
        pt4 = point(pt1.x + number*dx/fact, pt1.y + number*dy/fact)
        return [pt3, pt4]

    def shift_line(self, l):
        scale = self.scale
        trans_x = scale*l.dir[1]
        trans_y = scale*l.dir[0]
        new_p1 = point(l.start.x - trans_x, l.start.y - trans_y)
        new_p2 = point(l.stop.x - trans_x, l.stop.y - trans_y)
        new_line = line(new_p1, new_p2)
        return new_line 

    def iterate(self):
        new_points = []
        for i in range(len(self.points) - 1):
            insert_idx = i+1
            to_insert = self.split_points(self.points[i], self.points[i+1])
            new_points.append(self.points[i])
            new_points.append(to_insert[0])
            l = line(to_insert[0], to_insert[1])
            shift_line = self.shift_line(l)
            new_points.extend([shift_line.start, shift_line.stop])
            new_points.append(to_insert[1])
            new_points.append(self.points[i+1])
        self.points = new_points            

if __name__ == "__main__":
    points = [point(1, 0), point(1, 1)]
    mkf = MinkowskiFractal(points)
    print(mkf.get_points())
    mkf.iterate()
    print(mkf.get_points())

