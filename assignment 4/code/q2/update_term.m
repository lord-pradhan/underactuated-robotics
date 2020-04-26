function [P_grad, update] = update_term(x_p)

global plant_dt gamma alpha g l

y = eye(2);
x=x_p;

while( sign(x(2))*(x(1)-gamma) < alpha)
    
    x = x + plant_dt*stance_dynamics(x);
    A_dyn = [ 0,1 ; g*cos(x(1))/l , 0];
    y = y + A_dyn*y*plant_dt;
end

P = collision(x);

impact_grad = [ 0 , 0; 0, cos(2*alpha) ];
dX_dt = stance_dynamics(x);
phi_grad = [ sign(x(2)) ; 0 ] ;

P_grad = impact_grad*( y + dX_dt*( -phi_grad'*y )/( phi_grad'*dX_dt ) );

update = ( eye(2) - P_grad )^(-1) * ( x_p - P );

end