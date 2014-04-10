function panel = get_triggerpanel(obj)

layout_done = false;

panel = uipanel('title','Trigger');
obj.triggerpanel = panel;

mgr = ScLayoutManager(panel);
mgr.newline(15);

if obj.state == ScGuiState.spike_detection
    %if state == ampl_analysis, obj.signal will be given by
    %obj.ampl.parent_signal
    mgr.newline(20);
    mgr.add(getuitext('Signal'),100);
    ui_signal = mgr.add(sc_ctrl('popupmenu',[],@signal_callback,'visible','off'),100);
    mgr.newline(5);
end

    function signal_callback(~,~)
        if obj.plot_waveform_shapes
            %This option requires reload - hide other panels
            set_visible(0);
        end
        
        str = get(ui_signal,'String');
        val = get(ui_signal,'Value');
        tag = str{val};
        obj.signal = obj.sequence.signals.get('tag',tag);
    end

mgr.newline(20);
mgr.add(getuitext('Smoothing width:'),100);
ui_smoothing_width = mgr.add(uicontrol('style','edit','callback',...
    @smoothing_width_callback),100);
mgr.add(getuitext('bins (1 = off)'),80);

    function smoothing_width_callback(~,~)
        set_visible(0);
        val = str2double(get(ui_smoothing_width,'string'));
        obj.signal.filter.smoothing_width = val;
        obj.has_unsaved_changes = true;
    end

mgr.newline(20);
mgr.add(getuitext('Artifact width'),100);
ui_artifact_width = mgr.add(uicontrol('style','edit','callback',...
    @artifact_width_callback),100);
mgr.add(getuitext('bins (0 = off)'),80);

    function artifact_width_callback(~,~)
        set_visible(0);
        val = str2double(get(ui_artifact_width,'string'));
        obj.signal.filter.artifact_width = val;
        obj.has_unsaved_changes = true;
    end

mgr.newline(20);
if obj.state == ScGuiState.spike_detection
    mgr.add(sc_ctrl('text','Waveform','HorizontalAlignment','left'),100);
    ui_waveform = mgr.add(sc_ctrl('popupmenu',[],@waveform_callback,'visible','off'),100);
    ui_new_waveform = mgr.add(sc_ctrl('pushbutton','New waveform',@new_waveform_callback),100);
elseif obj.state == ScGuiState.ampl_analysis
    mgr.add(sc_ctrl('text','Amplitudes','HorizontalAlignment','left'),100);
    ui_ampl = mgr.add(sc_ctrl('popupmenu',[],@ampl_callback,'visible','off'),100);
    ui_new_ampl = mgr.add(sc_ctrl('pushbutton','New amplitude',@new_ampl_callback),100);
