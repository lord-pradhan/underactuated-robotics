%% q1 script
%Author - Roshan Pradhan

clear
close all
clc

%% Initialise
dt=0.025; N = 201; 
u0=zeros(1,N); X_f = [pi; 0]; X_0 = [0; 0];
lb = -2*ones(1,N); ub = 2.41*ones(1,N);

A = []; b=[]; Aeq=[]; beq=[];

% [c, ceq] = func(u0, X_0, X_f, dt);
nonlcon = @(u) func(u, X_0, X_f, dt);
fun = @(u) dot(u,u);

options =optimoptions(@fmincon,'TolFun',0.00000001,'MaxIter' ,10000,... 
    'MaxFunEvals',100000,'Display','iter',... 
    'DiffMinChange',0.001,'Algorithm','sqp');

u = fmincon(fun, u0, A, b, Aeq, beq, lb, ub, nonlcon , options);

figure(1)
plot(u)
title('Control action vs time step')
axis([0 201 -Inf Inf])
grid on
xlabel('Theta')
ylabel('Angular velocity')

%% plot state
X_calc = zeros(2,N);
X_calc(:,1) = X_0;
for i = 2:N
    X_calc(:,i) = X_calc(:,i-1)+ ...
        dt*( [X_calc(2,i-1) ; u(1,i-1) - X_calc(2,i-1) - sin(X_calc(1,i-1)) ] );
end

figure(2)
plot(X_calc(1,:), X_calc(2,:))
grid on
hold on
plot(pi,0,'rx')
title('Trajectory in phase-space')
xlabel('Theta')
ylabel('Angular velocity')