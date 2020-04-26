function xdot = stance_dynamics(x)

global plant_dt gamma alpha g l m
xdot = [x(2); g*sin(x(1))/l]; %; 0];

end