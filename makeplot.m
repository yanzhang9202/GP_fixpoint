fig = 1;
% Plot Optimality of Objective
figure(fig)
hold on;
ax = gca;
% Optimal value
% h1 = plot(repmat(sol.fval, 1, iter_max), 'g-');
% Theoretical bound
feval_bound = zeros(1, iter_max);
for ii = 1 : iter_max
   feval_bound(ii) = alpha*(2*max_z_entry)^2/2/(ii+1) + delta;  
end
h2 = plot(feval_bound, 'b-');
% Actual performance
h3 = plot(feval - sol.fval, 'm-');
h4 = plot(feval_avg - sol.fval, 'r-');
legend([h2, h3, h4], 'Theoretical bound', 'Optimality of decision var',...
    'Optimality of time-averaged decision var');
title('Optimality of Objective, GP under fixed point arithmetic')
set(ax,'YScale','log');
grid on;
hold off;
fig = fig + 1;