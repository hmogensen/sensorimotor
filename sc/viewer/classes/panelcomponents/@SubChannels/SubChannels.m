classdef SubChannels < PanelComponent
  properties
    ui_extra_channels
  end
  methods
    function obj = SubChannels(panel)
      obj@PanelComponent(panel);
    end

    function populate(obj,mgr)
      obj.ui_extra_channels = ScList();
      for k=2:obj.gui.analog_ch.n
        mgr.newline(20);
        mgr.add(sc_ctrl('text',sprintf('Channel #%i',k)),100);
        ui_channel = mgr.add(sc_ctrl('popupmenu',...
          [],@(~,~) obj.show_panels(false),'visible','off'),100);
        mgr.newline(5);
        obj.ui_extra_channels.add(ui_channel);
      end

    end

    function initialize(obj)
      str = obj.gui.sequence.signals.values('tag');
      for k=1:obj.ui_extra_channels.n
        signal = obj.gui.analog_ch.get(k+1).signal;
        if isempty(signal)
          val = k+1;
        else
          ind = find(cellfun(@(x) strcmp(x,signal.tag), str));
          if isempty(ind)
            val = k+1;
          else
            val = ind;
          end
        end
        set(obj.ui_extra_channels.get(k),'string',str,'value',val,...
          'visible','on');
        end
      end

      function updated = update(obj)
        updated = true;
        signals = obj.gui.sequence.signals;%.values('tag');
        for k=1:obj.ui_extra_channels.n
          h = obj.ui_extra_channels.get(k);
          val = get(h,'value');
          str = get(h,'string');
          obj.gui.analog_subch.get(k).signal = signals.get('tag',str{val});
        end
      end
    end
  end
