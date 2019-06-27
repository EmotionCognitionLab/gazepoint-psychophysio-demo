function Client2_LaunchClient1Experiment(app,experiment_filename, varargin)
% Launches a new matlab session and runs the user-input experiment file
%
% Author: Ringo Huang
% Date: 5/2/2019

%% Parse inpnut arguments
p = inputParser;
addRequired(p,'AppHandle');
addRequired(p,'ExperimentFilename',@ischar);
addParameter(p,'Arguments',{''}, @iscell);
addParameter(p,'ProgressDialog','on',@(x) any(validatestring(x,{'on','off'})));
addParameter(p,'CreateLogFile','yes',@(x) any(validatestring(x,{'yes','no'})));
addParameter(p,'LaunchAsBatch','yes',@(x) any(validatestring(x,{'yes','no'})));

parse(p,app,experiment_filename,varargin{:});

thisfilename_parts = strsplit(mfilename('fullpath'),filesep);

%% Progress dialog
if strcmp(p.Results.ProgressDialog,'on')
    progress_dlg = uiprogressdlg(app.UIFigure,'Message','Connecting client 2 with GP3...','Indeterminate','on');
end

%% Format logfile option
logfile_opt_formatted = [];
if strcmp(p.Results.CreateLogFile,'yes')
    computer_time = regexprep(regexprep(datestr(datetime),':','-'),' ','_');        % get datetime string and replace space with '_' and ':' with '-'
   
    logfilename = [experiment_filename '_log_' computer_time '.txt'];
    logfiledir = fullfile(thisfilename_parts{1:end-2},'logfiles');
    if ~exist(logfiledir,'dir')
        mkdir(logfiledir)
    end
    logfullpath = fullfile(logfiledir,logfilename);
    logfile_opt_formatted = [' -logfile "' logfullpath '" '];
end

%% Format batch option
arguments_formatted = ['(' strjoin(cellfun(@(x) num2str(x), p.Results.Arguments,'UniformOutput',false),',') ')'];
functions_fullpath = fullfile(thisfilename_parts{1:end-1});     % path to functions directory where experiment scripts are located
command_formatted = ['"addpath(''' functions_fullpath '''); ' experiment_filename arguments_formatted '" '];
if strcmp(p.Results.LaunchAsBatch,'yes')
    run_opt_formatted = [' -batch ' command_formatted];
elseif strcmp(p.Results.LaunchAsBatch,'no')
    run_opt_formatted = [' -r ' command_formatted];
end

%% Launch experiment session (either in an interactive session or a batch session)
eval(['!matlab -nosplash -nodesktop' logfile_opt_formatted run_opt_formatted ' &'])

%% Close progress_dlg
if strcmp(p.Results.ProgressDialog,'on')
    close(progress_dlg);
end