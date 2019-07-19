function timed_out_state = Client2_WaitForBufferToFill(app, time_limit)
% Waits up to time_limit (in seconds) for client 2 buffer to fill with
% data. If time limit is exceeded, returns timed_out_state == 1, else
% timed_out_state == 0
%
% Insert this function at the beginning of a loop that streams and records
% the GP3 data from the buffer to ensure that there is data available to be
% streamed.
%
% Written by: Ringo Huang
% Created on: 7/17/2019

timed_out_state = 0;    % default is return 0

start_time = tic;
% pause until buffer fills or timed_out_state == 1
while app.session2_client.BytesAvailable == 0 && timed_out_state == 0
    if toc(start_time) > time_limit
        GUI_CommandWindowMessages('WarningEmptyBuffer');
        timed_out_state = 1;    % if time limit is exceeded, return 1
    end
    pause(0.01)                 % avoid polling continuously
end