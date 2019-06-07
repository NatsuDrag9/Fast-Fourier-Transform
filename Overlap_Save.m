%% Overlap Save Method
clear all;
close all;

%% Inputs
x1_n = input('Enter first signal : ');
x2_n = input('Enter second signal : ');
N = input('Enter N for N-point circular convolution : ');
M = min(length(x1_n),length(x2_n));

%% Zero padding in x1[n]
x1_n_pad = [zeros(1, M-1), x1_n, zeros(1, M-1)];
if length(x2_n) < N
    x2_n_pad = [x2_n, zeros(1, N-length(x2_n))];
end

% Length
N_pad = length(x1_n_pad) - (M-1);

%% Number of blocks
n_blocks = (N_pad)/(N-M+1);

if  floor(n_blocks) ~= n_blocks
    n_blocks = ceil(n_blocks);
end

%% Block and output matrix
x_rn = zeros(n_blocks, N);
temp = x1_n_pad(1:N);
k = 1;
while k <= n_blocks
    x_rn(k, 1:N) = temp;
    index = find(x1_n_pad == temp(N-1));
    temp = x1_n_pad(index:index+N-1);
    k = k+1;
end
y_rn = zeros(n_blocks, N);

%% Circular Convolution
for k = 1:n_blocks
    for n = 0:N-1
        y_rn(k, n+1) = 0;
        for m = 0:length(x2_n_pad)-1
            if n-m>=0
                y_rn(k, n+1) = y_rn(k, n+1) + x_rn(k, m+1)*x2_n_pad(n-m+1);
            elseif n-m<0
                y_rn(k, n+1) = y_rn(k, n+1) + x_rn(k, m+1)*x2_n_pad(length(x2_n_pad) + n-m+1);
            end
        end
    end
end

% Output
a = 1;
y_n = zeros(n_blocks, N-M+1);
while a <= n_blocks
    y_n(a, 1:N-M+1) = y_rn(a, M:N);
    a = a+1;
end
y_n = reshape(y_n', 1, n_blocks*(N-M+1));

%% Plots and display
disp(y_n);
figure(1);
subplot(3, 1, 1);
stem(x1_n);
title('Input Sequence - x[n]');
xlabel('n');
ylabel('x[n]');

subplot(3, 1, 2);
stem(x2_n);
title('Impulse Response - h[n]');
xlabel('n');
ylabel('h[n]');

subplot(3, 1, 3);
stem(y_n);
title('Convoluted Sequence - y[n] = x[n] * h[n]');
xlabel('n');
ylabel('y[n]');