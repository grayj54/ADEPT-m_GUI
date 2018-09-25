function [vals derivs] = a_amphoteric3(flag,fd,in)
% 3 multivalent traps
% input energies are wrt Ev
% 

gp=1;
g0=2;
gm=1;
    
if strcmp(flag,'eq') || strcmp(flag,'eqvals')

    po=in.p;
    no=in.n;
    eg=in.eg;
    nv=in.nv;
    nc=in.nc;
    nt=in.nt3;
    esp_v=in.e3p+log(gp/g0);
    esm_v=in.e3m+log(g0/gm);
    esp_c=eg-esp_v;
    esm_c=eg-esm_v;
    cnp=in.cnp3.*in.vthp;
    cpp=in.cpp3.*in.vthp;
    cnm=in.cnm3.*in.vthn;
    cpm=in.cpm3.*in.vthn;        
    % compute emission coefficients
    enp=nc.*cnp.*exp(-esp_c);
    enm=nc.*cnm.*exp(-esm_c);
    epp=nv.*cpp.*exp(-esp_v);
    epm=nv.*cpm.*exp(-esm_v);
    f1=(no.*cnp+epp)./(po.*cpp+enp);
    f2=(no.*cnm+epm)./(po.*cpm+enm);
    fsum=1+f1+f1.*f2;
    nsp=nt./fsum;
    ns0=nt.*f1./fsum;
    nsm=nt.*f1.*f2./fsum;
    vals.qs3=nsp-nsm;
    vals.nsp=nsp;
    vals.ns0=ns0;
    vals.nsm=nsm;
    %sumns=sum(vals.ns)
    % check that Rp=Rn=0
%        Rnp=no.*cnp.*nsp-enp.*ns0
%        Rnp1=no.*cnp.*nsp
%        Rnp2=enp.*ns0
%        Rpp=po.*cpp.*ns0-epp.*nsp
%        Rpp1=po.*cpp.*ns0
%        Rpp2=epp.*nsp
%        Rnm=no.*cnm.*ns0-enm.*nsm
%        Rnm1=no.*cnm.*ns0
%        Rnm2=enm.*nsm
%        Rpm=po.*cpm.*nsm-epm.*ns0
%        Rpm1=po.*cpm.*nsm
%        Rpm2=epm.*ns0
        
    if strcmp(flag,'eq')
      % derivatives
      df1dn=cnp./(po.*cnp+enp);
      df2dn=cnm./(po.*cnm+enm);
      dfsumdn=df1dn+f1.*df2dn+df1dn.*f2;
      df1dp=-cnp.*(f1./(po.*cnp+enp));
      df2dp=-cnm.*(f2./(po.*cnm+enm));
      dfsumdp=df1dp+f1.*df2dp+df1dp.*f2;
      %dnspdn=-nt./fsum./fsum.*dfsumdn;
      dnspdn=-nsp./fsum.*dfsumdn;
      %dnspdp=-nt./fsum./fsum.*dfsumdp;
      dnspdp=-nsp./fsum.*dfsumdp;
      %dnsmdn=-nt.*f1.*f2./fsum./fsum.*dfsumdn+nt.*f1.*df2dn./fsum+nt.*df1dn.*f2./fsum;
      dnsmdn=-nsm./fsum.*dfsumdn+nsm.*df2dn./f2+nsm.*df1dn./f1;
      %dnsmdp=-nt.*f1.*f2./fsum./fsum.*dfsumdp+nt.*f1.*df2dp./fsum+nt.*df1dp.*f2./fsum;
      dnsmdp=-nsm./fsum.*dfsumdp+nsm.*df2dp./f2+nsm.*df1dp./f1;
      derivs.dqsdn=dnspdn-dnsmdn;
      derivs.dqsdp=dnspdp-dnsmdp;
      % check
%          dns0dn=-nt.*f1./fsum./fsum.*dfsumdn+nt.*df1dn./fsum
%          dns0dp=-nt.*f1./fsum./fsum.*dfsumdp+nt.*df1dp./fsum
%          zerock1=dnspdn+dns0dn+dnsmdn
%          zerock2=dnspdp+dns0dp+dnsmdp
    end
        
