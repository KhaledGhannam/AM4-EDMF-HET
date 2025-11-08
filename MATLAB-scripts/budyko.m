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

shflx_am4 = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/shflx.nc','shflx'),...
           3,'omitnan'));

evap_am4 = 2.5E06.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/evap.nc','evap'),...
           3,'omitnan'));

evapw_am4 = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/evap.nc','evap'),...
           3,'omitnan'));

g_am4 = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/grnd_flux.nc','grnd_flux'),...
           3,'omitnan'));

precip_am4 = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/precip.nc','precip'),...
           3,'omitnan'));

pressure_am4 = 1E-03.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/ps.nc','ps'),...
           3,'omitnan'));

tref_am4 = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/concatenation/1980_2014_am4/t_ref.nc','t_ref'),...
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

shflx_ncep = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/shflx.nc','shflx'),...
           3,'omitnan'));

evap_ncep = 2.5E06.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/evap.nc','evap'),...
           3,'omitnan'));

evapw_ncep = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/evap.nc','evap'),...
           3,'omitnan'));

g_ncep = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/grnd_flux.nc','grnd_flux'),...
           3,'omitnan'));

precip_ncep = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/precip.nc','precip'),...
           3,'omitnan'));

pressure_ncep = 1E-03.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/ps.nc','ps'),...
           3,'omitnan'));

tref_ncep = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_ncep_zas/t_ref.nc','t_ref'),...
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

shflx_clasp = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/shflx.nc','shflx'),...
           3,'omitnan'));

evap_clasp = 2.5E06.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/evap.nc','evap'),...
           3,'omitnan'));

evapw_clasp = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/evap.nc','evap'),...
           3,'omitnan'));

g_clasp = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/grnd_flux.nc','grnd_flux'),...
           3,'omitnan'));

precip_clasp = 86400.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/precip.nc','precip'),...
           3,'omitnan'));

pressure_clasp = 1E-03.*squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/ps.nc','ps'),...
           3,'omitnan'));

tref_clasp = squeeze(mean(ncread('/archive/Khaled.Ghannam/awg/xanadu_2022.08/james_data_03152023/1980_2014_clasp_lnd_disp_lm_zas/t_ref.nc','t_ref'),...
           3,'omitnan'));

%-------------------------------------

rn_am4 =  ((swdn_am4+lwdn_am4) - (swup_am4+lwup_am4));
rn_ncep = ((swdn_ncep+lwdn_ncep) - (swup_ncep+lwup_ncep));
rn_clasp= ((swdn_clasp+lwdn_clasp) - (swup_clasp+lwup_clasp));



% --- calculate runoff ratio ----

precip1= precip_am4; precip1(precip1<0.05)=NaN; precip1(:,1:30)=NaN; precip1(land_frac<0.5)=NaN;
precip2= precip_ncep; precip2(precip2<0.05)=NaN; precip2(:,1:30)=NaN; precip2(land_frac<0.5)=NaN;
precip3= precip_clasp; precip3(precip3<0.05)=NaN; precip3(:,1:30)=NaN; precip3(land_frac<0.5)=NaN;

evap1= evapw_am4; evap1(evap1<0.005)=NaN; evap1(:,1:30)=NaN; evap1(land_frac<0.5)=NaN;
evap2= evapw_ncep; evap2(evap2<0.005)=NaN; evap2(:,1:30)=NaN; evap2(land_frac<0.5)=NaN;
evap3= evapw_clasp; evap3(evap3<0.005)=NaN; evap3(:,1:30)=NaN; evap3(land_frac<0.5)=NaN;

r1= (precip1-evap1)./precip1; r1(r1<0 | r1>1)=NaN; r1(:,1:30)=NaN; r1(land_frac<0.5)=NaN;
r2= (precip2-evap2)./precip2; r2(r2<0 | r2>1)=NaN; r2(:,1:30)=NaN; r2(land_frac<0.5)=NaN;
r3= (precip3-evap3)./precip3; r3(r3<0 | r3>1)=NaN; r3(:,1:30)=NaN; r3(land_frac<0.5)=NaN;
%--------------------------------------------------

