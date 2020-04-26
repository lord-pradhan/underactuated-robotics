function dydt = opt_pend(t,y, k_opt, t2)

K_int = interp1(t2,k_opt,t);
dydt = [y(2); ( -K_int*[y(1); y(2)] - y(2) - y(1) ) ];

end
% function T_dot=f_mass(t,T,u, ut)
% f = interp1(ut,u,t);
% T_dot=(1-f)*T;
% end