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
sw_am4 =  ((swdn_am4) - (swup_am4))';
sw_ncep = ((swdn_ncep) - (swup_ncep))';
sw_clasp= ((swdn_clasp) - (swup_clasp))';
alb_am4  = (swup_am4./swdn_am4)'; alb_am4(alb_am4<0 | alb_am4>1)=NaN;
alb_ncep = (swup_ncep./swdn_ncep)'; alb_ncep(alb_ncep<0 | alb_ncep>1)=NaN;
alb_clasp= (swup_clasp./swdn_clasp)'; alb_clasp(alb_clasp<0 | alb_clasp>1)=NaN;



s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;

s.c1=-30;   s.c2=150;   s.vbino=[s.c1:5:s.c2]; s.unit='(K)';
s.cmin=-150; s.cmax=0; s.vbin =[s.cmin:5:s.cmax];
s.cminclasp=-10; s.cmaxclasp=10; s.vbin1 =[s.cminclasp:0.5:s.cmaxclasp];
s.cminclasp2=-20; s.cmaxclasp2=20; s.vbin2 =[s.cminclasp2:1:s.cmaxclasp2];

%--------------
aa=s.aa;
sea='ANN';

z3z1 = rn_clasp - rn_am4;
z3z2 = rn_clasp - rn_ncep;
z6z4 = lw_clasp - lw_am4;
z6z5 = lw_clasp - lw_ncep;
z9z7 = alb_clasp - alb_am4;
z9z8 = alb_clasp - alb_ncep;
z11z9 = sw_clasp - sw_am4;
z11z10 = sw_clasp - sw_ncep;


a=s.aa;
id=~isnan(z3z1) & ~isnan(z3z2); a(id)=a(id)/mean(a(id)); a=a(id);

e=z3z1(id); s.rmse31=sqrt(mean(e.*e.*a)); s.bias31=mean(mean(e.*a));
e=z6z4(id); s.rmse64=sqrt(mean(e.*e.*a)); s.bias64=mean(mean(e.*a));
e=z11z9(id); s.rmse119=sqrt(mean(e.*e.*a)); s.bias119=mean(mean(e.*a));

a=s.aa;

id=~isnan(z3z2); a(id)=a(id)/mean(a(id)); a=a(id);
e=z3z2(id); s.rmse32=sqrt(mean(e.*e.*a)); s.bias32=mean(mean(e.*a));


a=s.aa;

id=~isnan(z11z10); a(id)=a(id)/mean(a(id)); a=a(id);
e=z11z10(id); s.rmse1110=sqrt(mean(e.*e.*a)); s.bias1110=mean(mean(e.*a));

a=s.aa;
id=~isnan(z6z5); a(id)=a(id)/mean(a(id)); a=a(id);
e=z6z5(id); s.rmse65=sqrt(mean(e.*e.*a)); s.bias65=mean(mean(e.*a));

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
vbin=s.vbin; vbino=s.vbino;
domap='robinson';

a=s.aa; id=~isnan(rn_clasp); a(id)=a(id)/mean(a(id)); a=a(id);
e=rn_clasp(id); s.mean1=mean(e.*a);

a=s.aa; id=~isnan(lw_clasp); a(id)=a(id)/mean(a(id)); a=a(id);
e=lw_clasp(id); s.mean6=mean(e.*a);

a=s.aa; id=~isnan(sw_clasp); a(id)=a(id)/mean(a(id)); a=a(id);
e=sw_clasp(id); s.mean11=mean(e.*a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pms=[100, 200, 1800, 900]*1; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=-0.02; y0=0.6; wx=0.33; wy=0.3; dx=0.025; dy=0.15;
p1= [x0,            y0,            wx, wy];
p2= [0.32,          y0,            wx, wy];
p3= [0.655,          y0,            wx, wy];
p4= [x0,            y0-(wy+dy),    wx, wy];
p5= [0.32,          y0-(wy+dy),    wx, wy];
p6= [0.655,          y0-(wy+dy),    wx, wy];

nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);


