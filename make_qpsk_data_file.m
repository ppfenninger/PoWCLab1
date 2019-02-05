% N = 10000;
% % make 100 random bits of values +- 1
% bits = sign(randn(N,1));
bits = [-1,-1, -1,1, 1,1, 1,-1];

Symbol_period = 20;

% create a generic pulse of unit height
% with width equal to symbol period
pulse = ones(Symbol_period, 1);

% X is going to get upsampled
x = zeros(length(bits)/2,1);

for n = 1:length(x)
    m = 1+2*(n-1);
    if isequal(bits(m:m+1), [-1,-1])
        x(n) = -1 - 1i;
    elseif isequal(bits(m:m+1), [-1,1])
        x(n) = -1 + 1i;
    elseif isequal(bits(m:m+1), [1,1])
        x(n) = 1 + 1i;
    elseif isequal(bits(m:m+1), [1, -1])
        x(n) = 1 - 1i;
    end
end

x = upsample(x, Symbol_period);

% now convolve the single generic pulse with the spread-out bits
x_tx = conv(pulse, x);

% to visualize, make a stem plot
subplot(211)
stem(real(x_tx));
subplot(212)
stem(imag(x_tx));

% zero pad the beginning with 100000 samples to ensure that any glitch that
% happens when we start transmitting doesn't effect the data

x_tx = [zeros(100000, 1); x_tx;zeros(100000, 1)];


% here we write the data into a format that the USRP can understand
% specifically, we use float32 numbers with real followed by imaginary
% values

% first create a vector to store the interleaved real and imaginary values

tmp = zeros(length(x_tx)*2, 1);

% then assign the real part of x_tx to every other sample and the imaginary
% part to the remaining samples. In this example, the imaginary parts are
% all zero since our original signal is purely real, but we still have to
% write the zero values 

tmp(1:2:end) = real(x_tx);
tmp(2:2:end) = imag(x_tx);

% open a file to write in binary format 
f1 = fopen('tx2.dat', 'wb');
% write the values as a float32
fwrite(f1, tmp/2, 'float32');
% close the file
fclose(f1)