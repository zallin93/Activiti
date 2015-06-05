#!/bin/sh
echo "Dropping DB schema"
mysql -u activiti -pactiviti -e "DROP SCHEMA activiti-compatibility"

echo "Creating DB schema"
mysql -u activiti -pactiviti -e "CREATE SCHEMA activiti-compatibility DEFAULT CHARACTER SET utf8 COLLATE utf8_bin"

echo "Building dependencies" 
cd ..
mvn clean install -DskipTests

cd modules/activiti5-engine/
mvn clean install -DskipTests
cd ../..

cd modules/activiti5-compatibility/
mvn clean install -DskipTests
cd ../..

echo "Building test data generators"
cd modules/activiti5-compatibility-testdata
mvn clean package shade:shade

echo "Generating test data"
cd target
java -jar activiti5-compatibility-testdata.jar

echo "Running tests"
cd ../../activiti5-compatibility-test
mvn clean test
