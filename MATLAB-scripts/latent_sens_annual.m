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

f_orig = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/shflx.nc';
f_ncep = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/shflx.nc';
f_clasp_lndlm = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/shflx.nc';

f_orig2 = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/evap.nc';
f_ncep2 = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/evap.nc';
f_clasp_lndlm2 = '/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/evap.nc';

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


am4_orig.shflx= squeeze(mean(ncread(f_orig, 'shflx'),3));
am4_ncep.shflx= squeeze(mean(ncread(f_ncep, 'shflx'),3));
am4_clasp_lndlm.shflx=squeeze(mean(ncread(f_clasp_lndlm,'shflx'),3));

am4_orig.lhflx = 2.5E06.*squeeze(mean(ncread(f_orig2, 'evap'),3));
am4_ncep.lhflx = 2.5E06.*squeeze(mean(ncread(f_ncep2, 'evap'),3));
am4_clasp_lndlm.lhflx = 2.5E06.*squeeze(mean(ncread(f_clasp_lndlm2,'evap'),3));


% --- read and interpolate era-interim sensible and latent heat fluxes ------

era.lon  = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'longitude');
era.lat  = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'latitude');

mon_wt_era = [31 (28*26+29*9)/35 31 30 31 30 31 31 30 31 30 31]; mon_wt_era = mon_wt_era/sum(mon_wt_era); % Month weighting
era.shflx  = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'shflx');
era.lhflx = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'lhflx');

era.shflx  = sum(era.shflx.* reshape(mon_wt_era,1,1,12), 3);
era.lhflx = sum(era.lhflx.*reshape(mon_wt_era,1,1,12), 3);

% --- interpolate ---
era.lon_ext = [era.lon(end-1: end)-360; era.lon; era.lon(1:2)+360];
era.shflx_ext  = era.shflx ([end-1:end 1:end 1:2],:);
era.lhflx_ext = era.lhflx([end-1:end 1:end 1:2],:);


[X, Y] = meshgrid(era.lat, era.lon_ext);
era_inp.lon = am4_orig.lon; era_inp.lat = am4_orig.lat;
[Xp, Yp] = meshgrid(era_inp.lat, era_inp.lon);
era_inp.shflx  = interp2(X, Y, era.shflx_ext,  Xp, Yp);
era_inp.lhflx = interp2(X, Y, era.lhflx_ext, Xp, Yp);


fpath='./'; expn='am4';
do_print = 0;

%% Fig 6: Compare Preciplot_6panel_mapp_kmg(s,z1,z2,z3,z6,varn,expn,f,k,icmap,do_print);

k=1; varn='T_ref';
z1 = era_inp.shflx';
z2 = am4_orig.shflx';
z3 = am4_ncep.shflx';
z4 = am4_clasp_lndlm.shflx';


s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;
s.s1='(a) T_{ref} (K), ERA';
s.s2='(b) AM4-Lock minus ERA';
s.s3='(c) AM4-EDMF minus ERA';
s.s4='(d) AM4-EDMF-HET minus ERA';
s.s5='(e) AM4-EDMF-HET minus AM4-Lock';
s.s6='(f) AM4-EDMF-HET minus AM4-EDMF';

s.c1=-20;   s.c2=80;   s.vbino=[s.c1:5:s.c2]; s.unit='(K)';
s.cmin=-10; s.cmax=10; s.vbin =[s.cmin:0.5:s.cmax];
s.cminclasp=-10; s.cmaxclasp=10;
s.cminclasp2=-10; s.cmaxclasp2=10;
f=1; icmap=3;


plot_6panel_mapp_kmg(s,z1,z2,z3,z4,varn,expn,f,k,icmap,do_print);
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'shflx_clasplnddisplm.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
close all;
