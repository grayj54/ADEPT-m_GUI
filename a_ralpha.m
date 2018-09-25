function [alpha_data]=a_ralpha(alpha_file)
%
global APATH CONST VERBOSE

% see if alpha file is in current working directory
[Fid,message]=fopen(alpha_file,'rt');
if Fid < 0
    alfpath=fullfile(APATH,'BIN','ALPHA');
    [Fid,message]=fopen(fullfile(alfpath,alpha_file),'rt');
    if Fid < 0
        error('a_ralpha.m: %s.',message)
    else
        if VERBOSE; fprintf('Absorption coefficient file ''%s'' found in %s\n',alpha_file,alfpath); end
    end
else
    if VERBOSE; fprintf('Absorption coefficient file ''%s'' found in current folder\n',alpha_file); end
end
alpha_data.file_name=alpha_file;
alpha_data.info=fgetl(Fid);
nnn=fscanf(Fid,'%d',1);
pairs=fscanf(Fid,'%g %g',[2,nnn]);
fclose(Fid);

alpha_data.wl(1:nnn)=pairs(1:2:2*nnn-1);
alpha_data.alpha(1:nnn)=pairs(2:2:2*nnn);