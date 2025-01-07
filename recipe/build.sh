#!/usr/bin/env bash
set -ex

mkdir -p build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig

if [[ "${target_platform}" == "osx-"* ]]; then
    export OBJCXX=${CXX}
    export OBJCXX_FOR_BUILD=${CXX_FOR_BUILD}
fi

if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
  # Create a custom feedstock_local_meson_cross_file.txt to override gst-specific find_program
  # calls, and add it to MESON_FLAGS to combine it with the meson_cross_file.txt generated in
  # https://github.com/conda-forge/ctng-compiler-activation-feedstock/blob/main/recipe/activate-gcc.sh
  # https://github.com/conda-forge/clang-compiler-activation-feedstock/blob/main/recipe/activate-clang.sh
  echo "[binaries]" >> "$(pwd)/feedstock_local_meson_cross_file.txt"
  echo "glib-mkenums = '${BUILD_PREFIX}/bin/glib-mkenums'" >> "$(pwd)/feedstock_local_meson_cross_file.txt"
  export MESON_ARGS="${MESON_ARGS} --cross-file $(pwd)/feedstock_local_meson_cross_file.txt"
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
