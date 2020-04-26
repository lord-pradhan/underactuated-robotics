function dydt = simple_pend_PD(t,y, m,g,l, b, k1, k2)
%VDP1  Evaluate the van der Pol ODEs for mu = 1
%
%   See also ODE113, ODE23, ODE45.

%   Jacek Kierzenka and Lawrence F. Shampine
%   Copyright 1984-2014 The MathWorks, Inc.

dydt = [y(2); ( -[k1 k2]*[y(1); y(2)] - b*y(2) + m*g*l*y(1) )/(m*l^2) ];