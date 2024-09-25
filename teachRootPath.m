function rootPath=teachRootPath()
% Deprecated:  Return the path to the root psych221 directory
%
% Use psych221RootPath
%
% 
% Example:
%   fullfile(teachRootPath,'data')

warning('Use psych221RootPath');

rootPath = which('teachRootPath');

rootPath=fileparts(rootPath);

end