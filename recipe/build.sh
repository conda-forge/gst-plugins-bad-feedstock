#!/usr/bin/env bash
set -ex

mkdir -p build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig

if [[ "${target_platform}" == "osx-arm64" ]]; then
    echo "objcpp = '${CXX}'" >> ${BUILD_PREFIX}/meson_cross_file.txt
    cat ${BUILD_PREFIX}/meson_cross_file.txt
fi

meson_options=(
      -Dexamples=disabled
      -Dtests=disabled
)

meson ${MESON_ARGS} \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}
ninja install

popd
