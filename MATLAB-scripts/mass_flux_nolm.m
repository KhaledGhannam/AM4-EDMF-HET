clear; clc; close all;
addpath('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab/');
addpath('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab/am4_plot_miz');
addpath('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab/am4_plot_miz/freezeColors');
addpath('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab/am4_plot_miz/cm_and_cb_utilities');
addpath('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/figures');
addpath('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/plotting_scripts/');


land_frac=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab/land.static.nc','land_frac');
cell_area=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab/land.static.nc','cell_area');
area_am4 = repmat(diff(sind(-90:90))/2, 288,1)/288;

f_orig = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/t_ref.nc';

am4_orig = struct();
am4_orig.lat = ncread(f_orig, 'lat');
am4_orig.lon = ncread(f_orig, 'lon');
am4_orig.land_mask = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab//atmos.static.nc',...
    'land_mask');
am4_orig.area = area_am4;

am4_ncep = struct();
am4_ncep.lat = am4_orig.lat;
am4_ncep.lon = am4_orig.lon;
am4_ncep.land_mask = am4_orig.land_mask;
am4_ncep.area = area_am4;

am4_clasp = struct();
am4_clasp.lat = am4_orig.lat;
am4_clasp.lon = am4_orig.lon;
am4_clasp.land_mask = am4_orig.land_mask;
am4_clasp.area = area_am4;


am4_clasp_lnd = struct();
am4_clasp_lnd.lat = am4_orig.lat;
am4_clasp_lnd.lon = am4_orig.lon;
am4_clasp_lnd.land_mask = am4_orig.land_mask;
am4_clasp_lnd.area = area_am4;

am4_clasp_lndlm = struct();
am4_clasp_lndlm.lat = am4_orig.lat;
am4_clasp_lndlm.lon = am4_orig.lon;
am4_clasp_lndlm.land_mask = am4_orig.land_mask;
am4_clasp_lndlm.area = area_am4;


% ---- read mass flux -----

% --- NCEP ------
mu_ncep = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/Mu_han_lev.nc','Mu_han'));

mu_clasp = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_zas/Mu_han_lev.nc','Mu_han'));

pfull_ncep = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/Mu_han_lev.nc','pfull'));

pfull_clasp = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/Mu_han_lev.nc','pfull'));

max_h = 15;

x_ncep=squeeze(mean(mu_ncep(:,:,end-max_h:end,:),3,'omitnan'));
x_clasp=squeeze(mean(mu_clasp(:,:,end-max_h:end,:),3,'omitnan'));

%mask1=NaN(288,180);
%pval1=NaN(288,180);
%
%for i=1:288
%for j=1:180
%  clear hh1 pp1 hh2 pp2

%    x1 = squeeze(x_ncep(i,j,:));
%    x2 = squeeze(x_clasp(i,j,:));
%
%    [hh1,pp1]=ttest2(x1,x2);
%
%    mask1(i,j)=hh1; pval1(i,j)=pp1;
%
%end
%end

%mask2=mask1';


x_ncep2=squeeze(mean(x_ncep,3,'omitnan'))';
x_clasp2=squeeze(mean(x_clasp,3,'omitnan'))';



yy=x_clasp2-x_ncep2;

fpath='./'; expn='am4';
do_print = 0;

s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;

s.c1=0;   s.c2=3;   s.vbino=[s.c1:0.2:s.c2]; s.unit='(K)';
s.cmin=-0.3; s.cmax=0.3; s.vbin =[s.cmin:0.05:s.cmax];

s.c3=0;   s.c4=6;   s.vbino34=[s.c1:0.2:s.c2];
s.cmin3=-0.6; s.cmax3=0.6; s.vbin36 =[s.cmin:0.05:s.cmax];

%--------------
aa=s.aa;
sea='ANN';


