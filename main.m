%% Test Gradient Projection method under fixed point arithmetic
clear;
close all;
clc;
global do_display_proj

%% Initiate paramter
init_problem_param = 'MPC';
init_problem;

%% Run Gradient Projected Algorithm under fixed point arithmetic
% Assign paramters
iter_max = 1e3;
x_prev = fi(zeros(num_decision, 1), T, F);
x_inv = fi(zeros(num_decision, 1), T, F);

x = zeros(num_decision, iter_max);
x_avg = zeros(num_decision, iter_max);
x(:,1) = x_prev;
x_avg(:,1) = x_prev;
feval_avg = zeros(iter_max,1);
feval_avg(1) = calc_feval(x_avg(:,1));
feval = zeros(iter_max,1);
feval(1) = calc_feval(x(:,1));
% Run algorithm
do_display_proj = 0;
for ii = 2 : iter_max
   % Gradient Descent
   x_inv = x_prev - Halpha_fixpoint * x_prev - falpha_fixpoint;
   % Apply projection
   x_inv = calc_proj_fixpoint(x_inv, lb_fixpoint, ub_fixpoint); 
   % Calculate time-average of decision variable and objective value
   x(:,ii) = double(x_inv);
   x_avg(:,ii) = ((ii-1)*x_avg(:,ii-1) + double(x_inv))/ii;
   feval(ii) = calc_feval(x(:,ii));
   feval_avg(ii) = calc_feval(x_avg(:,ii));
   % Prepare next iteration
   x_prev = x_inv;
end
% Plot result
makeplot;
