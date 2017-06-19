switch init_problem_param
    case 'MPC'
        init_MPC_ballplate_fixpoint;
        % Create fix point data from original problem parameters
        init_fixpoint_param;
        init_create_fixpoint_problem;
    otherwise
        error('Undefined problem!');
end
    