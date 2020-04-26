%% Problem 1
%Author - Roshan Pradhan
clear 
close all
clc

%% Part a

% initialise parameters
m=1; l=1; g=1; b=1; u=0;
theta= -2*pi:0.1:2*pi; theta_dot = -2*g/l:0.1:2*g/l;

for i=1:length(theta)
    for j=1:length(theta_dot)
        x_vect(i,j) = theta_dot(j);
        y_vect(i,j) = (u-b*theta_dot(j)-m*g*l*(theta(i)))/(m*l^2);
    end
end

[X,Y] = meshgrid(theta,theta_dot);

quiver( transpose(X), transpose(Y) , x_vect, y_vect,3)
hold on
grid on

% ODE45
[t,y] = ode45(@(t,y) simple_pend(t,y, u, m,g,l, b),[0 10],[pi; 0.6]);
plot(y(:,1), y(:,2),'-o')

%% Part b
m=1; l=1; g=1;b=1; u=0;
theta= -2*pi:0.1:2*pi; theta_dot = -2*g/l:0.1:2*g/l;

for i=1:length(theta)
    for j=1:length(theta_dot)
        x_vect(i,j) = theta_dot(j);
        y_vect(i,j) = (u-b*theta_dot(j)+m*g*l*(theta(i)))/(m*l^2);
    end
    
end

[X,Y] = meshgrid(theta,theta_dot);

figure(2)
quiver( transpose(X), transpose(Y) , x_vect, y_vect,3)
hold on
grid on

[t,y] = ode45(@(t,y) simple_pend_shift(t,y, u, m,g,l, b),[0 5],[0; 0.6]);

plot(y(:,1), y(:,2),'-o')

%% Part c
k1 = 5; k2=1;

theta= -2*pi:0.1:2*pi; theta_dot = -2*g/l:0.1:2*g/l;

for i=1:length(theta)
    for j=1:length(theta_dot)
        x_vect(i,j) = theta_dot(j);
        y_vect(i,j) = (-[k1,k2]*[theta(i); theta_dot(j)]-b*theta_dot(j)+m*g*l*(theta(i)))/(m*l^2);
    end
    
end

[X,Y] = meshgrid(theta,theta_dot);

figure(3)
quiver( transpose(X), transpose(Y) , x_vect, y_vect,3.5)
hold on
grid on

[t,y] = ode45(@(t,y) simple_pend_PD(t,y, m,g,l, b, k1, k2),[0 10],[0; 0.6]);
plot(y(:,1), y(:,2),'-o')

%% Part d
Q = [5,0;0,1]; R = 1; Qf = eye(2);
A = [0, 1; 1, -1]; B = [0;1]; Tf = 10; T_run = 10;

% Find S(t)
[t2, S] = ode45( @(t2, S)riccati(t2, S , Q, B, R, A ), [Tf 0], [Qf(1,1); Qf(1,2); Qf(2,1); Qf(2,2)] );

figure(4)
plot(t2(:,1), S(:,1:4));

% find optimal gain
for i =1:size(t2,1)
    k_opt(i,1:2) = R^(-1)*transpose(B)*[S(i,1), S(i,2); S(i,3), S(i,4)]/2;
end

% plot response
[t1,y1] = ode45(@(t1,y1)opt_pend(t1,y1, m,g,l, b, k_opt, t2),[0 T_run],[0; 0.6]);
figure(5)
plot(y1(:,1), y1(:,2),'-x')
grid on
hold on

% interpolate final gain
K_fin = interp1(t2, k_opt, t1(end,1));

for i=1:length(theta)
    for j=1:length(theta_dot)
        x_vect(i,j) = theta_dot(j);
        y_vect(i,j) = ( -K_fin*[theta(i); theta_dot(j)] - b*theta_dot(j) + m*g*l*theta(i) )/(m*l^2) ; 
    end
end

[X,Y] = meshgrid(theta,theta_dot);
quiver( transpose(X), transpose(Y) , x_vect, y_vect,3.5 )