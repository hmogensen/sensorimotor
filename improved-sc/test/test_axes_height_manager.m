clc
close all
clipboard('copy', 'D:\raw_data\mat\BGNR140131')
clear classes
h = PlotManager;
h.axes_height = [10 10];
h.axes_height
h.axes_height = 'auto';
h.axes_height

h.pretrigger
h.posttrigger
h.pretrigger = 2;
h.posttrigger = -2;
h.pretrigger = -1;
h.posttrigger = 1;
h.update_axes_position