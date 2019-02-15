decoded_bits = zeros(2*length(down_x), 1);
for m = 1:length(down_x)
    decoded_bits(2*m - 1) = sign(real(down_x(m)));
    decoded_bits(2*m) = sign(imag(down_x(m)));
end

load('bits.mat');

decoded_bits = (decoded_bits + 1)./2;

% using this to figure out if we are rotated - the non rotated version
% should have a large peak at zero
[corr, lag] = xcorr(decoded_bits, bits(1:100));

hold on
xlabel('lag');
ylabel('correlation');
plot(lag, corr)

[~, maxIndex] = max(corr);
totalLag = lag(maxIndex);

if totalLag == 0
    disp(sum(decoded_bits(1:length(bits)) ~= bits) ./ length(decoded_bits));
else
    disp('total lag is not zero, signal may need to be rotated'); 
end





