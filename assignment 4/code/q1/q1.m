%% q1 script
%Author - Roshan Pradhan

clc
clear
close all

%% Load desired and nominal trajectories
load('open_loop_traj.mat')

%% Plots
figure(1)
plot(0,0, -pi, 0)
axis equal
for i = 1:N
    line([0, sin(u_des(2,i))], [0, -cos(u_des(2,i))])
    hold on
    axis([-2 2 -2 2])
    grid on
    pause(0.03)
    clf
    title('Animation for augmented pendulum')
    xlabel('Angle')
    ylabel('Angular velocity')
end

figure(2)
plot(u_des(2,:) , u_des(3,:))
grid on
title('Desired Traj')
xlabel('Angle')
ylabel('Angular velocity')


figure(3)
plot( 0:dt:(N-1)*dt, u_des(1,:), 'LineWidth', 1.5)
axis([0 N*dt -Inf Inf])
grid on
title('Desired Control action over time')
xlabel('Time')
ylabel('Control input')

figure(4)
plot(0,0, -pi, 0)
axis equal
for i = 1:N
    line([0, sin(u_nom(2,i))], [0, -cos(u_nom(2,i))])
    hold on
    axis([-2 2 -2 2])
    grid on
    pause(0.03)
    clf
    title('Animation for simple pendulum')
    xlabel('Angle')
    ylabel('Angular velocity')
end

figure(5)
plot(u_nom(2,:) , u_nom(3,:))
grid on
title('Nominal Traj')
xlabel('Angle')
ylabel('Angular velocity')

figure(6)
plot( 0:dt:(N-1)*dt, u_nom(1,:), 'LineWidth', 1.5)
axis([0 N*dt -Inf Inf])
grid on
title('Nominal control action over time')
xlabel('Time')
ylabel('Control input')

% plot nominal and desired traj together
figure(7)
plot( u_des(2,:) , u_des(3,:) , 'r--' , u_nom(2,:) , u_nom(3,:) , 'k' )
grid on
xlabel('Angle')
ylabel('Angular velocity')
legend('Desired Trajectory', 'Nominal Trajectory')


%% solve ricatti equations
Q = 50*eye(2); R = 1; Qf = eye(2);
Tf = dt*(N-1); T_run = dt*(N-1);
B = [0;1];

t_open = 0:dt:dt*(N-1); x_open = u_nom(2:3,:) ; u_open = u_nom(1,:);
t_desired = 0:dt:dt*(N-1); x_desired = u_des(2:3,:) ; u_desired = u_des(1,:);

t_current = t_open; x_current = x_open;  u_current = u_open;

%% run iterations

for i_ct = 1:5
    
    x_prev = x_current; u_prev = u_current;
    S2_fin = Qf;
    % Find S2(t)
    [t2, S2] = ode45( @(t2, S2)riccati_S2(t2, S2 , Q,  R, t_current, x_current, u_current ), [Tf 0], [S2_fin(1,1); S2_fin(1,2); S2_fin(2,1); S2_fin(2,2)] );
    
    % interpolate S2 onto grid
    for i = 1:4
        S2_grid(:,i) = (interp1( t2', S2(:,i)', t_current ))';
    end
    
    % feed-back gain
    for i =1:length(t_current)
        k_fb(i,1:2) = R^(-1)*transpose(B)*[S2_grid(i,1), S2_grid(i,2); S2_grid(i,3), S2_grid(i,4)];
    end
    
    % Find S1(t)
    S1_fin = -2*Qf*( x_desired(:,end) - x_current(:,end) );
    [t1, S1] = ode45( @(t1, S1)riccati_S1(t1, S1 , Q,  R, t_current, x_current, u_current, t2,S2, t_desired, x_desired, u_desired), [Tf 0], S1_fin );
    
    % interpolate S1 onto grid
    for i = 1:2
        S1_grid(:,i) = (interp1( t1', S1(:,i)', t_current ))';
    end
    
    % feed-forward gain
    for i =1:length(t_current)
        k_ff(i,1) = R^(-1)*transpose(B)*[S1_grid(i,1); S1_grid(i,2)]/2;
    end

%     % plot to check Ricatti is solved correctly
%     figure(8)
%     plot(t2(:,1), S2(:,1:4), t1(:,1), S1(:,:));
%     title('Components of S(t) versus time')
    
    % solve for updated nominal traj
    [t3,y3] = ode45( @(t3,y3)simp_pend_opt(t3,y3, k_fb, k_ff, u_desired, t_desired,  x_current, t_current),[0 T_run], x_current(:,1) );
    x_current(1,:) =  interp1(t3(:,1)', y3(:,1)', t_current);
    x_current(2,:) =  interp1(t3(:,1)', y3(:,2)', t_current);
    
    % calculate corresponding control
    for i =1:N
        u_current(1,i) = u_desired(1,i) - k_fb(i,:)*(x_current(:,i)-x_prev(:,i)) - k_ff(i,1);
    end
    
    clear k_fb k_ff t2 S2 t1 S1 t3 y3
