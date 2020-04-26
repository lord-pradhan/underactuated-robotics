%% Question 2a script
%Author - Roshan Pradhan

clear 
close all
clc

%% Call tedrake simulation
x = -3:0.05:3; ct=1;

for i = -3: 0.05: 3
    
    x_dot_vect(ct) = rimlessWheel_a(i);
    ct=ct+1;
    
end
    
x_dot_vect( x==0 ) = 0;

%% Post-processing
% x_dot_x = x_dot_vect(1:end-1);
% x_dot_y = x_dot_vect(2:end);

figure(2)
plot(x,x, 'r')
hold on
grid on
plot(x, x_dot_vect, 'k--')
title('Poincare Map')
legend('x=y line', 'Poincare map')

P = InterX( [x; x_dot_vect], [x;x] );