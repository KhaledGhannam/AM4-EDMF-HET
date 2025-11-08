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


f_orig = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/swdn_toa.nc';

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



% ------ shortwave down all ----
am4_orig.swdn_toa = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/swdn_toa.nc',...
    'swdn_toa'),3));

am4_ncep.swdn_toa = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/swdn_toa.nc',...
    'swdn_toa'),3));


am4_clasp.swdn_toa = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/swdn_toa.nc',...
    'swdn_toa'),3));

am4_orig.swdn_toa_clr = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/swdn_toa_clr.nc',...
    'swdn_toa_clr'),3));

am4_ncep.swdn_toa_clr = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/swdn_toa_clr.nc',...
    'swdn_toa_clr'),3));


am4_clasp.swdn_toa_clr = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/swdn_toa_clr.nc',...
    'swdn_toa_clr'),3));

%--------------------------

% ---- shortwave up all ------

am4_orig.swup_toa = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/swup_toa.nc',...
    'swup_toa'),3));

am4_ncep.swup_toa = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/swup_toa.nc',...
    'swup_toa'),3));


am4_clasp.swup_toa = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/swup_toa.nc',...
    'swup_toa'),3));

am4_orig.swup_toa_clr = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/swup_toa_clr.nc',...
    'swup_toa_clr'),3));

am4_ncep.swup_toa_clr = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/swup_toa_clr.nc',...
    'swup_toa_clr'),3));


am4_clasp.swup_toa_clr = squeeze(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/swup_toa_clr.nc',...
    'swup_toa_clr'),3));

%-----------------------------------


%----------------------------------
am4_orig.swcre_toa = (am4_orig.swdn_toa - am4_orig.swup_toa) - (am4_orig.swdn_toa_clr - am4_orig.swup_toa_clr);
am4_ncep.swcre_toa = (am4_ncep.swdn_toa - am4_ncep.swup_toa) - (am4_ncep.swdn_toa_clr - am4_ncep.swup_toa_clr);
am4_clasp.swcre_toa = (am4_clasp.swdn_toa - am4_clasp.swup_toa) - (am4_clasp.swdn_toa_clr - am4_clasp.swup_toa_clr);

load('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab/all_data.mat','ceres_inp');
%% Set do_print

fpath='./'; expn='am4';
do_print = 0;    % set do_print = 1 to output as PNG files.

%% Fig 6: Compare Precipitation
k=1; varn='SWCRE_toa';
z1 = ceres_inp.swcre_toa';
z2 = am4_orig.swcre_toa';
z3 = am4_ncep.swcre_toa';
z4 = am4_clasp.swcre_toa';


s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;


aa=s.aa;
sea='ANN';


z2z1 = z2 - z1;
z3z1 = z3 - z1;
z4z1 = z4 - z1;
z4z2 = z4 - z2;
z4z3 = z4 - z3;


a=s.aa;
id=~isnan(z2z1) & ~isnan(z3z1); a(id)=a(id)/mean(a(id)); a=a(id);

e=z2z1(id); s.rmse21=sqrt(mean(e.*e.*a)); s.bias21=mean(mean(e.*a));
e=z3z1(id); s.rmse31=sqrt(mean(e.*e.*a)); s.bias31=mean(mean(e.*a));
e=z4z1(id); s.rmse41=sqrt(mean(e.*e.*a)); s.bias41=mean(mean(e.*a));
e=z4z2(id); s.rmse42=sqrt(mean(e.*e.*a)); s.bias42=mean(mean(e.*a));
e=z4z3(id); s.rmse43=sqrt(mean(e.*e.*a)); s.bias43=mean(mean(e.*a));

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;

domap='robinson';

a=s.aa; id=~isnan(z1); a(id)=a(id)/mean(a(id)); a=a(id);
e=z1(id); s.mean1=mean(e.*a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pms=[ 100, 100, 1200, 1000]*1.; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=-0.01; y0=0.65; wx=0.46; wy=0.26; dx=0.025; dy=0.03;
p1= [-0.01,    0.675,    wx, wy];
p2= [0.495,    0.675,    wx, wy];
p3= [-0.01,    0.355,    wx, wy];
p4= [0.495,    0.355,    wx, wy];
p5= [-0.01,    0.035,    wx, wy];
p6= [0.495,    0.035,    wx, wy];

nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);


