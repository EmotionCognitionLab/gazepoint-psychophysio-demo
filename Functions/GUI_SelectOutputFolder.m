function app = GUI_SelectOutputFolder(app)
% Selects new user output folder and updates the OutputFolderEditField if
% user selected a file.
%
% Author: Ringo Huang
% Created: 5/15/2019

new_dir = uigetdir(app.OutputFolderEditField.Value);
figure(app.UIFigure);       % workaround to return windowfocus to GUI
if new_dir ~= 0
    app.OutputFolderEditField.Value = new_dir;
end