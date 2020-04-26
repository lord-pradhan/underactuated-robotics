function dydt = ode_solver(t,y, u, m, l, b, g)
%VDP1  Evaluate the van der Pol ODEs for mu = 1
%
%   See also ODE113, ODE23, ODE45.

%   Jacek Kierzenka and Lawrence F. Shampine
%   Copyright 1984-2014 The MathWorks, Inc.

dydt = [y(2); u/(m*l^2)-b*y(2)/(m*l^2)-g*sin(y(1))/l];