pos1=[0.285  0.62  0.015 0.25 ];%[left bottom width height];
pos2=[0.625  0.62  0.015 0.25 ];%[left bottom width height];
pos3=[0.961  0.62  0.015 0.25 ];%[left bottom width height];
pos4=[0.285  0.17  0.015 0.25 ];%[left bottom width height];
pos5=[0.625  0.17  0.015 0.25 ];%[left bottom width height];
pos6=[0.961  0.17  0.015 0.25 ];%[left bottom width height];

row=3; col=1; domap='noprojection'; domap='robinson';


ax1=subplot('Position',p1); clear a; a=sw_clasp;

axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[0:5:250], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([0 250]);
colormap(ax1,cmap);
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); cbfreeze(h1,cmap);
h1.Ticks = [0 50 100 150 200 250];
h1.TickLabels = {'0','50','100','150','200','250'};
set(get(h1,'Title') ,'String','W/m^{2}');
title({'(a) SW_{n} (AM4-EDMF-HET)',sprintf('(%s; MEAN=%5.1f)',sea, s.mean11)},...
'FontSize',14);

ax2=subplot('Position',p2); clear a; a=z11z9;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-20:1:20], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-20 20]);
colormap(ax2,bluewhitered(nn));
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-20 -10 0 10 20];
h2.TickLabels = {'-20','-10','0','10','20'};
set(get(h2,'Title') ,'String','W/m^{2}');
title({'(b) SW_{n} (AM4-EDMF-HET minus AM4-Lock)',sprintf('(DIFF=%5.1f)',s.bias119)},...
'FontSize',14);

ax3=subplot('Position',p3); clear a; a=z11z10;
a(land_frac'<0.4 & (a>-1.2 & a<1.2)) = NaN;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-10:0.5:10], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-10 10]);
colormap(ax3,bluewhitered(nn));
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-10 -5 0 5 10];
h3.TickLabels = {'-10','-5','0','5','10'};
set(get(h3,'Title') ,'String','W/m^{2}');
title({'(c) SW_{n} (AM4-EDMF-HET minus AM4-EDMF)',sprintf('(DIFF=%5.1f)',s.bias1110)},...
'FontSize',14);

ax4=subplot('Position',p4); clear a; a=lw_clasp;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-150:5:0], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-150 0]);
colormap(ax4,cmap);
h4=colorbar('Location','eastoutside','Position',pos4,'FontSize',16);
h4.Ticks = [-150 -120 -90 -60 -30 0];
h4.TickLabels = {'-150','-120','-90','-60','-30','0'};
set(get(h4,'Title') ,'String','W/m^{2}');
title({'(d) LW_{n} (AM4-EDMF-HET)',sprintf('(%s; MEAN=%5.2f)',sea, s.mean6)},...
'FontSize',14);

ax5=subplot('Position',p5); clear a; a=z6z4;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-20:1:20], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-20 20]);
colormap(ax5,bluewhitered(nn));
h5=colorbar('Location','eastoutside','Position',pos5,'FontSize',16);
h5.Ticks = [-20 -10 0 10 20];
h5.TickLabels = {'-20','-10','0','10','20'};
set(get(h5,'Title') ,'String','W/m^{2}');
title({'(e) LW_{n} (AM4-EDMF-HET minus AM4-Lock)',sprintf('(DIFF=%5.2f)',s.bias64)},...
'FontSize',14);

ax6=subplot('Position',p6); clear a; a=z6z5;
%a(land_frac'<0.4 & (a>-2 & a<2)) = NaN;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-10:0.5:10], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-10 10]);
caxis([s.cminclasp s.cmaxclasp]); colormap(ax6,bluewhitered(nn));
h6=colorbar('Location','eastoutside','Position',pos6,'FontSize',16);
h6.Ticks = [-10 -5 0 5 10];
h6.TickLabels = {'-10','-5','0','5','10'};
set(get(h6,'Title') ,'String','W/m^{2}');
title({'(f) LW_{n} (AM4-EDMF-HET minus AM4-EDMF)',sprintf('(DIFF=%5.2f)',s.bias65)},...
'FontSize',14);
%--------

cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'sw_lw_radiation_annualmean.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
close all;



















