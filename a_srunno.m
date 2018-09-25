function rno=a_srunno(pre)
[y,m,d,h,mi,s]=datevec(now);
rno=sprintf('%s:%4d-%2d-%2d-%2d%2d%6.3f',pre,y,m,d,h,mi,s);
rno=strrep(rno,' ','0');
rno=strrep(rno,'.','');