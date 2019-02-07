% Step 1: Estimate channel magnitude
magnitude_estimate = rms(abs(bits(1:1000)));

% Step 2: Divide received signal by estimate of channel magnitude
y_bar = bits./magnitude_estimate;

% Step 3: Initialize variables
psi = zeros(length(bits), 1);
psi_hat = psi;
x_hat = psi;
e = psi;
d = psi;

beta = 0.1;
alpha = beta/10;

% Start the loop
for k = 1:length(bits)-1
    % Step 4: Correct phase offset
    x_hat(k) = y_hat(k) * exp(1i * psi_hat(k));
    
    % Step 5: Compute error signal
    e(k) = -real(x_hat(k))*imag(x_hat(k));
    
    % Step 6: Compute correction factor
    for l = 1:k
        d(k) = d(k) + alpha * e(l);
    end
    
    d(k) = d(k) + beta * e(k);
    
    % Step 7: update psi_hat
    psi_hat(k+1) = psi_hat(k) + d(k);
    
    % Step 8: Wrap psi_hat
    if psi_hat(k+1) > pi
        psi_hat(k+1) = psi_hat(k+1) - 2*pi;
    elseif psi_hat(k+1) < pi
        psi_hat(k+1) = psi_hat(k+1) + 2*pi;
    end
end

subplot(211)
stem(real(x_hat));
subplot(212)
stem(imag(x_hat);