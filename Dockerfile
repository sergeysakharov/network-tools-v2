FROM ubuntu:latest

#RUN export TZ=Europe/Paris
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



ENV SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
    SIAB_PORT=4200 \
    SIAB_ADDUSER=true \
    SIAB_USER=user \
    SIAB_USERID=1000 \
    SIAB_GROUP=guest \
    SIAB_GROUPID=1000 \
    SIAB_PASSWORD=P@ssw0rd \
    SIAB_SHELL=/bin/bash \
    SIAB_HOME=/home/guest \
    SIAB_SUDO=false \
    SIAB_SSL=false \
    SIAB_SERVICE=/:LOGIN \
    SIAB_PKGS=none \
    SIAB_SCRIPT=none

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="Europe/Kyiv" apt-get install -y tzdata

RUN apt-get update && apt-get install -y awscli vim mc openvpn unzip wget python3.9 openssl curl openssh-client sudo shellinabox iputils-ping dnsutils traceroute telnet postgresql-client net-tools tcpdump mysql-client nmap ssh sudo iproute2 && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    ln -sf '/etc/shellinabox/options-enabled/00+Black on White.css' \
      /etc/shellinabox/options-enabled/00+Black-on-White.css && \
    ln -sf '/etc/shellinabox/options-enabled/00_White On Black.css' \
      /etc/shellinabox/options-enabled/00_White-On-Black.css && \
    ln -sf '/etc/shellinabox/options-enabled/01+Color Terminal.css' \
      /etc/shellinabox/options-enabled/01+Color-Terminal.css

RUN wget -O speedtest-cli  https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
RUN chmod +x speedtest-cli
EXPOSE 4200

# Setup the default user.
#RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
#USER ubuntu
#WORKDIR /home/ubuntu
#RUN useradd -ms /bin/bash user
#RUN echo 'user:P@ssw0rd' | chpasswd
#USER user
#WORKDIR /home/user

VOLUME /etc/shellinabox /var/log/supervisor /home

ADD assets/entrypoint.sh /usr/local/sbin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["shellinabox"]
