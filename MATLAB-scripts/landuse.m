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


area_crop=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/CLASP_EDMF_lnd_disp_lm_zas/gfdl.ncrc4-intel18-prod-openmp/pp/land_crop/ts/monthly/5yr/land_crop.198001-198412.area_crop.nc',...
          'area_crop');

area_ntrl=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/CLASP_EDMF_lnd_disp_lm_zas/gfdl.ncrc4-intel18-prod-openmp/pp/land_ntrl/ts/monthly/5yr/land_ntrl.198001-198412.area_ntrl.nc',...
          'area_ntrl');

area_past=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/CLASP_EDMF_lnd_disp_lm_zas/gfdl.ncrc4-intel18-prod-openmp/pp/land_past/ts/monthly/5yr/land_past.198001-198412.area_past.nc',...
          'area_past');

cellarea_land=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/CLASP_EDMF_lnd_disp_lm_zas/gfdl.ncrc4-intel18-prod-openmp/pp/land/land.static.nc',...
          'cell_area');

G=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/G_param_diu.nc',...
          'G_param');

std_t=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/std_t_ca_diu.nc',...
          'std_t_ca');

std_shflx=ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/std_fluxt_diu.nc',...
          'std_fluxt');

au = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/frac_up_diu.nc',...
          'frac_up');

shflx_diu = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/shflx_diu.nc',...
          'shflx');

precip = 86400.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/precip_diu.nc',...
          'precip');

precip_ncep = 86400.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/precip_diu.nc',...
          'precip');

precip_am4 = 86400.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/precip_diu.nc',...
          'precip');


precip_conv = 86400.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/prec_conv_diu.nc',...
          'prec_conv');

precip_ncep_conv = 86400.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/prec_conv_diu.nc',...
          'prec_conv');

precip_am4_conv = 86400.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/prec_conv_diu.nc',...
          'prec_conv');


lca = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/low_cld_amt_diu.nc',...
          'low_cld_amt');

lca_ncep = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/low_cld_amt_diu.nc',...
          'low_cld_amt');

lca_am4 = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/low_cld_amt_diu.nc',...
          'low_cld_amt');


tca = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/tot_cld_amt_diu.nc',...
          'tot_cld_amt');

tca_ncep = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/tot_cld_amt_diu.nc',...
          'tot_cld_amt');

tca_am4 = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/tot_cld_amt_diu.nc',...
          'tot_cld_amt');


zpbl = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/z_pbl_diu.nc',...
          'z_pbl');

zpbl_ncep = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/z_pbl_diu.nc',...
          'z_pbl');

zpbl_am4 = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/z_pbl_diu.nc',...
          'z_pbl');


zpblRi = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/z_Ri_025_diu.nc',...
          'z_Ri_025');

zpblRi_ncep = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/z_Ri_025_diu.nc',...
          'z_Ri_025');

zpblRi_am4 = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/z_Ri_025_diu.nc',...
          'z_Ri_025');


mu_ncep = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/Mu_han_lev.nc','Mu_han'));

mu_clasp = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/Mu_han_lev.nc','Mu_han'));

pfull_ncep = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/Mu_han_lev.nc','pfull'));

pfull_clasp = squeeze(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/Mu_han_lev.nc','pfull'));


evap = 86400.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/evap.nc',...
          'evap');

evap_ncep = 86400.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/evap.nc',...
          'evap');

evap_am4 = 86400.*ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/evap.nc',...
          'evap');


s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;




mu_clasp_ave = reshape(mu_clasp,288,180,33,12,[]);
mu_clasp_ave = squeeze(mean(mean(mean(mu_clasp_ave(:, :, end-6:end, :, :),3,'omitnan'),4,'omitnan'),5,'omitnan'));


mu_ncep_ave = reshape(mu_ncep,288,180,33,12,[]);
mu_ncep_ave = squeeze(mean(mean(mean(mu_ncep_ave(:, :, end-6:end, :, :),3,'omitnan'),4,'omitnan'),5,'omitnan'));


au_ave = squeeze(mean(mean(au(:, :, :, :),3,'omitnan'),4,'omitnan'));

precip_ave = squeeze(mean(mean(precip(:, :, :, :),3,'omitnan'),4,'omitnan'));

precip_ncep_ave = squeeze(mean(mean(precip_ncep(:, :, :, :),3,'omitnan'),4,'omitnan'));

