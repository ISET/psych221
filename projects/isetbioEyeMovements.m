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
scene = sceneCreate('slanted bar');

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

%%
cones.window;

%%  Get the mean absorptions across time

absorptions = cones.absorptions;
meanA = mean(absorptions,3);
ieNewGraphWin; imagesc(meanA); 

rgb = repmat(meanA,1,1,3);
deltaX = cones.patternSampleSize(1)*1e3;
ISO12233(rgb,deltaX,[1 0 0]);
colormap(gray); colorbar





