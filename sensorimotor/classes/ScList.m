classdef ScList < handle
    %List structture with extra features. Can only contain a single type of
    %objects. For a list of arbitray objects, see ScCellList
    properties (SetObservable)
        list
    end
    
    properties (Dependent)
        n
    end
    
    methods
        
        function add(obj, item)
            if ~obj.n
                obj.list = item;
            else
                obj.list(obj.n+1) = item;
            end
        end
        
        function remove(obj, item, value)
            if nargin==2
                index = obj.indexof(item);
                if index==-1
                    index = item;
                end
                obj.list(index) = [];
            else
                prop = item;
                index = obj.indexof(prop,value);
                obj.remove(index);
            end 
        end
        
        %if nargin == 2
        %   index   index in list
        %if nargin == 3
        %   index   property name (string)
        %   val     desired value of property
        function listobject = get(obj,index, val)
            if nargin==2
                listobject = obj.list(index);
            else
                property = index;
                index = cellfun(@(x) compare_fcn(x, val), {obj.list.(property)});
                listobject = obj.list(index);
            end
        end
        
        function object_exists = has(obj,property,val)
            if ~obj.n
                object_exists = false;
            else
                object_exists = ~isempty(obj.get(property,val));
            end
        end
        
        function exists = contains(obj, item)
            exists = 0;
            for k=1:obj.n
                if obj.get(k)==item
                    exists = true;
                    return
                end
            end
        end
        
        %get all values of a specific property, as a cell array
        function vals = values(obj, property)
            if isempty(obj.list)
                vals = {};
            else
                vals = {obj.list.(property)};
            end
        end
        
        function index = indexof(obj,item,value)
            index = -1;   
            if nargin==2
                for k=1:obj.n
                    if obj.get(k)==item
                        index = k;
                        return
                    end
                end
            else
                prop = item;
                for k=1:obj.n
                    if compare_fcn(value,obj.get(k).(prop))
                        index = k;
                        return
                    end
                end
            end
        end
        
        function n = get.n(obj)
            n = numel(obj.list);
        end
    end
end

function same = compare_fcn(value1, value2)
if isnumeric(value1)
    same = value1 == value2;
elseif ischar(value1)
    same = strcmp(value1,value2);
end
end