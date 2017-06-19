function [ x ] = calc_proj_fixpoint( x, lb, ub )
global do_display_proj
count = 0;
for ii = find(x < lb)
    x(ii) = lb(ii);
    count = count + 1;
end
for ii = find(x > ub)
    x(ii) = ub(ii);
    count = count + 1;
end
if (count > 0) && do_display_proj
    fprintf('Projection applied!\n')
end
end