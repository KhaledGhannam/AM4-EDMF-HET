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

am4_clasp_lndlm = struct();
am4_clasp_lndlm.lat = am4_orig.lat;
am4_clasp_lndlm.lon = am4_orig.lon;
am4_clasp_lndlm.land_mask = am4_orig.land_mask;
am4_clasp_lndlm.area = area_am4;

G=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/G_param_diu.nc',...
          'G_param');

std_t=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/std_t_ca_diu.nc',...
          'std_t_ca');

std_shflx=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/std_fluxt_diu.nc',...
          'std_fluxt');

au = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/frac_up_diu.nc',...
          'frac_up');

lm = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/het_lm_out_diu.nc',...
          'het_lm_out');

precip = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/precip_diu.nc',...
          'precip');

precip_ncep = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/precip_diu.nc',...
          'precip');

precip_am4 = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/precip_diu.nc',...
          'precip');

shflx_diu = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/shflx_diu.nc',...
          'shflx');

precip_conv = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/prec_conv_diu.nc',...
          'prec_conv');

precip_ncep_conv = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/prec_conv_diu.nc',...
          'prec_conv');

precip_am4_conv = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/prec_conv_diu.nc',...
          'prec_conv');


lca = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/low_cld_amt_diu.nc',...
          'low_cld_amt');

lca_ncep = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/low_cld_amt_diu.nc',...
          'low_cld_amt');

fpath='./'; expn='LM4';
do_print = 0;    % set do_print = 1 to output as EPS files.



s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;
s.s1='(a) $F_{E}$ (LM4-RSL-CSL)';
s.s2='(b) $\Delta F_{E}$ (LM4-RSL-CSL $-$ LM4)';
s.s3='(c) $\Delta F_{E}$ (LM4-RSL $-$ LM4)';
s.s4='(d) $F_{H}$ (LM4-RSL-CSL)';
s.s5='(e) $\Delta F_{H}$ (LM4-RSL-CSL $-$ LM4)';
s.s6='(f) $\Delta F_{H}$ (LM4-RSL $-$ LM4)';


% --- datasets ---
z1 = squeeze(mean(mean(std_t,3,'omitnan'),4,'omitnan'))';
z2 = squeeze(mean(mean(std_shflx,3,'omitnan'),4,'omitnan'))';
z3 = squeeze(mean(mean(G,3,'omitnan'),4,'omitnan'))';
z4 = squeeze(mean(mean(au,3,'omitnan'),4,'omitnan'))';
z5 = squeeze(mean(mean(precip,3,'omitnan'),4,'omitnan'))';
z6 = squeeze(mean(mean(precip_ncep,3,'omitnan'),4,'omitnan'))';
z7 = squeeze(mean(mean(precip_am4,3,'omitnan'),4,'omitnan'))';
z8 = squeeze(mean(mean(shflx_diu,3,'omitnan'),4,'omitnan'))';

z11=squeeze(mean(reshape(std_t,288,180,24,12,[]),5,'omitnan'));
z11_jja=squeeze(mean(z11(:,:,:,6:8),4,'omitnan'));

z22=squeeze(mean(reshape(std_shflx,288,180,24,12,[]),5,'omitnan'));
z22_jja=squeeze(mean(z22(:,:,:,6:8),4,'omitnan'));
z22_djf=squeeze(mean(z22(:,:,:,1:2),4,'omitnan'));

z33=squeeze(mean(reshape(G,288,180,24,12,[]),5,'omitnan'));
z33_jja=squeeze(mean(z33(:,:,:,6:8),4,'omitnan'));

z44=squeeze(mean(reshape(au,288,180,24,12,[]),5,'omitnan'));
z44_jja=squeeze(mean(z44(:,:,:,6:8),4,'omitnan'));
z44_djf=squeeze(mean(z44(:,:,:,1:2),4,'omitnan'));

z55=squeeze(mean(reshape(precip,288,180,24,12,[]),5,'omitnan'));
z55_jja=squeeze(mean(z55(:,:,:,6:8),4,'omitnan'));

