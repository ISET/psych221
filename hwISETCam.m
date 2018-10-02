%%  Using ISETCam
%
% This script spends some space and time explaining ISETCam.  The most
% important part of this script is teaching you how to search for
% functions and explanations about using ISETCam.  It also contains
% some basic examples.  Many many more examples can be found in the
% tutorials and scripts.
%
% Wandell, October 1, 2018
%
% See also
%  Any of the tutorials t_<> or scripts s_<>
%

%% Initialize ISET variables and structures
%%
% ISETCam is a way to help you compute basic quantities related to
% imaging.  The vast majority of ISETCam are its functions that
% compute different quantities.  A second and important part of
% ISETCam are the methods for visualizing the computations and
% monitoring the system parameters.
%

% To help you 

% The ieInit function closes windows and can clear your variables,
% depending on how you set your ISET preferences.

% Here is how your preferences are set
getpref('ISET')   % Current status

% To clear workspace variables on ieInit, do this
setpref('ISET','initclear',true);    

% To preserve workspace variables on ieInit, do this
setpref('ISET','initclear',false);   

ieInit;

%% Using ISETCam to visualize defocus of diffraction limited optics
%%
% Create a scene comprising a multispectral line, with equal photons
scene = sceneCreate('line ep',128);    % A thin line, equal photon radiance at each wavelength
scene = sceneSet(scene,'fov', 0.5);    % Small field of view (deg)
ieAddObject(scene); sceneWindow;       % Save it in the database and show

% Plot the scene data
scenePlot(scene,'radiance hline',[64 64]);
set(gca,'xlim',[-1 1]);  % Plot radiance at central 1 mm

% Type doc scenePlot to see other plotting options
%% Simulate the line passing through diffraction-limited optics
%%
oi = oiCreate;               % Default optics is diffraction limited
oi = oiCompute(oi,scene);
ieAddObject(oi); oiWindow;

% Plot the line spread as a function of wavelength
oiPlot(oi,'irradiance hline',[80 80]);
set(gca,'xlim',[-10 10]);  % Plot radiance at central 10 um
%% Now change the f-number of the optics and do it again
%%
oi = oiSet(oi,'optics fnumber',12);
oi = oiCompute(oi,scene);
ieAddObject(oi); oiWindow;

oiPlot(oi,'irradiance hline',[80 80]);
set(gca,'xlim',[-10 10]);  % Plot radiance at central 1 mm
%% Questions to Think About
% At this point, you can answer Questions #4, #5, and #6 on "Homework
% 1: Image Formation."

%%