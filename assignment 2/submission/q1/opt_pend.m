function dydt = opt_pend(t,y, m,g,l, b, k_opt, t2)

K_int = interp1(t2,k_opt,t);
dydt = [y(2); ( -K_int*[y(1); y(2)] - b*y(2) + m*g*l*y(1) )/(m*l^2) ];

end
% function T_dot=f_mass(t,T,u, ut)
% f = interp1(ut,u,t);
% T_dot=(1-f)*T;
% end