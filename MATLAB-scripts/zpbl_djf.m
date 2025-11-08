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


zpbl_clasp = reshape(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/z_pbl_diu.nc',...
          'z_pbl'),288,180,24,12,[]);

zpbl_claspnolm = reshape(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_zas/z_pbl_diu.nc',...
          'z_pbl'),288,180,24,12,[]);

zpbl_ncep = reshape(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/z_pbl_diu.nc',...
          'z_pbl'),288,180,24,12,[]);

zpbl_am4 = reshape(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/z_pbl_diu.nc',...
          'z_pbl'),288,180,24,12,[]);


zpblRi_clasp = reshape(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/z_Ri_025_diu.nc',...
          'z_Ri_025'),288,180,24,12,[]);

zpblRi_claspnolm = reshape(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_zas/z_Ri_025_diu.nc',...
          'z_Ri_025'),288,180,24,12,[]);

zpblRi_ncep = reshape(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/z_Ri_025_diu.nc',...
          'z_Ri_025'),288,180,24,12,[]);

zpblRi_am4 = reshape(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/z_Ri_025_diu.nc',...
          'z_Ri_025'),288,180,24,12,[]);
%----------
zpbl_clasp2y = squeeze(mean(zpbl_clasp(:,:,:,:,1:2),5,'omitnan'));
zpbl_claspnolm2y = squeeze(mean(zpbl_claspnolm(:,:,:,:,1:2),5,'omitnan'));
zpbl_ncep2y = squeeze(mean(zpbl_ncep(:,:,:,:,1:2),5,'omitnan'));
zpbl_am42y = squeeze(mean(zpbl_am4(:,:,:,:,1:2),5,'omitnan'));

zpbl_clasp = squeeze(mean(zpbl_clasp(:,:,:,:,:),5,'omitnan'));
zpbl_claspnolm = squeeze(mean(zpbl_claspnolm(:,:,:,:,:),5,'omitnan'));
zpbl_ncep = squeeze(mean(zpbl_ncep(:,:,:,:,:),5,'omitnan'));
zpbl_am4 = squeeze(mean(zpbl_am4(:,:,:,:,:),5,'omitnan'));

%-----------------


%---------------------------
zpbl_clasp_ann = squeeze(mean(mean(zpbl_clasp,3,'omitnan'),4,'omitnan'))';
zpbl_claspnolm_ann = squeeze(mean(mean(zpbl_claspnolm,3,'omitnan'),4,'omitnan'))';
zpbl_ncep_ann = squeeze(mean(mean(zpbl_ncep,3,'omitnan'),4,'omitnan'))';
zpbl_am4_ann = squeeze(mean(mean(zpbl_am4,3,'omitnan'),4,'omitnan'))';

zpbl_clasp_jja = squeeze(mean(mean(zpbl_clasp(:,:,:,6:8),3,'omitnan'),4,'omitnan'))';
zpbl_claspnolm_jja = squeeze(mean(mean(zpbl_claspnolm(:,:,:,6:8),3,'omitnan'),4,'omitnan'))';
zpbl_ncep_jja = squeeze(mean(mean(zpbl_ncep(:,:,:,6:8),3,'omitnan'),4,'omitnan'))';
zpbl_am4_jja = squeeze(mean(mean(zpbl_am4(:,:,:,6:8),3,'omitnan'),4,'omitnan'))';

zpbl_clasp_djf = squeeze(mean(mean(zpbl_clasp(:,:,:,1:2),3,'omitnan'),4,'omitnan'))';
zpbl_claspnolm_djf = squeeze(mean(mean(zpbl_claspnolm(:,:,:,1:2),3,'omitnan'),4,'omitnan'))';
zpbl_ncep_djf = squeeze(mean(mean(zpbl_ncep(:,:,:,1:2),3,'omitnan'),4,'omitnan'))';
zpbl_am4_djf = squeeze(mean(mean(zpbl_am4(:,:,:,1:2),3,'omitnan'),4,'omitnan'))';


land_frac_diu = repmat(land_frac,1,1,24);

