#!/bin/tcsh -f
# Checkout Script for Experiment 'cm4p12hem_xanadu_2022.08'
# ------------------------------------------------------------------------------
# The script created at 2023-03-12T11:59:45 via:
# /ncrc/home2/fms/local/opt/fre-commands/bronx-19/bin/fremake --force-checkout --link --ncores=8 --platform=ncrc4.intel18 --target=prod,openmp-dec2 --walltime=120 --xmlfile=/ncrc/home1/Khaled.Ghannam/awg/xanadu_2021.02/awg_xanadu_hem_kmg03102023.xml cm4p12hem_xanadu_2022.08
# ------------------------------------------------------------------------------

source $MODULESHOME/init/csh
echo Using source directory = /ncrc/home1/Khaled.Ghannam/awg/xanadu_2022.08/cm4p12hem_xanadu_2022.08/src...
cd /ncrc/home1/Khaled.Ghannam/awg/xanadu_2022.08/cm4p12hem_xanadu_2022.08/src

module avail git >& .git_avail
if (! -z .git_avail) then
    module load git
endif

unalias *

# ---------------- component 'fms'
echo "Cloning https://github.com/slm7826/FMS.git on branch/tag slm_edmf_20230310"
set git_output=`git clone -q --recursive -b slm_edmf_20230310 https://github.com/slm7826/FMS.git >& /dev/stdout`
if ( $? != 0 ) then
     echo "$git_output" | sed 's/^/**GIT ERROR** /' > /dev/stderr
     exit 1
endif
# Additional checkout commands from XML file


# ---------------- component 'atmos_phys'
echo "Cloning http://gitlab.gfdl.noaa.gov/fms/atmos_phys.git on branch/tag slm_edmf_20230310"
set git_output=`git clone -q --recursive -b slm_edmf_20230310 http://gitlab.gfdl.noaa.gov/fms/atmos_phys.git >& /dev/stdout`
if ( $? != 0 ) then
     echo "$git_output" | sed 's/^/**GIT ERROR** /' > /dev/stderr
     exit 1
endif
# Additional checkout commands from XML file


# ---------------- component 'atmos_cubed_sphere'
echo "Cloning https://github.com/NOAA-GFDL/GFDL_atmos_cubed_sphere.git on branch/tag main"
set git_output=`git clone -q --recursive -b main https://github.com/NOAA-GFDL/GFDL_atmos_cubed_sphere.git >& /dev/stdout`
if ( $? != 0 ) then
     echo "$git_output" | sed 's/^/**GIT ERROR** /' > /dev/stderr
     exit 1
endif
# Additional checkout commands from XML file

          # fa9ee63 = 2021 fv3 science updates + fix for FMS-2021.02
          ( cd GFDL_atmos_cubed_sphere && git checkout fa9ee63 )
         
        

# ---------------- component 'atmos_dyn'
echo "Cloning https://gitlab.gfdl.noaa.gov/Zhihong.Tan/atmos_drivers.git on branch/tag slm_edmf_20230310"
set git_output=`git clone -q --recursive -b slm_edmf_20230310 https://gitlab.gfdl.noaa.gov/Zhihong.Tan/atmos_drivers.git >& /dev/stdout`
if ( $? != 0 ) then
     echo "$git_output" | sed 's/^/**GIT ERROR** /' > /dev/stderr
     exit 1
endif
# Additional checkout commands from XML file

          ( cd atmos_drivers && git checkout user/slm/edmf )
         
        

# ---------------- component 'ice_sis'
echo "Cloning http://gitlab.gfdl.noaa.gov/fms/ice_sis.git on branch/tag master"
set git_output=`git clone -q --recursive -b master http://gitlab.gfdl.noaa.gov/fms/ice_sis.git >& /dev/stdout`
if ( $? != 0 ) then
     echo "$git_output" | sed 's/^/**GIT ERROR** /' > /dev/stderr
     exit 1
endif
echo "Cloning http://gitlab.gfdl.noaa.gov/fms/ice_param.git on branch/tag master"
set git_output=`git clone -q --recursive -b master http://gitlab.gfdl.noaa.gov/fms/ice_param.git >& /dev/stdout`
if ( $? != 0 ) then
     echo "$git_output" | sed 's/^/**GIT ERROR** /' > /dev/stderr
     exit 1
endif
# Additional checkout commands from XML file

          ( cd ice_sis    && git checkout xanadu )
          ( cd ice_param  && git checkout xanadu )
         
        

# ---------------- component 'land_lad2'
echo "Cloning http://gitlab.gfdl.noaa.gov/fms/land_lad2.git on branch/tag master"
set git_output=`git clone -q --recursive -b master http://gitlab.gfdl.noaa.gov/fms/land_lad2.git >& /dev/stdout`
if ( $? != 0 ) then
     echo "$git_output" | sed 's/^/**GIT ERROR** /' > /dev/stderr
     exit 1
endif
# Additional checkout commands from XML file

          ( cd land_lad2 && git checkout user/znt/wleq0_20200924 )
         
        

# ---------------- component 'mom6'
echo "Cloning http://gitlab.gfdl.noaa.gov/fms/ocean_shared.git on branch/tag master"
set git_output=`git clone -q --recursive -b master http://gitlab.gfdl.noaa.gov/fms/ocean_shared.git >& /dev/stdout`
if ( $? != 0 ) then
     echo "$git_output" | sed 's/^/**GIT ERROR** /' > /dev/stderr
     exit 1
endif
# Additional checkout commands from XML file

          git clone -b dev/gfdl/2018.04.06 https://github.com/NOAA-GFDL/MOM6-examples.git mom6
          pushd mom6
          git checkout dev/gfdl/2018.04.06  #needed for older git on zeus
          git submodule init src/MOM6 src/SIS2 src/icebergs tools/python/MIDAS
          git clone --recursive https://github.com/NOAA-GFDL/MOM6.git src/MOM6
          git clone             https://github.com/NOAA-GFDL/SIS2.git src/SIS2
          git clone             https://github.com/NOAA-GFDL/icebergs.git src/icebergs
          git submodule update #This gets the right version of submodules
          popd

          pushd mom6
          set platform_domain = `perl -T -e "use Net::Domain(hostdomain) ; print hostdomain"`
          if ("${platform_domain}" =~ *"fairmont.rdhpcs.noaa.gov"* ) then
            ln -s /scratch4/GFDL/gfdlscr/pdata/gfdl_O/datasets/ .datasets
          else if ("${platform_domain}" =~ *"ccs.ornl.gov"* ) then
            ln -s /lustre/atlas/proj-shared/cli061/pdata/gfdl_O/datasets/ .datasets
          else
            ln -s /lustre/f2/pdata/gfdl/gfdl_O/datasets/ .datasets
          endif
          popd

          test -e mom6/.datasets
          if ($status != 0) then
            echo ""; echo "" ; echo "   WARNING:  .datasets link in MOM6 examples directory is invalid"; echo ""; echo ""
          endif

        

# ---------------- component 'coupler'
echo "Cloning https://gitlab.gfdl.noaa.gov/Zhihong.Tan/FMScoupler.git on branch/tag slm_edmf_20230310"
set git_output=`git clone -q --recursive -b slm_edmf_20230310 https://gitlab.gfdl.noaa.gov/Zhihong.Tan/FMScoupler.git >& /dev/stdout`
if ( $? != 0 ) then
     echo "$git_output" | sed 's/^/**GIT ERROR** /' > /dev/stderr
     exit 1
endif
# Additional checkout commands from XML file

          ( cd FMScoupler && git checkout user/slm/edmf )
         
        

exit 0
