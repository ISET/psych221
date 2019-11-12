%% Calculate MTF for rectangular mosaic responses with eye movements
%
% This us a starter script that illustrates how to compute the cone mosaic
% response to a slanted bar target.
%
% The idea of the project is to use the ISETBio methods to control the eye
% movement patterns, the properties of the cone mosaic, and to calculate
% the effective MTF with different types of eye movements, cone sizes, and
% mixtures of cone types.
%
% Use the ieISO12233 method to calculate the MTF
%
% Wandell,20191110
%
% See also:  ieISO12233, emCreate
%

%%
ieInit

%%  The slanted bar scene
scene = sceneCreate('slanted edge');

%%  A standard human eye ball
oi = oiCreate;
oi = oiCompute(oi,scene);

%% Rectangular mosaic
cones = coneMosaic;
cones.spatialDensity = [0,1,0,0];   % Only L cones
cones.integrationTime = 0.001;      % One ms integration time
cones.emGenSequence(50);            % 50 eye movements (50 ms)

%%
cones.compute(oi);

%% Not needed, but nice to see
cones.window;

%%  Get the mean absorptions across time
absorptions = cones.absorptions;
edgeImage = mean(absorptions,3);
% ieNewGraphWin; imagesc(edgeImage);

% ISO12233 requires cropping the image so that the dge is taller than wide
% This is a specific way to do it.  But we need a more general way.
sz = size(edgeImage);
xmin = 30;
ymin= 15;
width  = 35;
height = 50;

edgeImage = imcrop(edgeImage,[xmin ymin width height]);
ieNewGraphWin; imagesc(edgeImage); axis image; colormap(gray);

%% Call the ISO routine

% It returns the key parameters
deltaX = cones.patternSampleSize(1)*1e3;
mtf = ISO12233(edgeImage,deltaX,[1 0 0]);
colormap(gray); colorbar

%% Here is a plot only up to the Nyquist sampling frequency
ieNewGraphWin;
keep = mtf.freq < mtf.nyquistf;
plot(mtf.freq(keep),mtf.mtf(keep),'k-','linewidth',2);
grid on;
xlabel('Cycles/mm');
ylabel('Contrast reduction');

%%





