function x=A_info(dev)
% returns useful information about the Adept object 'dev' (not all
% parameters listed below are returned - depends on operating conditions)
%     x.run_id: unique identifier for 'dev'
%     x.eq_id: unique identifier for the equilibrium Adept object used to
%              create 'dev'
%     x.diktat_file: diktat file name
%     x.diktats: diktats (is empty if GUI used)
%     x.description device description
%     x.T_K: device operating temperature in Kelvin
%     x.T_C: device operation temperature in Celsius
%     x.device_type: type of device
%     x.mode: mode of operation
%     x.V: operating voltage (V)
%     x.J: operating current (A/cm^2)
%     x.illumination: illumination operating condition
%     x.n_light_sources: number of light sources
%     x.J_Gen: total light generated current density (A/cm^2)
%     x.spectrum_file{i}: spectrum file name;
%     x.spectrum_P_inc(i): incident power in spectrum at 1X (W/cm^2)
%     x.spectrum_X(i): light concentration factor
%     x.spectrum_torb{i}: incident direction of light
%     x.spectrum_angle(i): incident angle of light

x.run_id=dev.runno;
x.eq_id=dev.eqrunno;
x.diktat_file=dev.input_file;
x.diktats=dev.diktats;
x.description=dev.description;
x.T_K=dev.OpCond.T_K;
x.T_C=dev.OpCond.T_C;
x.device_type=dev.type;
x.mode=dev.OpCond.mode;
switch x.mode
    case 'equilibrium'
        x.V=0;
        x.J=0;
        x.illumination='dark';
    case 'steady-state'
        x.V=dev.OpCond.Va;
        x.J=dev.OpCond.Jt;
        x.n_light_sources=length(dev.OpCond.Generation);
        x.J_Gen=dev.OpCond.Jgen;
        for i=1:x.n_light_sources
            temp=dev.OpCond.Generation(i);
            x.light_source{i}=temp.type;
            switch temp.type
                case 'spectrum'
                    x.spectrum_file{i}=temp.spec.sfile;
                    x.spectrum_P_inc(i)=temp.spec.sdata.Pinc;
                    x.spectrum_X(i)=temp.spec.X;
                    x.spectrum_torb{i}=temp.spec.top_or_bottom;
                    x.spectrum_angle(i)=temp.spec.angle;
            end
        end
    case {'transient' 'transient2'}
        
    case 'small-signal'
        
end

