% Constrained-MPC parameter
N = 2; % Horizon
nx = 2; % State dimension
nu = 1; % Control dimension
Q = [10, 0; 0, 1];    % Energy cost
R = 1;
Qn = Q;
Ad = [1, 0.01; 0, 1];    % State dynamics
Bd = [-0.0004; -0.0701];
lim_x = [-0.2, 0.01; -0.1, 0.1];    % Box Constraints
lim_u = [-0.0524, 0.0524];
x0 = [-0.15; 0.05];  % Starting state
% x0 = [0.009; 0.09];
% Build QP problem out of MPC
dim_z = (N+1)*nx + N*nu;    % Dimension of the stacked variable
H = zeros(dim_z);
H(1:(N+1)*nx, 1:(N+1)*nx) = kron(eye(N+1), Q);
H(((N+1)*nx+1):end,((N+1)*nx+1):end) = kron(eye(N), R);
f = zeros(dim_z, 1);
Aeq = [zeros(nx, dim_z); kron(-eye(N), Ad), zeros(N*nx, nx), kron(-eye(N), Bd)];
Aeq = Aeq + [eye((N+1)*nx), zeros((N+1)*nx, N*nu)];
beq = [x0; zeros(N*nx, 1)];
ub = [kron(ones(N+1, 1), lim_x(:,2)); kron(ones(N,1), lim_u(2))];
lb = [kron(ones(N+1, 1), lim_x(:,1)); kron(ones(N,1), lim_u(1))];
num_constraints = size(Aeq, 1);
num_decision = size(Aeq, 2);

% Pick any lambda
rng(101);
lambda = rand(num_constraints,1);

rho = 1;

% QP (inner) problem parameter
Hqp = H + rho * Aeq' * Aeq;
fqp = f + Aeq' * lambda - rho * Aeq' * beq;
[~, S, ~] = svd(Hqp);
alpha = S(1,1);
Halpha = Hqp/alpha;
falpha = fqp/alpha;

% % These two lines will be used in dual method
% % (when multiplier is being updated)

% Aeqalpha = Aeq'/alpha;    
% [~, SA, ~] = svd(Aeqalpha);

% Decide word length and fraction length of x
max_z_entry = max([max(abs(lim_x)), max(abs(lim_u))]);
range_z = 2 * max_z_entry + max(abs(falpha));

% % Observe the lowest absolute values in entries in Halpha and falpha to
% % decide fraction length
fl_max = ceil(log(1/(min([min(min(abs(Halpha(Halpha ~= 0)))), min(abs(falpha(falpha ~= 0)))])))/log(2));
fl = fl_max;

% % Since range_z is smaller than 1, set wordlength = fractionlength + 1 (signedness bit)
% % However, it's even possible to set wordlength smaller than fraction
% % length because range_z spans interval smaller than [-1, 1]
wl = fl + 1;
