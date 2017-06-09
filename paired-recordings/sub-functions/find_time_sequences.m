function sequences = find_time_sequences(t1, t2, max_inactivity_time, ...
  min_nbr_of_spikes_per_sequence, min_time_span)

sequence_1 = get_sequence(t1, max_inactivity_time);
sequence_2 = get_sequence(t2, max_inactivity_time);

sequences = nan(max([size(sequence_1,1) size(sequence_2,1)]), 2);
count = 0;

tmax = -inf;

while true
  
  tmin_sequence_1 = min(sequence_1(sequence_1(:,1)>tmax, 1));
  tmin_sequence_2 = min(sequence_2(sequence_2(:,1)>tmax, 1));
  
  if isempty(tmin_sequence_1) || isempty(tmin_sequence_2)
    break;
  end
  
  tmax_sequence_1 = min(sequence_1(sequence_1(:,2)>tmax, 2));
  tmax_sequence_2 = min(sequence_2(sequence_2(:,2)>tmax, 2));
  
  if isempty(tmax_sequence_1) || isempty(tmax_sequence_2)
    break;
  end
  
  tmin = max([tmin_sequence_1 tmin_sequence_2]);
  tmax = min([tmax_sequence_1 tmax_sequence_2]);
  
  if tmax - tmin >= min_time_span && ...
      nnz(t1 > tmin & t1 < tmax) >= min_nbr_of_spikes_per_sequence && ...
      nnz(t2 > tmin & t2 < tmax) >= min_nbr_of_spikes_per_sequence
    
    count = count + 1;
    sequences(count, :) = [tmin tmax];
    
  end
  
end

sequences = sequences(1:count, :);

end


