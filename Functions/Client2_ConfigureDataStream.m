function app = Client2_ConfigureDataStream(app,varargin)
% Configures the data stream sent from GP3 server to Client 2 (run by GUI).
% This function also configures the header for the output GP3 file based on
% the data stream configuration.
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/14/2019

%% Parse input arguments
p = inputParser;
addRequired(p,'AppHandle');
addParameter(p,'ProgressDialog','on',@(x) any(validatestring(x,{'on','off'})));

parse(p,app,varargin{:});

%% Progress dialog
if strcmp(p.Results.ProgressDialog,'on')
    progress_dlg = uiprogressdlg(app.UIFigure,'Message','Configuring client 2 data stream...','Indeterminate','on');
end

%% Configure data stream
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_TIME" STATE="1" />');
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_COUNTER" STATE="1" />');
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_USER_DATA" STATE="1" />');
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_PUPIL_LEFT" STATE="1" />');
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_PUPIL_RIGHT" STATE="1" />');
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_EYE_LEFT" STATE="1" />');
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_EYE_RIGHT" STATE="1" />');
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_BLINK" STATE="1" />');

% Enable data flow into buffer
fprintf(app.session2_client, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');

%% Configure header for GP3 data file (based on the data that were enabled)
while 1
    dataReceived = fscanf(app.session2_client);
    split = strsplit(dataReceived,'"');
    if regexp(split{1},'<REC','once')
        break
    end
end

app.header = {};
for j=1:2:length(split)-2
    if j==1
        split{j} = split{j}(6:end); % remove the '<REC ' from the first header
    end
    app.header = [app.header, split{j}(1:end-1)];
end

fprintf(app.session2_client, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');

%% Close progress_dlg
if strcmp(p.Results.ProgressDialog,'on')
    close(progress_dlg);
end
end