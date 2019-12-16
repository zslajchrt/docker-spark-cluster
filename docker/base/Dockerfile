FROM oracle/graalvm-ce:latest
LABEL author="Nathaniel Vala" email="nathanielvala@hotmail.com"
LABEL version="0.2"

ENV DAEMON_RUN=true
ENV SPARK_VERSION=2.3.4
ENV HADOOP_VERSION=2.7
ENV SCALA_VERSION=2.11.8
ENV SCALA_HOME=/usr/share/scala
ENV SPARK_HOME=/spark


RUN yum -y update
RUN yum -y install yum-utils
RUN yum -y groupinstall development
#RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm

RUN yum -y install python3
#RUN yum -y install python36u-pip

#RUN apt-get update && apt-get install -y curl vim wget software-properties-common ssh net-tools ca-certificates jq
RUN yum -y install curl vim wget software-properties-common ssh net-tools ca-certificates jq
#RUN yum -y install wget

#     apt update && apt -y upgrade \
#     apt install -y wget ca-certificates && \
#     apt install -y curl bash jq && \
RUN cd "/tmp" && \
#    wget --no-verbose "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
#    tar xzf "scala-${SCALA_VERSION}.tgz" && \
#    mkdir "${SCALA_HOME}" && \
#    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
#    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
#    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
#    rm -rf "/tmp/"*
    wget --no-verbose "http://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.rpm" && \
    yum -y install scala-${SCALA_VERSION}.rpm

# RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
#     apk add --no-cache bash curl jq && \
#     cd "/tmp" && \
#     wget --no-verbose "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
#     tar xzf "scala-${SCALA_VERSION}.tgz" && \
#     mkdir "${SCALA_HOME}" && \
#     rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
#     mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
#     ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
#     apk del .build-dependencies && \
#     rm -rf "/tmp/"*


# Add Dependencies for PySpark
RUN yum install -y python3 python3-pip python3-numpy python3-matplotlib python3-scipy python3-pandas python3-simpy
#RUN update-alternatives --install "/usr/bin/python" "python" "$(which python3)" 1

RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum install -y sbt

#Scala instalation
#RUN export PATH="/usr/local/sbt/bin:$PATH" &&  apt update && apt install ca-certificates wget tar && mkdir -p "/usr/local/sbt" && wget -qO - --no-check-certificate "https://github.com/sbt/sbt/releases/download/v1.2.8/sbt-1.2.8.tgz" | tar xz -C /usr/local/sbt --strip-components=1 && sbt sbtVersion

RUN wget --no-verbose http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark \
      && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

RUN yum install -y hostname
RUN yum install -y telnet

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

RUN gu install r
RUN /opt/graalvm-ce-java8-19.3.0/jre/languages/R/bin/configure_fastr
RUN yum install -y libxml2-devel
RUN R -e "install.packages(c('broom', 'sparklyr'))"

RUN mkdir /root/spark
WORKDIR /root/spark
RUN ln -s /spark spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

RUN git clone https://github.com/zslajchrt/sparklyr.git
WORKDIR sparklyr
RUN git checkout fastR_integration
RUN R CMD INSTALL .
RUN R -f ./build.R
RUN R CMD INSTALL .