% --- trying mm/day ----
clear r1 r2 r3
r1= (precip1-evap1); r1(r1<0 | r1>10)=NaN; r1(:,1:30)=NaN; r1(land_frac<0.5)=NaN;
r2= (precip2-evap2); r2(r2<0 | r2>10)=NaN; r2(:,1:30)=NaN; r2(land_frac<0.5)=NaN;
r3= (precip3-evap3); r3(r3<0 | r3>10)=NaN; r3(:,1:30)=NaN; r3(land_frac<0.5)=NaN;

s.aa = am4_orig.area';
s.lmx = am4_orig.land_mask';

s.lat = am4_orig.lat; s.lon = am4_orig.lon;
s.latx = am4_orig.lat; s.lonx = am4_orig.lon;

s.c1=0;   s.c2=4;   s.vbino=[s.c1:0.2:s.c2]; s.unit='(K)';
s.cmin=-0.6; s.cmax=0.6; s.vbin =[s.cmin:0.2:s.cmax];
s.cminclasp=-0.6; s.cmaxclasp=0.6; s.vbin1 =[s.cminclasp:0.2:s.cmaxclasp];
s.cminclasp2=-0.6; s.cmaxclasp2=0.6; s.vbin2 =[s.cminclasp2:0.2:s.cmaxclasp2];

%--------------
aa=s.aa;
sea='ANN';

r1=r1';
r2=r2';
r3=r3';
z3z1 = r3 - r1;
z3z2 = r3 - r2;

% -- trial ---
z3z1(z3z1>-0.03 & z3z1<0.03)=NaN;
z3z2(z3z2>-0.03 & z3z2<0.03)=NaN;

a=s.aa;
id=~isnan(z3z1) & ~isnan(z3z2); a(id)=a(id)/mean(a(id)); a=a(id);

e=z3z1(id); s.rmse31=sqrt(mean(e.*e.*a)); s.bias31=mean(mean(e.*a));
clear e;
e=z3z2(id); s.rmse32=sqrt(mean(e.*e.*a)); s.bias32=mean(mean(e.*a));

a=s.aa; id=~isnan(r3); a(id)=a(id)/mean(a(id)); a=a(id);
e=r3(id); s.mean3=mean(e.*a);

lat=s.lat; lon=s.lon; xy=[0 360 -90 90];
latx=s.latx; lonx=s.lonx; lm=s.lmx; lm(lm<=0.5)=0; lm(lm>0.5)=1;
domap='robinson';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pms=[20, 200, 1600, 400]*1; fsize=12; lw=2; msize=8;
handle = figure('Position', pms,'visible','on','color','white','Units','normalized');
x0=0.0; y0=0.1; wx=0.28; wy=0.7; dx=0.025; dy=0.15;
p1= [x0,            y0,            wx, wy];
p2= [0.33,          y0,            wx, wy];
p3= [0.68,          y0,            wx, wy];

nn=30;
cmap=jet(nn);
cmap1=bluewhitered(nn);


pos1=[0.27  0.24  0.015 0.44 ];%[left bottom width height];
pos2=[0.60  0.24  0.015 0.44 ];%[left bottom width height];
pos3=[0.95  0.24  0.015 0.44 ];%[left bottom width height];


row=3; col=1; domap='noprojection'; domap='robinson';


ax1=subplot('Position',p1); a=r3;
do_mapproj_kmg(lat,lon,a,s.vbino,latx,lonx,lm,domap,xy);
caxis([s.c1 s.c2]); colormap(ax1,cmap); freezeColors;
h1=colorbar('Location','eastoutside','Position',pos1,'FontSize',16); cbfreeze(h1,cmap);
h1.Ticks = [0 1 2 3 4];
h1.TickLabels = {'0','1','2','3','4'};
title({'(a) R (mm/d) (AM4-EDMF-HET)',sprintf('(%s; MEAN=%5.2f)',sea, s.mean3)},...
'FontSize',14);

ax2=subplot('Position',p2); a=z3z1;
do_mapproj_kmg(lat,lon,a,s.vbin2,latx,lonx,lm,domap,xy);
caxis([s.cminclasp2 s.cmaxclasp2]); colormap(ax2,bluewhitered(nn)); freezeColors;
h2=colorbar('Location','eastoutside','Position',pos2,'FontSize',16);
h2.Ticks = [-0.6 -0.3 0 0.3 0.6];
h2.TickLabels = {'-0.6','-0.3','0','0.3','0.6'};
title({'(b) R (AM4-EDMF-HET minus AM4-Lock)',sprintf('(DIFF=%5.2f)',s.bias31)},...
'FontSize',14);

