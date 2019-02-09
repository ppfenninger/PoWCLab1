load('cleanData.mat');
 
bits = cleanData;
 
% Step 1: Estimate channel magnitude
magnitude_estimate = rms(abs(bits));
 
% Step 2: Divide received signal by estimate of channel magnitude
y_hat = bits./magnitude_estimate;
 
% Step 3: Initialize variables
x_hat = zeros(length(y_hat), 1);

fft_x = fft(y_hat.^4);
x_axis = linspace(0, 2*pi*(length(bits)-1)/length(bits), length(bits));

[max_val, max_index] = max(abs(fft_x));

freq_offset = -1*x_axis(max_index)./4;

theta_hat = -1*angle(fft_x(max_index))./4;

for k = 1:length(y_hat)
    x_hat(k) = y_hat(k).*exp(1i*(freq_offset * (k-1) + theta_hat));
end

hold on
% stem(
% plot(real(x_hat), imag(x_hat), 'o');
% plot(real(x_hat(1:400)));

down_x = downsample(x_hat, 20);

plot(real(down_x), imag(down_x), 'o');
plot(real(down_x((length(down_x) - 60):length(down_x))), imag((length(down_x) - 60):length(down_x)), 'o');

bits = zeros(2*length(down_x), 1); 
% 
% for m = 1:length(down_x)
%         bits(2*m - 1) = sign(real(down_x(m)));
%         bits(2*m) = sign(imag(down_x(m)));
% end
% 
% for n = 1:length(bits) - 128
%     if sum(bits(n:(n+128))) == 0
%         start_bit = n + 129;
%     end
% end
% 
% bits_to_decode = bits(start_bit:16*floor((length(bits) - start_bit + 1)/16));
% str = char(bin2dec(reshape(char(bits_to_decode+'0'), 16,[]).'));

% for n = 1:16
%     bits_to_decode = bits(n:16*floor((length(bits) - n + 1)/16));
%     str = char(bin2dec(reshape(char(bits_to_decode+'0'), 16,[]).'));
% end



