%% s_opticsPinhole
% 
% Illustrate rendering as the pinhole aperture size increases
%
% PBRT sets the pinhole radius of the perspective

%%
ieInit;
if ~piDockerExists, piDockerConfig; end

%% Load the chess scene

thisR = piRecipeDefault('scene name','chessset');

%%  Increasing pinhole size 
radius = [0,logspace(-3,-2,3)];
img = cell(4,1);
for ii=1:numel(radius)
    thisR.set('lens radius',radius(ii));
    scene = piWRS(thisR,'name',sprintf('Radius %.3f mm',radius(ii)));
    scene = piAIdenoise(scene);
    img{ii} = sceneGet(scene,'srgb');
    ieReplaceObject(scene);
end

%%
ieNewGraphWin; montage(img);
%% End

