% cd /net2/Zhihong.Tan/MATLAB/
addpath('/net2/Zhihong.Tan/MATLAB/am4_plot_miz');
addpath('/net2/Zhihong.Tan/MATLAB/am4_plot_miz/freezeColors');
addpath('/net2/Zhihong.Tan/MATLAB/am4_plot_miz/cm_and_cb_utilities');

% Note: fre-analysis scripts are located at /home/fms/local/opt/fre-analysis

%% Read data, based on Plotting_20210308_AM4EDMF.m

% Make sure the following files are 'DUAL' on /archive

% NOTE: the pp has been recomputed with increased vertical levels to match ERA5!!
% Refer to: 
%   gfdl:/home/Zhihong.Tan/awg/xanadu_2021.02/c96L33_am4p0hem_hanedmfD2_full_notkemf/gfdl.ncrc4-intel18-prod-openmp/scripts/postProcess/era40_to_era5
%   gfdl:/home/Zhihong.Tan/awg/xanadu_2021.02/c96L33_am4p0hem_hanedmfD2_diag_notkemf_noise6/gfdl.ncrc4-intel18-prod-openmp/scripts/postProcess/era40_to_era5

area_am4 = repmat(diff(sind(-90:90))/2, 288,1)/288;

filenm_orig = '/net2/Zhihong.Tan/AM4data/20211210_AM4_AMIP/AM4_Lock/atmos_level.1980-2014.ann.nc';
filenm_edmf = '/net2/Zhihong.Tan/AM4data/20211210_AM4_AMIP/AM4_EDMF/atmos_level.1980-2014.ann.nc';
           
am4_orig = struct(); 
am4_orig.lat = ncread(filenm_orig, 'lat');             am4_orig.lon = ncread(filenm_orig, 'lon'); 
am4_orig.land_mask = ncread(filenm_orig, 'land_mask'); am4_orig.area = area_am4;

am4_edmf = struct(); 
am4_edmf.lat = ncread(filenm_edmf, 'lat');             am4_edmf.lon = ncread(filenm_edmf, 'lon'); 
am4_edmf.land_mask = ncread(filenm_edmf, 'land_mask'); am4_edmf.area = area_am4;

am4_orig.netrad_toa = ncread(filenm_orig, 'netrad_toa');
am4_edmf.netrad_toa = ncread(filenm_edmf, 'netrad_toa');

am4_orig.lwp = ncread(filenm_orig, 'LWP');
am4_edmf.lwp = ncread(filenm_edmf, 'LWP');

am4_orig.swdn_toa = ncread(filenm_orig, 'swdn_toa');
am4_edmf.swdn_toa = ncread(filenm_edmf, 'swdn_toa');
am4_orig.swdn_toa_clr = ncread(filenm_orig, 'swdn_toa_clr');
am4_edmf.swdn_toa_clr = ncread(filenm_edmf, 'swdn_toa_clr');

am4_orig.swup_toa = ncread(filenm_orig, 'swup_toa');
am4_edmf.swup_toa = ncread(filenm_edmf, 'swup_toa');
am4_orig.swup_toa_clr = ncread(filenm_orig, 'swup_toa_clr');
am4_edmf.swup_toa_clr = ncread(filenm_edmf, 'swup_toa_clr');


am4_orig.swcre_toa = (am4_orig.swdn_toa - am4_orig.swup_toa) - (am4_orig.swdn_toa_clr - am4_orig.swup_toa_clr);
am4_edmf.swcre_toa = (am4_edmf.swdn_toa - am4_edmf.swup_toa) - (am4_edmf.swdn_toa_clr - am4_edmf.swup_toa_clr);


