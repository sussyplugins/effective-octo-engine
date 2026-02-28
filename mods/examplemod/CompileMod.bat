@echo off
cd /d %~dp0

:: metadata defaults (override by setting environment variables)
set "NAME=Example Mod"
set "VERSION=1.0"
set "AUTHOR=Your Name"
set "MODID=examplemod"
set "DESCRIPTION=An example mod for AstroClient."
set "MAINCLASS=com.example.ExampleMod"

:: write amt file
echo name=%NAME%>src\main\resources\example.amt
echo version=%VERSION%>>src\main\resources\example.amt
echo author=%AUTHOR%>>src\main\resources\example.amt
echo modid=%MODID%>>src\main\resources\example.amt
echo description=%DESCRIPTION%>>src\main\resources\example.amt
echo mainClass=%MAINCLASS%>>src\main\resources\example.amt
echo Generated example.amt
type src\main\resources\example.amt

echo Building mod...
if exist gradlew.bat (
  call gradlew.bat assembleMod
) else (
  gradle assembleMod || (
    echo Gradle not found. Install Gradle or include a gradle wrapper.
    exit /b 1
  )
)

set "JARFILE=build\libs\%MODID%.jar"
if exist "%JARFILE%" (
  copy "%JARFILE%" "build\libs\logic.ams"
  echo Copied %JARFILE% to build\libs\logic.ams
)
echo Done - output zip is build\libs\%MODID%.zip