zpbl_clasp_jja_diur = squeeze(mean(zpbl_clasp2y(:,:,:,1:2),4,'omitnan'));
zpbl_clasp_jja_diur (land_frac_diu<0.4)=NaN;

zpbl_claspnolm_jja_diur = squeeze(mean(zpbl_claspnolm2y(:,:,:,1:2),4,'omitnan'));
zpbl_claspnolm_jja_diur (land_frac_diu<0.4)=NaN;

zpbl_ncep_jja_diur = squeeze(mean(zpbl_ncep2y(:,:,:,1:2),4,'omitnan'));
zpbl_ncep_jja_diur (land_frac_diu<0.4)=NaN;

zpbl_am4_jja_diur = squeeze(mean(zpbl_am42y(:,:,:,1:2),4,'omitnan'));
zpbl_am4_jja_diur (land_frac_diu<0.4)=NaN;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;
aa=s.aa;
lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
domap='robinson';
%domap='trystan';

s.ce=[0 3];   s.vbino1=[s.ce(1):0.2:s.ce(2)]; s.unit='(K)';
s.cerange=[0 40]; s.vbino2 =[s.cerange(1):5:s.cerange(2)];
s.ch=[0 100];    s.vbino3 =[s.ch(1):5:s.ch(2)];

pms=[ 100, 200, 1800, 1000];
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=-0.01; y0=0.625; wx=0.26; wy=0.30; dx=0.036; dy=0.08;
p1= [-0.01,         0.65,            wx, wy];
p2= [0.33,           0.65,            wx, wy];
p3= [0.68,           0.65,            wx, wy];
p4= [0.065,          0.42,          0.23, 0.2];
p5= [0.40,          0.42,          0.23, 0.2];
p6= [0.72,          0.42,         0.23, 0.2];
p7= [0.065,          0.1,           0.23, 0.2];
p8= [0.40,          0.1,           0.23, 0.2];
p9= [0.72,          0.1,          0.23, 0.2];

nn=30;

cmap1=bluewhitered(nn);
cmap=jet(nn);

pos1=[0.25    0.7  0.015 0.18 ];%[left bottom width height];
pos2=[0.59    0.7  0.015 0.18 ];%[left bottom width height];
pos3=[0.95    0.7  0.015 0.18 ];%[left bottom width height];


ax1=subplot('Position',p1); clear a; a=zpbl_clasp_djf;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[0:20:1500], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([0 1500]);
colormap(ax1,cmap);
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16);
h1.Ticks = [0 500 1000 1500];
h1.TickLabels = {'0','500','1000','1500'};
set(get(h1,'Title') ,'String','m');
title({'(a) h_{ABL}','(AM4-EDMF-HET)'},'FontSize',14);
%-------------------------------------------

ax2=subplot('Position',p2); clear a; a=zpbl_clasp_djf - zpbl_ncep_djf;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-100:5:100], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-100 100]);
colormap(ax2,bluewhitered(nn));
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-100 -50 0 50 100];
h2.TickLabels = {'-100','-50','0','50','100'};
set(get(h2,'Title') ,'String','m');
title({'(b) h_{ABL}','(AM4-EDMF-HET minus AM4-EDMF)'},'FontSize',14);

ax3=subplot('Position',p3); clear a; a=zpbl_clasp_djf - zpbl_claspnolm_djf;
axesm('MapProjection',domap,'origin',[0,180]);
framem;
contourfm(lat,lon,a,[-100:5:100], 'LineStyle', 'none'); hold on;
contourm(latx,lonx,lm,'k','LineWidth',1);
box off; axis off;
caxis([-100 100]);
colormap(ax3,bluewhitered(nn));
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-100 -50 0 50 100];
h3.TickLabels = {'-100','-50','0','50','100'};
set(get(h3,'Title') ,'String','m');
title({'(c) h_{ABL}','(AM4-EDMF-HET minus AM4-EDMF-HET-MF)'},'FontSize',14)

%------------------------------
ax4=subplot('Position',p4);
t_axis=1:1:24;
id1 = find(lon>=250 & lon<=254);
id2 = find(lat>30 & lat<35);

