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

f_orig = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/rh_ref.nc';
f_ncep = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/rh_ref.nc';
f_clasp = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/rh_ref.nc';

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

am4_orig.rh2m= squeeze(mean(ncread(f_orig, 'rh_ref'),3));
am4_ncep.rh2m= squeeze(mean(ncread(f_ncep, 'rh_ref'),3));
am4_clasp.rh2m= squeeze(mean(ncread(f_clasp, 'rh_ref'),3));

load('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab/all_data.mat',...
    'era_inp');

%% Set do_print

fpath='./'; expn='am4';

do_print = 0;    % set do_print = 1 to output as EPS files.

%% Fig 6: Compare Precipitation
k=1; varn='RH2m';
z1 = era_inp.rh2m';
z2 = am4_orig.rh2m';
z3 = am4_ncep.rh2m';
z4 = am4_clasp.rh2m';

per='%';

s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;
s.s1=sprintf('(a) RH_{ref} (%s), ERA',per);
s.s2='(b) AM4-Lock minus ERA';
s.s3='(c) AM4-EDMF minus ERA';
s.s4='(d) AM4-EDMF-HET minus ERA';
s.s5='(e) AM4-EDMF-HET minus AM4-Lock';
s.s6='(f) AM4-EDMF-HET minus AM4-EDMF';

s.c1=25;   s.c2=100;   s.vbino=[s.c1:2.5:s.c2]; s.unit='(K)';
s.cmin=-20; s.cmax=20; s.vbin =[s.cmin:2:s.cmax];
s.cminclasp=-10; s.cmaxclasp=10;
s.cminclasp2=-10; s.cmaxclasp2=10; s.vbin2 =[s.cminclasp2:1:s.cmaxclasp2];


%---------------------
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
s.s2=sprintf('%s (BIAS=%5.2f; RMSE=%5.2f)',s.s2,s.bias21,s.rmse21);
s.s3=sprintf('%s (BIAS=%5.2f; RMSE=%5.2f)',s.s3,s.bias31,s.rmse31);
s.s4=sprintf('%s (BIAS=%5.2f; RMSE=%5.2f)',s.s4,s.bias41,s.rmse41);
s.s5=sprintf('%s (DIFF=%5.2f)',s.s5,s.bias42);
s.s6=sprintf('%s (DIFF=%5.2f)',s.s6,s.bias43);

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
vbin=s.vbin; vbino=s.vbino;
domap='robinson';

a=s.aa; id=~isnan(z1); a(id)=a(id)/mean(a(id)); a=a(id);
e=z1(id); s.mean1=mean(e.*a);
s.s1=sprintf('%s (%s; MEAN=%5.2f)',s.s1,upper(sea),s.mean1);

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


ax1=subplot('Position',p1); a=z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[25:2.5:100], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([25 100]); colormap(ax1,cmap); %freezeColors;
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); %cbfreeze(h1,cmap);
h1.Ticks = [25 50 75 100];
h1.TickLabels = {'25','50','75','100'};
set(get(h1,'Title') ,'String',sprintf('%s',per));
title({'(a) RH_{ref} ; ERA', sprintf('(%s; MEAN=%5.2f)',upper(sea),s.mean1)},'FontSize',14);
%-------------------------------------
ax2=subplot('Position',p2); clear a; a=z2z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-20:2:20], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-20 20]); colormap(ax2,bluewhitered(nn)); %freezeColors;
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-20 -10 0 10 20];
h2.TickLabels = {'-20','-10','0','10','20'};
set(get(h2,'Title') ,'String',sprintf('%s',per));
title({'(b) AM4-Lock minus ERA', sprintf('(BIAS=%5.2f; RMSE=%5.2f)',s.bias21,s.rmse21)},'FontSize',14);
%-------------------------------------

ax3=subplot('Position',p3); clear a; a=z3z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-20:2:20], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-20 20]); colormap(ax3,bluewhitered(nn)); %freezeColors;
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-20 -10 0 10 20];
h3.TickLabels = {'-20','-10','0','10','20'};
set(get(h3,'Title') ,'String',sprintf('%s',per));
title({'(c) AM4-EDMF minus ERA', sprintf('(BIAS=%5.2f; RMSE=%5.2f)',s.bias31,s.rmse31)},'FontSize',14);
%-------------------------------------

ax4=subplot('Position',p4); clear a; a=z4z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-20:2:20], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-20 20]); colormap(ax4,bluewhitered(nn)); %freezeColors;
h4=colorbar('Location','eastoutside','Position',pos4,'FontSize',16);
h4.Ticks = [-20 -10 0 10 20];
h4.TickLabels = {'-20','-10','0','10','20'};
set(get(h4,'Title') ,'String',sprintf('%s',per));
title({'(d) AM4-EDMF-HET minus ERA', sprintf('(BIAS=%5.2f; RMSE=%5.2f)',s.bias41,s.rmse41)},'FontSize',14);
%-------------------------------------

ax5=subplot('Position',p5); clear a; a=z4z2;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-10:1:10], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-10 10]); colormap(ax5,bluewhitered(nn)); %freezeColors;
h5=colorbar('Location','eastoutside','Position',pos5,'FontSize',16);
h5.Ticks = [-10 -5 0 5 10];
h5.TickLabels = {'-10','-5','0','5','10'};
set(get(h5,'Title') ,'String',sprintf('%s',per)');
title({'(e) AM4-EDMF-HET minus AM4-Lock', sprintf('(DIFF=%5.2f)',s.bias42)},'FontSize',14);
%-------------------------------------

ax6=subplot('Position',p6); clear a; a=z4z3;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-10:1:10], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-10 10]); colormap(ax6,bluewhitered(nn)); %freezeColors;
h6=colorbar('Location','eastoutside','Position',pos6,'FontSize',16);
h6.Ticks = [-10 -5 0 5 10];
h6.TickLabels = {'-10','-5','0','5','10'};
set(get(h6,'Title') ,'String',sprintf('%s',per));
title({'(f) AM4-EDMF-HET minus AM4-EDMF', sprintf('(DIFF=%5.2f)',s.bias43)},'FontSize',14);
%-------------------------------------

cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'RHref_annualmean.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
close all;

