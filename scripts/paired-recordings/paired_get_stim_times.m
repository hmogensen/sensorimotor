function stim_times = paired_get_stim_times(neuron, str_stim)

if nargin<2
  str_stim = {'V1', 'V2', 'V3', 'V4', '1000'};
end

expr       = ScExperiment.load_experiment(neuron.experiment_filename);

file       = get_item(expr.list, neuron.file_tag);
triggers   = file.gettriggers(0, inf);

stims      = get_items(triggers.cell_list, 'tag', str_stim);
stim_times = get_values(stims, @(x) x.gettimes(0,inf));

end