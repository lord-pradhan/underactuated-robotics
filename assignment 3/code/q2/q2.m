%% q2 script
%Author - Roshan Pradhan

clc
clear
close all

%% Initialise
dt=0.1; N = 51;
u0=zeros(1,N); x0 = zeros(4,N); u_in = [u0; x0];
X_f = [0; pi; 0; 0]; X_0 = [0; 0;0 ; 0];
lb = [-5*ones(1,N); -Inf*ones(4,N)]; ub = [5*ones(1,N); Inf*ones(4,N)];

A =[]; b=[]; Aeq=[]; beq=[];

% [c, ceq] = func(u0, X_0, X_f, dt);
nonlcon = @(u)func(u, X_0, X_f, dt);
fun = @(u)obj_fn(u);

options =optimoptions(@fmincon,'TolFun',0.00000001,'MaxIter' ,10000,... 
    'MaxFunEvals',100000,'Display','iter',... 
    'DiffMinChange',0.001,'Algorithm','sqp');

u = fmincon(fun, u_in, A, b, Aeq, beq, lb, ub, nonlcon , options);

figure(1)
plot(0,0)
axis equal
for i = 1:N
    line([u(2,i), u(2,i) + sin(u(3,i))], [0, -cos(u(3,i))])
    hold on
    plot(u(2,i),0,'rx')
    axis([-5 5 -5 5])
    grid on
    pause(0.07)
%     clf
end

figure(2)
plot( 0:dt:(N-1)*dt, u(1,:), 'LineWidth', 1.5)
axis([0 4.9 -Inf Inf])
grid on
title('Control action over time')
xlabel('Time')
ylabel('Control input (Horizontal Force)')