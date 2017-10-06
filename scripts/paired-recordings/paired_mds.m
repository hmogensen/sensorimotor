function paired_mds(paired_neurons)

nbr_of_params  = 12;
nbr_of_neurons = 2*length(paired_neurons);

values            = nan(nbr_of_params, nbr_of_neurons);
legend_str        = cell(nbr_of_neurons, 1);
right_click_fcns  = {};

for i_paired_neuron=1:length(paired_neurons)
  
  tmp_paired_neuron = paired_neurons(i_paired_neuron);
  
  for i_neuron=1:2
    
    col_indx             = i_paired_neuron * 2 + i_neuron - 2;
    legend_str(col_indx) = {tmp_paired_neuron.file_tag};
    
    counter = 0;
    
    [~, height, leading_flank_width, ~, trailing_flank_width, ~, peak_position] ...
      = tmp_paired_neuron.compute_all_distances('indx_prespike_response', i_neuron);
    
    tmp_values = [height; leading_flank_width; trailing_flank_width; peak_position];
    values(counter + (1:length(tmp_values)), col_indx) = tmp_values;
    counter = counter + length(tmp_values);
    
    [~, height, leading_flank_width, ~, trailing_flank_width, ~, peak_position] ...
      = tmp_paired_neuron.compute_all_distances('indx_perispike_response', i_neuron);
    
    tmp_values = [height; leading_flank_width; trailing_flank_width; peak_position];
    values(counter + (1:length(tmp_values)), col_indx) = tmp_values;
    counter = counter + length(tmp_values);
    
    [~, height, leading_flank_width, ~, trailing_flank_width, ~, peak_position] ...
      = tmp_paired_neuron.compute_all_distances('indx_postspike_response', i_neuron);
    
    tmp_values = [height; leading_flank_width; trailing_flank_width; peak_position];
    values(counter + (1:length(tmp_values)), col_indx) = tmp_values;
    counter = counter + length(tmp_values);
    
    if counter ~= size(values, 1)
      error('Wrong dimension of values matrix');
    end
    
    right_click_fcns = add_to_list(right_click_fcns, ...
      @(varargin) right_click_fcn(tmp_paired_neuron, i_neuron));
    
  end

end

mean_values = mean(values, 2);
values      = values ./ repmat(mean_values, 1, nbr_of_neurons);

d = pdist(values');
y = cmdscale(d, 2);

clf
plot_mda(y, legend_str, '.', right_click_fcns);

add_legend

end


function right_click_fcn(paired_neuron, neuron_indx)

figure
nbrws                  = NeuronBrowserClickRecorder(paired_neuron);
nbrws.neuron_pair_indx = neuron_indx;
nbrws.plot_neuron();

end