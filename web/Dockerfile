FROM ubuntu:22.04

# Install core components

# Import Environment
ENV PATH_TO_MISP=/var/www/MISP
ENV WWW_USER=www-data
ENV SUDO_WWW='sudo -H -u www-data'
ENV CAKE="/var/www/MISP/app/Console/cake"
ENV MYSQL_HOST='misp_db'
ENV MYSQL_DATABASE='misp'
ENV MYSQL_USER='misp'
ENV MYSQL_PASSWORD='misp'
ENV MYSQL_ROOT_PASSWORD='misp'
ENV MISP_ADMIN_EMAIL='admin@admin.test'
ENV MISP_ADMIN_PASSPHRASE='misp'
ENV MISP_BASEURL=
ENV POSTFIX_RELAY_HOST='relay.fqdn'
ENV TIMEZONE='America/Sao_Paulo'
ENV LANG='en_US.UTF-8'
ENV MISP_USER="${MISP_USER:-misp}"
ENV MISP_PASSWORD="${MISP_PASSWORD:-$(openssl rand -hex 32)}"
RUN echo "MISP_PASSWORD=$MISP_PASSWORD" | tee -a template.env
ENV SUDO_CMD="sudo -H -u ${MISP_USER}"
#ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -qy && apt-get upgrade && apt-get autoremove -y && apt-get clean && \
    apt-get install -qy software-properties-common && \
    apt-get install -qy postfix rsyslog && \
    apt-get install -qy mysql-client curl gcc git gnupg-agent \
    make cmake openssl redis-server sudo vim zip locales wget iproute2 supervisor cron libfuzzy-dev librdkafka-dev libffi-dev libbrotli1 librdkafka1 libfuzzy2 libsimdjson-dev ssdeep clamav clamav-daemon

# USER misp
RUN echo "misp ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN MISP_USER=$USER
RUN sudo useradd -s /bin/bash -m -G adm,cdrom,sudo,dip,plugdev,www-data,staff,systemd-timesync,crontab $MISP_USER
RUN echo $MISP_USER:$MISP_PASSWORD | sudo chpasswd > password.txt
RUN echo "User $MISP_USER added, password is: $MISP_PASSWORD" >> password.txt
# 
ADD run.sh /run.sh 
RUN chmod +x /run.sh 
#
ADD wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh
RUN ln -s /usr/local/bin/wait-for-it.sh /wait-for-it.sh
#
ADD files/first-start-misp.sh /tmp/ 
RUN chmod +x /tmp/first-start-misp.sh
#
ADD files/misp-modules.sh /tmp/
RUN chmod +x /tmp/misp-modules.sh
#
ADD files/misp.cron.d /etc/cron.d/misp
ADD files/entrypoint_cron.sh /
RUN chmod +x /entrypoint_cron.sh 
#
ADD files/misp-workers.conf /etc/supervisor/conf.d/misp-workers.conf
ADD files/supervisord_build.conf /etc/supervisor/conf.d/supervisord.conf
#
RUN apt install -y python3.10-venv
#
# Configure TIMEZONE
ENV TIMEZONE=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone
RUN apt install tzdata -qy
#
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
#
# Install script
COPY --chown=misp:misp INSTALL.sh /tmp/
RUN chmod +x /tmp/INSTALL.sh
#USER $MISP_USER
USER misp 
RUN bash /tmp/INSTALL.sh
#
USER root
ADD files/misp-modules.sh /tmp/ 
RUN chmod +x /tmp/misp-modules.sh 
RUN bash /tmp/misp-modules.sh
#
RUN pip3 list -o | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print}' | cut -d' ' -f1 | xargs -n1 pip3 install -U ; exit 0 #Hack error code
#
# Add run script
ADD run.sh /run.sh
ADD wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN sudo chmod 0755 /run.sh && touch /.firstboot.tmp
#
# Make a backup of /var/www/MISP to restore it to the local moint point at first boot
WORKDIR /var/www/MISP
RUN sudo tar czpf /root/MISP.tgz .
#
VOLUME /var/www/MISP
EXPOSE 80
ENTRYPOINT ["/run.sh"]
