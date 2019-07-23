function Experiment_TwoTones
% Experiment Script for the Two Tones Task, run on a separate Matlab
% session (client 1)
%
%Author: Ringo Huang (ringohua@usc.edu)
%Created: 6/18/2019

%% Set-up client 1 connections
% Create Client1-GP3 socket
session1_client = Client1_ConnectToGP3;

% Wait for Client2_Ready Message before proceeding
Client_WaitForMessage(session1_client, 'Client2_Ready');

% Tell Client 2 that Client 1 is ready
Client1_SendReadyMsg(session1_client);

%% Run Experiment
run_count = 0;
while 1
    name_value_pairs = Client1_GetCurrentUserDataParsed(session1_client);
    
    switch name_value_pairs{1}
        case 'START'
            % Put name value pairs (experiment parameters) in a data
            % structure p
            [p, stop_recording] = Experiment_ReformatParametersToStructure(name_value_pairs, {'TONEFREQ','TONEDUR','EAR','EVENT1DUR','EVENT2DUR','EVENT3DUR'});        
            if stop_recording == 1; continue; end   % stop recording returns 1 if a required fieldname is missing;

            % Generate the Tone here
            Fs = 20100;         %sampling rate
            [y,Fs] = GenerateTone('constant',p.TONEFREQ,p.TONEDUR,p.EAR,Fs);
            
            run_count = run_count+1;
            fprintf(['\nRUN ' num2str(run_count)])
            flushinput(session1_client);    % clear buffer
            
            % Run Experiment Here
            Client1_SendMessages(session1_client,'EVENT1');            
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT1DUR) == 1; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)
            
            soundsc(y,Fs)
            Client1_SendMessages(session1_client,'EVENT2');            
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT2DUR) == 1; continue; end
            
            soundsc(y,Fs)
            Client1_SendMessages(session1_client,'EVENT3');
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT3DUR) == 1; continue; end
                                
            Client1_SendMessages(session1_client,'STOP_RECORDING');   
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
