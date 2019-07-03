function GUI_CommandWindowMessages(message_index, varargin)
% A set of canned command window messages that is common for all the apps.
% I keep them here because it is easier to ensure consistency across all
% apps if I decide to make changes to the message in the future.

%% Parse input arguments
p = inputParser;
addRequired(p, 'MessageIndex', @isnumeric);
addParameter(p, 'AdditionalComponents', @iscellstr);        % a cell array of strings to be included in the message
parse(p, message_index, varargin{:});

%% Write command window messages here
switch message_index
    case 1
        message_cw = 'Warning: No data being streamed. Automatically stopping experiment.\n';
    case 2
        message_cw = ['Experiment Running: Received "' p.Results.AdditionalComponents{1} '" message at ' p.Results.AdditionalComponents{2} ' sec.\n'];
    case 3
        message_cw = 'Experiment Stopped: Recording complete.\n';
end

%% Display message of user-defined message index in command window
fprintf(message_cw);
end