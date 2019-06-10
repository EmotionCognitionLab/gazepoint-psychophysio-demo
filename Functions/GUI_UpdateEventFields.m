function app = GUI_UpdateEventFields(app,marker_count,timestamp_zeroed,x,y_left,y_right)
% Performs the following updates on the GUI, taking into consideration the
% first and last marker. Note that a lot of these updates are dependent on
% user defining the Public Properties of the app appropriately.
%
% Author: Ringo Huang
% Date 5/15/2019

% Do for all markers (record timestamp and add marker line to plot):
app.marker(marker_count).timestamp = timestamp_zeroed;
addpoints(app.marker(marker_count).ln, [timestamp_zeroed timestamp_zeroed], [app.marker_y_lower app.marker_y_upper]);

% Do for all markers EXCEPT the last:
if marker_count < numel(app.marker_labels)
    app.(['Event' num2str(marker_count) '_Lamp']).Color = app.lamp_on_color;        %turn on lamp
end

% Do for all markers EXCEPT the first:
if marker_count-1 > 0
    app.(['Event' num2str(marker_count-1) '_Lamp']).Color = app.lamp_off_color;     %turn off lamp
    app.(['Event' num2str(marker_count-1) '_L_EditField']).Value = mean(y_left(x>=app.marker(marker_count-1).timestamp));
    app.(['Event' num2str(marker_count-1) '_R_EditField']).Value = mean(y_right(x>=app.marker(marker_count-1).timestamp));
end
end