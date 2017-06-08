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
        trans_x = scale*l.dir[1]*l.length
        trans_y = -scale*l.dir[0]*l.length
        new_p1 = point(l.start.x - trans_x, l.start.y - trans_y)
        new_p2 = point(l.stop.x - trans_x, l.stop.y - trans_y)
        new_line = line(new_p1, new_p2)
        return new_line 

    def iterate(self):
        new_points = []
        for i in range(len(self.points) - 1):
            try:
                insert_idx = i+1
                to_insert = self.split_points(self.points[i], self.points[i+1])
                new_points.append(self.points[i])
                new_points.append(to_insert[0])
                l = line(to_insert[0], to_insert[1])
                shift_line = self.shift_line(l)
                new_points.extend([shift_line.start, shift_line.stop])
                new_points.append(to_insert[1])
                new_points.append(self.points[i+1])
            except:
                pass
        self.points = new_points            

if __name__ == "__main__":
    from matplotlib import pyplot as plt
    import numpy as np
    points = [point(-1, 1), point(1, 1), 
              point(1, -1), point(-1, -1),
              point(-1, 1)]
    mkf = MinkowskiFractal(points, -1, 2)
    i = 0
    colors = ["k", "r", "b"]
    while i < len(colors):
        kurve = np.array([[p.x, p.y] for p in mkf.get_points()])
        #plt.plot(kurve[:, 0], kurve[:, 1], linestyle = "-", linewidth = 2, color = colors[i])
        mkf.iterate()
        i += 1
    plt.plot(kurve[:, 0], kurve[:, 1], linestyle = "-", linewidth = 4, color = colors[i-1])
    plt.axis("equal")
    plt.xlim([-1.5, 1.5])
    plt.ylim([-1.5,1.5])
    plt.show()
