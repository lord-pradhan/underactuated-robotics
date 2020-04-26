%% Problem 2
%Author - Roshan Pradhan

clc
close all
clear

%% initialise
i_init=7; j_init=8; N = 15;
J = ones(N,N,1); J(i_init, j_init,1)=0;
count = 1; loc_i = 7; loc_j = 8;
list_row = [loc_i,loc_j]; list_col = [loc_i, loc_j];
update_mat = ones(N,N); update_mat(loc_i, loc_j)=0;

%% form update matrix
while any(any(update_mat))
    list_row =  [ [list_row(1,1),list_row(1,2)-1] ; list_row; [list_row(end,1),list_row(end,2)+1] ];
    list_col =  [ [list_col(1,1)-1,list_col(1,2)] ; list_col; [list_col(end,1)+1,list_col(end,2)] ];
    
    if count>1
        UR_col = transpose(list_col(1,2)+1:list_row(end,2)-1); UR_row = transpose(list_col(1,1)+1:list_row(end,1)-1);
        UR = [UR_row, UR_col];

        LR_col = transpose(list_col(end,2)+1:list_row(end,2)-1); LR_row = transpose(list_col(end,1)-1 : -1 : list_row(end,1)+1);
        LR = [LR_row, LR_col];

        UL_col = transpose(list_col(1,2)-1 : -1 : list_row(1,2)+1) ; UL_row = transpose(list_col(1,1)+1 : list_row(1,1)-1);
        UL = [UL_row, UL_col];

        LL_col = transpose(list_col(end,2)-1: -1 :list_row(1,2)+1); LL_row = transpose(list_col(end,1)-1: -1 :list_row(1,1)+1);
        LL = [LL_row, LL_col];

        zero_ind = [ list_row(1,:); list_row(end,:); list_col(1,:); list_col(end,:); UR; UL; LL; LR ];
        
    else        
        zero_ind = [list_row(1,:); list_row(end,:); list_col(1,:); list_col(end,:)];
        
    end
    
    for i=1:size(zero_ind,1)
        
        if zero_ind(i,1)<1 || zero_ind(i,1)>N || zero_ind(i,2)>N || zero_ind(i,2)<1
            
        else
            update_mat(zero_ind(i,1),zero_ind(i,2))=0;           
        end
    end
    
    update_3dmat(:,:,count)=update_mat(:,:);
    count=count+1;
end

figure(1)
h = heatmap(J(:,:,1));

pause(0.5);
%% Value iteration
for k=1:count-1
    
    J(:,:,k+1) = J(:,:,k)+update_3dmat(:,:,k); 
    figure(1)
    h = heatmap(J(:,:,k+1));
    
    pause(0.5);
 
end
