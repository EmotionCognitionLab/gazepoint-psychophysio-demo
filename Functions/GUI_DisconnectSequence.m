function app = GUI_DisconnectSequence(app)
% Common sequence of commands to disconnect from GP3 server
%
% Author: Ringo Huang
% Created on: 7/23/2019

% Sends the message to disconnect session 1 client
SendMsgToGP3(app.session2_client,'DISCONNECT');

% Clean Up
CleanUpSocket(app.session2_client);
GUI_CommandWindowMessages('GP3Disconnected');

% Update Pushbutton States
app.ConnectButton.Enable = 'on';
app.DisconnectButton.Enable = 'off';
app.StartExperimentButton.Enable = 'off';
app.StopExperimentButton.Enable = 'off';
app.ReturnButton.Enable = 'on';
