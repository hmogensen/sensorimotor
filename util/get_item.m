function val = get_item(list, indx)

if isempty(indx)
  val = [];
elseif isobject(indx)
  val = indx;
elseif ischar(indx)
  val = get_items(list, 'tag', indx, 1);
elseif isnumeric(indx)
  if iscell(list)
    val = list{indx};
  else
    val = list(indx);
  end
else
  error('Function not implemented for input of type %s', class(indx));
end

if iscell(val) && length(val)==1
  val = val{1};
end

end