function app = GUI_EstablishConnectionsSequence(app, experiment_filename, varargin)
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

% Parse input arguments
p = inputParser;
addRequired(p, 'AppHandle');
addRequired(p, 'ExperimentFilename', @ischar);
addParameter(p, 'ProgressDialog', 'on', @(x) any(validatestring(x,{'on','off'})));
parse(p,app,experiment_filename,varargin{:});

progress_dialog_state = p.Results.ProgressDialog;

% Set up connection between GUI client and GP3 server
app.session2_client = Client2_ConnectToGP3(app,'ProgressDialog',progress_dialog_state);

% Launch background batch process to run the Experiment; Set up
% connection between Experiment Client and GP3 server
Client2_LaunchClient1Experiment(app,experiment_filename,'ProgressDialog',progress_dialog_state,'LaunchAsBatch','yes','CreateLogFile','yes');

% Configure data stream and output file header
app = Client2_ConfigureDataStream(app,'ProgressDialog',progress_dialog_state);

% Send "Client2_Ready" Message (Client 1 Receives message, then responds
% with Client1_Ready).
SendMsgToGP3(app.session2_client,'Client2_Ready');

% Wait to receive CLIENT1_READY message from Experiment client before
% proceeding
client1_message = 'CLIENT1_READY';
if strcmp(progress_dialog_state,'on')
    progress_dlg = uiprogressdlg(app.UIFigure,'Message',...
        ['Waiting for message, "' client1_message '" from client 1...'],...
        'Indeterminate','on');
end
Client_WaitForMessage(app.session2_client,client1_message);
if strcmp(progress_dialog_state,'on')
    close(progress_dlg);
end

% Update Pushbutton States
app.ConnectButton.Enable = 'off';
app.StartExperimentButton.Enable = 'on';
app.DisconnectButton.Enable = 'on';
figure(app.UIFigure);               % Brings UI back to the front
fprintf('Connections Established: Ready to start experiment.\n');
