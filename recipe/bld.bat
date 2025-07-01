"%PYTHON%" setup.py build_ext --inplace --force
if errorlevel 1 exit 1

"%PYTHON%" -m pip install -Ue .
if errorlevel 1 exit 1

@REM everything below this is an addition check
@REM @echo on
@REM setlocal ENABLEEXTENSIONS
@REM set FC=%FORTRAN%

@REM REM Compile Fortran
@REM %FC% /O2 /c reg_tet.f
@REM if errorlevel 1 exit 1

@REM REM Get Python include path
@REM for /f %%i in ('"%PYTHON%" -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())"') do set PYTHON_INC=%%i
@REM for /f %%i in ('"%PYTHON%" -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR'))"') do set PYTHON_LIBDIR=%%i
@REM for /f %%i in ('"%PYTHON%" -c "import sysconfig; print(sysconfig.get_config_var('LDLIBRARY'))"') do set PYTHON_LIB=%%i

@REM REM Compile C++ code
@REM cl /c /O2 /EHsc /MD /I %PYTHON_INC% hpbmodule.cpp
@REM if errorlevel 1 exit 1

@REM REM Link to make DLL
@REM link /DLL /OUT:hpb.pyd hpbmodule.obj reg_tet.obj /LIBPATH:%PYTHON_LIBDIR% %PYTHON_LIB% gfortran.lib
@REM if errorlevel 1 exit 1

@REM REM Move DLL to correct location
@REM copy hpb.pyd ..

@REM REM Final install
@REM "%PYTHON%" setup.py install --single-version-externally-managed --record=record.txt
@REM if errorlevel 1 exit 1
