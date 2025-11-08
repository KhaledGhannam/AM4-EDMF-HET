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

f_orig = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/evap.nc';
f_ncep = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/evap.nc';
f_clasp_lndlm = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/evap.nc';

f_orig2 = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/shflx.nc';
f_ncep2 = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/shflx.nc';
f_clasp_lndlm2 = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/shflx.nc';


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


am4_orig.evap= 2.5E06.*squeeze(mean(ncread(f_orig, 'evap'),3));
am4_ncep.evap= 2.5E06.*squeeze(mean(ncread(f_ncep, 'evap'),3));
am4_clasp_lndlm.evap=2.5E06.*squeeze(mean(ncread(f_clasp_lndlm,'evap'),3));

am4_orig.shflx= squeeze(mean(ncread(f_orig2, 'shflx'),3));
am4_ncep.shflx= squeeze(mean(ncread(f_ncep2, 'shflx'),3));
am4_clasp_lndlm.shflx=squeeze(mean(ncread(f_clasp_lndlm2,'shflx'),3));



fpath='./'; expn='am4';
do_print = 0;

%% Fig 6: Compare Preciplot_6panel_mapp_kmg(s,z1,z2,z3,z6,varn,expn,f,k,icmap,do_print);

k=1; varn='T_ref';
z1 = am4_orig.evap';
z2 = am4_ncep.evap';
z3 = am4_clasp_lndlm.evap';
z4 = am4_orig.shflx';
z5 = am4_ncep.shflx';
z6 = am4_clasp_lndlm.shflx';


s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;

s.c1=0;   s.c2=150;   s.vbino=[s.c1:5:s.c2]; s.unit='(K)';
s.cmin=-20; s.cmax=80; s.vbin =[s.cmin:5:s.cmax];
s.cminclasp=-10; s.cmaxclasp=10; s.vbin1 =[s.cminclasp:0.5:s.cmaxclasp];
s.cminclasp2=-20; s.cmaxclasp2=20; s.vbin2 =[s.cminclasp2:1:s.cmaxclasp2];

%--------------
aa=s.aa;
sea='ANN';

z_evap_clasp = z3;
z3z1 = z3 - z1;
z3z2 = z3 -z2;

z_shflx_clasp = z6;
z6z4 = z6 - z4;
z6z5 = z6 -z5;



a=s.aa;
id=~isnan(z3z1); a(id)=a(id)/mean(a(id)); a=a(id);
e=z3z1(id); s.rmse31=sqrt(mean(e.*e.*a)); s.bias31=mean(mean(e.*a));

a=s.aa;
z3z2(land_frac'<0.2)=NaN;
id=~isnan(z3z2); a(id)=a(id)/mean(a(id)); a=a(id);
e=z3z2(id); s.rmse32=sqrt(mean(e.*e.*a)); s.bias32=mean(mean(e.*a));

a=s.aa;
id=~isnan(z6z4); a(id)=a(id)/mean(a(id)); a=a(id);
e=z6z4(id); s.rmse64=sqrt(mean(e.*e.*a)); s.bias64=mean(mean(e.*a));

a=s.aa;
z6z5(land_frac'<0.2)=NaN;
id=~isnan(z6z5); a(id)=a(id)/mean(a(id)); a=a(id);
e=z6z5(id); s.rmse65=sqrt(mean(e.*e.*a)); s.bias65=mean(mean(e.*a));




lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
vbin=s.vbin; vbino=s.vbino;
domap='robinson';

a=s.aa; id=~isnan(z3); a(id)=a(id)/mean(a(id)); a=a(id);
e=z3(id); s.mean1=mean(e.*a);

a=s.aa; id=~isnan(z6); a(id)=a(id)/mean(a(id)); a=a(id);
e=z6(id); s.mean6=mean(e.*a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pms=[20, 200, 1650, 600]*1; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=-0.07; y0=0.6; wx=0.35; wy=0.3; dx=0.025; dy=0.15;
p1= [x0,            y0,            wx, wy];
p2= [wx-0.07,       y0,            wx, wy];
p3= [2*wx-0.07,     y0,            wx, wy];
p4= [x0,            y0-(wy+dy),    wx, wy];
p5= [wx-0.07,       y0-(wy+dy),    wx, wy];
p6= [2*wx-0.07,     y0-(wy+dy),    wx, wy];

nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);


pos1=[0.21  0.62  0.015 0.28 ];%[left bottom width height];
pos2=[0.56  0.62  0.015 0.28 ];%[left bottom width height];
pos3=[0.91  0.62  0.015 0.28 ];%[left bottom width height];
pos4=[0.21  0.17  0.015 0.28 ];%[left bottom width height];
pos5=[0.56  0.17  0.015 0.28 ];%[left bottom width height];
pos6=[0.91  0.17  0.015 0.28 ];%[left bottom width height];

row=3; col=1; domap='noprojection'; domap='robinson';


ax1=subplot('Position',p1); a=z3;
do_mapproj_kmg(lat,lon,a,s.vbino,latx,lonx,lm,domap,xy);
caxis([s.c1 s.c2]); colormap(ax1,cmap); freezeColors;
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); cbfreeze(h1,cmap);
h1.Ticks = [0 30 60 90 120 150];
h1.TickLabels = {'0','30','60','90','120','150'};
title({'(a) F_{E} (W/m^{2}) (AM4-EDMF-HET)',sprintf('(%s; MEAN=%5.2f)',sea, s.mean1)},...
'FontSize',14);

ax2=subplot('Position',p2); a=z3z1; id=isnan(a); a(id)=0;
do_mapproj_kmg(lat,lon,a,s.vbin2,latx,lonx,lm,domap,xy);
caxis([s.cminclasp2 s.cmaxclasp2]); colormap(ax2,bluewhitered(nn)); freezeColors;
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-20 -10 0 10 20];
h2.TickLabels = {'-20','-10','0','10','20'};
title({'(b) F_{E} (AM4-EDMF-HET minus AM4-Lock)',sprintf('(DIFF=%5.2f)',s.bias31)},...
'FontSize',14);

