function dev=a_update_eq(dev,dv)

if strcmp(dev.nD,'1D') == 1

    dv=a_damp(dv)';
    
    dev.node.v=dev.node.v+dv;
    
    % set p and n to be consistent with updated v
    dev=set_pn_newt(dev);

else
    error('only 1D supported.')
end