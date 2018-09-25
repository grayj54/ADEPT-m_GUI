function [x nset]=a_addnodes1(x,maxh)

n=length(x);
nset=0;
h(1:n-1)=x(2:n)-x(1:n-1);
[hm,ihm]=max(h); % max spacing is between x(ihm) and x(ihm+1)

% add nodes until biggest h is <= maxh
while hm > maxh
    nset=nset+1;
    x(n+1)=0.5*(x(ihm)+x(ihm+1));
    x=sort(x);
    n=length(x);
    h(1:n-1)=x(2:n)-x(1:n-1);
    [hm,ihm]=max(h); % max spacing between x(ihm) and x(ihm+1)
end