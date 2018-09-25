function [x ratio nset]=a_addnodes2(x,minh,maxrh)

global VERBOSE

% find biggest relative change in spacing
n=length(x);
h(1:n-1)=x(2:n)-x(1:n-1);
hhl=h(1:n-2);
hhr=h(2:n-1);
[r1 i1]=max(hhl./hhr);
[r2 i2]=max(hhr./hhl);
ratio=max([r1,r2]); % max relative spacing
    
nset=0;

while ratio > maxrh*1.001
    
    if r1 > r2 % hhl > hhr
        hl=h(i1);
        hr=h(i1+1);
        im=i1;
%         l3=[x(im),x(im+1),x(im+2)]
%         h3=[hl hr]
    else % hhr > hhl
        hl=h(i2);
        hr=h(i2+1);
        im=i2;
%         r3=[x(im),x(im+1),x(im+2)]
%         h3=[hl hr]
    end
% pause

    if hl > maxrh*hr+minh
        nset=nset+1;
        x(n+1)=x(im+1)-maxrh*hr;
    elseif hr > maxrh*hl+minh
        nset=nset+1;
        x(n+1)=x(im+1)+maxrh*hl;
    else
        if VERBOSE; fprintf('a_addnodes2.m: CAUTION - ratio > maxrh, but added node will be < minh\n\n'); end
        return
    end
        
%     % split biggest spacing in two
%     if hl > maxrh*hr && hl > 2*minh
%         nset=nset+1;
%         x(n+1)=0.5*(x(im)+x(im+1));
%     elseif hr > maxrh*hl && hr > 2*minh
%         nset=nset+1;
%         x(n+1)=0.5*(x(im+1)+x(im+2));
%     else
%         return;
%     end

    x=sort(x);
    % find biggest relative change in spacing
    n=length(x);
    h(1:n-1)=x(2:n)-x(1:n-1);
    hhl=h(1:n-2);
    hhr=h(2:n-1);
    [r1 i1]=max(hhl./hhr);
    [r2 i2]=max(hhr./hhl);
    ratio=max([r1,r2]); % max relative spacing

end