function Experiment_Looming
%This is the equivalent of the experiment script for a looming task that
%connects to GP3 server and sends messages via session1_client-GP3_server
%socket.
%
%Author: Ringo Huang (ringohua@usc.edu)
%Created: 4/30/2019

%% Set-up client 1 connections
% Create Client1-GP3 socket
session1_client = Client1_ConnectToGP3;

% Wait for Client2_Ready Message before proceeding
Client_WaitForMessage(session1_client, 'Client2_Ready');

% Tell Client 2 that Client 1 is also ready
Client1_SendReadyMsg(session1_client);

%% Run Experiment
run_count = 0;
while 1
    name_value_pairs = Client1_GetCurrentUserDataParsed(session1_client);
    
    switch name_value_pairs{1}
        case 'START'
           % Put name value pairs (experiment parameters) in a data
            % structure p
            [p, stop_recording] = Experiment_ReformatParametersToStructure(name_value_pairs, {'EAR','EVENT1DUR','EVENT3DUR','TONEFREQ','TONEDUR','TONETYPE'});
            if stop_recording == 1; continue; end   % stop recording returns 1 if a required fieldname is missing;          
            Fs = 20100; %Tone sampling rate
            
            [y,Fs] = GenerateTone(p.TONETYPE, p.TONEFREQ, p.TONEDUR, p.EAR, Fs);
            
            run_count = run_count+1;
            fprintf(['\nRUN ' num2str(run_count)])
            flushinput(session1_client);    % clear buffer
            
            % Run Experiment Here
            Client1_SendMessages(session1_client,'BASELINE');
            zero_time = tic;
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT1DUR) == 1; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)
            fprintf(['\nBaseline duration - ' num2str(toc(zero_time))]);
            
            % Audio
            t=tic;
            soundsc(y,Fs)
            fprintf(['\nAudio out delay - ' num2str(toc(t))]);
            Client1_SendMessages(session1_client,'AUDIO');
            zero_time = tic;
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.TONEDUR) == 1; continue; end
            fprintf(['\nAudio duration - ' num2str(toc(zero_time))]);
            
            % Post-audio
            Client1_SendMessages(session1_client,'POST_AUDIO');
            zero_time = tic;
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT3DUR) == 1; continue; end
            fprintf(['\nPost-Audio duration - ' num2str(toc(zero_time))]);
            
            Client1_SendMessages(session1_client,'STOP_RECORDING');
            pause(.1);
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