elseif (strcmp(flag,'neq') || strcmp(flag,'vals')) && in.omega == 0
       
      rdt=in.rdt; %reciprocal time step
      rdtold=in.rdtold; %reciprocal time step

      if rdt == 0 % dc steady state
        n=in.n;
        p=in.p;
        po=in.po;
        no=in.no;
        eg=in.eg;
        nv=in.nv;
        nc=in.nc;
        nt=in.nt3;
        esp_v=in.e3p+log(gp/g0);
        esm_v=in.e3m+log(g0/gm);
        esp_c=eg-esp_v;
        esm_c=eg-esm_v;
        cnp=in.cnp3.*in.vthp;
        cpp=in.cpp3.*in.vthp;
        cnm=in.cnm3.*in.vthn;
        cpm=in.cpm3.*in.vthn;        
        % compute emission coefficients
        enp=nc.*cnp.*exp(-esp_c);
        enm=nc.*cnm.*exp(-esm_c);
        epp=nv.*cpp.*exp(-esp_v);
        epm=nv.*cpm.*exp(-esm_v);
        f1=(n.*cnp+epp)./(p.*cpp+enp);
        f2=(n.*cnm+epm)./(p.*cpm+enm);
        fsum=1+f1+f1.*f2;
        nsp=nt./fsum;
        ns0=nt.*f1./fsum;
        nsm=nt.*f1.*f2./fsum;
        vals.qs3=nsp-nsm;
        vals.nsp=nsp;
        vals.ns0=ns0;
        vals.nsm=nsm;
        % recombination rate
        top_p=(nsp+ns0).*(p.*n.*cpp.*cnp-epp.*enp);
        bot_p=n.*cnp+p.*cpp+enp+epp;
        top_m=(ns0+nsm).*(p.*n.*cpm.*cnm-epm.*enm);
        bot_m=n.*cnm+p.*cpm+enm+epm;
        Rplus=top_p./bot_p;
        Rminus=top_m./bot_m;
        vals.Rp3=Rplus+Rminus;
        vals.Rn3=vals.Rp3;
        if strcmp(flag,'neq')
          % derivatives
          df1dn=cnp./(p.*cnp+enp);
          df2dn=cnm./(p.*cnm+enm);
          dfsumdn=df1dn+f1.*df2dn+df1dn.*f2;
          df1dp=-cnp.*(f1./(p.*cnp+enp));
          df2dp=-cnm.*(f2./(p.*cnm+enm));
          dfsumdp=df1dp+f1.*df2dp+df1dp.*f2;
          dnspdn=-nsp./fsum.*dfsumdn;
          dnspdp=-nsp./fsum.*dfsumdp;
          dns0dn=-nt.*f1./fsum./fsum.*dfsumdn+nt.*df1dn./fsum;
          dns0dp=-nt.*f1./fsum./fsum.*dfsumdp+nt.*df1dp./fsum;
          dnsmdn=-nsm./fsum.*dfsumdn+nsm.*df2dn./f2+nsm.*df1dn./f1;
          dnsmdp=-nsm./fsum.*dfsumdp+nsm.*df2dp./f2+nsm.*df1dp./f1;
          derivs.dqsdn=dnspdn-dnsmdn;
          derivs.dqsdp=dnspdp-dnsmdp;
          dtpdp=(dnspdp+dns0dp).*(p.*n.*cpp.*cnp-epp.*enp)+(nsp+ns0).*n.*cpp.*cnp;
          dtpdn=(dnspdn+dns0dn).*(p.*n.*cpp.*cnp-epp.*enp)+(nsp+ns0).*p.*cpp.*cnp;
          dtmdp=(dns0dp+dnsmdp).*(p.*n.*cpm.*cnm-epm.*enm)+(ns0+nsm).*n.*cpm.*cnm;
          dtmdn=(dns0dn+dnsmdn).*(p.*n.*cpm.*cnm-epm.*enm)+(ns0+nsm).*p.*cpm.*cnm;
          drpdp=dtpdp./bot_p-top_p./bot_p./bot_p.*cpp;
          drpdn=dtpdn./bot_p-top_p./bot_p./bot_p.*cnp;
          drmdp=dtmdp./bot_m-top_m./bot_m./bot_m.*cpm;
          drmdn=dtmdn./bot_m-top_m./bot_m./bot_m.*cnm;
          derivs.dRp3dp=drpdp+drmdp;
          derivs.dRp3dn=drpdn+drmdn;
          derivs.dRn3dp=derivs.dRp3dp;
          derivs.dRn3dn=derivs.dRp3dn;
        end
      elseif rdt > 0 % transient
        n=in.n;
        p=in.p;
        po=in.po;
        no=in.no;
        eg=in.eg;
        nv=in.nv;
        nc=in.nc;
        nt=in.nt3;
        nspold=in.oldntNmvp3;
        ns0old=in.oldntNmv03;
        nsmold=in.oldntNmvm3;
        esp_v=in.e3p+log(gp/g0);
        esm_v=in.e3m+log(g0/gm);
        esp_c=eg-esp_v;
        esm_c=eg-esm_v;
        cnp=in.cnp3.*in.vthp;
        cpp=in.cpp3.*in.vthp;
        cnm=in.cnm3.*in.vthn;
        cpm=in.cpm3.*in.vthn;        
        % compute emission coefficients
        enp=nc.*cnp.*exp(-esp_c);
        enm=nc.*cnm.*exp(-esm_c);
        epp=nv.*cpp.*exp(-esp_v);
        epm=nv.*cpm.*exp(-esm_v);
        % compute trap occupation
        [rdt_eff nsp_last_eff]=a_bdf_nt(nspold,rdt,rdtold);
        %[rdt_eff ns0_last_eff]=a_bdf_nt(ns0old,rdt,rdtold);
        [rdt_eff nsm_last_eff]=a_bdf_nt(nsmold,rdt,rdtold);
        A1=rdt_eff+n.*cnp+enp+p.*cpp+epp;
        B1=enm+p.*cpp;
        C1=rdt_eff.*nsp_last_eff+(enp+p.*cpp).*nt;        
        A2=-(rdt_eff+n.*cnp+enp+n.*cnm+p.*cpp+epp+epm);   
        B2=-(rdt_eff+enp+n.*cnm+enm+p.*cpp+p.*cpm+epm);
        C2=-(rdt_eff.*(nsp_last_eff+nsm_last_eff)+enp+n.*cnm+p.*cpp+epm);
        Det=A1.*B2-B1.*A2;
        nsp=(C1.*B2-B1.*C2)./Det;
        nsm=(A1.*C2-C1.*A2)./Det;
        ns0=nt-nsp-nsm;
        vals.qs3=nsp-nsm;
        vals.nsp=nsp;
        vals.ns0=ns0;
        vals.nsm=nsm;
        Rpplus=p.*cpp.*ns0-epp.*nsp;
        Rpminus=p.*cpm.*nsm-epm.*ns0;
        Rnplus=n.*cnp.*nsp-enp.*ns0;
        Rnminus.*cnm.*ns0-enm.*nsm;
        vals.Rp3=Rpplus+Rpminus;
        vals.Rn3=Rnplus+Rnminus;
        if strcmp(flag,'neq')
          % derivatives
          dA1dp=cpp;
          dA1dn=cnp;
          dB1dp=cpp;
          %dB1dn=0;
          dC1dp=cpp.*nt;
          %dC1dn=0;
          dA2dp=-cpp;
          dA2dn=-cnp-cnm;
          dB2dp=-cpp-cpm;
          dB2dn=-cnm;
          dC2dp=-cpp;
          dC2dn=-cnm;
          dDetdp=A1.*dB2dp+dA1dp.*B2-B1.*dA2dp-dB1dp.*A2;
          %dDetdn=A1.*dB2dn+dA1dn.*B2-B1.*dA2dn-dB1dn.*A2;
          dDetdn=A1.*dB2dn+dA1dn.*B2-B1.*dA2dn;
          dnspdp=(C1.*dB2dp+dC1dp.*B2-B1.*dC2dp-dB1dp.*C2)./Det-nsp./Det.*dDetdp;
          %dnspdn=(C1.*dB2dn+dC1dn.*B2-B1.*dC2dn-dB1dn.*C2)./Det-nsp./Det.*dDetdn;
          dnspdn=(C1.*dB2dn-B1.*dC2dn)./Det-nsp./Det.*dDetdn;
          dnsmdp=(A1.*dC2dp+dA1dp.*C2-C1.*dA2dp-dC1dp.*A2)./Det-nsm./Det.*dDetdp;
          %dnsmdn=(A1.*dC2dn+dA1dn.*C2-C1.*dA2dn-dC1dn.*A2)./Det-nsm./Det.*dDetdn;
          dnsmdn=(A1.*dC2dn+dA1dn.*C2-C1.*dA2dn)./Det-nsm./Det.*dDetdn;
          dns0dp=-dnspdp-dnsmdp;
          dns0dn=-dnspdn-dnsmdn;
          derivs.dqsdn=dnspdn-dnsmdn;
          derivs.dqsdp=dnspdp-dnsmdp;
          drppdp=cpp.*ns0+p.*cpp.*dns0dp-epp.*dnspdp;
          drppdn=p.*cpp.*dns0dn-epp.*dnspdn;
          drpmdp=cpm.*nsm+p.*cpm.*dnsmdp-epm.*dns0dp;
          drpmdn=p.*cpm.*dnsmdn-epm.*dns0dn;
          drnpdp=cnp.*ns0+n.*cnp.*dns0dp-enp.*dnspdp;
          drnpdn=n.*cnp.*dns0dn-enp.*dnspdn;
          drnmdp=cnm.*nsm+n.*cnm.*dnsmdp-enm.*dns0dp;
          drnmdn=n.*cnm.*dnsmdn-enm.*dns0dn;
          derivs.dRp3dp=drppdp+drpmdp;
          derivs.dRp3dn=drppdn+drpmdn;
          derivs.dRn3dp=drnpdp+drnmdp;
          derivs.dRn3dn=drnpdn+drnmdn;
        end
      end

