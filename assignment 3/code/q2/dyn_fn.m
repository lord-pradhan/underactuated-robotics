function F_x = dyn_fn(X_in, u)
 
x= X_in(1,1); theta=X_in(2,1); x_dot = X_in(3,1); theta_dot = X_in(4,1);

F_x = [ x_dot ; theta_dot ; ...
    ( (theta_dot^2 + cos(theta))*sin(theta) + u )/(1+(sin(theta))^2 );
    ( -u*cos(theta) - theta_dot^2*cos(theta)*sin(theta) - 2*sin(theta) )/(1+sin(theta)^2) ];
  
end