%the func gets 2 vectors whitch it 2 row in the frecuncy matrix
%the func calculte the distance between them by the formula of sperman rho 
function [r] = spearman_calc(x,y)
sum = 0;
for i=1:size(x,2)
    sum = sum + (x(i) - y(i)).^2;
end
r = 6*sum;
n = size(x,2);
m = n*(n.^2 - 1);
r = r/m;
r = 1 - r;
end