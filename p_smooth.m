function [x,y]=p_smooth(xx,yy,ele)

if ele == 2
    x(1)=xx(1);
    x(2:length(xx)/4+1)=xx(4:4:length(xx));
    for ii=1:size(yy,1)
        y(ii,1)=yy(ii,1);
        y(ii,2:length(xx)/4)=0.5*(yy(ii,4:4:length(xx)-4)+yy(ii,5:4:length(xx)-3));
        y(ii,length(xx)/4+1)=yy(ii,length(xx));
    end
elseif ele == 1
    x(1)=xx(1);
    x(2:length(xx)/2+1)=xx(2:2:length(xx));
    for ii=1:size(yy,1)
        y(ii,1)=yy(ii,1);
        y(ii,2:length(xx)/2)=0.5*(yy(ii,2:2:length(xx)-2)+yy(ii,3:2:length(xx)-1));
        y(ii,length(xx)/2+1)=yy(ii,length(xx));
    end
else
    error('STOP')
end