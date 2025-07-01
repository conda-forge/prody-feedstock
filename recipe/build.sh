# #!/bin/bash
# set -ex

# cd prody/proteins/hpbmodule/

# # Compile Fortran code
# $FC -O3 -fPIC -c reg_tet.f

# # Get Python include and lib details
# PYTHON_INCLUDE=$($PYTHON -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
# PYTHON_LIBDIR=$($PYTHON -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR'))")
# PYTHON_LIB=$($PYTHON -c "import sysconfig; print(sysconfig.get_config_var('LDLIBRARY'))")
# PYTHON_LIB_BASENAME=${PYTHON_LIB#lib}
# PYTHON_LIB_NAME=$(basename "${PYTHON_LIB}" | sed -E 's/^lib(.*)\.(so|dylib|a)$/\1/')
#  # Works for .so or .dylib

# # Compile C++ code
# g++ -O3 -g -fPIC -c hpbmodule.cpp -o hpbmodule.o -I${PYTHON_INCLUDE}

# # Export library path for linker
# export LIBRARY_PATH=$PREFIX/lib:$PYTHON_LIBDIR:$LIBRARY_PATH

# # Link shared library
# if [[ "$(uname)" == "Darwin" ]]; then
#   g++ -dynamiclib -o hpb.so hpbmodule.o reg_tet.o -L${PYTHON_LIBDIR} -l${PYTHON_LIB_NAME} -lgfortran
# else
#   g++ -shared -Wl,-soname,hpb.so -o hpb.so hpbmodule.o reg_tet.o -L${PYTHON_LIBDIR} -l${PYTHON_LIB_NAME} -lgfortran
# fi

# # Move built .so file to destination
# cp hpb.so ../

# cd -

# # Final installation
# $PYTHON setup.py build_ext --force
# $PYTHON setup.py install --single-version-externally-managed --record=record.txt
#!/bin/bash
set -ex
export CFLAGS="${CFLAGS} -D__NO_FLOAT16"
export CPPFLAGS="${CPPFLAGS} -D__NO_FLOAT16"

cd prody/proteins/hpbmodule/

# Compile Fortran code
$FC -O3 -fPIC -c reg_tet.f

# Get Python include and lib details
PYTHON_INCLUDE=$($PYTHON -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
PYTHON_LIBDIR=$($PYTHON -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR'))")
PYTHON_LIB=$($PYTHON -c "import sysconfig; print(sysconfig.get_config_var('LDLIBRARY'))")
PYTHON_LIB_BASENAME=${PYTHON_LIB#lib}
PYTHON_LIB_NAME=$(basename "${PYTHON_LIB}" | sed -E 's/^lib(.*)\.(so|dylib|a)$/\1/')
 # Works for .so or .dylib

# Compile C++ code
g++ -O3 -g -fPIC -c hpbmodule.cpp -o hpbmodule.o -I${PYTHON_INCLUDE}

# Export library path for linker
export LIBRARY_PATH=$PREFIX/lib:$PYTHON_LIBDIR:$LIBRARY_PATH

# Link shared library
if [[ "$(uname)" == "Darwin" ]]; then
  g++ -dynamiclib -o hpb.so hpbmodule.o reg_tet.o -L${PYTHON_LIBDIR} -l${PYTHON_LIB_NAME} -lgfortran
else
  g++ -shared -Wl,-soname,hpb.so -o hpb.so hpbmodule.o reg_tet.o -L${PYTHON_LIBDIR} -l${PYTHON_LIB_NAME} -lgfortran
fi

# Move built .so file to destination
cp hpb.so ../

cd -

# Final installation
$PYTHON setup.py build_ext --force
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
