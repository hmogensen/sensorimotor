function prev_neuron(obj)

if obj.neuron_pair_indx == 2
  
  obj.neuron_pair_indx = 1;

else
  
  obj.neuron_pair_indx = 2;
  ind_neuron           = find(obj.neuron == obj.neurons);
  obj.neuron           = obj.neurons(ind_neuron - 1);

end

plot_neuron(obj);

end