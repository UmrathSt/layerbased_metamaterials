function points = GenerateRandomPoints(N, xmin, xmax, ymin, ymax, dx, dy);
    % generate a total of N points (x,y) with:
    % x in [xmin, xmin+dx, xmin+2*dx,... xmax] and y in [ymin,... ymax] 
    % with step sizes dx and dy
    Nx = round((xmax-xmin)/dx)+1;
    Ny = round((ymax-ymin)/dy)+1;
    Ntot = Nx*Ny;
    Rands = randperm(Ntot)(1:N);
    points = [[]];
    for n = 1:N;
        Z = Rands(n);
        points = vertcat(points, [idivide(Z, Nx)*dx+xmin, mod(Z, Ny)*dy+ymin]);
    end;
    
end


    
            