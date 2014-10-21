function show(obj)

%Clear all figures
clf(obj.btn_window,'reset');
set(obj.btn_window,'ToolBar','None','MenuBar','none');
set(obj.btn_window,'CloseRequestFcn',@(~,~) obj.close_request);
clf(obj.plot_window,'reset');
set(obj.plot_window,'ToolBar','None','MenuBar','none');
set(obj.plot_window,'Color',[0 0 0]);

%Create panels
obj.panels = CascadeList();
obj.add_panels();
mgr = ScLayoutManager(obj.btn_window);
for k=1:obj.panels.n
    panel = obj.panels.get(k);
    setwidth(panel,obj.panel_width);
    mgr.newline(getheight(panel));
    mgr.add(panel);
end
mgr.trim();

%Create plot axes
if obj.show_digital_channels
    obj.digital_channels.ax = axes;
end
for k=1:obj.analog_ch.n
    obj.analog_ch.get(k).ax = axes;
end
if ~ishandle(obj.plot_window)
    obj.plot_window = figure;
end
mgr = ScLayoutManager(obj.plot_window);
for k=1:obj.plots.n
    plotaxes = obj.plots.get(k);
    mgr.newline(getheight(plotaxes));
    mgr.add(plotaxes);
end

for k=1:obj.panels.n
    if k>obj.panels.n
        break;
    else
        panel = obj.panels.get(k);
        panel.initialize_panel();
        panel.update_panel();
        if ~panel.enabled
            break;
        end
    end
end
drawnow
obj.position_figures();
figure(obj.btn_window)
end