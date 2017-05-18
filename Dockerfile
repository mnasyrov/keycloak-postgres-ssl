FROM jboss/keycloak:latest

ADD changeDatabase.xsl /opt/jboss/keycloak/
RUN java -jar /usr/share/java/saxon.jar \
        -xsl:/opt/jboss/keycloak/changeDatabase.xsl \
        -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml \
        -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml
RUN java -jar /usr/share/java/saxon.jar \
        -xsl:/opt/jboss/keycloak/changeDatabase.xsl \
        -s:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml \
        -o:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml
RUN rm /opt/jboss/keycloak/changeDatabase.xsl

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main; \
        cd /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main; \
        curl -O https://jdbc.postgresql.org/download/postgresql-42.1.1.jar

ADD module.xml /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main/
