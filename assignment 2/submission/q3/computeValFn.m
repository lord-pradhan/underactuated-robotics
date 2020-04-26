function [J_current, policy_mat] = computeValFn( J_next, x, x_dot, u_vect, dt, x_d, Q, R)

% initialise matrices
J_temp = zeros(1,length(u_vect)); J_current = zeros(length(x),length(x_dot)); policy_mat = zeros(length(x),length(x_dot));


for i = 1:length(x_dot)
    for j = 1:length(x)
        count_u = 1; 
        for u = drange(u_vect) % search in actuation space
            
            if x(j)<0
                inst_cost = transpose( [x(j);x_dot(i)] - x_d(:,1) )* Q * ( [x(j);x_dot(i)] - x_d(:,1) ) + R*u*u;
            else 
                inst_cost = transpose( [x(j);x_dot(i)] - x_d(:,2) )* Q * ( [x(j);x_dot(i)] - x_d(:,2) ) + R*u*u;
            end
            
            X_next =  [x(j);x_dot(i)] + dt*( [x_dot(i); -x_dot(i)-sin(x(j)) + u] );
            x_next = X_next(1,1); x_dot_next = X_next(2,1);
            
            % find discretised indices
            if x_next >= x(end)
                j_snap = length(x);
                x_next = x(end);
                
            elseif x_next <= x(1)
                j_snap = 1;
                x_next = x(1);
                
            else
                j_snap = find(~(x<x_next),1)-1;
            end

            if x_dot_next >= x_dot(end)
                i_snap = length(x_dot);
                x_dot_next = x_dot(end);
                
            elseif x_dot_next <= x_dot(1)
                i_snap = 1;
                x_dot_next = x_dot_next(1);
                
            else
                i_snap = find(~(x_dot<x_dot_next),1)-1;                 
            end
            
            % find interpolation ratios
            alpha1 = 1- (x_next - x(j_snap))/( x(2)-x(1) );
            alpha2 = 1- (x_dot_next - x_dot(i_snap))/( x_dot(2)-x_dot(1) );
            
            
            if i_snap==length(x_dot) && j_snap~=length(x)
                J_next_cost = alpha1*alpha2*J_next(i_snap,j_snap) + alpha2*(1-alpha1)*J_next(i_snap,j_snap+1);
                        
            elseif i_snap~=length(x_dot) && j_snap== length(x)
                J_next_cost = alpha1*alpha2*J_next(i_snap,j_snap) + alpha1*(1-alpha2)*J_next(i_snap+1,j_snap);
                        
            elseif i_snap==length(x_dot) && j_snap== length(x)
                J_next_cost = alpha1*alpha2*J_next(i_snap,j_snap) ;
                        
            else 
                J_next_cost = alpha1*alpha2*J_next(i_snap,j_snap) + alpha1*(1-alpha2)*J_next(i_snap+1,j_snap) + ...
                            alpha2*(1-alpha1)*J_next(i_snap,j_snap+1) + (1-alpha1)*(1-alpha2)*J_next(i_snap+1, j_snap+1) ;
            end
                        
            J_temp(count_u) = inst_cost + J_next_cost;
            count_u = count_u+1;
        end

        J_current(i,j) = min(J_temp);
        policy_mat(i,j) = u_vect(J_temp==J_current(i,j));
    end
end


end