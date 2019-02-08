% Open the file containing the received samples
f2 = fopen('rx4.dat', 'rb');
 
% read data from the file
tmp = fread(f2, 'float32');
 
% close the file
fclose(f2);
 
 
% since the USRP stores the data in an interleaved fashion
% with real followed by imaginary samples 
% create a vector of half the length of the received values to store the
% data. Make every other sample the real part and the remaining samples the
% imaginary part
% y = zeros(length(tmp)/2,1);
y = tmp(1:2:end)+1i*tmp(2:2:end);
 
startSignal = 0;
endSignal = 0;
 
for i = 21:length(y)
    if y(i) > 0.2 && startSignal == 0
        startSignal = i;
    end
    
    if mean(abs(y(i-20:i))) < 0.005 && endSignal == 0 && startSignal ~= 0
        endSignal = i - 20;
        break;
    end
end
 
cleanData = y(startSignal:endSignal);
 
save('cleanData.mat', 'cleanData');
 
 
plot(real(y(startSignal:end)), imag(y(startSignal:end)), '*');
 
 
% to visualize, plot the real and imaginary parts separately
return;
% subplot(211)
% stem(real(y));
% subplot(212)
% stem(imag(y));
