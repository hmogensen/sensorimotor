function [pattern_times, str_pattern]  = get_pattern_times(neuron)

str_pattern = get_intra_patterns();
str_pattern = str_pattern(~startsWith(str_pattern, '1p electrode'));

expr_fname = [get_default_experiment_dir() neuron.experiment_filename];
expr = ScExperiment.load_experiment(expr_fname);

file = get_item(expr.list, neuron.file_tag);
triggers = file.gettriggers(0, inf);

patterns = get_items(triggers.cell_list, 'tag', str_pattern);
pattern_times = get_values(patterns, @(x) x.gettimes(0,inf));
