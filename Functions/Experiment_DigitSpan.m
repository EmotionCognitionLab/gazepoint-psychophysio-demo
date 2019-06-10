function Experiment_DigitSpan(varargin)
%This is the equivalent of the experiment script for a digitspan task that
%connects to GP3 server and sends messages via session1_client-GP3_server
%socket.
%
%
% 5/14/2019 - Implemented Client1_PauseForDurationOrStopExperiment to
% handle user pressing the stop experiment button in the main GUI
% 5/14/2019 - Allow user to define event duration
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/15/2019

%% Addpath of sub-dirs from the parent dir of this file
addpath(genpath(fileparts(mfilename('fullpath'))));

%% Parse varargin for duration
if nargin == 0
    baseline_dur = 10;
    digit_dur = 1.5;
    delay_dur = 3;
    recall_dur = 15;
elseif nargin == 4
    baseline_dur = varargin{1};
    digit_dur = varargin{2};
    delay_dur = varargin{3};
    recall_dur = varargin{4};
else
    error('Requires either 0 or 4 input arguments for duration.');
end

%% Set-up client 1 connections
% Create Client1-GP3 socket
session1_client = Client1_ConnectToGP3;

% Tell Client 2 that Client 1 is ready
Client1_SendReadyMsg(session1_client);

%% Read in audio files
for d=1:9
    [y{d},Fs{d}]=audioread([num2str(d) '.wav']);
end
[yg,Fsg]=audioread('Glass.wav');

%% Run Experiment
run_count = 0;
while 1
    current_user_data_parsed = Client1_GetCurrentUserDataParsed(session1_client);
    
    switch current_user_data_parsed{1}
        case 'START'
            % Retrieve the trial configuration from the user_data message            
            trial_load = str2double(current_user_data_parsed{2});
            
            % Set up trial digit sequence
            rng('Shuffle');
            random_nums = Shuffle(1:9);
            digits = random_nums(1:trial_load);
            
            run_count = run_count+1;
            fprintf(['\nRUN ' num2str(run_count)])
            flushinput(session1_client);    % clear buffer
            

            % Baseline
            Client1_SendMessages(session1_client,'BASELINE');
            if Client1_PauseForDurationOrStopExperiment(session1_client,baseline_dur) == 1; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)
            
            % Encoding
            Client1_SendMessages(session1_client,'ENCODING');
            for digit_num = 1:numel(digits)              
                sound(y{digits(digit_num)},Fs{digits(digit_num)});
                if digit_num < numel(digits)
                    if Client1_PauseForDurationOrStopExperiment(session1_client,digit_dur) == 1; continue; end  %ensure 1.5s between digits except last digit
                end
            end

            % Delay
            Client1_SendMessages(session1_client,'DELAY');
            if Client1_PauseForDurationOrStopExperiment(session1_client,delay_dur) == 1; continue; end
            
            % Recall
            sound(yg,Fsg)
            Client1_SendMessages(session1_client,'RECALL');
            if Client1_PauseForDurationOrStopExperiment(session1_client,recall_dur) == 1; continue; end
                                
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
