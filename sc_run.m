%to do - add close req fcn
%       - when switching between sequences, ask to save unsaved changes
%       - implementra och testa plot_raw / plot_higlighted
%       - implemetera spikh�jdsanalys
%       - l�gg till spike removal
%       - implement SavePlotOptions
%       - implement HistogramPanel


%function sc_run(clearclasses)
% clc
% 
clc
% edhandle = com.mathworks.mlservices.MLEditorServices.getEditorApplication;
% openeditors = edhandle.getOpenEditors;
% for k=0:openeditors.size-1
%     openeditors.get(k).save
% end

%reset_all
sc -addpath 
addpath viewers\ panelcomponents\ panels\ channelaxes\ enumtypes\ uiobjects\ utility\

%if nargin==0
    clearclasses = 1;%
%end
clf('reset')
if clearclasses
    close all
    clear functions
    clear all
    clear classes
    set(gcf,'unit','normalized','Position',[0 0  1 1]);
else
    clear
end

% 
% clear
% [~, user_name] = system('echo %USERDOMAIN%\%USERNAME%');
% if strcmp(deblank(user_name),'HAMO\Hannes')
%     fname = 'C:\Users\Hannes\Documents\GitHub\matlab-analysis\BBNR_sc.mat';
% else
%     fname = 'C:\Users\hamo\Documents\MATLAB_minus_one\BBNR_sc.mat';
% end
% d=load(fname);
% sequence = d.obj.get(1).get(1);
% mgr = sc_gui.WaveformViewer(sequence);
% mgr.show();
% set(gcf,'units','normalized','position',[0 0 1 1]);
% 
% return
[~, user_name] = system('echo %USERDOMAIN%\%USERNAME%');
if strcmp(deblank(user_name),'HAMO\Hannes')
    fname = 'C:\Users\Hannes\Documents\GitHub\matlab-analysis\BBNR_sc.mat';
else
    fname = 'C:\Users\hamo\Documents\MATLAB_minus_one\BBNR_sc.mat';
end
d=load(fname);
guimgr = GuiManager();
guimgr.viewer.experiment = d.obj;
guimgr.show();
%pause
