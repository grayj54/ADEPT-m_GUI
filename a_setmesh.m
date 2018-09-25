function dev=a_setmesh(dev)
global A_FID VERBOSE

% there is always a node at the interface between 2 regions
% there is always a node +/- xres from each interface unless sharp=0

nreg=length(dev.reg);

sharp=dev.mesh.sharp;
if strcmp(sharp,'on') == 1
    xres=dev.mesh.h_min;
else
    xres=-1;
end
minh=dev.mesh.h_min;
maxh=dev.mesh.h_max;
if maxh < 0
    maxh=dev.reg(nreg).max/1000;
end
if maxh < minh; error('maxh < minh'); end
    
maxrh=dev.mesh.maxrh;
maxrD=dev.mesh.maxrD;
maxnodes=dev.mesh.max_nodes;

% set fixed nodes at interfaces
if xres > 0
    if VERBOSE; fprintf(A_FID,'\n--- Adding nodes to resolve interfaces\n\n'); end
    nn=4+3*(nreg-1);
    x(1:nn)=0;
    for r=1:nreg
        x(2+3*(r-1):1+3*r)=[dev.reg(r).min+xres dev.reg(r).max-xres dev.reg(r).max];
    end
else
    nn=nreg+1;
    x(1:nn)=0;
    for r=1:nreg
        x(r+1)=dev.reg(r).max;
    end
end

% add user defined nodes

% add nodes so that max node spacing is < maxh
if VERBOSE; fprintf(A_FID,'\n--- Adding nodes so that maximum mesh spacing is less than ''h_max''\n\n'); end
[x nadded]=a_addnodes1(x,maxh);
if VERBOSE; fprintf(A_FID,'    %d node(s) added...\n\n',nadded); end

% add nodes so that ratio of adjacent h's is < maxrh
if VERBOSE; fprintf(A_FID,'\n--- Adding nodes so that mesh length ratio is less than ''h_ratio''\n\n'); end
[x ratio nadded]=a_addnodes2(x,minh,maxrh);
if VERBOSE; fprintf(A_FID,'    %d node(s) added, max ratio = %.2g ...\n\n',nadded, ratio); end

% solve for equilibrium on this initial mesh
if VERBOSE; fprintf(A_FID,'\n--- Generate initial guess for a_doeq\n\n'); end
nn=length(x);
hh(1:nn-1)=x(2:nn)-x(1:nn-1);
dev.node.pos=x;
for i=2:nn
    e=i-1;
    dev.ele.h(e)=(x(i)-x(i-1))/dev.norm.x;
    dev.ele.reg(e)=a_in_region(dev,0.5*(x(i-1)+x(i)));
end
dev.mesh.num_nod=nn;
dev.mesh.num_ele=nn-1;
%dev=setv_neutral1(dev);
dev=a_doeq(dev,1);
dev=set_pn_newt(dev);
[dev error_code]=a_doeq(dev);
if error_code == 0
    error('A_setmesh(1): simulation terminated');
end

% add nodes so that dv <= kT between nodes
if VERBOSE; fprintf(A_FID,'\n--- Adding nodes so that dv <= kT between nodes\n\n'); end
[newx,nadded]=a_addnodes4(x,dev.node.v,minh,.01);
if VERBOSE; fprintf(A_FID,'    %d node(s) added...\n\n',nadded); end
if nadded > 0 
    xold=x;
    v=interp1(xold,dev.node.v,newx,'linear');
    x=newx;
    nn=length(x);
    hh(1:nn-1)=x(2:nn)-x(1:nn-1);
    dev.node.pos=x;
    dev.node.v=v;
    for i=2:nn
        e=i-1;
        dev.ele.h(e)=(x(i)-x(i-1))/dev.norm.x;
        dev.ele.reg(e)=a_in_region(dev,0.5*(x(i-1)+x(i)));
    end
    no=length(xold);
    nl=interp1(xold(1:no-1),dev.ele.nl(1:no-1),newx(1:nn-1));
    pl=interp1(xold(1:no-1),dev.ele.pl(1:no-1),newx(1:nn-1));
    nr=interp1(xold(1:no-1),dev.ele.nr(1:no-1),newx(1:nn-1));
    pr=interp1(xold(1:no-1),dev.ele.pr(1:no-1),newx(1:nn-1));
    dev.mesh.num_nod=nn;
    dev.mesh.num_ele=nn-1;
    dev.ele.nl(1:dev.mesh.num_ele)=nl;
    dev.ele.pl(1:dev.mesh.num_ele)=pl;
    dev.ele.nr(1:dev.mesh.num_ele)=nr;
    dev.ele.pr(1:dev.mesh.num_ele)=pr;
    dev=set_pn_newt(dev);
    [dev,error_code]=a_doeq(dev);
    if error_code == 0
        error('A_setmesh(2): simulation terminated');
    end
