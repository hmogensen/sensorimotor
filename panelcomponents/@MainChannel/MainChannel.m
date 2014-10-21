 classdef MainChannel < PanelComponent
    %Select main panel
    properties
        ui_channel
    end
    methods
        function obj = MainChannel(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Main channel'),100);
            obj.ui_channel = mgr.add(sc_ctrl('popupmenu',[],@channel_callback,...
                'visible','off'),100);
            mgr.newline(5);
            
            function channel_callback(~,~)
                val = get(obj.ui_channel,'value');
                str = get(obj.ui_channel,'string');
                obj.gui.main_channel.signal = obj.gui.sequence.signals.get('tag',str{val});
                obj.show_panels(false);
            end
        end
        
        function initialize(obj)
%             if isempty(obj.gui.sequence)
%                 set(obj.panel,'visible','off');
%             else
                str = obj.gui.sequence.signals.values('tag');
                if isempty(obj.gui.main_channel.signal)
                    if any(cellfun(@(x) strmcpi(x.tag,'patch'),str))
                        obj.gui.main_channel.signal = obj.gui.sequence.get('tag','patch');
                    else
                        obj.gui.main_channel.signal = obj.gui.sequence.signals.get(1);
                    end
                end
                val = find(cellfun(@(x) strcmp(x,obj.gui.main_signal.tag), str));
                set(obj.ui_channel,'string',str,'value',val,'visible','on');
 %           end
        end
        
    end
end