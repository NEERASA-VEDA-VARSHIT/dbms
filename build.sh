#!/bin/bash
echo "Building Event Management JDBC System..."

# Create target directory
mkdir -p target/classes

# Compile Java files
echo "Compiling Java source files..."
javac -cp "lib/*" -d target/classes src/database/*.java src/dao/*.java src/model/*.java src/*.java

if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

# Copy SQL resources
echo "Copying SQL resources..."
mkdir -p target/classes/sql
cp sql/schema.sql target/classes/sql/

# Create JAR file
echo "Creating JAR file..."
jar cfm target/event-management-jdbc-1.0.0.jar manifest.txt -C target/classes .

# Copy dependencies to lib directory in target
mkdir -p target/lib
cp lib/* target/lib/

echo "Build completed successfully!"
echo ""
echo "JAR file created: target/event-management-jdbc-1.0.0.jar"
echo ""
echo "To run the application:"
echo "java -jar target/event-management-jdbc-1.0.0.jar"
echo "" 