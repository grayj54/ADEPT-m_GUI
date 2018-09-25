function [mob]=a_ctmob(N,umin,umax,Nref,b)

mob=umin+(umax-umin)./(1+(N./Nref).^b);
