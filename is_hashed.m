function [name,index]=is_hashed(pname)

[token,rem]=strtok(pname,'#');
if length(rem) == 0 % no '#', so assume 'index=1'
    name=pname;
    index=1;
elseif length(rem) == 1 % no number follows '#'
    name=pname;
    index=-1;
else
    name=token;
    index=str2num(rem(2:length(rem)));
    if isempty(index)
        index=-1;
    end
end