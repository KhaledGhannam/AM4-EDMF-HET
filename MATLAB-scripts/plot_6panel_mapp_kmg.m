function plot_6panel_mapp_kmg(s,z1,z2,z3,z4,vname,expn,f,k,icmap, do_print)
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

% s1: obs; s2: AM4 orig; s3: AM4 edmf
% To plot: s1, s2-s1, s3-s1, s3-s2
z2z1 = z2 - z1;
z3z1 = z3 - z1;
z4z1 = z4 - z1;
z4z2 = z4 - z2;
z4z3 = z4 - z3;

vname=strcat(vname,'_',sea); a=s.aa;
id=~isnan(z2z1) & ~isnan(z3z1); a(id)=a(id)/mean(a(id)); a=a(id);

e=z2z1(id); s.rmse21=sqrt(mean(e.*e.*a)); s.bias21=mean(mean(e.*a));
e=z3z1(id); s.rmse31=sqrt(mean(e.*e.*a)); s.bias31=mean(mean(e.*a));
e=z4z1(id); s.rmse41=sqrt(mean(e.*e.*a)); s.bias41=mean(mean(e.*a));
e=z4z2(id); s.rmse42=sqrt(mean(e.*e.*a)); s.bias42=mean(mean(e.*a));
e=z4z3(id); s.rmse43=sqrt(mean(e.*e.*a)); s.bias43=mean(mean(e.*a));
s.s2=sprintf('%s (BIAS=%5.2f; RMSE=%5.2f)',s.s2,s.bias21,s.rmse21);
s.s3=sprintf('%s (BIAS=%5.2f; RMSE=%5.2f)',s.s3,s.bias31,s.rmse31);
s.s4=sprintf('%s (BIAS=%5.2f; RMSE=%5.2f)',s.s4,s.bias41,s.rmse41);
s.s5=sprintf('%s (DIFF=%5.2f)',s.s5,s.bias42);
s.s6=sprintf('%s (DIFF=%5.2f)',s.s6,s.bias43);

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
vbin=s.vbin; vbino=s.vbino;
domap='noprojection'; domap='hammer'; domap='robinson'; %domap='eckert4';

a=s.aa; id=~isnan(z1); a(id)=a(id)/mean(a(id)); a=a(id);
e=z1(id); s.mean1=mean(e.*a);
s.s1=sprintf('%s (%s; MEAN=%5.2f)',s.s1,upper(sea),s.mean1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pms=[ 0, 0, 600, 1100]*0.8; fsize=10; lw=2; msize=8;
% handle = figure('Position', pms,'visible','on');
% x0=0.08; y0=0.7; wx=0.8; wy=0.25*3/4; dy=0.05*3/4; %icmap=5;
% p1= [x0,y0,           wx, wy];%position of first subplot
% p2= [x0,y0-  (wy+dy), wx, wy];%position of first subplot
% p3= [x0,y0-2*(wy+dy), wx, wy];%position of first subplot
% p4= [x0,y0-3*(wy+dy), wx, wy];%position of first subplot


pms=[ 40, 40, 1200, 900]*1.; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=-0.01; y0=0.65; wx=0.48; wy=0.28; dx=0.025; dy=0.03;
p1= [x0,            y0,            wx, wy];%position of first subplot
p2= [x0+wx+dx,      y0,            wx, wy];%position of first subplot
p3= [x0,            y0-(wy+dy),    wx, wy];%position of first subplot
p4= [x0+wx+dx,      y0-(wy+dy),    wx, wy];%position of first subplot
p5= [x0,            y0-2.*(wy+dy), wx, wy];%position of first subplot
p6= [x0+(wx+dx),    y0-2.*(wy+dy), wx, wy];%position of first subplot
nn=30; % 32
caxis([s.cmin s.cmax]); cmap1=bluewhitered(nn);
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
pos1=[0.45  0.68  0.015 0.22 ];%[left bottom width height];
pos2=[0.95  0.68  0.015 0.22 ];%[left bottom width height];
pos3=[0.45  0.37  0.015 0.22 ];%[left bottom width height];
pos4=[0.95  0.37  0.015 0.22 ];%[left bottom width height];
pos5=[0.45  0.07  0.015 0.22 ];%[left bottom width height];
pos6=[0.95  0.07  0.015 0.22 ];%[left bottom width height];

row=3; col=1; domap='noprojection'; domap='robinson';


subplot('Position',p1); a=z1;
do_mapproj_kmg(lat,lon,a,s.vbino,latx,lonx,lm,domap,xy); %clabel(C,h);
caxis([s.c1 s.c2]); colormap(cmap); freezeColors;
h=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); cbfreeze(h,cmap);%cbunits(h,s.unit);
title(s.s1,'FontSize',14);

subplot('Position',p2); a=z2z1; id=isnan(a); a(id)=0;
do_mapproj_kmg(lat,lon,a,s.vbin,latx,lonx,lm,domap,xy); %clabel(C,h);
caxis([s.cmin s.cmax]); colormap(cmap1); freezeColors;
h=colorbar('Location','eastoutside','Position',pos2,'FontSize',16); %cbfreeze(h,cmap);
cbunits(h,s.unit);
title(s.s2,'FontSize',14);

subplot('Position',p3); a=z3z1; id=isnan(a); a(id)=0;
do_mapproj_kmg(lat,lon,a,s.vbin,latx,lonx,lm,domap,xy); %clabel(C,h);
caxis([s.cmin s.cmax]); colormap(cmap1); %freezeColors;
h=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
title(s.s3,'FontSize',14);

subplot('Position',p4); a=z4z1; id=isnan(a); a(id)=0;
do_mapproj_kmg(lat,lon,a,s.vbin,latx,lonx,lm,domap,xy); %clabel(C,h);
caxis([s.cmin s.cmax]); colormap(cmap1); %freezeColors;
h=colorbar('Location','eastoutside','Position',pos4,'FontSize',16);
title(s.s4,'FontSize',14);

subplot('Position',p5); a=z4z2; id=isnan(a); a(id)=0;
do_mapproj_kmg(lat,lon,a,s.vbin,latx,lonx,lm,domap,xy); %clabel(C,h);
caxis([s.cminclasp s.cmaxclasp]); colormap(cmap1); colorbar; %freezeColors;
h=colorbar('Location','eastoutside','Position',pos5,'FontSize',16);
title(s.s5,'FontSize',14);

subplot('Position',p6); a=z4z3; id=isnan(a); a(id)=0;
do_mapproj_kmg(lat,lon,a,s.vbin,latx,lonx,lm,domap,xy); %clabel(C,h);
caxis([s.cminclasp2 s.cmaxclasp2]); colormap(cmap1); %freezeColors;
h=colorbar('Location','eastoutside','Position',pos6,'FontSize',16);
title(s.s6,'FontSize',14);

if do_print
visfig='off'; vname=strcat(vname,'_',domap);
printit(visfig,expn,vname);
end
