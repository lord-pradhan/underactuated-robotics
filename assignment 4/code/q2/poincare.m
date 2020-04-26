function P = poincare(x)

while( sign(x(2))*(x(1)-gamma) < alpha)
    
    x = x + plant_dt*stance_dynamics(x);
end

P = collision(x);


% for t=0:plant_dt:T
%   if sign(x(2))*(x(1)-gamma) >= alpha % collision
%     x = collision(x);
%     x_vect = x(1);
%     x_dot_vect(ct) = x(2); 
%     ct=ct+1;
%   end
%   if (t - last_display_t > display_dt)
%     draw(x,t);
%     last_display_t = t;
%   end
%   x = x + plant_dt*stance_dynamics(x);
% end
% 
end