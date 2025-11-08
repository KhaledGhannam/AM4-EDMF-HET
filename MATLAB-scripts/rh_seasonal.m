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

%--- read ERA data ----
era.lon  = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'longitude');
era.lat  = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'latitude');

mon_wt_era = [31 (28*26+29*9)/35 31 30 31 30 31 31 30 31 30 31]; mon_wt_era = mon_wt_era/sum(mon_wt_era); % Month weighting
era.rh2m  = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'rh2m').*100;

era.lon_ext = [era.lon(end-1: end)-360; era.lon; era.lon(1:2)+360];
era.rh2m_ext  = era.rh2m ([end-1:end 1:end 1:2],:,:);

[X, Y] = meshgrid(era.lat, era.lon_ext);
era_inp.lon = am4_orig.lon; era_inp.lat = am4_orig.lat;
[Xp, Yp] = meshgrid(era_inp.lat, era_inp.lon);

era_inp.rh2m=NaN(288,180,12);

for i=1:12
era_inp.rh2m (:,:,i)  = interp2(X, Y, squeeze(era.rh2m_ext(:,:,i)),  Xp, Yp);
end
%----------

% ---read model data ----
am4_orig.rh2m= squeeze(mean(reshape(ncread(f_orig, 'rh_ref'),288,180,12,[]),4));
am4_ncep.rh2m= squeeze(mean(reshape(ncread(f_ncep, 'rh_ref'),288,180,12,[]),4));
am4_clasp.rh2m=squeeze(mean(reshape(ncread(f_clasp, 'rh_ref'),288,180,12,[]),4));
%----------------------------------

era_rh2m_jja = squeeze(mean(era_inp.rh2m(:,:,6:8),3,'omitnan'));
era_rh2m_jf =  squeeze(mean(era_inp.rh2m(:,:,1:2),3,'omitnan'));

am4_rh2m_jja = squeeze(mean(am4_orig.rh2m(:,:,6:8),3,'omitnan'));
am4_rh2m_jf = squeeze(mean(am4_orig.rh2m(:,:,1:2),3,'omitnan'));

ncep_rh2m_jja = squeeze(mean(am4_ncep.rh2m(:,:,6:8),3,'omitnan'));
ncep_rh2m_jf = squeeze(mean(am4_ncep.rh2m(:,:,1:2),3,'omitnan'));

clasp_rh2m_jja = squeeze(mean(am4_clasp.rh2m(:,:,6:8),3,'omitnan'));
clasp_rh2m_jf =  squeeze(mean(am4_clasp.rh2m(:,:,1:2),3,'omitnan'));
%-----------------------------------------------------

fpath='./'; expn='am4';
do_print = 0;

%% Fig 6: Compare Preciplot_6panel_mapp_kmg(s,z1,z2,z3,z6,varn,expn,f,k,icmap,do_print);

k=1; varn='T_ref';
z1 = era_rh2m_jja';
z2 = am4_rh2m_jja';
z3 = ncep_rh2m_jja';
z4 = clasp_rh2m_jja';

s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;


s.c1=240;   s.c2=310;   s.vbino=[s.c1:3:s.c2]; s.unit='(K)';
s.cmin=-3; s.cmax=3; s.vbin =[s.cmin:0.1:s.cmax];
s.cminclasp=-3; s.cmaxclasp=3;
s.cminclasp2=-2; s.cmaxclasp2=2; s.vbin2 =[s.cminclasp2:0.1:s.cmaxclasp2];

%--------------
aa=s.aa;
sea='JJA';
per='%';

z4z1 = z4 - z1;
z4z2 = z4 - z2;
z4z3 = z4 - z3;



a=s.aa;
id=~isnan(z4z1) & ~isnan(z4z2); a(id)=a(id)/mean(a(id)); a=a(id);