am4_orig.t2m = ncread(filenm_orig,  't_ref');
am4_edmf.t2m = ncread(filenm_edmf,  't_ref');
am4_orig.rh2m = ncread(filenm_orig, 'rh_ref');
am4_edmf.rh2m = ncread(filenm_edmf, 'rh_ref');
am4_orig.u10m = ncread(filenm_orig, 'u_ref');
am4_edmf.u10m = ncread(filenm_edmf, 'u_ref');
am4_orig.precip = ncread(filenm_orig, 'precip')*86400;
am4_edmf.precip = ncread(filenm_edmf, 'precip')*86400;
am4_orig.lca = ncread(filenm_orig,  'low_cld_amt');
am4_edmf.lca = ncread(filenm_edmf,  'low_cld_amt');
am4_orig.tsfc = ncread(filenm_orig,  't_surf');
am4_edmf.tsfc = ncread(filenm_edmf,  't_surf');
am4_orig.ps = ncread(filenm_orig,  'ps');
am4_edmf.ps = ncread(filenm_edmf,  'ps');
% check data
% figure; contourf(am4_orig.lon, am4_orig.lat, am4_orig.netrad_toa');


filenm_orig = '/net2/Zhihong.Tan/AM4data/20211210_AM4_AMIP/AM4_Lock/atmos.1980-2014.ann.nc';
filenm_edmf = '/net2/Zhihong.Tan/AM4data/20211210_AM4_AMIP/AM4_EDMF/atmos.1980-2014.ann.nc';
am4_orig.t  = ncread(filenm_orig, 'temp');
am4_edmf.t  = ncread(filenm_edmf, 'temp');
am4_orig.rh = ncread(filenm_orig, 'rh');
am4_edmf.rh = ncread(filenm_edmf, 'rh');
am4_orig.u  = ncread(filenm_orig, 'ucomp');
am4_edmf.u  = ncread(filenm_edmf, 'ucomp');
am4_orig.level = ncread(filenm_orig, 'level');
am4_edmf.level = ncread(filenm_edmf, 'level');
% lev: #3 = 850; 
% NEW lev: #7 = 850; 
am4_orig.u850 = am4_orig.u(:,:,7);
am4_edmf.u850 = am4_edmf.u(:,:,7);

%% Read in satellite or reanalysis data

% netrad_TOA and swcre_toa from CERES EBAF TOA Ed4.1.
ceres.lon = ncread('/net2/Zhihong.Tan/OBS/CERES_EBAF_Ed4.1/CERES_EBAF_Ed4.1_Subset_200003-201905.nc', 'lon');
ceres.lat = ncread('/net2/Zhihong.Tan/OBS/CERES_EBAF_Ed4.1/CERES_EBAF_Ed4.1_Subset_200003-201905.nc', 'lat');

mon_wt = [31 30 31 30 31 31 30 31 30 31 31 28]; mon_wt = repmat(mon_wt,1,15); % from 2000-03 to 2015-02, Month weighting
mon_wt([(1:3)*48]) = mon_wt([(1:3)*48]) + 1;    mon_wt = mon_wt/sum(mon_wt);

ceres.netrad_toa = ncread('/net2/Zhihong.Tan/OBS/CERES_EBAF_Ed4.1/CERES_EBAF_Ed4.1_Subset_200003-201905.nc', 'toa_net_all_mon');
ceres.swcre_toa  = ncread('/net2/Zhihong.Tan/OBS/CERES_EBAF_Ed4.1/CERES_EBAF_Ed4.1_Subset_200003-201905.nc', 'toa_cre_sw_mon');

ceres.netrad_toa = sum(ceres.netrad_toa(:,:,1:180).*reshape(mon_wt,1,1,180), 3);
ceres.swcre_toa  = sum(ceres.swcre_toa(:,:,1:180).* reshape(mon_wt,1,1,180), 3);

% t2m, rh2m, u850 from ERA-Interim
era.lon  = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'longitude');
era.lat  = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'latitude');

mon_wt_era = [31 (28*26+29*9)/35 31 30 31 30 31 31 30 31 30 31]; mon_wt_era = mon_wt_era/sum(mon_wt_era); % Month weighting
era.t2m  = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 't2m') + 273.15;
era.rh2m = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'rh2m')* 100;
era.u10m = ncread('/net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf/era_interim_monthly.1980-2014.climo.nc', 'u10');

