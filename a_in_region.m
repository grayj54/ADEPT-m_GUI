function reg=a_in_region(dev,x,y,z)

for r=1:length(dev.reg)
    
    switch nargin
        case 2 %1D
        if x >= dev.reg(r).min && x <= dev.reg(r).max
            reg=r;
            return
        end
        
        otherwise
            error('in_region: incorrect number of arguments')
            return
    end
    
end
