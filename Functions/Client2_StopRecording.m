function Client2_StopRecording(session2_client)
% Stops recording GP3 data and flushes client 2 buffer
%
% Author: Ringo Huang
% Created: 5/15/2019

SendMsgToGP3(session2_client,'RECORDING_STOPPED');
fprintf(session2_client, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');
flushinput(session2_client);
end

