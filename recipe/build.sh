cd prody/proteins/hpbmodule/
gfortran -O3 -fPIC -c reg_tet.f
variable=$(python -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())')
c++ -O3 -g -fPIC -c hpbmodule.cpp -o hpbmodule.o -I/$variable
c++ -shared -Wl,-soname,hpb.so -o hpb.so hpbmodule.o reg_tet.o -lgfortran
cp hpb.so ../

cd -
$PYTHON setup.py build_ext --inplace --force
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
