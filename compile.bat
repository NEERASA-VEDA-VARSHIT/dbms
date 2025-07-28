@echo off
echo Compiling Event Management JDBC Project...
javac -cp "lib/*" -d bin src/database/*.java src/dao/*.java src/model/*.java src/*.java
if %ERRORLEVEL% EQU 0 (
    echo Compilation successful!
    echo.
    echo To run the application, use: java -cp "bin;lib/*" EventManager
) else (
    echo Compilation failed!
)
pause 