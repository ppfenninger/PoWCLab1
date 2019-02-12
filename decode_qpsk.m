decoded_bits = zeros(2*length(down_x), 1);
for m = 1:length(down_x)
    decoded_bits(2*m - 1) = sign(real(down_x(m)));
    decoded_bits(2*m) = sign(imag(down_x(m)));
end

load('bits.mat');

decoded_bits = (decoded_bits + 1)./2;

disp(sum(decoded_bits(2:end - 1) ~= bits) ./ length(decoded_bits));

% hold on
% grid on
% plot(real(down_x), imag(down_x), 'o');

[corr, lag] = xcorr(decoded_bits, bits);

plot(lag, corr)

[~, maxIndex] = max(corr);
totalLag = lag(maxIndex);

