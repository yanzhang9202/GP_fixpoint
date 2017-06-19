function [ feval ] = calc_feval( x )
global Hqp_fixpoint fqp_fixpoint
Hqp = double(Hqp_fixpoint);
fqp = double(fqp_fixpoint);
feval = 1/2 * x' * Hqp * x + fqp' * x;
end