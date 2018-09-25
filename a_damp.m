function [ddv]=a_damp(dv)
% nn=length(dv);
% ddv=dv;
% for i=1:nn
%     adv=abs(dv(i));
%     if adv < 1
%     elseif adv < 3.654120770859726
%         s=sign(dv(i));
%         ddv(i)=s*(adv^0.2);
%     else
%         s=sign(dv(i));
%         ddv(i)=s*log(adv);
%     end
% end

% does the same thing, but slower
% s=sign(dv);
% x=min(abs(dv),1e5);
% ddv=s.*min(x,max(log(x),x.^0.2));

ddv=dv;
m0=find(abs(dv)>1);
m=find(abs(dv(m0))<=3.65412077);
s=sign(dv(m0(m)));
ddv(m0(m))=s.*(abs(dv(m0(m)).^.2));
m=abs(dv)>3.654120770859726;
s=sign(dv(m));
ddv(m)=s.*log(abs(dv(m)));