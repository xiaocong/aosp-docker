FROM        ubuntu:14.04
MAINTAINER  Xiaocong He <xiaocong@gmail.com>

# update apt sources
RUN         apt-get update

# install
RUN         apt-get install -y \
                openjdk-7-jdk \
                openssh-server \
                git \
                curl

# install sshd
RUN         mkdir /var/run/sshd
RUN         echo 'root:!QAZ2wsx3edc' | chpasswd
RUN         sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN         sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN         echo "export VISIBLE=now" >> /etc/profile

# config java
#RUN        update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
#RUN        update-alternatives --set javac /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/javac

#RUN         curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
#RUN         chmod +x /usr/local/bin/repo

#WORKDIR     /working
#RUN         repo init -u https://android.googlesource.com/platform/manifest
#RUN         repo sync
#VOLUME      ["/data"]

EXPOSE      22
CMD         ["/usr/sbin/sshd", "-D"]
