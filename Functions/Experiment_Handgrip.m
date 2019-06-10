function Experiment_Handgrip(varargin)
%This is the equivalent of the experiment script for a handgrip task that
%connects to GP3 server and sends messages via session1_client-GP3_server
%socket.
%
%Author: Ringo Huang (ringohua@usc.edu)
%Created: 4/30/2019
%
% 5/14/2019 - Implemented Client1_PauseForDurationOrStopExperiment to
% handle user pressing the stop experiment button in the main GUI
% 5/14/2019 - Allow user to define event duration

%% Addpath to the stimuli
Experiment_AddPathToStimuli('Handgrip');

%% Parse varargin for duration
if nargin == 0
    baseline_dur = 30;
    squeeze_dur = 10;
    relax_dur = 30;
elseif nargin == 3
    baseline_dur = varargin{1};
    squeeze_dur = varargin{2};
    relax_dur = varargin{3};
else
    error('Requires either 0 or 3 input arguments for duration.');
end

%% Set-up client 1 connections
% Create Client1-GP3 socket
session1_client = Client1_ConnectToGP3;

% Tell Client 2 that Client 1 is ready
Client1_SendReadyMsg(session1_client);

%% Set up audio for left and right channels
[y.mono, Fs] = audioread('Tone.wav');       % Be sure that Tone.wav is a single channel audio
y.left = [y.mono  zeros(length(y.mono),1)];
y.right = [zeros(length(y.mono),1) y.mono];

%% Run Experiment
run_count = 0;
while 1
    current_user_data_parsed = Client1_GetCurrentUserDataParsed(session1_client);
    
    switch current_user_data_parsed{1}
        case 'START'
            % Retrieve the hand selected by user and convert to lowercase
            hand = lower(current_user_data_parsed{2});
            
            run_count = run_count+1;
            fprintf(['\nRUN ' num2str(run_count)])
            flushinput(session1_client);    % clear buffer
            
            % Run Experiment Here
            Client1_SendMessages(session1_client,'BASELINE');            
            if Client1_PauseForDurationOrStopExperiment(session1_client,baseline_dur) == 1; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)
            
            sound(y.(hand),Fs)
            Client1_SendMessages(session1_client,'SQUEEZE');            
            if Client1_PauseForDurationOrStopExperiment(session1_client,squeeze_dur) == 1; continue; end
            
            sound(y.(hand),Fs)
            Client1_SendMessages(session1_client,'RELAX');
            if Client1_PauseForDurationOrStopExperiment(session1_client,relax_dur) == 1; continue; end
                                
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
