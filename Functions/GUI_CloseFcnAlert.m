function okay_to_close = GUI_CloseFcnAlert(app)
% Alerts user that GUI is still connected to GP3. Returns 1 if okay to
% close, 0 if not okay
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 6/21/2019

okay_to_close = 1;
if strcmp(app.DisconnectButton.Enable,'on') ||  strcmp(app.StopExperimentButton.Enable,'on')
    uialert(app.UIFigure,'Still connected to GP3. Please stop experiment and/or disconnect before closing program.',...
        'Still connected');
    okay_to_close = 0;
end