FROM spark-base-graalvm:latest

COPY spark-submit.sh /

ENV SPARK_MASTER_URL="spark://spark-master:7077"
ENV SPARK_SUBMIT_ARGS=""
ENV SPARK_APPLICATION_ARGS ""
#ENV SPARK_APPLICATION_JAR_LOCATION /opt/spark-apps/myjar.jar
#ENV SPARK_APPLICATION_MAIN_CLASS my.main.Application


#CMD ["/bin/bash", "/spark-submit.sh"]

RUN yum -y install openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:admin123' | chpasswd
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


RUN ssh-keygen -b 4096 -f /etc/ssh/ssh_host_rsa_key -t rsa -N ""
RUN ssh-keygen -b 1024 -f /etc/ssh/ssh_host_dsa_key -t dsa -N ""
RUN ssh-keygen -b 521 -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N ""
RUN ssh-keygen -b 4096 -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ""

COPY config-template.yml /root/spark/sparklyr/inst/conf/config-template.yml

RUN git config --global user.email "zslajchrt@gmail.com"
RUN git config --global user.name "Zbynek Slajchrt"

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
