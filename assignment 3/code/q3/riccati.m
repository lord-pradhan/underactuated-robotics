function dydt = riccati(t, y , Q,  R, t_open, x_open, u_open)
%VDP1  Evaluate the van der Pol ODEs for mu = 1
%
%   See also ODE113, ODE23, ODE45.

%   Jacek Kierzenka and Lawrence F. Shampine
%   Copyright 1984-2014 The MathWorks, Inc.
x_0 = interp1(t_open', x_open', t);
A = [0,1; -cos(x_0(1,1)) , -1];
B = [0;1];
S = [y(1), y(2); y(3), y(4)];
temp = -(Q - S*B*R^(-1)*transpose(B)*S + S*A + transpose(A)*S);

dydt = [temp(1,1); temp(1,2); temp(2,1); temp(2,2)];