function dydt = riccati(t, y , Q, B, R, A)
%VDP1  Evaluate the van der Pol ODEs for mu = 1
%
%   See also ODE113, ODE23, ODE45.

%   Jacek Kierzenka and Lawrence F. Shampine
%   Copyright 1984-2014 The MathWorks, Inc.

S = [y(1), y(2); y(3), y(4)];
temp = -(Q - S*B*R^(-1)*transpose(B)*S + S*A + transpose(A)*S);

dydt = [temp(1,1); temp(1,2); temp(2,1); temp(2,2)];