function Client2_WaitForMessage(app, client1_message, varargin)
% Waits for client1_message before proceeding. client1_message must match
% the string value paired with USERDATA from the XML packet sent by
% client1. Case-insensitive match.
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 6/28/2019


%% Parse input arguments
p = inputParser;
addRequired(p,'AppHandle');
addRequired(p,'Client1_Message');
addParameter(p,'ProgressDialog','on',@(x) any(validatestring(x,{'on','off'})));

parse(p, app, client1_message, varargin{:});

%% Progress dialog
if strcmp(p.Results.ProgressDialog,'on')
    progress_dlg = uiprogressdlg(app.UIFigure,'Message',...
        ['Waiting for message, "' client1_message '" from client 1...'],...
        'Indeterminate','on');
end

%% Wait to Receive CLIENT1_READY message or connection times out after 60s
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');
time_start=tic;
while  1
    dataReceived = fscanf(app.session2_client);
    split = strsplit(dataReceived,'"');
    current_user_data = split{end-1};
    if strcmpi(current_user_data,client1_message)
        fprintf(['Success: Received "' client1_message '" from client 1.']);
        break
    end
    if toc(time_start) > 60
        error(['Timed out: Failed to receive "' client1_message '" from client 1.'])
    end
    pause(.01);
end
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');
flushinput(app.session2_client);

%% Close progress_dlg
if strcmp(p.Results.ProgressDialog,'on')
    close(progress_dlg);
end