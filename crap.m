classdef crap < handle
    
    properties
        a
        b
        c
    end
        
    methods
        function obj=crap(x)
            if isa(x,'struct')
                obj.a=x.a;
                obj.b=x.b;
                obj.c=x.c;
            else
                obj.a.x=x;
                obj.b.A.x=x;
                obj.c.X.Y.x=x;
            end
        end
        function y=copy(x)
            y.a=x.a;
            y.b=x.b;
            y.c=x.c;
            y=crap(y);
        end
    end
    
end
        