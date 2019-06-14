function Experiment_Sounds(varargin)
%IADS Audio Presentation run on client 1
%
%Author: Ringo Huang (ringohua@usc.edu)
%Created: 4/30/2019

%% Addpath to the stimuli
Experiment_AddPathToStimuli('Sounds');

%% Parse varargin for duration
if nargin == 0          % default
    baseline_dur = 10;
    postaudio_dur = 5;
elseif nargin == 2      % user-defined
    baseline_dur = varargin{1};
    postaudio_dur = varargin{2};
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
    current_user_data = GetCurrentUserData(session1_client);
    current_user_data_parsed = strsplit(current_user_data,'_');
        
    switch current_user_data_parsed{1}
        case 'START'                       
            % Retrieve the user-defined options and convert to lowercase
            ear = lower(current_user_data_parsed{2});
            audio = lower(current_user_data_parsed{3});
            
            % Underscores in audio filename were replaced with
            % <UNDERSCORE>; Undo to get original
            audio = regexprep(audio,'<underscore>','_');
            
            % Uppercase letters were preceded with <UPPER>; Remove the
            % <UPPER> from the audio filename, and capitalize the character
            % following it
            audio = regexprep(audio,'<upper>([a-z])','${upper($1)}');
            
            % Read and process the audio file
            audio_info = audioinfo(audio);
            [y, Fs] = audioread(audio);
            audio_dur = audio_info.Duration;
            
            if audio_info.NumChannels == 1
                % For mono
                switch ear
                    case 'left'
                        y = [y zeros(length(y),1)];
                    case 'right'
                        y = [zeros(length(y),1) y];
                    case 'both'
                        % don't need to do anything
                end
            else
                % For stereo
                switch ear
                    case 'left'
                        y = sum(y,2)/size(y,2); % convert y from stereo to mono
                        y = [y zeros(length(y),1)];
                    case 'right'
                        y = sum(y,2)/size(y,2); % convert y from stereo to mono
                        y = [zeros(length(y),1) y];
                    case 'both'
                        % don't need to do anything
                end
            end
            
            run_count = run_count+1;
            fprintf(['\nRUN ' num2str(run_count)])
            flushinput(session1_client);    % clear buffer
            
           	% Run Experiment Here
            Client1_SendMessages(session1_client,'BASELINE');            
            if Client1_PauseForDurationOrStopExperiment(session1_client,baseline_dur) == 1; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)
            
            soundsc(y,Fs)       % play audio file
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