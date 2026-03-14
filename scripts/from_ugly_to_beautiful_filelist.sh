#!/usr/bin/env bash
set -euo pipefail

# --- colored logging helpers ---
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
    _c_reset="$(tput sgr0)"
    _c_red="$(tput setaf 1)"
    _c_green="$(tput setaf 2)"
    _c_yellow="$(tput setaf 3)"
    _c_blue="$(tput setaf 4)"
    _c_bold="$(tput bold)"
else
    _c_reset=""; _c_red=""; _c_green=""; _c_yellow=""; _c_blue=""; _c_bold=""
fi

log_info()  { printf '%s%s[INFO]%s %s\n'  "$_c_blue" "$_c_bold" "$_c_reset" "$*"; }
log_ok()    { printf '%s%s[ OK ]%s %s\n'  "$_c_green" "$_c_bold" "$_c_reset" "$*"; }
log_warn()  { printf '%s%s[WARN]%s %s\n'  "$_c_yellow" "$_c_bold" "$_c_reset" "$*"; }
log_err()   { printf '%s%s[ERR ]%s %s\n'  "$_c_red" "$_c_bold" "$_c_reset" "$*"; }

log_info "Starting filelist split..."

cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
mkdir -p ../filelists/bom
cd ../filelists/bom
log_ok "Working dir: $(pwd)"

flat_filelist="$WORKAREA/filelists/jgsio_psoc_predft.rtl.f"
log_info "Input flat filelist: $flat_filelist"
[[ -f "$flat_filelist" ]] || { log_err "Missing: $flat_filelist"; exit 1; }

log_info "Generating fc.rtl.f"
sed -n '/src\/subIP\/jgs_.*_fc_rtl/p' "$flat_filelist" > fc.rtl.f
log_ok "Wrote fc.rtl.f"

log_info "Generating common.rtl.f"
sed -n '/src\/subIP\/common_rtl/p' "$flat_filelist" > common.rtl.f
log_ok "Wrote common.rtl.f"

log_info "Generating archipelago.rtl.f"
sed -n '/src\/subIP\/archipelago_rtl/p' "$flat_filelist" > archipelago.rtl.f
log_ok "Wrote archipelago.rtl.f"

log_info "Generating psoc_common.rtl.f"
sed -n '/src\/subIP\/psoc_rtl/ { /h15a/! { /h15b/!p } }' "$flat_filelist" > psoc_common.rtl.f
log_ok "Wrote psoc_common.rtl.f"

log_info "Generating psoc_io.rtl.f"
sed -n '/src\/subIP\/psoc_rtl\/h15b/p' "$flat_filelist" > psoc_io.rtl.f
log_ok "Wrote psoc_io.rtl.f"

log_info "Generating psoc_compute.rtl.f"
sed -n '/src\/subIP\/psoc_rtl\/h15a/p' "$flat_filelist" > psoc_compute.rtl.f
log_ok "Wrote psoc_compute.rtl.f"

log_info "Post-processing path rewrite: subIP/psoc_rtl -> rtl/psoc_rtl"
for f in psoc_common.rtl.f psoc_io.rtl.f psoc_compute.rtl.f; do
    log_info "Updating $f"
    sed -i 's#subIP/psoc_rtl#rtl/psoc_rtl#g' "$f"
done
log_ok "Done."
