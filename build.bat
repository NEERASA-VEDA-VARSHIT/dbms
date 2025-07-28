@echo off
echo Building Event Management JDBC System...

REM Create target directory
if not exist "target" mkdir target
if not exist "target\classes" mkdir target\classes

REM Compile Java files
echo Compiling Java source files...
javac -cp "lib/*" -d target/classes src/database/*.java src/dao/*.java src/model/*.java src/*.java

if %ERRORLEVEL% NEQ 0 (
    echo Compilation failed!
    pause
    exit /b 1
)

REM Copy SQL resources
echo Copying SQL resources...
if not exist "target\classes\sql" mkdir target\classes\sql
copy sql\schema.sql target\classes\sql\

REM Create JAR file
echo Creating JAR file...
jar cfm target/event-management-jdbc-1.0.0.jar manifest.txt -C target/classes .

REM Copy dependencies to lib directory in target
if not exist "target\lib" mkdir target\lib
copy lib\* target\lib\

echo Build completed successfully!
echo.
echo JAR file created: target/event-management-jdbc-1.0.0.jar
echo.
echo To run the application:
echo java -jar target/event-management-jdbc-1.0.0.jar
echo.
pause 