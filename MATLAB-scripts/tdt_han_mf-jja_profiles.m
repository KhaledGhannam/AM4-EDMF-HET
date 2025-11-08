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

s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;



pfull_clasp = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/Mu_han_lev.nc','pfull'));



%tdt = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/tdt_vdif_lev.nc',...
%          'tdt_vdif');
%
%tdt_nolm = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_zas/tdt_vdif_lev.nc',...
%          'tdt_vdif');
%
%tdt_ncep = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/tdt_vdif_lev.nc',...
%          'tdt_vdif');
%
%tdt_am4 = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/tdt_vdif_lev.nc',...
%          'tdt_vdif');



%tdt = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/tdt_han_lev.nc',...
%          'tdt_han');
%
%tdt_nolm = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_zas/tdt_han_lev.nc',...
%          'tdt_han');
%
%tdt_ncep = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/tdt_han_lev.nc',...
%          'tdt_han');
%
%tdt_am4 = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/tdt_vdif_lev.nc',...
%          'tdt_vdif');


tdt = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/tdt_mf_han_lev.nc',...
          'tdt_mf_han');

tdt_nolm = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_zas/tdt_mf_han_lev.nc',...
          'tdt_mf_han');

tdt_ncep = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/tdt_mf_han_lev.nc',...
          'tdt_mf_han');

tdt_am4 = 3600.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/tdt_vdif_lev.nc',...
          'tdt_vdif');


xx=repmat(land_frac,1,1,33,420);

tdt_land = tdt; tdt_land(xx<0.4)=NaN;
tdt_nolm_land = tdt_nolm; tdt_nolm_land(xx<0.4)=NaN;
tdt_ncep_land = tdt_ncep; tdt_ncep_land(xx<0.4)=NaN;
tdt_am4_land = tdt_am4; tdt_am4_land(xx<0.4)=NaN;


% --- western US ----
id1 = find(lon>=250 & lon<=254);
id2 = find(lat>30 & lat<35);


%  -------- JJA profiles -------
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

%  -------- DJF profiles -------
clear tmp;
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));



pms=[ 20, 200, 2000, 900];
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');

x0=0.05; y0=0.70; wx=0.25; wy=0.3; dx=0.025; dy=0.15;
p1= [0.05,         0.6,     wx, wy];
p2= [0.39,         0.6,     wx, wy];
p3= [0.72,         0.6,     wx, wy];
p4= [0.05,         0.12,    wx, wy];
p5= [0.39,         0.12,    wx, wy];
p6= [0.72,         0.12,    wx, wy];

% ---------
ax1=subplot('Position',p1);
t_axis=1:1:24;
xis=gca;

max_h = 17;

