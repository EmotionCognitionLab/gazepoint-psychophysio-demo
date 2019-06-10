function current_user_data_parsed = Client1_GetCurrentUserDataParsed(session1_client)
%scan data from buffer and parse the xml format

dataReceived = fscanf(session1_client);
split = strsplit(dataReceived,'"');
current_user_data = split{end-1};
current_user_data_parsed = strsplit(current_user_data,'_');
end