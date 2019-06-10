function app = GUI_ClearPlots(app)
% Clear pupil and marker plots after user starts new recording
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/1/2019

clearpoints(app.left_pupil_plot);
clearpoints(app.right_pupil_plot);
for marker_num = 1:numel(app.marker_labels)
    clearpoints(app.marker(marker_num).ln);
end