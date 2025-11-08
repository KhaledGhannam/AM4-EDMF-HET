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

f_orig = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/temp_lev.nc';

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


% ---- read temperature levels -----

% --- NCEP ------
temp_am4 = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/temp_lev.nc','temp');
temp_ncep = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/temp_lev.nc','temp');
temp_clasp = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/temp_lev.nc','temp');

pfull_ncep =ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/temp_lev.nc','pfull');
pfull_clasp =ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/temp_lev.nc','pfull');


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

%----- Comparison between edmf-het and edmf ---
%------- Temp vertical profiles zonal means (land only)-----



%  --- vertical slices US-------
clear id1 id2 slice_us_clasp slice_us_ncep
id1 = find(lon>=240 & lon<=280); %--- US longitude span---
id2 = find(lat>25 & lat<50); %--- US latitude span---

xx=repmat(land_frac,1,1,33,420);
mu_clasp_lnd = temp_clasp; mu_clasp_lnd(xx<0.4)=NaN;
mu_ncep_lnd = temp_ncep; mu_ncep_lnd(xx<0.4)=NaN;
mu_am4_lnd = temp_am4; mu_am4_lnd(xx<0.4)=NaN;

slice_us_clasp = squeeze(mean(mu_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_us_ncep = squeeze(mean(mu_ncep_lnd(id1,id2,:,:),4,'omitnan'));
slice_us_am4 = squeeze(mean(mu_am4_lnd(id1,id2,:,:),4,'omitnan'));

slice_us_clasp_ann = reshape(mu_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_clasp_lnd,3),12,[]);
slice_us_clasp_jja = mean(mean(slice_us_clasp_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_us_clasp_djf = mean(mean(slice_us_clasp_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');

slice_us_ncep_ann = reshape(mu_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_ncep_lnd,3),12,[]);
slice_us_ncep_jja = mean(mean(slice_us_ncep_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_us_ncep_djf = mean(mean(slice_us_ncep_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');

slice_us_am4_ann = reshape(mu_am4_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_am4_lnd,3),12,[]);
slice_us_am4_jja = mean(mean(slice_us_am4_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_us_am4_djf = mean(mean(slice_us_am4_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');

max_h=15;
slice_us_clasp = slice_us_clasp(:,:,end-max_h:end);
slice_us_ncep = slice_us_ncep(:,:,end-max_h:end);
slice_us_am4 = slice_us_am4(:,:,end-max_h:end);

slice_us_clasp = fliplr(squeeze(mean(slice_us_clasp,2,'omitnan')));
slice_us_ncep = fliplr(squeeze(mean(slice_us_ncep,2,'omitnan')));
slice_us_am4 = fliplr(squeeze(mean(slice_us_am4,2,'omitnan')));
diff_clasp_ncep = slice_us_clasp - slice_us_ncep;
diff_clasp_am4 = slice_us_clasp - slice_us_am4;

slice_us_clasp_jja = slice_us_clasp_jja(:,:,end-max_h:end);
slice_us_ncep_jja = slice_us_ncep_jja(:,:,end-max_h:end);
slice_us_am4_jja = slice_us_am4_jja(:,:,end-max_h:end);

slice_us_clasp_jja = fliplr(squeeze(mean(slice_us_clasp_jja,2,'omitnan')));
slice_us_ncep_jja = fliplr(squeeze(mean(slice_us_ncep_jja,2,'omitnan')));
slice_us_am4_jja = fliplr(squeeze(mean(slice_us_am4_jja,2,'omitnan')));
diff_clasp_ncep_jja = slice_us_clasp_jja - slice_us_ncep_jja;
diff_clasp_am4_jja = slice_us_clasp_jja - slice_us_am4_jja;

slice_us_clasp_djf = slice_us_clasp_djf(:,:,end-max_h:end);
slice_us_ncep_djf = slice_us_ncep_djf(:,:,end-max_h:end);
slice_us_am4_djf = slice_us_am4_djf(:,:,end-max_h:end);

slice_us_clasp_djf = fliplr(squeeze(mean(slice_us_clasp_djf,2,'omitnan')));
slice_us_ncep_djf = fliplr(squeeze(mean(slice_us_ncep_djf,2,'omitnan')));
slice_us_am4_djf = fliplr(squeeze(mean(slice_us_am4_djf,2,'omitnan')));
diff_clasp_ncep_djf = slice_us_clasp_djf - slice_us_ncep_djf;
diff_clasp_am4_djf = slice_us_clasp_djf - slice_us_am4_djf;

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

nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);

ax3=subplot('Position',p3); clear a; a=slice_us_clasp_djf - slice_us_ncep_djf;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 10, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax3, 'YDir', 'reverse');
ax3.FontSize = 16;
set(ax3,'Xminortick','on')
set(ax3,'TickDir','out');
caxis([-1 1]);
colormap(ax3,bluewhitered(30)); freezeColors;
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-1 -0.5 0 0.5 1];
h3.TickLabels = {'-1','-0.5','0','0.5','1'};
xticks([241.8750 260.6250 279.3750])
xticklabels({'120^{\circ}W','100^{\circ}W','80^{\circ}W'})
%xlabel('Longitude')
ylabel('Pressure (hPa)')
set(get(h3,'Title') ,'String','^{\circ}C');
title({'(a) T (CONUS; 25N-50N)','(AM4-EDMF-HET minus AM4-EDMF)'},'FontSize',14);


ax4=subplot('Position',p4); clear a; a=slice_us_clasp_djf - slice_us_am4_djf;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 10, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax4, 'YDir', 'reverse');
ax4.FontSize = 16;
set(ax4,'Xminortick','on')
set(ax4,'TickDir','out');
caxis([-1 1]); colormap(ax4,bluewhitered(30)); freezeColors;
h4=colorbar('Location','eastoutside','Position',pos4,'FontSize',16); cbfreeze(h4,cmap);
h4.Ticks = [-1 -0.5 0 0.5 1];
h4.TickLabels = {'-1','-0.5','0','0.5','1'};
%xlabel('Longitude')
ylabel('Pressure (hPa)')
xticks([241.8750 260.6250 279.3750])
xticklabels({'120^{\circ}W','100^{\circ}W','80^{\circ}W'})
set(get(h4,'Title') ,'String','^{\circ}C');
title({'(b) T (CONUS; 25N-50N)','(AM4-EDMF-HET minus AM4-Lock)'},'FontSize',14);



%  --- vertical slices Central Africa-------
clear id1 id2 slice_afr_clasp slice_afr_ncep diff_clasp_ncep diff_clasp_ncep_jja
id1 = find(lon>=9 & lon<=47); %--- Central Africa longitude span---
id2 = find(lat>-10 & lat<10); %--- Central Africa latitude span---

slice_afr_clasp = squeeze(mean(mu_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_afr_ncep = squeeze(mean(mu_ncep_lnd(id1,id2,:,:),4,'omitnan'));
slice_afr_am4 = squeeze(mean(mu_am4_lnd(id1,id2,:,:),4,'omitnan'));

slice_afr_clasp_ann = reshape(mu_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_clasp_lnd,3),12,[]);
slice_afr_clasp_jja = mean(mean(slice_afr_clasp_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_afr_clasp_djf = mean(mean(slice_afr_clasp_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');

slice_afr_ncep_ann = reshape(mu_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_ncep_lnd,3),12,[]);
slice_afr_ncep_jja = mean(mean(slice_afr_ncep_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_afr_ncep_djf = mean(mean(slice_afr_ncep_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');

slice_afr_am4_ann = reshape(mu_am4_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_am4_lnd,3),12,[]);
slice_afr_am4_jja = mean(mean(slice_afr_am4_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_afr_am4_djf = mean(mean(slice_afr_am4_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');


slice_afr_clasp = slice_afr_clasp(:,:,end-max_h:end);
slice_afr_ncep = slice_afr_ncep(:,:,end-max_h:end);
slice_afr_am4 = slice_afr_am4(:,:,end-max_h:end);

slice_afr_clasp = fliplr(squeeze(mean(slice_afr_clasp,2,'omitnan')));
slice_afr_ncep = fliplr(squeeze(mean(slice_afr_ncep,2,'omitnan')));
slice_afr_am4 = fliplr(squeeze(mean(slice_afr_am4,2,'omitnan')));
diff_clasp_ncep = slice_afr_clasp - slice_afr_ncep;
diff_clasp_am4 = slice_afr_clasp - slice_afr_am4;

slice_afr_clasp_jja = slice_afr_clasp_jja(:,:,end-max_h:end);
slice_afr_ncep_jja = slice_afr_ncep_jja(:,:,end-max_h:end);
slice_afr_am4_jja = slice_afr_am4_jja(:,:,end-max_h:end);

slice_afr_clasp_jja = fliplr(squeeze(mean(slice_afr_clasp_jja,2,'omitnan')));
slice_afr_ncep_jja = fliplr(squeeze(mean(slice_afr_ncep_jja,2,'omitnan')));
slice_afr_am4_jja = fliplr(squeeze(mean(slice_afr_am4_jja,2,'omitnan')));
diff_clasp_ncep_jja = slice_afr_clasp_jja - slice_afr_ncep_jja;
diff_clasp_am4_jja = slice_afr_clasp_jja - slice_afr_am4_jja;

slice_afr_clasp_djf = slice_afr_clasp_djf(:,:,end-max_h:end);
slice_afr_ncep_djf = slice_afr_ncep_djf(:,:,end-max_h:end);
slice_afr_am4_djf = slice_afr_am4_djf(:,:,end-max_h:end);

slice_afr_clasp_djf = fliplr(squeeze(mean(slice_afr_clasp_djf,2,'omitnan')));
slice_afr_ncep_djf = fliplr(squeeze(mean(slice_afr_ncep_djf,2,'omitnan')));
slice_afr_am4_djf = fliplr(squeeze(mean(slice_afr_am4_djf,2,'omitnan')));
diff_clasp_ncep_djf = slice_afr_clasp_djf - slice_afr_ncep_djf;
diff_clasp_am4_djf = slice_afr_clasp_djf - slice_afr_am4_djf;
% ---- plot -----

ax5=subplot('Position',p5); clear a; a=slice_afr_clasp_djf - slice_afr_ncep_djf;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 10, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax5, 'YDir', 'reverse');
ax5.FontSize = 16;
set(ax5,'Xminortick','on')
set(ax5,'TickDir','out');
caxis([-1 1]); colormap(ax5,bluewhitered(30)); freezeColors;
h5=colorbar('Location','eastoutside','Position',pos5,'FontSize',16);
h5.Ticks = [-1 -0.5 0 0.5 1];
h5.TickLabels = {'-1','-0.5','0','0.5','1'};
xticks([15.6250 30.6250 45.6250])
xticklabels({'15^{\circ}E','30^{\circ}E','45^{\circ}E'})
%xlabel('Longitude')
ylabel('Pressure (hPa)')
set(get(h5,'Title') ,'String','^{\circ}C');
title({'(c) T (Tropical Africa; 10S-10N)','(AM4-EDMF-HET minus AM4-EDMF)'},'FontSize',14);


ax6=subplot('Position',p6); clear a; a=slice_afr_clasp_djf - slice_afr_am4_djf;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 10, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax6, 'YDir', 'reverse');
ax6.FontSize = 16;
set(ax6,'Xminortick','on')
set(ax6,'TickDir','out');
caxis([-1 1]); colormap(ax6,bluewhitered(30)); freezeColors;
h6=colorbar('Location','eastoutside','Position',pos6,'FontSize',16); cbfreeze(h6,cmap);
h6.Ticks = [-1 -0.5 0 0.5 1];
h6.TickLabels = {'-1','-0.5','0','0.5','1'};
%xlabel('Longitude')
ylabel('Pressure (hPa)')
xticks([15.6250 30.6250 45.6250])
xticklabels({'15^{\circ}E','30^{\circ}E','45^{\circ}E'})
set(get(h6,'Title') ,'String','^{\circ}C');
title({'(d) T (Tropical Africa; 10S-10N)','(AM4-EDMF-HET minus AM4-Lock)'},'FontSize',14);


%  --- vertical slices Amazon-------
clear id1 id2 slice_ama_clasp slice_ama_ncep
id1 = find(lon>=280 & lon<=320); %--- Amazonia longitude span---
id2 = find(lat>-10 & lat<10); %--- Amazonia latitude span---

slice_ama_clasp = squeeze(mean(mu_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_ama_ncep = squeeze(mean(mu_ncep_lnd(id1,id2,:,:),4,'omitnan'));
slice_ama_am4 = squeeze(mean(mu_am4_lnd(id1,id2,:,:),4,'omitnan'));

slice_ama_clasp_ann = reshape(mu_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_clasp_lnd,3),12,[]);
slice_ama_clasp_jja = mean(mean(slice_ama_clasp_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_ama_clasp_djf = mean(mean(slice_ama_clasp_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');

slice_ama_ncep_ann = reshape(mu_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_ncep_lnd,3),12,[]);
slice_ama_ncep_jja = mean(mean(slice_ama_ncep_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_ama_ncep_djf = mean(mean(slice_ama_ncep_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');

slice_ama_am4_ann = reshape(mu_am4_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_am4_lnd,3),12,[]);
slice_ama_am4_jja = mean(mean(slice_ama_am4_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_ama_am4_djf = mean(mean(slice_ama_am4_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');


slice_ama_clasp = slice_ama_clasp(:,:,end-max_h:end);
slice_ama_ncep = slice_ama_ncep(:,:,end-max_h:end);
slice_ama_am4 = slice_ama_am4(:,:,end-max_h:end);

slice_ama_clasp = fliplr(squeeze(mean(slice_ama_clasp,2,'omitnan')));
slice_ama_ncep = fliplr(squeeze(mean(slice_ama_ncep,2,'omitnan')));
slice_ama_am4 = fliplr(squeeze(mean(slice_ama_am4,2,'omitnan')));
diff_clasp_ncep = slice_ama_clasp - slice_ama_ncep;
diff_clasp_am4 = slice_ama_clasp - slice_ama_am4;

slice_ama_clasp_jja = slice_ama_clasp_jja(:,:,end-max_h:end);
slice_ama_ncep_jja = slice_ama_ncep_jja(:,:,end-max_h:end);
slice_ama_am4_jja = slice_ama_am4_jja(:,:,end-max_h:end);

slice_ama_clasp_jja = fliplr(squeeze(mean(slice_ama_clasp_jja,2,'omitnan')));
slice_ama_ncep_jja = fliplr(squeeze(mean(slice_ama_ncep_jja,2,'omitnan')));
slice_ama_am4_jja = fliplr(squeeze(mean(slice_ama_am4_jja,2,'omitnan')));
diff_clasp_ncep_jja = slice_ama_clasp_jja - slice_ama_ncep_jja;
diff_clasp_am4_jja = slice_ama_clasp_jja - slice_ama_am4_jja;

slice_ama_clasp_djf = slice_ama_clasp_djf(:,:,end-max_h:end);
slice_ama_ncep_djf = slice_ama_ncep_djf(:,:,end-max_h:end);
slice_ama_am4_djf = slice_ama_am4_djf(:,:,end-max_h:end);

slice_ama_clasp_djf = fliplr(squeeze(mean(slice_ama_clasp_djf,2,'omitnan')));
slice_ama_ncep_djf = fliplr(squeeze(mean(slice_ama_ncep_djf,2,'omitnan')));
slice_ama_am4_djf = fliplr(squeeze(mean(slice_ama_am4_djf,2,'omitnan')));
diff_clasp_ncep_djf = slice_ama_clasp_djf - slice_ama_ncep_djf;
diff_clasp_am4_djf = slice_ama_clasp_djf - slice_ama_am4_djf;
% ---- plot -----

ax7=subplot('Position',p7); clear a; a=slice_ama_clasp_djf - slice_ama_ncep_djf;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 10, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax7, 'YDir', 'reverse');
ax7.FontSize = 16;
set(ax7,'Xminortick','on')
set(ax7,'TickDir','out');
caxis([-1 1]); colormap(ax7,bluewhitered(30)); freezeColors;
h7=colorbar('Location','eastoutside','Position',pos7,'FontSize',16);
h7.Ticks = [-1 -0.5 0 0.5 1];
h7.TickLabels = {'-1','-0.5','0','0.5','1'};
%xlabel('Longitude')
ylabel('Pressure (hPa)')
xticks([281.8750 300.6250 319.3750])
xticklabels({'80^{\circ}W','60^{\circ}W','40^{\circ}W'})
set(get(h7,'Title') ,'String','^{\circ}C');
title({'(e) T (Amazon; 10S-10N)','(AM4-EDMF-HET minus AM4-EDMF)'},'FontSize',14);


ax8=subplot('Position',p8); clear a; a=slice_ama_clasp_djf - slice_ama_am4_djf;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 10, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax8, 'YDir', 'reverse');
ax8.FontSize = 16;
set(ax8,'Xminortick','on')
set(ax8,'TickDir','out');
caxis([-1 1]); colormap(ax8,bluewhitered(30)); freezeColors;
h8=colorbar('Location','eastoutside','Position',pos8,'FontSize',16); cbfreeze(h8,cmap);
h8.Ticks = [-1 -0.5 0 0.5 1];
h8.TickLabels = {'-1','-0.5','0','0.5','1'};
%xlabel('Longitude')
ylabel('Pressure (hPa)')
xticks([281.8750 300.6250 319.3750])
xticklabels({'80^{\circ}W','60^{\circ}W','40^{\circ}W'})
set(get(h8,'Title') ,'String','^{\circ}C');
title({'(f) T (Amazon; 10S-10N)','(AM4-EDMF-HET minus AM4-Lock)'},'FontSize',14);


%  --- vertical slices East Asia-------
clear id1 id2 slice_esia_clasp slice_esia_ncep
id1 = find(lon>=75 & lon<=116); %--- East asia longitude span---
id2 = find(lat>20 & lat<40); %--- East asia latitude span---

slice_esia_clasp = squeeze(mean(mu_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_esia_ncep = squeeze(mean(mu_ncep_lnd(id1,id2,:,:),4,'omitnan'));
slice_esia_am4 = squeeze(mean(mu_am4_lnd(id1,id2,:,:),4,'omitnan'));

slice_esia_clasp_ann = reshape(mu_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_clasp_lnd,3),12,[]);
slice_esia_clasp_jja = mean(mean(slice_esia_clasp_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_esia_clasp_djf = mean(mean(slice_esia_clasp_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');

slice_esia_ncep_ann = reshape(mu_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_ncep_lnd,3),12,[]);
slice_esia_ncep_jja = mean(mean(slice_esia_ncep_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_esia_ncep_djf = mean(mean(slice_esia_ncep_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');

slice_esia_am4_ann = reshape(mu_am4_lnd(id1,id2,:,:),length(id1),length(id2),size(mu_am4_lnd,3),12,[]);
slice_esia_am4_jja = mean(mean(slice_esia_am4_ann(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_esia_am4_djf = mean(mean(slice_esia_am4_ann(:,:,:,1:2,:),4,'omitnan'),5,'omitnan');


slice_esia_clasp = slice_esia_clasp(:,:,end-max_h:end);
slice_esia_ncep = slice_esia_ncep(:,:,end-max_h:end);
slice_esia_am4 = slice_esia_am4(:,:,end-max_h:end);

slice_esia_clasp = fliplr(squeeze(mean(slice_esia_clasp,2,'omitnan')));
slice_esia_ncep = fliplr(squeeze(mean(slice_esia_ncep,2,'omitnan')));
slice_esia_am4 = fliplr(squeeze(mean(slice_esia_am4,2,'omitnan')));
diff_clasp_ncep = slice_esia_clasp - slice_esia_ncep;
diff_clasp_am4 = slice_esia_clasp - slice_esia_am4;

slice_esia_clasp_jja = slice_esia_clasp_jja(:,:,end-max_h:end);
slice_esia_ncep_jja = slice_esia_ncep_jja(:,:,end-max_h:end);
slice_esia_am4_jja = slice_esia_am4_jja(:,:,end-max_h:end);

slice_esia_clasp_jja = fliplr(squeeze(mean(slice_esia_clasp_jja,2,'omitnan')));
slice_esia_ncep_jja = fliplr(squeeze(mean(slice_esia_ncep_jja,2,'omitnan')));
slice_esia_am4_jja = fliplr(squeeze(mean(slice_esia_am4_jja,2,'omitnan')));
diff_clasp_ncep_jja = slice_esia_clasp_jja - slice_esia_ncep_jja;
diff_clasp_am4_jja = slice_esia_clasp_jja - slice_esia_am4_jja;

slice_esia_clasp_djf = slice_esia_clasp_djf(:,:,end-max_h:end);
slice_esia_ncep_djf = slice_esia_ncep_djf(:,:,end-max_h:end);
slice_esia_am4_djf = slice_esia_am4_djf(:,:,end-max_h:end);

slice_esia_clasp_djf = fliplr(squeeze(mean(slice_esia_clasp_djf,2,'omitnan')));
slice_esia_ncep_djf = fliplr(squeeze(mean(slice_esia_ncep_djf,2,'omitnan')));
slice_esia_am4_djf = fliplr(squeeze(mean(slice_esia_am4_djf,2,'omitnan')));
diff_clasp_ncep_djf = slice_esia_clasp_djf - slice_esia_ncep_djf;
diff_clasp_am4_djf = slice_esia_clasp_djf - slice_esia_am4_djf;
% ---- plot -----

ax9=subplot('Position',p9); clear a; a=slice_esia_clasp_djf - slice_esia_ncep_djf;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 10, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax9, 'YDir', 'reverse');
ax9.FontSize = 16;
set(ax9,'Xminortick','on')
set(ax9,'TickDir','out');
caxis([-1 1]); colormap(ax9,bluewhitered(30)); freezeColors;
h9=colorbar('Location','eastoutside','Position',pos9,'FontSize',16);
h9.Ticks = [-1 -0.5 0 0.5 1];
h9.TickLabels = {'-1','-0.5','0','0.5','1'};
%xlim([75 115])
xticks([75.6250 95.6250 115.6250])
xticklabels({'75^{\circ}E','95^{\circ}E','115^{\circ}E'})
xlabel('Longitude')
ylabel('Pressure (hPa)')
set(get(h9,'Title') ,'String','^{\circ}C');
title({'(g) T (East Asia; 20N-40N)','(AM4-EDMF-HET minus AM4-EDMF)'},'FontSize',14);


ax10=subplot('Position',p10); clear a; a=slice_esia_clasp_djf - slice_esia_am4_djf;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 10, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax10, 'YDir', 'reverse');
ax10.FontSize = 16;
set(ax10,'Xminortick','on')
set(ax10,'TickDir','out');
caxis([-1 1]); colormap(ax10,bluewhitered(30)); freezeColors;
h10=colorbar('Location','eastoutside','Position',pos10,'FontSize',16); cbfreeze(h8,cmap);
h10.Ticks = [-1 -0.5 0 0.5 1];
h10.TickLabels = {'-1','-0.5','0','0.5','1'};
xlabel('Longitude')
ylabel('Pressure (hPa)')
xticks([75.6250 95.6250 115.6250])
xticklabels({'75^{\circ}E','95^{\circ}E','115^{\circ}E'})
set(get(h10,'Title') ,'String','^{\circ}C');
title({'(h) T (East Asia; 20N-40N)','(AM4-EDMF-HET minus AM4-Lock)'},'FontSize',14);

%-----
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'temp_profiles_djf.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%-------



