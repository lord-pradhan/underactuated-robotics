function grad = P_grad(x_p)

F_grad = [ 0 , 0; 0, cos(2*alpha) ];
dX_dt = stance_dynamics(x_p);
phi_grad = [ sign(x_p(2)) ; 0 ] ;



end

