%% q1- open loop
%Author- Roshan Pradhan
% This script runs the direct collocation for open and closed loop and
% saves to workspace

clc 
clear
close all

%% Part a
dt=0.1; N = 100;
u0_des=zeros(1,N); x0_des = zeros(2,N); u_in_des = [u0_des; x0_des];
X_f_des = [-pi; 0]; X_0_des = [0; 0];
lb_des = [-1.5*ones(1,N); -Inf*ones(2,N)]; ub_des = [1.5*ones(1,N); Inf*ones(2,N)];

A_des = []; b_des=[]; Aeq_des=[]; beq_des=[];

nonlcon_des = @(u) func_aug(u, X_0_des, X_f_des, dt);
fun_des = @(u) obj_fn(u, X_f_des);

options =optimoptions(@fmincon,'TolFun',0.00000001,'MaxIter' ,10000,... 
    'MaxFunEvals',100000,'Display','iter',... 
    'DiffMinChange',0.001,'Algorithm','sqp');

u_des = fmincon(fun_des, u_in_des, A_des, b_des, Aeq_des, beq_des, lb_des, ub_des, nonlcon_des , options);

%% Part b
dt=0.1; N = 100; 
u0_nom=zeros(1,N); x0_nom = zeros(2,N); u_in_nom = [u0_nom; x0_nom];
X_f_nom = [pi; 0]; X_0_nom = [0; 0];
lb_nom = [-1.5*ones(1,N); -Inf*ones(2,N)]; ub_nom = [1.5*ones(1,N); Inf*ones(2,N)];

A_nom = []; b_nom=[]; Aeq_nom=[]; beq_nom=[];

% [c, ceq] = func(u0, X_0, X_f, dt);
nonlcon_nom = @(u) func_simp(u, X_0_nom, X_f_nom, dt);
fun_nom = @(u) obj_fn(u, X_f_nom);

options =optimoptions(@fmincon,'TolFun',0.00000001,'MaxIter' ,10000,... 
    'MaxFunEvals',100000,'Display','iter',... 
    'DiffMinChange',0.001,'Algorithm','sqp');

u_nom = fmincon(fun_nom, u_in_nom, A_nom, b_nom, Aeq_nom, beq_nom, lb_nom, ub_nom, nonlcon_nom , options);

save('open_loop_traj.mat')