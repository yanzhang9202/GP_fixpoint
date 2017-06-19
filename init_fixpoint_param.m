%% wl and fl are set in the previous problem statement matlab file
wl = fl + 3;
% Set fixed point arithmetic rule
F = fimath('OverflowAction', 'Saturate', 'RoundingMethod', 'Nearest', ...
    'ProductMode', 'SpecifyPrecision', 'ProductFractionLength', fl, ...
    'ProductWordLength', wl, 'SumMode', 'SpecifyPrecision', ...
    'SumFractionLength', fl, 'SumWordLength', wl);
% Set fixed point data type
T = numerictype('WordLength', wl, 'FractionLength', fl, 'Signed', 1);

% Calculate error bound
err_unit = 1/2^fl/2;    % According to "Nearest" Rounding method