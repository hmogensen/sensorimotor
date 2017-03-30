function [neuron_distribution, statistical_distribution_avg_response, ...
  shuffled_distribution, binomial_permutations, nbr_of_positives, ...
  response_profiles] = ...
  compute_binomial_distribution(neuron, stims_str, response_min, response_max, ...
  normalize)

[neuron_distribution, binomial_permutations, nbr_of_positives, ...
  avg_response_rate, shuffled_distribution, response_profiles] = ...
  get_binomial_distribution(neuron, stims_str, response_min, response_max, ...
  normalize);

% Generate binomial distribution for null hypothesis, with response
% probability for each neuron given by average response rate
statistical_distribution_avg_response = ...
  get_stochastic_binomial_distribution(nbr_of_positives, avg_response_rate);

if ~normalize
  
  statistical_distribution_avg_response = statistical_distribution_avg_response ...
    * sum(neuron_distribution);
end

end