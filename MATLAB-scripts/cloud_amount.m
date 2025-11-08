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



per='%';
% ---- read variables -----
tdtvdif_ncep = 100.*squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/cld_amt_lev.nc','cld_amt'));

tdtvdif_clasp = 100.*squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/cld_amt_lev.nc','cld_amt'));

pfull_ncep = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/cld_amt_lev.nc','pfull'));

pfull_clasp = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/cld_amt_lev.nc','pfull'));




%------- cloud amt vertical profiles zonal means (land only)-----

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


max_h=25;

%  --- vertical slices US-------
clear id1 id2 slice_us_clasp slice_us_ncep
id1 = find(lon>=240 & lon<=280); %--- US longitude span---
id2 = find(lat>25 & lat<50); %--- US latitude span---

xx=repmat(land_frac,1,1,33,420);
tdtvdif_clasp_lnd = 1.*tdtvdif_clasp; tdtvdif_clasp_lnd(xx<0.4)=NaN;
tdtvdif_ncep_lnd = 1.*tdtvdif_ncep; tdtvdif_ncep_lnd(xx<0.4)=NaN;

slice_us_clasp = squeeze(mean(tdtvdif_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_us_ncep = squeeze(mean(tdtvdif_ncep_lnd(id1,id2,:,:),4,'omitnan'));

slice_us_clasp_jja = reshape(tdtvdif_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(tdtvdif_clasp_lnd,3),12,[]);
slice_us_clasp_jja = mean(mean(slice_us_clasp_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_us_ncep_jja = reshape(tdtvdif_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(tdtvdif_ncep_lnd,3),12,[]);
slice_us_ncep_jja = mean(mean(slice_us_ncep_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');


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

pms=[ 20, 200, 2200, 800]*1.; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
p3=  [0.04,          0.67,          0.165, 0.24];
p4=  [0.28,          0.67,          0.165, 0.24];
p5=  [0.55,          0.67,          0.165, 0.24];
p6=  [0.787,         0.67,          0.165, 0.24];
p7=  [0.04,          0.13,          0.165, 0.24];
p8=  [0.28,          0.13,          0.165, 0.24];
p9=  [0.55,          0.13,          0.165, 0.24];
p10= [0.787,         0.13,          0.165, 0.24];

pos3= [0.215   0.67  0.012 0.22 ];%[left bottom width height];
pos4= [0.455   0.67  0.012 0.22 ];%[left bottom width height];
pos5= [0.725   0.67  0.012 0.22 ];%[left bottom width height];
pos6= [0.960   0.67  0.012 0.22 ];%[left bottom width height];
pos7= [0.215   0.13  0.012 0.22 ];%[left bottom width height];
pos8= [0.455   0.13  0.012 0.22 ];%[left bottom width height];
pos9= [0.725   0.13  0.012 0.22 ];%[left bottom width height];
pos10=[0.960   0.13  0.012 0.22 ];%[left bottom width height];

nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);

ax3=subplot('Position',p3); clear a; a=slice_us_clasp_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 5, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.0f", "FaceAlpha",1);
set(ax3, 'YDir', 'reverse');
ax3.FontSize = 16;
set(ax3,'Xminortick','on')
set(ax3,'TickDir','out');
caxis([0 20]);
colormap(ax3,cmap); freezeColors;
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [0 5 10 15 20];
h3.TickLabels = {'0','5','10','15','20'};
xticks([241.8750 260.6250 279.3750])
xticklabels({'120^{\circ}W','100^{\circ}W','80^{\circ}W'})
xlabel('Longitude')
ylabel('Pressure (hPa)')
set(get(h3,'Title') ,'String',sprintf('%s',per));
title({'(a) Cloud amount (CONUS; 25N-50N)','(AM4-EDMF-HET)'},'FontSize',14);


ax4=subplot('Position',p4); clear a; a=diff_clasp_ncep_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 4, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax4, 'YDir', 'reverse');
ax4.FontSize = 16;
set(ax4,'Xminortick','on')
set(ax4,'TickDir','out');
caxis([-2 2]);
colormap(ax4,bluewhitered(nn)); freezeColors;
h4=colorbar('Location','eastoutside','Position',pos4,'FontSize',16); cbfreeze(h4,cmap);
h4.Ticks = [-2 -1 0 1 2];
h4.TickLabels = {'-2','-1','0','1','2'};
xlabel('Longitude')
%ylabel('Pressure (hPa)')
xticks([241.8750 260.6250 279.3750])
xticklabels({'120^{\circ}W','100^{\circ}W','80^{\circ}W'})
set(get(h4,'Title') ,'String',sprintf('%s',per));
title({'(b) Cloud amount (CONUS; 25N-50N)','(AM4-EDMF-HET minus AM4-EDMF)'},'FontSize',14);



%  --- vertical slices Central Africa-------
clear id1 id2 slice_afr_clasp slice_afr_ncep diff_clasp_ncep diff_clasp_ncep_jja
id1 = find(lon>=9 & lon<=47); %--- Central Africa longitude span---
id2 = find(lat>-10 & lat<10); %--- Central Africa latitude span---

xx=repmat(land_frac,1,1,33,420);
tdtvdif_clasp_lnd = 1.*tdtvdif_clasp; tdtvdif_clasp_lnd(xx<0.4)=NaN;
tdtvdif_ncep_lnd = 1.*tdtvdif_ncep; tdtvdif_ncep_lnd(xx<0.4)=NaN;

slice_afr_clasp = squeeze(mean(tdtvdif_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_afr_ncep = squeeze(mean(tdtvdif_ncep_lnd(id1,id2,:,:),4,'omitnan'));

slice_afr_clasp_jja = reshape(tdtvdif_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(tdtvdif_clasp_lnd,3),12,[]);
slice_afr_clasp_jja = mean(mean(slice_afr_clasp_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_afr_ncep_jja = reshape(tdtvdif_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(tdtvdif_ncep_lnd,3),12,[]);
slice_afr_ncep_jja = mean(mean(slice_afr_ncep_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');


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

ax5=subplot('Position',p5); clear a; a=slice_afr_clasp_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 5, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.0f", "FaceAlpha",1);
set(ax5, 'YDir', 'reverse');
ax5.FontSize = 16;
set(ax5,'Xminortick','on')
set(ax5,'TickDir','out');
caxis([0 25]);
colormap(ax5,cmap); freezeColors;
h5=colorbar('Location','eastoutside','Position',pos5,'FontSize',16);
h5.Ticks = [0 5 10 15 20 25];
h5.TickLabels = {'0','5','10','15','20','25'};
xticks([15.6250 30.6250 45.6250])
xticklabels({'15^{\circ}E','30^{\circ}E','45^{\circ}E'})
xlabel('Longitude')
ylabel('Pressure (hPa)')
set(get(h5,'Title') ,'String',sprintf('%s',per));
title({'(c) Cloud amount (Tropical Africa; 10S-10N)','(AM4-EDMF-HET)'},'FontSize',14);


ax6=subplot('Position',p6); clear a; a=diff_clasp_ncep_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 4, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax6, 'YDir', 'reverse');
ax6.FontSize = 16;
set(ax6,'Xminortick','on')
set(ax6,'TickDir','out');
caxis([-2 2]);
colormap(ax6,bluewhitered(nn)); freezeColors;
h6=colorbar('Location','eastoutside','Position',pos6,'FontSize',16); cbfreeze(h6,cmap);
h6.Ticks = [-2 -1 0 1 2];
h6.TickLabels = {'-2','-1','0','1','2'};
xlabel('Longitude')
%ylabel('Pressure (hPa)')
xticks([15.6250 30.6250 45.6250])
xticklabels({'15^{\circ}E','30^{\circ}E','45^{\circ}E'})
set(get(h6,'Title') ,'String',sprintf('%s',per));
title({'(d) Cloud amount (Tropical Africa; 10S-10N)','(AM4-EDMF-HET minus AM4-EDMF)'},'FontSize',14);


%  --- vertical slices Amazon-------
clear id1 id2 slice_ama_clasp slice_ama_ncep
id1 = find(lon>=280 & lon<=320); %--- Amazonia longitude span---
id2 = find(lat>-10 & lat<10); %--- Amazonia latitude span---

xx=repmat(land_frac,1,1,33,420);
tdtvdif_clasp_lnd = 1.*tdtvdif_clasp; tdtvdif_clasp_lnd(xx<0.4)=NaN;
tdtvdif_ncep_lnd = 1.*tdtvdif_ncep; tdtvdif_ncep_lnd(xx<0.4)=NaN;

slice_ama_clasp = squeeze(mean(tdtvdif_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_ama_ncep = squeeze(mean(tdtvdif_ncep_lnd(id1,id2,:,:),4,'omitnan'));

slice_ama_clasp_jja = reshape(tdtvdif_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(tdtvdif_clasp_lnd,3),12,[]);
slice_ama_clasp_jja = mean(mean(slice_ama_clasp_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_ama_ncep_jja = reshape(tdtvdif_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(tdtvdif_ncep_lnd,3),12,[]);
slice_ama_ncep_jja = mean(mean(slice_ama_ncep_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');


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

ax7=subplot('Position',p7); clear a; a=slice_ama_clasp_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 5, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.0f", "FaceAlpha",1);
set(ax7, 'YDir', 'reverse');
ax7.FontSize = 16;
set(ax7,'Xminortick','on')
set(ax7,'TickDir','out');
caxis([0 20]);
colormap(ax7,cmap); freezeColors;
h7=colorbar('Location','eastoutside','Position',pos7,'FontSize',16);
h7.Ticks = [0 5 10 15 20];
h7.TickLabels = {'0','5','10','15','20'};
xlabel('Longitude')
ylabel('Pressure (hPa)')
xticks([281.8750 300.6250 319.3750])
xticklabels({'80^{\circ}W','60^{\circ}W','40^{\circ}W'})
set(get(h7,'Title') ,'String',sprintf('%s',per));
title({'(e) Cloud amount (Amazon; 10S-10N)','(AM4-EDMF-HET)'},'FontSize',14);


ax8=subplot('Position',p8); clear a; a=diff_clasp_ncep_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 4, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax8, 'YDir', 'reverse');
ax8.FontSize = 16;
set(ax8,'Xminortick','on')
set(ax8,'TickDir','out');
caxis([-2 2]);
colormap(ax8,bluewhitered(nn)); freezeColors;
h8=colorbar('Location','eastoutside','Position',pos8,'FontSize',16); cbfreeze(h8,cmap);
h8.Ticks = [-2 -1 0 1 2];
h8.TickLabels = {'-2','-1','0','1','2'};
xlabel('Longitude')
%ylabel('Pressure (hPa)')
xticks([281.8750 300.6250 319.3750])
xticklabels({'80^{\circ}W','60^{\circ}W','40^{\circ}W'})
set(get(h8,'Title') ,'String',sprintf('%s',per));
title({'(f) Cloud amount (Amazon; 10S-10N)','(AM4-EDMF-HET minus AM4-EDMF)'},'FontSize',14);


%  --- vertical slices East Asia-------
clear id1 id2 slice_esia_clasp slice_esia_ncep
id1 = find(lon>=75 & lon<=116); %--- East asia longitude span---
id2 = find(lat>20 & lat<40); %--- East asia latitude span---

xx=repmat(land_frac,1,1,33,420);
tdtvdif_clasp_lnd = 1.*tdtvdif_clasp; tdtvdif_clasp_lnd(xx<0.4)=NaN;
tdtvdif_ncep_lnd = 1.*tdtvdif_ncep; tdtvdif_ncep_lnd(xx<0.4)=NaN;

slice_esia_clasp = squeeze(mean(tdtvdif_clasp_lnd(id1,id2,:,:),4,'omitnan'));
slice_esia_ncep = squeeze(mean(tdtvdif_ncep_lnd(id1,id2,:,:),4,'omitnan'));

slice_esia_clasp_jja = reshape(tdtvdif_clasp_lnd(id1,id2,:,:),length(id1),length(id2),size(tdtvdif_clasp_lnd,3),12,[]);
slice_esia_clasp_jja = mean(mean(slice_esia_clasp_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');
slice_esia_ncep_jja = reshape(tdtvdif_ncep_lnd(id1,id2,:,:),length(id1),length(id2),size(tdtvdif_ncep_lnd,3),12,[]);
slice_esia_ncep_jja = mean(mean(slice_esia_ncep_jja(:,:,:,6:8,:),4,'omitnan'),5,'omitnan');


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

ax9=subplot('Position',p9); clear a; a=slice_esia_clasp_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 6, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.0f", "FaceAlpha",1);
set(ax9, 'YDir', 'reverse');
ax9.FontSize = 16;
set(ax9,'Xminortick','on')
set(ax9,'TickDir','out');
caxis([0 25]);
colormap(ax9,cmap); freezeColors;
h9=colorbar('Location','eastoutside','Position',pos9,'FontSize',16);
h9.Ticks = [0 5 10 15 20 25];
h9.TickLabels = {'0','5','10','15','20','25'};
%xlim([75 115])
xticks([75.6250 95.6250 115.6250])
xticklabels({'75^{\circ}E','95^{\circ}E','115^{\circ}E'})
xlabel('Longitude')
ylabel('Pressure (hPa)')
set(get(h9,'Title') ,'String',sprintf('%s',per));
title({'(g) Cloud amount (East Asia; 20N-40N)','(AM4-EDMF-HET)'},'FontSize',14);


ax10=subplot('Position',p10); clear a; a=diff_clasp_ncep_jja;
contourf(lon(id1),flipud(pfull_clasp(end-max_h:end)),a', 6, 'LineStyle', '-',...
"ShowText",true,"LabelFormat","%0.1f", "FaceAlpha",1);
set(ax10, 'YDir', 'reverse');
ax10.FontSize = 16;
set(ax10,'Xminortick','on')
set(ax10,'TickDir','out');
caxis([-2 2]);
colormap(ax10,bluewhitered(nn)); freezeColors;
h10=colorbar('Location','eastoutside','Position',pos10,'FontSize',16); cbfreeze(h8,cmap);
h10.Ticks = [-2 -1 0 1 2];
h10.TickLabels = {'-2','-1','0','1','2'};
xlabel('Longitude')
%ylabel('Pressure (hPa)')
xticks([75.6250 95.6250 115.6250])
xticklabels({'75^{\circ}E','95^{\circ}E','115^{\circ}E'})
set(get(h10,'Title') ,'String',sprintf('%s',per));
title({'(h) Cloud amount (East Asia; 20N-40N)','(AM4-EDMF-HET minus AM4-EDMF)'},'FontSize',14);

%-----
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'cloudamount_jja_landonly.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%-------



