#!/usr/bin/env bash

set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ios_dir="${repo_root}/ReproducerApp/ios"
pods_dir="${ios_dir}/Pods"
rncore_dir="${pods_dir}/React-Core-prebuilt"
module_map="${rncore_dir}/Headers/module.modulemap"
marker="${rncore_dir}/.last_build_configuration"
previous_configuration="${RNCORE_PREVIOUS_CONFIGURATION:-Debug}"
derived_data="$(mktemp -d /tmp/rncore-swap-repro.XXXXXX)"
log_file="/tmp/rncore-swap-repro-$(date +%Y%m%d-%H%M%S).log"

if [[ ! -f "${module_map}" ]]; then
  echo "The module map does not exist: ${module_map}" >&2
  echo "Run bundle exec pod install in ${ios_dir}." >&2
  exit 2
fi

printf '%s' "${previous_configuration}" > "${marker}"

echo "Xcode:"
xcodebuild -version
echo "Before Release build: marker=$(<"${marker}"), modulemap=present"
echo "DerivedData: ${derived_data}"
echo "Log: ${log_file}"

set +e
xcodebuild \
  -workspace "${ios_dir}/ReproducerApp.xcworkspace" \
  -scheme ReproducerApp \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "${derived_data}" \
  -jobs 32 \
  "$@" \
  2>&1 | tee "${log_file}"
build_status=${PIPESTATUS[0]}
set -e

echo
echo "Relevant result:"
grep -E \
  "Removing directory React-Core-prebuilt|Done replacing React Native prebuilt|module map file|non-modular header|PrecompileModule .*React-|BUILD (SUCCEEDED|FAILED)" \
  "${log_file}" || true

exit "${build_status}"
