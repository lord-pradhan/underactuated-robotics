%% Problem 2_b
%Author - Roshan Pradhan
clear 
close all
clc
m=1; l=1; g=9.8; i=1;j=1;b=0.25;
theta= -2*pi:0.1:2*pi; theta_dot = -2*g/l:0.1:2*g/l;
% slope=zeros(length(theta),length(theta_dot));

for i=1:length(theta)
    for j=1:length(theta_dot)
%         slope(i,j) = u/(m*l^2*theta_dot(j))-(g/l)*sin(theta(i))/theta_dot(j) - b/(m*l ^2);
        x_vect(i,j) = theta_dot(j);
        y_vect(i,j) = (-b*theta_dot(j)+m*g*l*sin(theta(i)))/(m*l^2);
    end
    
end

[X,Y] = meshgrid(theta,theta_dot);
% x_vect = theta_dot;
% y_vect = (u-b.*theta_dot-m*g*l.*sin(theta))./(m*l^2);

quiver( transpose(X), transpose(Y) , x_vect, y_vect,5)
hold on
grid on
plot(0,0,'r*', pi,0, 'b*', -pi, 0, 'k*', 2*pi, 0, 'g*', -2*pi, 0, 'c*')