era.t2m  = sum(era.t2m.* reshape(mon_wt_era,1,1,12), 3);
era.rh2m = sum(era.rh2m.*reshape(mon_wt_era,1,1,12), 3);
era.u10m = sum(era.u10m.*reshape(mon_wt_era,1,1,12), 3);


% The p-level data in /net2/Zhihong.Tan/OBS/Datasets/miz_ecmwf seem identical to
% those in /net2/Zhihong.Tan/OBS/Datasets/cjs_ecmwf
% lev: #31 = 850; 
era.level = ncread('/net2/Zhihong.Tan/OBS/Datasets/miz_ecmwf/u.1980-2014.climo.nc', 'levelist');
era.u = ncread('/net2/Zhihong.Tan/OBS/Datasets/miz_ecmwf/u.1980-2014.climo.nc', 'u');
for ilev = 1:37
    utmp(:,:,ilev) = sum(squeeze(era.u(:,end:-1:1,ilev,:)).* reshape(mon_wt_era,1,1,12), 3); 
end
era.u = utmp; clear utmp
era.u850 = era.u(:,:,31);

era.t = ncread('/net2/Zhihong.Tan/OBS/Datasets/miz_ecmwf/t.1980-2014.climo.nc', 't');
for ilev = 1:37
    ttmp(:,:,ilev) = sum(squeeze(era.t(:,end:-1:1,ilev,:)).* reshape(mon_wt_era,1,1,12), 3); 
end
era.t = ttmp; clear ttmp

era.rh = ncread('/net2/Zhihong.Tan/OBS/Datasets/miz_ecmwf/r.1980-2014.climo.nc', 'r');
for ilev = 1:37
    rtmp(:,:,ilev) = sum(squeeze(era.rh(:,end:-1:1,ilev,:)).* reshape(mon_wt_era,1,1,12), 3); 
end
era.rh = rtmp; clear rtmp


gpcp.lon  = ncread('/net2/Zhihong.Tan/OBS/Datasets/sak_precip/gpcp_v2p3_monthly_1980-2014_c.nc', 'LON');
gpcp.lat  = ncread('/net2/Zhihong.Tan/OBS/Datasets/sak_precip/gpcp_v2p3_monthly_1980-2014_c.nc', 'LAT');

mon_wt_gpcp = [31 (28*26+29*9)/35 31 30 31 30 31 31 30 31 30 31]; mon_wt_gpcp = mon_wt_gpcp/sum(mon_wt_gpcp); % Month weighting

gpcp.precip  = ncread('/net2/Zhihong.Tan/OBS/Datasets/sak_precip/gpcp_v2p3_monthly_1980-2014_c.nc', 'precip_c');
gpcp.precip  = sum(gpcp.precip.* reshape(mon_wt_gpcp,1,1,12), 3);


%% Interpolate to AM4 grid
ceres.lon_ext = [ceres.lon(end-1: end)-360; ceres.lon; ceres.lon(1:2)+360];
ceres.netrad_toa_ext = ceres.netrad_toa([end-1:end 1:end 1:2],:);
ceres.swcre_toa_ext  = ceres.swcre_toa ([end-1:end 1:end 1:2],:);

[X, Y] = meshgrid(ceres.lat, ceres.lon_ext);
ceres_inp.lon = am4_orig.lon; ceres_inp.lat = am4_orig.lat; 
[Xp, Yp] = meshgrid(ceres_inp.lat, ceres_inp.lon);
ceres_inp.netrad_toa = interp2(X, Y, ceres.netrad_toa_ext, Xp, Yp);
ceres_inp.swcre_toa  = interp2(X, Y, ceres.swcre_toa_ext,  Xp, Yp);

%
era.lon_ext = [era.lon(end-1: end)-360; era.lon; era.lon(1:2)+360];
era.t2m_ext  = era.t2m ([end-1:end 1:end 1:2],:);
era.rh2m_ext = era.rh2m([end-1:end 1:end 1:2],:);
era.u10m_ext = era.u10m([end-1:end 1:end 1:2],:);
era.u850_ext = era.u850([end-1:end 1:end 1:2],:);

