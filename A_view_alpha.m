function [adata]=A_view_alpha(afile)
% [adata]=A_view_alpha(filename)
% plot absortion coefficient vs wavelength

[adata]=a_ralpha(afile);
plot(adata.wl,adata.alpha)
hold on
title(adata.info)
xlabel('Wavelength (\mum)')
ylabel('Absorption Coefficient (cm^{-1})')
end

