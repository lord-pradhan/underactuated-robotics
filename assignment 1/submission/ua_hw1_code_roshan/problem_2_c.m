%% Problem 2_c
%Author - Roshan Pradhan
clear 
close all
clc
k_p = 1; k_d=2; 
theta= 0:0.05:2*pi; theta_dot = -20:0.05:20;

for i=1:length(theta)
    for j=1:length(theta_dot)
        x_vect(i,j) = theta_dot(j);
        y_vect(i,j) = -k_d*theta_dot(j)-k_p*(theta(i)-pi);
    end
    
end

[X,Y] = meshgrid(theta,theta_dot);


quiver( transpose(X), transpose(Y) , x_vect, y_vect,10)
hold on
grid on
plot(0,0,'r*', pi,0, 'b*', 2*pi, 0, 'g*')
axis([pi-1 pi+1 -1.2 1.2])