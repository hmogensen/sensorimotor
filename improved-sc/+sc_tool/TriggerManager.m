classdef TriggerManager < handle
  
  properties (Abstract)
    plot_mode
  end
  
  properties (Dependent)
    trigger_parent
    trigger
    trigger_indx
    trigger_incr
    trigger_time
    all_trigger_times
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_trigger_parent
    m_trigger
    m_trigger_indx
    m_trigger_incr
    m_trigger_time
  end
  
  properties (Abstract)
    sequence
  end
  
  methods (Abstract)
    varargout = update_plots(varargin)
  end
  
  methods
    
    function val = get.all_trigger_times(obj)
      
      if isempty(obj.trigger)
        val = obj.m_trigger_time;
      else
        val = obj.trigger.gettimes(obj.sequence.tmin, obj.sequence.tmax);
      end
      
    end
    
  end
  
  methods
    %Getters & Setters
    
    function val = get.trigger_parent(obj)
      val = obj.m_trigger_parent;
    end
    
    function set.trigger_parent(obj, val)
      
      if isa(val, 'sc_tool.EmptyClass')
        
        if isempty(val.source)
          
          obj.m_trigger_parent = val;
          obj.trigger = get_set_val(obj.signal1.amplitudes.list, ...
            obj.amplitude, 1);
          
        else
          
          obj.m_trigger_parent = val.source;
          
          
        end
        
      else
        
        obj.m_trigger_parent = val;
        obj.trigger = get_set_val(val.triggers.list, obj.trigger, 1);
        
      end
      
    end
    
    function val = get.trigger(obj)
      val = obj.m_trigger;
    end
    
    function set.trigger(obj, val)
      
      obj.m_trigger = val;
      
      if isempty(obj.m_trigger)
        obj.trigger_indx = [];
      else
        obj.trigger_indx = 1;
      end
      
      %       if obj.plot_mode == sc_tool.PlotModeEnum.plot_amplitude && ...
      %           ~isa(obj.m_trigger, 'ScAmplitude')
      %
      %         obj.plot_mode = sc_tool.PlotModeEnum.plot_sweep;
      %
      %       end
      
    end
    
    function val = get.trigger_indx(obj)
      val = obj.m_trigger_indx;
    end
    
    
    function set.trigger_indx(obj, val)
      
      if ~isempty(obj.trigger)
        val = mod(val -1 , length(obj.all_trigger_times)) + 1;
      end
      
      if size(val, 1) > 1
        val = val';
      end
      
      obj.m_trigger_indx = val;
      
      if isempty(obj.trigger_indx)
        obj.trigger_time = obj.sequence.tmin;
      else
        obj.trigger_time = obj.all_trigger_times(obj.trigger_indx);
      end
      
      if isempty(obj.trigger)
        
        if length(obj.trigger_incr) ~= 1
          obj.trigger_incr = .8 * (obj.posttrigger - obj.pretrigger);
        end
        
      else
        
        obj.trigger_incr = obj.trigger_incr - mod(obj.trigger_incr, 1);
        
      end
    end
    
    function val = get.trigger_time(obj)
      val = obj.m_trigger_time;
    end
    
    function set.trigger_time(obj, val)
      
      if size(val, 1) > 1
        val = val';
      end
      
      obj.m_trigger_time = val;
      obj.update_plots();
      
    end
    
    function val = get.trigger_incr(obj)
      val = obj.m_trigger_incr;
    end
    
    function set.trigger_incr(obj, val)
      obj.m_trigger_incr = val;
    end
    
  end
  
end