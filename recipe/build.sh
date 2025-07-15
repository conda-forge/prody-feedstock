#!/bin/bash
set -ex
export CFLAGS="${CFLAGS} -D__NO_FLOAT16"
export CPPFLAGS="${CPPFLAGS} -D__NO_FLOAT16"

cd "$SRC_DIR/prody/proteins/hpbmodule"

# Check Fortran compiler
if [ -z "$FC" ]; then
  echo "Fortran compiler (\$FC) not set. Aborting."
  exit 1
fi

# Compile Fortran code
$FC -O3 -fPIC -c reg_tet.f

# Get Python compile & link info
PYTHON_INCLUDE=$($PYTHON -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
PYTHON_LIBDIR=$($PYTHON -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR'))")
PYTHON_LIB=$($PYTHON -c "import sysconfig; print(sysconfig.get_config_var('LDLIBRARY'))")
PYTHON_LIB_NAME=$(basename "$PYTHON_LIB" | sed -E 's/^lib(.*)\.(so|dylib|a)$/\1/')

# Compile C++ wrapper
g++ -O3 -g -fPIC -c hpbmodule.cpp -o hpbmodule.o -I${PYTHON_INCLUDE}

# Export library path
export LIBRARY_PATH=$PREFIX/lib:$PYTHON_LIBDIR:$LIBRARY_PATH

# Link .so
if [[ "$(uname)" == "Darwin" ]]; then
  g++ -dynamiclib -o hpb.so hpbmodule.o reg_tet.o -L${PYTHON_LIBDIR} -l${PYTHON_LIB_NAME} -lgfortran -undefined dynamic_lookup
else
  g++ -shared -Wl,-soname,hpb.so -o hpb.so hpbmodule.o reg_tet.o -L${PYTHON_LIBDIR} -l${PYTHON_LIB_NAME} -lgfortran
fi

# Move shared object
cp hpb.so ../

cd "$SRC_DIR"

# Final installation
$PYTHON -m pip install . --no-deps --no-build-isolation -vv
