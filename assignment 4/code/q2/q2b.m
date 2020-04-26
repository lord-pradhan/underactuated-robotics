%% Question 2b script
%Author - Roshan Pradhan

clear 
close all
clc

global plant_dt gamma alpha g l m
%% First generate Poincare map from x
X_0 = [-0.3127; 4.5];
m = 1; l = 1; g = 9.8; alpha = pi/8; gamma = 0.08;
ct =1; plant_dt = 1e-4;

x = X_0; x_prev = [0;0];
% start Newton's method from this x_p

while( norm(x - x_prev) > 1e-5 )
    
    x_prev = x;
    % get nearest x_p[n]
    
    while( sign(x(2))*(x(1)-gamma) < alpha )

        x = x + plant_dt*stance_dynamics(x);
    end
    
    x_temp=x; % this satisfies guard condition
    
    x_p = collision(x);
    [P_grad, x_update] = update_term(x_p);
    x = x_p - x_update;
   
    ct=ct+1;
end

%% Stability analysis
J = eig(P_grad);
