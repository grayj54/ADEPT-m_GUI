function [filename]=A_summary(dev,filename)
% A_summary generates a concise summary of an ADEPT-m device (dev)
% précis is pronounced "prey-SEE"
% default filename is derived from dev.input_file
a_init;
global CONST
if nargin == 1
    froot=dev.input_file(1:length(dev.input_file)-3);
    filename=strcat(froot,'.html');
end

fid=fopen(filename,'wt');
fprintf(fid,'<HTML>');
fprintf(fid,'<HEAD>');
fprintf(fid,'<TITLE>ADEPT-m: %s</TITLE>',filename);
fprintf(fid,'<BODY>');

fprintf(fid,'<H2 align=center>ADEPT-m Device Summary</H2>');
fprintf(fid,'<BLOCKQUOTE>');
if strcmp(dev.description,'') == 0
    fprintf(fid,'<B>Device description:</B>');
    fprintf(fid,'<BLOCKQUOTE>');
    fprintf(fid,'<P>%s',dev.description);
    fprintf(fid,'</BLOCKQUOTE>');
end
fprintf(fid,'<B>Device type:</B> %s @ ',dev.type);
fprintf(fid,'T = %g K  (%g &deg C)',dev.T,dev.T+CONST.abs_zero);
fprintf(fid,'<P><B>Diktat file name:</B> <tt>%s</TT>',dev.input_file);
fprintf(fid,'<BLOCKQUOTE>');
fprintf(fid,'<P>');
for ii=1:length(dev.diktats)
    fprintf(fid,'<TT>%s</TT><BR>',string(dev.diktats{ii}));
end
fprintf(fid,'</BLOCKQUOTE>');
fprintf(fid,'<H4>Physical Constants:</H4>');
fprintf(fid,'<UL>');
fprintf(fid,'<LI>q = %.10e C',CONST.q);
fprintf(fid,'<LI>kb = %.7e eV/K',CONST.kb);
fprintf(fid,'<LI>e0 = %.9e F/cm',CONST.e0);
fprintf(fid,'<LI>hp = %.9e J-s',CONST.hp);
fprintf(fid,'<LI>c = %.8e m/s',CONST.c);
fprintf(fid,'</UL>');
fprintf(fid,'</BLOCKQUOTE>');

for ii=1:length(dev.reg)
    
    fprintf(fid,'<H3>Region %d: %s</H3>',ii,dev.reg(ii).mat);
    matno=dev.reg(ii).matno;
    fprintf(fid,'<BLOCKQUOTE>');
    if strcmp(dev.description,'') == 0
        fprintf(fid,'<B>%s</B>',dev.reg(matno).describe);
    end
    switch string(dev.reg(ii).mat)
        case 'semiconductor'
            fprintf(fid,'<H4>Model: %s</H4>',string(dev.semi(matno).model));
            fprintf(fid,'');
        otherwise
            fprintf(fid,'THIS SHOULD NOT HAPPEN');
    end
    fprintf(fid,'</BLOCKQUOTE>');
    
end

fprintf(fid,'</BODY>');
fprintf(fid,'</HTML>');
fclose(fid);

    

