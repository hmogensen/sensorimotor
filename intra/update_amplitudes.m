function signal = update_amplitudes(neuron, response_min, response_max, force_update)

stims = get_intra_motifs();

s.smooth = true;
s.remove_artifacts = true;
s.remove_waveforms = true;
s.remove_artifacts_simple = true;

signal = sc_load_signal(neuron);

v = signal.get_v(s);

for i=1:length(stims)
  fprintf('%g\n', i/length(stims));
  amplitude = signal.amplitudes.get('tag', stims{i});
  
  if force_update || ~amplitude.is_updated
    amplitude.update(v, signal.dt, neuron.psp_templates, response_min, response_max);
  end
end

signal.update_spont_activity(neuron.psp_templates, get_intra_patterns(), response_min, response_max);

end