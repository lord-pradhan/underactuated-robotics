%% Problem 3
%Author - Roshan Pradhan
clc
clear
close all

%% Declare parameters and initialise
Q = eye(2); R = 1; N=20;
u = -2:0.5:2; x = -pi:pi/6:2*pi; x_dot = -3*pi/2:pi/6:3*pi/2;
dt = 0.05; x_d = [-pi, pi;0, 0];

J_init = zeros(length(x),length(x_dot)); J_whole = zeros(length(x),length(x_dot),1); policy_whole = zeros(length(x),length(x_dot),1);
J=J_init; [X , Y] = meshgrid(x,x_dot);

for count = 1:N
    [J_fin, policy_mat] = computeValFn(J, x, x_dot, u, dt, x_d, Q, R);
    J_whole(:,:,count)=J_fin;
    J = J_fin;
    figure(1)
    subplot(1,2,1)
    h = heatmap(x,x_dot,J);
    title('Heatmap for value function')
    
    policy_whole(:,:,count)=policy_mat;
    subplot(1,2,2)
    h1 = heatmap(x,x_dot,policy_mat);
    title('Heatmap for policy')
    pause(0.5);
end