end

    function waveform_callback(~,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        str = get(ui_waveform,'string');
        val = get(ui_waveform,'val');
        tag = str{val};
        obj.waveform = obj.signal.waveforms.get('tag',tag);
    end

    function new_waveform_callback(~,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        obj.new_waveform();
    end

    function ampl_callback(src,~)
        val = get(src,'Value');
        str = get(src,'string');
        tag = str{val};
        obj.ampl = obj.sequence.ampl_list.get('tag',tag);
    end

    function new_ampl_callback(~,~)
        obj.new_amplitude();
    end

mgr.newline(5);

if obj.state == ScGuiState.spike_detection
    mgr.newline(20);
    ui_no_trigger = mgr.add(uicontrol('style','checkbox','String','No trigger',...
        'Callback',@no_trigger_callback,'Value',obj.no_trigger),100);
    
    mgr.newline(20);
    mgr.add(getuitext('Trigger'),100);
    ui_triggerparent = mgr.add(sc_ctrl('popupmenu',[],@triggerparent_callback,...
        'visible','off'),100);
    ui_trigger = mgr.add(sc_ctrl('popupmenu',[],@trigger_callback,'Visible','off'),...
        100);
    
    mgr.newline(10);
    
end

for i=1:obj.extrasignalaxes.n
    mgr.newline(20);
    mgr.add(getuitext(['Plot ' num2str(i+1)]),100);
    src = mgr.add(uicontrol('style','popupmenu','string',...
        {obj.sequence.signals.list.tag},'Value',i+1,'callback',...
        @(src,~) extrasignal_callback(src,i)),100);
    extrasignal_callback(src,i);
    mgr.newline(10);
end

mgr.newline(20);
mgr.add(getuitext('Pretrigger'),75);
ui_pretrigger = mgr.add(uicontrol('style','edit','string',obj.pretrigger,...
    'callback',@range_callback),75);
mgr.add(getuitext('Posttrigger'),70);
ui_posttrigger = mgr.add(uicontrol('style','edit','string',obj.posttrigger,...
    'callback',@range_callback),75);

if obj.state == ScGuiState.spike_detection
    mgr.newline(20);
    ui_plot_waveforms = mgr.add(uicontrol('style','checkbox','string',...
        'Plot waveform shapes (requires more time to load)',...
        'callback',@plot_waveforms_callback,'Value',obj.plot_waveform_shapes),300);
end

mgr.newline(20);
ui_plot_raw = mgr.add(uicontrol('style','checkbox','string','Plot raw data',...
    'Value',obj.plot_raw,'callback',@(~,~) set_visible(0)),100);

mgr.newline(20);
ui_load = mgr.add(uicontrol('style','pushbutton','string',...
    'Load membrane potential (required for waveform shapes)','callback',...
    @load_callback),obj.leftpanelwidth);

    function ampl_listener(~,~)
        if isempty(obj.ampl)
            set(ui_load,'style','text','string',...
                sprintf('You must press ''%s'' to load',get(ui_new_ampl,'string')),...
                'enable','inactive','Fontweight','bold');
            set(ui_ampl,'visible','off');
        else
            set(ui_load,'style','pushbutton','string',...
                'Load analog signals',...
                'enable','on','Fontweight','normal');
            set(ui_ampl,'visible','on','string',obj.sequence.ampl_list.values('tag'),...
                'value',obj.sequence.ampl_list.indexof(obj.ampl));
        end
    end

mgr.newline(2);
mgr.trim;

%Add triggers
if obj.state == ScGuiState.spike_detection    
    sc_addlistener(obj,'no_trigger_',@no_trigger_listener,panel);
    sc_addlistener(obj,'triggerparent_',@triggerparent_listener,panel);
    sc_addlistener(obj,'trigger_',@trigger_waveform_listener,panel);
    sc_addlistener(obj,'sequence_',@sequence_waveform_listener,ui_new_waveform);
    sc_addlistener(obj,'signal_',@signal_waveform_listener,ui_new_waveform);
elseif obj.state == ScGuiState.ampl_analysis
    sc_addlistener(obj,'sequence_',@sequence_ampl_listener,ui_ampl);
    sc_addlistener(obj,'signal_',@signal_listener,ui_new_ampl);
    sc_addlistener(obj,'ampl_',@ampl_listener,ui_load);
end

obj.load_sequence_fcn = @load_callback;
%sc_addlistener(obj,'trigger_',@trigger_listener,panel);

layout_done = true;

    function extrasignal_callback(src,i)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        val = get(src,'Value');
        str = get(src,'string');
        tag = str{val};
        signal = obj.sequence.signals.get('tag',tag);
        obj.extrasignalaxes.get(i).signal = signal;
    end

    function range_callback(src,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        val = str2double(get(src,'string'));
        switch src
            case ui_pretrigger
                obj.pretrigger = val;
            case ui_posttrigger
                obj.posttrigger = val;
            otherwise
                error('debugging error : unkown option')
        end
    end

    function plot_waveforms_callback(~,~)
        set_visible(0);
        obj.plot_waveform_shapes = get(ui_plot_waveforms,'Value');
    end

    function load_callback(~,~)
        obj.disable_all(1);
        obj.zoom_on = false; obj.pan_on = false;
        obj.pretrigger = str2double(get(ui_pretrigger,'string'));
        obj.posttrigger = str2double(get(ui_posttrigger,'string'));
        if obj.pretrigger>=obj.posttrigger
            msgbox('Error: pre trigger >= post trigger');
            return
        end
        if obj.no_trigger
            if obj.signal.N>obj.max_array_size
                msgbox('More than maximum allowed array size.');
                return
            end
            if obj.pretrigger>0 || obj.pretrigger>=obj.posttrigger || ...
                    obj.posttrigger<=0
                msgbox(['Plotting in ''no trigger'' mode requires that ' ...
                    'pretrigger <= 0 < posttrigger']);
                return
            end
            obj.trigger = ScSpikeTrain('',...
                obj.sequence.tmin-obj.pretrigger:(obj.posttrigger-obj.pretrigger):...
                obj.sequence.tmax);
        end
        if obj.state == ScGuiState.spike_detection
            obj.waveform = obj.waveform;
        elseif obj.state == ScGuiState.ampl_analysis
            obj.ampl = obj.ampl;
        end
        obj.v_raw = obj.signal.sc_loadsignal();
        obj.v = obj.signal.filter.filt(obj.v_raw,0,inf);
        obj.plot_raw = get(ui_plot_raw,'Value');
        if ~obj.plot_raw
            obj.v_raw = [];
        end
        if obj.plot_waveform_shapes
            t = (0:(numel(obj.v)-1))';
            pos = t>=(round(obj.tmin/obj.signal.dt)+1) & ...
                t<(round(obj.tmax/obj.signal.dt)+1);
            clear t;
            if ~isempty(obj.waveform)
                [~,ind] = obj.waveform.match(obj.v(pos));
                obj.wfpos = ind>0;
            else
                obj.wfpos = false(nnz(pos),1);
            end
        else
            obj.wfpos = [];
        end
        maxsweeps = numel(obj.triggertimes);
        obj.sweep = obj.sweep(obj.sweep<=maxsweeps);
        obj.update_plotpanel_fcn();
        obj.update_histogrampanel_fcn();
        obj.update_savepanel_fcn();
        
        obj.plot_fcn();
        obj.disable_all(0);
        set_visible(1);
        obj.sweep = 1;
    end

%Inactivate other panels to stop user from causing a crash by pressing
%inadequate buttons
    function set_visible(on)
        if ~layout_done
            return
        end
        if on
            visible = 'on';
        else
            visible = 'off';
        end
        set(obj.plotpanel,'visible',visible);
        set(obj.waveformpanel,'visible',visible);
    end

    function no_trigger_callback(~,~)
        obj.no_trigger = get(ui_no_trigger,'Value');
    end

    function triggerparent_callback(~,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        str = get(ui_triggerparent,'String');
        val = get(ui_triggerparent,'Value');
        tag = str{val};
        obj.triggerparent = obj.sequence.gettriggerparents(obj.tmin,obj.tmax).get('tag',tag);
    end

    function trigger_callback(~,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        str = get(ui_trigger,'String');
        val = get(ui_trigger,'Value');
        tag = str{val};
        obj.trigger = obj.triggerparent.triggers.get('tag',tag);
    end


%Listeners
    function no_trigger_listener(~,~)
        if obj.no_trigger
            set(ui_triggerparent,'visible','off');
            set(ui_trigger,'visible','off');
        else
            set(ui_triggerparent,'visible','on');
            set(ui_trigger,'visible','on');
        end
    end
    
    function triggerparent_listener(~,~)
        if ~isempty(obj.triggerparent)
            triggers = obj.triggerparent.triggers;
            set(ui_trigger,'string',triggers.values('tag'),...
                'value',triggers.indexof(obj.trigger),...
                'visible','on');
        else
            set(ui_triggerparent,'string',[],'visible','off');
        end
    end

    function trigger_waveform_listener(~,~)
        if ~isempty(obj.trigger)
            triggers = obj.triggerparent.triggers;
            set(ui_trigger,'string',triggers.values('tag'),'value',triggers.indexof(obj.trigger),...
                'visible','on');
        else
            set(ui_trigger,'string',[],'visible','off');
        end
        if isempty(obj.signal) || isempty(obj.trigger) || isempty(obj.trigger.gettimes(obj.tmin,obj.tmax))
            set(ui_load,'style','text','fontweight','bold','string',...
                'No signal or trigger, cannot load data','enable','inactive');
        else
            set(ui_load,'style','pushbutton','fontweight','normal','string',...
                'Load signal','enable','on');
        end
    end

    function signal_waveform_listener(~,~)
        if isempty(obj.signal)
            set(ui_waveform,'string',[],'visible','off');
            set(ui_new_waveform,'visible','off');
        elseif ~obj.signal.waveforms.n
            set(ui_waveform,'string',[],'visible','off');
            set(ui_new_waveform,'visible','on');
        else
            set(ui_waveform,'string',obj.signal.waveforms.values('tag'),...
                'Value',obj.signal.waveforms.indexof(obj.waveform),'visible','on');
            set(ui_new_waveform,'visible','on');
        end
        signal_listener();
    end

    function signal_listener(~,~)
        if ~isempty(obj.signal)
            set(ui_smoothing_width,'string',obj.signal.filter.smoothing_width,...
                'visible','on');
            set(ui_artifact_width,'string',obj.signal.filter.artifact_width,...
                'visible','on');
        else
            set(ui_smoothing_width,'visible','off');
            set(ui_artifact_width,'visible','off');
        end
        if isempty(obj.signal) || isempty(obj.trigger) || isempty(obj.trigger.gettimes(obj.tmin,obj.tmax))
            set(ui_load,'style','text','fontweight','bold','string',...
                'No signal or trigger, cannot load data','enable','inactive');
        else
            set(ui_load,'style','pushbutton','fontweight','normal','string',...
                'Load signal','enable','on');
        end
    end

    function sequence_ampl_listener(~,~)
        if isempty(obj.sequence)
            set(ui_ampl,'visible','off','string',[]);
            set(ui_new_ampl,'visible','off');
        elseif ~obj.sequence.ampl_list.n
            set(ui_ampl,'visible','off','string',[]);
            set(ui_new_ampl,'visible','on');
        else
            set(ui_ampl,'visible','on','string',obj.sequence.ampl_list.values('tag'),...
                'Value',obj.sequence.ampl_list.indexof(obj.ampl));
            set(ui_new_ampl,'visible','on');
        end
    end

    function sequence_waveform_listener(~,~)
        if isempty(obj.sequence)
            set(ui_signal,'visible','off','string',[]);
            set(ui_triggerchannel,'visible','off','string',[]);
            set(ui_trigger,'visible','off','string',[]);
        else
            set(ui_signal,'visible','on','String',obj.sequence.signals.values('tag'),...
                'Value',obj.sequence.signals.indexof(obj.signal));
            triggerparents = obj.sequence.gettriggerparents(obj.tmin,obj.tmax);
            if triggerparents.n
                set(ui_triggerparent,'visible','on','string',...
                    triggerparents.values('tag'),...
                    'value',triggerparents.indexof(obj.triggerparent));
            else
                set(ui_triggerparent,'visible','off','string',[]);
            end
        end
    end

end