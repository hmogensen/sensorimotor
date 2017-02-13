function [neuron_distribution, statistical_distribution_avg_response, ...
  statistical_distribution_lsqfit, shuffled_distribution, ...
  binomial_permutations, nbr_of_positives] = ...
  compute_binomial_distribution(neuron, stims_str, pattern_str, ...
  response_min, response_max)

stims_str = get_items(stims_str, @get_pattern, pattern_str);

[neuron_distribution, binomial_permutations, nbr_of_positives, ...
  avg_response_rate, shuffled_distribution] = ...
  get_binomial_distribution(neuron, stims_str, response_min, response_max);

% Generate binomial distribution for null hypothesis, with response
% probability for each neuron given by least squares fit with recorded data

lsq_fcn = @(x) sum(abs(get_stochastic_binomial_distribution(nbr_of_positives, x) - neuron_distribution));
optimal_response_rate = lsqnonlin(lsq_fcn, avg_response_rate, 0, 1);
statistical_distribution_lsqfit = ...
  get_stochastic_binomial_distribution(nbr_of_positives, optimal_response_rate);

% Generate binomial distribution for null hypothesis, with response
% probability for each neuron given by average response rate

statistical_distribution_avg_response = ...
  get_stochastic_binomial_distribution(nbr_of_positives, avg_response_rate);

end