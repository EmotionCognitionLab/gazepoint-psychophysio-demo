function Client_WaitForMessage(client, match_message, varargin)
% Waits for match_message before proceeding. Checks USERDATA from the XML
% packet sent from GP3 Server for a case-insensitive match with
% match_message. Returns timed_out_state = 1 if message was not matched 
%
% Meant for receiving progress updates from a different client-GP3 socket.
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 6/28/2019

%% Parse input arguments
p = inputParser;
addRequired(p, 'ClientHandle');
addRequired(p, 'MatchMessage', @ischar);
addParameter(p, 'TimeOutDuration', 60, @(x) isnumeric(x) && (x > 0));
parse(p,client,match_message,varargin{:});

%% Detect whether the session2_client buffer has send data enabled
% Empty buffer then pause for a moment; if send_data is enabled, client
% buffer will start filling up; if not, bytesavailable will remain 0
flushinput(client)
pause(0.1)
if client.BytesAvailable > 0
    send_data_enabled_already = 1;
elseif client.BytesAvailable == 0
    send_data_enabled_already = 0;
end

% Enable send data if not already enabled
if send_data_enabled_already == 0
    fprintf(client, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');
end

%% Scan until match_message is received; connection times out after 60s
time_start=tic;
fprintf(['Streaming data: Listening for "' match_message '" message.\n']);
while  1
    dataReceived = fscanf(client);
    split = strsplit(dataReceived,'"');
    current_user_data = split{end-1};
    if strcmpi(current_user_data,match_message)
        fprintf(['Success: Received "' match_message '" message.\n']);
        break
    end
    if toc(time_start) > p.Results.TimeOutDuration
        error(['Timed out: Failed to receive "' match_message '" message.\n'])
    end
    pause(.01);
end

% Clears buffer and disables send_data if originally disabled
if send_data_enabled_already == 0
    fprintf(client, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');
    flushinput(client);
end