line1 = plot(1.*(tdt_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(1.*(tdt_nolm_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'k-x','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET-MF');
line3 = plot(1.*(tdt_ncep_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
%line4 = plot(1.*(tdt_am4_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');

plot([0 0],[500 1000],'k--')
set(ax1, 'YDir', 'reverse');
%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);

hh=legend([line1 line2 line3]);
set(hh,'Orientation','Vertical','Position',[0.035 0.78 0.195075760569109 0.122674420939227],...
    'box','off','Fontsize',16)

xlim([-0.4 0.15])
xticks([-0.4 -0.3 -0.2 -0.1 0 0.1])
xticklabels({'-0.4','-0.3','-0.2','-0.1','0','0.1'})

%yticklabels({'0', '0.5', '1','1.5'})
ylabel('Pressure (hPa)','FontSize',16)
xlabel('T tendency (K/hr)','FontSize',16)
title('(a) Western US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------


% --- central US ----
id1 = find(lon>=263 & lon<=267);
id2 = find(lat>36 & lat<40);

%  -------- JJA profiles -------
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

%  -------- DJF profiles -------
clear tmp;
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%------------

max_h = 12;

ax2=subplot('Position',p2);
t_axis=1:1:24;
xis=gca;
line1 = plot(1.*(tdt_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(1.*(tdt_nolm_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'k-x','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
line3 = plot(1.*(tdt_ncep_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
%line4 = plot(1.*(tdt_am4_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');
plot([0 0],[700 1000],'k--')
set(ax2, 'YDir', 'reverse');
%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xlim([-0.2 0.1])
xticks([-0.2 -0.1 0 0.1 ])
xticklabels({'-0.2','-0.1','0','0.1'})

ylabel('Pressure (hPa)','FontSize',16)
xlabel('T tendency (K/hr)','FontSize',16)
title('(b) Central US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------


% --- Eastern US ----
id1 = find(lon>=279 & lon<=283);
id2 = find(lat>30 & lat<35);

%  -------- JJA profiles -------
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

%  -------- DJF profiles -------
clear tmp;
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%------------

ax3=subplot('Position',p3);
t_axis=1:1:24;
xis=gca;
line1 = plot(1.*(tdt_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(1.*(tdt_nolm_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'k-x','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
line3 = plot(1.*(tdt_ncep_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
%line4 = plot(1.*(tdt_am4_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');
plot([0 0],[700 1000],'k--')
set(ax3, 'YDir', 'reverse');
%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xlim([-0.15 0.1])
xticks([-0.1 0 0.1 ])
xticklabels({'-0.1','0','0.1'})

%ylim([0 1.5])
%yticks([0 0.5 1 1.5])
%yticklabels({'0', '0.5', '1','1.5'})
ylabel('Pressure (hPa)','FontSize',16)
xlabel('T tendency (K/hr)','FontSize',16)
title('(c) Eastern US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------


% --- Amazon ----
id1 = find(lon>=300 & lon<=304);
id2 = find(lat>-2 & lat<2);

%  -------- JJA profiles -------
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

%  -------- DJF profiles -------
clear tmp;
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%------------

ax4=subplot('Position',p4);
t_axis=1:1:24;
xis=gca;
line1 = plot(1.*(tdt_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(1.*(tdt_nolm_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'k-x','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
line3 = plot(1.*(tdt_ncep_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
%line4 = plot(1.*(tdt_am4_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');
plot([0 0],[700 1000],'k--')
set(ax4, 'YDir', 'reverse');
%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xlim([-0.15 0.1])
xticks([-0.1 0 0.1 ])
xticklabels({'-0.1','0','0.1'})
%ylim([0 1.5])
%yticks([0 0.5 1 1.5])
%yticklabels({'0', '0.5', '1','1.5'})
ylabel('Pressure (hPa)','FontSize',16)
xlabel('T tendency (K/hr)','FontSize',16)
title('(d) Amazon','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------



% --- Central africa ----
id1 = find(lon>=31 & lon<35);
id2 = find(lat>6 & lat<9);

%  -------- JJA profiles -------
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

%  -------- DJF profiles -------
clear tmp;
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%------------

ax5=subplot('Position',p5);
t_axis=1:1:24;
xis=gca;
line1 = plot(1.*(tdt_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(1.*(tdt_nolm_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'k-x','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
line3 = plot(1.*(tdt_ncep_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
%line4 = plot(1.*(tdt_am4_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');
plot([0 0],[700 1000],'k--')
set(ax5, 'YDir', 'reverse');
%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xlim([-0.15 0.1])
xticks([-0.1 0 0.1 ])
xticklabels({'-0.1','0','0.1'})
%ylim([0 1.5])
%yticks([0 0.5 1 1.5])
%yticklabels({'0', '0.5', '1','1.5'})
ylabel('Pressure (hPa)','FontSize',16)
xlabel('T tendency (K/hr)','FontSize',16)
title('(e) Tropical Africa','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------


% --- East Asia ----
id1 = find(lon>=100 & lon<104);
id2 = find(lat>10 & lat<14);

%  -------- JJA profiles -------
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

%  -------- DJF profiles -------
clear tmp;
tmp = reshape(tdt_land,288,180,33,12,35);
tdt_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_nolm_land,288,180,33,12,35);
tdt_nolm_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_ncep_land,288,180,33,12,35);
tdt_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(tdt_am4_land,288,180,33,12,35);
tdt_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,1:2),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%------------

ax6=subplot('Position',p6);
t_axis=1:1:24;
xis=gca;
line1 = plot(1.*(tdt_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(1.*(tdt_nolm_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'k-x','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
line3 = plot(1.*(tdt_ncep_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
%line4 = plot(1.*(tdt_am4_land_jja(end-max_h:end-1)),1.*(pfull_clasp(end-max_h:end-1)),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');
plot([0 0],[700 1000],'k--')
set(ax6, 'YDir', 'reverse');
%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xlim([-0.1 0.15])
xticks([-0.1 0 0.1])
xticklabels({'-0.1','0','0.1'})
%ylim([0 1.5])
%yticks([0 0.5 1 1.5])
%yticklabels({'0', '0.5', '1','1.5'})
ylabel('Pressure (hPa)','FontSize',16)
xlabel('T tendency (K/hr)','FontSize',16)
title('(f) East Asia','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------



cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'tdt_hanmf_jja_sixprof.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%---------------