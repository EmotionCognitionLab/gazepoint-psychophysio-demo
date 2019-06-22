function [p, stop_recording] = Experiment_ReformatParametersToStructure(name_value_pairs,required_fieldnames)
% Reformats the experiment parameters sent via the socket into a data
% structure. Also checks that all required fieldnames are sent.

% Retrieve the parameters sent in the start message
name_value_parsed = split(name_value_pairs(2:end),'-');
p_fieldnames = name_value_parsed(:,:,1);
p_values = name_value_parsed(:,:,2);

% Handle missing field name pairs
stop_recording = 0;
for required_fieldname = required_fieldnames
    if sum(strcmp(p_fieldnames,required_fieldname{1}))==0
        warning(['Missing fieldname ' required_fieldname{1} ' in START message to GP3.']);
        Client1_SendMessages(session1_client,'STOP_RECORDING');
        stop_recording = 1;
        return
    end
end

% Create parameters data structure p
for i = 1:numel(p_fieldnames)
    if sum(isletter(p_values{i})) == 0      % This checks if the value is numeric or only letters
        p.(p_fieldnames{i}) = str2double(p_values{i});
    else
        p.(p_fieldnames{i}) = p_values{i};
    end
end

end
