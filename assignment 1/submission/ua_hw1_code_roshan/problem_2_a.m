%% Problem 2_a
%Author - Roshan Pradhan
clear 
close all
clc

m=1; l=1; g=9.8; i=1;j=1; 
b=0;%.25; 
u=0;%g/(2*l);

theta= -2*pi:0.01:2*pi; theta_dot = -2*g/l:0.01:2*g/l;
x_vect=[]; y_vect = []; X_end =[]; 
% slope=zeros(length(theta),length(theta_dot));


% Basin of attraction
warning('off') % To off the warning which shows "Matrix is close to singular 
               % badly scaled" when algorithm passes through a point where the Jacobian
               % matrix is singular
% The roots of the given governing equations
r1 = [-2*pi ;0] ;
r2 = [-pi ;0] ;
r3 = [0 ;0] ;
r4 = [pi; 0];
r5 = [2*pi; 0];

Xr1=[]; Xr2=[]; Xr3=[]; Xr4 = []; Xr5 = []; Xr6=[];

for i=1:length(theta)
    for j=1:length(theta_dot)
%         slope(i,j) = u/(m*l^2*theta_dot(j))-(g/l)*sin(theta(i))/theta_dot(j) - b/(m*l ^2);
%         x_vect(i,j) = theta_dot(j);
%         y_vect(i,j) = (u-b*theta_dot(j)-m*g*l*sin(theta(i)))/(m*l^2);
        X0 = [theta(i); theta_dot(j)];
        [t,y] = ode45(@(t,y)ode_solver(t,y, u, m, l, b, g),[0 100],[theta(i); theta_dot(j)]);
%         X_end(i, j) = y(1,end);
%         X_dot_end(i,j) = y(2,end);
        X_vect_end = [y(end,1);  y(end,2)];
        
        % Locating the initial conditions according to error
        if norm(X_vect_end -r1)<1e-3
            Xr1 = [X0 Xr1]  ;
        elseif norm(X_vect_end - r2)<1e-3
            Xr2 = [X0 Xr2] ;
        elseif norm(X_vect_end - r3)<1e-3
            Xr3 = [X0 Xr3] ;
        elseif norm(X_vect_end - r4)<1e-3
            Xr4 = [X0 Xr4];
        elseif norm(X_vect_end - r5)<1e-3
            Xr5 = [X0 Xr5];
            
        % if not close to any of the roots
        else               
            Xr6 = [X0 Xr6] ;
        end
    end
end


warning('on') % Remove the warning off constraint
% Initialize figure
figure
set(gcf,'color','w') 
hold on
plot(Xr1(1,:),Xr1(2,:),'.','color','r') ;
plot(Xr2(1,:),Xr2(2,:),'.','color','b') ;
plot(Xr3(1,:),Xr3(2,:),'.','color','g') ;
plot(Xr4(1,:),Xr4(2,:),'.','color','c') ;
plot(Xr5(1,:),Xr5(2,:),'.','color','y') ;
plot(Xr6(1,:),Xr6(2,:),'.','color','k') ;
title('Basin of attraction for b = 0, u = 0')



% [X,Y] = meshgrid(theta,theta_dot);
% x_vect = theta_dot;
% y_vect = (u-b.*theta_dot-m*g*l.*sin(theta))./(m*l^2);


% quiver( transpose(X), transpose(Y) , x_vect, y_vect,20)
% hold on
% plot(pi/6,0,'r*')
% % plot(0,0,'r*', pi,0, 'b*', -pi, 0, 'k*', 2*pi, 0, 'g*', -2*pi, 0, 'c*')
% grid on


