function app = GUI_InitializeMarkers(app)
% Sets up the structure that contains marker labels and its animatedline handles
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/14/2019

hold(app.PupilAxis,'on');
for marker_num = 1:numel(app.marker_labels)
    app.marker(marker_num).ln = animatedline(app.PupilAxis, 'LineStyle', '--','Color',app.marker_colors{marker_num});
    app.marker(marker_num).label = app.marker_labels{marker_num};
end
hold(app.PupilAxis,'off');