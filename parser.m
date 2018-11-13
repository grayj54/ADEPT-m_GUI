function [p] = parser(fin)
%
% function [p] = parser(fin)
%_______________________________________________________
% Revision History:
%
% March 13, 2009 
% September 21, 2000
% March 20, 2017
%_______________________________________________________
% Author: Jeffery L. Gray, grayj@purdue.edu
%         School of Electrical and Computer Engineering
%         Purdue University, West Lafayette, IN 47907
%_______________________________________________________
%
% Input -
%
%       fin: file id of input file containing statements
%
% Output -
%
%       p: a structure, defined below
%
% The following variables are always returned:
%
% p.diktat - is a string containing the name of the input diktat
% p.err - error messages, as follows:
%    normal return conditions:  
%         p.err=-1; p.errmess='end of file';
%         p.err=1; p.errmess='no errors detected on assignment statement';
%         p.err=2; p.errmess='no errors detected on title statement';
%    error detected:
%         p.err=999; p.errmess=strcat('cannot mix numbers and strings in: ',p.var(i).name);
%
% parser.m reads stements from the file fin which are of the form:
%
%       *titlediktat  anything at all
%
%   or
%
%       diktatname  var1=value1,var2=string2 var3=value3
%       +     array1=va1/va1/va3, array2=str1/str2/str3/str4
%       +     var4 value2
%
% Lines beginning with a blank or a $ are ignored.
%       
% Variables have 3 types: number, string, or empty
%
% Statements may be any number of lines. The diktat name
% must start in column 1. The continuation symbol, +,
% must also appear in column 1.
%
% Commas or blanks are assumed to be separaters. Any
% number of separaters may appear between assignments.
% An assignment cannot contain any blanks, i.e.
%      block = - 12.0
% is not valid. It must be written as
%      block=-12.0   instead.
%
% Multiple values can be assigned to the variable
% by separating the values by /'s (rows) and/or :'s (columns). For example
% wl=.3/.4/.5/.6/.7/.8 (6 rows, 1 column)
% Nd=1e19:1e18/1e16:1e15/1e14:1e13 (3 rows, 2 columns)
%    and
% ohmic=yes:no:no:no:yes (1 row, 5 columns)
%
%
% Examples-
%
%       |<-- file column 1
%       |
%####   newdiktat  x=3.0,rat=cat  alpha=1.0e12
%       +  wl=.3/.4/.5/inf/1e500 string=ab:cde:fghi:j purdue
%       +  N=1:2:3/7:3:2
%
%----   p.diktat: 'newdiktat'
%       p.nvar: 7
%       p.err: 1
%       p.errmess: 'no errors detected on assignment statement'
%       p.var: [1x6 struct]
%          p.var(1).name: 'x'
%          p.var(1).type: 'number'
%          p.var(1).nval: 1
%          p.var(1).val: 3
%          p.var(2).name: 'rat'
%          p.var(2).type: 'string'
%          p.var(2).nval: 1
%          p.var(2).val: {'cat'}
%          p.var(3).name: 'alpha'
%          p.var(3).type: 'number'
%          p.var(3).nval: 1
%          p.var(3).val: 1.0000e+012
%          p.var(4).name: 'wl'
%          p.var(4).type: 'number'
%          p.var(4).nval: [5 1]
%          p.var(4).val: [0.3000;0.4000;0.5000;inf;inf]
%          p.var(5).name: 'string'
%          p.var(5).type: 'string'
%          p.var(5).nval: [1 4]
%          p.var(5).val: {'ab','cdcd','fgh','z'}
%          p.var(6).name: 'purdue'
%          p.var(6).type: 'empty'
%          p.var(6).nval: 0
%          p.var(6).val: []
%          p.var(7).name: N
%          p.var(7).type: number
%          p.var(7).nval: [2 3]
%          p.var(7).val: [1,2,3;7,3,2]
%
%####   *mess  hello world!
%
%----   p.diktat: '*mess'
%       p.err: 2
%       p.errmess: 'no errors detected on title statement'
%       p.title: 'hello world!  '
%
%####   test2 f=false r=3/yes
%
%----   p.diktat: 'test2'
%       p.err: 999
%       p.errmess: 'cannot mix numbers and strings in: r'
%       p.nvar: 2
%       p.var: [1x2 struct]
%          p.var(1).name: 'f'
%          p.var(1).type: 'string'
%          p.var(1).nval: 1
%          p.var(1).val: {'false'}
%          p.var(2).name: 'r'
%          p.var(2).type: 'number'
%          p.var(2).nval: 2
%          p.var(2).val: 3