e=z4z1(id); s.rmse41=sqrt(mean(e.*e.*a)); s.bias41=mean(mean(e.*a));
e=z4z2(id); s.rmse42=sqrt(mean(e.*e.*a)); s.bias42=mean(mean(e.*a));
e=z4z3(id); s.rmse43=sqrt(mean(e.*e.*a)); s.bias43=mean(mean(e.*a));

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
vbin=s.vbin; vbino=s.vbino;
domap='robinson';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pms=[ 120, 120, 1600, 1000]*1.; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=0.02; y0=0.67; wx=0.4; wy=0.24; dx=0.025; dy=0.1;
p1= [0.01,            0.68, wx, wy];
p2= [0.01,            0.34, wx, wy];
p3= [0.01,            0.01, wx, wy];




nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);


pos1=[0.37  0.69  0.018 0.20 ];%[left bottom width height];
pos2=[0.37  0.36  0.018 0.20 ];%[left bottom width height];
pos3=[0.37  0.03  0.018 0.20 ];%[left bottom width height];


row=3; col=1; domap='noprojection'; domap='robinson';



ax1=subplot('Position',p1); clear a; a=z4z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-20:1:20], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-20 20]); colormap(ax1,bluewhitered(nn));
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16);
h1.Ticks = [-20 -10 0 10 20];
h1.TickLabels = {'-20','-10','0','10','20'};
set(get(h1,'Title') ,'String',sprintf('%s',per));
title({'(a) RH_{ref} (AM4-EDMF-HET minus ERA)', sprintf('(%s; BIAS=%5.2f; RMSE=%5.2f)',upper(sea),s.bias41,s.rmse41)},'FontSize',14);
%------------------------------------------------

ax2=subplot('Position',p2); clear a; a=z4z2;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-20:1:20], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-20 20]); colormap(ax2,bluewhitered(nn));
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-20 -10 0 10 20];
h2.TickLabels = {'-20','-10','0','10','20'};
set(get(h2,'Title') ,'String',sprintf('%s',per));
title({'(b) RH_{ref} (AM4-EDMF-HET minus AM4-Lock)', sprintf('(%s; DIFF=%5.2f)',upper(sea),s.bias42)},'FontSize',14);
%------------------------------------------------

ax3=subplot('Position',p3); clear a; a=z4z3;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-20:1:20], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-20 20]); colormap(ax3,bluewhitered(nn));
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-20 -10 0 10 20];
h3.TickLabels = {'-20','-10','0','10','20'};
set(get(h3,'Title') ,'String',sprintf('%s',per));
title({'(c) RH_{ref} (AM4-EDMF-HET minus AM4-EDMF)', sprintf('(%s; DIFF=%5.2f)',upper(sea),s.bias43)},'FontSize',14);
%------------------------------------------------

%  ---- seasonal cycle -----


delete (ax4);
delete (ax5);
delete (ax6);
delete (ax7);
delete(legend);
delete(hh);

lf=repmat(land_frac,1,1,12);
s.s4='(d) 60N - 90N';
s.s5='(e) 20N - 60N';
s.s6='(f) 20S - 20N';
s.s7='(g) 60S - 20S';

p4= [0.50,            0.80, 0.44, 0.16];
p5= [0.50,            0.55, 0.44, 0.16];
p6= [0.50,            0.3,  0.44, 0.16];
p7= [0.50,            0.05, 0.44, 0.16];
%-------------------------------
ax4=subplot('Position',p4);

ax4.FontSize = 16;
ax4.XMinorTick = 'off';
ax4.YMinorTick = 'off';
xx=era_inp.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(151:180,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'k-o','MarkerSize',6,'linewidth',1.25)

hold on

clear xx
xx=am4_orig.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(151:180,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'b->','MarkerSize',6,'linewidth',1.25)

clear xx
xx=am4_ncep.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(151:180,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'c-^','MarkerSize',6,'linewidth',1.25)

clear xx
xx=am4_clasp.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(151:180,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'r-s','MarkerSize',6,'linewidth',1.25)

set(gca,'TickLength', [0.03 0.03]);
xlim([1 12])
xticks([1 4 7 10])
xticklabels({'Dec.','Mar.','Jun.',...
    'Sep.'})
