function Client1_SendMessages(session1_client,msg)
%sends msg to gp3 server as well as prints message in command window

SendMsgToGP3(session1_client,msg);
fprintf(['\n' msg]);

end