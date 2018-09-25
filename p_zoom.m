function [a,b]=p_zoom(x,range)

for ii=1:length(x)
  if x(ii) >= range(1)
    a=ii;
    break;
  end
end

for ii=length(x):-1:a
  if x(ii) <= range(2)
    b=ii;
    break;
  end
end