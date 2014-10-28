FROM    ubuntu:14.04
MAINTAINER Xiaocong He <xiaocong@gmail.com>

# update apt sources
RUN     apt-get update

# install jdk7
RUN     apt-get install -y openjdk-7-jdk
# install sshd
RUN     apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# config java
#RUN     update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
#RUN     update-alternatives --set javac /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/javac

RUN     apt-get install -y bison g++-multilib git gperf libxml2-utils
RUN     curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
RUN     chmod +x /usr/local/bin/repo
RUN     mkdir /working
RUN     cd /working && repo init -u https://android.googlesource.com/platform/manifest && repo sync

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