z66=squeeze(mean(reshape(precip_ncep,288,180,24,12,[]),5,'omitnan'));
z66_jja=squeeze(mean(z66(:,:,:,6:8),4,'omitnan'));

z77=squeeze(mean(reshape(precip_am4,288,180,24,12,[]),5,'omitnan'));
z77_jja=squeeze(mean(z77(:,:,:,6:8),4,'omitnan'));

z88=squeeze(mean(reshape(shflx_diu,288,180,24,12,[]),5,'omitnan'));
z88_jja=squeeze(mean(z88(:,:,:,6:8),4,'omitnan'));

aa=s.aa;
lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
domap='robinson';
%domap='trystan';

s.ce=[0 3];   s.vbino1=[s.ce(1):0.2:s.ce(2)]; s.unit='(K)';
s.cerange=[0 40]; s.vbino2 =[s.cerange(1):5:s.cerange(2)];
s.ch=[0 100];    s.vbino3 =[s.ch(1):5:s.ch(2)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pms=[ 20, 200, 1500, 850];
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=-0.01; y0=0.64; wx=0.3; wy=0.35; dx=0.036; dy=0.08;
p1= [x0,            y0,            wx, wy];
p2= [x0+wx+dx,      y0,            wx, wy];
p3= [x0+2.*(wx+dx), y0,            wx, wy];
p4= [0.065,          0.42,          0.23, 0.2];
p5= [0.385,          0.42,          0.23, 0.2];
p6= [0.705,           0.42,          0.23, 0.2];
p7= [0.065,          0.1,          0.23, 0.2];
p8= [0.385,          0.1,          0.23, 0.2];
p9= [0.705,           0.1,          0.23, 0.2];

nn=30;

cmap1=bluewhitered(nn);
cmap=jet(nn);

pos1=[0.28    0.71  0.015 0.21 ];%[left bottom width height];
pos2=[0.615   0.71  0.015 0.21 ];%[left bottom width height];
pos3=[0.95    0.71  0.015 0.21 ];%[left bottom width height];


ax1=subplot('Position',p1); clear a; a=z1;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[0:0.1:2], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([0 2]);
colormap(ax1,cmap);
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16);
h1.Ticks = [0 0.5 1 1.5 2];
h1.TickLabels = {'0','0.5','1','1.5','2'};
set(get(h1,'Title') ,'String','^{\circ}C');
title({'(a) \sigma (T_{s})'},'FontSize',14);
%-------------------------------------------

ax2=subplot('Position',p2); clear a; a=z2;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[0:2:30], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([0 30]);
colormap(ax2,cmap);
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [0 10 20 30];
h2.TickLabels = {'0','10','20','30'};
set(get(h2,'Title') ,'String','W/m^{2}');
title({'(b) \sigma (F_{H})'},'FontSize',14);

ax3=subplot('Position',p3); clear a; a=z3;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[0:5:100], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([0 100]);
colormap(ax3,cmap);
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [0 20 40 60 80 100];
h3.TickLabels = {'0','20','40','60','80','100'};
%set(get(h3,'Title') ,'String','-');
title({'(c) Heterogeneity parameter G'},'FontSize',14)

%------------------------------
ax4=subplot('Position',p4);
t_axis=1:1:24;
id1 = find(lon>=250 & lon<=254);
id2 = find(lat>30 & lat<35);

