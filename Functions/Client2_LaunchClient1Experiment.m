function Client2_LaunchClient1Experiment(app,experiment_filename, varargin)
% Launches a new matlab session and runs the user-input experiment file
%
% 5/10/2019 - includes progress dialog option
% 5/10/2019 - handle input arguments with parser
%
% Author: Ringo Huang
% Date: 5/2/2019

%% Parse inpnut arguments
p = inputParser;
addRequired(p,'AppHandle');
addRequired(p,'ExperimentFilename',@ischar);
addParameter(p,'ProgressDialog','on',@(x) any(validatestring(x,{'on','off'})));
addParameter(p,'Arguments',{''}, @iscell);

parse(p,app,experiment_filename,varargin{:});

%% Progress dialog
if strcmp(p.Results.ProgressDialog,'on')
    progress_dlg = uiprogressdlg(app.UIFigure,'Message','Connecting client 2 with GP3...','Indeterminate','on');
end

%% Format arguments
formatted_arguments = ['(' strjoin(cellfun(@(x) num2str(x), p.Results.Arguments,'UniformOutput',false),',') ')'];

%% Launch the Handgrip task experiment in a Matlab session 1
if exist(fullfile(pwd, [experiment_filename '.m']),'file')
    % run this if the GP3 functions are in the same folder as the main
    % script
    eval(['!matlab -nosplash -nodesktop -r "' experiment_filename formatted_arguments '" &'])
else
    % run this if the GP3 functions are in a sub-folder of the main script
    eval(['!matlab -nosplash -nodesktop -r "addpath(genpath(pwd)); ' experiment_filename formatted_arguments '" &'])
end

%% Close progress_dlg
if strcmp(p.Results.ProgressDialog,'on')
    close(progress_dlg);
end
