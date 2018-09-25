function [Gstruct]=make_Generation
uniform=struct('J_Gen',[]);
mono=struct('top_or_bottom','','J_Inc',[],'wl',[],'angle',[]);
sdata=struct('info','','Pinc',[],'Jinc',[],'n_photon',[],'wl',[],'flux',[]);
spec=struct('top_or_bottom','','sfile','','X',[],'angle',[],'sdata',sdata);

Gstruct=struct('type','','J_Inc',[],'uniform',uniform,'mono',mono,'spec',spec);