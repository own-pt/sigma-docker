FROM java:8

ENV SIGMA_HOME=/sigma

ENV MAVEN_OPTS="-Xmx2024m"

EXPOSE 8080

RUN apt-get update \
    && apt-get install -y --no-install-recommends git ant maven  \
               graphviz swi-prolog-nox build-essential curl wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /sigma && cd /sigma \
    && git clone https://github.com/ontologyportal/sumo.git \
    && git clone https://github.com/ontologyportal/sigmakee.git \
    && ln -s sumo KBs


RUN cd /sigma && curl http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_1.8/E.tgz | tar xzf - \
    && cd /sigma/E \
    && ./configure && make

RUN cd /sigma/sigmakee \
    && mvn -f pom-old.xml -DskipTests clean install

ADD config_docker.xml /sigma/KBs/config.xml

WORKDIR /sigma
CMD cd /sigma/sigmakee && mvn -f pom-old.xml -DskipTests tomcat7:run
