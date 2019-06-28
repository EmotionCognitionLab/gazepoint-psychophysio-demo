function app = GUI_EstablishConnectionsSequence(app)
% Common sequence of commands to establish:
%   1. Client 2 (GUI Client) to GP3 Connection
%   2. Launch background batch process for Client 1 (Exp Client) and wait
%   for Client 1 to GP3 Connection
%   3. Prepare UI figure elements
%
% Connection confirmation messages:
%   1. GUI Client launches Experiment Client; Sends "Client2_Ready"; Waits
%   for "Client1_Ready"
%   2. Experiment Client establishes connection; Waits for "Client2_Ready";
%   Receives "Client2_Ready"; Sends "Client1_Ready"
%   3. GUI Client receives "Client1_Ready"; finishes setting up; Enables
%   "start experiment" pushbutton for user
%
% Author: Ringo Huang
% Created on: 6/28/2019

% Set up connection between GUI client and GP3 server
app.session2_client = Client2_ConnectToGP3(app,'ProgressDialog','on');

% Launch background batch process to run the Experiment; Set up
% connection between Experiment Client and GP3 server
Client2_LaunchClient1Experiment(app,'Experiment_Sounds','ProgressDialog','on','LaunchAsBatch','yes','CreateLogFile','yes');

% Configure data stream and output file header
app = Client2_ConfigureDataStream(app,'ProgressDialog','on');

% Send "Client2_Ready" Message (Client 1 Receives message, then responds
% with Client1_Ready).

% Wait to receive CLIENT1_READY message from Experiment client before
% proceeding
Client2_WaitForMessage(app,'Client1_Ready','ProgressDialog','on');

% Flush input buffer
flushinput(app.session2_client);

% Update Pushbutton States
app.ConnectButton.Enable = 'off';
app.StartExperimentButton.Enable = 'on';
app.DisconnectButton.Enable = 'on';
figure(app.UIFigure);       % Brings UI back to the front
