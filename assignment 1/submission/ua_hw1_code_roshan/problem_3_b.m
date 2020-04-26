%% Problem 3_b
%Author - Roshan Pradhan
clear
clc
close all

A = [0,1;0,0]; B = [0;1]; C = eye(2); D=0;
Q = 100*eye(2); R = 10;

sys = ss(A,B,C,D);

[K,S,P]=lqr(sys, Q, R);

% phase portrait
x = -1:0.01:1; x_dot = -1:0.01:1;
% u = - K*[x;x_dot];

for i = 1:length(x)
    for j = 1:length(x_dot)
      U(i,j)= -K*[x(i);x_dot(j)];
    end
end
      
% [X,Y]= meshgrid(x,x_dot );
% % U = -K*[X;Y];
% 
% quiver(X,Y,Y, U, 10)

% time response
A_2 = (A-B*K); B_2=[0;0]; C_2=eye(2); D_2 = 0;

sys2 = ss(A_2, B_2, C_2, D_2);
[y_2,t_2,x_2] = initial(sys2, [1;2], 100);
% figure(2)
% plot(x_2(:,1), x_2(:,2))
% grid on

% settling time
N=zeros(length(x_2(:,1)), 1);
N(:,1) = sqrt( x_2(:,1).^2 + x_2(:,2).^2 );
i=1;
while(N(i,1)>0.05)
    i=i+1;
end

T_settling = t_2(i,1);
