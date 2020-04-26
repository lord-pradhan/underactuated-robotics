function cost = obj_fn(u)

% cost=0;
% for i = 1:size(u,2)-1
%     cost = cost+ (u(1,i)/2+u(1,i+1)/2)^2;
% end

cost = u(1,:)*u(1,:)';

end