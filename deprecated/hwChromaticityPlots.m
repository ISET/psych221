%% hwChromaticityPlots
%
% Show the chromaticity plots starting from the XYZ plots.
%
% To improve by adding video or rotation or something.
%

%%
ieInit

%% Read in the xyz functions
xyz = ieReadSpectra('XYZEnergy.mat');

%%
ieNewGraphWin;
P1 = plot3(xyz(:,1),xyz(:,2),xyz(:,3),'bo');
grid on; axis square;
xlabel('X'),ylabel('Y'),zlabel('Z');

line([1 0],[0 1],[0 0],'Color','k','Linestyle',':','Linewidth',2);  % X to Y
line([1 0],[0 0],[0 1],'Color','k','Linestyle',':','Linewidth',2);  % X to Z
line([0 0],[1 0],[0 1],'Color','k','Linestyle',':','Linewidth',2);     % Y to Z
view([-40,25]);


%% Add the corresponding chromaticity points

xy = chromaticity(xyz);
z = ones(length(xy(:,1)),1) - xy(:,1) - xy(:,2);
hold on;
plot3(xy(:,1),xy(:,2),z(:,1),'x');

%% XY view
view([0 90]);

%%
delete(P1);

%%
chromaticityPlot;

%% END