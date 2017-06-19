%%
global Hqp_fixpoint fqp_fixpoint

wl = wl + ceil(log(max(max(abs(Hqp))))/log(2));
T.WordLength = wl;
Hqp_fixpoint = fi(Hqp, T, F);
fqp_fixpoint = fi(fqp, T, F);
wl = wl - ceil(log(max(max(abs(Hqp))))/log(2));
T.WordLength = wl;
ub_fixpoint = fi(ub, T, F);
lb_fixpoint = fi(lb, T, F);
[~, S, ~] = svd(double(Hqp));
alpha = S(1,1);
Halpha = double(Hqp_fixpoint)/alpha;
Halpha_fixpoint = fi(Halpha, T, F);
falpha = double(fqp_fixpoint)/alpha;
falpha_fixpoint = fi(falpha, T, F);

% Solve the fixed point problem exactly using Matlab function
options = optimoptions('quadprog',...
'Algorithm','interior-point-convex','Display','off');
[sol.x, sol.fval, flagexit, sol.output, sol.lambda] = quadprog(...
    double(Hqp_fixpoint), double(fqp_fixpoint), [], [], [], [],...
    double(lb_fixpoint), double(ub_fixpoint), [], options);
if flagexit ~= 1
    fprintf('Formulated problem cannot be exactly solved by Matlab!\n')
end

% % Test error behavior
% err_tst = norm(double(Halpha_fixpoint * ub_fixpoint) ...
%     - double(Halpha_fixpoint)*double(ub_fixpoint));
% bound_error_tst = sqrt(num_decision) * (num_decision * err_unit);

% % Estimate error bound of GP algorithm based on existing result
max_z_entry = max([max(abs(double(ub_fixpoint))), max(abs(double(lb_fixpoint)))]);
delta = alpha * sqrt(num_decision) * ( num_decision *  (max_z_entry + 1) + 1) * err_unit;
