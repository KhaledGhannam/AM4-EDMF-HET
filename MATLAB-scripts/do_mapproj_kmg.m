function [C,h]=do_mapproj_kmg(lat,lon,z1,vbino,latx,lonx,lm,domap,xy)
if (strcmp(domap,'noprojection'))
  [C,h]=contourf (lon,lat,z1,vbino, 'LineStyle', 'none'); shading flat; hold on;
  contour(lonx,latx,lm,'k','LineWidth',1); axis(xy);
  fsize=12; set(gca,'FontSize',fsize);
else
  axesm('MapProjection',domap,'origin',[0,180]);
  framem;
  contourfm(lat,lon,z1,vbino, 'LineStyle', 'none'); hold on;
  contourm(latx,lonx,lm,'k','LineWidth',1);
  box off; axis off; % shading flat;
end
return
