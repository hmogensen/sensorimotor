classdef ScExperiment < ScList
%Children: ScFile    
    properties
        fdir        %directory containing .mat / .adq files
        save_name   %for saving this class, ends with _sc.mat
    end
    
    methods
        function obj = ScExperiment(varargin)
            for i=1:2:numel(varargin)
                obj.(varargin{i}) = varargin{i+1};
            end
        end
                
        %Save current object
        %   showdialog  if true, user can update obj.save_name
        function saved = sc_save(obj, showdialog)
            saved = false;
            if nargin<2 || showdialog || isempty(obj.save_name)
                [fname, pname] = uiputfile('*_sc.mat','Choose file to save',...
                    obj.save_name);
                if ~isnumeric(fname)
                    file = fullfile(pname,fname);
                    obj.save_name = fname;
                    save(file,'obj');
                    saved = true;
                end
            else
                save(fullfile(obj.fdir,obj.save_name),'obj');
                saved = true;
            end
        end
        
        %clear all transient data
        function sc_clear(obj)
            for i=1:obj.n
                obj.get(i).sc_clear();
            end
        end
        
        %Populate all children
        function init(obj)
            for i=1:obj.n
                fprintf('reading file: %i out of %i\n',i,obj.n);
                obj.get(i).init();
            end
        end
        
        %Parse experimental protocol (*.txt)
         function update_from_protocol(obj, protocolfile)
             for i=1:obj.n
                 fprintf('parsing file %i out of %i\n',i,obj.n);
                 obj.get(i).update_from_protocol(protocolfile);
             end
         end
    end
end