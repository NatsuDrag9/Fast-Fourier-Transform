%% Overlap Add Method
clear all;
close all;

% Currently assuming length(x1_n) > length(x2_n) and length(x2_n) < N

%% Inputs
x1_n = input('Enter first signal : ');
x2_n = input('Enter second signal : ');
N = input('Enter N for N-point circular convolution : ');
M = min(length(x1_n),length(x2_n));

% Number of blocks
% n_blocks = ceil(max(length(x1_n), length(x2_n))/N); % Taking the length of larger sequence i.e. x[n]
n_blocks = ceil(length(x1_n)/N);

%% Zero padding in x2[n]
x2_n_pad = [x2_n, zeros(1, N+M-1-length(x2_n))];
% if length(x2_n) < N
%     x2_n_pad = [x2_n, zeros(1, N-length(x2_n))];
% end

%% Block and output matrix
x_rn = zeros(n_blocks, N+M-1);  % N columns for N-point circular convolution + (M-1) columns for zero padding
temp = x1_n(1:N);
k = 1;
while k <= n_blocks
    x_rn(k, 1:N) = temp;
    index = find(x1_n == temp(end));
    if index+N > length(x1_n)
        temp1 = x1_n(index+1:end);
        temp = [temp1, zeros(1, N-length(temp1))];
    else
        temp = x1_n(index+1:index+N);
    end
    k = k+1;
end
y_rn = zeros(n_blocks, N+M-1);
% [rows, cols] = size(y_rn);

%% Circular Convolution
for k = 1:n_blocks
    for n = 0:(N+M-1)-1
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

%% Addition of elements
for k = 1:n_blocks
    if k+1 <= n_blocks
        y_rn(k, end-1) = y_rn(k, end-1) + y_rn(k+1, 1);
        y_rn(k, end) = y_rn(k, end) + y_rn(k+1, 2);
    end
end

%% Output
y = zeros(1, n_blocks*(N+M-1) - n_blocks*2);
y(1:N+M-1) = y_rn(1, :);
indx = length(y_rn(1, :));
for k = 2:n_blocks
    if k == n_blocks
        y(indx+1:indx+(N+M-1)-2-(M-1))  = y_rn(k, 3:end-(M-1));
    else
        y(indx+1:indx+(N+M-1)-2)  = y_rn(k, 3:end);
    end
    indx = indx + (N+M-1) - 2;
end

%% Plots and display
disp(y);
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
stem(y);
title('Convoluted Sequence - y[n] = x[n] * h[n]');
xlabel('n');
ylabel('y[n]');