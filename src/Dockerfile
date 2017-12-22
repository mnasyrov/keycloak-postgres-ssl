FROM jboss/keycloak:3.2.1.Final

ENV JDBC_POSTGRES_VERSION 9.3-1102-jdbc3

USER root
RUN yum -y install ca-certificates openssl && yum clean all


USER jboss

ADD changeDatabase.xsl /opt/jboss/keycloak/
RUN java -jar /usr/share/java/saxon.jar \
        -xsl:/opt/jboss/keycloak/changeDatabase.xsl \
        -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml \
        -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml; \
    java -jar /usr/share/java/saxon.jar \
        -xsl:/opt/jboss/keycloak/changeDatabase.xsl \
        -s:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml \
        -o:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml; \
    rm /opt/jboss/keycloak/changeDatabase.xsl;

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main; \
    cd /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main; \
    curl -L -o postgres-jdbc.jar http://central.maven.org/maven2/org/postgresql/postgresql/$JDBC_POSTGRES_VERSION/postgresql-$JDBC_POSTGRES_VERSION.jar

ADD module.xml /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main/
