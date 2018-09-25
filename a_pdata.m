function [xx,yy]=a_pdata(x,y,flag)
% assumes y is piece-wise const between x values
% length(y)=length(x)-1;

nx=length(x);
ny=size(y,2);
if ny ~= nx-1
  error('a_pdata: length(y) must equal length(x)-1')
end

nn=2*nx-2;

if flag == 1
  xx=zeros(1,nn);
  xx(1)=x(1);
  xx(2:2:nn-2)=x(2:nx-1);
  xx(3:2:nn-1)=x(2:nx-1);
  xx(nn)=x(nx);
else
    xx=0;
end
yy=zeros(size(y,1),nn);
yy(:,1)=y(:,1);
yy(:,2:2:nn-2)=y(:,1:ny-1);
yy(:,3:2:nn-1)=y(:,2:ny);
yy(:,nn)=y(:,ny);