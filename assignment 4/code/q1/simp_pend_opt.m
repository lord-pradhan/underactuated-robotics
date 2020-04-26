function dydt = simp_pend_opt(t ,y , k_fb, k_ff, u_desired, t_desired, x_current, t_current)
 
% K_int = interp1(t2,k_opt,t);
% dydt = [y(2); ( -K_int*[y(1); y(2)] - y(2) - y(1) ) ];

% k_fb_int = interp1(t2, k_fb, t);
% k_ff_int = interp1(t1, k_ff, t);

% y(1) = wrapToPi(y(1));

k_fb_int(1,1) = interp1(t_current', k_fb(:,1)', t);
k_fb_int(1,2) = interp1(t_current', k_fb(:,2)', t);
k_ff_int = interp1(t_current', k_ff', t);

u_d = interp1(t_desired, u_desired, t);
x_0(1,1) = interp1(t_current, x_current(1,:), t);
x_0(2,1) = interp1(t_current, x_current(2,:), t);

u = u_d - k_fb_int*( [y(1);y(2)] - x_0 ) - k_ff_int;

dydt = [ y(2) ; u - 1/4*y(2) - sin(y(1))];

end