function Client2_WaitForData(app)
%If client_socket.bytesavailable == 0, wait for a few seconds for buffer to
%fill up; if no data is received after a time limit (default = 10s),
%then client is closed

client = app.session2_client;
time_limit = 10;

start_time = tic;
while get(client, 'BytesAvailable') == 0 && toc(start_time)<time_limit
end

if toc(start_time)>=10
    warning('Client stopped receiving data before STOP_EYETRACKER trigger was sent');
end
end