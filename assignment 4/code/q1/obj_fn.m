function cost = obj_fn(u, X_f_des)

cost=0;
for i = 1:size(u,2)-1
    cost = cost+ (u(1,i)/2+u(1,i+1)/2)^2 + ...
        ( u(2:end, i)/2 + u(2:end, i+1)/2 )'*( u(2:end, i)/2 + u(2:end, i+1)/2 ) ;

%     cost = cost + (u(1,i)/2+u(1,i+1)/2)^2 + ( ( u(2:end, i)/2 + u(2:end, i+1)/2 ) - X_f_des )'*( ( u(2:end, i)/2 + u(2:end, i+1)/2 ) - X_f_des );
end

end