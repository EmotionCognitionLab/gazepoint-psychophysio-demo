function Experiment_DigitSpan
%This is the equivalent of the experiment script for a digitspan task that
%connects to GP3 server and sends messages via session1_client-GP3_server
%socket.
%
%
% 5/14/2019 - Implemented Client1_PauseForDurationOrStopExperiment to
% handle user pressing the stop experiment button in the main GUI
% 5/14/2019 - Allow user to define event duration
% 7/19/2019 - Reworked to implement all the new functions
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/15/2019


%% Addpath to the stimuli
Experiment_AddPathToStimuli('DigitSpan');

%% Set-up client 1 connections
% Create Client1-GP3 socket
session1_client = Client1_ConnectToGP3;

% Wait for Client2_Ready Message before proceeding
Client_WaitForMessage(session1_client, 'Client2_Ready');

% Tell Client 2 that Client 1 is also ready
Client1_SendReadyMsg(session1_client);

%% Read in audio files
for d=1:9
    [y{d},Fs{d}]=audioread([num2str(d) '.wav']);
end
[yg,Fsg]=audioread('Glass.wav');

%% Run Experiment
run_count = 0;
while 1
    name_value_pairs = Client1_GetCurrentUserDataParsed(session1_client);
    
    switch name_value_pairs{1}
        case 'START'
            % Put name value pairs (experiment parameters) in a data
            % structure p
            [p, stop_recording] = Experiment_ReformatParametersToStructure(name_value_pairs, {'LOAD','EAR','EVENT1DUR','EVENT3DUR','EVENT4DUR','DIGITINTERVAL'});
            if stop_recording == 1; continue; end   % stop recording returns 1 if a required fieldname is missing;
            
            % Set up trial digit sequence
            rng('Shuffle');     % new seed
            random_nums = 1:9;
            random_nums = random_nums(randperm(length(random_nums)));
            digit_sequence = random_nums(1:p.LOAD);
            
            run_count = run_count+1;
            fprintf(['\nRUN ' num2str(run_count)])
            flushinput(session1_client);    % clear buffer         

            % Baseline
            Client1_SendMessages(session1_client,'BASELINE');
            zero_time = tic;
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT1DUR) == 1; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)
            fprintf(['\nBaseline duration - ' num2str(toc(zero_time))]);
            
            % Encoding
            Client1_SendMessages(session1_client,'ENCODING');
            for digit_num = 1:numel(digit_sequence)              
                sound(y{digit_sequence(digit_num)},Fs{digit_sequence(digit_num)});
                if digit_num < numel(digit_sequence)
                    zero_time = tic;
                    if Client1_PauseForDurationOrStopExperiment(session1_client,p.DIGITINTERVAL) == 1; continue; end  %ensure 1.5s between digits except last digit
                    fprintf(['\nDigit interval - ' num2str(toc(zero_time))]);
                end
            end

            % Delay
            Client1_SendMessages(session1_client,'DELAY');
            zero_time = tic;
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT3DUR) == 1; continue; end
            fprintf(['\nDelay duration - ' num2str(toc(zero_time))]);
            
            % Recall
            sound(yg,Fsg)
            Client1_SendMessages(session1_client,'RECALL');
            zero_time = tic;
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT4DUR) == 1; continue; end
            fprintf(['\nRecall duration - ' num2str(toc(zero_time))]);
            
            Client1_SendMessages(session1_client,'STOP_RECORDING');   
            
            pause(.1)
        case 'DISCONNECT'
            Client1_SendMessages(session1_client,'DISCONNECTED');   %confirm disconnected
            break
    end
    pause(0.01);
end

%% Clean up socket
fprintf('\nDisconnecting session 1 socket...\n\n')
CleanUpSocket(session1_client);
end
