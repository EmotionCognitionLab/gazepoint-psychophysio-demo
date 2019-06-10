function Client2_WaitForClient1(app,varargin)
% This ensures that the other Matlab session has launched and is ready
% before proceeding.
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
    progress_dlg = uiprogressdlg(app.UIFigure,'Message','Waiting for connection response from client 1...','Indeterminate','on');
end


%% Wait to Receive CLIENT1_READY message or connection times out after 60s
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');
time_start=tic;
while  1
    dataReceived = fscanf(app.session2_client);
    split = strsplit(dataReceived,'"');
    current_user_data = split{end-1};
    if strcmp(current_user_data,'CLIENT1_READY')
        fprintf('\nConnection to session 1 client successful!\n\n')
        break
    end
    if toc(time_start) > 60
        error('Connection time out: could not connect to session 1 client.')
    end
    pause(.01);
end
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');

%% Close progress_dlg
if strcmp(p.Results.ProgressDialog,'on')
    close(progress_dlg);
end