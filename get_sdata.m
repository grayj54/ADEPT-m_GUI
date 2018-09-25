function [sdata]=get_sdata(spectrum_file)
%
global APATH CONST VERBOSE

if VERBOSE; fprintf('--- reading spectrum data.\n'); end
% see if spectrum file is in current working directory
[Fid,message]=fopen(spectrum_file,'rt');
if Fid < 0
    spath=fullfile(APATH,'BIN','SPECTRUMS');
    [Fid,message]=fopen(fullfile(spath,spectrum_file),'rt');
    if Fid < 0
        error('get_sdata.m: %s.',message)
    else
        if VERBOSE; fprintf('Spectrum file ''%s'' found in %s\n',spectrum_file,spath); end
    end
else
    if VERBOSE; fprintf('Spectrum file ''%s'' found in current folder\n',spectrum_file); end
end

sdata.file_name=spectrum_file;
sdata.info=fgetl(Fid);
nnn=fscanf(Fid,'%d',1);
pairs=fscanf(Fid,'%g %g',[2,nnn]);
fclose(Fid);

sdata.wl(1:nnn)=pairs(1:2:2*nnn-1);
irrad=pairs(2:2:2*nnn);

% convert irrad from W/m^2/um to #/cm^2/um
Ewl=CONST.hp/CONST.q*CONST.c*1e6./sdata.wl;
sdata.Pinc=trapz(sdata.wl,irrad/1e4);
sdata.flux=irrad./Ewl/CONST.q/1e4;
sdata.n_photon=trapz(sdata.wl,sdata.flux);
sdata.Jinc=CONST.q*sdata.n_photon;
sdata.irrad=irrad;