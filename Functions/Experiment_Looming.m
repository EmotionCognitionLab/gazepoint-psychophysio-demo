function Experiment_Looming(varargin)
%This is the equivalent of the experiment script for a looming task that
%connects to GP3 server and sends messages via session1_client-GP3_server
%socket.
%
%Author: Ringo Huang (ringohua@usc.edu)
%Created: 4/30/2019

%% Parse varargin for duration
if nargin == 0
    baseline_dur = 10;
    post_dur = 10;
elseif nargin == 2
    baseline_dur = varargin{1};
    post_dur = varargin{2};
else
    error('Requires either 0 or 2 input arguments for duration.');
end

%% Set-up client 1 connections
% Create Client1-GP3 socket
session1_client = Client1_ConnectToGP3;

% Tell Client 2 that Client 1 is ready
Client1_SendReadyMsg(session1_client);

%% Run Experiment
run_count = 0;
while 1
    current_user_data_parsed = Client1_GetCurrentUserDataParsed(session1_client);
    
    switch current_user_data_parsed{1}
        case 'START'
            % Retrieve the hand selected by user and convert to lowercase
            ear = lower(current_user_data_parsed{2});
            tone_type = lower(current_user_data_parsed{3});
            tone_freq = str2double(current_user_data_parsed{4});
            tone_dur = str2double(current_user_data_parsed{5});
            Fs = 20100; %Tone sampling rate
            
            [y,Fs] = GenerateTone(tone_type,tone_freq,tone_dur,ear,Fs);
            
            run_count = run_count+1;
            fprintf(['\nRUN ' num2str(run_count)])
            flushinput(session1_client);    % clear buffer
            
            % Run Experiment Here
            Client1_SendMessages(session1_client,'BASELINE');            
            if Client1_PauseForDurationOrStopExperiment(session1_client,baseline_dur) == 1; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)
            
            soundsc(y,Fs)
            Client1_SendMessages(session1_client,'AUDIO');            
            if Client1_PauseForDurationOrStopExperiment(session1_client,tone_dur) == 1; continue; end
            
            Client1_SendMessages(session1_client,'POST_AUDIO');
            if Client1_PauseForDurationOrStopExperiment(session1_client,post_dur) == 1; continue; end
                                
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
