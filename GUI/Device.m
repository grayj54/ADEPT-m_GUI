classdef Device < handle
    properties
        type = 'Solar Cell'
        tempUnit = 'K'
        temp = '279'
        desc = ''
    end
    
    methods
        function set.type(obj, val)
            obj.type = val;
        end
        
        function set.tempUnit(obj, val)
            obj.tempUnit = val;
        end
        
        function set.temp(obj, val)
            obj.temp = val;
        end
        
        function set.desc(obj, val)
            obj.desc = val;
        end
        
        function value = get.type(obj)
            value = obj.type;
        end
        
        function value = get.tempUnit(obj)
            value = obj.tempUnit;
        end
        
        function value = get.temp(obj)
            value = obj.temp;
        end
        
        function value = get.desc(obj)
            value = obj.desc;
        end
    end
end