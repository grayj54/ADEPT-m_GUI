function [adata,fig]=A_examine(dev,what,varargin)
% A_exammine(dev,what,...)
%
% dev = ADEPT-m device structure created by A_build or A_applyOpCond
% what = string describing data to examine, call with no arguments for list
%
% optional input argument pairs:
%
%    'range' -- [xmin,xmax] -- use same units as defined by 'xunits'
%                              (defaults to full range)
%    'xunits' -- 'cm' or 'um' or 'nm' or 'A' (defaults to 'um')recom
%    'plot' -- 'on' or 'off' (defaults to 'on')
%    'legend' -- legend position for plots (defaults to 'bestoutside')
%                can be 'best', 'bestoutside', or 'hide'
%    'extract' -- 'on' or 'off' (defaults to 'off', if 'on' exports to
%                                strcture 'adata'
%    'Excel' -- {filename} (default is empty string, not exported)

% for expert use: 'smooth'  -- 'on' or 'off' (defaults to 'on')
a_init;

if nargin == 0
    disp(' ');
    disp('The following plots may be requested:');
    disp(' ');
    disp('    carrier: Electron/Hole Densities');
    disp('     charge: Charge Density');
    disp('    current: Current Density');
    disp('     doping: Doping Density');
    disp('      eband: Energy Band Diagram');
    disp('      field: Electric/Displacement Fields');
    disp('    genrate: Generation Rate');
    disp('  potential: Electric Potential');
    disp('     recomb: Recombination Rates');
    disp(' ');
    disp('  ac_charge: Small-Signal Charge Density');
    disp(' ac_current: Small-Signal Current Density');
    disp(' ');
    return;
end

data=dev.data;
scalex=1e4; % default to um
x_unit='um';
doplot=1;
doxtrct=0;
smooth=1; % smooth element data by default
drange=[data.NODE.X(1),data.NODE.X(length(data.NODE.X))]; % default range
range=drange;
setr=0;
filen='';

pdescribe=dev.description;
pmode=dev.OpCond.mode;
pv=dev.OpCond.Va;
pj=dev.OpCond.Jt;

ptitle=sprintf('ADEPT-m: %s',dev.runno);

mon = get(0,'screensize');
monw=mon(3)-mon(1)+1;
monh=mon(4)-mon(2)+1;
offset=floor(0.05*min(monw,monh));
fw=floor(monw/3.4286);
fh=floor(monh/2.5714);

lrange=monw-fw-2*offset;
lmax=floor(lrange/offset);
brange=monh-fh-4*offset;
bmax=floor(brange/offset);
left=floor(rand*lmax)*offset;
bottom=floor(rand*bmax)*offset;
dpos=[left bottom fw fh];
legloc='bestoutside';
%set(0,'defaultfigureposition',dpos);

if nargin <= 1
    disp(' ');
    disp('The following plots may be requested:');
    disp(' ');
    disp('    carrier: Electron/Hole Densities ');
    disp('     charge: Charge Density');
    disp('    current: Current Density');
    disp('     doping: Doping Density');
    disp('      eband: Energy Band Diagram');
    disp('      field: Electric/Displacement Fields');
    disp('    genrate: Generation Rate');
    disp('  potential: Electric Potential');
    disp('     recomb: Recombination Rates');
    disp(' ');
    if strcmp(dev.OpCond.mode,'small-signal')
        disp('  ac_charge: Small-Signal Charge Density');
        disp(' ac_current: Small-Signal Current Density');
        disp(' ');
    end
    return;
elseif nargin > 2
    nop=nargin-2;
    if mod(nop,2) == 1
        error('A_plot.m: mismatched input arguments'); 
    else
        nop=nop/2;
        for iop=1:nop
          op{iop}=varargin{2*iop-1};
          val{iop}=varargin{2*iop};
        end
    end
    for iop=1:nop
        switch op{iop}
            case 'legend'
                if isnumeric(val{iop})
                    error('A_plot.m: legend={''best'' ''bestoutside'' ''hide''}')
                else
                    switch char(val{iop})
                        case 'best'
                            legloc='best';
                        case 'bestoutside'
                            legloc='bestoutside';
                        case 'hide'
                            legloc='hide';
                        otherwise
                            error('A_plot.m: legend error')
                    end
                end
            case 'range'
                if isnumeric(val{iop}) && length(val{iop}) == 2
                    range=val{iop};
                    setr=1;
                else
                    error('A_plot.m: range error')
                end
            case 'xunits'
                if isnumeric(val{iop})
                    error('A_plot.m: xunits error')
                else
                    switch char(val{iop})
                        case 'cm'
                            scalex=1;
                            x_unit='cm';
                        case 'um'
                            scalex=1e4;
                            x_unit='um';
                        case 'nm'
                            scalex=1e7;
                            x_unit='nm';
                        case 'A'
                            scalex=1e8;
                            x_unit='A';
                        otherwise
                            error('A_plot.m: xunits error')
                    end
                end
            case 'smooth'
                if isnumeric(val{iop})
                    error('A_plot.m: ''smooth'' must be ''on'' or ''off''')
                else
                    if strcmp(char(val{iop}),'off')
                        smooth=0;
                    elseif strcmp(char(val{iop}),'on')
                        smooth=1;
                    else
                        error('A_plot.m: ''smooth'' must be ''on'' or ''off''')
                    end
                end
            case 'plot'
                if isnumeric(val{iop})
                    error('A_plot.m: ''plot'' must be ''on'' or ''off''')
                else
                    if strcmp(char(val{iop}),'off')
                        doplot=0;
                    elseif strcmp(char(val{iop}),'on')
                        doplot=1;
                    else
                        error('A_plot.m: ''plot'' must be ''on'' or ''off''')
                    end
                end
            case 'extract'
                if isnumeric(val{iop})
                    error('A_plot.m: ''extract'' must be ''on'' or ''off''')
                else
                    if strcmp(char(val{iop}),'off')
                        doxtrct=0;
                    elseif strcmp(char(val{iop}),'on')
                        doxtrct=1;
                    else
                        error('A_plot.m: ''extract'' must be ''on'' or ''off''')
                    end
                end
            case 'Excel'
                if isnumeric(val{iop})
                    error('A_plot.m: Excel error')
                else
                    filen=char(val{iop});
                    l4='';
                    l5='';
                    if length(filen) > 5
                        l4=filen(length(filen)-3:length(filen));
                    end
                    if length(filen) > 6
                        l5=filen(length(filen)-4:length(filen));
                    end
                    if strcmp(l4,'.xls') || strcmp(l5,'.xlsx')
                        % file name has extention
                    else
                        filen=strcat(filen,'.xlsx');
                    end
                end
            otherwise
                error('a_plot.m: option ''%s'' not recognized',string(op{iop}))
        end
    end
end

drange=drange*scalex;
if setr == 0
    range=range*scalex;
end
if range(1) < drange(1) || range(2) > drange(2)
    error('A_plot.m: range out of bounds')
end
data.NODE.X=data.NODE.X*scalex;
data.ELE1.X=data.ELE1.X*scalex;
data.ELE2.X=data.ELE2.X*scalex;
data.INT.X=data.INT.X*scalex;

xlab=sprintf('x (%s)',x_unit);
[a_node,b_node]=p_zoom(data.NODE.X,range);
[a_ele1,b_ele1]=p_zoom(data.ELE1.X,range);
[a_ele2,b_ele2]=p_zoom(data.ELE2.X,range);
[a_int,b_int]=p_zoom(data.INT.X,range);

%-----------------------------------------------------------------------
%   plots start here
%-----------------------------------------------------------------------

switch what
    
    case 'charge'
        lwhat='Charge Density';
        if smooth
          [x,y]=p_smooth(data.ELE2.X,[data.ELE2.P;data.ELE2.N;data.ELE2.NT;data.ELE2.PO;data.ELE2.NO;data.ELE2.NTO],2);
          p=y(1,:);
          n=y(2,:);
          c=y(3,:);
          q=p-n+c;
          po=y(4,:);
          no=y(5,:);
          co=y(6,:);
          qo=po-no+co;
          a=a_node;
          b=b_node;
        else  
          x=data.ELE2.X;
          p=data.ELE2.P;
          n=data.ELE2.N;
          c=data.ELE2.NT;
          q=p-n+c;
          po=data.ELE2.PO;
          no=data.ELE2.NO;
          co=data.ELE2.NTO;
          qo=po-no+co;
          a=a_ele2;
          b=b_ele2;
        end
          
        %plot
        if doplot
            fig=figure;
            set(fig,'name','Charge Density');
            set(fig,'position',dpos);
            plot(x(a:b),q(a:b),'k');
            hold on
            plot(x(a:b),qo(a:b),'k:');
            xlabel(xlab)
            ylabel('\rho/q');
            title(ptitle)
            legend('\rho/q','\rho_o/q','location',legloc);
            hold off
        end
        %export plot data
        xz=x(a:b);
        if doxtrct
            yz(:,1)=q(a:b);
            yz(:,2)=qo(a:b);
            y_labels{1}='rho/q (#/cm3)';
            y_labels{2}='rho_o/q (#/cm3)';
        end
        %export to Excel
        if strcmp(filen,'') == 0 
              yyz(:,1)=q(a:b);
              yyz(:,2)=qo(a:b);
              xlswrite(filen,{xlab,'rho/q (#/cm3)','rho_o/q (#/cm3)'})
              A=[xz',yyz];
              xlsrange=sprintf(' A2:C%d',length(xz)+1);
              xlswrite(filen,A,xlsrange);
              fprintf('\nCharge density data exported to: %s\n',filen)
        end
    
    case 'potential'
        lwhat='Electric Potential';
        kTq=data.kTq;
        fd=data.fd;
        x=data.NODE.X;
        v=data.NODE.V;
        vo=data.NODE.VO;
        dv=v-vo;
        
        %plot
        if doplot
            fig=figure;
            set(fig,'name','Electric Potential');
            set(fig,'position',dpos);
            plot(x(a_node:b_node),v(a_node:b_node),'k')
            hold on
            plot(x(a_node:b_node),vo(a_node:b_node),'k:')
            plot(x(a_node:b_node),dv(a_node:b_node),'b')
            xlabel(xlab)
            ylabel('Potential (V)')
            title(ptitle)
            legend('V','V_o','(V-V_o)','location',legloc);
            hold off
        end
        %export plot data
        xz=x(a_node:b_node);
        if doxtrct
            yz(:,1)=v(a_node:b_node);
            yz(:,2)=vo(a_node:b_node);
            yz(:,3)=dv(a_node:b_node);
            y_labels{1}='V (V)';
            y_labels{2}='Vo (V)';
            y_labels{3}='(V-Vo) (V)';
        end
        %export to Excel
        if strcmp(filen,'') == 0 
            xlswrite(filen,{xlab,'V (V)','Vo (V)','(V-Vo) (V)'})
            A=[xz',yz];
            xlsrange=sprintf(' A2:D%d',length(xz)+1);
            xlswrite(filen,A,xlsrange);
            fprintf('\nElectric potential data exported to: %s\n',filen)
        end
    
    case 'doping'
        lwhat='Doping Density';
        if smooth
          [x,y]=p_smooth(data.ELE2.X,[data.ELE2.NDP;data.ELE2.ND;data.ELE2.ND_ionized;...
                                      data.ELE2.NAM;data.ELE2.NA;data.ELE2.NA_ionized],2);
          ndp=y(1,:);
          nd=y(2,:);
          ndi=y(3,:);
          ndtot=ndp+nd;
          ndtoti=ndp+ndi;
          nam=y(4,:);
          na=y(5,:);
          nai=y(6,:);
          natot=nam+na;
          natoti=nam+nai;
          a=a_node;
          b=b_node;
        else  
          ndp=data.ELE2.NDP;
          nd=data.ELE2.ND;
          ndi=data.ELE2.ND_ionized;
          ndtot=ndp+nd;
          ndtoti=ndp+ndi;
          nam=data.ELE2.NAM;
          na=data.ELE2.NA;
          nai=data.ELE2.NA_ionized;
          natot=nam+na;
          natoti=nam+nai;
          a=a_ele2;
          b=b_ele2;
        end

      ndp(ndp<1)=1;
      nd(nd<1)=1;
      ndi(ndi<1)=1;
      ndtot(ndtot<1)=1;
      ndtoti(ndtoti<1)=1;
      nam(nam<1)=1;
      na(na<1)=1;
      nai(nai<1)=1;
      natot(natot<1)=1;
      natoti(natoti<1)=1;
        
      %plot
      if doplot
          fig=figure;
          set(fig,'name','Doping Density');
          set(fig,'position',dpos);
          semilogy(x(a:b),ndtot(a:b),'r');
          hold on
          semilogy(x(a:b),ndtoti(a:b),'r:');
          semilogy(x(a:b),ndp(a:b),'m--');
          semilogy(x(a:b),nd(a:b),'m');
          semilogy(x(a:b),ndi(a:b),'m:');
          semilogy(x(a:b),natot(a:b),'b');
          semilogy(x(a:b),natoti(a:b),'b:');
          semilogy(x(a:b),nam(a:b),'c--');
          semilogy(x(a:b),na(a:b),'c');
          semilogy(x(a:b),nai(a:b),'c:');
          xlabel(xlab)
          ylabel('Doping Density (#/cm^3)')
          title(ptitle)
          legend('N_{D,tot}','N^+_{D,tot}','N_{D^+}','N_{D}','N^+_{D}',...
                 'N_{A,tot}','N^-_{A,tot}','N_{A^-}','N_{A}','N^-_{A}',...
                 'location',legloc);
          grid on
          hold off
      end
      %export plot data
      xz=x(a:b);
      if doxtrct
          yz(:,1)=ndtot(a:b);
          yz(:,2)=ndtoti(a:b);
          yz(:,3)=ndp(a:b);
          yz(:,4)=nd(a:b);
          yz(:,5)=ndi(a:b);
          yz(:,6)=natot(a:b);
          yz(:,7)=natoti(a:b);
          yz(:,8)=nam(a:b);
          yz(:,9)=na(a:b);
          yz(:,10)=nai(a:b);
          y_labels{1}='Nd,tot (cm-3)';
          y_labels{2}='Nd+,tot (cm-3)';
          y_labels{3}='Ndp (cm-3)';
          y_labels{4}='Nd (cm-3)';
          y_labels{5}='Nd+ (cm-3)';
          y_labels{6}='Na,tot (cm-3)';
          y_labels{7}='Na+,tot (cm-3)';
          y_labels{8}='Nam (cm-3)';
          y_labels{9}='Na (cm-3)';
          y_labels{10}='Na- (cm-3)';
      end
      %export to Excel
      if strcmp(filen,'') == 0 
            xlswrite(filen,{xlab,'Nd,tot (cm-3)','Nd+,tot (cm-3)','Ndp (cm-3)','Nd (cm-3)','Nd+ (cm-3)'...
                                 'Na,tot (cm-3)','Na-,tot (cm-3)','Nam (cm-3)','Na (cm-3)','Na- (cm-3)'})
            A=[xz',yz];
            xlsrange=sprintf(' A2:K%d',length(xz)+1);
            xlswrite(filen,A,xlsrange);
            fprintf('\nDoping density data exported to: %s\n',filen)
        end
        
    case 'ac_charge'
      lwhat='Small-Signal Charge Density';
      if strcmp(pmode,'small-signal')
        if smooth
          [x,y]=p_smooth(data.ELE2.X,[data.ELE2.p_ac;data.ELE2.n_ac;data.ELE2.nq_ac],2);
          pac=y(1,:);
          nac=y(2,:);
          cac=y(3,:);
          qac=pac-nac+cac;
          a=a_node;
          b=b_node;
        else  
          x=data.ELE2.X;
          pac=data.ELE2.p_ac;
          nac=data.ELE2.n_ac;
          cac=data.ELE2.nq_ac;
          qac=pac-nac+cac;
          a=a_ele2;
          b=b_ele2;
        end
        
        %plot
        if doplot
            fig=figure;
            set(fig,'name','Small-Signal Charge Density');
            set(fig,'position',dpos);
            plot(x(a:b),abs(qac(a:b)),'k');
            hold on
            plot(x(a:b),real(qac(a:b)),'k--');
            plot(x(a:b),imag(qac(a:b)),'k:');
            xlabel(xlab)
            ylabel('\rho/q_{ac}');
            title(ptitle)
            legend('|\rho/q_{ac}|','Re(\rho/q_{ac})','Im(\rho/q_{ac})','location',legloc);
            hold off
        end
        %export plot data
        xz=x(a:b);
        if doxtrct
            yz(:,1)=qac(a:b);
            y_labels{1}='(rho/q)_ac (#/cm3)';
        end
        %export to Excel    
        if strcmp(filen,'') == 0 
              yyz(:,1)=real(qac(a:b));
              yyz(:,2)=imag(qac(a:b));
              xlswrite(filen,{xlab,'Re(rho/q_ac) (#/cm3)','Im(rho/q_ac) (#/cm3)'})
              A=[xz',yyz];
              xlsrange=sprintf(' A2:C%d',length(xz)+1);
              xlswrite(filen,A,xlsrange);
              fprintf('\nSmall-signal charge density data exported to: %s\n',filen)
        end
      else
        error('mode of operation must be ''small-signal'' for ac values')
      end
      
    case 'ac_current'
      lwhat='Small-Signal Current Density';
      if strcmp(pmode,'small-signal')
        if smooth
          [x,y]=p_smooth(data.ELE1.X,[data.ELE1.jp_ac;data.ELE1.jn_ac;data.ELE1.jd_ac],1);
          jp=y(1,:);
          jn=y(2,:);
          jd=y(3,:);
          jt=jp+jn+jd;
          a=a_node;
          b=b_node;
        else  
          x=data.ELE1.X;
          jp=data.ELE1.jp_ac;
          jn=data.ELE1.jn_ac;
          jd=data.ELE1.jd_ac;
          jt=jp+jn+jd;
          a=a_ele1;
          b=b_ele1;
        end
        
        %plot
        if doplot
            fig=figure;
            set(fig,'name','Small-Signal Current Density');
            set(fig,'position',dpos);
            plot(x(a:b),abs(jt(a:b)),'k');
            hold on
            plot(x(a:b),abs(jp(a:b)),'r');
            plot(x(a:b),abs(jn(a:b)),'b');
            plot(x(a:b),abs(jd(a:b)),'g');
            plot(x(a:b),real(jt(a:b)),'k--');
            plot(x(a:b),real(jp(a:b)),'r--');
            plot(x(a:b),real(jn(a:b)),'b--');
            plot(x(a:b),real(jd(a:b)),'g--');
            plot(x(a:b),imag(jt(a:b)),'k:');
            plot(x(a:b),imag(jp(a:b)),'r:');
            plot(x(a:b),imag(jn(a:b)),'b:');
            plot(x(a:b),imag(jd(a:b)),'g:');
            xlabel(xlab)
            ylabel('J_{ac}');
            title(ptitle)
            legend('|J_{ac}|','|Jp_{ac}|','|Jn_{ac}|','|Jd_{ac}|',...
                   'Re(J_{ac})','Re(Jp_{ac})','Re(Jn_{ac})','Re(Jd_{ac})',...
                   'Im(J_{ac})','Im(Jp_{ac})','Im(Jn_{ac})','Im(Jd_{ac})',...
                   'location',legloc);
            hold off
        end
        %export plot data
        xz=x(a:b);
        if doxtrct
            yz(:,1)=jt(a:b);
            yz(:,2)=jp(a:b);
            yz(:,3)=jn(a:b);
            yz(:,4)=jd(a:b);
            y_labels{1}='J_ac';
            y_labels{2}='Jp_ac';
            y_labels{3}='Jn_ac';
            y_labels{4}='Jd_ac';
        end
        %export to Excel    
        if strcmp(filen,'') == 0 
              yyz(:,1)=real(jt(a:b));
              yyz(:,2)=imag(jt(a:b));
              yyz(:,3)=real(jp(a:b));
              yyz(:,4)=imag(jp(a:b));
              yyz(:,5)=real(jn(a:b));
              yyz(:,6)=imag(jn(a:b));
              yyz(:,7)=real(jd(a:b));
              yyz(:,8)=imag(jd(a:b));
              xlswrite(filen,{xlab,'Re(J_ac)','Im(J_ac)','Re(Jp_ac)','Im(Jp_ac)',...
                                   'Re(Jn_ac)','Im(Jn_ac)','Re(Jd_ac)','Im(Jd_ac)'})
              A=[xz',yyz];
              xlsrange=sprintf(' A2:I%d',length(xz)+1);
              xlswrite(filen,A,xlsrange);
              fprintf('\nSmall-signal current density data exported to: %s\n',filen)
        end
      else
        error('mode of operation must be ''small-signal'' for ac values')
      end
      
    case 'current'
        lwhat='Current Density';
        if smooth
          [x,y]=p_smooth(data.ELE1.X,[data.ELE1.Jp;data.ELE1.Jn;data.ELE1.Jd],1);
          jp=y(1,:);
          jn=y(2,:);
          jd=y(3,:);
          jt=jp+jn+jd;
          a=a_node;
          b=b_node;
        else  
          x=data.ELE1.X;
          jp=data.ELE1.Jp;
          jn=data.ELE1.Jn;
          jd=data.ELE1.Jd;
          jt=jp+jn+jd;
          a=a_ele1;
          b=b_ele1;
        end

        %plot
        if doplot
            fig=figure;
            set(fig,'name','Current Density');
            set(fig,'position',dpos);
            plot(x(a:b),jt(a:b),'k');
            hold on
            plot(x(a:b),jp(a:b),'r');
            plot(x(a:b),jn(a:b),'b');
            plot(x(a:b),jd(a:b),'g');
            xlabel(xlab)
            ylabel('J (A/cm^2)');
            title(ptitle)
            legend('J','Jp','Jn','Jd','location',legloc);
            hold off
        end
        %export plot data
        xz=x(a:b);
        if doxtrct
            yz(:,1)=jt(a:b);
            yz(:,2)=jp(a:b);
            yz(:,3)=jn(a:b);
            yz(:,4)=jd(a:b);
            y_labels{1}='J (A/cm2)';
            y_labels{2}='Jp (A/cm2)';
            y_labels{3}='Jn (A/cm2)';
            y_labels{4}='Jd (A/cm2)';
        end
        %export to Excel   
        if strcmp(filen,'') == 0 
              xlswrite(filen,{xlab,'J (A/cm2)','Jp (A/cm2)','Jn (A/cm2)','Jd (A/cm2)'})
              A=[xz',yz];
              xlsrange=sprintf(' A2:E%d',length(xz)+1);
              xlswrite(filen,A,xlsrange);
              fprintf('\nCurrent density data exported to: %s\n',filen)
        end
      
    case 'hratio' % expert user only
        lwhat='hratio';
        nn=length(data.NODE.X);    
        x=data.NODE.X;
        h=x(2:nn)-x(1:nn-1);
        xm=x(2:nn-1);
        for kk=2:nn-1
          hrat(kk-1)=max([h(kk-1)/h(kk),h(kk)/h(kk-1)]);
        end
        a=1;
        b=nn-2;
        
        fig=figure;
        set(fig,'name','h ratio');
        set(fig,'position',dpos);
        plot(xm,hrat);
        xz=xm;
        yz(:,1)=hrat;
        xlabel(xlab)
        ylabel('h ratio');
        y_labels{1}='h ratio';
        size(xm)
        size(hrat)
        
    case 'nodeh' % expert user only
        lwhat='nodeh';
        x=data.NODE.X;
        nn=length(x);
        xm=0.5*(x(2:nn)+x(1:nn-1));
        h=x(2:nn)-x(1:nn-1);
        a=a_node;
        b=b_node-1;
        
        fig=figure;
        set(fig,'name','Mesh Spacing');
        set(fig,'position',dpos);
        semilogy(xm(a:b),h(a:b));
        xz=xm(a:b);
        yz(:,1)=h(a:b);
        xlabel(xlab)
        ylab=sprintf('h (%s)',x_unit);
        ylabel(ylab);
        y_labels{1}=ylab;
        
    case 'eband'
        lwhat='Energy Band Diagram';
        kTq=data.kTq;
        fd=data.fd;
        x=data.NODE.X;
        v=data.NODE.V;
        xx=data.ELE2.X;
        nn=length(x);

        E0(1:nn)=0;

        [~,chi]=p_smooth(xx,data.ELE2.CHI,2);
        [~,eg]=p_smooth(xx,data.ELE2.EG,2);
        [~,nc]=p_smooth(xx,data.ELE2.NC,2);
        [~,nv]=p_smooth(xx,data.ELE2.NV,2);
        [~,p]=p_smooth(xx,data.ELE2.P,2);
        [~,n]=p_smooth(xx,data.ELE2.N,2);

        Ec=E0-v-chi;
        Ev=Ec-eg;
        Ei=(Ec+Ev)/2+kTq/2*log(nv/nc);
        if strcmp(fd,'off') %Boltzmann
            Fp=Ev-kTq*log(p./nv);
            Fn=Ec+kTq*log(n./nc);
        else
            Fp=Ev-kTq*rez_fermi(p./nv);
            Fn=Ec+kTq*rez_fermi(n./nc);
        end

        %plot
        if doplot
            fig=figure;
            set(fig,'name','Energy Band');
            set(fig,'position',dpos);
            plot(x(a_node:b_node),Ec(a_node:b_node),'k')
            hold on
            plot(x(a_node:b_node),Ev(a_node:b_node),'k')
            plot(x(a_node:b_node),Ei(a_node:b_node),'k:')
            plot(x(a_node:b_node),Fp(a_node:b_node),'r-.')
            plot(x(a_node:b_node),Fn(a_node:b_node),'b-.')
            xlabel(xlab)
            ylabel('Energy (eV)')
            title(ptitle)
            legend('Ec','Ev','Ei','Fp','Fn','location',legloc);
            hold off
        end
        %export plot data
        xz=x(a_node:b_node);
        if doxtrct
            yz(:,1)=Ec(a_node:b_node);
            yz(:,2)=Ev(a_node:b_node);
            yz(:,3)=Ei(a_node:b_node);
            yz(:,4)=Fp(a_node:b_node);
            yz(:,5)=Fn(a_node:b_node);
            y_labels{1}='Ec (eV)';
            y_labels{2}='Ev (eV)';
            y_labels{3}='Ei (eV)';
            y_labels{4}='Fp (eV)';
            y_labels{5}='Fn (eV)';
            end
        %export to Excel
        if strcmp(filen,'') == 0 
            yyz(:,1)=Ec(a_node:b_node);
            yyz(:,2)=Ev(a_node:b_node);
            yyz(:,3)=Ei(a_node:b_node);
            yyz(:,4)=Fp(a_node:b_node);
            yyz(:,5)=Fn(a_node:b_node);
            xlswrite(filen,{xlab,'Ec (eV)','Ev (eV)','Ei (eV)','Fp (eV)','Fn (eV)'})
            A=[xz',yyz];
            xlsrange=sprintf(' A2:F%d',length(xz)+1);
            xlswrite(filen,A,xlsrange);
            fprintf('\nEnergy band data exported to: %s\n',filen)
        end

    case 'field'
        lwhat='Electric/Displacement Fields';
        if smooth
          [x,y]=p_smooth(data.ELE1.X,[data.ELE1.E;data.ELE1.D;data.ELE1.Eo;data.ELE1.Do],1);
          E=y(1,:);
          D=y(2,:);
          Eo=y(3,:);
          Do=y(4,:);
          a=a_node;
          b=b_node;
        else  
          x=data.ELE1.X;
          E=data.ELE1.E;
          Eo=data.ELE1.Eo;
          D=data.ELE1.D;
          Do=data.ELE1.Do;
          a=a_ele1;
          b=b_ele1;
        end
        
        %plot
        if doplot
            fig=figure;
            set(fig,'name','Electric/Displacement Fields');
            set(fig,'position',dpos);
            left_color = [0 0 0];
            right_color = [0 0 0];
            set(fig,'defaultAxesColorOrder',[left_color; right_color]);
            yyaxis left
            plot(x(a:b),E(a:b)','k');
            hold on
            plot(x(a:b),Eo(a:b)','k:');
            xlabel(xlab)
            ylabel('E (V/cm)');
            title(ptitle)
            yyaxis right
            plot(x(a:b),D(a:b)','r');
            hold on
            plot(x(a:b),Do(a:b)','r:');
            ylabel('D (C/cm^2)');
            legend('E','Eo','D','Do','location',legloc);
            hold off
        end
        %export plot data
        xz=x(a:b);
        if doxtrct
            yz(:,1)=E(a:b);
            yz(:,2)=Eo(a:b);
            yz(:,3)=D(a:b);
            yz(:,4)=Do(a:b);
            y_labels{1}='E (V/cm)';
            y_labels{2}='Eo (V/cm)';
            y_labels{3}='D (C/cm2)';
            y_labels{4}='Do (C/cm2)';
        end
        %export to Excel    
        if strcmp(filen,'') == 0 
            yyz(:,1)=E(a:b);
            yyz(:,2)=Eo(a:b);
            yyz(:,3)=D(a:b);
            yyz(:,4)=Do(a:b);
            xlswrite(filen,{xlab,'E (V/cm)','Eo (V/cm)','D (C/cm2)','Do (C/cm2)'})
            A=[xz',yyz];
            xlsrange=sprintf(' A2:E%d',length(xz)+1);
            xlswrite(filen,A,xlsrange);
            fprintf('\nElectric/displacement field data exported to: %s\n',filen)
        end
        
    case 'recomb'
      lwhat='Recombination Rates';  
      if dev.OpCond.rdt == 0

        if smooth
            [x,y]=p_smooth(data.ELE2.X,[data.ELE2.RP;data.ELE2.R_RAD;data.ELE2.R_AUGER;data.ELE2.R_SHR;...
                           data.ELE2.RP_SLT;data.ELE2.RP_BT;data.ELE2.RP_NA;data.ELE2.RP_ND],2);
            R=y(1,:);
            Rrad=y(2,:);
            Raug=y(3,:);
            Rshr=y(4,:);
            Rslt=y(5,:);
            Rbt=y(6,:);
            Ra=y(7,:);
            Rd=y(8,:);

            xx=data.INT.X;
            yy=dev.data.INT.RPINT/data.INT.RPINT(length(xx));
            Rint=interp1(xx,yy,x);
            a=a_node;
            b=b_node;
        else  
            x=data.ELE2.X;
            R=data.ELE2.RP;
            Rrad=data.ELE2.R_RAD;
            Raug=data.ELE2.R_AUGER;
            Rshr=data.ELE2.R_SHR;
            Rslt=data.ELE2.RP_SLT;
            Rbt=data.ELE2.RP_BT;
            Ra=data.ELE2.RP_NA;
            Rd=data.ELE2.RP_ND;
            xx=data.INT.X;
            yy=data.INT.RPINT/data.INT.RPINT(length(xx));
            Rint=interp1(xx,yy,x);
            a=a_ele2;
            b=b_ele2;
        end
        
        %plot
        if doplot
            fig=figure;
            set(fig,'name','Recombination Rate');
            set(fig,'position',dpos);
            left_color = [0 0 0];
            right_color = [0 0 0];
            set(fig,'defaultAxesColorOrder',[left_color; right_color]);
            yyaxis left
            title(ptitle)
            plot(x(a:b),R(a:b),'LineWidth',3);
            hold on
            il=0;
            if sum(Rrad==0) ~= length(Rrad)
                il=il+1;
                pr(il)=plot(x(a:b),Rrad(a:b),'b');
                set(pr(il),'DisplayName','R_{rad}');
            end
            if sum(Raug==0) ~= length(Raug)
                il=il+1;
                pr(il)=plot(x(a:b),Raug(a:b),'g');
                set(pr(il),'DisplayName','R_{Auger}');
            end
            if sum(Rshr==0) ~= length(Rshr)
                il=il+1;
                pr(il)=plot(x(a:b),Rshr(a:b),'r');
                set(pr(il),'DisplayName','R_{SHR}');
            end
            if sum(Rslt==0) ~= length(Rslt)
                il=il+1;
                pr(il)=plot(x(a:b),Rslt(a:b),'m');
                set(pr(il),'DisplayName','R_{SLT}');
            end
            if sum(Rbt==0) ~= length(Rbt)
                il=il+1;
                pr(il)=plot(x(a:b),Rbt(a:b),'c');
                set(pr(il),'DisplayName','R_{band-tails}');
            end
            if sum(Ra==0) ~= length(Ra)
                il=il+1;
                pr(il)=plot(x(a:b),Ra(a:b),'y--');
                set(pr(il),'DisplayName','R_{acceptor}');
            end
            if sum(Rd==0) ~= length(Rd)
                il=il+1;
                pr(il)=plot(x(a:b),Rd(a:b),'y-.');
                set(pr(il),'DisplayName','R_{donor}');
            end
            xlabel(xlab)
            ylabel('Recombination Rate (#/cm^3-s)') % left y-axis
            yyaxis right
            axis([-inf inf 0 1]);
            plot(x(a:b),Rint(a:b),'--','LineWidth',1.5);
            ylabel('Relative Integrated Recombination') % right y-axis
            if il == 1
                legend('R_{total}',get(pr(1),'DisplayName'),'R_{int}','location',legloc);
            elseif il == 2
                legend('R_{total}',get(pr(1),'DisplayName'),get(pr(2),'DisplayName'),'R_{int}','location',legloc);
            elseif il == 3
                legend('R_{total}',get(pr(1),'DisplayName'),get(pr(2),'DisplayName'),get(pr(3),'DisplayName'),'R_{int}','location',legloc);
            elseif il == 4
                legend('R_{total}',get(pr(1),'DisplayName'),get(pr(2),'DisplayName'),get(pr(3),'DisplayName'),get(pr(4),'DisplayName'),'R_{int}','location',legloc);
            elseif il == 5
                legend('R_{total}',get(pr(1),'DisplayName'),get(pr(2),'DisplayName'),get(pr(3),'DisplayName'),get(pr(4),'DisplayName'),get(pr(5),'DisplayName'),'R_{int}','location',legloc);
            elseif il == 6
                legend('R_{total}',get(pr(1),'DisplayName'),get(pr(2),'DisplayName'),get(pr(3),'DisplayName'),get(pr(4),'DisplayName'),get(pr(5),'DisplayName'),get(pr(6),'DisplayName'),'R_{int}','location',legloc);
            elseif il == 7
                legend('R_{total}',get(pr(1),'DisplayName'),get(pr(2),'DisplayName'),get(pr(3),'DisplayName'),get(pr(4),'DisplayName'),get(pr(5),'DisplayName'),get(pr(6),'DisplayName'),get(pr(7),'DisplayName'),'R_{int}','location',legloc);
                %legend('Rtot','Rrad','Rauger','Rshr','Rslt','Rbt','Ra','Rd','Rint','location',legloc);
            end
            hold off
        end
        %export plot data
        xz=x(a:b);
        if doxtrct
            yz(:,1)=R(a:b);
            yz(:,2)=Rrad(a:b);
            yz(:,3)=Raug(a:b);
            yz(:,4)=Rshr(a:b);
            yz(:,5)=Rslt(a:b);
            yz(:,6)=Rbt(a:b);
            yz(:,7)=Ra(a:b);
            yz(:,8)=Rd(a:b);
            yz(:,9)=Rint(a:b);
            y_labels{1}='R_tot (#/cm^3-s)';
            y_labels{2}='R_rad (#/cm^3-s)';
            y_labels{3}='R_Auger (#/cm^3-s)';
            y_labels{4}='R_shr (#/cm^3-s)';
            y_labels{5}='R_slt (#/cm^3-s)';
            y_labels{6}='R_bt (#/cm^3-s)';
            y_labels{7}='R_a (#/cm^3-s)';
            y_labels{8}='R_d (#/cm^3-s)';
            y_labels{9}='R_int(x)';
        end
        %export to Excel    
        if strcmp(filen,'') == 0 
            yyz(:,1)=R(a:b);
            yyz(:,2)=Rrad(a:b);
            yyz(:,3)=Raug(a:b);
            yyz(:,4)=Rshr(a:b);
            yyz(:,5)=Rslt(a:b);
            yyz(:,6)=Rbt(a:b);
            yyz(:,7)=Ra(a:b);
            yyz(:,8)=Rd(a:b);
            yyz(:,9)=Rint(a:b);
            xlswrite(filen,{xlab,'R_tot (#/cm^3-s)','R_rad (#/cm^3-s)','R_Auger (#/cm^3-s)','R_shr (#/cm^3-s)','R_slt (#/cm^3-s)','R_bt (#/cm^3-s)','R_a (#/cm^3-s)','R_d (#/cm^3-s)','R_int'})
            A=[xz',yyz];
            xlsrange=sprintf(' A2:J%d',length(xz)+1);
            xlswrite(filen,A,xlsrange);
            fprintf('\nRecombination rate data exported to: %s\n',filen)
        end
      else
        error('transient recombination plots to come')
      end

    case 'genrate'
        lwhat='Generation Rate';
        if strcmp(pmode,'steady-state')
            
            if smooth
                [x,y]=p_smooth(data.ELE2.X,[data.ELE2.G],2);
                G=y(1,:);
                xx=data.INT.X;
                yy=data.INT.GINT/data.INT.GINT(length(xx));
                Gint=interp1(xx,yy,x);
                a=a_node;
                b=b_node;
            else  
                x=data.ELE2.X;
                G=data.ELE2.G;
                xx=data.INT.X;
                yy=dev.data.INT.GINT/data.INT.GINT(length(xx));
                Gint=interp1(xx,yy,x);
                a=a_ele2;
                b=b_ele2;
            end
        else
            error('genrate')
        end
        
        %plot
        if doplot
            fig=figure;
            set(fig,'name','Generation Rate');
            set(fig,'position',dpos);
            left_color = [0 0 0];
            right_color = [0 0 0];
            set(fig,'defaultAxesColorOrder',[left_color; right_color]);
            yyaxis left
            title(ptitle)
            plot(x(a:b),G(a:b),'LineWidth',2);
            hold on
            xlabel(xlab)
            ylabel('Generation Rate (#/cm^3-s)') % left y-axis
            yyaxis right
            plot(x(a:b),Gint(a:b),'--','LineWidth',2);
            ylabel('Relative Integrated Generation') % right y-axis
            legend('G','Gint','location',legloc);
            hold off
        end
        %export plot data
        xz=x(a:b);
        if doxtrct
            yz(:,1)=G(a:b);
            yz(:,2)=Gint(a:b);
            y_labels{1}='G (#/cm^3-s)';
            y_labels{2}='G_int(x)';
        end
        %export to Excel    
        if strcmp(filen,'') == 0 
            yyz(:,1)=G(a:b);
            yyz(:,2)=Gint(a:b);
            xlswrite(filen,{xlab,'G (#/cm^3-s)','G_int'})
            A=[xz',yyz];
            xlsrange=sprintf(' A2:C%d',length(xz)+1);
            xlswrite(filen,A,xlsrange);
            fprintf('\nGeneration rate data exported to: %s\n',filen)
        end

    case 'carrier'
      lwhat='Electron/Hole Densities';
      if smooth
          [x,y]=p_smooth(data.ELE2.X,[data.ELE2.P;data.ELE2.N;data.ELE2.PO;data.ELE2.NO],2);
          p=y(1,:);
          n=y(2,:);
          po=y(3,:);
          no=y(4,:);
          a=a_node;
          b=b_node;
          nio=sqrt(po.*no);
      else  
        x=data.ELE2.X;
        p=data.ELE2.P;
        n=data.ELE2.N;
        po=data.ELE2.PO;
        no=data.ELE2.NO;
        nio=sqrt(po.*no);
        a=a_ele2;
        b=b_ele2;
      end

      %plot
      if doplot
          fig=figure;
          set(fig,'name','Carrier Density');
          set(fig,'position',dpos);
          semilogy(x(a:b),p(a:b),'r');
          hold on
          semilogy(x(a:b),n(a:b),'b');
          semilogy(x(a:b),po(a:b),'r:');
          semilogy(x(a:b),no(a:b),'b:');
          semilogy(x(a:b),nio(a:b),'g--');
          xlabel(xlab)
          ylabel('Carrier Density (#/cm^3)')
          title(ptitle)
          legend('p','n','p_o','n_o','n_i','location',legloc);
          grid on
          hold off
      end
      %export plot data
      xz=x(a:b);
      if doxtrct
          %export plot data
          yz(:,1)=p(a:b);
          yz(:,2)=n(a:b);
          yz(:,3)=po(a:b);
          yz(:,4)=no(a:b);
          y_labels{1}='p (cm-3)';
          y_labels{2}='n (cm-3)';
          y_labels{3}='po (cm-3)';
          y_labels{4}='no (cm-3)';
      end
      %export to Excel    
      if strcmp(filen,'') == 0 
          yyz(:,1)=p(a:b);
          yyz(:,2)=n(a:b);
          yyz(:,3)=po(a:b);
          yyz(:,4)=no(a:b);
          xlswrite(filen,{xlab,'p (cm-3)','n (cm-3)','po (cm-3)','no (cm-3)'})
          A=[xz',yyz];
          xlsrange=sprintf(' A2:E%d',length(xz)+1);
          xlswrite(filen,A,xlsrange);
          fprintf('\nCarrier density data exported to: %s\n',filen)
      end

    otherwise
        error('A_plot.m: requested plot not found')
end

adata.what=lwhat;
if strcmp(filen,'') == 0 
    adata.Excel=filen;
end
if doxtrct
    adata.x=xz';
    adata.y=yz;
    adata.xlabels=xlab;
    adata.ylabels=y_labels;
end