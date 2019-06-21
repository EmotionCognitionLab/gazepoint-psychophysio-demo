function timed_out = WaitForMessageFromBuffer(session_client, user_data_message, varargin)
% Waits for user_data_message to be received in the client buffer before
% proceeding. Returns timed_out == 1 if time out before start message is
% received. 
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 6/21/2019

narginchk(2,3);
if nargin == 2
    time_out_dur = 10;
elseif nargin == 3
    time_out_dur = varargin{1};
end

timed_out = 0;
[~, current_user_data] = RetrieveDataFromBuffer(session_client);
waitingForStartTimer = tic;
while ~strcmpi(current_user_data, user_data_message)
    disp(current_user_data)
    [~, current_user_data] = RetrieveDataFromBuffer(session_client);
    
    if toc(waitingForStartTimer) > time_out_dur
        % Alert user of time out
        warn_msg = ['Timed out after ' num2str(time_out_dur) 's without receiving experiment start message'];
        warning(warn_msg);
        uialert(app.UIFigure, warn_msg, 'Timed out');
        
        % Stop collecting data and clear buffer
        fprintf(session_client, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');
        flushinput(session_client);
        timed_out = 1;
        break
    end
end