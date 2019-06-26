function stop_experiment = Client1_PauseForDurationOrStopExperiment(session1_client,duration)
% Pauses script for a user-defined duration while scanning client 1 buffer 
% for STOP_EXPERIMENT message from client 2
%
% Returns 1 if STOP_EXPERIMENT was received; 0 if not. Main script should
% handle the output
%
% Author: Ringo Huang
% Date: 5/14/2019

start_time = tic;
stop_experiment = 0;
while toc(start_time) < duration
    current_user_data_parsed = Client1_GetCurrentUserDataParsed(session1_client);
    if strcmp(current_user_data_parsed{1},'STOP') && strcmp(current_user_data_parsed{2},'EXPERIMENT') % if user presses the Stop Experiment button
        stop_experiment = 1;
        Client1_SendMessages(session1_client,'STOP_RECORDING');         % sends STOP_RECORDING message, which client 2 will receive and break from recording
        break
    end
    pause(0.001)
end

