function [ c, ceq ] = func_simp( u, X_0, X_f, dt )

N = size(u,2);
n_st = size(u,1)-1;
ceq = zeros( n_st*(N+1) +2 ,1 );
ceq(1:n_st , 1) = u(2:end, 1) - X_0;
ceq( end-2-(n_st-1) : end-2 , 1 ) = u(2:end, end) - X_f;
ceq( end-1:end,1) = [u(1,1); u(1,end)];

for i =1:N-1
    ceq( n_st*(i)+1 : n_st*(i+1) ) = u(2:end, i) - u(2:end,i+1) ...
        + dt/6*( simp_pend(u(2:end,i), u(1,i)) + simp_pend(u(2:end,i+1), u(1,i+1)) + ...
        4*( simp_pend( (u(2:end,i)+u(2:end,i+1))/2 , (u(1,i)+u(1,i+1))/2 )  ));
    
end

c=[];
end