[X, Y] = meshgrid(era.lat, era.lon_ext);
era_inp.lon = am4_orig.lon; era_inp.lat = am4_orig.lat; 
[Xp, Yp] = meshgrid(era_inp.lat, era_inp.lon);
era_inp.t2m  = interp2(X, Y, era.t2m_ext,  Xp, Yp);
era_inp.rh2m = interp2(X, Y, era.rh2m_ext, Xp, Yp);
era_inp.u10m = interp2(X, Y, era.u10m_ext, Xp, Yp);
era_inp.u850 = interp2(X, Y, era.u850_ext, Xp, Yp);

%% Interpolate 3D fields
% OLD AM4 P-LEVEL: 23-lev following CMIP 
% era_to_am4_lev = [37,34,31,28:-2:18,17:-2:11 10:-1:1];

% NEW AM4 P-LEVEL: 37-lev following ERA
era_to_am4_lev = 37:-1:1;
era_inp.level = am4_orig.level;
for ilev = 1:length(era_to_am4_lev)
    data_ext = era.t ([end-1:end 1:end 1:2],:,era_to_am4_lev(ilev));
    era_inp.t(:,:,ilev)  = interp2(X, Y, data_ext,  Xp, Yp);
    
    data_ext = era.rh([end-1:end 1:end 1:2],:,era_to_am4_lev(ilev));
    era_inp.rh(:,:,ilev) = interp2(X, Y, data_ext, Xp, Yp);
    
    data_ext = era.u([end-1:end 1:end 1:2],:,era_to_am4_lev(ilev));
    era_inp.u(:,:,ilev)  = interp2(X, Y, data_ext, Xp, Yp);
end

gpcp.lon_ext = [gpcp.lon(end-1: end)-360; gpcp.lon; gpcp.lon(1:2)+360];
gpcp.precip_ext  = gpcp.precip ([end-1:end 1:end 1:2],:);

[X, Y] = meshgrid(gpcp.lat, gpcp.lon_ext);
gpcp_inp.lon = am4_orig.lon; gpcp_inp.lat = am4_orig.lat; 
[Xp, Yp] = meshgrid(gpcp_inp.lat, gpcp_inp.lon);
gpcp_inp.precip  = interp2(X, Y, gpcp.precip_ext,  Xp, Yp);


%% Set do_print

fpath='./figures_znt/'; expn='am4'; 
do_print = 0;    % set do_print = 1 to output as PNG files. 


%% Figure 1: netrad at TOA
k=1; varn='netrad_toa';
z1 = ceres_inp.netrad_toa'; 
z2 = am4_orig.netrad_toa'; % - ceres_inp.netrad_toa'; 
z3 = am4_edmf.netrad_toa'; % - am4_orig.netrad_toa'; 

% z2 = z2-z1; z3 = z3-z2; 
s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';  

s.lat = am4_orig.lat; s.lon = am4_orig.lon; 
s.latx = am4_orig.lat; s.lonx = am4_orig.lon; 
% s.s1='NetRAD TOA, OBS';  s.s2='AM4 orig - OBS';  s.s3='AM4 EDMF - AM4 orig';
% s.s1='CERES-EBAF-ed4.1, 2000/03-2015/02';  
% s.s2='AM4 Lock (1980-2014) minus CERES';  
% s.s3='AM4 EDMF (1980-2014) minus CERES';
% s.s4='AM4 EDMF minus AM4 Lock';

s.s1='(a) NetRad TOA (W/m^2), CERES-EBAF';  
s.s2='(b) AM4 Lock minus CERES';  
s.s3='(c) AM4 EDMF minus CERES';
s.s4='(d) AM4 EDMF minus AM4 Lock';
s.c1=-150;   s.c2=150;   s.vbino=[s.c1:10:s.c2]; s.unit='(W/m2)'; % 300/10 = 30
s.cmin=-60; s.cmax=60; s.vbin =[s.cmin:4:s.cmax];                 % 120/4 = 30
% s.c1=-150;   s.c2=150;   s.vbino=[s.c1:30:s.c2]; s.unit='(W/m2)';
% s.cmin=-60; s.cmax=60; s.vbin =[s.cmin:20:s.cmax];

