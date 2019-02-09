load('cleanData.mat');
 
bits = cleanData;
 
plot(y);
 
% Step 1: Estimate channel magnitude
magnitude_estimate = rms(abs(bits(1:1000)));
 
% Step 2: Divide received signal by estimate of channel magnitude
y_hat = bits./magnitude_estimate;
 
% Step 3: Initialize variables
psi = zeros(length(bits), 1);
psi_hat = psi;
x_hat = psi;
e_sum = 0;
e = psi;
d = psi;
 
beta = 0.02;
alpha = beta/5;
 
% Start the loop
for k = 1:length(bits)-1
    % Step 4: Correct phase offset
    x_hat(k) = y_hat(k) * exp(1i * psi_hat(k));
    
    % Step 5: Compute error signal
    e(k) = -real(x_hat(k))*imag(x_hat(k));
    
    e_sum = e_sum + e(k)*alpha;
   
    
    d(k) = e_sum + beta * e(k);
    
    % Step 7: update psi_hat
    psi_hat(k+1) = psi_hat(k) + d(k);
    
    % Step 8: Wrap psi_hat
    if psi_hat(k+1) > pi
        psi_hat(k+1) = psi_hat(k+1) - 2*pi;
    elseif psi_hat(k+1) < pi
        psi_hat(k+1) = psi_hat(k+1) + 2*pi;
    end
end
n = 20;
% x_hat = mean(reshape(x_hat(1:floor(length(x_hat)/20)*20), n, []));
 
subplot(211)
stem(real(x_hat(1:100)));
subplot(212)
stem(imag(x_hat(1:100)));
