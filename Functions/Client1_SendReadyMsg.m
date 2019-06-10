function Client1_SendReadyMsg(session_client)
% Client 1 refers to the Matlab session responsible for controlling the
% experiment or stimuli presentation. Sends the experiment-related markers
% to the GP3 server.
%
% This function sends the confirmation CLIENT1_READY message to GP3 server.
% When client 2 receives this message, it knows  to advance.
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/2/2019


SendMsgToGP3(session_client,'CLIENT1_READY');
pause(.1);
SendMsgToGP3(session_client,'CLIENT1_WAITING');

fprintf('Client 1 is ready. Waiting for START_EXPERIMENT message from client 2...\n\n');

end