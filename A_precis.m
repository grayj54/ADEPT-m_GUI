function A_precis(inputs)
% 
%   struct with fields:
% 
%             nD: '1D'
%     input_file: 'si_example.1d'
%           type: 'gui_input'
%          title: 'simple silicon solar cell'
%         device: [1×1 struct]
%            top: [1×1 struct]
%          layer: [1×1 struct]
%         bottom: [1×1 struct]
%           mesh: [1×1 struct]
%           misc: [1×1 struct]

fid=1;

fprintf(fid,'title: %s\n',inputs.title);
fprintf(fid,'Input file: %s\n\n',inputs.input_file);

fprintf(fid,'device:\n\n');
a_print_ip(inputs.device.ip,fid)


end

function a_print_ip(ip,fid)

for i=1:length(ip)
    if strcmp(ip(i).type,'number')
        if length(ip(i).aliases) == 1
            k=1;
        else
            for kk=1:length(ip(i).aliases)
                if strcmp(ip(i).name,ip(i).aliases(kk))
                    k=kk;
                    break;
                end
            end
        end
        fprintf(fid,'    %s = ',ip(i).full_name);
        fprintf(fid,'%g %s\n',ip(i).set,char(ip(i).units(k)));
    else
        fprintf(fid,'    %s = ''',ip(i).full_name);
        fprintf(fid,'%s''\n',char(ip(i).set));
    end
end
end




