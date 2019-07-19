function GUI_CommandWindowMessages(message_keyword, varargin)
% A set of canned command window messages that is common for all the apps.
% I keep them here because it is easier to ensure consistency across all
% apps if I decide to make changes to the message in the future.

%% Parse input arguments
p = inputParser;
addRequired(p, 'MessageKeyword', @isstr);
addParameter(p, 'AdditionalComponents', @iscellstr);        % a cell array of strings to be included in the message
parse(p, message_keyword, varargin{:});

%% Write command window messages here
switch message_keyword
    case 'GP3Connected'
        message_cw = 'GP3 Connected: Background process successfully launched and sockets established...\n';
    case 'WarningEmptyBuffer'
        message_cw = 'Warning - Empty Buffer: No data being streamed. Automatically stopping experiment.\n';
    case 'ExperimentStarted'
        message_cw = 'Experiment Started: Recording data from buffer.\n';
    case 'ExperimentRunning'
        message_cw = ['Experiment Running: Received "' p.Results.AdditionalComponents{1} '" message at ' p.Results.AdditionalComponents{2} ' sec.\n'];
    case 'ExperimentStopped'
        message_cw = 'Experiment Stopped: Recording complete.\n';
    case 'GP3Disconnected'
        message_cw = 'GP3 Disconnected: Background process closed and socket successfully closed. You may safely exit this Matlab program.\n';
end

%% Display message of user-defined message index in command window
fprintf(message_cw);
end