function session_client = Client2_ConnectToGP3(app, varargin)
% Client 2 refers to the Matlab session responsible for recording the GP3
% data stream (e.g., the GUI)
%
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

%% Try to open connect with GP3 server; if unable to connect, prompt user to turn on Gazepoint Control (or check port) or to cancel
not_connected = 1;

while not_connected
    try
        fopen(session_client);
        not_connected = 0;
    catch ME
        fclose(session_client);
        switch ME.identifier
            case 'instrument:fopen:opfailed'
                retry_or_cancel = uiconfirm(app.UIFigure,...
                    'Could not connect to GP3. Make sure Gazepoint Control is open and GP3 Port Number is set to 4242, then press retry.',...
                    'Could not connect','Options',{'Retry','Cancel'},...
                    'DefaultOption',2,'CancelOption',2,'Icon','error');
                if strcmp(retry_or_cancel,'Cancel')
                    rethrow(ME);
                end
            otherwise
                rethrow(ME);
        end
    end
end
session_client.Terminator = 'CR/LF';

%% Close progress_dlg
if strcmp(p.Results.ProgressDialog,'on')
    close(progress_dlg);
end