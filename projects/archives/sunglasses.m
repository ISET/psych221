% sunglasses.m
%
% Illustrates how to calculate the cone responses to a simple scene.  The
% goal of this project is to understand the impact of sunglasses on the
% cone quantum catches.
%
% Relies on ISETBio, not ISETCam
%
% See also
%   2021 EnChroma glasses project

%%
if piCamBio
    % Return true if ISETCam, false if ISETBio
    error('Use ISETBio, not ISETCam');
end

%%
ieInit;

%% The basic method for creating a scene and computing the OI

% Just like ISETCam.  Create a scene that is about 4 deg.
scene = sceneCreate('macbeth d65');
scene = sceneSet(scene,'fov',2);

oi = oiCreate;
oi = oiCompute(oi,scene);
oiWindow(oi);

%%  Now, create a cone mosaic

thisMosaic = coneMosaic;
thisMosaic.setSizeToFOV(2);

thisMosaic.compute(oi);
thisMosaic.window;

%% Extra

%{
% See t_cMosaicBasic.mlx for a tutorial on the fancier kind of cone mosaics

cm = cMosaic(...
    'sizeDegs', [4 4], ...         % SIZE: 1.0 degs (x) 0.5 degs (y)
    'positionDegs', [0 0], ... % ECC: (0,0)
    'eccVaryingConeBlur', true ...
    );
cm.visualize();
cm.compute(oi);
%}
%% Code illustrating how to apply a color filter to the image

scene = sceneCreate('macbeth d65');
scene = sceneSet(scene,'fov',2);

sceneWindow(scene);
oi = oiCreate('wvf human');
oi = oiCompute(oi, scene);

% visualize the resulting optical image
oiWindow(oi);

%% EnChroma is a filter that transmits light 

% There is a little script that shows how we calculated the transmittance
% enchromaTransmittance.m
wave = oiGet(oi,'wave');
[eTransmittance,wave] = ieReadSpectra('enchroma',wave);
ieNewGraphWin;
plot(wave,eTransmittance,'-o');
grid on; xlabel('Wave (nm)'); ylabel('Transmittance');

%% Retina image with EnChroma glasses

% Now apply the transmittance to the photons in the oi
Photons = oiGet(oi,'photons');

% Convert the data format so we can easily multiply by a matrix
[Photons, row, col] = RGB2XWFormat(Photons);

% Multiply
Photons = Photons*diag(eTransmittance);

% Put the data back into the right format and then into the oi
Photons = XW2RGBFormat(Photons, row, col);
oi = oiSet(oi,'photons',Photons);

oiWindow(oi);

%% Let's image the oi onto the cone mosaic

thisMosaic.compute(oi);
thisMosaic.window;
absorptions = thisMosaic.absorptions;

thisMosaic.plot('hline absorptions');

%%
