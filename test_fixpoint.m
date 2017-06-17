%% Display format
originalFormat = get(0, 'format');
format loose
format long g
% Capture the current state of and reset the fi display and logging
% preferences to the factory settings.
fiprefAtStartOfThisExample = get(fipref);
reset(fipref);

%% Default fix point setting
a = fi(pi);
b = fi(0.1);
% Practice: why given word length 16, matlab chooses fraction length 18 to
% represent 0.1?

%% Specify signed/unsigned and word length property
% Signed 8-bit
a = fi(pi, 1, 8);
a1 = sfi(pi,8);

% Unsigned 20-bit
b = fi(exp(1), 0, 20);
b1 = ufi(exp(1), 20);

% Precision
a = ufi(0.1, 40);
b = a * a;

% Transformation between data types
a = fi(pi);
double(a);
a.double = exp(1);

%% Specify fraction length
a = sfi(10,16,0); 
b = sfi(10,16);

% Practice: what will happen if fraction length is misproperly set.
a = fi(2.1, 1, 16, 14);
% Answer: No error message. Saturation happens. a.int = 2^15-1;
b = fi(2.1, 1, 16, 13);

%% Specify properties uising "numerictype"
T = numerictype;
T = numerictype('WordLength',40,'FractionLength',37);
T.Signed = false;
a = fi(pi,'numerictype',T);
b = fi(exp(1),'numerictype',T);
a1 = fi(pi,T);

%% Retrieve original display format
% Reset the fi display and logging preferences
fipref(fiprefAtStartOfThisExample);
set(0, 'format', originalFormat);

%% %% Perform Fixed Point Arithmetic
warnstate = warning;
%% Addition
% Addition between unsigned numbers, same scaling
a = ufi(0.234375,4,6);
c = a + a;

% Addition between signed numbers, same scaling
a = sfi(0.078125,4,6);
b = sfi(-0.125,4,6);
c = a + b;

% Addition between numbers with different scaling
a = sfi(pi,16,13);
b = sfi(0.1,12,14);
c = a + b;
% Practice: explain the word/fraction length property chosen by matlab.

% Scalar summation in a loop
s = rng; rng('default');
b = sfi(4*rand(16,1)-2,32,30);
rng(s); % restore RNG state
Nadds = length(b) - 1;
temp  = b(1);
for n = 1:Nadds
    temp = temp + b(n+1); % temp has 15 more bits than b
end

c = sum(b); % c has 4 more bits than b

%% Multiplication
a = sfi(pi,20);
b = sfi(exp(1),16);
c = a * b;

%% Assignment
N = 10;
a = sfi(2*rand(N,1)-1,16,15);
a(1) = 1;
% a(1) = 1 - 2^(-15);
b = sfi(2*rand(N,1)-1,16,15);
b(1) = -1;
% b(1) = -1 + 2^(-15);
c = sfi(zeros(N,1),16,14);
for n = 1:N
    c(n) = a(n).*b(n);
%     checkSat(c(n));
end

% Explicit quantization during computation

