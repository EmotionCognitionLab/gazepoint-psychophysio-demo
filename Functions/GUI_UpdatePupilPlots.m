function app = GUI_UpdatePupilPlots(app, x, y_left, y_right)
%  Updates Pupil plots with each new sample from GP3 server by adding a
%  given number to optimize speed if animating plot in a loop
%
% Author: Ringo Huang (ringohua@usc.edu)
% Created: 5/1/2019

addpoints(app.left_pupil_plot, x, y_left);
addpoints(app.right_pupil_plot, x, y_right);
drawnow limitrate
