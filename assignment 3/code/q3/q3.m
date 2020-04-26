%% Problem 1
%Author - Roshan Pradhan
clear 
close all
clc

%% Shooting method
dt=0.025; N = 201; 
u0=zeros(1,N); X_f = [pi; 0]; X_0 = [0; 0];
lb = -2*ones(1,N); ub = 2.42*ones(1,N);

A = []; b=[]; Aeq=[]; beq=[];

% [c, ceq] = func(u0, X_0, X_f, dt);
nonlcon = @(u) func(u, X_0, X_f, dt);
fun = @(u) dot(u,u);

options =optimoptions(@fmincon,'TolFun',0.00000001,'MaxIter' ,10000,... 
    'MaxFunEvals',100000,'Display','iter',... 
    'DiffMinChange',0.001,'Algorithm','sqp');

u = fmincon(fun, u0, A, b, Aeq, beq, lb, ub, nonlcon , options);


%% plot state
X_calc = zeros(2,N);
X_calc(:,1) = X_0;
for i = 2:N
    X_calc(:,i) = X_calc(:,i-1)+ ...
        dt*( [X_calc(2,i-1) ; u(1,i-1) - X_calc(2,i-1) - sin(X_calc(1,i-1)) ] );
end


%% LQR Time varying
Q = eye(2); R = 1; Qf = eye(2);
Tf = 5; T_run = 5;

B = [0;1];

t_open = 0:dt:dt*(N-1); x_open = X_calc; u_open = u;

% Find S(t)
[t2, S] = ode45( @(t2, S)riccati(t2, S , Q,  R, t_open, x_open, u_open ), [Tf 0], [Qf(1,1); Qf(1,2); Qf(2,1); Qf(2,2)] );

figure(1)
plot(t2(:,1), S(:,1:4));
title('Components of S(t) versus time')

% find optimal gain
for i =1:size(t2,1)
    k_opt(i,1:2) = R^(-1)*transpose(B)*[S(i,1), S(i,2); S(i,3), S(i,4)]/2;
end

% plot response of error
[t1,y1] = ode45(@(t1,y1)opt_pend(t1,y1, k_opt, t2),[0 T_run],[0.5; 0]-X_0);
figure(2)
plot(y1(:,1), y1(:,2),'-x')
grid on
title('Trajectory of error in error-phase-space')
xlabel('Error in theta')
ylabel('Error in angular velocity')

% plot actual response
x_0 = interp1(t_open', x_open', t1);
x_actual = y1+x_0;
figure(3)
plot(x_actual(:,1), x_actual(:,2), 'r--', x_0(:,1), x_0(:,2), '-x')
title('Real traj converging to open-loop traj')
xlabel('theta')
ylabel('angular velocity')
grid on

% plot control
figure(4)
u_0 = interp1(t_open', u_open', t1);
K_int = interp1(t2,k_opt,t1);
u_actual=zeros(size(u_0));
for i = 1:size(u_0,1)
    u_actual(i,1) = u_0(i,1) - K_int(i,:)*y1(i,:)';
end
% u_actual = u_0 - K_int*(y1)';
plot(t1, u_actual(:,1), 'r--', t1 , u_0(:,1), '-x')
title('Actual control converging to open-loop control')
xlabel('theta')
ylabel('angular velocity')
grid on
legend('Actual control', 'Open-loop control')