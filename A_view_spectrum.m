function [sdata]=A_view_spectrum(sfile)
% [sdata]=A_view_spectrum(sfile)
% plot spectrum irradiance vs wavelength

sdata=get_sdata(sfile);
plot(sdata.wl,sdata.irrad)
hold on
title(sdata.info)
xlabel('Wavelength (\mum)')
ylabel('Irradiance (W/m^2/\mum)')
end

