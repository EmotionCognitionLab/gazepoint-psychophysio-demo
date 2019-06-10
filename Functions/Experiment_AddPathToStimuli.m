function Experiment_AddPathToStimuli(experiment_name)
%Adds path to the directory where stimuli for the defined experiment is
%located

curr_file_fullpath = mfilename('fullpath');
curr_file_fullpath_split = strsplit(curr_file_fullpath,filesep);                        % split the parts of the curr fullpath using the system's file separator
stimuli_dir = fullfile(curr_file_fullpath_split{1:end-2},'Stimuli',experiment_name);    % define the path to the stimuli directory
addpath(stimuli_dir);

end
