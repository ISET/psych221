%% fise_01Pinhole
% 
% Render the chess set scene with a pinhole camera (perspective) mode.
% We render with a range of aperture sizes to show the blurring
% effect.
% 
% Maybe we should also illustrate the cos fall off.
%
% Requires: ISET3d
%

%%
ieInit;
if ~piDockerExists, piDockerConfig; end

%% Load the chess scene

thisR = piRecipeDefault('scene name','chessset');

%%  Increasing pinhole size 

% PBRT sets the pinhole radius (mm) of the perspective camera.
radius = [0,logspace(-3,-2,3)];
img = cell(4,1);
for ii=1:numel(radius)
    thisR.set('lens radius',radius(ii));
    scene = piWRS(thisR,'name',sprintf('Radius %.3f mm',radius(ii)));
    scene = piAIdenoise(scene);
    img{ii} = sceneGet(scene,'srgb');
    ieReplaceObject(scene);
end

%% This is the scene we include in the book
ieNewGraphWin; montage(img);

%% End

