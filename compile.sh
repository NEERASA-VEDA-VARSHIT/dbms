#!/bin/bash
echo "Compiling Event Management JDBC Project..."
javac -cp "lib/*" -d bin src/database/*.java src/dao/*.java src/model/*.java src/*.java
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo ""
    echo "To run the application, use: java -cp 'bin:lib/*' EventManager"
else
    echo "Compilation failed!"
fi 