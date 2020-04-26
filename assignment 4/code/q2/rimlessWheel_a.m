function x_dot = rimlessWheel_a(w0)

% RimlessWheel
%   rimlessWheel(w0) starts the wheel with w0 as the initial
%   rotation velocity.
%
%   rimlessWheel with no arguments starts the wheel with a random
%   initial velocity.
%
% Written by Russ Tedrake (russt@mit.edu)

m = 1; l = 1; g = 9.8; alpha = pi/8;
%gamma = 0.03;  % standing is only fixed point
gamma = 0.08;  % standing and rolling fixed points
%gamma = alpha+0.01;  % only rolling fixed point

if (nargin < 1)
  w0 = 5*randn;
  theta0 = -sign(w0)*alpha+gamma;
end


% x = [-sign(w0)*alpha+gamma; w0; 0];  % [\theta, \dot\theta, xfoot] 
theta0 = -sign(w0)*alpha+gamma;
x = [ theta0; w0; 0];
  % I'm only keeping xfoot around so that the drawing looks smoother

plant_dt = 1e-3;
T = 15;

for t=0:plant_dt:T
  if sign(x(2))*(x(1)-gamma) >= alpha % collision
    x = collision(x);
    x_dot = x(2); 
    break
  end
  
  x = x + plant_dt*stance_dynamics(x);
end



  function xp = collision(xm)

    xp = [-sign(xm(1)-gamma)*alpha + gamma; ...
      xm(2)*cos(2*alpha); ...
      xm(3) + sign(x(1)-gamma)*2*l*sin(alpha)];

  end


  function xdot = stance_dynamics(x)

    xdot = [x(2); g*sin(x(1))/l; 0];

  end

end