a=s.aa;

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
vbin=s.vbin; vbino=s.vbino;
domap='robinson';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pms=[ 300, 500, 1200, 400]*1.; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=0.05; y0=0.1; wx=0.40; wy=0.7; dx=0.05; dy=0.03;
p1=  [x0-0.05,       y0,            wx, wy];
p2=  [x0+wx+0.04,         y0,            wx, wy];


nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);


pos1= [0.40  0.18  0.02 0.50 ];%[left bottom width height];
pos2= [0.89  0.18  0.02 0.50 ];%[left bottom width height];

row=3; col=1; domap='noprojection'; domap='robinson';


ax1=subplot('Position',p1); a=100.*x_clasp2;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,s.vbino, 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([s.c1 s.c2]); colormap(ax1,cmap); freezeColors;
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); cbfreeze(h1,cmap);
h1.Ticks = [0 1 2 3];
h1.TickLabels = {'0','1','2','3'};
set(get(h1,'Title') ,'String','cm/s');
title({'(a) Vertically averaged M_{u}', '(AM4-EDMF-HET-MF)'},'FontSize',14);

ax2=subplot('Position',p2); clear a; a=100.*yy;
%a(land_frac'<0.1 & (a>-0.02 & a<0.02))=NaN;
a(a>-0.03 & a<0.03)=NaN;
%a(mask2>0.5)=NaN;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,s.vbin, 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([s.cmin s.cmax]); colormap(ax2,bluewhitered(nn)); freezeColors;
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-0.3 -0.2 -0.1 0 0.1 0.2 0.3];
h2.TickLabels = {'-0.3','-0.2','-0.1','0','0.1','0.2','0.3'};
set(get(h2,'Title') ,'String','cm/s');
title({'(b) Vertically averaged M_{u}', '(AM4-EDMF-HET-MF minus AM4-EDMF)'},'FontSize',14);
%--

cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'massflux_integrated_12302024.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%----------


%------- Mu vertical profiles zonal means (land only)-----

s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;

s.c1=0;   s.c2=3;   s.vbino=[s.c1:0.2:s.c2]; s.unit='(K)';
s.cmin=-0.3; s.cmax=0.3; s.vbin =[s.cmin:0.05:s.cmax];

s.c3=0;   s.c4=6;   s.vbino34=[s.c1:0.2:s.c2];
s.cmin3=-0.6; s.cmax3=0.6; s.vbin36 =[s.cmin:0.05:s.cmax];


lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
vbin=s.vbin; vbino=s.vbino;
domap='robinson';


xx=repmat(land_frac,1,1,33,420);
mu_clasp_lnd = mu_clasp; mu_clasp_lnd(xx<0.4)=NaN;
mu_ncep_lnd = mu_ncep; mu_ncep_lnd(xx<0.4)=NaN;


%  --- vertical slices US-------
clear id1 id2 slice_us_clasp slice_us_ncep
id1 = find(lon>=240 & lon<=280); %--- US longitude span---
id2 = find(lat>25 & lat<50); %--- US latitude span---

