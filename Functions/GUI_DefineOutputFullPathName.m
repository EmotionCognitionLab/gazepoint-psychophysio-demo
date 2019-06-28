function [app, outputFullPathName] = GUI_DefineOutputFullPathName(app, p, output_fieldnames)
% Assigns an output directory for the gazepoint data if the
% OutputFolderEditField is empty. The assigned directory is
% ..\Data\app_name. If the assigned/specified output folder does not exist,
% automatically creates the directory. 
% 
% User can specify a different output folder even after connection with GP3
% is established. Subsequent "Start Experiment" runs will output Gazepoint
% data to the new output folder.
%
% Arguments:
%   output_fieldnames - in the main app GUI code, the output_fieldnames are
%   pre-defined based on which name-pair parameters I think should be
%   included in the Gazepoint filename
%
% Created by: Ringo Huang
% Date: 6/20/2019

output_string_pairs = GUI_CreateStringPairs(p, output_fieldnames);  %only include the fieldnames that you want in the output filename

% If the OutputFolderEditField is empty, automatically assigns an output
% directory in ..\Data\app_name
if isempty(app.OutputFolderEditField.Value)                 
    current_fullpath = mfilename('fullpath');
    current_fullpath_split = strsplit(current_fullpath,filesep);
    parent_directory = fullfile(current_fullpath_split{1:end-2});
    app_name = regexprep(app.UIFigure.Name, ' Task', '');   % Remove ' task' from the app name string
    app.OutputFolderEditField.Value = fullfile(parent_directory,'Data',app_name);
end

% If Output Folder doesn't exist, create it
if ~exist(app.OutputFolderEditField.Value,'dir'); mkdir(app.OutputFolderEditField.Value); end

% Define outputFullPathName
outputFileName = [output_string_pairs '.tsv'];
outputFullPathName = fullfile(app.OutputFolderEditField.Value,outputFileName);

% If outputFullPathName exists, append with file number until it's unique
file_num = 2;
while exist(outputFullPathName,'file')
    outputFileName = [output_string_pairs '_' num2str(file_num) '.tsv'];
    outputFullPathName = fullfile(app.OutputFolderEditField.Value,outputFileName);
    file_num = file_num + 1;
end


