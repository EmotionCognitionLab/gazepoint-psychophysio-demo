function Client1_SendMessages(session1_client,msg)
%sends msg to gp3 server as well as prints message in command window
fprintf(['\n' msg]);
SendMsgToGP3(session1_client,msg);
end