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

f_orig = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/precip.nc';
f_ncep = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/precip.nc';
f_clasp = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_zas/precip.nc';


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



p_am4=86400.*squeeze(mean(ncread(f_orig, 'precip'),3));
p_ncep=86400.*squeeze(mean(ncread(f_ncep, 'precip'),3));
p_clasp=86400.*squeeze(mean(ncread(f_clasp, 'precip'),3));

%mask1=NaN(288,180); mask2=NaN(288,180);
%pval1=NaN(288,180); pval2=NaN(288,180);
%for i=1:288
%for j=1:180
%  clear hh1 pp1 hh2 pp2
%    x_am4   = squeeze(p_am4(i,j,:));
%    x_ncep  = squeeze(p_ncep(i,j,:));
%    x_clasp = squeeze(p_clasp(i,j,:));
%
%    [hh1,pp1]=ttest2(x_am4,x_clasp);
%    [hh2,pp2]=ttest2(x_ncep,x_clasp);
%    mask1(i,j)=hh1; pval1(i,j)=pp1;
%    mask2(i,j)=hh2; pval2(i,j)=pp2;
%
%end
%end


load('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab/all_data.mat',...
    'gpcp_inp');

%% Set do_print
sprintf('data read surccessfully, now plotting')
fpath='./'; expn='am4';
do_print = 0;    % set do_print = 1 to output as EPS files.

%% Fig 6: Compare Precipitation
k=1; varn='precip';
z1 = gpcp_inp.precip';
z2 = p_am4';
z3 = p_ncep';
z4 = p_clasp';


s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;
s.s1='(a) P (mm/d), GPCP';
s.s2='(b) AM4-Lock minus GPCP';
s.s3='(c) AM4-EDMF minus GPCP';
s.s4='(d) AM4-EDMF-HET minus GPCP';
s.s5='(e) AM4-EDMF-HET minus AM4-Lock';
s.s6='(f) AM4-EDMF-HET minus AM4-EDMF';

s.c1=0;   s.c2=12;   s.vbino=[s.c1:0.4:s.c2]; s.unit='(mm/d)';
s.cmin=-3; s.cmax=3; s.vbin =[s.cmin:0.2:s.cmax];
s.cminclasp=-2; s.cmaxclasp=2;
s.cminclasp2=-2; s.cmaxclasp2=2; s.vbin2 =[s.cminclasp2:0.2:s.cmaxclasp2];
s.cminclasp3=-1; s.cmaxclasp3=1; s.vbin3 =[s.cminclasp3:0.1:s.cmaxclasp3];
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
contourfm(lat,lon,a,[0:0.25:10], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([0 10]); colormap(ax1,cmap); %freezeColors;
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); %cbfreeze(h1,cmap);
h1.Ticks = [0 2 4 6 8 10];
h1.TickLabels = {'0','2','4','6','8','10'};
set(get(h1,'Title') ,'String','mm/d');
title({'(a) P ; GPCP', sprintf('(%s; MEAN=%5.2f)',upper(sea),s.mean1)},'FontSize',14);
%-------------------------------------
ax2=subplot('Position',p2); clear a; a=z2z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-3:0.2:3], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-3 3]); colormap(ax2,bluewhitered(nn));
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-3 -2 -1 0 1 2 3];
h2.TickLabels = {'-3','-2','-1','0','1','2','3'};
set(get(h2,'Title') ,'String','mm/d');
title({'(b) AM4-Lock minus GPCP', sprintf('(BIAS=%5.2f; RMSE=%5.2f)',s.bias21,s.rmse21)},'FontSize',14);
%-------------------------------------

ax3=subplot('Position',p3); clear a; a=z3z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-3:0.2:3], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-3 3]); colormap(ax3,bluewhitered(nn));
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-3 -2 -1 0 1 2 3];
h3.TickLabels = {'-3','-2','-1','0','1','2','3'};
set(get(h3,'Title') ,'String','mm/d');
title({'(c) AM4-EDMF minus GPCP', sprintf('(BIAS=%5.2f; RMSE=%5.2f)',s.bias31,s.rmse31)},'FontSize',14);
%-------------------------------------

ax4=subplot('Position',p4); clear a; a=z4z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-3:0.2:3], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-3 3]); colormap(ax4,bluewhitered(nn));
h4=colorbar('Location','eastoutside','Position',pos4,'FontSize',16);
h4.Ticks = [-3 -2 -1 0 1 2 3];
h4.TickLabels = {'-3','-2','-1','0','1','2','3'};
set(get(h4,'Title') ,'String','mm/d');
title({'(d) AM4-EDMF-HET minus GPCP', sprintf('(BIAS=%5.2f; RMSE=%5.2f)',s.bias41,s.rmse41)},'FontSize',14);
%-------------------------------------

ax5=subplot('Position',p5); clear a; a=z4z2;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-2:0.2:2], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-2 2]); colormap(ax5,bluewhitered(nn)); %freezeColors;
h5=colorbar('Location','eastoutside','Position',pos5,'FontSize',16);
h5.Ticks = [-2 -1 0 1 2];
h5.TickLabels = {'-2','-1','0','1','2'};
set(get(h5,'Title') ,'String','mm/d');
title({'(e) AM4-EDMF-HET minus AM4-Lock', sprintf('(DIFF=%5.2f)',s.bias42)},'FontSize',14);
%-------------------------------------
delete(ax6);
ax6=subplot('Position',p6); clear a; a=z4z3;
%a(land_frac'<0.4 & (a>-0.8 & a<0.8))=NaN;
a(land_frac'<0.4)=NaN;
a(a>-0.05 & a<0.05)=NaN;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-0.6:0.1:0.6], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-0.6 0.6]); colormap(ax6,bluewhitered(nn)); %freezeColors;
h6=colorbar('Location','eastoutside','Position',pos6,'FontSize',16);
h6.Ticks = [-0.6 -0.3 0 0.3 0.6];
h6.TickLabels = {'-0.6','-0.3','0','0.3','0.6'};
set(get(h6,'Title') ,'String','mm/d');
title({'(f) AM4-EDMF-HET minus AM4-EDMF', sprintf('(DIFF=%5.2f)',s.bias43)},'FontSize',14);
%-------------------------------------


cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'precip_annualmean_nolm.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')