slice_us_clasp = squeeze(mean(mu_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_us_ncep = squeeze(mean(mu_ncep_lnd(id1,id2,:,:),4,'omitnan'));

slice_us_clasp_jja = reshape(mu_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_clasp_lnd,3),12,[]);
slice_us_clasp_jja = mean(mean(slice_us_clasp_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_us_ncep_jja = reshape(mu_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_ncep_lnd,3),12,[]);
slice_us_ncep_jja = mean(mean(slice_us_ncep_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');

max_h=15;
slice_us_clasp = slice_us_clasp(:,:,end-max_h:end);
slice_us_ncep = slice_us_ncep(:,:,end-max_h:end);

slice_us_clasp_jja = slice_us_clasp_jja(:,:,end-max_h:end);
slice_us_ncep_jja = slice_us_ncep_jja(:,:,end-max_h:end);

slice_us_clasp = fliplr(squeeze(mean(slice_us_clasp,2,'omitnan')));
slice_us_ncep = fliplr(squeeze(mean(slice_us_ncep,2,'omitnan')));
diff_clasp_ncep = slice_us_clasp - slice_us_ncep;

slice_us_clasp_jja = fliplr(squeeze(mean(slice_us_clasp_jja,2,'omitnan')));
slice_us_ncep_jja = fliplr(squeeze(mean(slice_us_ncep_jja,2,'omitnan')));
diff_clasp_ncep_jja = slice_us_clasp_jja - slice_us_ncep_jja;
% ---- plot -----

pms=[ 200, 250, 1600, 1150]*1.; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
%----
p3=  [0.06,          0.805,          0.35, 0.14];
p4=  [0.57,          0.805,          0.35, 0.14];
p5=  [0.06,          0.558,          0.35, 0.14];
p6=  [0.57,          0.558,          0.35, 0.14];
p7=  [0.06,          0.310,          0.35, 0.14];
p8=  [0.57,          0.310,          0.35, 0.14];
p9=  [0.06,          0.066,          0.35, 0.14];
p10= [0.57,          0.066,          0.35, 0.14];

pos3= [0.435        0.800  0.015 0.14 ];%[left bottom width height];
pos4= [0.945        0.800  0.015 0.14 ];%[left bottom width height];
pos5= [0.435        0.553  0.015 0.14 ];%[left bottom width height];
pos6= [0.945        0.553  0.015 0.14 ];%[left bottom width height];
pos7= [0.435        0.305  0.015 0.14 ];%[left bottom width height];
pos8= [0.945        0.305  0.015 0.14 ];%[left bottom width height];
pos9= [0.435        0.061  0.015 0.14 ];%[left bottom width height];
pos10=[0.945        0.061  0.015 0.14 ];%[left bottom width height];

nn1=30;
nn=30;
cmap=jet(nn1);
cmap1=bluewhitered(nn);

ax3=subplot('Position',p3); clear a; a=100.*slice_us_clasp_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 6, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax3, 'YDir', 'reverse');
ax3.FontSize = 16;
set(ax3,'Xminortick','on')
set(ax3,'TickDir','out');
caxis([0 6]);
colormap(ax3,cmap); freezeColors;
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [0 2 4 6];
h3.TickLabels = {'0','2','4','6'};
xticks([241.8750 260.6250 279.3750])
xticklabels({'120^{\circ}W','100^{\circ}W','80^{\circ}W'})
%xlabel('Longitude')
ylabel('Pressure (hPa)')
set(get(h3,'Title') ,'String','cm/s');
title({'(a) M_{u} (CONUS; 25N-50N)','(AM4-EDMF-HET-MF)'},'FontSize',14);


ax4=subplot('Position',p4); clear a; a=100.*diff_clasp_ncep_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a',4, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.2f", "FaceAlpha",1,'LabelSpacing', 300);
set(ax4, 'YDir', 'reverse');
ax4.FontSize = 16;
set(ax4,'Xminortick','on')
set(ax4,'TickDir','out');
caxis([-0.6 0.6]);
colormap(ax4,bluewhitered(nn)); freezeColors;
h4=colorbar('Location','eastoutside','Position',pos4,'FontSize',16); cbfreeze(h4,cmap);
h4.Ticks = [-0.6 -0.3 0 0.3 0.6];
h4.TickLabels = {'-0.6','-0.3','0','0.3','0.6'};
%xlabel('Longitude')
%ylabel('Pressure (hPa)')
xticks([241.8750 260.6250 279.3750])
xticklabels({'120^{\circ}W','100^{\circ}W','80^{\circ}W'})
ylabel('Pressure (hPa)')
set(get(h4,'Title') ,'String','cm/s');
title({'(b) M_{u} (CONUS; 25N-50N)','(AM4-EDMF-HET-MF minus AM4-EDMF)'},'FontSize',14);



%  --- vertical slices Central Africa-------
clear id1 id2 slice_afr_clasp slice_afr_ncep diff_clasp_ncep diff_clasp_ncep_jja
id1 = find(lon>=9 & lon<=47); %--- Central Africa longitude span---
id2 = find(lat>-10 & lat<10); %--- Central Africa latitude span---

slice_afr_clasp = squeeze(mean(mu_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_afr_ncep = squeeze(mean(mu_ncep_lnd(id1,id2,:,:),4,'omitnan'));

slice_afr_clasp_jja = reshape(mu_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_clasp_lnd,3),12,[]);
slice_afr_clasp_jja = mean(mean(slice_afr_clasp_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_afr_ncep_jja = reshape(mu_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_ncep_lnd,3),12,[]);
slice_afr_ncep_jja = mean(mean(slice_afr_ncep_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');

max_h=15;
slice_afr_clasp = slice_afr_clasp(:,:,end-max_h:end);
slice_afr_ncep = slice_afr_ncep(:,:,end-max_h:end);

slice_afr_clasp_jja = slice_afr_clasp_jja(:,:,end-max_h:end);
slice_afr_ncep_jja = slice_afr_ncep_jja(:,:,end-max_h:end);

slice_afr_clasp = fliplr(squeeze(mean(slice_afr_clasp,2,'omitnan')));
slice_afr_ncep = fliplr(squeeze(mean(slice_afr_ncep,2,'omitnan')));
diff_clasp_ncep = slice_afr_clasp - slice_afr_ncep;

slice_afr_clasp_jja = fliplr(squeeze(mean(slice_afr_clasp_jja,2,'omitnan')));
slice_afr_ncep_jja = fliplr(squeeze(mean(slice_afr_ncep_jja,2,'omitnan')));
diff_clasp_ncep_jja = slice_afr_clasp_jja - slice_afr_ncep_jja;
% ---- plot -----

ax5=subplot('Position',p5); clear a; a=100.*slice_afr_clasp_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 6, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax5, 'YDir', 'reverse');
ax5.FontSize = 16;
set(ax5,'Xminortick','on')
set(ax5,'TickDir','out');
caxis([0 6]);
colormap(ax5,cmap); freezeColors;
h5=colorbar('Location','eastoutside','Position',pos5,'FontSize',16);
h5.Ticks = [0 2 4 6];
h5.TickLabels = {'0','2','4','6'};
xticks([15.6250 30.6250 45.6250])
xticklabels({'15^{\circ}E','30^{\circ}E','45^{\circ}E'})
%xlabel('Longitude')
ylabel('Pressure (hPa)')
set(get(h5,'Title') ,'String','cm/s');
title({'(c) M_{u} (Tropical Africa; 10S-10N)','(AM4-EDMF-HET-MF)'},'FontSize',14);


ax6=subplot('Position',p6); clear a; a=100.*diff_clasp_ncep_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 5, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.2f", "FaceAlpha",1,'LabelSpacing', 300);
set(ax6, 'YDir', 'reverse');
ax6.FontSize = 16;
set(ax6,'Xminortick','on')
set(ax6,'TickDir','out');
caxis([-0.6 0.6]);
colormap(ax6,bluewhitered(nn)); freezeColors;
h6=colorbar('Location','eastoutside','Position',pos6,'FontSize',16); cbfreeze(h6,cmap);
h6.Ticks = [-0.6 -0.3 0 0.3 0.6];
h6.TickLabels = {'-0.6','-0.3','0','0.3','0.6'};
%xlabel('Longitude')
ylabel('Pressure (hPa)')
xticks([15.6250 30.6250 45.6250])
xticklabels({'15^{\circ}E','30^{\circ}E','45^{\circ}E'})
set(get(h6,'Title') ,'String','cm/s');
title({'(d) M_{u} (Tropical Africa; 10S-10N)','(AM4-EDMF-HET-MF minus AM4-EDMF)'},'FontSize',14);


%  --- vertical slices Amazon-------
clear id1 id2 slice_ama_clasp slice_ama_ncep
id1 = find(lon>=280 & lon<=320); %--- Amazonia longitude span---
id2 = find(lat>-10 & lat<10); %--- Amazonia latitude span---

slice_ama_clasp = squeeze(mean(mu_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_ama_ncep = squeeze(mean(mu_ncep_lnd(id1,id2,:,:),4,'omitnan'));

slice_ama_clasp_jja = reshape(mu_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_clasp_lnd,3),12,[]);
slice_ama_clasp_jja = mean(mean(slice_ama_clasp_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_ama_ncep_jja = reshape(mu_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_ncep_lnd,3),12,[]);
slice_ama_ncep_jja = mean(mean(slice_ama_ncep_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');

max_h=15;
slice_ama_clasp = slice_ama_clasp(:,:,end-max_h:end);
slice_ama_ncep = slice_ama_ncep(:,:,end-max_h:end);

slice_ama_clasp_jja = slice_ama_clasp_jja(:,:,end-max_h:end);
slice_ama_ncep_jja = slice_ama_ncep_jja(:,:,end-max_h:end);

slice_ama_clasp = fliplr(squeeze(mean(slice_ama_clasp,2,'omitnan')));
slice_ama_ncep = fliplr(squeeze(mean(slice_ama_ncep,2,'omitnan')));
diff_clasp_ncep = slice_ama_clasp - slice_ama_ncep;

slice_ama_clasp_jja = fliplr(squeeze(mean(slice_ama_clasp_jja,2,'omitnan')));
slice_ama_ncep_jja = fliplr(squeeze(mean(slice_ama_ncep_jja,2,'omitnan')));
diff_clasp_ncep_jja = slice_ama_clasp_jja - slice_ama_ncep_jja;
% ---- plot -----

ax7=subplot('Position',p7); clear a; a=100.*slice_ama_clasp_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 6, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax7, 'YDir', 'reverse');
ax7.FontSize = 16;
set(ax7,'Xminortick','on')
set(ax7,'TickDir','out');
caxis([0 4]);
colormap(ax7,cmap); freezeColors;
h7=colorbar('Location','eastoutside','Position',pos7,'FontSize',16);
h7.Ticks = [0 1 2 3 4];
h7.TickLabels = {'0','1','2','3','4'};
%xlabel('Longitude')
ylabel('Pressure (hPa)')
xticks([281.8750 300.6250 319.3750])
xticklabels({'80^{\circ}W','60^{\circ}W','40^{\circ}W'})
set(get(h7,'Title') ,'String','cm/s');
title({'(e) M_{u} (Amazon; 10S-10N)','(AM4-EDMF-HET-MF)'},'FontSize',14);


ax8=subplot('Position',p8); clear a; a=100.*diff_clasp_ncep_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 6, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.2f", "FaceAlpha",1,'LabelSpacing', 300);
set(ax8, 'YDir', 'reverse');
ax8.FontSize = 16;
set(ax8,'Xminortick','on')
set(ax8,'TickDir','out');
caxis([-0.4 +0.4]);
colormap(ax8,bluewhitered(nn)); freezeColors;
h8=colorbar('Location','eastoutside','Position',pos8,'FontSize',16); cbfreeze(h8,cmap);
h8.Ticks = [-0.4 -0.2 0 0.2 0.4];
h8.TickLabels = {'-0.4','-0.2','0','0.2','0.4'};
%xlabel('Longitude')
%ylabel('Pressure (hPa)')
xticks([281.8750 300.6250 319.3750])
xticklabels({'80^{\circ}W','60^{\circ}W','40^{\circ}W'})
set(get(h8,'Title') ,'String','cm/s');
title({'(f) M_{u} (Amazon; 10S-10N)','(AM4-EDMF-HET-MF minus AM4-EDMF)'},'FontSize',14);


%  --- vertical slices East Asia-------
clear id1 id2 slice_esia_clasp slice_esia_ncep
id1 = find(lon>=75 & lon<=116); %--- East asia longitude span---
id2 = find(lat>20 & lat<40); %--- East asia latitude span---

slice_esia_clasp = squeeze(mean(mu_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_esia_ncep = squeeze(mean(mu_ncep_lnd(id1,id2,:,:),4,'omitnan'));

slice_esia_clasp_jja = reshape(mu_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_clasp_lnd,3),12,[]);
slice_esia_clasp_jja = mean(mean(slice_esia_clasp_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_esia_ncep_jja = reshape(mu_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_ncep_lnd,3),12,[]);
slice_esia_ncep_jja = mean(mean(slice_esia_ncep_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');

max_h=15;
slice_esia_clasp = slice_esia_clasp(:,:,end-max_h:end);
slice_esia_ncep = slice_esia_ncep(:,:,end-max_h:end);

slice_esia_clasp_jja = slice_esia_clasp_jja(:,:,end-max_h:end);
slice_esia_ncep_jja = slice_esia_ncep_jja(:,:,end-max_h:end);

slice_esia_clasp = fliplr(squeeze(mean(slice_esia_clasp,2,'omitnan')));
slice_esia_ncep = fliplr(squeeze(mean(slice_esia_ncep,2,'omitnan')));
diff_clasp_ncep = slice_esia_clasp - slice_esia_ncep;

slice_esia_clasp_jja = fliplr(squeeze(mean(slice_esia_clasp_jja,2,'omitnan')));
slice_esia_ncep_jja = fliplr(squeeze(mean(slice_esia_ncep_jja,2,'omitnan')));
diff_clasp_ncep_jja = slice_esia_clasp_jja - slice_esia_ncep_jja;
% ---- plot -----

ax9=subplot('Position',p9); clear a; a=100.*slice_esia_clasp_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 6, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax9, 'YDir', 'reverse');
ax9.FontSize = 16;
set(ax9,'Xminortick','on')
set(ax9,'TickDir','out');
caxis([0 4]);
colormap(ax9,cmap); freezeColors;
h9=colorbar('Location','eastoutside','Position',pos9,'FontSize',16);
h9.Ticks = [0 1 2 3 4];
h9.TickLabels = {'0','1','2','3','4'};
%xlim([75 115])
xticks([75.6250 95.6250 115.6250])
xticklabels({'75^{\circ}E','95^{\circ}E','115^{\circ}E'})
xlabel('Longitude')
ylabel('Pressure (hPa)')
set(get(h9,'Title') ,'String','cm/s');
title({'(g) M_{u} (East Asia; 20N-40N)','(AM4-EDMF-HET-MF)'},'FontSize',14);


ax10=subplot('Position',p10); clear a; a=100.*diff_clasp_ncep_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 5, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.2f", "FaceAlpha",1,'LabelSpacing', 300);
set(ax10, 'YDir', 'reverse');
ax10.FontSize = 16;
set(ax10,'Xminortick','on')
set(ax10,'TickDir','out');
caxis([-0.4 +0.4]);
colormap(ax10,bluewhitered(nn)); freezeColors;
h10=colorbar('Location','eastoutside','Position',pos10,'FontSize',16); cbfreeze(h8,cmap);
h10.Ticks = [-0.4 -0.2 0 0.2 0.4];
h10.TickLabels = {'-0.4','-0.2','0','0.2','0.4'};
xlabel('Longitude')
%ylabel('Pressure (hPa)')
xticks([75.6250 95.6250 115.6250])
xticklabels({'75^{\circ}E','95^{\circ}E','115^{\circ}E'})
set(get(h10,'Title') ,'String','cm/s');
title({'(h) M_{u} (East Asia; 20N-40N)','(AM4-EDMF-HET-MF minus AM4-EDMF)'},'FontSize',14);

%-----
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'massflux_prof_jja_nolm_12302024.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%-------

