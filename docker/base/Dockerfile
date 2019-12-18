FROM fastr:latest
LABEL author="Nathaniel Vala" email="nathanielvala@hotmail.com"
LABEL version="0.2"

ENV DAEMON_RUN=true
ENV SPARK_VERSION=2.3.4
ENV HADOOP_VERSION=2.7
ENV SCALA_VERSION=2.11.8
ENV SCALA_HOME=/usr/share/scala
ENV SPARK_HOME=/spark

RUN cd "/tmp" && \
    wget --no-verbose "http://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.rpm" && \
    yum -y install scala-${SCALA_VERSION}.rpm

# Add Dependencies for PySpark
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum install -y sbt

RUN wget --no-verbose http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark \
      && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

RUN yum install -y hostname
RUN yum install -y telnet

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

RUN yum install -y libxml2-devel

RUN mkdir /root/spark
WORKDIR /root/spark
RUN ln -s /spark spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

COPY library /library

RUN echo "Cloning FastR Sparklyr ..."
RUN git clone https://github.com/zslajchrt/sparklyr.git
WORKDIR sparklyr
RUN git checkout fastR_integration

RUN R CMD INSTALL --library=/library .
ENV R_LIBS=/library
RUN R -f ./build.R
RUN R CMD INSTALL --library=/library .

RUN echo "Configuring root's profile"
COPY root/.bash_profile /root

RUN yum install -y iputils

# This can be removed after fastr:latest is rebuilt
ENV LD_LIBRARY_PATH=/graal/sulong/mxbuild/linux-amd64/SULONG_HOME/native/lib/

ENV R_VERSION=3.6.1

WORKDIR /gnur
RUN wget https://cran.rstudio.com/src/base/R-3/R-${R_VERSION}.tar.gz && \
	tar xf R-${R_VERSION}.tar.gz
RUN	cd R-${R_VERSION} && \
	 ./configure --with-x=no --with-aqua=no --enable-memory-profiling > gnur_configure.log 2>&1
RUN cd R-${R_VERSION} && make -j > gnur_make.log 2>&1
RUN mkdir /library-gnur && \
	R_LIBS=/library-gnur R-${R_VERSION}/bin/R -e "install.packages('broom', repos='https://cloud.r-project.org')"

WORKDIR /
