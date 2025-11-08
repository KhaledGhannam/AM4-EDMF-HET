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


evapw_am4 = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/evap.nc','evap'),...
           3,'omitnan'));

precip_am4 = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/precip.nc','precip'),...
           3,'omitnan'));


% --- NCEP ------

evapw_ncep = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/evap.nc','evap'),...
           3,'omitnan'));


precip_ncep = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/precip.nc','precip'),...
           3,'omitnan'));

% --- CLASP ------


evapw_clasp = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/evap.nc','evap'),...
           3,'omitnan'));


precip_clasp = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/precip.nc','precip'),...
           3,'omitnan'));




% --- calculate runoff ratio ----

precip1= precip_am4; precip1(precip1<0.05)=NaN; precip1(:,1:30)=NaN; precip1(land_frac<0.5)=NaN;
precip2= precip_ncep; precip2(precip2<0.05)=NaN; precip2(:,1:30)=NaN; precip2(land_frac<0.5)=NaN;
precip3= precip_clasp; precip3(precip3<0.05)=NaN; precip3(:,1:30)=NaN; precip3(land_frac<0.5)=NaN;

evap1= evapw_am4; evap1(evap1<0.005)=NaN; evap1(:,1:30)=NaN; evap1(land_frac<0.5)=NaN;
evap2= evapw_ncep; evap2(evap2<0.005)=NaN; evap2(:,1:30)=NaN; evap2(land_frac<0.5)=NaN;
evap3= evapw_clasp; evap3(evap3<0.005)=NaN; evap3(:,1:30)=NaN; evap3(land_frac<0.5)=NaN;


clear r1 r2 r3
r1= (precip1-evap1); r1(r1<0 | r1>10)=NaN; r1(:,1:30)=NaN; r1(land_frac<0.5)=NaN;
r2= (precip2-evap2); r2(r2<0 | r2>10)=NaN; r2(:,1:30)=NaN; r2(land_frac<0.5)=NaN;
r3= (precip3-evap3); r3(r3<0 | r3>10)=NaN; r3(:,1:30)=NaN; r3(land_frac<0.5)=NaN;

s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;

s.c1=0;   s.c2=4;   s.vbino=[s.c1:0.2:s.c2]; s.unit='(K)';
s.cmin=-0.6; s.cmax=0.6; s.vbin =[s.cmin:0.2:s.cmax];
s.cminclasp=-0.6; s.cmaxclasp=0.6; s.vbin1 =[s.cminclasp:0.2:s.cmaxclasp];
s.cminclasp2=-0.6; s.cmaxclasp2=0.6; s.vbin2 =[s.cminclasp2:0.2:s.cmaxclasp2];

%--------------
aa=s.aa;
sea='ANN';

r1=r1';
r2=r2';
r3=r3';
z3z1 = r3 - r1;
z3z2 = r3 - r2;

% -- trial ---
z3z1(z3z1>-0.03 & z3z1<0.03)=NaN;
z3z2(z3z2>-0.03 & z3z2<0.03)=NaN;

a=s.aa;
id=~isnan(z3z1) & ~isnan(z3z2); a(id)=a(id)/mean(a(id)); a=a(id);

e=z3z1(id); s.rmse31=sqrt(mean(e.*e.*a)); s.bias31=mean(mean(e.*a));
clear e;
e=z3z2(id); s.rmse32=sqrt(mean(e.*e.*a)); s.bias32=mean(mean(e.*a));

a=s.aa; id=~isnan(r3); a(id)=a(id)/mean(a(id)); a=a(id);
e=r3(id); s.mean3=mean(e.*a);

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
domap='robinson';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pms=[20, 200, 1600, 400]*1; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=0.0; y0=0.1; wx=0.28; wy=0.7; dx=0.025; dy=0.15;
p1= [x0,            y0,            wx, wy];
p2= [0.33,          y0,            wx, wy];
p3= [0.68,          y0,            wx, wy];

nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);


pos1=[0.27  0.22  0.015 0.44 ];%[left bottom width height];
pos2=[0.60  0.22  0.015 0.44 ];%[left bottom width height];
pos3=[0.95  0.22  0.015 0.44 ];%[left bottom width height];


row=3; col=1; domap='noprojection'; domap='robinson';


ax1=subplot('Position',p1); a=r3;
do_mapproj_kmg(lat,lon,a,s.vbino,latx,lonx,lm,domap,xy);
caxis([s.c1 s.c2]); colormap(ax1,cmap); freezeColors;
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); cbfreeze(h1,cmap);
h1.Ticks = [0 1 2 3 4];
h1.TickLabels = {'0','1','2','3','4'};
set(get(h1,'Title') ,'String','mm/d');
title({'(a) R (AM4-EDMF-HET)',sprintf('(%s; MEAN=%5.2f)',sea, s.mean3)},...
'FontSize',14);

ax2=subplot('Position',p2); a=z3z1;
do_mapproj_kmg(lat,lon,a,s.vbin2,latx,lonx,lm,domap,xy);
caxis([s.cminclasp2 s.cmaxclasp2]); colormap(ax2,bluewhitered(nn)); freezeColors;
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-0.6 -0.3 0 0.3 0.6];
h2.TickLabels = {'-0.6','-0.3','0','0.3','0.6'};
set(get(h2,'Title') ,'String','mm/d');
title({'(b) R (AM4-EDMF-HET minus AM4-Lock)',sprintf('(DIFF=%5.2f)',s.bias31)},...
'FontSize',14);

ax3=subplot('Position',p3); a=z3z2;
do_mapproj_kmg(lat,lon,a,s.vbin1,latx,lonx,lm,domap,xy);
caxis([s.cminclasp s.cmaxclasp]); colormap(ax3,bluewhitered(nn));
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-0.6 -0.3 0 0.3 0.6];
h3.TickLabels = {'-0.6','-0.3','0','0.3','0.6'};
set(get(h3,'Title') ,'String','mm/d');
title({'(c) R (AM4-EDMF-HET minus AM4-EDMF)',sprintf('(DIFF=%5.2f)',s.bias32)},...
'FontSize',14);
%-----------------------
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'runoff_clasplnddisplm.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%-----------

