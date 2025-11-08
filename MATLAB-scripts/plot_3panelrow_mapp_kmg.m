function plot_3panelrow_mapp_kmg(s,z1,z2,z3,vname,expn,f,k,icmap, do_print)
aa=s.aa;
if (k==1)
  sea='ANN';
elseif(k==2)
  sea='MAM';
elseif(k==3)
  sea='JJA';
elseif(k==4)
  sea='SON';
elseif(k==5)
  sea='DJF';
end


vname=strcat(vname,'_',sea);  

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;


pms=[60 400 1200 300];
handle = figure('Position', pms,'visible','on',...
    'color','white','Units','normalized');

x0=-0.01; y0=0.25; wx=0.3; wy=0.7; dx=0.02; dy=0.02;
p1= [x0,            y0,        wx, wy];%position of first subplot
p2= [x0+(wx+dx),    y0,        wx, wy];%position of first subplot
p3= [x0+2*(wx+dx),  y0,        wx, wy];%position of first subplot

nn=30; % 32
cmap1=bluewhitered(nn);
caxis([s.c1 s.c2]);
if (icmap==0)
  cmap=fabien_colormap(nn);
elseif (icmap==1) 
  cmap=bluewhitered(nn);
elseif (icmap==2)
  cmap =cbrewer('seq', 'BuGn', nn);
  cmap1=cbrewer('div', 'BrBG', nn); cmap=cmap1;
else
  cmap=jet(nn); %cmap(nn/2:nn/2+1,:)=1;
end

xc=0.28;
pos1=[xc            0.35  0.015 0.5 ];%[left bottom width height];
pos2=[xc+(wx+dx)    0.35  0.015 0.5 ];%[left bottom width height];
pos3=[xc+2.*(wx+dx) 0.35  0.015 0.5 ];%[left bottom width height];

row=3; col=1; domap='noprojection'; domap='robinson'; 


subplot('Position',p1); a=z1;
do_mapproj_kmg(lat,lon,a,s.vbino1,latx,lonx,lm,domap,xy); %clabel(C,h); 
caxis([s.c1 s.c2]); colormap(cmap); freezeColors; 
h=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); cbfreeze(h,cmap);%cbunits(h,s.unit); 
title(s.s1,'FontSize',18,'Interpreter','latex');
  
subplot('Position',p2); a=z2;
do_mapproj_kmg(lat,lon,a,s.vbino2,latx,lonx,lm,domap,xy); %clabel(C,h); 
caxis([s.c3 s.c4]); colormap(cmap); freezeColors; 
h=colorbar('Location','eastoutside','Position',pos2,'FontSize',16); cbfreeze(h,cmap);%cbunits(h,s.unit); 
title(s.s2,'FontSize',18,'Interpreter','latex');

subplot('Position',p3); a=z3;
do_mapproj_kmg(lat,lon,a,s.vbino3,latx,lonx,lm,domap,xy); %clabel(C,h); 
caxis([s.c5 s.c6]); colormap(cmap); freezeColors; 
h=colorbar('Location','eastoutside','Position',pos3,'FontSize',16); cbfreeze(h,cmap);%cbunits(h,s.unit); 
title(s.s3,'FontSize',18,'Interpreter','latex');
