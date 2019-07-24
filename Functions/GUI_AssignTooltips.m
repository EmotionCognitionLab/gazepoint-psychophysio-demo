function app = GUI_AssignTooltips(app, ui_component_names)
% A set of canned command window messages that is common for all the apps.
% I keep them here because it is easier to ensure consistency across all
% apps if I decide to make changes to the message in the future.

%% Parse input arguments
p = inputParser;
addRequired(p, 'AppHandle');
addRequired(p, 'UIComponentNames', @iscellstr);        % a cell array of the component names that are part of the GUI
parse(p, app, ui_component_names);

%% Tooltip to return based on user-specified tooltip_index
for i = 1:numel(ui_component_names)
    switch ui_component_names{i}
        case {'ExperimentNameEditField', 'ExperimentNameEditFieldLabel'}
            tooltip_str = sprintf(['Enter experiment name, which will be a component\n',...
                'of the GP3 output file name. This is not the same as the app name.']);
        case {'SubjectIDEditField', 'SubjectIDEditFieldLabel'}
            tooltip_str = 'Enter subject ID.';
        case 'EarButtonGroup'
            tooltip_str = 'Select sound playback through left, right, or both audio channels.';
        case 'ReloadButton'
            tooltip_str = 'Updates drop-down list with new .wav and .mp3 files. To add your own files, save them in the ..\Stimuli\Sounds folder.';
        case 'ReturnButton'
            tooltip_str = 'Returns to select experiment menu.';
        case 'ToneTypeButtonGroup'
            tooltip_str = 'Select whether tone should be increasing (looming), decreasing (receding), or constant over the tone duration.';
        case {'OutputFolderButton','OutputFolderEditField'}
            tooltip_str = 'Select output folder for Gazepoint raw data. Default path will be used if left blank.';
        otherwise
            warning([ui_component_names{i} ' tooltip string not assigned in GUI_AssignTooltips.m']);       
    end
    
    % Assign string to copmonent tooltip
    app.(ui_component_names{i}).Tooltip = tooltip_str;
end