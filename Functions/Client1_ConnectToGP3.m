function session_client = Client1_ConnectToGP3
% Client 1 refers to the Matlab session responsible for controlling the
% experiment or stimuli presentation. Sends the experiment-related markers
% to the GP3 server.
%
% This function sets up the socket between session 1 client and GP3
% server and configures the data stream
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/2/2019

% Set up session 2 set up address and port, and configure socket properties
session_client = tcpip('127.0.0.1', 4242);
session_client.InputBufferSize = 4096;
fopen(session_client);
session_client.Terminator = 'CR/LF';

% Configure data stream
fprintf(session_client, '<SET ID="ENABLE_SEND_USER_DATA" STATE="1" />');

% Enable data flow into buffer
fprintf(session_client, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');

pause(.1)
end