lca_ave = squeeze(mean(mean(lca(:, :, :, :),3,'omitnan'),4,'omitnan'));

lca_ncep_ave = squeeze(mean(mean(lca_ncep(:, :, :, :),3,'omitnan'),4,'omitnan'));

tca_ave = squeeze(mean(mean(tca(:, :, :, :),3,'omitnan'),4,'omitnan'));

tca_ncep_ave = squeeze(mean(mean(tca_ncep(:, :, :, :),3,'omitnan'),4,'omitnan'));


evap_ave = squeeze(mean(evap(:, :, :),3,'omitnan'));

evap_ncep_ave = squeeze(mean(evap_ncep(:, :, :),3,'omitnan'));


area_crop_norm = squeeze(area_crop(:,:,1))./cellarea_land;
area_ntrl_norm = squeeze(area_ntrl(:,:,1))./cellarea_land;
area_past_norm = squeeze(area_past(:,:,1))./cellarea_land;

area_crop_norm(land_frac<0.4)=NaN;
area_ntrl_norm(land_frac<0.4)=NaN;
area_past_norm(land_frac<0.4)=NaN;

id_crop = find(area_crop_norm > 0.1 & area_crop_norm < 0.99);
id_ntrl = find(area_ntrl_norm > 0.1 & area_ntrl_norm < 0.99);
id_past = find(area_past_norm > 0.1 & area_past_norm < 0.99);
%------- annual mean diurnal cycles ------
xx=repmat(land_frac,1,1,24,420);

precip_land = lca; precip_land(xx<0.4)=NaN;
precip_ncep_land = lca_ncep; precip_ncep_land(xx<0.4)=NaN;
precip_am4_land = lca_am4; precip_am4_land(xx<0.4)=NaN;
precipconv_land = tca; precipconv_land(xx<0.4)=NaN;
precipconv_ncep_land = tca_ncep; precipconv_ncep_land(xx<0.4)=NaN;
precipconv_am4_land = tca_am4; precipconv_am4_land(xx<0.4)=NaN;


% --- western US ----
id1 = find(lon>=250 & lon<=254);
id2 = find(lat>30 & lat<35);