zpbl_clasp_jja_diur2=squeeze(mean(mean(zpbl_clasp_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_claspnolm_jja_diur2=squeeze(mean(mean(zpbl_claspnolm_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_ncep_jja_diur2=squeeze(mean(mean(zpbl_ncep_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_am4_jja_diur2=squeeze(mean(mean(zpbl_am4_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));

xis=gca;

plot(t_axis,circshift(zpbl_clasp_jja_diur2,-8),'r-o','linewidth',1.25)
hold on
plot(t_axis,circshift(zpbl_claspnolm_jja_diur2,-8),'k-x','linewidth',1.25)
plot(t_axis,circshift(zpbl_ncep_jja_diur2,-8),'b->','linewidth',1.25)
plot(t_axis,circshift(zpbl_am4_jja_diur2,-8),'g-s','linewidth',1.25)
ylim([0 1000])
yticks([0 250 500 750 1000])
yticklabels({'0' '250'  '500' '750' '1000'})
ylabel('h_{ABL} (m)','FontSize',16)
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ax4.FontSize = 16;
hh=legend('AM4-EDMF-HET','AM4-EDMF-HET-MF','AM4-EDMF','AM4-Lock');
set(hh,'Orientation','Vertical','Position',[0.4401437593020475 0.54299366974578 0.0531525369942488 0.0574509810653386],...
'box','off','FontSize',16)

title('(d) Western US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');


%-----------------------------------------------

ax5=subplot('Position',p5);
t_axis=1:1:24;

clear id1 id2
id1 = find(lon>=263 & lon<=267);
id2 = find(lat>36 & lat<40);

zpbl_clasp_jja_diur2=squeeze(mean(mean(zpbl_clasp_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_claspnolm_jja_diur2=squeeze(mean(mean(zpbl_claspnolm_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_ncep_jja_diur2=squeeze(mean(mean(zpbl_ncep_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_am4_jja_diur2=squeeze(mean(mean(zpbl_am4_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));

xis=gca;

plot(t_axis,circshift(zpbl_clasp_jja_diur2,-6),'r-o','linewidth',1.25)
hold on
plot(t_axis,circshift(zpbl_claspnolm_jja_diur2,-6),'k-x','linewidth',1.25)
plot(t_axis,circshift(zpbl_ncep_jja_diur2,-6),'b->','linewidth',1.25)
plot(t_axis,circshift(zpbl_am4_jja_diur2,-6),'g-s','linewidth',1.25)
ylim([0 2000])
yticks([0 500 1000 1500 2000])
yticklabels({'0' '500' '1000' '1500' '2000'})

xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])

ax5.FontSize = 16;
title('(e) Central US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
%-----------------------------------------------

%-----------------------------------------------

ax6=subplot('Position',p6);
t_axis=1:1:24;
clear id1 id2

id1 = find(lon>=279 & lon<=283);
id2 = find(lat>30 & lat<35);

zpbl_clasp_jja_diur2=squeeze(mean(mean(zpbl_clasp_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_claspnolm_jja_diur2=squeeze(mean(mean(zpbl_claspnolm_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_ncep_jja_diur2=squeeze(mean(mean(zpbl_ncep_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_am4_jja_diur2=squeeze(mean(mean(zpbl_am4_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));

xis=gca;

plot(t_axis,circshift(zpbl_clasp_jja_diur2,-5),'r-o','linewidth',1.25)
hold on
plot(t_axis,circshift(zpbl_claspnolm_jja_diur2,-5),'k-x','linewidth',1.25)
plot(t_axis,circshift(zpbl_ncep_jja_diur2,-5),'b->','linewidth',1.25)
plot(t_axis,circshift(zpbl_am4_jja_diur2,-5),'g-s','linewidth',1.25)
ylim([0 1000])
yticks([0 250 500 750 1000])
yticklabels({'0' '250' '500' '750' '1000'})
%ylabel('h_{ABL} (m)','FontSize',16)
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ax6.FontSize = 16;

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
zpbl_clasp_jja_diur2=squeeze(mean(mean(zpbl_clasp_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_claspnolm_jja_diur2=squeeze(mean(mean(zpbl_claspnolm_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_ncep_jja_diur2=squeeze(mean(mean(zpbl_ncep_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_am4_jja_diur2=squeeze(mean(mean(zpbl_am4_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));

xis=gca;

plot(t_axis,circshift(zpbl_clasp_jja_diur2,-3),'r-o','linewidth',1.25)
hold on
plot(t_axis,circshift(zpbl_claspnolm_jja_diur2,-3),'k-x','linewidth',1.25)
plot(t_axis,circshift(zpbl_ncep_jja_diur2,-3),'b->','linewidth',1.25)
plot(t_axis,circshift(zpbl_am4_jja_diur2,-3),'g-s','linewidth',1.25)
ylim([0 1500])
yticks([0 500 1000 1500])
yticklabels({'0' '500' '1000' '1500'})
ylabel('h_{ABL} (m)','FontSize',16)
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ax7.FontSize = 16;
xlabel('Time (LST)','Interpreter','latex','FontSize',16)
title('(g) Amazon','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');

%-----------------------------------------------

%-----------------------------------------------

ax8=subplot('Position',p8);
t_axis=1:1:24;
clear id1 id2

id1 = find(lon>=31 & lon<35);
id2 = find(lat>6 & lat<9);

zpbl_clasp_jja_diur2=squeeze(mean(mean(zpbl_clasp_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_claspnolm_jja_diur2=squeeze(mean(mean(zpbl_claspnolm_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_ncep_jja_diur2=squeeze(mean(mean(zpbl_ncep_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_am4_jja_diur2=squeeze(mean(mean(zpbl_am4_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));

xis=gca;

plot(t_axis,circshift(zpbl_clasp_jja_diur2,+3),'r-o','linewidth',1.25)
hold on
plot(t_axis,circshift(zpbl_claspnolm_jja_diur2,+3),'k-x','linewidth',1.25)
plot(t_axis,circshift(zpbl_ncep_jja_diur2,+3),'b->','linewidth',1.25)
plot(t_axis,circshift(zpbl_am4_jja_diur2,+3),'g-s','linewidth',1.25)
ylim([0 1000])
yticks([0 250 500 750 1000])
yticklabels({'0' '250' '500' '750' '1000'})
%ylabel('h_{ABL} (m)','FontSize',16)
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ax8.FontSize = 16;
xlabel('Time (LST)','Interpreter','latex','FontSize',16)
title('(h) Tropical Africa','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');

%-----------------------------------------------

ax9=subplot('Position',p9);
t_axis=1:1:24;
clear id1 id2

id1 = find(lon>=100 & lon<104);
id2 = find(lat>10 & lat<14);

zpbl_clasp_jja_diur2=squeeze(mean(mean(zpbl_clasp_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_claspnolm_jja_diur2=squeeze(mean(mean(zpbl_claspnolm_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_ncep_jja_diur2=squeeze(mean(mean(zpbl_ncep_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));
zpbl_am4_jja_diur2=squeeze(mean(mean(zpbl_am4_jja_diur(id1,id2,:),1,'omitnan'),2,'omitnan'));

xis=gca;

plot(t_axis,circshift(zpbl_clasp_jja_diur2,+7),'r-o','linewidth',1.25)
hold on
plot(t_axis,circshift(zpbl_claspnolm_jja_diur2,+7),'k-x','linewidth',1.25)
plot(t_axis,circshift(zpbl_ncep_jja_diur2,+7),'b->','linewidth',1.25)
plot(t_axis,circshift(zpbl_am4_jja_diur2,+7),'g-s','linewidth',1.25)
ylim([0 1000])
yticks([0 250 500 750 1000])
yticklabels({'0' '250' '500' '750' '1000'})
%ylabel('h_{ABL} (m)','FontSize',16)
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ax9.FontSize = 16;
xlabel('Time (LST)','Interpreter','latex','FontSize',16)

title('(i) East Asia','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');

%-----------------------------------------------


cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'zpbl_diurnal_map_djf.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%----