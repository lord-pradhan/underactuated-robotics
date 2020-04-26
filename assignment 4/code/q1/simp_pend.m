function F_x = simp_pend(X_in, u)
 
theta= X_in(1,1); theta_dot=X_in(2,1);

F_x = [ theta_dot ; u - 1/4*theta_dot - sin(theta)];

end