% Read first line of statement definition - ignore comment lines

line(1)=' ';

while (strcmp(line(1),' ') == 1)
   
   if(feof(fin)==1)
      p.diktat='End-of-File';
      p.err=-1;
      p.errmess='end of file';
      return;
   end
   
   line = fgetl(fin);

   if isempty(line) == 1 || strcmp(line(1),'$') == 1 ||...
                            strcmp(line(1),'%') == 1 || strcmp(line(1),' ') == 1
      line(1)=' ';
   end
   
end

statement = line;
p.statement(1)={statement};
p.nl=1;

% Read remaining lines of definition statement if continued
     
while 1 == 1
   
   line = fgetl(fin);

   if line == -1
       break;
   elseif isempty(line) == 1
       break;
   elseif strcmp(line(1),'+')
      p.nl=p.nl+1;
      p.statement(p.nl)={line};
      line(1)=' ';
      statement=strcat(statement,line);
   else
      offset=length(line)+2; % +2 accounts for end-of-line terminator
      fseek(fin,-offset,'cof');
      break
   end
   
end

% decode the statement

% check for title statement

if statement(1) == '*'
   [p.diktat rem]=strtok(statement);
   p.title=strjust(rem,'left');
   p.err=2;
   p.errmess='no errors detected on title statement';
   return;
else
    % replace all occurances of ',' with a space, ' '
    statement = strrep(statement,',',' ');
end

% get statement name

[p.diktat rem]=strtok(statement);
rem=deblank(rem);

if length(rem) == 0 % blank diktat
    p.nvar=0;
    p.err=1;
    p.errmess='no assignments on diktat';
    return
end    

% extract tokens

i=0;

while i>=0
   
   [token rem]=strtok(rem);
   n=size(token,2);
   if(n==0)   
      break;
   end
   
   i=i+1;
   if i==1
      dlist=token;
   else
      dlist=char(dlist,token);
   end
   
end

% interpret list of tokens

n=size(dlist,1);
p.nvar=n;

for i=1:n
   
   [vname rem]=strtok(dlist(i,:),'=');
   rem(1,1)=' ';
   rem=strjust(rem,'left');
   rem=deblank(rem);
   p.var(i).name=deblank(vname);
   p.var(i).type='      ';
   if isempty(rem)==0 
      % test for array of values
      rdelims=strfind(rem,'/');
      nde=length(rdelims);
      nr=nde+1;
      p.var(i).nval=[nr,1];
      for j=1:nr
         f_str=0;
         f_num=0;
         [rem remrem]=strtok(rem,'/');
         rem=strjust(rem,'left');
         rem=deblank(rem);
         % count columns
         cdelims=strfind(rem,':');
         nde=length(cdelims);
         nc(j)=nde+1;
         for k=1:nc(j)
           [value rem]=strtok(rem,':');
           number=str2num(value);
           if isnumeric(number)==1 && isempty(number)==0
               f_num=1;
           else
               f_str=1;
           end
           if f_str*f_num == 1
               p.err=999;
               p.errmess=strcat('cannot mix numbers and strings in: ',p.var(i).name);
               return;
           end 
           if f_str
               p.var(i).type='string';
               p.var(i).val{j,k}=value;
           elseif f_num
               p.var(i).type='number';
               p.var(i).val(j,k)=number;
           end
         end
         if nr > 1
           if nc(1) > 1
             if nc(j) ~= nc(1)
               p.err=999;
               p.errmess=strcat('number of columns in each row must be the same for: ',p.var(i).name);
             end
           end
         end
         rem=remrem;
      end
      p.var(i).nval=[nr,nc(1)];
   else
      p.var(i).nval=[0,0];
      p.var(i).type='empty';
   end
   
end

p.err=1;
p.errmess='no errors detected on assignment statement';

return;