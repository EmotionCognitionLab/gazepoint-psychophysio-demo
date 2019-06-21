function Experiment_TwoTones
%This is the equivalent of the experiment script for a looming task that
%connects to GP3 server and sends messages via session1_client-GP3_server
%socket.
%
%Author: Ringo Huang (ringohua@usc.edu)
%Created: 4/30/2019
%
% 5/14/2019 - Implemented Client1_PauseForDurationOrStopExperiment to
% handle user pressing the stop experiment button in the main GUI
% 5/14/2019 - Allow user to define event duration


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
            % Retrieve the parameters sent in the start message
            name_value_parsed = split(name_value_pairs(2:end),'-');
            p_fieldnames = name_value_parsed(:,:,1);
            p_values = name_value_parsed(:,:,2);
            
            % Handle missing field name pairs
            stop_recording = 0;
            for required_fieldname = {'TONEFREQ','TONEDUR','EAR','EVENT1DUR','EVENT2DUR','EVENT3DUR'}
                if sum(strcmp(p_fieldnames,required_fieldname{1}))==0
                    warning(['Missing fieldname ' required_fieldname{1} ' in START message to GP3.']);
                    Client1_SendMessages(session1_client,'STOP_RECORDING');
                    stop_recording = 1;
                    break
                end
            end
            if stop_recording == 1; continue; end
            
            % Create parameters data structure p
            for i = 1:numel(p_fieldnames)
                if sum(isletter(p_values{i})) == 0      % This checks if the value is numeric or only letters
                    p.(p_fieldnames{i}) = str2double(p_values{i});
                else
                    p.(p_fieldnames{i}) = p_values{i};
                end
            end
            
            Fs = 20100;         %sampling rate
            
            % Generate the Tone here
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