pos1=[0.43  0.69  0.019 0.21 ];%[left bottom width height];
pos2=[0.94  0.69  0.019 0.21 ];%[left bottom width height];
pos3=[0.43  0.37  0.019 0.21 ];%[left bottom width height];
pos4=[0.94  0.37  0.019 0.21 ];%[left bottom width height];
pos5=[0.43  0.06  0.019 0.21 ];%[left bottom width height];
pos6=[0.94  0.06  0.019 0.21 ];%[left bottom width height];

row=3; col=1; domap='noprojection'; domap='robinson';


ax1=subplot('Position',p1); clear a; a=z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-100:5:0], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-100 0]);
colormap(ax1,cmap);
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16);
h1.Ticks = [-100 -80 -60 -40 -20 0];
h1.TickLabels = {'-100','-80','-60','-40','-20','0'};
set(get(h1,'Title') ,'String','W/m^{2}');
title({'(a) SWCRE-TOA ; CERES-EBAF', sprintf('(%s; MEAN=%5.1f)',upper(sea),s.mean1)},'FontSize',14);
%-------------------------------------
ax2=subplot('Position',p2); clear a; a=z2z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-30:3:30], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-30 30]);
colormap(ax2,bluewhitered(nn));
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-30 -20 -10 0 10 20 30];
h2.TickLabels = {'-30','-20','-10','0','10','20','30'};
set(get(h2,'Title') ,'String','W/m^{2}');
title({'(b) AM4-Lock minus CERES', sprintf('(BIAS=%5.2f; RMSE=%5.2f)',s.bias21,s.rmse21)},'FontSize',14);
%-------------------------------------

ax3=subplot('Position',p3); clear a; a=z3z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-30:3:30], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-30 30]);
colormap(ax3,bluewhitered(nn));
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-30 -20 -10 0 10 20 30];
h3.TickLabels = {'-30','-20','-10','0','10','20','30'};
set(get(h3,'Title') ,'String','W/m^{2}');
title({'(c) AM4-EDMF minus CERES', sprintf('(BIAS=%5.2f; RMSE=%5.2f)',s.bias31,s.rmse31)},'FontSize',14);
%-------------------------------------

ax4=subplot('Position',p4); clear a; a=z4z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-30:3:30], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-30 30]);
colormap(ax4,bluewhitered(nn));
h4=colorbar('Location','eastoutside','Position',pos4,'FontSize',16);
h4.Ticks = [-30 -20 -10 0 10 20 30];
h4.TickLabels = {'-30','-20','-10','0','10','20','30'};
set(get(h4,'Title') ,'String','W/m^{2}');
title({'(d) AM4-EDMF-HET minus CERES', sprintf('(BIAS=%5.2f; RMSE=%5.2f)',s.bias41,s.rmse41)},'FontSize',14);
%-------------------------------------

ax5=subplot('Position',p5); clear a; a=z4z2;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-20:2:20], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-20 20]);
colormap(ax5,bluewhitered(nn));
h5=colorbar('Location','eastoutside','Position',pos5,'FontSize',16);
h5.Ticks = [-20 -10 0 10 20];
h5.TickLabels = {'-20','-10','0','10','20'};
set(get(h5,'Title') ,'String','W/m^{2}');
title({'(e) AM4-EDMF-HET minus AM4-Lock', sprintf('(DIFF=%5.2f)',s.bias42)},'FontSize',14);
%-------------------------------------

ax6=subplot('Position',p6); clear a; a=z4z3;
a(land_frac'<0.4 & (a>-2 & a<2))=NaN;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-10:1:10], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-10 10]);
colormap(ax6,bluewhitered(nn));
h6=colorbar('Location','eastoutside','Position',pos6,'FontSize',16);
h6.Ticks = [-10 -5 0 5 10];
h6.TickLabels = {'-10','-5','0','5','10'};
set(get(h6,'Title') ,'String','W/m^{2}');
title({'(f) AM4-EDMF-HET minus AM4-EDMF', sprintf('(DIFF=%5.2f)',s.bias43)},'FontSize',14);
%-------------------------------------


cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'swcre_annualmean.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%--------


