classdef AnalogAxes < sc_gui.ChannelAxes
    properties
        signal
    end
    
    properties (Transient)
        v_raw
        v
    end
    
    methods
        function obj = AnalogAxes(gui,signal,varargin)            
            obj@sc_gui.ChannelAxes(gui);
            addlistener(obj.ax,'XLim','PostSet',@xlim_listener);
            sc_addlistener(obj.gui,'xlimits',@xlimits_listener,obj.ax);
            %end
            obj.signal = signal;
            setheight(obj.ax,250);
            plot_raw = 0;
            for k=1:2:numel(varargin)
                switch varargin{k}
                    case 'plot_raw'
                        plot_raw = varargin{k+1};
                end
            end
            obj.update_v(plot_raw);
            
            function xlim_listener(~,~)
                if obj.ax == obj.gui.main_axes
                    obj.gui.xlimits = xlim(obj.ax);
                end
            end
            
            function xlimits_listener(~,~)
                if obj.gui.xlimits(1) < obj.gui.xlimits(2)
                    xlim(obj.ax,obj.gui.xlimits);
                end
            end
        end
        
        function update_v(obj,plot_raw)
            if plot_raw
                obj.v_raw = obj.signal.sc_loadsignal();
                obj.v = obj.signal.filter.filt(obj.v_raw,0,inf);
            else
                obj.v_raw = [];
                obj.v = obj.signal.sc_loadsignal();
                obj.v = obj.signal.filter.filt(obj.v,0,inf);
            end
        end
        
        function plotch(obj,btn_down_fcn)
            sweep = obj.setup_axes();
            xlabel(obj.ax,'Time [s]');
            ylabel(obj.ax,obj.signal.tag);
            set(obj.ax,'XColor',[1 1 1],'YColor',[1 1 1],'Color',[0 0 0],...
                'Box','off');
            grid(obj.ax,'on');
            if ~isempty(sweep)   
                if ~isempty(obj.v_raw)
                    obj.plotv(obj.v_raw,sweep,[1 1 1],[]);
                end
                obj.plotv(obj.v,sweep,[1 0 0],btn_down_fcn);
            else
                cla(obj.ax);
            end
        end
        
        function plotv(obj,v_signal, sweep, plotcolor, btn_down_fcn)
            [v_signal,time] = sc_get_sweeps(v_signal, 0, obj.gui.triggertimes(sweep), ...
                obj.gui.pretrigger, obj.gui.posttrigger, ...
                obj.signal.dt);
            if ~isempty(obj.gui.set_v_to_zero_for_t)
                [~,ind] = min(abs(time-obj.gui.set_v_to_zero_for_t));
                for i=1:size(v_signal,2)
                    v_signal(:,i) = v_signal(:,i) - v_signal(ind,i);
                end
            end
            
            for i=1:size(v_signal,2)
                plothandle = plot(obj.ax,time,v_signal(:,i),'Color',plotcolor,'LineWidth',2);
                if ~isempty(btn_down_fcn)
                    set(plothandle,'ButtonDownFcn',btn_down_fcn);
                end
            end
            if obj.gui.plotmode == sc_gui.PlotModes.plot_avg_all || ...
                    obj.gui.plotmode == sc_gui.PlotModes.plot_avg_selected || ...
                    obj.gui.plotmode == sc_gui.PlotModes.plot_avg_std_all || ...
                    obj.gui.plotmode == sc_gui.PlotModes.plot_avg_std_selected
                avg = mean(v_signal,2);
                plot(obj.ax,time,avg,'Color',[0 1 0],...
                    'LineWidth',2);
            end
            if obj.gui.plotmode == sc_gui.PlotModes.plot_avg_std_all || ...
                    obj.gui.plotmode == sc_gui.PlotModes.plot_avg_std_selected
                stddev = std(v_signal,0,2);
                plot(obj.ax,time,avg+stddev,'Color',[0 0 1],'LineWidth',2);
                plot(obj.ax,time,avg-stddev,'Color',[0 0 1],'LineWidth',2);
            end
        end        
    end
end