ax3=subplot('Position',p3); a=z3z2;
do_mapproj_kmg(lat,lon,a,s.vbin1,latx,lonx,lm,domap,xy);
caxis([s.cminclasp s.cmaxclasp]); colormap(ax3,bluewhitered(nn));
h3=colorbar('Location','eastoutside','Position',pos3,'FontSize',16);
h3.Ticks = [-0.6 -0.3 0 0.3 0.6];
h3.TickLabels = {'-0.6','-0.3','0','0.3','0.6'};
title({'(c) R (AM4-EDMF-HET minus AM4-EDMF)',sprintf('(DIFF=%5.2f)',s.bias32)},...
'FontSize',14);

cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'runoff_clasplnddisplm.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
close all;

%--------- Budyko --------------------
% ---- calculate potential ET ----
alp=1.2;
Le=2.501E06; % J/kg
Fa1 = rn_am4 - g_am4; % available energy
Fa2 = rn_ncep - g_ncep; % available energy
Fa3 = rn_clasp - g_clasp; % available energy

Fa1(Fa1<1)=NaN; Fa2(Fa2<1)=NaN; Fa3(Fa3<1)=NaN;

tref1 = tref_am4-273.15;
tref2 = tref_ncep-273.15;
tref3 = tref_clasp-273.15;

Fa1(tref1<5)=NaN;
Fa2(tref2<5)=NaN;
Fa3(tref3<5)=NaN;

tref1(tref1<5)=NaN;
tref2(tref2<5)=NaN;
tref3(tref3<5)=NaN;


pr1 = pressure_am4; %surface pressure
pr2 = pressure_ncep; %surface pressure
pr3 = pressure_clasp; %surface pressure

es1 = 0.6108.*exp(17.27.*tref1./(tref1+237.3));  % saturation vapor pressure
es2 = 0.6108.*exp(17.27.*tref2./(tref2+237.3));  % saturation vapor pressure
es3 = 0.6108.*exp(17.27.*tref3./(tref3+237.3));  % saturation vapor pressure

delta1=4098.*es1./((tref1+237.3).^2);
delta2=4098.*es2./((tref2+237.3).^2);
delta3=4098.*es3./((tref3+237.3).^2);

gam1 = 0.0016286.*pr1./2.501;
gam2 = 0.0016286.*pr2./2.501;
gam3 = 0.0016286.*pr3./2.501;

Fa1w = 86400.*Fa1./Le;   % -- Available energy in mm/day
Fa2w = 86400.*Fa2./Le;   % -- Available energy in mm/day
Fa3w = 86400.*Fa3./Le;   % -- Available energy in mm/day

pote1 = alp.*(delta1./(delta1 + gam1)).*(Fa1w);
pote2 = alp.*(delta2./(delta2 + gam2)).*(Fa2w);
pote3 = alp.*(delta3./(delta3 + gam3)).*(Fa3w);

evap_ra1=evap1./precip1;
evap_ra2=evap2./precip2;
evap_ra3=evap3./precip3;

pote_ra1 = pote1./precip1;
pote_ra2 = pote2./precip2;
pote_ra3 = pote3./precip3;

evap_ra1(land_frac<0.5)=NaN; evap_ra1(evap_ra1<0.0 | evap_ra1 > 1.0)=NaN;
evap_ra2(land_frac<0.5)=NaN; evap_ra2(evap_ra2<0.0 | evap_ra2 > 1.0)=NaN;
evap_ra3(land_frac<0.5)=NaN; evap_ra3(evap_ra3<0.0 | evap_ra3 > 1.0)=NaN;

evap_ra1(:,1:30)=NaN; evap_ra1(:,160:180)=NaN;
evap_ra2(:,1:30)=NaN; evap_ra2(:,160:180)=NaN;
evap_ra3(:,1:30)=NaN; evap_ra3(:,160:180)=NaN;

pote_ra1(land_frac<0.5)=NaN;
pote_ra2(land_frac<0.5)=NaN;
pote_ra3(land_frac<0.5)=NaN;

pote_ra1(:,1:30)=NaN; pote_ra1(:,160:180)=NaN;
pote_ra2(:,1:30)=NaN; pote_ra2(:,160:180)=NaN;
pote_ra3(:,1:30)=NaN; pote_ra3(:,160:180)=NaN;