ylabel(sprintf('RH_{ref} (%s)',per),'FontSize',16)
ylim([60 100])
yticks([60 70 80 90 100])
yticklabels({'60','70','80','90','100'})
set(gca,'Fontsize',16)
title(s.s4,'FontSize',14);

%----------------------
%-------------------------------
ax5=subplot('Position',p5);

ax5.FontSize = 16;
ax5.XMinorTick = 'off';
ax5.YMinorTick = 'off';
xx=era_inp.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(111:150,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'k-o','MarkerSize',6,'linewidth',1.25)

hold on

clear xx
xx=am4_orig.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(111:150,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'b->','MarkerSize',6,'linewidth',1.25)

clear xx
xx=am4_ncep.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(111:150,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'c-^','MarkerSize',6,'linewidth',1.25)

clear xx
xx=am4_clasp.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(111:150,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'r-s','MarkerSize',6,'linewidth',1.25)

set(gca,'TickLength', [0.03 0.03]);
xlim([1 12])
xticks([1 4 7 10])
xticklabels({'Dec.','Mar.','Jun.',...
    'Sep.'})
ylabel(sprintf('RH_{ref} (%s)',per),'FontSize',16)
ylim([40 80])
yticks([40 60 80])
yticklabels({'40','60','80'})
set(gca,'Fontsize',16)
title(s.s5,'FontSize',14);


%----------------------

ax6=subplot('Position',p6);

ax6.FontSize = 16;
ax6.XMinorTick = 'off';
ax6.YMinorTick = 'off';
xx=era_inp.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(71:110,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'k-o','MarkerSize',6,'linewidth',1.25)

hold on

clear xx
xx=am4_orig.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(71:110,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'b->','MarkerSize',6,'linewidth',1.25)

clear xx
xx=am4_ncep.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(71:110,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'c-^','MarkerSize',6,'linewidth',1.25)

clear xx
xx=am4_clasp.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(71:110,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'r-s','MarkerSize',6,'linewidth',1.25)

hh=legend('ERA','AM4-Lock','AM4-EDMF','AM4-EDMF-HET');
set(hh,'Orientation','Vertical','Position',[0.759 0.38015617652079027 0.195075760569109 0.122674420939227],...
    'box','off','Fontsize',16)

set(gca,'TickLength', [0.03 0.03]);
xlim([1 12])
xticks([1 4 7 10])
xticklabels({'Dec.','Mar.','Jun.',...
    'Sep.'})
ylabel(sprintf('RH_{ref} (%s)',per),'FontSize',16)
ylim([60 80])
yticks([60 70 80])
yticklabels({'60','70','80'})
set(gca,'Fontsize',16)

title(s.s6,'FontSize',14);


%----------------------

ax7=subplot('Position',p7);

ax7.FontSize = 16;
ax7.XMinorTick = 'off';
ax7.YMinorTick = 'off';
xx=era_inp.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(30:70,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'k-o','MarkerSize',6,'linewidth',1.25)

hold on

clear xx
xx=am4_orig.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(30:70,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'b->','MarkerSize',6,'linewidth',1.25)

clear xx
xx=am4_ncep.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(30:70,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'c-^','MarkerSize',6,'linewidth',1.25)

clear xx
xx=am4_clasp.rh2m;
xx(lf<0.5)=NaN;
xx=squeeze(mean(xx,1,'omitnan'));
xx=mean(xx(30:70,:),1,'omitnan');
xx=[xx(end) xx(1:end-1)];
plot(1:12,xx,'r-s','MarkerSize',6,'linewidth',1.25)

set(gca,'TickLength', [0.03 0.03]);
xlim([1 12])
xticks([1 4 7 10])
xticklabels({'Dec.','Mar.','Jun.',...
    'Sep.'})
ylabel(sprintf('RH_{ref} (%s)',per),'FontSize',16)
ylim([50 80])
yticks([50 60 70 80])
yticklabels({'50','60','70','80'})
set(gca,'Fontsize',16)

title(s.s7,'FontSize',14);


%----------------------
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'RHref_seasonalrev.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')