end

nnlast=0;
while dev.mesh.num_nod < maxnodes && nn ~= nnlast
    nnlast=nn;
    % add nodes so that ratio of adjacent D fields is < maxrD
    nadded=inf;
    while nadded > 0
        D=get_D(dev);
        if VERBOSE; fprintf(A_FID,'\n--- Adding nodes so that Dfield ratio is less than ''D_ratio''\n\n'); end
        [newx,maxDrat,nadded]=a_addnodes3(x,D,minh,maxrD,dev.mesh.Dth);
        if VERBOSE; fprintf(A_FID,'    %d node(s) added, max D ratio = %.2g ...\n\n',nadded,maxDrat); end
        % re-solve for equilibrium on this mesh
        if nadded > 0 
            xold=x;
            v=interp1(xold,dev.node.v,newx,'linear');
            x=newx;
            nn=length(x);
            hh(1:nn-1)=x(2:nn)-x(1:nn-1);
            dev.node.pos=x;
            dev.node.v=v;
            for i=2:nn
                e=i-1;
                dev.ele.h(e)=(x(i)-x(i-1))/dev.norm.x;
                dev.ele.reg(e)=a_in_region(dev,0.5*(x(i-1)+x(i)));
            end
            no=length(xold);
            nl=interp1(xold(1:no-1),dev.ele.nl(1:no-1),newx(1:nn-1));
            pl=interp1(xold(1:no-1),dev.ele.pl(1:no-1),newx(1:nn-1));
            nr=interp1(xold(1:no-1),dev.ele.nr(1:no-1),newx(1:nn-1));
            pr=interp1(xold(1:no-1),dev.ele.pr(1:no-1),newx(1:nn-1));
            dev.mesh.num_nod=nn;
            dev.mesh.num_ele=nn-1;
            dev.ele.nl(1:dev.mesh.num_ele)=nl;
            dev.ele.pl(1:dev.mesh.num_ele)=pl;
            dev.ele.nr(1:dev.mesh.num_ele)=nr;
            dev.ele.pr(1:dev.mesh.num_ele)=pr;
            dev=set_pn_newt(dev);
            [dev,error_code]=a_doeq(dev);
            if error_code == 0
                error('A_setmesh(2): simulation terminated');
            end
        end
    end

    % add nodes so that ratio of adjacent h's is < maxrh
    if VERBOSE; fprintf(A_FID,'\n--- Adding nodes so that mesh length ratio is less than ''h_ratio''\n\n'); end
    [xnew ratio nadded]=a_addnodes2(x,minh,maxrh);
    if VERBOSE; fprintf(A_FID,'    %d node(s) added, max ratio = %.2g ...\n\n',nadded, ratio); end
    xold=x;
    v=interp1(x,dev.node.v,xnew,'linear');
    x=xnew;
    nn=length(x);
    hh(1:nn-1)=x(2:nn)-x(1:nn-1);
    dev.node.pos=x;
    dev.node.v=v;
    for i=2:nn
        e=i-1;
        dev.ele.h(e)=(x(i)-x(i-1))/dev.norm.x;
        dev.ele.reg(e)=a_in_region(dev,0.5*(x(i-1)+x(i)));
    end
    no=length(xold);
    nl=interp1(xold(1:no-1),dev.ele.nl(1:no-1),xnew(1:nn-1));
    pl=interp1(xold(1:no-1),dev.ele.pl(1:no-1),xnew(1:nn-1));
    nr=interp1(xold(1:no-1),dev.ele.nr(1:no-1),xnew(1:nn-1));
    pr=interp1(xold(1:no-1),dev.ele.pr(1:no-1),xnew(1:nn-1));
    dev.mesh.num_nod=nn;
    dev.mesh.num_ele=nn-1;
    dev.ele.nl(1:dev.mesh.num_ele)=nl;
    dev.ele.pl(1:dev.mesh.num_ele)=pl;
    dev.ele.nr(1:dev.mesh.num_ele)=nr;
    dev.ele.pr(1:dev.mesh.num_ele)=pr;
    dev=set_pn_newt(dev);
    [dev error_code]=a_doeq(dev);
    if error_code == 0
        error('A_setmesh(3): simulation terminated\n');
    end
    
    if VERBOSE; fprintf(A_FID,'--- Number of nodes = %d\n\n',nn); end
end

if dev.mesh.num_nod > dev.mesh.max_nodes
    error('a_setmesh.m: Max number of nodes exceeded.\n')
end
    