elseif (strcmp(flag,'neq') || strcmp(flag,'vals')) && in.omega > 0 % small signal ac
    n=in.n;
    p=in.p;
    po=in.po;
    no=in.no;
    eg=in.eg;
    nv=in.nv;
    nc=in.nc;
    nt=in.nt3;
    nsp=in.nsp;
    ns0=in.ns0;
    nsm=in.nsm;
    esp_v=in.e3p+log(gp/g0);
    esm_v=in.e3m+log(g0/gm);
    esp_c=eg-esp_v;
    esm_c=eg-esm_v;
    cnp=in.cnp3.*in.vthp;
    cpp=in.cpp3.*in.vthp;
    cnm=in.cnm3.*in.vthn;
    cpm=in.cpm3.*in.vthn;        
    % compute emission coefficients
    enp=nc.*cnp.*exp(-esp_c);
    enm=nc.*cnm.*exp(-esm_c);
    epp=nv.*cpp.*exp(-esp_v);
    epm=nv.*cpm.*exp(-esm_v);a0=j*omega./(p.*cpp+enp);
    
    a0=j*omwga./(p.*cpp+enp);
    a1=(j*omega+n.*cnm+epm)./(p.*cpm+enm);
    
    db0dn=nsp.*cnp./(p.*cpp+enp);
    db0dp=-ns0.*cpp./(p.*cpp+enp);
    db1dn=ns0.*cnm./(p.*cpm+enm);
    db1dp=-nsm.*cpm./(p.*cpm+enm);
    
    trm=nt./(1+a0.(2+a1));
    dnspdn=-trm.*((1+a1).*db0dn+db1dn);
    dns0dn=trm.*(1+a0).*db0dn-a0.*db1dn;
    dnsmdn=trm.*(a1-a0).*db0dn+(1+a0).*db1dn;
    dnspdp=-trm.*((1+a1).*db0dp+db1dp);
    dns0dp=trm.*(1+a0).*db0dp-a0.*db1dp;
    dnsmdp=trm.*(a1-a0).*db0dp+(1+a0).*db1dp;
    
    drppdp=p.*cpp.*dns0dp-epp.*dnspdp+cpp.*ns0;
    drppdn=p.*cpp.*dns0dn-epp.*dnspdn;
    drpmdp=p.*cpm.*dnsmdp-epm.*dns0dp+cpm.*nsm;
    drpmdn=p.*cpm.*dnsmdn-epm.*dns0dn;
    drnpdp=n.*cnp.*dnspdp-enp.*dns0dp;
    drnpdn=n.*cnp.*dnspdn-enp.*dns0dn+cnp.*nsp;
    drnmdp=n.*cnm.*dns0dp-enm.*dnsmdp;
    drnmdn=n.*cnm.*dns0dn-enm.*dnsmdn+cnm.*ns0;
    
    derivs.dRp3dp=drppdp+drpmdp;
    derivs.dRp3dn=drppdn+drpmdn;
    derivs.dRn3dp=drnpdp+drnmdp;
    derivs.dRn3dn=drnpdn+drnmdn;
    derivs.dqsdn=dnspdn-dnsmdn;
    derivs.dqsdp=dnspdp-dnsmdp;
    
else
    error('a_amphoteric3: undefined operating condition')  
end
          
