function set_experiment(obj, experiment)

if ischar(experiment)

  sc_settings.set_last_experiment(experiment);
  experiment = load_experiment(experiment);
  
end

obj.experiment = experiment;

if isempty(experiment)
  
  obj.set_file([]);

else
  
  file = get_set_val(obj.experiment.list, obj.file, 1);
  obj.set_file(file);

end

end