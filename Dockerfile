FROM ubuntu

ENV UID         99
ENV GID         100
ENV HOME        /home/minecraft

ENV EXECDIR     $HOME/server
ENV JARFILE     minecraft_server
ENV JAVAPARAMS  ""
ENV SVPARAMS    "nogui"

ENV JAVA_HEAP_MIN 1024m
ENV JAVA_HEAP_MAX 1024m

RUN set -x \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
        openjdk-8-jre \
        curl wget \
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

RUN useradd --uid $UID --gid $GID -m minecraft
RUN mkdir -p $EXECDIR \
 && chown $UID:$GID -R $HOME

VOLUME $EXECDIR
EXPOSE 25565/tcp

USER minecraft
WORKDIR $EXECDIR
ENTRYPOINT java \
           $JAVAPARAMS \
           -Xms${JAVA_HEAP_MIN} \
           -Xmx${JAVA_HEAP_MAX} \
           -jar ${JARFILE}.jar \
           $SVPARAMS
