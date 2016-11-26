mkdir build
cd build

cmake -DCMAKE_BUILD_TYPE=Release            \
      -DCMAKE_VERBOSE_MAKEFILE=ON           \
      -DCMAKE_INSTALL_PREFIX=$PREFIX        \
      -DINSTALL_LIB_DIR=$PREFIX/lib         \
      -DINSTALL_BIN_DIR=$PREFIX/bin         \
      -DINSTALL_INCLUDE_DIR=$PREFIX/include \
      -DINSTALL_CMAKE_DIR=$PREFIX/lib/cmake \
      -DGALOIS_CMAKE_DIR=$PREFIX/lib/cmake  \
      ..

ctest || true

make -j6
# The install code for this beta release
# appears to be totally broken, so here's
# a stopgap that should be good enough
# until they get that fixed.

# On a similar note, they are currently
# vendoring a few portions of LLVM in a
# way that makes actually installing
# Galois alongside LLVM in a given environment
# impossible to do in any safe way since
# the header locations conflict across the
# two packages. In addition, since the symbols
# are not mangled, using things linked statically
# against these libraries within the same process
# with other LLVM based libraries must be done
# with the utmost caution.

# So, with those cautionary notes, here's
# the "installation."
# This will probably only work on Linux.
# OSX could probably be made to work similarly
# given an appropriate choice of CMake generator.
# First deal with the headers and their odd layout.
cp -a ../libexp/include/.        $PREFIX/include
cp -a ../libgraphs/include/.     $PREFIX/include
cp -a ../libllvm/include/.       $PREFIX/include
cp -a ../libruntime/include/.    $PREFIX/include
cp -a ../libsubstrate/include/. $PREFIX/include
# Now deal with the static libraries.
cp    libexp/libgalois_exp.a             $PREFIX/lib/libgalois_exp.a
cp    libgraphs/libgalois_graphs.a       $PREFIX/lib/libgalois_graphs.a
cp    libllvm/libgllvm.a                 $PREFIX/lib/libgllvm.a
cp    libruntime/libgalois_runtime.a     $PREFIX/lib/libgalois_runtime.a
cp    libsubstrate/libgalois_substrate.a $PREFIX/lib/libgalois_substrate.a

# It'd be nice to install all the Galois apps and
# tools into $PREFIX/bin or $PREFIX/bin/galois
# or something like that at some point too.