% s.c1=-180;   s.c2=120;   s.vbino=[s.c1:60:s.c2]; s.unit='(W/m2)';
% s.cmin=-60; s.cmax=60; s.vbin =[s.cmin:20:s.cmax];
f=1; icmap=3; 
plot_3to4panel_mapp_znt1a(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);

% plot_3to4panel_mapp_znt1(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);
% plot_3tpanel_mapp_znt(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);

%% Figure 2: SWCRE at TOA
k=1; varn='swcre_toa';
z1 = ceres_inp.swcre_toa'; 
z2 = am4_orig.swcre_toa'; % - ceres_inp.netrad_toa'; 
z3 = am4_edmf.swcre_toa'; % - am4_orig.netrad_toa'; 

% z2 = z2-z1; z3 = z3-z2; 
s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';  

s.lat = am4_orig.lat; s.lon = am4_orig.lon; 
s.latx = am4_orig.lat; s.lonx = am4_orig.lon; 
% s.s1='NetRAD TOA, OBS';  s.s2='AM4 orig - OBS';  s.s3='AM4 EDMF - AM4 orig';
s.s1='(a) SWCRE TOA (W/m^2), CERES-EBAF';  
s.s2='(b) AM4 Lock minus CERES';  
s.s3='(c) AM4 EDMF minus CERES';
s.s4='(d) AM4 EDMF minus AM4 Lock';
s.c1=-150;   s.c2=150;   s.vbino=[s.c1:10:s.c2]; s.unit='(W/m2)'; % 300/10 = 30
s.cmin=-60; s.cmax=60; s.vbin =[s.cmin:4:s.cmax];                 % 120/4 = 30

% s.c1=-180;   s.c2=120;   s.vbino=[s.c1:60:s.c2]; s.unit='(W/m2)';
% s.cmin=-60; s.cmax=60; s.vbin =[s.cmin:20:s.cmax];
f=1; icmap=3; 
plot_3to4panel_mapp_znt1a(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);
% plot_3tpanel_mapp_znt(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);




%% Fig 3a: Compare 2m Temperature
k=1; varn='t2m';
z1 = era_inp.t2m'; 
z2 = am4_orig.t2m'; % - ceres_inp.netrad_toa'; 
z3 = am4_edmf.t2m'; % - am4_orig.netrad_toa'; 

% z2 = z2-z1; z3 = z3-z2; 
s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';  

s.lat = am4_orig.lat; s.lon = am4_orig.lon; 
s.latx = am4_orig.lat; s.lonx = am4_orig.lon; 
% s.s1='NetRAD TOA, OBS';  s.s2='AM4 orig - OBS';  s.s3='AM4 EDMF - AM4 orig';
% s.s1='ERAI (1980-2014)';  
% s.s2='AM4 Lock (1980-2014) minus ERAI';  
% s.s3='AM4 EDMF (1980-2014) minus ERAI';
% s.s4='AM4 EDMF minus AM4 Lock';
s.s1='(a) T2m (K), ERAI';  
s.s2='(b) AM4 Lock minus ERAI';  
s.s3='(c) AM4 EDMF minus ERAI';
s.s4='(d) AM4 EDMF minus AM4 Lock';
s.c1=220;   s.c2=310;   s.vbino=[s.c1:3:s.c2]; s.unit='(K)'; % 90/3  = 30
s.cmin=-3; s.cmax=3; s.vbin =[s.cmin:0.2:s.cmax];            % 6/0.2 = 30

% s.c1=-180;   s.c2=120;   s.vbino=[s.c1:60:s.c2]; s.unit='(W/m2)';
% s.cmin=-60; s.cmax=60; s.vbin =[s.cmin:20:s.cmax];
f=1; icmap=3; 
plot_3to4panel_mapp_znt1a(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);
% plot_3tpanel_mapp_znt(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);



