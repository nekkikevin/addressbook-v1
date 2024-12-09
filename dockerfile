
FROM tomcat:8.5.72-jdk8-openjdk-buster

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_VERSION 3.8.4

RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

//set the workking directory
Workdir /app    

//copy the .pom ./src and ./settings.xml files from local host(ec2 to tomcat server)
copy ./pom.xml  ./pom.xml
copy ./src      ./src
copy ./settings.xml  ./settings.xml

//run the mvn package which also runs compile, build and other stages
Run mvn package
Run mvn -U deploy -s settings.xml

//this commmand will be run inside the container where the .war will be copied from /app/target/ --> /usr/local/tomcat/webapps
Run cp /app/target/addressbook.war /usr/local/tomcat/webapps

Expose 8080

CMD ["catalina.sh", "run"]
