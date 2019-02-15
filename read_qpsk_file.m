% Open the file containing the received samples
f2 = fopen('rxp3.dat', 'rb');
 
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

load('random_start_noise.mat')
load('random_end_noise.mat')
 
[xcorrStart, xcorrStartLag] = xcorr(y, random_start_noise);
[xcorrEnd, xcorrEndLag] = xcorr(y, random_end_noise);

[~, startSignalIndex] = max(abs(xcorrStart));
[~, endSignalIndex] = max(abs(xcorrEnd));

startSignal = xcorrStartLag(startSignalIndex);
endSignal = xcorrEndLag(endSignalIndex);
 
cleanData = y(startSignal + 257:endSignal);
 
save('cleanData.mat', 'cleanData');
 
% to visualize, plot the real and imaginary parts separately
% return;
subplot(211)
hold on
xlabel('samples');
ylabel('amplitude');
plot(real(cleanData));
hold off
subplot(212)
hold on
xlabel('samples');
ylabel('amplitude');
plot(real(y));