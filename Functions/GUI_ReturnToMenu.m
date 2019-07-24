function GUI_ReturnToMenu(app)
% The common sequence used to return from app to main menu
%
% Author: Ringo Huang
% Created on: 7/23/2019

current_fileparts = strsplit(mfilename('fullpath'),filesep);
menu_filename = 'GazepointDemo_menu';

try
    eval(['"addpath(''' fullfile(current_fileparts{1:end-2}) ''')"; ' menu_filename])       % add path to parent directory ('gazepoint-psychophysio-demo')
catch
    warning(['Unable to find ' menu_filename ' in path.'])
end

delete(app.UIFigure);