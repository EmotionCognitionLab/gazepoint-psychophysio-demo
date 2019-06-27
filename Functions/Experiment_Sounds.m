function Experiment_Sounds
% Experiment Script for the Sounds Task, run on a separate Matlab
% session (client 1). Can play any .mp3 or .wav sound file found in a
% stimulus folder defined by the user in the GUI
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 4/30/2019

%% Addpath to the stimuli
Experiment_AddPathToStimuli('Sounds');

%% Set-up client 1 connections
% Create Client1-GP3 socket
session1_client = Client1_ConnectToGP3;

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
            [p, stop_recording] = Experiment_ReformatParametersToStructure(name_value_pairs, {'AUDIO','EAR','EVENT1DUR','EVENT2DUR'});        
            if stop_recording == 1; continue; end   % stop recording returns 1 if a required fieldname is missing;
            audio = lower(p.AUDIO);    % save audio filename to audio
            
            % Underscores and dashes in audio filename were replaced with
            % <UNDERSCORE> and <DASH>; Undo to get original
            audio = regexprep(audio,'<underscore>','_');
            audio = regexprep(audio,'<dash>','-');
            
            % Uppercase letters were preceded with <UPPER>; Remove the
            % <UPPER> from the audio filename, and capitalize the character
            % following it
            audio = regexprep(audio,'<upper>([a-z])','${upper($1)}');
            
            % Read and process the audio file
            audio_info = audioinfo(audio);
            [y, Fs] = audioread(audio);
            audio_dur = audio_info.Duration;
            
            % Create audioplayer object for preloading
            audio_obj = audioplayer(y, Fs);
        
            if audio_info.NumChannels == 1
                % For mono
                switch lower(p.EAR)
                    case 'left'
                        y = [y zeros(length(y),1)];
                    case 'right'
                        y = [zeros(length(y),1) y];
                    case 'both'
                        % don't need to do anything
                end
            else
                % For stereo
                switch lower(p.EAR)
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
            zero_time = tic;
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT1DUR) == 1; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)  
            fprintf(['\nBaseline duration - ' num2str(toc(zero_time))]);   
            
            t=tic;
            audio_obj.play;
            fprintf(['\nAudio out delay - ' num2str(toc(t))]);
            
            Client1_SendMessages(session1_client,'AUDIO');
            
            zero_time = tic;
            if Client1_PauseForDurationOrStopExperiment(session1_client,audio_dur) == 1; continue; end
            fprintf(['\nAudio duration - ' num2str(toc(zero_time))]);
            
            zero_time = tic;
            Client1_SendMessages(session1_client,'POST_AUDIO');
            fprintf(['\nPost Audio duration - ' num2str(toc(zero_time))]);
            if Client1_PauseForDurationOrStopExperiment(session1_client,p.EVENT2DUR) == 1; continue; end
                                
            Client1_SendMessages(session1_client,'STOP_RECORDING'); 
            
            pause(.1)
        case 'DISCONNECT'
            SendMsgToGP3(session1_client,'DISCONNECTED');
            break
    end
    pause(.01);
end

%% Clean up socket
fprintf('\nDisconnecting session 1 socket...\n\n')
CleanUpSocket(session1_client);
