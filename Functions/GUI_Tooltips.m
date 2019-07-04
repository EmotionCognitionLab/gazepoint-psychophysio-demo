function tooltip_str = GUI_Tooltips(tooltip_index, varargin)
% A set of canned command window messages that is common for all the apps.
% I keep them here because it is easier to ensure consistency across all
% apps if I decide to make changes to the message in the future.

%% Parse input arguments
p = inputParser;
addRequired(p, 'TooltipIndex', @isnumeric);
addParameter(p, 'AdditionalComponents', @iscellstr);        % a cell array of strings to be included in the message
parse(p, tooltip_index, varargin{:});

%% Tooltip to return based on user-specified tooltip_index
switch tooltip_index
    case 1      % Experiment Name Field
        tooltip_str = sprintf(['Enter experiment name, which will be a component\n',...
            'of the GP3 output file name. This is not the same as the app name.']);
    case 2      % Subject ID Field
        tooltip_str = 'Enter subject ID.';
    case 3      % Connect Button
        tooltip_str = 'Starts connection sequence with GP3 server.';
    case 4      % Disconnect Button
        tooltip_str = 'Begins disconnect sequence with GP3 server.';
    case 5      % Start Experiment Button
        tooltip_str = 'Starts next experiment run.';
    case 6      % Stop Experiment Button
        tooltip_str = 'Stops experiment before completion.';
    case 7      % Ear Button Group
        tooltip_str = 'Select sound playback through left, right, or both audio channels.';
    case 8      % Refresh button
        tooltip_str = 'Update drop-down list with the .wav and .mp3 files in the Sounds folder.';

end
