function dydt = riccati_S1(t, y , Q,  R, t_open, x_current, u_current, t2, S2, t_desired, x_desired, u_desired)

x_0 = interp1(t_open', x_current', t);
x_d = interp1(t_desired', x_desired', t);

u_0 = interp1(t_open', u_current', t);
u_d = interp1(t_desired', u_desired', t);

A = [0,1; -cos(x_0(1,1)) , -1/4];
B = [0;1];

S2_int = interp1(t2, S2, t);
S2_temp = [S2_int(1), S2_int(2); S2_int(3), S2_int(4)];

S1 = [y(1);y(2)];

dydt = -( -2*Q*(x_d' - x_0') + (A' - S2_temp*B*R^(-1)*B')*S1 + 2*S2_temp*B*(u_d - u_0) );

end