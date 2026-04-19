#!/bin/tcsh -f

setenv DVT_HOME /nfs/site/disks/xeg.jgsfe_ultpsoc.0001/emilrad/vscode/.vscode-server/extensions/amiq.dvt-26.1.8-linux-x64/dvt_home
setenv DVTLMD_LICENSE_FILE 20020@dvt01e.elic.intel.com
setenv DVT_GIT /nfs/site/disks/jgs_cad_01/dvt_builds
setenv WORKAREA /nfs/site/disks/xeg.jgsfe_compute.0004/emilrad/cth_jgs_psoc
setenv PSOC_LIBS /nfs/site/disks/jgs_cad_01/psoc_libs
setenv ctech_path /p/tech1/n3p/tech-release/v1.0.5_gfx/ctech_c4v24ww43a_hdk164_cth2409_lib/c4v24ww43a_hdk164_cth2409/source/v

set DVT_BIN = $DVT_HOME/platform/linux-amd64/bin
set DVT_VER = 26.1.8

foreach build (sbb trng_dwc dteg_security_dfxagg cro_sip cro_hip compute_psoc_sbr gpsbrf pmsbrf_compute pmsbrf_io fuse_puller fpc_ser iosf_sb_sbe i3c_dwc spi_dwc spi_mst_dwc spi_slv_dwc dwc_gpio ctech io_die_mng_arc io_die_misc_arc io_die_pid_arc io_die_rst_arc dteg_upm_n3_top jgsiod_rams compute_die_mng_arc compute_die_rst_arc jgscd_rams)
    echo "=== BUILD: precompiled.$build ==="
    $DVT_BIN/dvt_build.sh -lang vlog -cmd $WORKAREA/.dvt/precompiled.$build.build -heap_size 4096m
    echo "=== DONE: $build ==="
end

echo "Setting permissions..."
chmod -R g+w $PSOC_LIBS/*/dvt/$DVT_VER
echo "=== ALL DONE. chmod applied ==="
