%% Schade, low pass, calculations
%
%  Why did Schade think there had to be an opposing center?
%

%%  Here are the MTFs of Gaussians

% Because the PSF is all positive, it is necessary that the peak
% response is at 0 freq 
nsamples = 5;
sigma = logspace(0,1,nsamples);
hsize = 256;
idx = ((hsize/2+1) : hsize);
sfreq = (idx - (hsize/2)+1)/max(idx);
ieNewGraphWin;
for ii=1:nsamples
    thisGauss = fspecial('gaussian',[hsize,1],sigma(ii));
    thisGaussFFT = fftshift(abs(fft(thisGauss)));
    plot(sfreq,thisGaussFFT(idx));
    set(gca,'xlim',[0 0.5]); grid on; hold on;
end

xlabel('Normalized spatial frequency');

%%  Suppose we create an MTF that is flat for a while, and then declines

O = ones()
mtf = 