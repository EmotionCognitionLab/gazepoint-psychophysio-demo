function session_client = Client2_ConnectToGP3(app, varargin)
% Client 2 refers to the Matlab session responsible for recording the GP3
% data stream.
%
% 5/10/2019 - includes progress dialog option
%
% This function sets up the socket between session 2 client and GP3
% server and configures the data stream
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/1/2019


%% Parse input arguments
p = inputParser;
addRequired(p,'AppHandle');
addParameter(p,'ProgressDialog','on',@(x) any(validatestring(x,{'on','off'})));

parse(p,app,varargin{:});

%% Progress dialog
if strcmp(p.Results.ProgressDialog,'on')
    progress_dlg = uiprogressdlg(app.UIFigure,'Message','Establishing client 2 connection to GP3...','Indeterminate','on');
end

%% Set up session 2 set up address and port, and configure socket properties
session_client = tcpip('127.0.0.1', 4242);
session_client.InputBufferSize = 100000;
fopen(session_client);
session_client.Terminator = 'CR/LF';

%% Close progress_dlg
if strcmp(p.Results.ProgressDialog,'on')
    close(progress_dlg);
end