ax3=subplot('Position',p3); a=z3z2; id=isnan(a); a(id)=0;
a(land_frac'<0.2)=NaN;
do_mapproj_kmg(lat,lon,a,s.vbin2,latx,lonx,lm,domap,xy);
caxis([s.cminclasp2 s.cmaxclasp2]); colormap(ax3,bluewhitered(nn));
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-20 -10 0 10 20];
h3.TickLabels = {'-20','-10','0','10','20'};
title({'(c) F_{E} (AM4-EDMF-HET minus AM4-EDMF)',sprintf('(DIFF=%5.2f)',s.bias32)},...
'FontSize',14);

ax4=subplot('Position',p4); a=z6; id=isnan(a); a(id)=0;
do_mapproj_kmg(lat,lon,a,s.vbin,latx,lonx,lm,domap,xy);
caxis([s.cmin s.cmax]); colormap(ax4,cmap);
h4=colorbar('Location','eastoutside','Position',pos4,'FontSize',16);
h4.Ticks = [-20 0 20 40 60 80];
h4.TickLabels = {'-20','0','20','40','60','80'};
title({'(d) F_{H} (W/m^{2}) (AM4-EDMF-HET)',sprintf('(%s; MEAN=%5.2f)',sea, s.mean6)},...
'FontSize',14);

ax5=subplot('Position',p5); a=z6z4; id=isnan(a); a(id)=0;
do_mapproj_kmg(lat,lon,a,s.vbin2,latx,lonx,lm,domap,xy);
caxis([s.cminclasp2 s.cmaxclasp2]); colormap(ax5,bluewhitered(nn));
h5=colorbar('Location','eastoutside','Position',pos5,'FontSize',16);
h5.Ticks = [-20 -10 0 10 20];
h5.TickLabels = {'-20','-10','0','10','20'};
title({'(e) F_{H} (AM4-EDMF-HET minus AM4-Lock)',sprintf('(DIFF=%5.2f)',s.bias64)},...
'FontSize',14);

ax6=subplot('Position',p6); a=z6z5; id=isnan(a); a(id)=0;
do_mapproj_kmg(lat,lon,a,s.vbin2,latx,lonx,lm,domap,xy);
caxis([s.cminclasp2 s.cmaxclasp2]); colormap(ax6,bluewhitered(nn));
h6=colorbar('Location','eastoutside','Position',pos6,'FontSize',16);
h6.Ticks = [-20 -10 0 10 20];
h6.TickLabels = {'-20','-10','0','10','20'};
title({'(f) F_{H} (AM4-EDMF-HET minus AM4-EDMF)',sprintf('(DIFF=%5.2f)',s.bias65)},...
'FontSize',14);

%--------------
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'sens_evap_clasplnddisplm.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
close all;
