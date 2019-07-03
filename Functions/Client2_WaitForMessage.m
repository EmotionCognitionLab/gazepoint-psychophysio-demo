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

%% Detect whether the session2_client buffer has send data enabled
flushinput(app.session2_client)
pause(0.1)
if app.session2_client.BytesAvailable > 0
    send_data_enabled_already = 1;
elseif app.session2_client.BytesAvailable == 0
    send_data_enabled_already = 0;
end

% Enable send data if not already
if send_data_enabled_already == 0
    fprintf(app.session2_client, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');
end

%% Wait to Receive CLIENT1_READY message or connection times out after 60s
time_start=tic;
while  1
    dataReceived = fscanf(app.session2_client);
    split = strsplit(dataReceived,'"');
    current_user_data = split{end-1};
    if strcmpi(current_user_data,client1_message)
        fprintf(['\nSuccess: Received "' client1_message '" from client 1.\n']);
        break
    end
    if toc(time_start) > 60
        error(['\nTimed out: Failed to receive "' client1_message '" from client 1.\n'])
    end
    pause(.01);
end

% Reset buffer if buffer was originally empty
if send_data_enabled_already == 0
    fprintf(app.session2_client, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');
    flushinput(app.session2_client);
end

%% Close progress_dlg
if strcmp(p.Results.ProgressDialog,'on')
    close(progress_dlg);
end