%% Fig 3b: Compare 2m RH
k=1; varn='rh2m';
z1 = era_inp.rh2m'; 
z2 = am4_orig.rh2m'; % - ceres_inp.netrad_toa'; 
z3 = am4_edmf.rh2m'; % - am4_orig.netrad_toa'; 

% z2 = z2-z1; z3 = z3-z2; 
s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';  

s.lat = am4_orig.lat; s.lon = am4_orig.lon; 
s.latx = am4_orig.lat; s.lonx = am4_orig.lon; 
% s.s1='NetRAD TOA, OBS';  s.s2='AM4 orig - OBS';  s.s3='AM4 EDMF - AM4 orig';
% s.s1='ERAI (1980-2014)';  
% s.s2='AM4 Lock (1980-2014) minus ERAI';  
% s.s3='AM4 EDMF (1980-2014) minus ERAI';
% s.s4='AM4 EDMF minus AM4 Lock';
s.s1='(a) RH2m (%), ERAI';  
s.s2='(b) AM4 Lock minus ERAI';  
s.s3='(c) AM4 EDMF minus ERAI';
s.s4='(d) AM4 EDMF minus AM4 Lock';
s.c1=25;   s.c2=100;   s.vbino=[s.c1:2.5:s.c2]; s.unit='(%)';  % 75/2.5 = 30
s.cmin=-15; s.cmax=15; s.vbin =[s.cmin:1:s.cmax];          % 20/(2/3) = 30
% s.cmin=-10; s.cmax=10; s.vbin =[s.cmin:(2/3):s.cmax];          % 20/(2/3) = 30

% s.c1=-180;   s.c2=120;   s.vbino=[s.c1:60:s.c2]; s.unit='(W/m2)';
% s.cmin=-60; s.cmax=60; s.vbin =[s.cmin:20:s.cmax];
f=1; icmap=3; 
plot_3to4panel_mapp_znt1a(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);
% plot_3tpanel_mapp_znt(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);



%% Fig 6: Compare Precipitation
k=1; varn='precip';
z1 = gpcp_inp.precip'; 
z2 = am4_orig.precip'; % - ceres_inp.netrad_toa'; 
z3 = am4_edmf.precip'; % - am4_orig.netrad_toa'; 

% z2 = z2-z1; z3 = z3-z2; 
s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';  

s.lat = am4_orig.lat; s.lon = am4_orig.lon; 
s.latx = am4_orig.lat; s.lonx = am4_orig.lon; 
% s.s1='NetRAD TOA, OBS';  s.s2='AM4 orig - OBS';  s.s3='AM4 EDMF - AM4 orig';
% s.s1='GPCP v2.3 (1980-2014)';  
% s.s2='AM4 Lock (1980-2014) minus GPCP';  
% s.s3='AM4 EDMF (1980-2014) minus GPCP';
% s.s4='AM4 EDMF minus AM4 Lock';
s.s1='(a) PREC (mm/d), GPCP';  
s.s2='(b) AM4 Lock minus GPCP';  
s.s3='(c) AM4 EDMF minus GPCP';
s.s4='(d) AM4 EDMF minus AM4 Lock';
s.c1=0;   s.c2=12;   s.vbino=[s.c1:0.4:s.c2]; s.unit='(mm/d)';
s.cmin=-3; s.cmax=3; s.vbin =[s.cmin:0.2:s.cmax];

% s.c1=-180;   s.c2=120;   s.vbino=[s.c1:60:s.c2]; s.unit='(W/m2)';
% s.cmin=-60; s.cmax=60; s.vbin =[s.cmin:20:s.cmax];
f=1; icmap=3; 
plot_3to4panel_mapp_znt1a(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);
% plot_3tpanel_mapp_znt(s,z1,z2,z3,varn,fpath,expn,f,k,icmap,do_print);
