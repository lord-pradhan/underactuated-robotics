function [ c, ceq ] = func( u, X_0, X_f, dt )

N = size(u,2);
n_st = size(u,1)-1;
ceq = zeros( n_st*(N+1) +2 ,1 );
ceq(1:n_st , 1) = u(2:end, 1) - X_0;
ceq( end-2-(n_st-1) : end-2 , 1 ) = u(2:end, end) - X_f;
% ceq( end-1:end,1) = [0; u(1,end)];

for i =1:N-1
    
    x_c = 1/2*( u(2:end,i) + u(2:end,i+1) ) + dt/8 * ( dyn_fn(u(2:end,i),u(1,i)) - dyn_fn(u(2:end,i+1),u(1,i+1)) );
    u_c = (u(1,i)+u(1,i+1))/2;
    ceq( n_st*(i)+1 : n_st*(i+1) ) = u(2:end, i) - u(2:end,i+1) ...
        + dt/6*( dyn_fn(u(2:end,i), u(1,i)) + dyn_fn(u(2:end,i+1), u(1,i+1)) + ...
        4*( dyn_fn( x_c, u_c )));
    
end

c=[];
end