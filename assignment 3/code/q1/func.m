function [ c, ceq ] = func( u, X_0, X_f, dt )

N = length(u);
X_calc = zeros(2,N);
X_calc(:,1) = X_0;
for i = 2:N
    X_calc(:,i) = X_calc(:,i-1)+ ...
        dt*( [X_calc(2,i-1) ; u(1,i-1) - X_calc(2,i-1) - sin(X_calc(1,i-1)) ] );
end

ceq = X_f - X_calc(:,end); 
c=[];
end
