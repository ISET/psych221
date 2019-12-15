cd('C:\Documents and Settings\joyce\My Documents\Projects\MultispectralImaging\LED lights\LED spectra\Matlab\MatlabData')

% load('Orange-Red.mat')
% plot(wavelength,data)
% RedOrange=data;
% Wavelength_RedOrange = wavelength;
% 
% load('AmberFilter.mat')
% amber=data;
% Wavelength_Amber = wavelength;
% 
% load('GreenLed.mat')
% green = data;
% Wavelength_Green = wavelength;
% 
% load('BlueLED.mat')
% blue = data;
% Wavelength_blue=wavelength;
% 
% load('CyanFilter.mat')
% cyan=data;
% Wavelength_Cyan=wavelength;
% 
% load('RedLed.mat')
% red = data;
% Wavelength_Red=wavelength;
% 
% load('IRFilter.mat')
% IR = data;
% Wavelength_IR = wavelength;

% save LUXEON amber blue cyan green red IR Wavelength_Amber Wavelength_Cyan Wavelength_Green Wavelength_IR Wavelength_Red Wavelength_blue                   
%   
load('Luxeon.mat')

plot(Wavelength_Amber,amber,'y')
hold on;
plot(Wavelength_Cyan,cyan,'c')
plot(Wavelength_Green,green,'g')
plot(Wavelength_Red,red,'r')
plot(Wavelength_blue,blue,'b')
plot(Wavelength_IR,IR,'k')
