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

lh_clasp = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/het_lm_out_diu.nc','het_lm_out'));


lh_clasp_mean = squeeze(mean(mean(lh_clasp,3,'omitnan'),4,'omitnan'));


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
title({'(a) Vertically averaged M_{u}', '(AM4-EDMF-HET)'},'FontSize',14);


cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'massflux_integrated.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
