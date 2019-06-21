function [dataSplit, current_user_data] = RetrieveDataFromBuffer(session_client)
% Reads XML formatted string from the client buffer and parses the string
% to get the data; also saves the USER_DATA value in current_user_data
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 6/21/2019

dataReceived = fscanf(session_client);
dataSplit = strsplit(dataReceived,'"');
current_user_data = dataSplit{end-1};