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

am4_orig = struct();
am4_orig.lat = ncread(f_orig, 'lat');
am4_orig.lon = ncread(f_orig, 'lon');
am4_orig.land_mask = ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/matlab//atmos.static.nc',...
    'land_mask');
am4_orig.area = area_am4;

am4_clasp = struct(); 
am4_clasp.lat = am4_orig.lat;             
am4_clasp.lon = am4_orig.lon; 
am4_clasp.land_mask = am4_orig.land_mask; 
am4_clasp.area = area_am4;


am4_clasp_disp = struct(); 
am4_clasp_disp.lat = am4_orig.lat;
am4_clasp_disp.lon = am4_orig.lon; 
am4_clasp_disp.land_mask = am4_orig.land_mask; 
am4_clasp_disp.area = area_am4;

am4_clasp_disp20 = struct(); 
am4_clasp_disp20.lat = am4_orig.lat;
am4_clasp_disp20.lon = am4_orig.lon; 
am4_clasp_disp20.land_mask = am4_orig.land_mask; 
am4_clasp_disp20.area = area_am4;

am4_clasp_disp_hetlm_lnd = struct(); 
am4_clasp_disp_hetlm_lnd.lat = am4_orig.lat;
am4_clasp_disp_hetlm_lnd.lon = am4_orig.lon; 
am4_clasp_disp_hetlm_lnd.land_mask = am4_orig.land_mask; 
am4_clasp_disp_hetlm_lnd.area = area_am4;


am4_clasp.G_param = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp/G_param_diu.nc', 'G_param'),3),4));

am4_claspdisp.G_param = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp_disp/G_param_diu.nc', 'G_param'),3),4));

am4_claspdisp20.G_param = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp_disp20/G_param_diu.nc', 'G_param'),3),4));

am4_claspdisp_hetlm_lnd.G_param = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp_disp_hetlm_lnd/G_param_diu.nc', 'G_param'),3),4));
    
am4_clasp.std_t_ca = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp/std_t_ca_diu.nc', 'std_t_ca'),3),4));

am4_claspdisp.std_t_ca = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp_disp/std_t_ca_diu.nc', 'std_t_ca'),3),4));

am4_claspdisp20.std_t_ca = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp_disp20/std_t_ca_diu.nc', 'std_t_ca'),3),4));

am4_claspdisp_hetlm_lnd.std_t_ca = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp_disp_hetlm_lnd/std_t_ca_diu.nc', 'std_t_ca'),3),4));
    
am4_clasp.std_fluxt = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp/std_fluxt_diu.nc', 'std_fluxt'),3),4));

am4_claspdisp.std_fluxt = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp_disp/std_fluxt_diu.nc', 'std_fluxt'),3),4));

am4_claspdisp20.std_fluxt = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp_disp20/std_fluxt_diu.nc', 'std_fluxt'),3),4));

am4_claspdisp_hetlm_lnd.std_fluxt = squeeze(mean(mean(ncread(...
    '/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/1980_2014_clasp_disp_hetlm_lnd/std_fluxt_diu.nc', 'std_fluxt'),3),4));
%% Set do_print

sprintf('finished reading data')

fpath='./'; expn='am4'; 
do_print = 0;    % set do_print = 1 to output as EPS files. 

%% Fig 6: Compare Precipitation
k=1; varn='stddev';
z1 = am4_clasp.std_t_ca'; 
z2 = am4_clasp.std_fluxt'; 
z3 = am4_clasp.G_param';

z4 = am4_claspdisp.std_t_ca'; 
z5 = am4_claspdisp.std_fluxt'; 
z6 = am4_claspdisp.G_param';

z7 = am4_claspdisp20.std_t_ca'; 
z8 = am4_claspdisp20.std_fluxt'; 
z9 = am4_claspdisp20.G_param';

z10 = am4_claspdisp_hetlm_lnd.std_t_ca'; 
z11 = am4_claspdisp_hetlm_lnd.std_fluxt'; 
z12 = am4_claspdisp_hetlm_lnd.G_param';




s.aa = am4_orig.area'; s.lmx = am4_orig.land_mask';  

s.lat = am4_orig.lat; s.lon = am4_orig.lon; 
s.latx = am4_orig.lat; s.lonx = am4_orig.lon; 
s.s1='(a) $\sigma_{\theta_{s}}$ (K)';  
s.s2='(b) $\sigma_{F_{H}}$ (W m$^{-2}$)';  
s.s3='(c) Heterogeneity parameter $G$ (-)';


s.c1=0;   s.c2=3;   s.vbino1=[s.c1:0.1:s.c2]; s.unit1='(K)';
s.c3=0;   s.c4=40;  s.vbino2=[s.c3:2.5:s.c4];   s.unit2='(W/m^2)';
s.c5=0;   s.c6=100;  s.vbino3=[s.c5:2.5:s.c6];  s.unit3='(-)';

f=1; icmap=3; 
plot_3panelrow_mapp_kmg(s,z1,z2,z3,varn,expn,f,k,icmap,do_print);
cd('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/figures/')
saveas(gcf,'stddev_G_clasp.png')
cd('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/plotting_scripts/');
sprintf('first figure plotted')
close all;

plot_3panelrow_mapp_kmg(s,z4,z5,z6,varn,expn,f,k,icmap,do_print);
cd('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/figures/')
saveas(gcf,'stddev_G_claspdisp.png')
cd('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/plotting_scripts/');
sprintf('second figure plotted')
close all;

plot_3panelrow_mapp_kmg(s,z7,z8,z9,varn,expn,f,k,icmap,do_print);
cd('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/figures/')
saveas(gcf,'stddev_G_claspdisp20.png')
cd('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/plotting_scripts/');
sprintf('third figure plotted')
close all;

plot_3panelrow_mapp_kmg(s,z10,z11,z12,varn,expn,f,k,icmap,do_print);
cd('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/figures/')
saveas(gcf,'stddev_G_clasp_hetlm_lnd.png')
cd('/archive/Khaled.Ghannam/awg/xanadu_2022.08/jms_data/plotting_scripts/');
sprintf('fourth figure plotted')
close all;
