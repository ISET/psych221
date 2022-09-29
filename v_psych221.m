%% Run through all the MLX files in teach/psych221
%
% See also
%
%%
ieInit;
chdir(teachRootPath)

%%
fnames = dir('*.mlx');
for ii=1:numel(fnames)
    [~,thisName] = fileparts(fnames(ii).name);
    if ~isequal(thisName,'TransferLearning_08a')
        fprintf('\n\n  **** Checking %s **** \n\n',thisName);
        eval(thisName);
    end
end
