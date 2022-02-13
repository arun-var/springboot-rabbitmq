FROM maven:3.8.4-openjdk-8
COPY . /usr/src/app 
WORKDIR /usr/src/app
RUN mvn -s settings.xml clean install jib:dockerBuild