end

x_final = x_current; u_final = u_current;

%% post-processing

% plot final traj and desired traj
figure(8)
plot( x_desired(1,:) ,x_desired(2,:) , 'r--' , x_final(1,:), x_final(2,:) , 'k' )
grid on
title('iLQR applied for non-zero desired control')
xlabel('Angle')
ylabel('Angular velocity')
legend('Desired Trajectory', 'Actual Trajectory')

figure(9)
plot( t_current, u_desired , 'r--' , t_current, u_final, 'k' )
grid on
title('iLQR applied for non-zero desired control')
xlabel('Time')
ylabel('Control input')
legend('Desired control','Actual control')

%% part (d) - set desired control to zero

Q = 50*eye(2); R = 1; Qf = eye(2);
Tf = dt*(N-1); T_run = dt*(N-1);
B = [0;1];

t_open = 0:dt:dt*(N-1); x_open = u_nom(2:3,:) ; u_open = u_nom(1,:);
t_desired = 0:dt:dt*(N-1); x_desired = u_des(2:3,:) ; u_desired = zeros(1,N);

t_current = t_open; x_current = x_open;  u_current = u_open;

%% run iterations

for i_ct = 1:5
    
    x_prev = x_current; u_prev = u_current;
    S2_fin = Qf;
    % Find S2(t)
    [t2, S2] = ode45( @(t2, S2)riccati_S2(t2, S2 , Q,  R, t_current, x_current, u_current ), [Tf 0], [S2_fin(1,1); S2_fin(1,2); S2_fin(2,1); S2_fin(2,2)] );
    
    % interpolate S2 onto grid
    for i = 1:4
        S2_grid(:,i) = (interp1( t2', S2(:,i)', t_current ))';
    end
    
    % feed-back gain
    for i =1:length(t_current)
        k_fb(i,1:2) = R^(-1)*transpose(B)*[S2_grid(i,1), S2_grid(i,2); S2_grid(i,3), S2_grid(i,4)];
    end
    
    % Find S1(t)
    S1_fin = -2*Qf*( x_desired(:,end) - x_current(:,end) );
    [t1, S1] = ode45( @(t1, S1)riccati_S1(t1, S1 , Q,  R, t_current, x_current, u_current, t2,S2, t_desired, x_desired, u_desired), [Tf 0], S1_fin );
    
    % interpolate S1 onto grid
    for i = 1:2
        S1_grid(:,i) = (interp1( t1', S1(:,i)', t_current ))';
    end
    
    % feed-forward gain
    for i =1:length(t_current)
        k_ff(i,1) = R^(-1)*transpose(B)*[S1_grid(i,1); S1_grid(i,2)]/2;
    end

%     % plot to check Ricatti is solved correctly
%     figure(8)
%     plot(t2(:,1), S2(:,1:4), t1(:,1), S1(:,:));
%     title('Components of S(t) versus time')
    
    % solve for updated nominal traj
    [t3,y3] = ode45( @(t3,y3)simp_pend_opt(t3,y3, k_fb, k_ff, u_desired, t_desired,  x_current, t_current),[0 T_run], x_current(:,1) );
    x_current(1,:) =  interp1(t3(:,1)', y3(:,1)', t_current);
    x_current(2,:) =  interp1(t3(:,1)', y3(:,2)', t_current);
    
    % calculate corresponding control
    for i =1:N
        u_current(1,i) = u_desired(1,i) - k_fb(i,:)*(x_current(:,i)-x_prev(:,i)) - k_ff(i,1);
    end
    
    clear k_fb k_ff t2 S2 t1 S1 t3 y3
end

x_final = x_current; u_final = u_current;

%% post-processing

% plot final traj and desired traj
figure(10)
plot( x_desired(1,:) ,x_desired(2,:) , 'r--' , x_final(1,:), x_final(2,:) , 'k' )
grid on
title('iLQR applied for zero desired control')
xlabel('Angle')
ylabel('Angular velocity')
legend('Desired Trajectory', 'Actual Trajectory')

figure(11)
plot( t_current, u_desired , 'r--' , t_current, u_final, 'k' )
grid on
title('iLQR applied for zero desired control')
xlabel('Time')
ylabel('Control input')
legend('Desired control','Actual control')