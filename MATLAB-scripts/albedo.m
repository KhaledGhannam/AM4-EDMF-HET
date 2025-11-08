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


% ---- read shortwave radiation -----

% --- AM4 ------
swdn_am4 = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/swdn_sfc.nc','swdn_sfc'),...
           3,'omitnan'));
swup_am4 = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/swup_sfc.nc','swup_sfc'),...
           3,'omitnan'));
lwdn_am4 = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/lwdn_sfc.nc','lwdn_sfc'),...
           3,'omitnan'));
lwup_am4 = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/lwup_sfc.nc','lwup_sfc'),...
           3,'omitnan'));

% --- NCEP ------
swdn_ncep = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/swdn_sfc.nc','swdn_sfc'),...
        3,'omitnan'));
swup_ncep = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/swup_sfc.nc','swup_sfc'),...
        3,'omitnan'));
lwdn_ncep = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/lwdn_sfc.nc','lwdn_sfc'),...
        3,'omitnan'));
lwup_ncep = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/lwup_sfc.nc','lwup_sfc'),...
           3,'omitnan'));

% --- CLASP ------
swdn_clasp = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/swdn_sfc.nc','swdn_sfc'),...
        3,'omitnan'));
swup_clasp = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/swup_sfc.nc','swup_sfc'),...
        3,'omitnan'));
lwdn_clasp = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/lwdn_sfc.nc','lwdn_sfc'),...
        3,'omitnan'));
lwup_clasp = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/lwup_sfc.nc','lwup_sfc'),...
           3,'omitnan'));

%-------------------------------------

rn_am4 =  ((swdn_am4+lwdn_am4) - (swup_am4+lwup_am4))';
rn_ncep = ((swdn_ncep+lwdn_ncep) - (swup_ncep+lwup_ncep))';
rn_clasp= ((swdn_clasp+lwdn_clasp) - (swup_clasp+lwup_clasp))';
lw_am4 =  ((lwdn_am4) - (lwup_am4))';
lw_ncep = ((lwdn_ncep) - (lwup_ncep))';
lw_clasp= ((lwdn_clasp) - (lwup_clasp))';
alb_am4  = 100.*(swup_am4./swdn_am4)';
alb_ncep = 100.*(swup_ncep./swdn_ncep)';
alb_clasp= 100.*(swup_clasp./swdn_clasp)';


%-----------------------
alb_am4(alb_am4<0 | alb_am4>100)=NaN;
alb_ncep(alb_ncep<0 | alb_ncep>100)=NaN;
alb_am4(alb_clasp<0 | alb_clasp>100)=NaN;
%-----------------------
s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;

s.c1=0;   s.c2=80;   s.vbino=[s.c1:5:s.c2]; s.unit='(K)';
s.cminclasp=-5; s.cmaxclasp=5; s.vbin1 =[s.cminclasp:1:s.cmaxclasp];
s.cminclasp2=-5; s.cmaxclasp2=5; s.vbin =[s.cminclasp2:1:s.cmaxclasp2];

%--------------
aa=s.aa;
sea='ANN';

z3z1 = rn_clasp - rn_am4;
z3z2 = rn_clasp - rn_ncep;
z6z4 = lw_clasp - lw_am4;
z6z5 = lw_clasp - lw_ncep;
z9z7 = alb_clasp - alb_am4;
z9z8 = alb_clasp - alb_ncep;


a=s.aa;
id=~isnan(z9z7); a(id)=a(id)/mean(a(id)); a=a(id);
e=z9z7(id); s.rmse97=sqrt(mean(e.*e.*a)); s.bias97=mean(mean(e.*a));

a=s.aa;
z9z8(land_frac'<0.2)=NaN;
id=~isnan(z9z8); a(id)=a(id)/mean(a(id)); a=a(id);
e=z9z8(id); s.rmse98=sqrt(mean(e.*e.*a)); s.bias98=mean(mean(e.*a));

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
vbin=s.vbin; vbino=s.vbino;
domap='robinson';

a=s.aa; id=~isnan(alb_clasp); a(id)=a(id)/mean(a(id)); a=a(id);
e=alb_clasp(id); s.mean1=mean(e.*a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pms=[20, 200, 1500, 600]*1; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=-0.04; y0=0.6; wx=0.35; wy=0.3; dx=0.025; dy=0.15;
p1= [x0,            y0,            wx, wy];
p2= [0.31,          y0,            wx, wy];
p3= [0.66,          y0,            wx, wy];
p4= [x0,            y0-(wy+dy),    wx, wy];
p5= [0.31,          y0-(wy+dy),    wx, wy];
p6= [0.66,          y0-(wy+dy),    wx, wy];

nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);


pos1=[0.25  0.62  0.015 0.28 ];%[left bottom width height];
pos2=[0.60  0.62  0.015 0.28 ];%[left bottom width height];
pos3=[0.95  0.62  0.015 0.28 ];%[left bottom width height];

row=3; col=1; domap='noprojection'; domap='robinson';


ax1=subplot('Position',p1); a=alb_clasp;
do_mapproj_kmg(lat,lon,a,s.vbino,latx,lonx,lm,domap,xy);
caxis([s.c1 s.c2]); colormap(ax1,cmap); freezeColors;
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); cbfreeze(h1,cmap);
h1.Ticks = [0 20 40 60 80];
h1.TickLabels = {'0','20','40','60','80'};
title({'(a) albedo (AM4-EDMF-HET)',sprintf('(%s; MEAN=%5.2f)',sea, s.mean1)},...
'FontSize',14);

ax2=subplot('Position',p2); a=z9z7;
do_mapproj_kmg(lat,lon,a,s.vbin1,latx,lonx,lm,domap,xy);
caxis([s.cminclasp s.cmaxclasp]); colormap(ax2,bluewhitered(nn)); freezeColors;
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
%h2.Ticks = [-0.1 0 0.1];
%h2.TickLabels = {'-0.1','0','0.1'};
title({'(b) albedo (AM4-EDMF-HET minus AM4-Lock)',sprintf('(DIFF=%5.2f)',s.bias97)},...
'FontSize',14);

ax3=subplot('Position',p3); a=z9z8;
do_mapproj_kmg(lat,lon,a,s.vbin1,latx,lonx,lm,domap,xy);
caxis([s.cminclasp s.cmaxclasp]); colormap(ax3,bluewhitered(nn));
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
%h3.Ticks = [-0.1 0 0.1];
%h3.TickLabels = {'-0.1','0','0.1'};
title({'(c) albedo (AM4-EDMF-HET minus AM4-EDMF)',sprintf('(DIFF=%5.2f)',s.bias98)},...
'FontSize',14);


cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'albedo_clasplnddisplm.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
close all;






















