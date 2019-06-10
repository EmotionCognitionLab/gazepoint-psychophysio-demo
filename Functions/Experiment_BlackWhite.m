function Experiment_BlackWhite(varargin)
%This is the equivalent of the experiment script for a blackwhite task that
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
    black_dur = 20;
    white_dur = 20;
    post_dur = 10;
elseif nargin == 4
    baseline_dur = varargin{1};
    black_dur = varargin{2};
    white_dur = varargin{3};
    post_dur = varargin{4};
else
    error('Requires either 0 or 4 input arguments for duration.');
end

%% Set-up client 1 connections
% Create Client1-GP3 socket
session1_client = Client1_ConnectToGP3;

% Tell Client 2 that Client 1 is ready
Client1_SendReadyMsg(session1_client);


%% Set up screens
% Define colors
color_black = [0 0 0];       %black
color_white = [255 255 255]; %white
color_baseline = [100 100 100];        %background color for instructions
screen_num = 1;

%% Run Experiment
run_count = 0;
while 1
    current_user_data_parsed = Client1_GetCurrentUserDataParsed(session1_client);
    
    switch current_user_data_parsed{1}
        case 'START'

            % Open window in primary monitor (non-fullscreen for debugging purposes)  
            Screen('Preference','SkipSyncTests',1);
            %w = Screen('OpenWindow',screen_num,color_baseline, [100 100 1000 800]);
            w = Screen('OpenWindow',screen_num,color_baseline);
            [w_width, w_height] = Screen('WindowSize',w);
            windowRect = [0 0 w_width w_height];
            Screen('TextFont',w,'Calibri');
            Screen('TextSize',w,18);
            refrate=Screen('NominalFrameRate',screen_num);
            
            % Set up offscreen windows
            baselineScreen = Screen(w, 'OpenOffscreenWindow', color_baseline, windowRect);
            blackScreen = Screen(w, 'OpenOffscreenWindow', color_black, windowRect);
            whiteScreen = Screen(w, 'OpenOffscreenWindow', color_white, windowRect);
            DrawFormattedText(baselineScreen,'+','center','center',[125 125 125]);
            DrawFormattedText(blackScreen,'+','center','center',[125 125 125]);
            DrawFormattedText(whiteScreen,'+','center','center',[125 125 125]);
            
            % Baseline
            Screen('CopyWindow',baselineScreen,w);
            Screen('Flip',w);
            Client1_SendMessages(session1_client,'BASELINE');
            Screen('CopyWindow',blackScreen,w);
            if Client1_PauseForDurationOrStopExperiment(session1_client,baseline_dur) == 1; sca; continue; end % continues if this function returns 1 (meaning user pressed Stop Experiment button)
            
            % Black
            Screen('Flip',w);
            Client1_SendMessages(session1_client,'BLACK');
            Screen('CopyWindow',whiteScreen,w);
            if Client1_PauseForDurationOrStopExperiment(session1_client,black_dur) == 1; sca; continue; end

            % White
            Screen('Flip',w);
            Client1_SendMessages(session1_client,'WHITE');
            Screen('CopyWindow',baselineScreen,w);
            if Client1_PauseForDurationOrStopExperiment(session1_client,white_dur) == 1; sca; continue; end
            
            % Post
            Screen('Flip',w);
            Client1_SendMessages(session1_client,'POST');
            if Client1_PauseForDurationOrStopExperiment(session1_client,post_dur) == 1; sca; continue; end
              
            sca;
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
