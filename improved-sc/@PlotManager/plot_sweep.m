function [v_out, t_out] = plot_sweep(obj, btn_dwn_fcn)

if nargin == 1
  btn_dwn_fcn = [];
end

if ~isempty(obj.signal1)
  
  [v, t] = sc_get_sweeps(obj.v1, 0, obj.trigger_time, obj.pretrigger, ...
    obj.posttrigger, obj.signal1.dt);
  
  for i=1:size(v, 2)
    
    plot(obj.signal1_axes, t, v(:,i), 'Color', 'r', ...
      'ButtonDownFcn', btn_dwn_fcn);
    
  end
  
end

if nargout
  v_out = v;
end

if nargout >= 2
  t_out = t;
end

end