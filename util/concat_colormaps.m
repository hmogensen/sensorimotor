function concat_colormaps(plothandle, limits, varargin)

nbr_of_regions = length(limits) + 1;
cmaps = varargin;

if length(cmaps) ~= nbr_of_regions
  error('Mismatch between size of limits array and number of colormaps');
end

z = get(plothandle, 'ZData');

zmin = min(z(:));
zmax = max(z(:));

zrange = zmax - zmin;
n_colormap = 1024;
cmapvalues = [];

for i=1:nbr_of_regions
  
  if i==1
    cmin = min(z(:));
  else
    cmin = cmax;
  end
  
  if i==nbr_of_regions
    cmax = max(z(:));
  else
    cmax = limits(i);
  end
  
  n_cmap = round((cmax-cmin)/zrange*n_colormap);
  cmap = cmaps{i};
  cmapvalues = [cmapvalues; cmap(n_cmap)];
end

parent_axes = get(plothandle, 'parent');
colormap(parent_axes, cmapvalues);
colorbar(parent_axes);

end