pote_ra1(pote_ra1>4)=NaN;
pote_ra2(pote_ra2>4)=NaN;
pote_ra3(pote_ra3>4)=NaN;

pote_ra1(isnan(evap_ra1))=NaN;
pote_ra2(isnan(evap_ra2))=NaN;
pote_ra3(isnan(evap_ra3))=NaN;

evap_ra1(isnan(pote_ra1))=NaN;
evap_ra2(isnan(pote_ra2))=NaN;
evap_ra3(isnan(pote_ra3))=NaN;

 yax1=evap_ra1;
 yax2=evap_ra2;
 yax3=evap_ra3;

%----------------------------------
ax4=subplot('Position',p4);
set(gca,'FontSize',16)
plot(pote_ra1(:),yax1(:),'b.','MarkerSize',0.2)
hold on
xaxe=[0:0.01:4]; mm=2; yaxe=(1+xaxe.^(-mm)).^(-1.0./mm);
plot(xaxe,yaxe,'k-','linewidth',1.25)
xlim([0 4])
ylim([0 1.2])
yticks([0 0.2 0.4 0.6 0.8 1])
yticklabels({'0','0.2','0.4','0.6','0.8','1'})
xticks([0 1 2 3 4])
xticklabels({'0','1','2','3','4'})
hh=legend('AM4-Lock','TMPT (\nu = 2)');
set(hh,'Orientation','Vertical','Location','southeast',...
    'box','off','Fontsize',16)

ylabel('$E/P$','Interpreter','latex','FontSize',17)
xlabel('$E_{p}/P$','Interpreter','latex','FontSize',17)

set(gca,'XMinorTick','on','YMinorTick','on','TickDir','out',...
    'FontSize',16)
title('(d) AM4-Lock','FontSize',14);

%--------------------------------------------------------------------------
%----------------------------------
ax5=subplot('Position',p5);
set(gca,'FontSize',16)
plot(pote_ra2(:),yax2(:),'b.','MarkerSize',0.2)
hold on
xaxe=[0:0.01:4]; mm=2; yaxe=(1+xaxe.^(-mm)).^(-1.0./mm);
plot(xaxe,yaxe,'k-','linewidth',1.25)
xlim([0 4])
ylim([0 1.2])
yticks([0 0.2 0.4 0.6 0.8 1])
yticklabels({'0','0.2','0.4','0.6','0.8','1'})
xticks([0 1 2 3 4])
xticklabels({'0','1','2','3','4'})
hh=legend('AM4-EDMF','TMPT (\nu = 2)');
set(hh,'Orientation','Vertical','Location','southeast',...
    'box','off','Fontsize',16)

ylabel('$E/P$','Interpreter','latex','FontSize',17)
xlabel('$E_{p}/P$','Interpreter','latex','FontSize',17)

set(gca,'XMinorTick','on','YMinorTick','on','TickDir','out',...
    'FontSize',16)
title('(e) AM4-EDMF','FontSize',14);

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%----------------------------------
ax6=subplot('Position',p6);
set(gca,'FontSize',16)
plot(pote_ra3(:),yax3(:),'b.','MarkerSize',0.2)
hold on
xaxe=[0:0.01:4]; mm=2; yaxe=(1+xaxe.^(-mm)).^(-1.0./mm);
plot(xaxe,yaxe,'k-','linewidth',1.25)
xlim([0 4])
ylim([0 1.2])
yticks([0 0.2 0.4 0.6 0.8 1])
yticklabels({'0','0.2','0.4','0.6','0.8','1'})
xticks([0 1 2 3 4])
xticklabels({'0','1','2','3','4'})
hh=legend('AM4-EDMF-HET','TMPT (\nu = 2)');
set(hh,'Orientation','Vertical','Location','southeast',...
    'box','off','Fontsize',16)

ylabel('$E/P$','Interpreter','latex','FontSize',17)
xlabel('$E_{p}/P$','Interpreter','latex','FontSize',17)

set(gca,'XMinorTick','on','YMinorTick','on','TickDir','out',...
    'FontSize',16)
title('(e) AM4-EDMF-HET','FontSize',14);

%--------------------------------------------------------------------------

cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/figures/')
saveas(gcf,'radiation_clasplnddisplm.png')
cd('/home/Khaled.Ghannam/awg/xanadu_2022.08/james_ana_03152023/plotting_scripts/')
close all;






















