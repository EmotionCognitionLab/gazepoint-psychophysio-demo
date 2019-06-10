function app = GUI_InitializePupilPlots(app)
% Sets up the left and right pupil plot and figure axes
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/14/2019

hold(app.PupilAxis,'on');
app.left_pupil_plot=animatedline(app.PupilAxis,'Color',[0.5 0.8 0.5]);
app.right_pupil_plot=animatedline(app.PupilAxis,'Color',[0.5 0.5 0.8]);
legend(app.PupilAxis,[app.left_pupil_plot,app.right_pupil_plot],'Left','Right','AutoUpdate','off');
hold(app.PupilAxis,'off');