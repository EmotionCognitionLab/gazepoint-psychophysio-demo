function [app, outputFullPathName] = GUI_DefineOutputFullPathName(app, p, output_fieldnames)
% Defines OutputFullPathName
%   Automatically generates the folder if output folder edit field is
%   empty; otherwise, uses the value in output folder edit field.

output_string_pairs = GUI_CreateStringPairs(p, output_fieldnames);  %only include the fieldnames that you want in the output filename

% If the OutputFolderEditField is empty, automatically fill it in
if isempty(app.OutputFolderEditField.Value)                 % automatically generates output folder path name if the field is empty
    current_filename = mfilename('fullpath');
    current_filename_split = strsplit(current_filename,filesep);
    parent_directory = fullfile(current_filename_split{1:end-2});
    app.OutputFolderEditField.Value = fullfile(parent_directory,'Data',app.ExperimentNameEditField.Value);
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
end

