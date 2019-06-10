function Experiment_IADS(varargin)
%IADS Audio Presentation run on client 1
%
%Author: Ringo Huang (ringohua@usc.edu)
%Created: 4/30/2019

%% Addpath to the stimuli
Experiment_AddPathToStimuli('IADS');

%% Parse varargin for duration
if nargin == 0          % default
    baseline_dur = 10;
    audio_dur = 3;
    postaudio_dur = 5;
elseif nargin == 3      % user-defined
    baseline_dur = varargin{1};
    audio_dur = varargin{2};
    postaudio_dur = varargin{3};
else
    error('Requires either 0 or 3 input arguments for duration.');
end

%% Set-up client 1 connections
% Create Client1-GP3 socket
session1_client = Client1_ConnectToGP3;

% Tell Client 2 that Client 1 is ready
Client1_SendReadyMsg(session1_client);

%% Set up audio for left and right channels
audiofiles = {'neg_275_3s.wav','neg_712_3s.wav','neg_1006_3s.wav','neg_1029_3s.wav','neg_1062_3s.wav','neu_225_3s.wav','neu_320_3s.wav','neu_425_3s.wav','neu_2039_3s.wav','neu_2065_3s.wav'};
audiofieldnames = {'neg1','neg2','neg3','neg4','neg5','neu1','neu2','neu3','neu4','neu5'};

for i=1:numel(audiofiles)
    [y.both.(audiofieldnames{i}), Fs.both.(audiofieldnames{i})] = audioread(audiofiles{i});
    y.left.(audiofieldnames{i}) = [y.both.(audiofieldnames{i}) zeros(length(y.both.(audiofieldnames{i})),1)];
    y.right.(audiofieldnames{i}) = [zeros(length(y.both.(audiofieldnames{i})),1) y.both.(audiofieldnames{i})];
end

%% Run Experiment
run_count = 0;
while 1
    current_user_data = GetCurrentUserData(session1_client);
    current_user_data_parsed = strsplit(current_user_data,'_');
        
    switch current_user_data_parsed{1}
        case 'START'
            % Retrieve the hand selected by user and convert to lowercase
            ear = lower(current_user_data_parsed{2});
            audio = lower(current_user_data_parsed{3});
            
            run_count = run_count+1;
            fprintf(['\nRUN ' num2str(run_count)])
            flushinput(session1_client);    % clear buffer
            
           	% Run Experiment Here
            Client1_SendMessages(session1_client,'BASELINE');            
            if Client1_PauseForDurationOrStopExperiment(session1_client,baseline_dur) == 1; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)
            
            sound(y.(ear).(audio),Fs.both.(audio))       % play IADS audio file
            Client1_SendMessages(session1_client,'AUDIO');            
            if Client1_PauseForDurationOrStopExperiment(session1_client,audio_dur) == 1; continue; end
            
            Client1_SendMessages(session1_client,'POST_AUDIO');
            if Client1_PauseForDurationOrStopExperiment(session1_client,postaudio_dur) == 1; continue; end
                                
            Client1_SendMessages(session1_client,'STOP_RECORDING'); 
            
            pause(.1)
            SendMessages(session1_client,'STOP_EYETRACKER');   
        case 'DISCONNECT'
            SendMsgToGP3(session1_client,'DISCONNECTED');
            break
    end
    pause(.01);
end

%% Clean up socket
fprintf('\nDisconnecting session 1 socket...\n\n')
CleanUpSocket(session1_client);
end

function current_user_data = GetCurrentUserData(session1_client)
%scan data from buffer and parse the xml format
dataReceived = fscanf(session1_client);
split = strsplit(dataReceived,'"');
current_user_data = split{end-1};
end

function SendMessages(session1_client,msg)
%sends msg to gp3 server as well as prints message in command window
fprintf(['\n' msg]);
SendMsgToGP3(session1_client,msg);
end