function string_pairs = GUI_CreateStringPairs(p,p_fieldnames)
%Creates the strings for the output file name or the start message sent to
%GP3

for p_num = 1:numel(p_fieldnames)
    p_values{p_num} = p.(p_fieldnames{p_num});
end
string_pairs = strjoin(strcat(p_fieldnames,'-',p_values),'_');

end