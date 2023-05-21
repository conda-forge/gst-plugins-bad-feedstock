#!/usr/bin/env bash
set -ex

mkdir -p build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig

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
