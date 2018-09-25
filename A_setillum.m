function illum=A_setillum
% illum=A_setillum
% answer questions to set illumination
%
  fprintf('\n\n');
  
  fprintf('      1=uniform\n');
  fprintf('      2=mono\n');
  fprintf('      3=spectrum\n\n');
  itype=0;
  while itype < 1 || itype > 3
    itype=input('   Select illumination type: ');
    if itype/floor(itype) ~= 1
      itype=0;
    end
  end
  
  switch itype
    case 1
      illum.type='uniform';
      nr=-1;
      while nr < 0
        nr=input('   Enter number of regions: ');
        if itype/floor(itype) ~= 1
          itype=0;
        end
      end
      for ii=1:nr
        fprintf('   Enter J_Gen for region %d',ii);
        illum.J_Gen(ii)=input(' (A/cm^2): ');
      end
    case 2
      illum.type='mono';
      illum.top_or_bottom='not set';
      while strcmp(illum.top_or_bottom,'top') == 0 && strcmp(illum.top_or_bottom,'bottom') == 0
        illum.top_or_bottom=input('   Is illumination from the top or bottom? ','s');
      end
      illum.J_Inc=input('   Enter incident current density (A/cm^2): ');
      illum.wl=input('   Enter illumination wavelength (microns): ');
      illum.inc_angle=input('   Enter angle of incidence (degrees): ');
    case 3
      illum.type='spectrum';
      illum.top_or_bottom='not set';
      while strcmp(illum.top_or_bottom,'top') == 0 && strcmp(illum.top_or_bottom,'bottom') == 0
        illum.top_or_bottom=input('   Is illumination from the top or bottom? ','s');
      end
      illum.spectrum=input('   Enter name of the spectrum file: ','s');
      illum.X=input('   Enter concentrtion factor: ');
      illum.inc_angle=input('   Enter angle of incidence (degrees): ');
    otherwise
      error('Illumination type not recognized')
  end
  
end