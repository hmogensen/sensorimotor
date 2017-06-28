function saved = save_experiment(experiment, save_path, prompt_before_saving)

saved = false;

if ischar(prompt_before_saving)
  
  if ~strcmpi(prompt_before_saving, '-f')
    error('Unknown command: %s', prompt_before_saving);
  end
else
  file_missing = isempty(save_path) || ~exist(save_path, 'file');
  
  if file_missing || prompt_before_saving
    
    if file_missing
      default_dir = get_default_experiment_dir;
    else
      default_dir = save_path;
    end
    
    [fname, pname] = uiputfile('*_sc.mat', ['Choose file to save ' save_path], ...
      default_dir);
    
    if isnumeric(fname)
      return
    end
    
    save_path = fullfile(pname, fname);
  end
end

obj = experiment;

[~, obj.save_name] = fileparts(save_path);
 
save(save_path, 'obj')

set_last_experiment(save_path);

saved = true;

end