precip_land_ann = squeeze(mean(mean(mean(precip_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_ncep_land_ann = squeeze(mean(mean(mean(precip_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_am4_land_ann = squeeze(mean(mean(mean(precip_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------


precipconv_land_ann = squeeze(mean(mean(mean(precipconv_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_ncep_land_ann = squeeze(mean(mean(mean(precipconv_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_am4_land_ann = squeeze(mean(mean(mean(precipconv_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------



pms=[ 20, 200, 2000, 900];
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');

x0=0.05; y0=0.70; wx=0.25; wy=0.3; dx=0.025; dy=0.15;
p1= [0.05,         0.6,     wx, wy];
p2= [0.4,          0.6,     wx, wy];
p3= [0.72,         0.6,     wx, wy];
p4= [0.05,         0.12,    wx, wy];
p5= [0.4,          0.12,    wx, wy];
p6= [0.72,         0.12,    wx, wy];

% ---------
ax1=subplot('Position',p1);
t_axis=1:1:24;
xis=gca;
ax1.FontSize = 16;
line1 = plot(t_axis,circshift(precip_land_jja,-7),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(t_axis,circshift(precip_ncep_land_jja,-7),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
line3 = plot(t_axis,circshift(precip_am4_land_jja,-7),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');

%line4 = plot(t_axis,circshift(precipconv_land_jja,-7),'r--','linewidth',1.25);
hold on
%line5 = plot(t_axis,circshift(precipconv_ncep_land_jja,-7),'b--','linewidth',1.25);
%line6 = plot(t_axis,circshift(precipconv_am4_land_jja,-7),'g--','linewidth',1.25);

hh=legend([line1 line2 line3]);
set(hh,'Orientation','Vertical','Position',[0.15 0.78 0.195075760569109 0.122674420939227],...
    'box','off','Fontsize',16)

%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ylim([0 5])
yticks([0 2 4])
yticklabels({'0', '2', '4'})
ylabel(sprintf('LCA (%s)','%'),'FontSize',16)
xlabel('Time (LST)','FontSize',16)
title('(a) Western US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------


% --- central US ----
id1 = find(lon>=263 & lon<=267);
id2 = find(lat>36 & lat<40);

precip_land_ann = squeeze(mean(mean(mean(precip_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_ncep_land_ann = squeeze(mean(mean(mean(precip_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_am4_land_ann = squeeze(mean(mean(mean(precip_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------


precipconv_land_ann = squeeze(mean(mean(mean(precipconv_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_ncep_land_ann = squeeze(mean(mean(mean(precipconv_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_am4_land_ann = squeeze(mean(mean(mean(precipconv_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------
% ---------
ax2=subplot('Position',p2);
t_axis=1:1:24;
xis=gca;
ax2.FontSize = 16;
line1 = plot(t_axis,circshift(precip_land_jja,-5),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(t_axis,circshift(precip_ncep_land_jja,-5),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
line3 = plot(t_axis,circshift(precip_am4_land_jja,-5),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');

%line4 = plot(t_axis,circshift(precipconv_land_jja,-5),'r--','linewidth',1.25);
hold on
%line5 = plot(t_axis,circshift(precipconv_ncep_land_jja,-5),'b--','linewidth',1.25);
%line6 = plot(t_axis,circshift(precipconv_am4_land_jja,-5),'g--','linewidth',1.25);

%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ylim([0 20])
yticks([0 4 8 12 16 20])
yticklabels({'0', '4', '8','12','16','20'})
ylabel(sprintf('LCA (%s)','%'),'FontSize',16)
xlabel('Time (LST)','FontSize',16)
title('(b) Central US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------


% --- Eastern US ----
id1 = find(lon>=279 & lon<=283);
id2 = find(lat>30 & lat<35);

precip_land_ann = squeeze(mean(mean(mean(precip_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_ncep_land_ann = squeeze(mean(mean(mean(precip_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_am4_land_ann = squeeze(mean(mean(mean(precip_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------


precipconv_land_ann = squeeze(mean(mean(mean(precipconv_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_ncep_land_ann = squeeze(mean(mean(mean(precipconv_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_am4_land_ann = squeeze(mean(mean(mean(precipconv_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------
% ---------
ax3=subplot('Position',p3);
t_axis=1:1:24;
xis=gca;
ax3.FontSize = 16;
line1 = plot(t_axis,circshift(precip_land_jja,-4),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(t_axis,circshift(precip_ncep_land_jja,-4),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
line3 = plot(t_axis,circshift(precip_am4_land_jja,-4),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');

%line4 = plot(t_axis,circshift(precipconv_land_jja,-4),'r--','linewidth',1.25);
hold on
%line5 = plot(t_axis,circshift(precipconv_ncep_land_jja,-4),'b--','linewidth',1.25);
%line6 = plot(t_axis,circshift(precipconv_am4_land_jja,-4),'g--','linewidth',1.25);

%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ylim([0 30])
yticks([0 10 20 30])
yticklabels({'0', '10', '20','30'})
ylabel(sprintf('LCA (%s)','%'),'FontSize',16)
xlabel('Time (LST)','FontSize',16)
title('(c) Eastern US','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------


% --- Amazon ----
id1 = find(lon>=300 & lon<=304);
id2 = find(lat>-2 & lat<2);

precip_land_ann = squeeze(mean(mean(mean(precip_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_ncep_land_ann = squeeze(mean(mean(mean(precip_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_am4_land_ann = squeeze(mean(mean(mean(precip_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------


precipconv_land_ann = squeeze(mean(mean(mean(precipconv_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_ncep_land_ann = squeeze(mean(mean(mean(precipconv_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_am4_land_ann = squeeze(mean(mean(mean(precipconv_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------
% ---------
ax4=subplot('Position',p4);
t_axis=1:1:24;
xis=gca;
ax4.FontSize = 16;
line1 = plot(t_axis,circshift(precip_land_jja,-5),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(t_axis,circshift(precip_ncep_land_jja,-5),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
line3 = plot(t_axis,circshift(precip_am4_land_jja,-5),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');

%line4 = plot(t_axis,circshift(precipconv_land_jja,-5),'r--','linewidth',1.25);
hold on
%line5 = plot(t_axis,circshift(precipconv_ncep_land_jja,-5),'b--','linewidth',1.25);
%line6 = plot(t_axis,circshift(precipconv_am4_land_jja,-5),'g--','linewidth',1.25);

%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ylim([0 60])
yticks([0 20 40 60])
yticklabels({'0','20','40','60'})
ylabel(sprintf('LCA (%s)','%'),'FontSize',16)
xlabel('Time (LST)','FontSize',16)
title('(d) Amazon','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------



% --- Central africa ----
id1 = find(lon>=31 & lon<35);
id2 = find(lat>6 & lat<9);

precip_land_ann = squeeze(mean(mean(mean(precip_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_ncep_land_ann = squeeze(mean(mean(mean(precip_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_am4_land_ann = squeeze(mean(mean(mean(precip_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------


precipconv_land_ann = squeeze(mean(mean(mean(precipconv_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_ncep_land_ann = squeeze(mean(mean(mean(precipconv_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_am4_land_ann = squeeze(mean(mean(mean(precipconv_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------
% ---------
ax5=subplot('Position',p5);
t_axis=1:1:24;
xis=gca;
ax5.FontSize = 16;
line1 = plot(t_axis,circshift(precip_land_jja,+3),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(t_axis,circshift(precip_ncep_land_jja,+3),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
line3 = plot(t_axis,circshift(precip_am4_land_jja,+3),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');

%line4 = plot(t_axis,circshift(precipconv_land_jja,+3),'r--','linewidth',1.25);
hold on
%line5 = plot(t_axis,circshift(precipconv_ncep_land_jja,+3),'b--','linewidth',1.25);
%line6 = plot(t_axis,circshift(precipconv_am4_land_jja,+3),'g--','linewidth',1.25);

%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ylim([0 45])
yticks([0 15 30 45])
yticklabels({'0','15','30','45'})
ylabel(sprintf('LCA (%s)','%'),'FontSize',16)
xlabel('Time (LST)','FontSize',16)
title('(e) Central Africa','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------


% --- East Asia ----
id1 = find(lon>=100 & lon<104);
id2 = find(lat>10 & lat<14);

precip_land_ann = squeeze(mean(mean(mean(precip_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_ncep_land_ann = squeeze(mean(mean(mean(precip_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precip_am4_land_ann = squeeze(mean(mean(mean(precip_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precip_land,288,180,24,12,35);
precip_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_ncep_land,288,180,24,12,35);
precip_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precip_am4_land,288,180,24,12,35);
precip_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------


precipconv_land_ann = squeeze(mean(mean(mean(precipconv_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_ncep_land_ann = squeeze(mean(mean(mean(precipconv_ncep_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));
precipconv_am4_land_ann = squeeze(mean(mean(mean(precipconv_am4_land(id1,id2,:,:),1,'omitnan'),2,'omitnan'),4,'omitnan'));

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_jja = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,6:8,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------

tmp = reshape(precipconv_land,288,180,24,12,35);
precipconv_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_ncep_land,288,180,24,12,35);
precipconv_ncep_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));

clear tmp;
tmp = reshape(precipconv_am4_land,288,180,24,12,35);
precipconv_am4_land_djf = squeeze(mean(mean(mean(mean(tmp(id1,id2,:,1:2,:),1,'omitnan'),2,'omitnan'),4,'omitnan'),5,'omitnan'));
%-------
% ---------
ax6=subplot('Position',p6);
t_axis=1:1:24;
xis=gca;
ax5.FontSize = 16;
line1 = plot(t_axis,circshift(precip_land_jja,+7),'r-o','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF-HET');
hold on
line2 = plot(t_axis,circshift(precip_ncep_land_jja,+7),'b->','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-EDMF');
line3 = plot(t_axis,circshift(precip_am4_land_jja,+7),'g-s','MarkerSize',6,'linewidth',1.25,'DisplayName','AM4-Lock');

%line4 = plot(t_axis,circshift(precipconv_land_jja,+7),'r--','linewidth',1.25);
hold on
%line5 = plot(t_axis,circshift(precipconv_ncep_land_jja,+7),'b--','linewidth',1.25);
%line6 = plot(t_axis,circshift(precipconv_am4_land_jja,+7),'g--','linewidth',1.25);

%xis.YAxis(1).Color = 'k';
%xis.YAxis(1).Limits = ([0, 0.2]);
xticks([1 5 9 13 17 21])
xticklabels({'0','4','8','12','16','20'})
xlim([1 24])
ylim([0 50])
yticks([0 10 20 30 40 50])
yticklabels({'0','10','20','30','40','50'})
ylabel(sprintf('LCA (%s)','%'),'FontSize',16)
xlabel('Time (LST)','FontSize',16)
title('(f) East Asia','FontSize',14)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'TickDir','out');
set(gca,'Fontsize',16);
%-----------------------------------------------



cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'lca_diurnal_jja.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
%---------------