au_westUS=squeeze(mean(mean(z44_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));
shflx_westUS=squeeze(mean(mean(z22_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));

xis=gca;
ax4.FontSize = 16;
yyaxis left
plot(t_axis,circshift(au_westUS,-8),'b-o','linewidth',1.25)
xis.YAxis(1).Color = 'k';
xis.YAxis(1).Limits = ([0, 0.2]);
yticks([0 0.05 0.1 0.15 0.2])
yticklabels({'0' '0.05' '0.1' '0.15' '0.2'})
ylabel('a_{u} (-)','FontSize',16)

yyaxis right
plot(t_axis,circshift(shflx_westUS,-8),'r-x','linewidth',1.25)
xis.YAxis(2).Color = 'k';

xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
hh=legend('a_{u}','\sigma (F_{H})');
set(hh,'Orientation','Vertical','Position',[0.0751437593020475 0.55299366974578 0.0531525369942488 0.0574509810653386],...
'box','off','FontSize',16)
xis.YAxis(2).Limits = ([0, 100]);
yticks([0 25 50 75 100 ])
yticklabels({'0' '25' '50' '75' '100'})

title('(d) Western US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');


%-----------------------------------------------

ax5=subplot('Position',p5);
t_axis=1:1:24;

clear id1 id2
id1 = find(lon>=263 & lon<=267);
id2 = find(lat>36 & lat<40);

au_centUS=squeeze(mean(mean(z44_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));
shflx_centUS=squeeze(mean(mean(z22_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));
xis=gca;
ax5.FontSize = 16;
yyaxis left
plot(t_axis,circshift(au_centUS,-6),'b-o','linewidth',1.25)
xis.YAxis(1).Color = 'k';
xis.YAxis(1).Limits = ([0, 0.2]);
yticks([0 0.05 0.1 0.15 0.2])
yticklabels({'0' '0.05' '0.1' '0.15' '0.2'})

yyaxis right
plot(t_axis,circshift(shflx_centUS,-6),'r-x','linewidth',1.25)
xis.YAxis(2).Color = 'k';
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
xis.YAxis(2).Limits = ([0, 100]);
yticks([0 25 50 75 100 ])
yticklabels({'0' '25' '50' '75' '100'})

title('(e) Central US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
%set(gca,'TickLabelInterpreter','latex')

%-----------------------------------------------

%-----------------------------------------------

ax6=subplot('Position',p6);
t_axis=1:1:24;
clear id1 id2

id1 = find(lon>=279 & lon<=283);
id2 = find(lat>30 & lat<35);

au_eastUS=squeeze(mean(mean(z44_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));
shflx_eastUS=squeeze(mean(mean(z22_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));

%au_eastUS=squeeze(mean(mean(z44_jja(225-3:225+3,127-3:127+3,:),1,'omitnan'),2,'omitnan'));
%shflx_eastUS=squeeze(mean(mean(z22_jja(225-3:225+3,127-3:127+3,:),1,'omitnan'),2,'omitnan'));
xis=gca;
ax6.FontSize = 16;
yyaxis left
plot(t_axis,circshift(au_eastUS,-5),'b-o','linewidth',1.25)
xis.YAxis(1).Color = 'k';
xis.YAxis(1).Limits = ([0, 0.2]);
yticks([0 0.05 0.1 0.15 0.2])
yticklabels({'0' '0.05' '0.1' '0.15' '0.2'})

yyaxis right
plot(t_axis,circshift(shflx_eastUS,-5),'r-x','linewidth',1.25)
xis.YAxis(2).Color = 'k';
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
xis.YAxis(2).Limits = ([0, 100]);
yticks([0 25 50 75 100 ])
yticklabels({'0' '25' '50' '75' '100'})
ylabel('\sigma (F_{H}) (W/m^{2})','FontSize',16)

title('(f) Eastern US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
%set(gca,'TickLabelInterpreter','latex')

%-----------------------------------------------

ax7=subplot('Position',p7);
t_axis=1:1:24;
clear id1 id2
id1 = find(lon>=300 & lon<=304);
id2 = find(lat>-2 & lat<2);
au_amazon=squeeze(mean(mean(z44_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));
shflx_amazon=squeeze(mean(mean(z22_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));

%au_amazon=squeeze(mean(mean(z44_jja(238-2:238+2,85-2:85+2,:),1,'omitnan'),2,'omitnan'));
%shflx_amazon=squeeze(mean(mean(z22_jja(238-2:238+2,85-2:85+2,:),1,'omitnan'),2,'omitnan'));

xis=gca;
ax7.FontSize = 16;
yyaxis left
plot(t_axis,circshift(au_amazon,-3),'b-o','linewidth',1.25)
xis.YAxis(1).Color = 'k';
ylabel('a_{u} (-)','FontSize',16)
xis.YAxis(1).Limits = ([0, 0.2]);
yticks([0 0.05 0.1 0.15 0.2])
yticklabels({'0' '0.05' '0.1' '0.15' '0.2'})

yyaxis right
plot(t_axis,circshift(shflx_amazon,-3),'r-x','linewidth',1.25)
xis.YAxis(2).Color = 'k';
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
xlabel('Time (LST)','FontSize',16)
xis.YAxis(2).Limits = ([0, 100]);
yticks([0 25 50 75 100 ])
yticklabels({'0' '25' '50' '75' '100'})


title('(g) Amazon','FontSize',14)
%set(get(gca,'title'),'Units', 'normalized','Position',[0.5, 0.8, 0.95])
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
%set(gca,'TickLabelInterpreter','latex')

%-----------------------------------------------

%-----------------------------------------------

ax8=subplot('Position',p8);
t_axis=1:1:24;
clear id1 id2

id1 = find(lon>=31 & lon<35);
id2 = find(lat>6 & lat<9);

au_centA=squeeze(mean(mean(z44_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));
shflx_centA=squeeze(mean(mean(z22_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));

%au_centA=squeeze(mean(mean(z44_jja(20-2:20+2,86-2:86+2,:),1,'omitnan'),2,'omitnan'));
%shflx_centA=squeeze(mean(mean(z22_jja(20-2:20+2,86-2:86+2,:),1,'omitnan'),2,'omitnan'));
xis=gca;
ax8.FontSize = 16;
yyaxis left
plot(t_axis,0.015+circshift(au_centA,+3),'b-o','linewidth',1.25)
xis.YAxis(1).Color = 'k';
xis.YAxis(1).Limits = ([0, 0.2]);
yticks([0 0.05 0.1 0.15 0.2])
yticklabels({'0' '0.05' '0.1' '0.15' '0.2'})

yyaxis right
plot(t_axis,circshift(shflx_centA,+3),'r-x','linewidth',1.25)
xis.YAxis(2).Color = 'k';
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
xlabel('Time (LST)','FontSize',16)
xis.YAxis(2).Limits = ([0, 100]);
yticks([0 25 50 75 100 ])
yticklabels({'0' '25' '50' '75' '100'})


title('(h) Tropical Africa','FontSize',14)
%set(get(gca,'title'),'Units', 'normalized','Position',[0.5, 0.8, 0.95])
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
%set(gca,'TickLabelInterpreter','latex')

%-----------------------------------------------

ax9=subplot('Position',p9);
t_axis=1:1:24;
clear id1 id2

id1 = find(lon>=100 & lon<104);
id2 = find(lat>10 & lat<14);

au_india=squeeze(mean(mean(z44_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));
shflx_india=squeeze(mean(mean(z22_jja(id1,id2,:),1,'omitnan'),2,'omitnan'));

%au_india=squeeze(mean(mean(z44_jja(62-2:62+2,107-2:107+2,:),1,'omitnan'),2,'omitnan'));
%shflx_india=squeeze(mean(mean(z22_jja(62-2:62+2,107-2:107+2,:),1,'omitnan'),2,'omitnan'));
xis=gca;
ax9.FontSize = 16;
yyaxis left
plot(t_axis,circshift(au_india,+7),'b-o','linewidth',1.25)
xis.YAxis(1).Color = 'k';
xis.YAxis(1).Limits = ([0, 0.2]);
yticks([0 0.05 0.1 0.15 0.2])
yticklabels({'0' '0.05' '0.1' '0.15' '0.2'})

yyaxis right
plot(t_axis,circshift(shflx_india,+7),'r-x','linewidth',1.25)
xis.YAxis(2).Color = 'k';
ylabel('\sigma (F_{H}) (W/m^{2})','FontSize',16)
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])

xlabel('Time (LST)','Interpreter','latex','FontSize',16)
xis.YAxis(2).Limits = ([0, 100]);
yticks([0 25 50 75 100 ])
yticklabels({'0' '25' '50' '75' '100'})


title('(i) East Asia','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
%set(gca,'TickLabelInterpreter','latex')

%-----------------------------------------------

cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'hetmeasures_clasp.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%----